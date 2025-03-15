public enum Pomodoro.Models.IntervalType {
    WORK,
    BREAK,
    LONG_BREAK
}

public class Pomodoro.Models.Interval : Object {
    private static string[] COLORS = {"#0d52bf", "#cc3b02", "#a10705"};
    private static string[] MESSAGES = {
        _("Time to treat yourself with a break."),
        _("Sadly your short break is over."),
        _("Sadly your long break finished. Time to get back to work.")
    };

    private enum State {
    RUNNING,
    PAUSED,
    FINISHED
    }

    private TimeoutSource? timer = null;
    private State state;
    private IntervalType type;

    public int remaining_time { get; set; }
    public string message { get { return MESSAGES[type]; } }
    public string color { get { return COLORS[type]; } }

    public Interval(IntervalType t) {
        state = State.PAUSED;
        type = t;
    }

    public void start () {
        state = State.RUNNING;

        timer = new TimeoutSource.seconds (remaining_time);
        timer.set_callback (() => {
            // finished ();
            return Source.REMOVE;
        });
        timer.attach (MainContext.get_thread_default ());
    }

    public void pause () {}

    public Interval next () {
        return new Interval (IntervalType.WORK);
    }
}
