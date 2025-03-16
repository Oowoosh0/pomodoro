public class Pomodoro.Views.MainWindow : Gtk.ApplicationWindow {
    private Controllers.Timer timer;
    private Views.PreferencesDialog? preferences_dialog = null;
    private Gtk.Button start_pause_button;
    private Gtk.Label timer_label;
    private const string BG_CSS = "@define-color colorBackground %s;";

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
        add_css_class ("bg-color");

        timer = new Controllers.Timer (this);

        var action_toggle = new SimpleAction ("toggle", null);
        action_toggle.activate.connect (timer.toggle);
        add_action (action_toggle);

        var action_forward = new SimpleAction ("forward", null);
        action_forward.activate.connect (timer.forward);
        add_action (action_forward);

        var action_pref = new SimpleAction ("open-preferences", null);
        action_pref.activate.connect (show_preferences_dialog);
        add_action (action_pref);

        var pref_button = new Gtk.Button () {
            icon_name = "open-menu-symbolic",
            action_name = "win.open-preferences"
        };
        pref_button.add_css_class ("button");

        var header = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            title_widget = new Gtk.Label ("")
        };
        header.add_css_class (Granite.STYLE_CLASS_FLAT);
        header.pack_end (pref_button);

        set_titlebar (header);

        timer_label = new Gtk.Label ("00:00") {
            valign = Gtk.Align.END
        };
        timer_label.add_css_class ("timer-label");

        start_pause_button = new Gtk.Button () {
            icon_name = "media-playback-start-symbolic",
            action_name = "win.toggle"
        };
        start_pause_button.add_css_class ("button");
        start_pause_button.add_css_class ("start-button");

        var forward_button = new Gtk.Button () {
            icon_name = "media-skip-forward-symbolic",
            action_name = "win.forward"
        };
        forward_button.add_css_class ("button");
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

    public void set_start_button_icon (string icon_name) {
        start_pause_button.icon_name = icon_name;
    }

    public void set_timer_label (int seconds) {
        timer_label.label = "%.2i:%.2i".printf (seconds / 60, seconds % 60);
    }

    public void set_bg_color (string color) {
        var css_provider = new Gtk.CssProvider ();
        var new_css = BG_CSS.printf (color);
        css_provider.load_from_string (new_css);
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    private void show_preferences_dialog () {
        if (preferences_dialog == null) {
            preferences_dialog = new Views.PreferencesDialog (this);

            preferences_dialog.response.connect ((t, a) => {
                preferences_dialog.destroy ();
                preferences_dialog = null;
            });
        }

        preferences_dialog.present ();
    }
}
