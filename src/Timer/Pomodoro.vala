public class Pomodoro.Timer.Pomodoro : Object {
    public int work_time_seconds {get; set;}
    public int break_time_seconds {get; set;}
    public PomodoroState state {get; private set; default = PomodoroState.WORK;}
    public bool auto_start_next_interval {get; set; default = true;}
    public bool running {
        get { return timer != null; }
        private set {}
    }
    private TimeoutSource timer = null;

    public Pomodoro (int _work_time_seconds, int _break_time_seconds) {
        work_time_seconds = _work_time_seconds;
        break_time_seconds = _break_time_seconds;
    }

    construct {
        this.start_pause_toggle.connect ((t) => _start_pause_toggle ());
        this.start.connect ((t) => _start ());
        this.pause.connect ((t) => _pause ());
        this.finished.connect ((t) => _finished ());
    }

    public signal void start_pause_toggle ();
    public signal void start ();
    public signal void pause ();
    public signal void finished ();

    public int get_remaining_time () {
        if (!running) {
            return get_next_interval_length ();
        }
        int64 time_in_ns = timer.get_ready_time () - timer.get_time ();
        int time_in_sec = (int) (time_in_ns / (1000 * 1000));
        return time_in_sec;
    }

    public int get_next_interval_length () {
        switch (state) {
        case PomodoroState.WORK:
            return work_time_seconds;
        case PomodoroState.BREAK:
            return break_time_seconds;
        }
        return 0;
    }

    private void _start_pause_toggle () {
        if (running) {
            pause ();
        } else {
            start ();
        }
    }

    private void _start () {
        int interval_length = 0;
        switch (state) {
        case PomodoroState.WORK:
            interval_length = work_time_seconds;
            break;
        case PomodoroState.BREAK:
            interval_length = break_time_seconds;
            break;
        }

        timer = new TimeoutSource.seconds (interval_length);
        timer.set_callback (() => {
            finished();
            return Source.REMOVE;
        });
        timer.attach (MainContext.get_thread_default ());
        running = true;
    }

    private void _pause () {

    }

    private void _finished () {
        timer = null;
        switch (state) {
        case PomodoroState.WORK:
            state = PomodoroState.BREAK;
            break;
        case PomodoroState.BREAK:
            state = PomodoroState.WORK;
            break;
        }

        if (auto_start_next_interval) {
            start ();
        }
    }
}
