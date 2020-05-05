!============================================================================*
!                                                                            *
!   lrschema.rex - Schema for Rexx programming                               *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
!                                                                            *
!   Generates a script written in the REXX language.                         *
!                                                                            *
!   Usage:      Add this line to the start of your dialog file:              *
!               -schema=lrschema.rex                                         *
!                                                                            *
!               Put your module data and code in '<script>.mod'.  When       *
!               you run lr, it makes a REXX program combining your modules   *
!               with the generated code from this schema.  To make a change  *
!               and rebuild 'myscript', run these commands:                  *
!                                                                            *
!               edit myscript.l     (make changes to dialog)                 *
!               edit myscript.mod   (modify module code)                     *
!               lr myscript         (add stubs if needed, build script)      *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:stack_max=nnn - size of subdialog stack (20)            *
!               -opt:template=xxxx - template file (template.ksh)            *
!                                                                            *
!   ------------------ GPL Licensed Source Code ------------------           *
!   iMatix makes this software available under the GNU General               *
!   Public License (GPL) license for open source projects.  For              *
!   details of the GPL license please see www.gnu.org or read the            *
!   file license.gpl provided in this package.                               *
!                                                                            *
!   This program is free software; you can redistribute it and/or            *
!   modify it under the terms of the GNU General Public License as           *
!   published by the Free Software Foundation; either version 2 of           *
!   the License, or (at your option) any later version.                      *
!                                                                            *
!   This program is distributed in the hope that it will be useful,          *
!   but WITHOUT ANY WARRANTY; without even the implied warranty of           *
!   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
!   GNU General Public License for more details.                             *
!                                                                            *
!   You should have received a copy of the GNU General Public                *
!   License along with this program in the file 'license.gpl'; if            *
!   not, write to the Free Software Foundation, Inc., 59 Temple              *
!   Place - Suite 330, Boston, MA 02111-1307, USA.                           *
!                                                                            *
!   You can also license this software under iMatix's General Terms          *
!   of Business (GTB) for commercial projects.  If you have not              *
!   explicitly licensed this software under the iMatix GTB you may           *
!   only use it under the terms of the GNU General Public License.           *
!                                                                            *
!   For more information, send an email to info@imatix.com.                  *
!   --------------------------------------------------------------           *
!============================================================================*

:if $events > 254
:   echo "lr E: dialog is too complex - more than 254 events"
:   exit 1
:endif
:if $modules > 254
:   echo "lr E: dialog is too complex - more than 254 modules"
:   exit 1
:endif

!   You can use the template file to include project-specific code in the
!   generated code at various points.  This is a (better) alternative to
!   changing the schema in order to add your own project code.
!
!   The template file should contain these sections (each starts with a
!   keyword on a line, and ends with <END> on a line).  These sections may
!   be included in a newly-generated program (keywords are case-sensitive):
!
!   <HEADER>                    - program header comment
!   <DATA>                      - data definitions
!   <Initialise-The-Program>    - in Initialise-The-Program
!   <Get-External-Event>        - in Get-External-Event
!   <Terminate-The-Program>     - in Terminate-The-Program
!
!   <Any-Dialog-Module>         - any dialog module
:declare string $template = "template.rex"

:if not exist $source.mod
:output $source.mod
:echo "lr I: creating skeleton module file $source.mod..."
/*-----------------------------------------------------------------------------
 *
 *  $source.mod - module file for $dialog.l
<help>
 *
 *  $source     Summary of script file
 *
 *  Written:    $date     $author
 *  Revised:    $date
 *
:include optional $template "<HEADER>" "<END>"
<end>
 *  Skeleton generated by LIBERO $version on $fulldate, $time.
 *---------------------------------------------------------------------------*/

/*  Put definitions here that will go at the start of the script             */
<data>
:include optional $template "<DATA>" "<END>"
<end>

<code>

/*************************   INITIALISE THE PROGRAM   ************************/

$"initialise_the_program":
    $"the_next_event" = $"ok_event"
:include optional $template "<Initialise-The-Program>" "<END>"
    Return


/***************************   GET EXTERNAL EVENT   **************************/

$"get_external_event":
:include optional $template "<Get-External-Event>" "<END>"
    Return


/*************************   TERMINATE THE PROGRAM    ************************/

$"terminate_the_program":
    $"the_next_event" = $"terminate_event"
:include optional $template "<Terminate-The-Program>" "<END>"
    Return

:close
:endif

!   Create dummy file listing the modules provided by the generated code;
!   this prevents them being added to the .mod file.

:output $dialog.tmp
:  if module "Dialog-Call"
function $"dialog_call"
function $"dialog_return"
:  endif
:close

!   Generate stubs for all modules not yet defined in source file

:set stub_first="/"
:set stub_between="*"
:set stub_last="/"
:set module_line="%s:"
:set row_first="%ld"
:set row_after=" %ld"

:internal initialise_the_program
:internal get_external_event
:do stubs $source.mod $dialog.tmp

$name:
:   include optional $template "<$module_name>" "<END>"
    Return

:enddo stubs
:delete $dialog.tmp

:if exist $source
:    declare string $ext = ""
:else
:    declare string $ext = ".rx"
:endif
:output $source$ext
:echo "lr I: creating $source$ext..."
/*---------------------------------------------------------------------------
:include $source.mod "<help>" "<end>"
 *  $source$ext - generated script; do not modify directly. See $dialog.l
 *  Generated by LIBERO $version on $fulldate, $time.
 *  Schema used: $schema
 *---------------------------------------------------------------------------*/

/*- Symbolic constants and event numbers ------------------------------------*/

:include $source.mod "<data>" "<end>"
$"terminate_event"  = -1                /*  Halts the dialog                 */
LR_NULL_EVENT       = -2
:do event
$name               = $number
:enddo
:do state
LR_STATE_$name      = $number
:enddo
:if defaults
LR_defaults_state   = $defaults
:endif

/*- Public dialog variables -------------------------------------------------*/

$"the_next_event" = 0                   /*  Next event from module           */
$"the_exception_event" = 0              /*  Exception event from module      */
$"feedback" = 0                         /*  Return code from this function   */
$"exception_raised" = 0                 /*  1 if exception raised            */

/*- Variables used by dialog interpreter ------------------------------------*/

LR_event = 0                            /*  Event for state transition       */
LR_state = 0                            /*  Current dialog state             */
LR_savest = 0                           /*  Saved dialog state               */
LR_index = 0                            /*  Index into vector table          */
LR_vecptr = 0                           /*  Index into module vector         */

/*- Static areas ------------------------------------------------------------*/

:if $states < 10
:   declare int nswid = 1               # Size of item in LR_nextst table
:else
:if $states < 100
:   declare int nswid = 2
:else
:   declare int nswid = 3
:endif all
:
:if $vectors < 10
:   declare int acwid = 1               # Size of item in LR_action table
:else
:if $vectors < 100
:   declare int acwid = 2
:else
:   declare int acwid = 3
:endif all
:
:if $modules < 10
:   declare int mowid = 1               # Size of item in LR_module table
:   declare string null = "0"
:else
:if $modules < 100
:   declare int mowid = 2
:   declare string null = "00"
:else
:   declare int mowid = 3
:   declare string null = "000"
:endif all
:
:set row_width  = 42                    # If $row is longer, do overflow
:set row_first  = "%0$nswid\ld"
:set row_after  = "%0$nswid\ld"
LR_nextst = ""
:do nextst
LR_nextst = LR_nextst || "$row"
:  do overflow
LR_nextst = LR_nextst || "$row"
:  enddo
:enddo

:set row_first  = "%0$acwid\ld"
:set row_after  = "%0$acwid\ld"
:set array_base = 1
LR_action = ""
:do action
LR_action = LR_action || "$row"
:  do overflow
LR_action = LR_action || "$row"
:  enddo
:enddo

:set row_first  = "%0$mowid\ld"
:set row_after  = "%0$mowid\ld"
LR_module = ""
:do vector
LR_module = LR_module || "$row" || "$null"
:enddo
:set array_base = 0

:set number_fmt = "%0$acwid\ld"
:declare int offsetidx
:do vector
:   set offsetidx = $number + 1
LR_offset.$offsetidx = $offset
:enddo
:set number_fmt = "%ld"
:if animate

:push $style
:option -style=normal
:do state
LR_sname.$number = "$name"
:enddo
:do event
LR_ename.$number = "$name"
:enddo
:set array_base = 1
:set number_fmt = "%0$acwid\ld"
:do module
LR_mname.$number = "$name"
:enddo
:set number_fmt = "%ld"
:set array_base = 0
:pop $style
:option -style=$style
:endif

/**********************************   MAIN   **********************************/

LR_state = 0                            /*  First state is always zero       */
:if module "Dialog-Call"
LR_stack_size = 0                       /*  Clear subdialog stack            */
:endif
Parse Arg arguments
Call $"initialise_the_program" arguments
Do While $"the_next_event" <> $"terminate_event"
    LR_event = $"the_next_event"
:if check
    If LR_event < 0 | LR_event >= $events Then Do
        Say "State" LR_state "- event" LR_event "is out of range"
        Exit 1
    End
:endif
    LR_index = (LR_state * $events + LR_event) * $acwid + 1
    LR_index = Substr(LR_action, LR_index, $acwid)
    LR_savest = LR_state

:if defaults
    /*  if no action for this event, try the defaults state                  */
    If LR_index = 0 Then Do
        LR_state = LR_defaults_state
        LR_index = (LR_state * $events + LR_event) * $acwid + 1
        LR_index = Substr(LR_action, LR_index, $acwid)
:endif
:if check
        If LR_index = 0 Then Do
            Say "State" LR_state "- event" LR_event "is not accepted"
            Exit 1
        End
:endif
:if defaults
    End
:endif
:if animate
    Say ""
    Say LR_sname.LR_state ":"
    Say "    (--)" LR_ename.LR_event
:endif
:if check
    $"the_next_event" = LR_NULL_EVENT
:endif
    $"the_exception_event" = LR_NULL_EVENT
    $"exception_raised" = 0

    /*  Execute module list for state transition, 0 indicates end of list    */
    LR_vecptr = LR_offset.LR_index
    LR_modnbr = Substr(LR_module, LR_vecptr * $mowid + 1, $mowid)
    Do While LR_modnbr > 0 & $"exception_raised" = 0
:if animate
        Say "          +" LR_mname.LR_modnbr
:endif
        Select
:set array_base = 1
:do module
            When LR_modnbr = $number Then Call $name
:enddo
:set array_base = 0
        End
        LR_vecptr = LR_vecptr + 1
        LR_modnbr = Substr(LR_module, LR_vecptr * $mowid + 1, $mowid)
    End
    /*  Handle exception if any was raised                                   */
    If $"exception_raised" Then Do
        If $"the_exception_event" <> LR_NULL_EVENT Then Do
            LR_event = $"the_exception_event"
        End
        $"the_next_event" = LR_event
:if animate
        Say "    (=>)" LR_ename.LR_event
:endif
    End
    Else Do
        LR_index = (LR_state * $events + LR_event) * $nswid + 1
        LR_state = Substr(LR_nextst, LR_index, $nswid)
    End
:if defaults
    If LR_state = LR_defaults_state Then Do
        LR_state = LR_savest
    End
:endif
    If $"the_next_event" = LR_NULL_EVENT Then Do
        Call $"get_external_event"
:if check
        If $"the_next_event" = LR_NULL_EVENT Then Do
            Say "No event set after event" LR_event "in state" LR_state
            Exit 1
        End
:endif
    End
End
Exit $"feedback"

$"raise_exception":
    Arg event
    $"exception_raised" = 1
    If event > 0 Then $"the_exception_event" = event
    Return

:if module "Dialog-Call"
:  if not event "Return"
:     echo "lr E: you must define the 'Return' event"
:     exit 1
:  endif
:  declare int $stack_max = 20
:
$"dialog_call":
    If LR_stack_size < $stack_max Then Do
        LR_stack_size = LR_stack_size + 1
        LR_stack.LR_stack_size = LR_state
    End
    Else Do
        Say "State" LR_state "- Dialog-Call overflow"
        Exit 1
    End
    Return

$"dialog_return":
    If LR_stack_size > 0 Then Do
        LR_state = LR_stack.LR_stack_size
        LR_stack_size = LR_stack_size - 1
        Call $"raise_exception" $"return_event"
    End
    Else Do
        Say "State" LR_state "- Dialog-Return underflow"
        Exit 1
    End
    Return

:endif
:include $source.mod "<code>" "<end>"
