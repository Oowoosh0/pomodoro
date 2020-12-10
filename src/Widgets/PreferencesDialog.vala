public class Pomodoro.Widgets.PreferencesDialog : Gtk.Dialog {
    private Gtk.Stack stack;

    public PreferencesDialog (Gtk.Window? parent) {
        Object (
            deletable: false,
            resizable: false,
            title: "Preferences",
            transient_for: parent
        );
    }

    construct {
        var intervals_grid = new Gtk.Grid ();
        var notifications_grid = new Gtk.Grid ();

        stack = new Gtk.Stack ();
        stack.add_titled (intervals_grid, "intervals", "Intervals");
        stack.add_titled (notifications_grid, "notifications", "Notifications");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.set_stack (stack);

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
}
