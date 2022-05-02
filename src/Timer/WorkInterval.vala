public class Pomodoro.Timer.WorkInterval : Interval {
    public static int work_duration_min = 25;

    public WorkInterval () {
        base (work_duration_min);
    }

    public override Interval reset () {
        base.destroy_timer ();
        return new WorkInterval ();
    }

    public override Interval next () {
        base.destroy_timer ();
        return new BreakInterval ();
    }

    public override string color () {
        return "#0d52bf";
    }

}
