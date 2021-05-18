public class Pomodoro.Timer.WorkInterval : Interval {

    public WorkInterval (PomodoroTimer parent) {
        base (parent, parent.work_duration_seconds);
    }

    public override Interval reset () {
        base.destroy ();
        return new WorkInterval (parent_timer);
    }

    public override Interval previous () {
        base.destroy ();
        return new BreakInterval (parent_timer);
    }

    public override Interval next () {
        base.destroy ();
        return new BreakInterval (parent_timer);
    }

    public override string color () {
        return "#007367";
    }

}