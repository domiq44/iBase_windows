/*---------------------------------------------------------------------------*
 *  smtlog.d - LIBERO dialog data definitions for smtlog.c.                  *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *  Schema file used: smtschm.c.                                             *
 *---------------------------------------------------------------------------*/

/*- Symbolic constants and event numbers ------------------------------------*/

#define _LR_STOP                        0xFFFFL
#define _LR_NULL_EVENT                  -2
#define _LR_NULL_STATE                  -1
#define terminate_event                 -1
#define append_event                    0
#define close_event                     1
#define cycle_event                     2
#define error_event                     3
#define exception_event                 4
#define ok_event                        5
#define open_event                      6
#define plain_event                     7
#define put_event                       8
#define shutdown_event                  9
#define stamp_event                     10
#define _LR_STATE_after_init            0
#define _LR_STATE_before_opening        1
#define _LR_STATE_logfile_open          2
#define _LR_STATE_defaults              3
#define _LR_defaults_state              3


/*- Function prototypes and macros ------------------------------------------*/

#ifndef MODULE
#define MODULE  static void             /*  Libero dialog modules            */
#endif

MODULE initialise_the_thread        (THREAD *thread);
MODULE terminate_the_thread         (THREAD *thread);
MODULE write_text_to_stdout         (THREAD *thread);
MODULE cycle_logfile_if_exists      (THREAD *thread);
MODULE open_thread_logfile          (THREAD *thread);
MODULE append_thread_logfile        (THREAD *thread);
MODULE log_file_output_is_plain     (THREAD *thread);
MODULE close_thread_logfile         (THREAD *thread);
MODULE write_text_to_logfile        (THREAD *thread);
MODULE log_file_output_is_timed     (THREAD *thread);

#define the_next_event              _the_next_event
#define the_exception_event         _the_exception_event
#define the_external_event          _the_external_event
#define exception_raised            _exception_raised
#define io_completed                _io_completed


/*- Static areas shared by all threads --------------------------------------*/

static word _LR_nextst [4][11] =
{
    { 0,0,0,0,0,1,0,0,0,0,0 },
    { 2,0,1,0,0,0,2,1,2,0,0 },
    { 0,1,2,0,0,0,0,2,2,0,2 },
    { 3,3,3,3,3,3,3,3,3,3,3 }
};

static word _LR_action [4][11] =
{
    { 0,0,0,2,0,1,0,0,0,0,0 },
    { 6,0,4,0,0,0,5,7,3,0,0 },
    { 0,11,8,0,0,0,0,7,9,0,10 },
    { 1,1,1,1,2,1,1,1,1,1,1 }
};

#if (defined (SMT_PROFILE))
static word _LR_count [9];
static long _LR_time  [9];
static word _LR_flow  [4][11];
#endif

static word _LR_offset [] =
{
    0,
    0,
    1,
    3,
    5,
    7,
    9,
    11,
    13,
    17,
    19,
    21
};

static word _LR_vector [] =
{
    _LR_STOP,
    0,_LR_STOP,
    1,_LR_STOP,
    2,_LR_STOP,
    3,_LR_STOP,
    4,_LR_STOP,
    5,_LR_STOP,
    6,2,3,_LR_STOP,
    7,_LR_STOP,
    8,_LR_STOP,
    6,_LR_STOP
};

static HOOK *_LR_module [9] = {
    terminate_the_thread,
    write_text_to_stdout,
    cycle_logfile_if_exists,
    open_thread_logfile,
    append_thread_logfile,
    log_file_output_is_plain,
    close_thread_logfile,
    write_text_to_logfile,
    log_file_output_is_timed
};

#if (defined (DEBUG))
static char *_LR_mname [9] =
{
     "Terminate-The-Thread",
     "Write-Text-To-Stdout",
     "Cycle-Logfile-If-Exists",
     "Open-Thread-Logfile",
     "Append-Thread-Logfile",
     "Log-File-Output-Is-Plain",
     "Close-Thread-Logfile",
     "Write-Text-To-Logfile",
     "Log-File-Output-Is-Timed"
};

static char *_LR_sname [4] =
{
     "After-Init",
     "Before-Opening",
     "Logfile-Open",
     "Defaults"
};

static char *_LR_ename [11] =
{
     "Append-Event",
     "Close-Event",
     "Cycle-Event",
     "Error-Event",
     "Exception-Event",
     "Ok-Event",
     "Open-Event",
     "Plain-Event",
     "Put-Event",
     "Shutdown-Event",
     "Stamp-Event"
};
#else
static char *_LR_mname [9] =
{
     "0",
     "1",
     "2",
     "3",
     "4",
     "5",
     "6",
     "7",
     "8"
};

static char *_LR_sname [4] =
{
     "0",
     "1",
     "2",
     "3"
};

static char *_LR_ename [11] =
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
     "10"
};
#endif
