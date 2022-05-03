public class Pomodoro.Timer.LongBreakInterval : Interval {
    public static int break_duration_min = 15;

    public LongBreakInterval (int index) {
        base (break_duration_min, index);
    }

    public override Interval reset () {
        base.destroy_timer ();
        return new LongBreakInterval (this.index);
    }

    public override Interval next () {
        base.destroy_timer ();
        return new WorkInterval (this.index + 1);
    }

    public override string color () {
        return "#a10705";
    }
    
    public override string message () {
        return "Sadly your long break finished. Time to get back to work";
    }
}
