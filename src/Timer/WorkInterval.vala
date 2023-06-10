public class Pomodoro.Timer.WorkInterval : Interval {
    public static int work_duration_min = 25;
    public static int intervals_to_long_break = 4;

    public WorkInterval (int index) {
        base (work_duration_min, index);
    }

    public override Interval reset () {
        base.destroy_timer ();
        return new WorkInterval (this.index);
    }

    public override Interval next () {
        base.destroy_timer ();
        Interval next_break_interval = new BreakInterval (this.index);
        if (index % intervals_to_long_break == 0) {
            next_break_interval = new LongBreakInterval (this.index);
        }
        return next_break_interval;
    }

    public override string color () {
        return "#0d52bf";
    }

    public override string message () {
        int next_break_duration = BreakInterval.break_duration_min;
        if (index % intervals_to_long_break == 0) {
            next_break_duration = LongBreakInterval.break_duration_min;
        }
        return ngettext (
            "Time to treat yourself with a break. See you in %i minute.",
            "Time to treat yourself with a break. See you in %i minutes.",
            next_break_duration
        ).printf (next_break_duration);
    }
}
