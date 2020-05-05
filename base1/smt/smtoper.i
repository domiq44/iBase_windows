/*---------------------------------------------------------------------------*
 *  smtoper.i - LIBERO dialog interpreter for smtoper.c.                     *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *  Schema file used: smtschm.c.                                             *
 *---------------------------------------------------------------------------*/
    if (agent_lookup (AGENT_NAME))
        return (0);                     /*  Agent already declared           */
    if ((agent = agent_declare (AGENT_NAME)) == NULL)
        return (-1);                    /*  Could not declare agent          */

#if (defined (SINGLE_THREADED))
    agent-> tcb_size     = 0;           /*  No context block                 */
    agent-> max_threads  = 1;           /*    and max. 1 thread              */
#else
    agent-> tcb_size     = sizeof (TCB);
#endif
    agent-> initialise   = initialise_the_thread;
    agent-> maxevent     = 9;
    agent-> maxmodule    = 8;
    agent-> maxstate     = 3;
    agent-> priority     = SMT_PRIORITY_NORMAL;
    agent-> LR_defaults  = 2;
    agent-> LR_nextst    = &_LR_nextst [0][0];
    agent-> LR_action    = &_LR_action [0][0];
    agent-> LR_offset    = _LR_offset;
    agent-> LR_vector    = _LR_vector;
    agent-> LR_module    = _LR_module;
    agent-> LR_mname     = _LR_mname;
    agent-> LR_sname     = _LR_sname;
    agent-> LR_ename     = _LR_ename;
#if (defined (SMT_PROFILE))
    agent-> LR_count     = &_LR_count [0];
    agent-> LR_time      = &_LR_time  [0];
    agent-> LR_flow      = &_LR_flow  [0][0];

    memset (_LR_count, 0, sizeof (_LR_count));
    memset (_LR_time,  0, sizeof (_LR_time));
#endif
