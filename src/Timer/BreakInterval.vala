public class Pomodoro.Timer.BreakInterval : Interval {
    public static int break_duration_min = 5;

    public BreakInterval (int index) {
        base (break_duration_min, index);
    }

    public override Interval reset () {
        base.destroy_timer ();
        return new BreakInterval (this.index);
    }

    public override Interval next () {
        base.destroy_timer ();
        return new WorkInterval (this.index + 1);
    }

    public override string color () {
        return "#cc3b02";
    }
    
    public override string message () {
        return "Sadly your short break is over. Time to get back to work.";
    }
}
