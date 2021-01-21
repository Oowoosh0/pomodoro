public class Pomodoro.Widgets.PreferencesDialog : Gtk.Dialog {
    private Gtk.Stack stack;

    public PreferencesDialog (Gtk.Window? parent) {
        Object (
            border_width: 5,
            deletable: false,
            resizable: false,
            title: "Preferences",
            transient_for: parent
        );
    }

    construct {
        var intervals_grid = new Gtk.Grid ();
        intervals_grid.column_spacing = 12;
        intervals_grid.row_spacing = 6;
        intervals_grid.attach (new SettingsLabel ("Work duration:"), 0, 0);
        intervals_grid.attach (new SettingsDurationButton ("work-time-minutes", 5.0), 1, 0);
        intervals_grid.attach (new SettingsLabel ("Break duration:"), 0, 1);
        intervals_grid.attach (new SettingsDurationButton ("break-time-minutes", 1.0), 1, 1);
        intervals_grid.attach (new SettingsLabel ("Autostart intervals:"), 0, 2);
        intervals_grid.attach (new SettingsSwitch ("autostart-interval"), 1, 2);

        var notifications_grid = new Gtk.Grid ();
        notifications_grid.column_spacing = 12;
        notifications_grid.row_spacing = 6;
        notifications_grid.attach (new SettingsLabel ("Show notification:"), 0, 0);
        notifications_grid.attach (new SettingsSwitch ("show-notifications"), 1, 0);
        notifications_grid.attach (new SettingsLabel ("Raise Window to top:"), 0, 1);
        notifications_grid.attach (new SettingsSwitch ("raise-window"), 1, 1);

        stack = new Gtk.Stack ();
        stack.margin = 6;
        stack.margin_top = 18;
        stack.margin_bottom = 18;
        stack.add_titled (intervals_grid, "intervals", "Intervals");
        stack.add_titled (notifications_grid, "notifications", "Notifications");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        stack_switcher.halign = Gtk.Align.CENTER;

        var main_grid = new Gtk.Grid ();
        main_grid.attach (stack_switcher, 0, 0, 1, 1);
        main_grid.attach (stack, 0, 1, 1, 1);

        var close_button = new Gtk.Button.with_label ("Close");
        close_button.clicked.connect (() => {
            destroy ();
        });

        get_content_area ().add (main_grid);
        add_action_widget (close_button, 0);
    }

    private class SettingsLabel : Gtk.Label {
        public SettingsLabel (string text) {
            label = text;
            halign = Gtk.Align.END;
        }
    }

    private class SettingsSwitch : Gtk.Switch {
        public SettingsSwitch (string setting) {
            halign = Gtk.Align.START;
            valign = Gtk.Align.CENTER;
            Application.settings.bind (setting, this, "active", GLib.SettingsBindFlags.DEFAULT);
        }
    }

    private class SettingsDurationButton : Gtk.SpinButton {
        public SettingsDurationButton (string setting, double step_inc) {
            Gtk.Adjustment adjust = new Gtk.Adjustment (10.0, 0.0, 500.0, step_inc, 0.0, 0.0);
            adjustment = adjust;
            climb_rate = 1.0;
            digits = 0;
            Application.settings.bind (setting, this, "value", GLib.SettingsBindFlags.DEFAULT);
        }
    }
}
