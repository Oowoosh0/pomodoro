public class Pomodoro.Timer.PomodoroTimer : Object {
    private Interval interval;
    private int _work_duration_seconds;
    private int _break_duration_seconds;

    public int work_duration_seconds {
        get { return _work_duration_seconds; }
        set {
            _work_duration_seconds = value;
            if (interval.state == IntervalState.BEFORE_START) {
                time_changed ();
            }
        }
        default = 1500;
    }

    public int break_duration_seconds {
        get { return _break_duration_seconds; }
        set {
            _break_duration_seconds = value;
            if (interval.state == IntervalState.BEFORE_START) {
                time_changed ();
            }
        }
        default = 300;
    }

    public int work_duration_minutes {
        get { return work_duration_seconds % 60; }
        set { work_duration_seconds = value * 60; }
    }
    public int break_duration_minutes {
        get { return break_duration_seconds % 60; }
        set { break_duration_seconds = value * 60; }
    }
    public bool autostart_interval {get; set; default = false;}

    public PomodoroTimer () {
        interval = new WorkInterval(this);
    }

    public PomodoroTimer.seconds (int work_duration_seconds, int break_duration_seconds) {
        this.work_duration_seconds = work_duration_seconds;
        this.break_duration_seconds = break_duration_seconds;
        interval = new WorkInterval(this);
    }

    public void start_pause_toggle () {
        if (interval.state == IntervalState.RUNNING) {
            pause ();
        } else {
            start ();
        }
    }

    public virtual signal void start () {
        interval.start ();
    }

    public virtual signal void pause () {
        interval.pause ();
    }

    public virtual signal void finished () {
        interval = interval.next ();
        if (autostart_interval) {
            start ();
        }
    }

    public virtual signal void time_changed () {
        interval = interval.reset ();
    }

    public bool is_running () {
        return interval.state == IntervalState.RUNNING;
    }

    public int get_remaining_time () {
        return interval.get_remaining_time ();
    }

    public void skip_forward () {
        interval = interval.next ();
    }

    public void skip_backward () {
        if (interval.state != IntervalState.BEFORE_START) {
            interval = interval.reset ();
        } else {
            interval = interval.previous ();
        }
    }

    public string interval_color () {
        return interval.color ();
    }

}
