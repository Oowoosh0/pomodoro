public class Pomodoro.Application : Gtk.Application {
    public MainWindow? main_window = null;

     public Application () {
        Object (application_id: "com.github.oowoosh0.pomodoro");
    }

    protected override void activate () {
        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("com/github/oowoosh0/pomodoro/Application.css");
        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        if (get_windows () == null) {
            main_window = new MainWindow (this);
            main_window.show_all ();
        } else {
            main_window.present ();
        }
    }

    public static int main(string[] args) {
        var application = new Application ();
        return application.run(args);
    }
}