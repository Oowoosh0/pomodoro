public class Pomodoro.Timer.BreakInterval : Interval {
    public static int break_duration_min = 5;

    public BreakInterval () {
        base (break_duration_min);
    }

    public override Interval reset () {
        base.destroy_timer ();
        return new BreakInterval ();
    }

    public override Interval next () {
        base.destroy_timer ();
        return new WorkInterval ();
    }

    public override string color () {
        return "#cc3b02";
    }
}
