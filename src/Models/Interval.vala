public enum Pomodoro.Models.IntervalType {
    WORK,
    BREAK,
    LONG_BREAK
}

public class Pomodoro.Models.Interval : Object {
    private static string[] colors = {"#0d52bf", "#cc3b02", "#a10705"};
    private static string[] type_strings = {_("WORK"), _("BREAK"), _("LONG BREAK")};
    private static string[] messages = {
        _("Time to treat yourself with a break."),
        _("Sadly your short break is over."),
        _("Sadly your long break finished. Time to get back to work.")
    };

    public delegate void callbackOnFinished ();

    private TimeoutSource? timer = null;
    private IntervalType type;
    private int remaining_time;

    public int index { get; private set; }
    public int intervals_to_long_break { get; private set; }
    public string message { get { return messages[type]; } }
    public string color { get { return colors[type]; } }
    public string type_string { get { return type_strings[type]; } }

    public Interval (IntervalType t, int i) {
        type = t;
        index = i;
        intervals_to_long_break = App.settings.get_int ("intervals-to-long-break");
        switch (type) {
        case IntervalType.WORK:
            remaining_time = App.settings.get_int ("work-time-minutes") * 60;
            break;
        case IntervalType.BREAK:
            remaining_time = App.settings.get_int ("break-time-minutes") * 60;
            break;
        case IntervalType.LONG_BREAK:
            remaining_time = App.settings.get_int ("long-break-time-minutes") * 60;
            break;
        default:
            remaining_time = 1500;
            break;
        }
    }

    public Interval.from_interval (Interval i) {
        this (i.type, i.index);
    }

    public void start (callbackOnFinished cb) {
        timer = new TimeoutSource.seconds (remaining_time);
        timer.set_callback (() => {
            cb ();
            return Source.REMOVE;
        });
        timer.attach (MainContext.get_thread_default ());
    }

    public void pause () {
        remaining_time = get_remaining_time ();
        if (timer != null) {
            timer.destroy ();
        }
        timer = null;
    }

    public int get_remaining_time () {
        if (timer != null) {
            int64 time_in_ns = timer.get_ready_time () - timer.get_time ();
            return (int) (time_in_ns / (1000 * 1000));
        }
        return remaining_time;
    }

    public Interval next () {
        if (type != IntervalType.WORK) {
            return new Interval (IntervalType.WORK, index + 1);
        }
        if (index == intervals_to_long_break) {
            return new Interval (IntervalType.LONG_BREAK, 0);
        }
        return new Interval (IntervalType.BREAK, index);
    }
}
