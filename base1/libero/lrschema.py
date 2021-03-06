!============================================================================*
!                                                                            *
!   lrschema.py - Schema for Python programming                              *
!                                                                            *
!   Written:    01/12/12  Glenn Williams  <gloonie@netscape.net>             *
!   Revised:    01/12/12                                                     *
!                                                                            *
!   Usage:      Generates a Python module                                    *
!                                                                            *
!               Accepts these options:                                       *
!               -opt:stack_max=nnn - size of subdialog stack (20)            *
!               -opt:template=xxxx - template file (template.pyt)            *
!                                                                            *
!   Copyright (c) 1991-2009 iMatix Corporation                               *
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
!   <HEADER>                    - program header comment
!   <DATA>                      - data definitions
!   <Initialise-The-Program>    - in Initialise-The-Program
!   <Get-External-Event>        - in Get-External-Event
!   <Any-Dialog-Module>         - any dialog module
!
:declare string $template = "template.py"
:if not exist $source.py
:echo "lr I: Creating skeleton program $source.py..."
:output $source.py
#*===========================================================================*
#*                                                                           *
#*  $source.py     description...                                            *
#*                                                                           *
#*  Written:       $date      $author                                        *
#*  Revised:       $date                                                     *
#*                                                                           *
:include optional $template "<HEADER>" "<END>"
#*  Skeleton generated by LIBERO $version on $fulldate, $time.               *
#*===========================================================================*

:include optional $template "<DATA>" "<END>"

import $source\d

#%START MODULE
#--------------------------  INITIALISE THE PROGRAM  ------------------------#

def $"initialise_the_program" ():
    global $"the_next_event", $"the_exception_event"
    $"the_next_event" = $"ok_event"
:include optional $template "<Initialise-The-Program>" "<END>"

#----------------------------  GET EXTERNAL EVENT ---------------------------#

def $"get_external_event" ():
    global $"the_next_event", $"the_exception_event"
:include optional $template "<Get-External-Event>" "<END>"
    pass

#%END MODULE
#%MAIN
#--------------------- when executing as a batch program -------------------#
if __name__ == '__main__':
    feedback = run_fsm()
:include optional $template "<main>" "<END>"
:close
:endif
:output $source.001
:include $source.py "" "#%START MODULE"
:close
:output $source.002
:include $source.py "#%MAIN" ""
:close
:output $source.003
#%START MODULE
:include $source.py "#%START MODULE" "#%END MODULE"
:close
:echo "lr I: Creating and updating module stubs in $source.py..."
:internal $"initialise_the_program" ():  
:internal $"get_external_event" (): 
!   Generate stubs for all modules not yet defined in source file
:set module_line="def %s ():"
:set stub_first="#"
:set stub_between="-"
:set stub_last="#"
:do stubs $source.003

def $name ():
    global $"the_next_event", $"the_exception_event"
:include optional $template "<$module_name>" "<END>"
    pass

:enddo stubs
:extend $source.003
#%END MODULE
:close
:output $source\d.py
#*===========================================================================*
#*                                                                           *
#*  $source\d.py    FSM Dialog class for $source.py                          *
#*                                                                           *
#*  Written:       $date      $author                                        *
#*  Revised:       $date                                                     *
#*                                                                           *
#*  Generated by LIBERO $version on $fulldate, $time.                        *
#*===========================================================================*

class $source\FSM:
    def __init__(self, ev):
        self.ev = ev
        self.modules = {}

:if module "Dialog-Call"
:  if not event "Return"
:     echo "lr E: You must define the 'Return' event"
:     exit 1
:  endif
:  declare int $stack_max = 20
        self._LR_stack            = []
        self._LR_stack_size       = 0     # Subdialog stack size; 0=empty
:endif
        #- Symbolic constants and event numbers -------------------
        self._LR_STOP             = 0xFFFF
        self._LR_NULL_EVENT       = -2
:do state
        self._LR_STATE_$name      = $number
:enddo
:if defaults
        self._LR_defaults_state  = $defaults
:endif
        #- Static areas ----------------------------------------------

        self._LR_nextst = [
:do nextst
:  if $overflow = 0
        ( $row )$comma
:  else
        ( $row
:    do overflow
          $row
:    enddo
        )$comma
:  endif
:enddo
                          ]

        self._LR_action = [
:set array_base=1
:do action
:  if $overflow = 0
        ( $row )$comma
:  else
        ( $row
:    do overflow
          $row
:    enddo
        )$comma
:  endif
:enddo
                          ]

:set array_base=0
        self._LR_vector = [
        (0,),
:do vector
:  if "$row" = ""
        (self._LR_STOP)$comma
:  else
        ($row,self._LR_STOP)$comma
:  endif
:enddo
                          ]
:if animate

:push $style
:option -style=normal
        self._LR_mname =  [
:  do module
                          "$name"$comma
:  enddo
                          ]

        self._LR_sname =  [
:  do state
                           "$name"$comma
:  enddo
                          ]

        self._LR_ename =  [
:  do event
                           "$name"$comma
:  enddo
                          ]
:pop $style
:option -style=$style
:endif
    # Add modules to dictionary
    def add_modules(self, name, module):
        self.modules[name] = module

    # Dialog interpreter starts here ---------------------

    def run (self):
        # Local variables
        feedback = 0
        index = 0
        next_module = 0

        self._LR_state = 0              # First state is always zero
:if module "Dialog-Call"
        self._LR_stack_size = 0         # Clear subdialog stack
        self._LR_stack = []
:endif
        self.modules['$"initialise_the_program"'] ()
        while self.ev.$"the_next_event" != self.ev.$"terminate_event":
            self._LR_event = self.ev.$"the_next_event"
:if check
            if self._LR_event >= $events or self._LR_event < 0:
                buffer  = "State " + `self._LR_state` + " - event " + `self._LR_event`
                buffer += " is out of range"
                print buffer
                break
:endif
            self._LR_savest = self._LR_state
            self._LR_index  = self._LR_action [self._LR_state][self._LR_event]
:if defaults
            # If no action for this event, try the defaults state
            if self._LR_index == 0:
                self._LR_state = self._LR_defaults_state
                self._LR_index = self._LR_action [self._LR_state][self._LR_event]
:endif
:if animate
            print self._LR_sname [self._LR_state] + ':'
            print "    (--) " + self._LR_ename [self._LR_event]
:endif
:if check
            if self._LR_index == 0:
                buffer  = "State " + `self._LR_state` + " - event " + `self._LR_event`
                buffer += " is not accepted"
                print buffer
                break
            self.ev.$"the_next_event" = self._LR_NULL_EVENT
:endif
            self.ev.$"the_exception_event" = self._LR_NULL_EVENT
            self.ev.$"exception_raised" = 0
            next_module = 0

            while 1:
                index = self._LR_vector [self._LR_index][next_module]
                if index == self._LR_STOP or self.ev.$"exception_raised":
                    break
:if animate
                print "          + " + self._LR_mname [index]
:endif
                try:
                    self.modules[`index`] ()
                except:
                    print "invocation error for module: ", index 
                    break
                next_module = next_module + 1

            if self.ev.$"exception_raised":
                if self.ev.$"the_exception_event" != self._LR_NULL_EVENT:
                    self._LR_event = self.ev.$"the_exception_event"
                self.ev.$"the_next_event" = self._LR_event
:if animate
                print "    (=>) " + self._LR_ename [self._LR_event]
:endif
            else:
                self._LR_state = self._LR_nextst [self._LR_state][self._LR_event]

:if defaults
            if self._LR_state == self._LR_defaults_state:
                self._LR_state = self._LR_savest
:endif
            if self.ev.$"the_next_event" == self._LR_NULL_EVENT:
                self.modules['$"get_external_event"'] ()
:if check
                if self.ev.$"the_next_event" == self._LR_NULL_EVENT:
                    buffer  = "No event set after event " + `self._LR_event`
                    buffer += " in state " + `self._LR_state`
                    print buffer
                    break
:endif
        return $"feedback"

    #- Standard dialog routines ---------------------------------------

    def $"raise_exception" (self, event):
        self.ev.$"exception_raised" = 1
        if event >= 0:
            self.ev.$"the_exception_event" = event

:if module "Dialog-Call"
    def $"dialog_call" (self)
        if self._LR_stack_size < $stack_max:
            self._LR_stack [self._LR_stack_size] = self._LR_state
            self._LR_stack = self._LR_stack_size + 1
        else:
            print "State " + `self._LR_state` + " - Dialog-Call overflow"
            exit 1

    def $"dialog_return" (self)
        if self._LR_stack_size > 0:
            self._LR_stack_size = self._LR_stack_size - 1
            self._LR_state = self._LR_stack [self._LR_stack_size]
            self.$"raise_exception" (self.ev.$"return_event")
        else:
            print "State " + `self._LR_state` + " - Dialog-Return underflow"
        exit 1
:endif
:close
:echo "lr I: Building $source.py..."
:output $source.py
:include $source.001
:delete $source.001
:include $source.003
:delete $source.003
:echo "lr I: regenerating local routines..."
# class used to pass globals between modules and fsm 
class globaliser:
    def __init__(self):
        globals()['$"the_next_event"']       =  0 # set to the next event in modules
        globals()['$"exception_raised"']     =  0 # set to 1 when raising an exception
        globals()['$"the_exception_event"']  =  0 # set to the event to be executed
        globals()['$"terminate_event"']      = -1 # to terminate program 
:do event
        globals()['$name']                   =  $number # module from libero dialog $source.py
:enddo
:if module "Dialog-Call"
        globals()['$"return_event"']         =  0 # event to execute after return from sub-dialog
:endif

    def __getattr__(self, name):
        return globals()[name]
    def __setattr__(self,name,value):
        globals()[name]=value

#----------------------  Execute the state machine  ---------------------#
def $"run_fsm" ():
    ev = globaliser()
    fsm = $source\d.$source\FSM(ev)
    fsm.add_modules('$"initialise_the_program"', $"initialise_the_program")   
    fsm.add_modules('$"get_external_event"', $"get_external_event")   
:if module "Dialog-Call"
    fsm.add_modules($"dialog_call", $"dialog_call")   
    fsm.add_modules($"dialog_return", $"dialog_return")   
:endif
:do module
    fsm.add_modules('$number',$name)
:enddo
    feedback = fsm.run()
    return feedback
#%MAIN
:include $source.002
:delete $source.002
:close
