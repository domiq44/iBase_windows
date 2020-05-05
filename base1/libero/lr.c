/*===========================================================================*
 *                                                                           *
 *  lr.c - Main Libero program                                               *
 *                                                                           *
 *  Copyright (c) 1991-2009 iMatix Corporation                               *
 *                                                                           *
 *  ------------------ GPL Licensed Source Code ------------------           *
 *  iMatix makes this software available under the GNU General               *
 *  Public License (GPL) license for open source projects.  For              *
 *  details of the GPL license please see www.gnu.org or read the            *
 *  file license.gpl provided in this package.                               *
 *                                                                           *
 *  This program is free software; you can redistribute it and/or            *
 *  modify it under the terms of the GNU General Public License as           *
 *  published by the Free Software Foundation; either version 2 of           *
 *  the License, or (at your option) any later version.                      *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
 *  GNU General Public License for more details.                             *
 *                                                                           *
 *  You should have received a copy of the GNU General Public                *
 *  License along with this program in the file 'license.gpl'; if            *
 *  not, write to the Free Software Foundation, Inc., 59 Temple              *
 *  Place - Suite 330, Boston, MA 02111-1307, USA.                           *
 *                                                                           *
 *  You can also license this software under iMatix's General Terms          *
 *  of Business (GTB) for commercial projects.  If you have not              *
 *  explicitly licensed this software under the iMatix GTB you may           *
 *  only use it under the terms of the GNU General Public License.           *
 *                                                                           *
 *  For more information, send an email to info@imatix.com.                  *
 *  --------------------------------------------------------------           *
 *===========================================================================*/

#include "prelude.h"                    /*  Public definitions               */
#include "lrpriv.h"                     /*  Private definitions              */
#include "version.h"                    /*  Version definitions              */


/*  Function prototypes                                                      */

static void process_file        (char *filename);
static void  handle_signal       (int Signal);
static void  ignore_signal       (int Signal);
static void  print_help          (void);

#define ARGN_IS(a,b,c)      (   tolower (argv [argn][1]) == (a)              \
                             && tolower (argv [argn][2]) == (b)              \
                             && tolower (argv [argn][3]) == (c))

/*  Options:  1. Hard-coded defaults
 *            2. -initial on command line if any
 *            3. contents of ini file
 *            -. then for each file:
 *                -. save options)
 *                4. options at start of file
 *                5. options on command line
 *                -. process file
 *                -. restore options)
 *            6. options on command line
 */

static char
    command_options [LINE_MAX + 1];     /*  Command line options             */

int
main (int argc, char *argv [])
{
    int argn,                           /*  Index for command arguments      */
        count;                          /*  Number of files processed        */
    char
        *MessageFile;                   /*  Message file name                */

    signal (SIGINT,  handle_signal);    /*  Trap break signals               */
    signal (SIGTERM, handle_signal);
    signal (SIGSEGV, handle_signal);

    lr_reset_options ();                /*  Set default options              */
    lr_parse_option_line ("-author='Your Name'");
    lr_parse_option_line ("-check");
    lr_parse_option_line ("-generate");
    lr_parse_option_line ("-stubs");
    lr_parse_option_line ("-sort");
    lr_parse_option_line ("-noquiet");
    lr_parse_option_line ("-initial=lr.ini");
    lr_parse_option_line ("-schema=lrschema.c");
    lr_parse_option_line ("-defaults=defaults");
    lr_parse_option_line ("-style=plain");
#if (defined (__OS2__))
    /*  In OS/2 DPATH fits better into the scheme of things -- EDM 97/01/01  */
    /*  This should be abstracted somehow into prelude.h -- PH 02/05/11      */
    lr_parse_option_line ("-path='DPATH'");
#else
    lr_parse_option_line ("-path='PATH'");
#endif

    /*  Collect options from command line                                    */
    strclr (command_options);
    for (argn = 1; argn < argc; argn++)
      {
        if (argv [argn][0] == '-')
          {
            /*  -initial, -help, -path, -dpath, -version processed at once   */
            if (ARGN_IS ('i', 'n', 'i')
            ||  ARGN_IS ('h', 'e', 'l')
            ||  ARGN_IS ('p', 'a', 't')
            ||  ARGN_IS ('v', 'e', 'r')
            ||  ARGN_IS ('d', 'p', 'a'))
                lr_parse_option (argv [argn]);
            else
              {
                strcat (command_options, argv [argn]);
                strcat (command_options, " ");
              }
            strclr (argv [argn]);       /*  Remove argument from list        */
          }
      }
    count = 0;
    lr_parse_option_file (OPT_INITIAL.value);
    MessageFile = FileWhere ('r', OPT_PATH.value, MESSAGE_FILE, NULL);
    if (MessageFile == NULL)
      {
        printf ("lr E: cannot find message file '%s' on '%s' path\n",
                 MESSAGE_FILE, OPT_PATH.value);
        exit (EXIT_FAILURE);
      }
    OpenMessageFile (MessageFile);
    if (argc == 1 || OPT_HELP.flags & OPT_ON)
      {
        puts (COPYRIGHT);
        print_help ();
        exit (EXIT_SUCCESS);
      }
    if (OPT_VERSION.flags & OPT_ON)
      {
        printf ("%s\n", PRODUCT);
        printf ("%s\n", BUILDMODEL);
        printf ("%s\n", COPYRIGHT);
#if defined (CCOPTS)
        printf ("Compiler: " CCOPTS "\n");
#endif
        printf ("Revision: " SVN_REVISION "\n");
        exit (EXIT_SUCCESS);
      }
    for (argn = 1; argn < argc; argn++)
        if (argv [argn][0])
          {
            process_file (argv [argn]);
            count++;
          }
    if (count == 0)
      {
        lr_parse_option_line (command_options);
        lr_show_options      ("command");
      }
    CloseMessageFile ();
    return (EXIT_SUCCESS);
}


static void
process_file (char *filename)
{
    lrstat stats;                       /*  Dialog statistics                */
    lrnode listhead;                    /*  Dialog list header node          */
    static Bool
        first_file = TRUE;              /*  First time through function?     */
    static char
        trace_file [LR_FILENAMEMAX+1],  /*  Trace file with extension        */
        localname  [LR_FILENAMEMAX+1],  /*  Dialog file with extension       */
        fullname   [LR_FILENAMEMAX+1];  /*  Dialog file with ext. & path     */
    char
        *located;                       /*  Filename on dpath                */

    if (DefaultExtension (localname, filename, "l") == -1)
      {
        PrintMessage (MSG_INVALID_FILENAME, filename);
        exit (EXIT_FAILURE);
      }

    /*  Look for dialog file on -dpath or -path unless fully specified       */
    if (strchr (localname, PATHEND))
        strcpy (fullname, localname);
    else
      {
        located = FileWhere ('r', OPT_DPATH.value?
                                  OPT_DPATH.value: OPT_PATH.value,
                                  localname, NULL);
        if (located)
            strcpy (fullname, located);
        else
            strcpy (fullname, localname);
      }

    if (!FileExists (fullname))
      {
        PrintMessage (MSG_DIALOG_FILE_NF, localname);
        exit (EXIT_FAILURE);
      }

    lr_push_options      ();            /*  Save current options             */
    lr_parse_option_file (fullname);    /*  Then get options from .l file    */
    lr_parse_option_line (command_options);   /*  and then command line      */
    lr_show_options      (fullname);

    if (first_file & !OPT_QUIET.flags & OPT_ON)
        puts (COPYRIGHT);
    if (!OPT_QUIET.flags & OPT_ON)
        PrintMessage (MSG_PROCESSING, fullname);
    first_file = FALSE;

    if (OPT_TRACE.flags & OPT_ON)       /*  Create trace file if wanted      */
      {
        FixedExtension (trace_file, filename, "lst");
        SetTraceFile (trace_file, 'w');
        if (!TraceFile)                 /*  If error on file, halt           */
          {
            PrintMessage (MSG_TRACE_FILE_ERROR, trace_file);
            exit (EXIT_FAILURE);
          }
        EnableTrace ();                 /*  Else enable tracing to file      */
      }
    Trace ("Pass 1: loading dialog");
    if (lr_load_dialog (&listhead, &stats, localname) == -1)
        exit (EXIT_FAILURE);
    else
    if (OPT_PRETTY.flags & OPT_ON)
        exit (EXIT_SUCCESS);

    Trace ("Pass 2: sorting dialog");
    if (lr_sort_dialog (&listhead, &stats) == -1)
        exit (EXIT_FAILURE);

    if (stats.states && stats.events && stats.modules)
      {
        /*  Generate code from -schema if specified                          */
        if (OPT_SCHEMA.value)
          {
            Trace ("Pass 3: generating code");
            if (lr_generate_code (&listhead, &stats, localname) == -1)
                exit (EXIT_FAILURE);
          }
      }
    else
        PrintMessage (MSG_DIALOG_EMPTY, fullname);

    Trace ("Pass 4: cleaning-up");
    lr_dump_dialog (&listhead, &stats); /*  Dump tables if wanted            */
    lr_free_memory (&listhead, &stats); /*  And free table memory            */
    lr_pop_options ();                  /*  Restore previous options         */

    if (TraceFile)                      /*  Close trace file if wanted       */
      {
        FileClose (TraceFile);
        TraceFile = NULL;
      }
}


static void
handle_signal (int the_signal)
{
    ASSERT (the_signal != 0);

    signal (SIGINT,  ignore_signal);    /*  Ignore further break signals     */
    signal (SIGTERM, ignore_signal);
    signal (SIGSEGV, ignore_signal);

    OPT_QUIET.flags = OPT_OFF;
    if (the_signal == SIGINT)
        PrintMessage (MSG_INTERRUPTED);
    else
    if (the_signal == SIGTERM)
        PrintMessage (MSG_CANCELLED);
    else
    if (the_signal == SIGSEGV)
        PrintMessage (MSG_SEGMENT_ERROR);

    exit (EXIT_SUCCESS);
}

static void
ignore_signal (int the_signal)
{
    ASSERT (the_signal != 0);
}


static void 
print_help (void)
{
    char *message;

    message = MessageText (MSG_HELP);
    while (strneq (message, "."))
      {
        puts (message);
        message = MessageText (-1);
      }
}
