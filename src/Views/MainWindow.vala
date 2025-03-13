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

        var timer_label = new Gtk.Label ("25:00") {
            valign = Gtk.Align.END
        };
        timer_label.add_css_class ("timer-label");

        var start_pause_button = new Gtk.Button () {
            icon_name = "media-playback-start-symbolic"
        };
        start_pause_button.add_css_class ("start-button");

        var forward_button = new Gtk.Button () {
            icon_name = "media-skip-forward-symbolic"
        };
        forward_button.add_css_class ("forward-button");

        var controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
            valign = Gtk.Align.START,
            halign = Gtk.Align.CENTER
        };
        controls.append (start_pause_button);
        controls.append (forward_button);

        var main_content_area = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            homogeneous = true,
            hexpand = true,
            vexpand = true
        };
        main_content_area.append (timer_label);
        main_content_area.append (controls);

        set_child (main_content_area);
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
