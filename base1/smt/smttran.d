/*---------------------------------------------------------------------------*
 *  smttran.d - LIBERO dialog data definitions for smttran.c.                *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *  Schema file used: smtschm.c.                                             *
 *---------------------------------------------------------------------------*/

/*- Symbolic constants and event numbers ------------------------------------*/

#define _LR_STOP                        0xFFFFL
#define _LR_NULL_EVENT                  -2
#define _LR_NULL_STATE                  -1
#define terminate_event                 -1
#define alarm_event                     0
#define clear_pipes_event               1
#define commit_event                    2
#define empty_event                     3
#define end_of_file_event               4
#define error_event                     5
#define exception_event                 6
#define get_block_event                 7
#define get_file_event                  8
#define get_huge_event                  9
#define incomplete_event                10
#define master_event                    11
#define ok_event                        12
#define pipe_create_event               13
#define pipe_manager_event              14
#define put_block_event                 15
#define put_file_event                  16
#define put_huge_event                  17
#define read_ok_event                   18
#define readh_ok_event                  19
#define shutdown_event                  20
#define sock_closed_event               21
#define sock_error_event                22
#define sock_read_closed_event          23
#define sock_readh_closed_event         24
#define write_ok_event                  25
#define _LR_STATE_after_init            0
#define _LR_STATE_getting_event         1
#define _LR_STATE_file_buffer_out       2
#define _LR_STATE_file_buffer_in        3
#define _LR_STATE_refresh_pipes         4
#define _LR_STATE_defaults              5
#define _LR_STATE_end_thread            6
#define _LR_defaults_state              5


/*- Function prototypes and macros ------------------------------------------*/

#ifndef MODULE
#define MODULE  static void             /*  Libero dialog modules            */
#endif

MODULE initialise_the_thread        (THREAD *thread);
MODULE create_transfer_pipes_table  (THREAD *thread);
MODULE wait_for_pipe_refresh        (THREAD *thread);
MODULE open_file_for_input          (THREAD *thread);
MODULE read_file_data_buffer        (THREAD *thread);
MODULE convert_ascii_to_net_if_reqd (THREAD *thread);
MODULE put_buffer_to_socket         (THREAD *thread);
MODULE open_file_for_output         (THREAD *thread);
MODULE get_buffer_from_socket       (THREAD *thread);
MODULE create_put_block_request     (THREAD *thread);
MODULE process_transfer_requests    (THREAD *thread);
MODULE get_next_event_from_queue    (THREAD *thread);
MODULE create_get_block_request     (THREAD *thread);
MODULE create_put_huge_request      (THREAD *thread);
MODULE create_get_huge_request      (THREAD *thread);
MODULE create_put_file_thread       (THREAD *thread);
MODULE create_get_file_thread       (THREAD *thread);
MODULE create_transfer_pipe         (THREAD *thread);
MODULE destroy_all_transfer_pipes   (THREAD *thread);
MODULE okay_if_no_requests_left     (THREAD *thread);
MODULE regenerate_alarm_event       (THREAD *thread);
MODULE update_request_after_write   (THREAD *thread);
MODULE update_request_after_read    (THREAD *thread);
MODULE update_request_after_readh   (THREAD *thread);
MODULE update_request_after_closed  (THREAD *thread);
MODULE update_request_after_read_closed (THREAD *thread);
MODULE update_request_after_readh_closed (THREAD *thread);
MODULE update_request_after_error   (THREAD *thread);
MODULE signal_socket_closed         (THREAD *thread);
MODULE terminate_the_thread         (THREAD *thread);
MODULE signal_socket_error          (THREAD *thread);
MODULE convert_net_to_ascii_if_reqd (THREAD *thread);
MODULE write_file_data_buffer       (THREAD *thread);
MODULE signal_get_file_okay         (THREAD *thread);
MODULE refresh_all_pipes            (THREAD *thread);
MODULE check_thread_type            (THREAD *thread);
MODULE signal_put_file_okay         (THREAD *thread);
MODULE destroy_all_requests         (THREAD *thread);

#define the_next_event              _the_next_event
#define the_exception_event         _the_exception_event
#define the_external_event          _the_external_event
#define exception_raised            _exception_raised
#define io_completed                _io_completed


/*- Static areas shared by all threads --------------------------------------*/

static word _LR_nextst [7][26] =
{
    { 0,0,0,0,0,0,0,0,3,0,0,1,0,0,4,0,2,0,0,0,0,0,0,0,0,0 },
    { 1,1,1,1,0,0,0,1,1,1,0,0,0,1,0,1,1,1,1,1,0,1,1,1,1,1 },
    { 2,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,2,2,0,0,2 },
    { 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,3,3,3,0,0 },
    { 4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
    { 0,0,0,0,5,5,6,0,0,0,0,0,5,0,0,0,0,0,0,0,6,0,0,0,0,0 },
    { 0,0,0,0,0,0,0,0,6,0,0,6,0,0,6,0,6,0,0,0,0,0,0,0,0,0 }
};

static word _LR_action [7][26] =
{
    { 0,0,0,0,0,0,0,0,4,0,0,1,0,0,2,0,3,0,0,0,0,0,0,0,0,0 },
    { 15,12,13,14,0,0,0,6,10,8,0,0,0,11,0,5,9,7,17,18,0,19,22,20
     ,21,16
    },
    { 24,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,25,26,0,0,23 },
    { 28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27,0,0,29,26,30,0,0 },
    { 31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
    { 0,0,0,0,33,34,32,0,0,0,0,0,35,0,0,0,0,0,0,0,32,0,0,0,0,0 },
    { 0,0,0,0,0,0,0,0,34,0,0,36,0,0,37,0,34,0,0,0,0,0,0,0,0,0 }
};

#if (defined (SMT_PROFILE))
static word _LR_count [37];
static long _LR_time  [37];
static word _LR_flow  [7][26];
#endif

static word _LR_offset [] =
{
    0,
    0,
    2,
    4,
    9,
    12,
    16,
    20,
    24,
    28,
    32,
    36,
    39,
    42,
    45,
    47,
    49,
    52,
    55,
    58,
    61,
    64,
    67,
    70,
    74,
    76,
    79,
    82,
    86,
    88,
    91,
    96,
    99,
    101,
    104,
    106,
    107,
    110
};

static word _LR_vector [] =
{
    0,_LR_STOP,
    1,_LR_STOP,
    2,3,4,5,_LR_STOP,
    6,7,_LR_STOP,
    8,9,10,_LR_STOP,
    11,9,10,_LR_STOP,
    12,9,10,_LR_STOP,
    13,9,10,_LR_STOP,
    14,9,10,_LR_STOP,
    15,9,10,_LR_STOP,
    16,10,_LR_STOP,
    17,10,_LR_STOP,
    18,10,_LR_STOP,
    9,_LR_STOP,
    19,_LR_STOP,
    20,9,_LR_STOP,
    21,9,_LR_STOP,
    22,9,_LR_STOP,
    23,9,_LR_STOP,
    24,9,_LR_STOP,
    25,9,_LR_STOP,
    26,9,_LR_STOP,
    3,4,5,_LR_STOP,
    5,_LR_STOP,
    27,28,_LR_STOP,
    29,28,_LR_STOP,
    30,31,7,_LR_STOP,
    7,_LR_STOP,
    32,28,_LR_STOP,
    30,31,32,28,_LR_STOP,
    33,1,_LR_STOP,
    34,_LR_STOP,
    35,28,_LR_STOP,
    28,_LR_STOP,
    _LR_STOP,
    36,28,_LR_STOP,
    17,28,_LR_STOP
};

static HOOK *_LR_module [37] = {
    create_transfer_pipes_table,
    wait_for_pipe_refresh,
    open_file_for_input,
    read_file_data_buffer,
    convert_ascii_to_net_if_reqd,
    put_buffer_to_socket,
    open_file_for_output,
    get_buffer_from_socket,
    create_put_block_request,
    process_transfer_requests,
    get_next_event_from_queue,
    create_get_block_request,
    create_put_huge_request,
    create_get_huge_request,
    create_put_file_thread,
    create_get_file_thread,
    create_transfer_pipe,
    destroy_all_transfer_pipes,
    okay_if_no_requests_left,
    regenerate_alarm_event,
    update_request_after_write,
    update_request_after_read,
    update_request_after_readh,
    update_request_after_closed,
    update_request_after_read_closed,
    update_request_after_readh_closed,
    update_request_after_error,
    signal_socket_closed,
    terminate_the_thread,
    signal_socket_error,
    convert_net_to_ascii_if_reqd,
    write_file_data_buffer,
    signal_get_file_okay,
    refresh_all_pipes,
    check_thread_type,
    signal_put_file_okay,
    destroy_all_requests
};

#if (defined (DEBUG))
static char *_LR_mname [37] =
{
     "Create-Transfer-Pipes-Table",
     "Wait-For-Pipe-Refresh",
     "Open-File-For-Input",
     "Read-File-Data-Buffer",
     "Convert-Ascii-To-Net-If-Reqd",
     "Put-Buffer-To-Socket",
     "Open-File-For-Output",
     "Get-Buffer-From-Socket",
     "Create-Put-Block-Request",
     "Process-Transfer-Requests",
     "Get-Next-Event-From-Queue",
     "Create-Get-Block-Request",
     "Create-Put-Huge-Request",
     "Create-Get-Huge-Request",
     "Create-Put-File-Thread",
     "Create-Get-File-Thread",
     "Create-Transfer-Pipe",
     "Destroy-All-Transfer-Pipes",
     "Okay-If-No-Requests-Left",
     "Regenerate-Alarm-Event",
     "Update-Request-After-Write",
     "Update-Request-After-Read",
     "Update-Request-After-Readh",
     "Update-Request-After-Closed",
     "Update-Request-After-Read-Closed",
     "Update-Request-After-Readh-Closed",
     "Update-Request-After-Error",
     "Signal-Socket-Closed",
     "Terminate-The-Thread",
     "Signal-Socket-Error",
     "Convert-Net-To-Ascii-If-Reqd",
     "Write-File-Data-Buffer",
     "Signal-Get-File-Okay",
     "Refresh-All-Pipes",
     "Check-Thread-Type",
     "Signal-Put-File-Okay",
     "Destroy-All-Requests"
};

static char *_LR_sname [7] =
{
     "After-Init",
     "Getting-Event",
     "File-Buffer-Out",
     "File-Buffer-In",
     "Refresh-Pipes",
     "Defaults",
     "End-Thread"
};

static char *_LR_ename [26] =
{
     "Alarm-Event",
     "Clear-Pipes-Event",
     "Commit-Event",
     "Empty-Event",
     "End-Of-File-Event",
     "Error-Event",
     "Exception-Event",
     "Get-Block-Event",
     "Get-File-Event",
     "Get-Huge-Event",
     "Incomplete-Event",
     "Master-Event",
     "Ok-Event",
     "Pipe-Create-Event",
     "Pipe-Manager-Event",
     "Put-Block-Event",
     "Put-File-Event",
     "Put-Huge-Event",
     "Read-Ok-Event",
     "Readh-Ok-Event",
     "Shutdown-Event",
     "Sock-Closed-Event",
     "Sock-Error-Event",
     "Sock-Read-Closed-Event",
     "Sock-Readh-Closed-Event",
     "Write-Ok-Event"
};
#else
static char *_LR_mname [37] =
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
     "34",
     "35",
     "36"
};

static char *_LR_sname [7] =
{
     "0",
     "1",
     "2",
     "3",
     "4",
     "5",
     "6"
};

static char *_LR_ename [26] =
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
     "25"
};
#endif
