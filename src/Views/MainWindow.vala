public class Pomodoro.Views.MainWindow : Gtk.ApplicationWindow {
    private PreferencesDialog? preferences_dialog = null;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            title: "Pomodoro",
            width_request: 400,
            height_request: 400,
            resizable: false
        );
    }

    construct {
        var pref_button = new Gtk.Button.from_icon_name ("open-menu-symbolic");
        pref_button.clicked.connect (() => {
            show_preferences_dialog ();
        });

        var header = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            title_widget = new Gtk.Label ("")
        };
        header.add_css_class (Granite.STYLE_CLASS_FLAT);
        header.pack_end(pref_button);

        set_titlebar (header);
    }

    private void show_preferences_dialog () {
        if (preferences_dialog == null) {
            preferences_dialog = new PreferencesDialog (this);

            preferences_dialog.close_request.connect (() => {
                preferences_dialog = null;
                return true;
            });
        }

        preferences_dialog.present ();
    }

}
