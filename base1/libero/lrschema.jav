!============================================================================*
!                                                                            *
!   lrschema.jav - Schema for Java programming                               *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
!                                                                            *
!   Usage:      Generates a Java module                                      *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:model=object  - generate a Java object (default)        *
!               -opt:model=console - generate an console application         *
!               -opt:model=applet  - generate an Java applet                 *
!               -opt:extend=***    - generate the Java object with your      *
!                                    extends and implementations             *
!                                    Eg. extend="Applet implement Runable"   *
!               -opt:stack_max=nnn - size of subdialog stack (20)            *
!               -opt:template=xxxx - template file (template.jav)            *
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

!   You can use the template file to include project-specific code in the
!   generated code at various points.  This is a (better) alternative to
!   changing the schema in order to add your own project code.
!
!   The template file should contain these sections (each starts with a
!   keyword on a line, and ends with <END> on a line).  These sections may
!   be included in newly-generated code (keywords are case-sensitive):
!
!   <PACKAGE>                   - package for generated classes
!   <HEADER>                    - program header comment
!   <DATA>                      - data definitions
!   <Initialise-The-Program>    - in Initialise-The-Program
!   <Get-External-Event>        - in Get-External-Event
!   <Any-Dialog-Module>         - any dialog module
!
:declare string $template = "template.jav"
:declare string model     = "object"
:declare string extend    = ""

:if "$model" = "object"
:else
:if "$model" = "console"
:else
:if "$model" = "applet"
:else
:   echo "lr E: invalid model '$model'; use -opt:model=[object|console|applet]"
:   exit 1
:endif all

:if not exist $source.java
:echo "lr I: creating skeleton program $source.java..."
:output $source.java
/*===========================================================================*
 *                                                                           *
 *  $source.java   description...                                            *
 *                                                                           *
 *  Written:       $date      $author                                        *
 *  Revised:       $date                                                     *
 *                                                                           *
:include optional $template "<HEADER>" "<END>"
 *  Skeleton generated by LIBERO $version on $fulldate, $time.               *
 *===========================================================================*/

:include optional $template "<PACKAGE>" "<END>"
import java.awt.*;
import java.applet.*;
import java.net.*;
import java.util.*;
import java.io.*;

:include optional $template "<DATA>" "<END>"

public class $source extends $source\I
{
:if "$model" = "applet"
    public void init ()
    {
        super.init();
        // Add your custom init here
    }
:else
///////////////////////////   C O N T R U C T O R   ///////////////////////////

public $source ()
{
}
:endif


//////////////////////////////////   M A I N   ////////////////////////////////

:if "$model" = "console"
static $source
    main;                               //  Main object

//  For console application
public static void main (String args[])
{
    main = new $source ();
    main.execute ();
}
:else
public int $source\_execute (String args[])
{
    int
        feedback;

    feedback = execute ();
    return (feedback);
}
:endif


//////////////////////////   INITIALISE THE PROGRAM   /////////////////////////

public void $"initialise_the_program" ()
{
    $"the_next_event" = $"ok_event";
:include optional $template "<Initialise-The-Program>" "<END>"
}


////////////////////////////   GET EXTERNAL EVENT   ///////////////////////////

public void $"get_external_event" ()
{
:include optional $template "<Get-External-Event>" "<END>"
}

//%START MODULE
//%END MODULE
}
:endif

!if applet -> generate a simple html file

:if "$model" = "applet"
:  if not exist $source.html
:  echo "lr I: creating html page $source.html..."
:  output $source.html
<!Generated by LIBERO $version on $fulldate, $time, schema=$schema>
<HTML>
<HEAD>
<TITLE>Simple container for $source </TITLE>
</HEAD>
<BODY>
<APPLET CODE="$source.class"></APPLET>
</BODY>
</HTML>
:  close
:  endif
:endif

:echo "lr I: generating $source\I.java..."
:output $source\I.java
//  Object used by $source
//  Generated by LIBERO $version on $fulldate, $time.
//  Schema file used: $schema.
:include optional $template "<PACKAGE>" "<END>"
import java.awt.*;
import java.applet.*;
import java.net.*;
import java.util.*;
import java.io.*;

:include optional $template "<DATA>" "<END>"

:if "$model" = "applet"
abstract public class $source\I extends Applet $extend
:else
:   if "$extend" = ""
abstract public class $source\I
:   else
abstract public class $source\I extends $extend
:   endif
:endif
{
    //- Variables used by dialog interpreter --------------------------------

    private int
        _LR_event,                  //  Event for state transition
        _LR_state,                  //  Current dialog state
        _LR_savest,                 //  Saved dialog state
        _LR_index;                  //  Index of methods function

    public int
        $"the_next_event",          //  Next event from module
        $"the_exception_event";     //  Exception event from module

    private boolean
        $"exception_raised";        //  TRUE if exception raised

:if module "Dialog-Call"
:  if not event "Return"
:     echo "lr E: you must define the 'Return' event"
:     exit 1
:  endif
:  declare int $stack_max = 20
    private static int
        _LR_stack [] = new int [$stack_max],
        _LR_stack_size;             //  Subdialog stack size; 0=empty
:endif

    //- Symbolic constants and event numbers --------------------------------

:if check
    private static int
        _LR_STOP            = 0xFFFF,
        _LR_NULL_EVENT      = -2;
:endif
    public static int
:do state
        _LR_STATE_$name     = $number,
:enddo
:if defaults
        _LR_defaults_state  = $defaults,
:endif
:do event
        $name               = $number,
:enddo
        $"terminate_event"  = -1;

    //- Static areas --------------------------------------------------------

    private static int _LR_nextst [][] = {
:do nextst
:  if $overflow = 0
        { $row }$comma
:  else
        { $row
:    do overflow
         $row
:    enddo
        }$comma
:  endif
:enddo
    };

    private static int _LR_action [][] = {
:set array_base=1
:do action
:  if $overflow = 0
        { $row }$comma
:  else
        { $row
:    do overflow
          $row
:    enddo
        }$comma
:  endif
:enddo
:set array_base=0
    };

    private static int _LR_vector [][] = {
        {0},
:do vector
:  if "$row" = ""
        {_LR_STOP}$comma
:  else
        {$row,_LR_STOP}$comma
:  endif
:enddo
    };
:if animate

:push $style
:option -style=normal
    private static String _LR_mname [] = {
:  do module
        "$name"$comma
:  enddo
    };

    private static String _LR_sname [] = {
:  do state
        "$name"$comma
:  enddo
    };

    private static String _LR_ename [] = {
:  do event
        "$name"$comma
:  enddo
    };
:pop $style
:option -style=$style
:endif

    abstract public void $"initialise_the_program" ();
    abstract public void $"get_external_event" ();
:   do module
    abstract public void $name ();
:   enddo

    //- Dialog interpreter starts here --------------------------------------

    public int execute ()
    {
        int
            feedback = 0,
            index,
            next_module;

        _LR_state = 0;                  //  First state is always zero
:if module "Dialog-Call"
        _LR_stack_size = 0;             //  Clear subdialog stack
        _LR_stack = new int [$stack_max];
:endif
        $"initialise_the_program" ();
        while ($"the_next_event" != $"terminate_event")
          {
            _LR_event = $"the_next_event";
:if check
            if (_LR_event >= $events || _LR_event < 0)
              {
                String buffer;
                buffer  = "State " + _LR_state + " - event " + _LR_event;
                buffer += " is out of range  ($source)";
                System.out.println (buffer);
                break;
              }
:endif
            _LR_savest = _LR_state;
            _LR_index  = _LR_action [_LR_state][_LR_event];
:if defaults
            //  If no action for this event, try the defaults state
            if (_LR_index == 0)
              {
                _LR_state = _LR_defaults_state;
                _LR_index = _LR_action [_LR_state][_LR_event];
              }
:endif
:if animate
            System.out.println ( _LR_sname [_LR_state] + ':');
            System.out.println ("    (--) " + _LR_ename [_LR_event]);
:endif
:if check
            if (_LR_index == 0)
              {
                String buffer;
                buffer  = "State " + _LR_state + " - event " + _LR_event;
                buffer += " is not accepted ($source)";
                System.out.println (buffer);
                break;
              }
            $"the_next_event"       = _LR_NULL_EVENT;
:endif
            $"the_exception_event"  = _LR_NULL_EVENT;
            $"exception_raised"     = false;
            next_module             = 0;

            for (;;)
              {
                index = _LR_vector [_LR_index][next_module];
                if ((index == _LR_STOP)
                || ($"exception_raised"))
                break;
:if animate
                System.out.println ("          + " + _LR_mname [index]);
:endif
                switch (index)
                  {
:declare $index = 0
:do module
                    case $index: $name (); break;
:set $index = $index + 1
:enddo
                  }
                  next_module++;
              }
            if ($"exception_raised")
              {
                if ($"the_exception_event" != _LR_NULL_EVENT)
                    _LR_event = $"the_exception_event";
                $"the_next_event" = _LR_event;
:if animate
                System.out.println ("    (=>) " + _LR_ename [_LR_event]);
:endif
              }
            else
                _LR_state = _LR_nextst [_LR_state][_LR_event];

:if defaults
            if (_LR_state == _LR_defaults_state)
                _LR_state = _LR_savest;
:endif
            if ($"the_next_event" == _LR_NULL_EVENT)
              {
                $"get_external_event" ();
:if check
                if ($"the_next_event" == _LR_NULL_EVENT)
                  {
                    String buffer;
                    buffer  = "No event set after event " + _LR_event;
                    buffer += " in state " + _LR_state + " ($source)";
                    System.out.println (buffer);
                    break;
                  }
:endif
              }
          }
        return (feedback);
    }

    //- Standard dialog routines --------------------------------------------
    public void $"raise_exception" (int event)
    {
        $"exception_raised" = true;
        if (event >= 0)
            $"the_exception_event" = event;
    }

:if module "Dialog-Call"
public void $"dialog_call" ()
{
    if (_LR_stack_size < $stack_max)
        _LR_stack [_LR_stack_size++] = _LR_state;
    else
      {
        System.out.println ("State " + _LR_state + " - Dialog-Call overflow");
        exit (1);
      }
}

public void $"dialog_return" ()
{
    if (_LR_stack_size > 0)
      {
        _LR_state = _LR_stack [--_LR_stack_size];
        $"raise_exception" ($"return_event");
      }
    else
      {
        System.out.println
            ("State " + _LR_state + " - Dialog-Return underflow");
        exit (1);
      }
}

:endif
}
:close

:output $source.001
:include $source.java "//%START MODULE" "//%END MODULE"
:close $source.001
:output $source.002
:include $source.java "" "//%START MODULE"
:close $source.002

!   Generate stubs for all modules not yet defined in source file

:set module_line="public void %s ()"
:set stub_first="/"
:set stub_between="/"
:set stub_last="/"
:do stubs $source.001 $source\I.java

public void $name ()
{
:include optional $template "<$module_name>" "<END>"
}

:enddo

:output $source.java
:include $source.002
:delete  $source.002
//%START MODULE
:include $source.001
:delete  $source.001
//%END MODULE
}
