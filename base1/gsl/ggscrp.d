/*---------------------------------------------------------------------------*
 *  ggscrp.d - LIBERO dialog data definitions for ggscrp.c.                  *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *  Schema file used: smtschm.c.                                             *
 *---------------------------------------------------------------------------*/

/*- Symbolic constants and event numbers ------------------------------------*/

#define _LR_STOP                        0xFFFFL
#define _LR_NULL_EVENT                  -2
#define _LR_NULL_STATE                  -1
#define terminate_event                 -1
#define anomaly_event                   0
#define else_event                      1
#define else_if_event                   2
#define end_for_event                   3
#define end_function_event              4
#define end_if_event                    5
#define end_macro_event                 6
#define end_new_event                   7
#define end_of_file_event               8
#define end_scope_event                 9
#define end_template_event              10
#define end_while_event                 11
#define error_event                     12
#define file_event                      13
#define for_event                       14
#define function_event                  15
#define if_event                        16
#define incoming_event                  17
#define macro_event                     18
#define new_event                       19
#define ok_event                        20
#define other_event                     21
#define scope_event                     22
#define shutdown_event                  23
#define template_event                  24
#define terminator_event                25
#define text_event                      26
#define unmatched_control_event         27
#define wait_event                      28
#define while_event                     29
#define _LR_STATE_after_init            0
#define _LR_STATE_parsing               1
#define _LR_STATE_treating              2
#define _LR_STATE_skip_incoming         3
#define _LR_STATE_defaults              4
#define _LR_defaults_state              4


/*- Function prototypes and macros ------------------------------------------*/

#ifndef MODULE
#define MODULE  static void             /*  Libero dialog modules            */
#endif

MODULE initialise_the_thread        (THREAD *thread);
MODULE wait_on_semaphore            (THREAD *thread);
MODULE open_the_file                (THREAD *thread);
MODULE parse_line                   (THREAD *thread);
MODULE open_the_text                (THREAD *thread);
MODULE return_done                  (THREAD *thread);
MODULE terminate_the_thread         (THREAD *thread);
MODULE destroy_script_source_node   (THREAD *thread);
MODULE send_file_error_message      (THREAD *thread);
MODULE save_the_node                (THREAD *thread);
MODULE generate_node_type_event     (THREAD *thread);
MODULE confirm_control_stack_is_empty (THREAD *thread);
MODULE clean_control_stack          (THREAD *thread);
MODULE send_unmatched_control_error (THREAD *thread);
MODULE send_error_message           (THREAD *thread);
MODULE save_loop_start              (THREAD *thread);
MODULE push_the_control             (THREAD *thread);
MODULE set_template_mode            (THREAD *thread);
MODULE set_gsl_mode                 (THREAD *thread);
MODULE set_template_or_gsl_mode     (THREAD *thread);
MODULE pop_if_or_else_control       (THREAD *thread);
MODULE pop_if_control               (THREAD *thread);
MODULE push_if_control              (THREAD *thread);
MODULE pop_for_control              (THREAD *thread);
MODULE get_previous_loop_start      (THREAD *thread);
MODULE pop_scope_control            (THREAD *thread);
MODULE pop_while_control            (THREAD *thread);
MODULE pop_macro_control            (THREAD *thread);
MODULE pop_function_control         (THREAD *thread);
MODULE pop_new_control              (THREAD *thread);
MODULE pop_template_control         (THREAD *thread);
MODULE read_script_line             (THREAD *thread);
MODULE extend_script_line           (THREAD *thread);
MODULE unexpected_eof_error         (THREAD *thread);
MODULE signal_internal_error        (THREAD *thread);
MODULE shutdown_everything          (THREAD *thread);

#define the_next_event              _the_next_event
#define the_exception_event         _the_exception_event
#define the_external_event          _the_external_event
#define exception_raised            _exception_raised
#define io_completed                _io_completed


/*- Static areas shared by all threads --------------------------------------*/

static word _LR_nextst [5][30] =
{
    { 0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0 },
    { 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0 },
    { 0,1,1,1,1,1,1,1,0,1,1,1,0,0,1,1,1,3,1,1,0,1,1,0,1,0,0,1,0,1 },
    { 0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,1,0,0,0,0 },
    { 4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0 }
};

static word _LR_action [5][30] =
{
    { 0,0,0,0,0,0,0,0,0,0,0,0,4,1,0,0,0,0,0,0,0,0,0,0,0,0,2,0,3,0 },
    { 0,0,0,0,0,0,0,0,6,0,0,0,8,0,0,0,0,0,0,0,5,0,0,0,0,0,0,7,0,0 },
    { 0,15,16,17,21,14,20,22,0,18,23,19,0,0,9,12,10,24,11,10,0,25
     ,10,0,13,0,0,26,0,9
    },
    { 0,0,0,0,0,0,0,0,28,0,0,0,0,0,0,0,0,0,0,0,27,0,0,0,0,25,0,0,0
     ,0
    },
    { 29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,0,0,0,0,0
     ,0
    }
};

#if (defined (SMT_PROFILE))
static word _LR_count [35];
static long _LR_time  [35];
static word _LR_flow  [5][30];
#endif

static word _LR_offset [] =
{
    0,
    0,
    4,
    7,
    11,
    16,
    19,
    24,
    29,
    32,
    36,
    39,
    43,
    47,
    51,
    54,
    58,
    62,
    66,
    69,
    73,
    76,
    79,
    82,
    85,
    87,
    89,
    92,
    94,
    99,
    102
};

static word _LR_vector [] =
{
    0,1,2,_LR_STOP,
    3,2,_LR_STOP,
    0,4,5,_LR_STOP,
    6,7,4,5,_LR_STOP,
    8,9,_LR_STOP,
    10,11,4,5,_LR_STOP,
    12,11,4,5,_LR_STOP,
    13,2,_LR_STOP,
    14,15,2,_LR_STOP,
    15,2,_LR_STOP,
    15,16,2,_LR_STOP,
    15,17,2,_LR_STOP,
    15,18,2,_LR_STOP,
    19,2,_LR_STOP,
    20,15,2,_LR_STOP,
    20,21,2,_LR_STOP,
    22,23,2,_LR_STOP,
    24,2,_LR_STOP,
    25,23,2,_LR_STOP,
    26,2,_LR_STOP,
    27,2,_LR_STOP,
    28,2,_LR_STOP,
    29,2,_LR_STOP,
    30,_LR_STOP,
    2,_LR_STOP,
    12,2,_LR_STOP,
    31,_LR_STOP,
    32,11,4,5,_LR_STOP,
    33,34,_LR_STOP,
    5,_LR_STOP
};

static HOOK *_LR_module [35] = {
    wait_on_semaphore,
    open_the_file,
    parse_line,
    open_the_text,
    return_done,
    terminate_the_thread,
    destroy_script_source_node,
    send_file_error_message,
    save_the_node,
    generate_node_type_event,
    confirm_control_stack_is_empty,
    clean_control_stack,
    send_unmatched_control_error,
    send_error_message,
    save_loop_start,
    push_the_control,
    set_template_mode,
    set_gsl_mode,
    set_template_or_gsl_mode,
    pop_if_or_else_control,
    pop_if_control,
    push_if_control,
    pop_for_control,
    get_previous_loop_start,
    pop_scope_control,
    pop_while_control,
    pop_macro_control,
    pop_function_control,
    pop_new_control,
    pop_template_control,
    read_script_line,
    extend_script_line,
    unexpected_eof_error,
    signal_internal_error,
    shutdown_everything
};

#if (defined (DEBUG))
static char *_LR_mname [35] =
{
     "Wait-On-Semaphore",
     "Open-The-File",
     "Parse-Line",
     "Open-The-Text",
     "Return-Done",
     "Terminate-The-Thread",
     "Destroy-Script-Source-Node",
     "Send-File-Error-Message",
     "Save-The-Node",
     "Generate-Node-Type-Event",
     "Confirm-Control-Stack-Is-Empty",
     "Clean-Control-Stack",
     "Send-Unmatched-Control-Error",
     "Send-Error-Message",
     "Save-Loop-Start",
     "Push-The-Control",
     "Set-Template-Mode",
     "Set-Gsl-Mode",
     "Set-Template-Or-Gsl-Mode",
     "Pop-If-Or-Else-Control",
     "Pop-If-Control",
     "Push-If-Control",
     "Pop-For-Control",
     "Get-Previous-Loop-Start",
     "Pop-Scope-Control",
     "Pop-While-Control",
     "Pop-Macro-Control",
     "Pop-Function-Control",
     "Pop-New-Control",
     "Pop-Template-Control",
     "Read-Script-Line",
     "Extend-Script-Line",
     "Unexpected-Eof-Error",
     "Signal-Internal-Error",
     "Shutdown-Everything"
};

static char *_LR_sname [5] =
{
     "After-Init",
     "Parsing",
     "Treating",
     "Skip-Incoming",
     "Defaults"
};

static char *_LR_ename [30] =
{
     "Anomaly-Event",
     "Else-Event",
     "Else-If-Event",
     "End-For-Event",
     "End-Function-Event",
     "End-If-Event",
     "End-Macro-Event",
     "End-New-Event",
     "End-Of-File-Event",
     "End-Scope-Event",
     "End-Template-Event",
     "End-While-Event",
     "Error-Event",
     "File-Event",
     "For-Event",
     "Function-Event",
     "If-Event",
     "Incoming-Event",
     "Macro-Event",
     "New-Event",
     "Ok-Event",
     "Other-Event",
     "Scope-Event",
     "Shutdown-Event",
     "Template-Event",
     "Terminator-Event",
     "Text-Event",
     "Unmatched-Control-Event",
     "Wait-Event",
     "While-Event"
};
#else
static char *_LR_mname [35] =
{
     "0",
     "1",
     "2",
     "3",
     "4",
     "5",
     "6",
     "7",
     "8",
     "9",
     "10",
     "11",
     "12",
     "13",
     "14",
     "15",
     "16",
     "17",
     "18",
     "19",
     "20",
     "21",
     "22",
     "23",
     "24",
     "25",
     "26",
     "27",
     "28",
     "29",
     "30",
     "31",
     "32",
     "33",
     "34"
};

static char *_LR_sname [5] =
{
     "0",
     "1",
     "2",
     "3",
     "4"
};

static char *_LR_ename [30] =
{
     "0",
     "1",
     "2",
     "3",
     "4",
     "5",
     "6",
     "7",
     "8",
     "9",
     "10",
     "11",
     "12",
     "13",
     "14",
     "15",
     "16",
     "17",
     "18",
     "19",
     "20",
     "21",
     "22",
     "23",
     "24",
     "25",
     "26",
     "27",
     "28",
     "29"
};
#endif
