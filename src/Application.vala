public class Pomodoro.App : Gtk.Application {
    public static GLib.Settings settings;

    public App () {
        Object (
            application_id: APP_ID,
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
    }

    protected override void startup () {
        base.startup ();
        Granite.init ();

        settings = new GLib.Settings (APP_ID);

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_application_prefer_dark_theme =
            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme =
                granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
    }

    protected override void activate () {
        if (active_window != null) {
            active_window.present ();
            return;
        }

        var main_window = new Views.MainWindow (this);
        main_window.present ();
    }

    public static int main (string[] args) {
        return new Pomodoro.App ().run (args);
    }
}
