public class Pomodoro.MainWindow : Gtk.ApplicationWindow {
    private Timer.Pomodoro pomodoro;
    private Widgets.TimerLabel timer_label;
    private Gtk.Button start_pause_button;
    private Widgets.PreferencesDialog? preferences_dialog = null;
    private const string WORK_BG_COLOR = "#007367";
    private const string BREAK_BG_COLOR = "#c6262e";
    private const string BG_CSS = """
        @define-color colorBackground %s;

        .bg-color {
            transition: all 250ms ease-in-out;
        }
    """;

    public MainWindow (Gtk.Application application) {
        Object (
             application: application,
             title: "Pomodoro",
             width_request: 450,
             height_request: 450,
             resizable: false
        );
    }

     construct {
        pomodoro = new Timer.Pomodoro(10, 5);
        pomodoro.start.connect (on_pomodoro_start);
        pomodoro.pause.connect (on_pomodoro_pause);
        pomodoro.finished.connect (on_pomodoro_finished);

        var header_bar = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            show_close_button = true,
            hexpand = true
        };

        var menu_button = new Gtk.Button.from_icon_name (
            "open-menu-symbolic",
            Gtk.IconSize.SMALL_TOOLBAR
        );
        menu_button.clicked.connect (() => {
            show_preferences_dialog ();
        });

        header_bar.pack_end (menu_button);

        var header_grid = new Gtk.Grid ();
        var header_grid_context = header_grid.get_style_context ();
        header_grid_context.add_class ("main-titlebar");
        header_grid_context.add_class ("default-decoration");
        header_grid_context.add_class ("bg-color");
        header_grid_context.add_class (Gtk.STYLE_CLASS_FLAT);

        header_grid.add (header_bar);

        timer_label = new Widgets.TimerLabel ();
        timer_label.set_label_seconds (pomodoro.work_time_seconds);
        timer_label.yalign = 1;

        var skip_backward_button = new Gtk.Button.from_icon_name (
            "media-skip-backward-symbolic",
            Gtk.IconSize.DIALOG
        );
        skip_backward_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        skip_backward_button.clicked.connect (() => pomodoro.skip_backward ());

        start_pause_button = new Gtk.Button.from_icon_name (
            "media-playback-start-symbolic",
            Gtk.IconSize.DIALOG
        );
        start_pause_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        start_pause_button.clicked.connect (() => pomodoro.start_pause_toggle ());

        var skip_forward_button = new Gtk.Button.from_icon_name (
            "media-skip-forward-symbolic",
            Gtk.IconSize.DIALOG
        );
        skip_forward_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        skip_forward_button.clicked.connect (() => pomodoro.skip_forward ());

        var timer_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        timer_controls.halign = Gtk.Align.CENTER;
        timer_controls.pack_start (skip_backward_button, false, false, 0);
        timer_controls.pack_start (start_pause_button, false, false, 0);
        timer_controls.pack_start (skip_forward_button, false, false, 0);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var box_context = box.get_style_context ();
        box_context.add_class ("timer-box");
        box_context.add_class ("bg-color");
        box.pack_start (timer_label, true, true, 0);
        box.pack_start (timer_controls, true, false, 0);

        set_titlebar (header_grid);
        add (box);
        get_style_context ().add_class ("rounded");
     }

     private void on_pomodoro_start () {
        Gtk.Image pause_icon = new Gtk.Image.from_icon_name (
            "media-playback-pause-symbolic",
            Gtk.IconSize.DIALOG
        );
        start_pause_button.set_image (pause_icon);

         Timeout.add(200, () => {
             timer_label.set_label_seconds (pomodoro.get_remaining_time ());
             return pomodoro.is_running ();
         });
     }

     private void on_pomodoro_pause () {
        Gtk.Image start_icon = new Gtk.Image.from_icon_name (
            "media-playback-start-symbolic",
            Gtk.IconSize.DIALOG
        );
        start_pause_button.set_image (start_icon);
     }

     private void on_pomodoro_finished () {
        Gtk.Image start_icon = new Gtk.Image.from_icon_name (
            "media-playback-start-symbolic",
            Gtk.IconSize.DIALOG
        );
        start_pause_button.set_image (start_icon);

        string bg_color = WORK_BG_COLOR;
        switch (pomodoro.state) {
        case Timer.PomodoroState.WORK:
            bg_color = WORK_BG_COLOR;
            break;
        case Timer.PomodoroState.BREAK:
            bg_color = BREAK_BG_COLOR;
            break;
        }

        var css_provider = new Gtk.CssProvider ();
        var break_css = BG_CSS.printf (bg_color);
        try {
            css_provider.load_from_data (break_css, break_css.length);
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (GLib.Error e) {
            return;
        }
        timer_label.set_label_seconds (pomodoro.get_next_interval_length ());
     }

     private void on_pomodoro_skip_backward () {

     }

     private void show_preferences_dialog () {
         if (preferences_dialog == null) {
             preferences_dialog = new Widgets.PreferencesDialog (this);
             preferences_dialog.show_all ();

             preferences_dialog.destroy.connect (() => {
                 preferences_dialog = null;
             });
         }

         preferences_dialog.present ();
     }
}
