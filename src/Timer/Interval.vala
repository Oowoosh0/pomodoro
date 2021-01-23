public abstract class Pomodoro.Timer.Interval : Object {
    private int last_remaining_time = 0;
    private TimeoutSource? timer = null;

    public PomodoroTimer parent_timer { get; private set; }
    public int duration { get; private set; }
    public IntervalState state {
        get;
        private set;
        default = IntervalState.BEFORE_START;
    }

    public Interval (PomodoroTimer parent, int duration) {
        this.parent_timer = parent;
        this.duration = duration;
    }

    public void start () {
        int interval_duration = this.duration;
        if (state == IntervalState.PAUSED) {
            interval_duration = last_remaining_time;
        }
        state = IntervalState.RUNNING;

        timer = new TimeoutSource.seconds (interval_duration);
        timer.set_callback (() => {
            parent_timer.finished ();
            return Source.REMOVE;
        });
        timer.attach (MainContext.get_thread_default ());
    }

    public void pause () {
        destroy_timer ();
        state = IntervalState.PAUSED;
    }

    public int get_remaining_time () {
        int time_in_sec = 0;
        switch (state) {
        case IntervalState.BEFORE_START:
            time_in_sec = duration;
            break;
        case IntervalState.PAUSED:
            time_in_sec = last_remaining_time;
            break;
        case IntervalState.RUNNING:
            int64 time_in_ns = timer.get_ready_time () - timer.get_time ();
            time_in_sec = (int) (time_in_ns / (1000 * 1000));
            break;
        }
        return time_in_sec;
    }

    public abstract Interval reset ();

    public abstract Interval next ();

    public abstract Interval previous ();

    public abstract string color ();

    protected void destroy () {
        destroy_timer ();
        state = IntervalState.DESTROYED;
    }

    private void destroy_timer () {
        last_remaining_time = get_remaining_time ();
        if (timer != null) {
            timer.destroy ();
        }
        timer = null;
    }
}
