public class Pomodoro.Widgets.PreferencesDialog : Granite.Dialog {
    private Gtk.Stack stack;

    public PreferencesDialog (Gtk.Window? parent) {
        Object (
            // border_width: 5,
            deletable: false,
            resizable: false,
            title: _("Preferences"),
            transient_for: parent
        );
    }

    construct {
        var intervals_grid = new Gtk.Grid ();
        intervals_grid.column_spacing = 12;
        intervals_grid.row_spacing = 6;
        intervals_grid.attach (create_label (_("Work duration:")), 0, 0);
        intervals_grid.attach (create_spin_button ("work-time-minutes", 5.0), 1, 0);
        intervals_grid.attach (create_label (_("Break duration:")), 0, 1);
        intervals_grid.attach (create_spin_button ("break-time-minutes", 1.0), 1, 1);
        intervals_grid.attach (create_label (_("Long break duration:")), 0, 2);
        intervals_grid.attach (create_spin_button ("long-break-time-minutes", 1.0), 1, 2);
        intervals_grid.attach (create_label (_("Intervals to long break:")), 0, 3);
        intervals_grid.attach (create_spin_button ("intervals-to-long-break", 1.0), 1, 3);
        intervals_grid.attach (create_label (_("Autostart intervals:")), 0, 4);
        intervals_grid.attach (create_switch ("autostart-interval"), 1, 4);

        var notifications_grid = new Gtk.Grid ();
        notifications_grid.column_spacing = 12;
        notifications_grid.row_spacing = 6;
        notifications_grid.attach (create_label (_("Show notification:")), 0, 0);
        notifications_grid.attach (create_switch ("show-notifications"), 1, 0);
        notifications_grid.attach (create_label (_("Raise Window to top:")), 0, 1);
        notifications_grid.attach (create_switch ("raise-window"), 1, 1);

        stack = new Gtk.Stack ();
        // stack.margin = 6;
        stack.margin_top = 18;
        stack.margin_bottom = 18;
        stack.add_titled (intervals_grid, "intervals", _("Intervals"));
        stack.add_titled (notifications_grid, "notifications", _("Notifications"));

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);
        stack_switcher.halign = Gtk.Align.CENTER;

        var main_grid = new Gtk.Grid ();
        main_grid.attach (stack_switcher, 0, 0, 1, 1);
        main_grid.attach (stack, 0, 1, 1, 1);

        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.clicked.connect (() => {
            close ();
        });

        get_content_area ().append (main_grid);
        add_action_widget (close_button, 0);
    }

    private Gtk.Label create_label (string text) {
        var label = new Gtk.Label (text) {
            halign = Gtk.Align.END
        };

        return label;
    }

    private Gtk.Switch create_switch (string setting) {
        var toggle = new Gtk.Switch () {
            halign = Gtk.Align.START,
            valign = Gtk.Align.CENTER
        };
        Application.settings.bind (setting, toggle, "active", GLib.SettingsBindFlags.DEFAULT);

        return toggle;
    }

    private Gtk.SpinButton create_spin_button (string setting, double step_inc) {
        Gtk.Adjustment adjust = new Gtk.Adjustment (10.0, 0.0, 500.0, step_inc, 0.0, 0.0);
        var spin_button = new Gtk.SpinButton (adjust, 1.0, 0);
        Application.settings.bind (setting, spin_button, "value", GLib.SettingsBindFlags.DEFAULT);

        return spin_button;
    }
}
