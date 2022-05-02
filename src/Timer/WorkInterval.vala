public class Pomodoro.Timer.WorkInterval : Interval {
    public static int work_duration_min = 25;

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
        if (index % 4 == 0) {
            next_break_interval = new LongBreakInterval (this.index);
        }
        return next_break_interval;
    }

    public override string color () {
        return "#0d52bf";
    }

}
