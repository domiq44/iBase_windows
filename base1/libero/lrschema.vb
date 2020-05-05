!============================================================================*
!                                                                            *
!   lrschema.vb - Schema for Visual Basic programming                        *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
!                                                                            *
!   Generates a Visual Basic 3.0 .BAS and .INT file.  Add both of these      *
!   to your project.  Whenever you regenerated the dialog, make sure that    *
!   (a) you save your .BAS file before running Libero, and (b) you add       *
!   the .BAS and .INT files to your project, or close/open the project.      *
!                                                                            *
!   Usage:      Add this line to the start of your dialog file:              *
!               -schema=lrschema.vb                                          *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:slice=shared  - let other processes work at same time   *
!               -opt:stack_max=nnn - size of subdialog stack (20)            *
!               -opt:template=xxxx - template file (template.vb)             *
!                                                                            *
!               You can modify the generated .BAS file except between the    *
!               marks "'%BEGIN..." and "'%END...".                           *
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
!   be included in a newly-generated program (keywords are case-sensitive):
!
!   <HEADER>                    - program header comment
!   <DATA>                      - data definitions
!   <Initialise-The-Program>    - in Initialise-The-Program
!   <Get-External-Event>        - in Get-External-Event
!   <Terminate-The-Program>     - in Terminate-The-Program
!   <Any-Dialog-Module>         - any dialog module
!
:declare string $template = "template.vb"

:if not exist $source.bas
:output $source.bas
:echo "lr I: creating skeleton procedure module $source.bas..."
'==============================================================================
'
'   $source.bas - summary of procedure function
'
'   Written:    $date     $author
'   Revised:    $date
'
:include optional $template "<HEADER>" "<END>"
'   Skeleton generated by LIBERO $version on $fulldate, $time.
'==============================================================================
'
Option Explicit
'
'   Define module-level variables here
'
:include optional $template "<DATA>" "<END>"

'%BEGIN EVENTS
'%END EVENTS
Dim $"the_next_event"       As Integer  ' Next event from module
Dim $"the_exception_event"  As Integer  ' Exception event from module
Dim $"exception_raised"     As Integer  ' TRUE if exception raised
Dim $"feedback"             As Integer  ' Return code for function

'********************************   M A I N   ********************************
'   This is the entry function - change its name and arguments as you
'   need to.  If you expect arguments, copy them into module-level
'   variables so that the private functions can access them.
'
Function $source () As Integer
    $"feedback" = 0                     ' Assume no errors
    If $source\_EXECUTE() Then          ' Run program dialog
        $source = -1                    ' Error from dialog
    Else
        $source = $"feedback"           ' Return feedback
    End If
End Function

'
'*************************   INITIALISE THE PROGRAM   *************************
'
Private Sub $"initialise_the_program" ()
    $"the_next_event" = $"ok_event"
:include optional $template "<Initialise-The-Program>" "<END>"
End Sub

'
'***************************   GET EXTERNAL EVENT   ***************************
'
Private Sub $"get_external_event" ()
:include optional $template "<Get-External-Event>" "<END>"
:if $included = 0

:endif
End Sub

'
'*************************   TERMINATE THE PROGRAM    *************************
'
Private Sub $"terminate_the_program" ()
    $"the_next_event" = $"terminate_event"
:include optional $template "<Terminate-The-Program>" "<END>"
End Sub

'
'******************************   DISPATCHER   ********************************
'
Sub ZzDis_$source (module, LR_nextev, LR_excpev, LR_raised)
'%BEGIN DISPATCHER
'%END DISPATCHER
End Sub

:close
:endif

!   Create dummy file listing the modules provided by the generated code;
!   this prevents them being added to the .mod file.

:output $dialog.tmp
:if module "Dialog-Call"
Private Sub $"dialog_call" ()
Private Sub $"dialog_return" ()
:endif
:close

!   Generate stubs for all modules not yet defined in source file

:set stub_before="'"
:set stub_first="'"
:set stub_between="*"
:set stub_last="*"
:set module_line="Private Sub %s ()"
:internal initialise_the_program
:internal get_external_event
:option -noidle
:do stubs $source.bas $dialog.tmp
'
Private Sub $name ()
:   include optional $template "<$module_name>" "<END>"
:   if $included = 0
    ' needs work
:   endif
End Sub

:enddo stubs
:delete $dialog.tmp

!
!   Slice EVENTS code out of source BAS file, then re-generate it
!
:output $source.tmp
:include $source.bas "" "'%BEGIN EVENTS"
:echo "lr I: generating code for $dialog..."
'%BEGIN EVENTS
'----------------------------------------------------------------------------
'   Dialog event definitions - do not modify this code by hand
'   Generated by LIBERO $version on $fulldate, $time.
'   Schema used: $schema
'----------------------------------------------------------------------------
Const $"terminate_event" = -1           ' Halts the dialog
:do event
Const $name = $number
:enddo
'%END EVENTS
!
!   Slice DISPATCHER code out of source BAS file, then re-generate it
!
:include $source.bas "'%END EVENTS" "'%BEGIN DISPATCHER"
'%BEGIN DISPATCHER
    '------------------------------------------------------------------------
    '   Dialog dispatcher - do not modify this code by hand
    '   Generated by LIBERO $version on $fulldate, $time.
    '   Schema used: $schema
    '----------------------------------------------------------lrschema.vb---
    $"the_next_event" = LR_nextev
    $"the_exception_event" = LR_excpev
    $"exception_raised" = LR_raised
    Select Case module
        Case -1
            $"initialise_the_program"
        Case -2
            $"get_external_event"
:set array_base = 1
:do module
:  if '$name' = '$"dialog_call"'
:  else
:  if '$name' = '$"dialog_return"'
:  else
        Case $number
            $name
:  endif all
:enddo
:set array_base = 0
    End Select
    LR_nextev = $"the_next_event"
    LR_excpev = $"the_exception_event"
    LR_raised = $"exception_raised"
'%END DISPATCHER
:include $source.bas "'%END DISPATCHER" ""
:close
:delete $source.bak
:rename $source.bas $source.bak
:rename $source.tmp $source.bas

:output $source.int
'----------------------------------------------------------------------------
'   Dialog data and code block - do not modify this code by hand
'   Generated by LIBERO $version on $fulldate, $time.
'   Schema used: $schema
'--------------------------------------------------------------lrschema.vb---

Option Explicit

'-- Symbolic constants and event numbers ------------------------------------

Const LR_NULL_EVENT = -2
Const $"terminate_event" = -1
:if defaults
Const LR_defaults_state = $defaults
:endif
:do state
Const LR_STATE_$name = $number
:enddo

'-- MsgBox parameters -------------------------------------------------------

Const MB_OK = 0                         ' OK button only
Const MB_OKCANCEL = 1                   ' OK and Cancel buttons
Const MB_ABORTRETRYIGNORE = 2           ' Abort, Retry, and Ignore buttons
Const MB_YESNOCANCEL = 3                ' Yes, No, and Cancel buttons
Const MB_YESNO = 4                      ' Yes and No buttons
Const MB_RETRYCANCEL = 5                ' Retry and Cancel buttons

Const MB_ICONSTOP = 16                  ' Critical message
Const MB_ICONQUESTION = 32              ' Warning query
Const MB_ICONEXCLAMATION = 48           ' Warning message
Const MB_ICONINFORMATION = 64           ' Information message

Const MB_APPLMODAL = 0                  ' Application Modal Message Box
Const MB_DEFBUTTON1 = 0                 ' First button is default
Const MB_DEFBUTTON2 = 256               ' Second button is default
Const MB_DEFBUTTON3 = 512               ' Third button is default
Const MB_SYSTEMMODAL = 4096             ' System Modal

'-- Variables used by dialog interpreter ------------------------------------

Dim LR_nextev   As Integer              ' Next event from module
Dim LR_excpev   As Integer              ' Exception event from module
Dim LR_raised   As Integer              ' TRUE if exception raised
Dim LR_feedback As Integer              ' -1 if fatal error hit us

Dim LR_event    As Integer              ' Event for state transition
Dim LR_state    As Integer              ' Current dialog state
Dim LR_savest   As Integer              ' Saved dialog state
Dim LR_index    As Integer              ' Index into vector table
Dim LR_vecptr   As Integer              ' Index into module vector
Dim LR_modnbr   As Integer              ' Number of module to execute
Dim LR_mesg     As String               ' For pop-up error messages

Dim LR_nextst   As String               ' Next state for each event
Dim LR_action   As String               ' Action for each event
Dim LR_module   As String               ' Module list for action
Dim LR_offset(1 To $vectors) As Integer

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
:if animate
:declare int count
:set count = $states - 1
Dim LR_sname(0 To $count) As String
:set count = $events - 1
Dim LR_ename(0 To $count) As String
Dim LR_mname(1 To $modules) As String
:endif

:if module "Dialog-Call"
:  if not event "Return"
:     echo "lr E: you must define the 'Return' event"
:     exit 1
:  endif
:  declare int $stack_max = 20
:  declare int $dialog_call_modnbr
:  declare int $dialog_return_modnbr
:  do module                            #   Look at all modules to find
:    if '$name' = '$"dialog_call"'      #     numbers for -Call and -Return.
:       set $dialog_call_modnbr = $number + 1
:    endif
:    if '$name' = '$"dialog_return"'
:       set $dialog_return_modnbr = $number + 1
:    endif
:  enddo
Dim LR_stack(1 to $stack_max) As Integer
Dim LR_stack_size As Integer

:endif
'-- Dialog interpreter starts here ------------------------------------------

Static Function $source\_EXECUTE () As Integer
    LR_state = 0                        ' First state is always 0
:if module "Dialog-Call"
    LR_stack_size = 0                   ' Clear subdialog stack
:endif
    LR_feedback = 0                     ' No dialog errors
    LR_initialise                       ' Initialse static strings

    ' Call Initialise_the_program through the Dispatcher routine
    ZzDis_$source -1, LR_nextev, LR_excpev, LR_raised
    Do Until LR_nextev = $"terminate_event"
:declare string slice = "exclusive"
:if "$slice" = "shared"
        DoEvents                        ' Give a time slice to Windows
:endif
        LR_event = LR_nextev
:if check
        If LR_event >= $events Or LR_event < 0 Then
            LR_mesg = "State" & LR_state & " - event" & LR_event
            LR_mesg = LR_mesg & " is out of range"
            LR_fatalerror
            Exit Do
        End If
:endif
        LR_index = (LR_state * $events + LR_event) * $acwid + 1
        LR_index = Mid(LR_action, LR_index, $acwid)
        LR_savest = LR_state

:if defaults
        '   If no action for this event, try the defaults state
        If LR_index = 0 Then
            LR_state = LR_defaults_state
            LR_index = (LR_state * $events + LR_event) * $acwid + 1
            LR_index = Mid(LR_action, LR_index, $acwid)
:endif
:if check
            If LR_index = 0 Then
                LR_mesg = "State" & LR_state & " - event"
                LR_mesg = LR_mesg & LR_event & " is not accepted"
                LR_fatalerror
                Exit Do
            End If
:endif
:if defaults
        End If
:endif

:if animate
        Debug.Print ""
        Debug.Print LR_sname(LR_state); ":"
        Debug.Print "    (--) "; LR_ename(LR_event)
:endif
:if check
        LR_nextev = LR_NULL_EVENT
:endif
        LR_excpev = LR_NULL_EVENT
        LR_raised = False

        '   Execute module list for state transition, 0 indicates end of list
        LR_vecptr = LR_offset(LR_index)
        Do
            LR_modnbr = Mid(LR_module, LR_vecptr * $mowid + 1, $mowid)
            If LR_modnbr = 0 Or LR_raised Then Exit Do
:if animate
            Debug.Print "          + "; LR_mname(LR_modnbr)
:endif
:if module "Dialog-Call"
            If LR_modnbr = $dialog_call_modnbr Then
                dialog_call
            Elseif LR_modnbr = $dialog_return_modnbr Then
                dialog_return
            Else
                ' Execute the module via the Dispatcher
                ZzDis_$source LR_modnbr, LR_nextev, LR_excpev, LR_raised
            End If
:else
            ' Execute the module via the Dispatcher
            ZzDis_$source LR_modnbr, LR_nextev, LR_excpev, LR_raised
:endif
            LR_vecptr = LR_vecptr + 1
        Loop

        '   Handle exception if any was raised
        If LR_raised Then
            If LR_excpev <> LR_NULL_EVENT Then LR_event = LR_excpev
            LR_nextev = LR_event
:if animate
            Debug.Print "    (=>) "; LR_ename(LR_event)
:endif
        Else
            LR_index = (LR_state * $events + LR_event) * $nswid + 1
            LR_state = Mid(LR_nextst, LR_index, $nswid)
        End If
:if defaults
        If LR_state = LR_defaults_state Then LR_state = LR_savest
:endif
        If LR_nextev = LR_NULL_EVENT Then
            ' get_external_event
            ZzDis_$source -2, LR_nextev, LR_excpev, LR_raised
:if check
            If LR_nextev = LR_NULL_EVENT Then
                LR_mesg = "No event set after event" & LR_event
                LR_mesg = LR_mesg & " in state" & LR_state
                LR_fatalerror
                Exit Do
            End If
:endif
        End If
    Loop
    $source\_EXECUTE = LR_feedback
End Function

'   Standard subroutines used by dialog interpreter

Private Sub LR_fatalerror
    LR_mesg = LR_mesg & Chr$$(10) & "Source = $source"
    Debug.Print LR_mesg
    MsgBox LR_mesg, MB_OK + MB_ICONSTOP, "Libero Fatal Error"
    LR_feedback = -1                    ' Signal error to main function
End Sub

Private Sub LR_initialise
    static values_loaded As Integer     ' First-time flag

    If values_loaded Then Exit Sub      ' If we already initialised tables
    values_loaded = True                '   then things are okay, so leave

:set row_width  = 42                    # If $row is longer, do overflow
:set number_fmt = "%ld"
:set row_first  = "%0$nswid\ld"
:set row_after  = "%0$nswid\ld"
:set number_fmt = "%ld"
:
    LR_nextst = ""
:do nextst
    LR_nextst = LR_nextst & "$row"
:  do overflow
    LR_nextst = LR_nextst & "$row"
:  enddo
:enddo

:set number_fmt = "%ld"
:set row_first  = "%0$acwid\ld"
:set row_after  = "%0$acwid\ld"
:set number_fmt = "%ld"
:
:set array_base = 1
    LR_action = ""
:do action
    LR_action = LR_action & "$row"
:  do overflow
    LR_action = LR_action & "$row"
:  enddo
:enddo

:set number_fmt = "%ld"
:set row_first  = "%0$mowid\ld"
:set row_after  = "%0$mowid\ld"
:set number_fmt = "%ld"
:
    LR_module = ""
:do vector
    LR_module = LR_module + "$row" + "$null"
:enddo
:set array_base = 0

:declare int offsetidx
:do vector
:   set offsetidx = $number + 1
    LR_offset($offsetidx) = $offset
:enddo
:if animate

:push $style
:option -style=normal
:do state
    LR_sname($number) = "$name"
:enddo
:do event
    LR_ename($number) = "$name"
:enddo
:set array_base = 1
:do module
    LR_mname($number) = "$name"
:enddo
:set array_base = 0
:pop $style
:option -style=$style
:endif
End Sub

:if module "Dialog-Call"
Private Sub $"dialog_call"
    If LR_stack_size < $stack_max Then
        LR_stack_size = LR_stack_size + 1
        LR_stack(LR_stack_size) = LR_state
    Else
        LR_mesg = "State " & LR_state & " - Dialog-Call overflow"
        LR_fatalerror
    End If
End Sub

Private Sub $"dialog_return"
    If LR_stack_size > 0 Then
        LR_state = LR_stack(LR_stack_size)
        LR_stack_size = LR_stack_size - 1
        exception_raised = True
        the_exception_event = $"return_event"
    Else
        LR_mesg = "State " & LR_state & " - Dialog-Return underflow"
        LR_fatalerror
    End If
End Sub

:endif
