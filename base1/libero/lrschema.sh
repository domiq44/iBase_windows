!============================================================================*
!                                                                            *
!   lrschema.sh - Schema for Unix Bourne shell programming                   *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
!                                                                            *
!   Generates a script written in the Bourne shell language (/bin/sh).       *
!                                                                            *
!   Usage:      Add this line to the start of your dialog file:              *
!               -schema=lrschema.sh                                          *
!                                                                            *
!               Put your module data and code in '<script>.mod'.  When       *
!               you run lr, it creates a script file combining your modules  *
!               with the generated code from this schema.  To make a change  *
!               and rebuild 'myscript', run these commands:                  *
!                                                                            *
!               vi myscript.l       (make changes to dialog)                 *
!               vi myscript.mod     (modify module code)                     *
!               lr myscript         (add stubs if needed, build script)      *
!               chmod +x myscript   (make script executable)                 *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:stack_max=nnn - size of subdialog stack (20)            *
!               -opt:template=xxxx - template file (template.sh)             *
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
!   <Any-Dialog-Module>         - any dialog module
!
:declare string $template = "template.sh"

:if not exist $source.mod
:output $source.mod
:echo "lr I: creating skeleton module file $source.mod..."
#==============================================================================
#-
#-  $source.mod - module file for $dialog.l
<help>
#
#   $source     Summary of script file
#
#   Written:    $date     $author
#   Revised:    $date
#
:include optional $template "<HEADER>" "<END>"
<end>
#-  Skeleton generated by LIBERO $version on $fulldate, $time.
#==============================================================================

#   Put definitions here that will go at the start of the script
<data>
:include optional $template "<DATA>" "<END>"
<end>

<code>

##########################   INITIALISE THE PROGRAM   #########################

$"initialise_the_program" ()
{
    $"the_next_event"=$$$"ok_event"
:include optional $template "<Initialise-The-Program>" "<END>"
}


############################   GET EXTERNAL EVENT   ###########################

$"get_external_event" ()
{
:include optional $template "<Get-External-Event>" "<END>"
:if $included = 0
    return
:endif
}


##########################   TERMINATE THE PROGRAM    #########################

$"terminate_the_program" ()
{
    $"the_next_event"=$$$"terminate_event"
:   include optional $template "<Terminate-The-Program>" "<END>"
}
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

:set stub_first="#"
:set stub_between="#"
:set stub_last="#"
:set module_line="%s ()"
:set array_base=1
:set row_first="%ld"
:set row_after=" %ld"
:option -noidle

:internal initialise_the_program
:internal get_external_event
:do stubs $source.mod $dialog.tmp

$name ()
{
:   include optional $template "<$module_name>" "<END>"
:   if $included = 0
    return
:   endif
}

:enddo stubs
:delete $dialog.tmp

:output $source
:echo "lr I: building $source..."
#! /bin/sh
#----------------------------------------------------------------------------
:include $source.mod "<help>" "<end>"
#-  $source - generated script; do not modify directly. See $dialog.l
#-  Generated by LIBERO $version on $fulldate, $time.
#-  Schema used: $schema
#----------------------------------------------------------------------------

#-- Symbolic constants and event numbers ------------------------------------

:include $source.mod "<data>" "<end>"
$"terminate_event"=255
:do event
$name=$number
:enddo
:do state
LR_STATE_$name=$number
:enddo
:if defaults
LR_defaults_state=$defaults
:endif

#-- Standard variables ------------------------------------------------------

$"the_next_event"=0                     #   Next event from module
$"the_exception_event"=0                #   Exception event from module
$"feedback"=0                           #   Return code from this function
$"exception_raised"=FALSE               #   TRUE if exception raised
$"script_name"=""                       #   Name of script including path

#-- Variables used by dialog interpreter ------------------------------------

LR_event=0                              #   Event for state transition
LR_state=0                              #   Current dialog state
LR_savest=0                             #   Saved dialog state
LR_index=0                              #   Index into vector table
LR_vecptr=0                             #   Index into module vector

#-- Static areas ------------------------------------------------------------

:set comma_before=""
:set comma_last="\""
:
:do nextst
:  if $overflow = 0
LR_nextst$number="$row"
:  else
LR_nextst$number="$row
:    do overflow
            $row$comma
:    enddo
:  endif
:enddo

:do action
:  if $overflow = 0
LR_action$number="$row"
:  else
LR_action$number="$row
:    do overflow
            $row$comma
:    enddo
:  endif
:enddo

:do vector
:  if "$row" = ""
LR_vector$number="255"
:  else
LR_vector$number="$row 255"
:  endif
:enddo

:do module
LR_module$number=$name
:enddo
:if animate

:push $style
:option -style=normal
:  do event
LR_ename$number=$name
:  enddo

:  do state
LR_sname$number=$name
:  enddo
:pop $style
:option -style=$style
:endif

:include $source.mod "<code>" "<end>"

LR_idx ()                               #   Extract one item from array
{
    shift $$1
    return $$1
}

$"raise_exception" ()
{
    $"exception_raised"=TRUE
    test "$$1" != "" && $"the_exception_event"=$$1
}

:if module "Dialog-Call"
:  if not event "Return"
:     echo "lr E: you must define the 'Return' event"
:     exit 1
:  endif
:  declare int $stack_max = 20
:
$"dialog_call" ()
{
    if [ $$LR_stack_size -lt $stack_max ]; then
        LR_stack_size=`expr $$LR_stack_size + 1`
        eval "LR_stack$$LR_stack_size=$$LR_state"
    else
        echo State $$LR_state - Dialog-Call overflow
        exit 1
    fi
}

$"dialog_return" ()
{
    if [ $$LR_stack_size -gt 0 ]; then
        LR_state=$$LR_stack$$LR_stack_size
        LR_state=`eval "echo $$LR_state"`
        LR_stack_size=`expr $$LR_stack_size - 1`
        $"raise_exception" $$$"return_event"
    else
        echo State $$LR_state - Dialog-Return underflow
        exit 1
    fi
}

:endif
###################################   MAIN   ##################################

LR_state=1
:if module "Dialog-Call"
LR_stack_size=0                         #   Clear subdialog stack
:endif
$"script_name"=$$0
$"initialise_the_program" $$*
while [ $$$"the_next_event" != $$$"terminate_event" ]; do
    LR_event=$$$"the_next_event"
:if check
    if [ $$LR_event -gt $events -o $$LR_event -lt 1 \
    -o `expr $$LR_event : ".*"` -gt 3 ]; then
        echo State $$LR_state - event $$LR_event is out of range
        exit 1
    fi
:endif
    eval "LR_idx $$LR_event \$$LR_action$$LR_state"; LR_index=$$?
    LR_savest=$$LR_state

:if defaults
    #   If no action for this event, try the defaults state
    if [ $$LR_index -eq 0 ]; then
        LR_state=$$LR_defaults_state
        eval "LR_idx $$LR_event \$$LR_action$$LR_state"; LR_index=$$?
:endif
:if check
        if [ $$LR_index -eq 0 ]; then
            echo State $$LR_state - event $$LR_event is not accepted
            exit 1
        fi
:endif
:if defaults
    fi
:endif

:if animate
    echo; eval "echo -n \$$LR_sname$$LR_state"; echo :
    echo -n "    (--) "; eval "echo \$$LR_ename$$LR_event"
:endif
:if check
    $"the_next_event"=0
:endif
    $"the_exception_event"=0
    $"exception_raised"=FALSE

    #   Execute module list for state transition
    LR_vecptr=1
    while true; do
        eval "LR_idx $$LR_vecptr \$$LR_vector$$LR_index"; LR_modnbr=$$?
        if [ $$LR_modnbr -eq 255 -o $$$"exception_raised" = TRUE ]; then
            break
        fi
:if animate
        echo -n "          + "; eval "echo \$$LR_module$$LR_modnbr"
:endif
        eval "\$$LR_module$$LR_modnbr"  #   Execute the module of code
        LR_vecptr=`expr $$LR_vecptr + 1`
    done

    #   Handle exception if any was raised
    if [ $$$"exception_raised" = TRUE ]; then
        if [ $$$"the_exception_event" -ne 0 ]; then
            LR_event=$$$"the_exception_event"
        fi
        $"the_next_event"=$$LR_event
:if animate
        echo -n "    (=>) "; eval "echo \$$LR_ename$$LR_event"
:endif
    else
        eval "LR_idx $$LR_event \$$LR_nextst$$LR_state"; LR_state=$$?
    fi
:if defaults
    if [ $$LR_state -eq $$LR_defaults_state ]; then
        LR_state=$$LR_savest
    fi
:endif
    if [ $$$"the_next_event" -eq 0 ]; then
        $"get_external_event"
:if check
        if [ $$$"the_next_event" -eq 0 ]; then
            echo No event set after event $$LR_event in state $$LR_state
            exit 1
        fi
:endif
    fi
done
exit $$$"feedback"
