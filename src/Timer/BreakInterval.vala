public class Pomodoro.Timer.BreakInterval : Interval {

    public BreakInterval (PomodoroTimer parent) {
        base (parent, parent.break_duration_seconds);
    }

    public override Interval reset () {
        return new BreakInterval (parent_timer);
    }

    public override Interval previous () {
        return new WorkInterval (parent_timer);
    }

    public override Interval next () {
        return new WorkInterval (parent_timer);
    }

    public override string color () {
        return "#c6262e";
    }

}
