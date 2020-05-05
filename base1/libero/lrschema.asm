!============================================================================*
!                                                                            *
!   lrschema.asm - Schema for 80x86 assembler programming                    *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
!                                                                            *
!   Usage:      Generates an include file with extension .D. Add this line   *
!               to your dialog: /schema=lrschema.asm /opt:model=xxx.         *
!               Note: do not rely on registers being safe between modules.   *
!               The dialog code uses these freely without saving them.       *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:model=com     - generate a .COM file (default)          *
!               -opt:model=exe     - generate an .EXE file                   *
!               -opt:model=lsub    - generate a large-model subroutine       *
!               -opt:template=xxxx - template file (template.asm)            *
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
:set comment_ind=";"
:option -style=plain
:declare string model = "com"

:if "$model" = "com"
:else
:if "$model" = "exe"
:else
:if "$model" = "lsub"
:else
:   echo "lr E: invalid model '$model'; use -opt:model=[com|exe|lsub]"
:   exit 1
:endif all

:if $states > 255
:   echo "lr E: dialog is too complex - more than 255 states"
:   exit 1
:endif
:if $events > 253
:   echo "lr E: dialog is too complex - more than 253 events"
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
:declare string $template = "template.asm"

:if not exist $source.asm
:output $source.asm
:echo "lr I: creating skeleton program $source.asm..."
;=============================================================================
;
;  $source.asm   description...
;
;  Written:      $date      $author
;  Revised:      $date
;
:if "$model" = "com"
;  Usage:        Assemble and link as a .COM file:
;                    masm $source;
;                    link $source;
;                    exe2bin $source.exe $source.com
;                    del $source.exe
;
;  Model:        Code, data, and stack are in same segment: CS, DS, ES, and SS
;                point to the one segment, and never change.
:endif
:if "$model" = "exe"
;  Usage:        Assemble and link as an .EXE file:
;                    masm $source;
;                    link $source;
;
;  Model:        Code, data, and stack each have their own segment.  DS and ES
;                both point to the data segment.  Default stack size is 1024;
;                you can ask for a larger stack using '-opt:stack_size=nnnn'.
:endif
:if "$model" = "lsub"
;  Usage:        Assemble and link with a large-model calling program:
;                    masm $source;
;                    link caller+$source;
;
;  Model:        Code, data, and stack each have their own segment.  DS and ES
;                both point to the data segment.  Stack is provided by calling
;                program.
:endif
:include optional $template "<HEADER>" "<END>"
;
;  Skeleton generated by LIBERO $version on $fulldate, $time.
;=============================================================================

:if "$model" = "lsub"
;  FUNCTION_OPEN macro defines the interface between your function and calling
;  programs.  The default below is for C programming.  Change the definition
;  of 'function' to suit the name of your function.  Note that it must start
;  with '_' for C programming.  Define any parameters following the example
;  param1 shown below.  The parameters to a function are passed on the stack
;  starting at <6[bp]>.
;
function         equ     <_$source>    ; Name of your function
FUNCTION_OPEN    macro
                 public  function      ; Calling protocol
function         proc    far           ;
                 push    bp            ; Save caller's frame pointer
                 mov     bp,sp         ; Set-up our frame pointer
                 pushr   <es,di,ds,si> ; Save working registers
param1_lo        equ     <6[bp]>       ; Define parameters here;
param1_hi        equ     <8[bp]>       ;    this could be a 32-bit address
                 endm

FUNCTION_CLOSE   macro
                 popr    <si,ds,di,es> ; Restore working registers
                 mov     sp,bp         ; Get back old stack pointer
                 pop     bp            ; Restore caller's frame pointer
                 ret                   ; Return to caller
function         endp                  ;     and close function
                 endm

:endif
include $dialog.d                      ; Include dialog definitions

                 DATA_SEG              ; Data definitions
:include optional $template "<DATA>" "<END>"

:if "$model" != "lsub"
msg_helptext     label   byte          ; Example copyright notice
                 db 'LIBERO v', LR_version
                 db ' (c) 1991-95 by Pieter A. Hintjens.\n'
                 db 'FSM Code Generator\n\n'
                 db 'lr [file]... [{-/+}[no]option]...\n\n'
                 db '  file   - name of dialog file, default extension is .l\n'
                 db '  option - parameter or command\n', 0

:endif
;*************************   INITIALISE THE PROGRAM   ************************

MODULE initialise_the_program
:if "$model" != "lsub"
                 cmp     arg_help,1    ; Was /? specified on command line?
                 jne     initialise_okay
                 lea     si,msg_helptext
                 call    echo          ; Yes - echo help text
                 mov     the_next_event,terminate_event
                 ret                   ;   and terminate dialog

initialise_okay  label   near          ; Normal initialisation
:endif
                 mov     the_next_event,ok_event
:include optional $template "<Initialise-The-Program>" "<END>"
                 ret                   ; Return to state machine
ENDMODULE


;***************************   GET EXTERNAL EVENT   ***************************

MODULE get_external_event
:include optional $template "<Get-External-Event>" "<END>"
:if $included = 0

:endif
                 ret                   ; Return to state machine
ENDMODULE


;*************************   TERMINATE THE PROGRAM   *************************

MODULE terminate_the_program
                 mov     the_next_event,terminate_event
:include optional $template "<Terminate-The-Program>" "<END>"
                 ret                   ; Return to state machine
ENDMODULE

;%END MODULES
:close
:endif

!   Generate stubs for all modules not yet defined in source file

:internal initialise_the_program
:internal get_external_event
:set stub_first=";"
:set stub_between="*"
:set stub_last="*"
:set module_line="MODULE %s"

:output $source.tmp
:include $source.asm "" ";%END MODULES"
:close
:do stubs $source.tmp

MODULE $name
:include optional $template "<$module_name>" "<END>"

                 ret                   ; Return to state machine
ENDMODULE

:enddo stubs
:extend $source.tmp
;%END MODULES
;--------------- End of source file ------------------------------------------

                 end     program       ; This block is generated code

:close
:delete $source.bak
:rename $source.asm $source.bak
:rename $source.tmp $source.asm

:output $dialog.d
:echo "lr I: building $dialog.d..."
;----------------------------------------------------------------------------
;   $dialog.d - LIBERO dialog data definitions for $source.asm, model=$model.
;   Generated by LIBERO $version on $fulldate, $time.
;   Schema file used: $schema
;----------------------------------------------------------------------------

LR_version       equ     '$version'
:if check
LR_null_event    equ     255
LR_stop_action   equ     255
:endif
terminate_event  equ     254
:do event
$name            equ     $number
:enddo
:if defaults
LR_defaults      equ     $defaults
:endif
:do state
LR_STATE_$name   equ     $number
:enddo

ZERO             equ     00h
SPACE            equ     20h
O                equ     <offset>
B                equ     <byte ptr>
W                equ     <word ptr>


;--------------- Macros ------------------------------------------------------

CODE_SEG         macro                 ; Define code segment
                 .code
                 endm
:if "$model" = "com"
DATA_SEG         macro                 ; Define null data segment
                 endm
:else
DATA_SEG         macro                 ; Define real data segment
                 .data
                 endm
:endif

MODULE           macro   modname       ; Start of dialog module procedure
endname          equ     <modname>     ; Name to use in ENDMODULE
                 CODE_SEG              ; Open code segment
modname          proc    near          ; Open procedure
                 endm

ENDMODULE        macro                 ; End previous procedure
endname          endp                  ; Close procedure
                 endm

raise_exception  macro   optevent      ; Optional event
                 irp     event,<optevent>
                 mov     the_exception_event,event
                 endm
                 mov     exception_raised,1
                 endm

pushr            macro   rl            ; Push one or more registers onto stack
                 irp     r,<rl>        ; Registers listed between <...>
                 push    r
                 endm
                 endm

popr             macro   rl            ; Pop one or more registers from stack
                 irp     r,<rl>        ; Registers listed between <...>
                 pop     r
                 endm
                 endm

jmps             macro   addr          ; Short jump
                 jmp     short addr
                 endm

LR_move          macro   dest,src      ; Move 16-bit memory to memory
                 mov     ax,src
                 mov     dest,ax
                 endm

LR_load          macro   dest,src      ; Load item from LR table
                 xor     ax,ax         ; Tables are 8-bits wide
                 mov     al,src        ;
                 mov     dest,ax       ; LR registers are 16-bits wide
                 endm

;--------------- Main function -----------------------------------------------

:if "$model" = "com"
                 .model  small         ; Use near pointers by default
                 assume  ds:_text,es:_text
                 CODE_SEG
                 org     100h          ; Start after PSP
program          label   near

LR_main          proc    near          ; Main function:
                 call    LR_args       ;   Parse command line arguments
                 call    LR_motor      ;   Run state machine until done
                 mov     al,feedback   ; Exit program:
                 mov     ah,4Ch        ;   Function 4Ch: terminate program
                 int     21h           ;     with exit code in AL
LR_main          endp
:else
:if "$model" = "exe"
:declare int stack_size = 1024         ; Default stack size
                 dosseg                ; Don't initialise stack segment
                 .model  large         ; Use far pointers by default
                 .stack  $stack_size   ; Declare stack segment
                 CODE_SEG
program          label   far

LR_main          proc    far           ; Main function:
                 mov     ax,DGROUP     ;   Load data segment address
                 mov     ds,ax         ;   into the DS segment register
                 call    LR_args       ;   Parse command line arguments
                 call    LR_motor      ;   Run state machine until done
                 mov     al,feedback   ; Exit program:
                 mov     ah,4Ch        ;   Function 4Ch: terminate program
                 int     21h           ;     with exit code in AL
LR_main          endp
:else
:if "$model" = "lsub"
                 .model  large         ; Use far pointers by default
                 CODE_SEG
program          label   far

                 FUNCTION_OPEN
                 call    LR_motor      ;   Run state machine until done
                 FUNCTION_CLOSE
:endif all

:if "$model" != "lsub"                 ; Don't need arg parser in subroutines
;--------------- Parse arguments ---------------------------------------------
;
;  Scan command line arguments, copying text to arg_text.  Puts size of
;  argument text into arg_size.  If /? found, sets arg_help to 1, else 0.
;  Changes registers AX, SI, DI.  Stores binary zero at end of arg_text.
:if "$model" = "exe"
;  At entry, ES points to PSP; at exit ES and DS both point to _DATA.
:endif
;
LR_args          proc    near
:if "$model" = "exe"
                 pushr   <es,ds>       ; ES points to PSP
                 popr    <es,ds>       ;   so exchange DS and ES
:endif
                 mov     si,81h        ; Point SI to command tail in PSP
                 mov     di,O arg_text ; Point DI to arg_text
                 xor     cx,cx         ; Clear help switch and arg size
LR_argNext:      lodsb                 ; Get next char at DS:SI, bump SI
                 cmp     al,0Dh        ; Do we have end of line?
                 je      LR_argExit    ; yes - exit
                 cmp     al,'/'        ; Do we have '/'?
                 jne     LR_argSpace   ; no - go store character (maybe skip)
LR_argSlash:     mov     ah,[si]       ; Get switch character
                 cmp     ah,'?'        ; Is it '?'
                 jne     LR_argPut     ; no - go store character
                 mov     ch,1          ; /? was found
                 inc     si            ; Bump SI to skip ?
                 jmps    LR_argNext    ;   and loop
LR_argSpace:     cmp     al,' '        ; Do we have leading space?
                 jne     LR_argPut     ; no - go store character
                 jcxz    LR_argNext    ; yes - go get next
LR_argPut:       stosb                 ; Write char at ES:DI, bump DI
                 inc     cl            ;   bump argument size
                 jmps    LR_argNext    ;   and loop
LR_argExit:      xor     al,al         ; Store binary zero
                 stosb                 ;   at end of argument text
:if "$model" = "exe"
                 pushr   <es>          ; Leave DS and ES pointing to
                 popr    <ds>          ;   data segment
:endif
                 mov     arg_help,ch   ; 1 if /? found, else 0
                 mov     arg_size,cl   ; Size of argument text in bytes
                 ret                   ; Return to caller
LR_args          endp

:endif
;--------------- State machine motor -----------------------------------------
;
;  Runs the state machine until it halts normally, or due to an error.  If
;  there is an error, sets feedback to 1.  Fatal errors cause a message to
;  be displayed.

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!   _LR_state = 0;                      /*  First state is always zero       */
!   initialise_the_program ();
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LR_motor         proc    near
                 mov     LR_state,0
                 call    initialise_the_program

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!   while (the_next_event != terminate_event)
!     {
!       _LR_event = the_next_event;
!       if (_LR_event >= $events OR _LR_event < 0)
!         {
!           printf ("Invalid event %d in state %d\n", _LR_event, _LR_state);
!           break;
!         }
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LR_motorLoop     label   near
                 cmp     the_next_event,terminate_event
                 jne     LR_motorLoop1
                 jmp     LR_motorExit  ; Finished - end state machine
LR_motorLoop1    label   near
:if check
                 ;       Check that event is not >= nbr-events or < 0
                 cmp     the_next_event,$events
                 jge     LR_motorLoop2
                 cmp     the_next_event,0
                 jge     LR_motorLoop3
LR_motorLoop2:   jmp     LR_errorBad   ; Show message and abort
LR_motorLoop3    label   near
:endif

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       _LR_index  = _LR_action [_LR_state][_LR_event];
!       _LR_savest = _LR_state;
!       /*  If no action for this event, try the defaults state              */
!       if (_LR_index == 0)
!         {
!           _LR_state = _LR_defaults_state;
!           _LR_index = _LR_action [_LR_state][_LR_event];
!         }
!       if (_LR_index == 0)
!         {
!           printf ("Bad event %d in state %d\n", _LR_event, _LR_state);
!           break;
!         }
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 LR_move LR_event,the_next_event
                 call    LR_get_action ; Get action for state/event
                 LR_move LR_savest,LR_state
:if defaults
                 ; If no action for this event, try the defaults state
                 cmp     LR_index,0
                 jne     LR_indexOkay
                 mov     LR_state,LR_defaults
                 call    LR_get_action ; Get action for state/event
LR_indexOkay     label   near
:endif
:if check
                 cmp     LR_index,0    ; Is event valid in state?
                 jnz     LR_indexOkay1 ; Yes - continue
                 jmp     LR_errorBad   ; No - show message and exit
LR_indexOkay1    label   near
:endif check

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       Animate ("\n%s:\n",      _LR_sname [_LR_state]);
!       Animate ("    (--)%s\n", _LR_ename [_LR_event]);
!       the_next_event          = _LR_null_event;
!       the_exception_event     = _LR_null_event;
!       exception_raised        = FALSE;
!       _LR_vecptr = _LR_vector [_LR_index];
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:if animate
                 lea     si,newline    ;
                 call    echo          ; echo '\n'
                 mov     bx,LR_state   ; BX = state number
                 shl     bx,1          ; Address word table
                 mov     si,LR_sname[BX]
                 call    echo          ; and echo state name
                 lea     si,LR_eventis ;
                 call    echo          ; echo ':\n    (--) '
                 call    LR_echo_ename ; echo LR_event name
                 call    LR_newline    ; echo '\n' and pause
:endif
                 mov     the_next_event,LR_null_event
                 mov     the_exception_event,LR_null_event
                 mov     exception_raised,0
                 ; set-up SI to point to first module number in vector
                 mov     bx,LR_index
                 shl     bx,1          ; Each offset is two bytes
                 mov     bx,LR_vectoroffset[bx]
                 mov     LR_index,bx

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       for ever
!         {
!           if ((*_LR_vecptr == _LR_stop_action)
!           OR (exception_raised))
!               break;
!           Animate ("          + %s\n", _LR_mname [*_LR_vecptr]);
!           (*_LR_module [*_LR_vecptr++]) ();
!         }
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LR_vectorNext    label   near
                 mov     bx,LR_index   ; LR_index points into vector
                 mov     bl,LR_vector[bx]
                 xor     bh,bh         ; BX is number of next module
                 cmp     bx,LR_stop_action
                 je      LR_vectorStop ; Done if hit LR_stop_action
                 cmp     exception_raised,1
                 je      LR_vectorStop ; Done if exception was raised
                 shl     bx,1          ; Each module address is 2 bytes
:if animate
                 lea     si,LR_moduleis
                 call    echo          ; echo '          + '
                 mov     si,LR_mname[BX]
                 call    echo          ; echo module name
                 call    LR_newline    ; echo '\n' and pause
:endif
                 call    W LR_module[bx]
                 inc     LR_index      ; Bump LR_index
                 jmps    LR_vectorNext ;   and do next module
LR_vectorStop    label   near

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       if (exception_raised)
!         {
!           if (the_exception_event != _LR_null_event)
!               _LR_event = the_exception_event;
!           the_next_event = _LR_event;
!           Animate ("    (=>) %s\n", _LR_ename [_LR_event]);
!         }
!       else
!           _LR_state = _LR_nextst [_LR_state][_LR_event];
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 cmp     exception_raised,1
                 jne     LR_set_nextst
:if animate
                 lea     si,LR_raisedis
                 call    echo          ; echo '    (=>) '
                 call    LR_echo_ename ; echo LR_event name
                 call    LR_newline    ; echo '\n' and pause
:endif
                 cmp     the_exception_event,LR_null_event
                 je      LR_exception
                 LR_move LR_event,the_exception_event
LR_exception     label   near
                 LR_move the_next_event,LR_event
                 jmps    LR_have_state

LR_set_nextst    label   near          ; Set new state if no exception
                 mov     ax,$events    ; Compute AX = LR_state
                 mul     LR_state      ;            * nbr-events
                 add     ax,LR_event   ;            + LR_event
                 xchg    ax,bx         ; Get result into BX
                 LR_load LR_state,LR_nextst[bx]
LR_have_state    label   near

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       if (_LR_state == _LR_defaults_state)
!           _LR_state = _LR_savest;
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 cmp     LR_state,LR_defaults
                 jne     LR_not_defaults
                 LR_move LR_state,LR_savest
LR_not_defaults  label   near

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!       if (the_next_event == _LR_null_event)
!         {
!           get_external_event ();
!           if (the_next_event == _LR_null_event)
!             {
!               printf ("No event set after event %d in state %d\n",
!                   _LR_event, _LR_state);
!               break;
!         }
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 cmp     the_next_event,LR_null_event
                 jne     LR_eventset
                 call    get_external_event
                 cmp     the_next_event,LR_null_event
                 je      LR_errorNull  ; Show message and abort
LR_eventset      label   near

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!     }          /*  while (the_next_event != terminate_event)        */
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                 jmp     LR_motorLoop

:if check
LR_errorNull     label near            ;
                 lea     si,LR_emsg3   ; echo 'No event set after event'
                 jmps    LR_error2     ; ... go do rest

LR_errorBad      label   near          ;
                 lea     si,LR_emsg1   ;
LR_error2:       call    echo          ; echo 'Invalid event '
                 mov     ax,LR_event   ;
                 call    echonum       ; echo LR_event
                 lea     si,LR_emsg2   ;
                 call    echo          ; echo 'in state '
                 mov     ax,LR_state   ;
                 call    echonum       ; echo LR_state
                 lea     si,newline    ;
                 call    echo          ; echo '\n'
:endif

LR_error         label   near          ; Error in dialog
                 mov     feedback,1    ;   Signal error

!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!   return (feedback);
!- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LR_motorExit     label   near          ; Finished with dialog
                 ret                   ;   Return to caller
LR_motor         endp


;--------------- LR Get Action -----------------------------------------------
;   LR_index = LR_action [LR_state][LR_event]
;
LR_get_action    proc    near
                 mov     ax,$events    ; Compute AX = LR_state
                 mul     LR_state      ;            * nbr-events
                 add     ax,LR_event   ;            + LR_event
                 xchg    ax,bx         ; Get result into BX
                 LR_load LR_index,LR_action[bx]
                 ret
LR_get_action    endp

:if animate
;--------------- Animation subroutines ---------------------------------------

LR_echo_ename    proc    near          ; print name of current event
                 mov     bx,LR_event   ; BX = event number
                 shl     bx,1          ; Address word table
                 mov     si,LR_ename[BX]
                 jmps    echo          ; and echo event name
LR_echo_ename    endp

LR_newline       proc    near          ; print end of line and pause
                 lea     si,newline    ;
                 call    echo          ;   echo '\n'
                 jmp     pause         ;   wait for keystroke
LR_newline       endp
:endif

;--------------- Echo --------------------------------------------------------
;  Prints the null-terminated message pointed at DS:SI.  The sequence '\n' is
;  treated as a new-line.  Does not change any registers except the flags.
;
echo             proc    near
                 pushr   <ax,si>       ; Save registers
echoNext:        lodsb                 ; Get next character at DS:SI
                 cmp     al,0          ; A zero byte
                 jz      echoExit      ;   marks the end of the string
                 cmp     al,'\'        ; Do we have '\'?
                 jne     echoOkay      ; no - go echo it
                 xchg    al,ah         ;   save backslash
                 lodsb                 ;   get char after backslash
                 cmp     al,'n'        ;   do we have '\n' after all?
                 jne     echoBoth      ;   no - output AH and AL
                 mov     ax,0A0Dh      ;   yes - prepare CRLF (reversed)
echoBoth:        xchg    al,ah         ;   swap to get right order
                 call    echoch        ;   output first of two chars
                 mov     al,ah         ;   get second
                 cmp     al,0          ;
                 je      echoExit      ;   if zero, we have end of line
echoOkay:        call    echoch        ;   else echo it
                 jmps    echoNext      ;   and loop to do next
echoExit:        popr    <si,ax>       ; Restore registers
                 ret                   ; Return to caller
echo             endp

;--------------- Echo character ----------------------------------------------
;  Prints the character in AL.  Calls the BIOS tty display functions.
;  Does not change any registers except the flags.
;
echoch           proc    near          ; AL = character to echo
                 pushr   <ax,dx>       ; Save work registers
                 mov     dl,al         ; DL = character to echo
                 mov     ah,02h        ; Function 02: echo character
                 int     21h           ; Call DOS
                 popr    <dx,ax>       ; Restore work registers
                 ret                   ; Return to caller
echoch           endp

;--------------- Echo number -------------------------------------------------
;  Displays the value in AX as a signed decimal number with one leading space,
;  and optional sign.  Does not change any registers except the flags.
;
                 DATA_SEG
LR_sign          db      0             ; Sign character, if any

                 CODE_SEG
echonum          proc    near          ; AX = value to display, -32768..32767
                 pushr   <ax,bx,cx,dx> ; Save work registers
                 mov     LR_sign,' '   ; Clear sign character
                 cmp     ax,0          ; If < zero,
                 jge     echonumFlat   ;
                 xor     ax,0FFFFh     ; Get negative of number
                 inc     ax            ;
                 mov     LR_sign,'-'   ; Sign is minus
echonumFlat:     mov     bx,10         ; Dividend is 10
                 mov     cx,5          ; Repeat 5 times
echonumDiv:      xor     dx,dx         ;   Clear DX
                 div     bx            ;   Divide DX:AX by 10
                 push    dx            ;   Save remainder on stack
                 loop    echonumDiv    ; Until no more digits
                 mov     al,LR_sign    ;
                 cmp     al,' '        ; Print sign if wanted
                 je      echonumPrt    ;
                 call    echoch        ;
echonumPrt:      xor     dx,dx         ; Skip leading zeroes while DX=0
                 mov     cx,5          ; Repeat 5 times
echonumPop:      pop     ax            ;   Get result from stack
                 cmp     ax,0          ;   Is it zero?
                 jnz     echonumOut    ;   No - echo digit
                 cmp     dx,0          ;   If not leading zeroes,
                 jne     echonumOut    ;     echo digit
                 cmp     cx,1          ;   If 0 is not last digit
                 jne     echonumSkip   ;     skip until finished
echonumOut:      add     ax,'0'        ;   Turn into ASCII digit
                 call    echoch        ;     and echo to screen
                 inc     dx            ;   No more leading zeroes
echonumSkip:     loop    echonumPop    ; Until no more digits
                 mov     al,' '        ; Echo one trailing space
                 call    echoch        ;
                 popr    <dx,cx,bx,ax> ; Restore work registers
                 ret                   ; Return to caller
echonum          endp

;--------------- Pause -------------------------------------------------------
;  Waits for a keystroke; if [Esc] pressed, exits program
;  Does not change any registers except the flags.
;
pause            proc    near
                 pushr   <ax>
                 mov     ah,00h        ; Function 00h: wait for key
                 int     16h           ; Do BIOS keyboard interrupt
                 cmp     al,27
                 jne     pause_1
                 mov     ah,4Ch        ;   Function 4Ch: terminate program
                 int     21h           ;     with exit code in AL
pause_1:         popr    <ax>
                 ret                   ; Return to caller
pause            endp


;-- Static areas -------------------------------------------------------------
;   All event and state numbers are 8 bits wide
;   All counters and indices are 16 bits wide
;
:set row_first="%ld"
:set row_after=",%ld"
:set row_width=48
:set row_clean=1                       ; Clean-up overflow rows
                 DATA_SEG

LR_nextst        label   byte          ; State/event gives next state
:do nextst
                 db      $row
:    do overflow
                 db      $row
:    enddo
:enddo

LR_action        label   byte          ; State/event gives action
:set array_base=1                      ; Zero indicates invalid transition
:do action
                 db      $row
:    do overflow
                 db      $row
:    enddo
:enddo
:set array_base=0

LR_vectoroffset  label   word          ; Action gives address into vector table
                 dw      0             ; Table starts at 1, not 0
:do vector
                 dw      $offset
:enddo

LR_vector        label   byte          ; Address gives vector of module numbers
:do vector
:  if "$row" = ""
                 db      255
:  else
                 db      $row,255
:  endif
:enddo

LR_module        label   word          ; Module number gives address of module
:do module
                 dw      $name
:enddo

:if animate
LR_eventis       db      ':\n    (--) ',0
LR_moduleis      db      '          + ',0
LR_raisedis      db      '    (=>) ',0

:push $style
:option -style=normal
:do module
LR_mname$number  db      '$name',0
:enddo
LR_mname         label   word          ; Table of module names
:do module
                 dw      LR_mname$number
:enddo

:do state
LR_sname$number  db      '$name',0
:enddo
LR_sname         label   word          ; Table of state names
:do state
                 dw      LR_sname$number
:enddo

:do event
LR_ename$number  db      '$name',0
:enddo
LR_ename         label   word          ; Table of event names
:do event
                 dw      LR_ename$number
:enddo
:pop $style
:option -style=$style

:endif
:if check
LR_emsg1         db      'Invalid event ',0
LR_emsg2         db      'in state ',0
LR_emsg3         db      'No event set after event ',0
:endif
newline          db      '\n',0

;-- Variables used by dialog interpreter -------------------------------------
;   All event and state variables are 16 bits wide

LR_event         dw      0             ; Event for state transition
LR_state         dw      0             ; Current dialog state
LR_savest        dw      0             ; Saved dialog state
LR_index         dw      0             ; Index into vector table

the_next_event   dw      0             ; Next event from module
the_exception_event dw   0             ; Exception event from module
exception_raised db      0             ; 1 if exception raised
feedback         db      0             ; Return code to system
:if "$model" != "lsub"                 ; Don't need arg parser in subroutines
arg_text         db      128 dup(0)    ; Command line arguments
arg_size         db      0             ; Size of arguments (0 = none)
arg_help         db      0             ; 1 if /? specified, else 0
:endif
:close
