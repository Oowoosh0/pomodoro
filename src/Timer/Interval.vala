public abstract class Pomodoro.Timer.Interval : Object {
    private TimeoutSource? timer = null;
    public static Pomodoro.MainWindow parent_window;

    public int index;
    public int duration_sec { get; private set; }
    public int duration_min {
        get { return duration_sec % 60; }
        set { duration_sec = value * 60; }
    }
    public IntervalState state {
        get;
        private set;
        default = IntervalState.BEFORE_START;
    }

    protected Interval (int duration_min, int index) {
        this.duration_min = duration_min;
        this.index = index;
    }

    public void start () {
        state = IntervalState.RUNNING;

        timer = new TimeoutSource.seconds (duration_sec);
        timer.set_callback (() => {
            finished ();
            return Source.REMOVE;
        });
        timer.attach (MainContext.get_thread_default ());
    }

    public void pause () {
        destroy_timer ();
        state = IntervalState.PAUSED;
    }

    private void finished () {
        state = IntervalState.FINISHED;
        parent_window.on_finished ();
    }

    public bool is_running () {
        return state == IntervalState.RUNNING;
    }

    public bool is_before_start () {
        return state == IntervalState.BEFORE_START;
    }

    public int get_remaining_time () {
        int time_in_sec = 0;
        switch (state) {
        case IntervalState.BEFORE_START:
            time_in_sec = duration_sec;
            break;
        case IntervalState.PAUSED:
            time_in_sec = duration_sec;
            break;
        case IntervalState.RUNNING:
            int64 time_in_ns = timer.get_ready_time () - timer.get_time ();
            time_in_sec = (int) (time_in_ns / (1000 * 1000));
            break;
        case IntervalState.FINISHED:
        case IntervalState.DESTROYED:
            break;
        }
        return time_in_sec;
    }

    public abstract Interval reset ();

    public abstract Interval next ();

    public abstract string color ();

    public abstract string message ();

    protected void destroy_timer () {
        duration_sec = get_remaining_time ();
        if (timer != null) {
            timer.destroy ();
        }
        timer = null;
        state = IntervalState.DESTROYED;
    }
}
