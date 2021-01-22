public class Pomodoro.Timer.WorkInterval : Interval {

    public WorkInterval (PomodoroTimer parent) {
        base (parent, parent.work_duration_seconds);
    }

    public override Interval reset () {
        return new WorkInterval (parent_timer);
    }

    public override Interval previous () {
        return new BreakInterval (parent_timer);
    }

    public override Interval next () {
        return new BreakInterval (parent_timer);
    }

    public override string color () {
        return "#007367";
    }

}
