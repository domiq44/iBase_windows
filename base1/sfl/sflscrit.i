/*---------------------------------------------------------------------------*
 *  sflscrit.i - LIBERO dialog interpreter for sflscrit.c.                   *
 *  Generated by LIBERO 2.4 on  6 Oct, 2010, 19:32.                          *
 *---------------------------------------------------------------------------*/

    _LR_state = 0;                      /*  First state is always 0          */
    initialise_the_program ();
    while (the_next_event != terminate_event) {
        _LR_event = the_next_event;
        if (_LR_event >= 10 || _LR_event < 0) {
            printf ("State %d - event %d is out of range\n",
                     _LR_state, _LR_event);
            break;
        }
        _LR_savest = _LR_state;
        _LR_index  = _LR_action [_LR_state][_LR_event];
        if (_LR_index == 0) {
            printf ("State %d - event %d is not accepted\n",
                     _LR_state, _LR_event);
            break;
        }
        the_next_event          = _LR_NULL_EVENT;
        the_exception_event     = _LR_NULL_EVENT;
        exception_raised        = FALSE;

        _LR_number = 0;
        while ((_LR_vector [_LR_index] [_LR_number] != _LR_STOP)
           && (! exception_raised)) {
            (*_LR_module [_LR_vector [_LR_index] [_LR_number++]]) ();

            _LR_index  = _LR_action [_LR_state][_LR_event];
        }
        if (exception_raised) {
            if (the_exception_event != _LR_NULL_EVENT)
                _LR_event = the_exception_event;
            the_next_event = _LR_event;
        }
        else
            _LR_state = _LR_nextst [_LR_state][_LR_event];

        if (the_next_event == _LR_NULL_EVENT) {
            get_external_event ();
            if (the_next_event == _LR_NULL_EVENT) {
                printf ("No event set after event %d in state %d\n",
                         _LR_event, _LR_state);
                break;
            }
        }
    }
    return (feedback);
}

/*- Standard dialog routines ------------------------------------------------*/

static void raise_exception (event_t event)
{
    exception_raised = TRUE;
    if (event >= 0)
        the_exception_event = event;
