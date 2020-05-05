/*---------------------------------------------------------------------------*
 *  smtsock.d - LIBERO dialog data definitions for smtsock.c.                *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *  Schema file used: smtschm.c.                                             *
 *---------------------------------------------------------------------------*/

/*- Symbolic constants and event numbers ------------------------------------*/

#define _LR_STOP                        0xFFFFL
#define _LR_NULL_EVENT                  -2
#define _LR_NULL_STATE                  -1
#define terminate_event                 -1
#define activity_event                  0
#define close_event                     1
#define closed_event                    2
#define connect_event                   3
#define error_event                     4
#define exception_event                 5
#define fatal_event                     6
#define finished_event                  7
#define flush_event                     8
#define incomplete_event                9
#define input_event                     10
#define no_active_request_event         11
#define ok_event                        12
#define output_event                    13
#define read_event                      14
#define readh_event                     15
#define readr_event                     16
#define readrh_event                    17
#define shutdown_event                  18
#define timeout_event                   19
#define write_event                     20
#define writeh_event                    21
#define _LR_STATE_after_init            0
#define _LR_STATE_getting_event         1
#define _LR_STATE_socket_activity       2
#define _LR_STATE_after_activity        3
#define _LR_STATE_defaults              4
#define _LR_defaults_state              4


/*- Function prototypes and macros ------------------------------------------*/

#ifndef MODULE
#define MODULE  static void             /*  Libero dialog modules            */
#endif

MODULE initialise_the_thread        (THREAD *thread);
MODULE schedule_non_blocking_select (THREAD *thread);
MODULE terminate_the_thread         (THREAD *thread);
MODULE create_read_request          (THREAD *thread);
MODULE create_huge_read_request     (THREAD *thread);
MODULE create_read_repeat_request   (THREAD *thread);
MODULE create_huge_read_repeat_request (THREAD *thread);
MODULE create_write_request         (THREAD *thread);
MODULE create_huge_write_request    (THREAD *thread);
MODULE create_input_request         (THREAD *thread);
MODULE create_output_request        (THREAD *thread);
MODULE create_connect_request       (THREAD *thread);
MODULE create_close_request         (THREAD *thread);
MODULE flush_socket_requests        (THREAD *thread);
MODULE find_timed_out_request       (THREAD *thread);
MODULE reply_timeout_to_request     (THREAD *thread);
MODULE check_first_socket_activity  (THREAD *thread);
MODULE generate_request_type_event  (THREAD *thread);
MODULE write_data_to_socket         (THREAD *thread);
MODULE reply_ok_to_request          (THREAD *thread);
MODULE check_next_socket_activity   (THREAD *thread);
MODULE read_data_from_socket        (THREAD *thread);
MODULE close_the_socket             (THREAD *thread);
MODULE confirm_socket_connected     (THREAD *thread);
MODULE process_socket_exception     (THREAD *thread);
MODULE reply_closed_to_all_requests (THREAD *thread);
MODULE reply_error_to_all_requests  (THREAD *thread);
MODULE request_shutdown             (THREAD *thread);
MODULE destroy_all_requests         (THREAD *thread);

#define the_next_event              _the_next_event
#define the_exception_event         _the_exception_event
#define the_external_event          _the_external_event
#define exception_raised            _exception_raised
#define io_completed                _io_completed


/*- Static areas shared by all threads --------------------------------------*/

static word _LR_nextst [5][22] =
{
    { 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0 },
    { 2,1,0,1,0,0,0,0,1,0,1,0,0,1,1,1,1,1,0,1,1,1 },
    { 0,2,0,3,0,2,0,0,0,0,2,1,0,2,3,0,0,0,0,0,3,0 },
    { 0,0,2,0,2,0,0,2,0,2,0,0,0,0,0,0,0,0,0,0,0,0 },
    { 0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0 }
};

static word _LR_action [5][22] =
{
    { 0,0,0,0,2,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0 },
    { 15,12,0,11,0,0,0,0,13,0,9,0,0,10,3,4,5,6,0,14,7,8 },
    { 0,19,0,20,0,21,0,0,0,0,17,1,0,17,18,0,0,0,0,0,16,0 },
    { 0,0,23,0,24,0,0,17,0,22,0,0,0,0,0,0,0,0,0,0,0,0 },
    { 0,0,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,26,0,0,0 }
};

#if (defined (SMT_PROFILE))
static word _LR_count [28];
static long _LR_time  [28];
static word _LR_flow  [5][22];
#endif

static word _LR_offset [] =
{
    0,
    0,
    2,
    4,
    6,
    8,
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    26,
    29,
    32,
    34,
    38,
    40,
    44,
    46,
    50,
    53,
    57,
    61,
    65
};

static word _LR_vector [] =
{
    0,_LR_STOP,
    1,_LR_STOP,
    2,_LR_STOP,
    3,_LR_STOP,
    4,_LR_STOP,
    5,_LR_STOP,
    6,_LR_STOP,
    7,_LR_STOP,
    8,_LR_STOP,
    9,_LR_STOP,
    10,_LR_STOP,
    11,_LR_STOP,
    12,_LR_STOP,
    13,14,_LR_STOP,
    15,16,_LR_STOP,
    17,_LR_STOP,
    18,19,16,_LR_STOP,
    20,_LR_STOP,
    21,19,16,_LR_STOP,
    22,_LR_STOP,
    23,19,16,_LR_STOP,
    19,16,_LR_STOP,
    24,19,16,_LR_STOP,
    25,19,16,_LR_STOP,
    26,27,1,_LR_STOP,
    27,1,_LR_STOP
};

static HOOK *_LR_module [28] = {
    schedule_non_blocking_select,
    terminate_the_thread,
    create_read_request,
    create_huge_read_request,
    create_read_repeat_request,
    create_huge_read_repeat_request,
    create_write_request,
    create_huge_write_request,
    create_input_request,
    create_output_request,
    create_connect_request,
    create_close_request,
    flush_socket_requests,
    find_timed_out_request,
    reply_timeout_to_request,
    check_first_socket_activity,
    generate_request_type_event,
    write_data_to_socket,
    reply_ok_to_request,
    check_next_socket_activity,
    read_data_from_socket,
    close_the_socket,
    confirm_socket_connected,
    process_socket_exception,
    reply_closed_to_all_requests,
    reply_error_to_all_requests,
    request_shutdown,
    destroy_all_requests
};

#if (defined (DEBUG))
static char *_LR_mname [28] =
{
     "Schedule-Non-Blocking-Select",
     "Terminate-The-Thread",
     "Create-Read-Request",
     "Create-Huge-Read-Request",
     "Create-Read-Repeat-Request",
     "Create-Huge-Read-Repeat-Request",
     "Create-Write-Request",
     "Create-Huge-Write-Request",
     "Create-Input-Request",
     "Create-Output-Request",
     "Create-Connect-Request",
     "Create-Close-Request",
     "Flush-Socket-Requests",
     "Find-Timed-Out-Request",
     "Reply-Timeout-To-Request",
     "Check-First-Socket-Activity",
     "Generate-Request-Type-Event",
     "Write-Data-To-Socket",
     "Reply-Ok-To-Request",
     "Check-Next-Socket-Activity",
     "Read-Data-From-Socket",
     "Close-The-Socket",
     "Confirm-Socket-Connected",
     "Process-Socket-Exception",
     "Reply-Closed-To-All-Requests",
     "Reply-Error-To-All-Requests",
     "Request-Shutdown",
     "Destroy-All-Requests"
};

static char *_LR_sname [5] =
{
     "After-Init",
     "Getting-Event",
     "Socket-Activity",
     "After-Activity",
     "Defaults"
};

static char *_LR_ename [22] =
{
     "Activity-Event",
     "Close-Event",
     "Closed-Event",
     "Connect-Event",
     "Error-Event",
     "Exception-Event",
     "Fatal-Event",
     "Finished-Event",
     "Flush-Event",
     "Incomplete-Event",
     "Input-Event",
     "No-Active-Request-Event",
     "Ok-Event",
     "Output-Event",
     "Read-Event",
     "Readh-Event",
     "Readr-Event",
     "Readrh-Event",
     "Shutdown-Event",
     "Timeout-Event",
     "Write-Event",
     "Writeh-Event"
};
#else
static char *_LR_mname [28] =
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
     "27"
};

static char *_LR_sname [5] =
{
     "0",
     "1",
     "2",
     "3",
     "4"
};

static char *_LR_ename [22] =
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
     "21"
};
#endif
