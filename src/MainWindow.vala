public class Pomodoro.MainWindow : Hdy.ApplicationWindow {
    private Timer.PomodoroTimer pomodoro;
    private Widgets.TimerLabel timer_label;
    private StartPauseButton start_pause_button;
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
             width_request: 350,
             height_request: 350,
             resizable: false
        );
    }

     construct {
        Hdy.init();

        pomodoro = new Timer.PomodoroTimer ();
        Application.settings.bind (
            "work-time-minutes",
            pomodoro,
            "work_duration_minutes",
            GLib.SettingsBindFlags.GET
        );
        Application.settings.bind (
            "break-time-minutes",
            pomodoro,
            "break_duration_minutes",
            GLib.SettingsBindFlags.GET
        );
        Application.settings.bind (
            "autostart-interval",
            pomodoro,
            "autostart_interval",
            GLib.SettingsBindFlags.GET
        );
        pomodoro.start.connect_after (on_pomodoro_start);
        pomodoro.pause.connect_after (on_pomodoro_pause);
        pomodoro.finished.connect_after (on_pomodoro_finished);
        pomodoro.time_changed.connect_after (on_time_change);

        var header_bar = new Hdy.HeaderBar () {
            decoration_layout = "close:",
            show_close_button = true
        };

        var header_bar_context = header_bar.get_style_context ();
        header_bar_context.add_class ("main-titlebar");
        header_bar_context.add_class ("bg-color");
        header_bar_context.add_class (Gtk.STYLE_CLASS_FLAT);

        var menu_button = new Gtk.Button.from_icon_name (
            "open-menu-symbolic",
            Gtk.IconSize.SMALL_TOOLBAR
        );
        menu_button.get_style_context ().add_class ("button");
        menu_button.clicked.connect (() => {
            show_preferences_dialog ();
        });

        header_bar.pack_end (menu_button);

        timer_label = new Widgets.TimerLabel ();
        timer_label.set_label_seconds (pomodoro.get_remaining_time ());
        timer_label.yalign = 1;

        var skip_backward_button = new Gtk.Button.from_icon_name (
            "media-skip-backward-symbolic",
            Gtk.IconSize.DND
        );
        skip_backward_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        skip_backward_button.get_style_context ().add_class ("button");
        skip_backward_button.clicked.connect (() => on_pomodoro_skip_backward ());

        start_pause_button = new StartPauseButton ();
        start_pause_button.clicked.connect (() => pomodoro.start_pause_toggle ());

        var skip_forward_button = new Gtk.Button.from_icon_name (
            "media-skip-forward-symbolic",
            Gtk.IconSize.DND
        );
        skip_forward_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        skip_forward_button.get_style_context ().add_class ("button");
        skip_forward_button.clicked.connect (() => on_pomodoro_skip_forward ());

        var timer_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        timer_controls.halign = Gtk.Align.CENTER;
        timer_controls.pack_start (skip_backward_button, false, false, 0);
        timer_controls.pack_start (start_pause_button, false, false, 0);
        timer_controls.pack_start (skip_forward_button, false, false, 0);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            hexpand = true,
            vexpand = true
        };

        var box_context = box.get_style_context ();
        box_context.add_class ("timer-box");
        box_context.add_class ("bg-color");
        box.pack_start (timer_label, true, true, 0);
        box.pack_start (timer_controls, true, false, 0);

        var main_grid = new Gtk.Grid () {
            hexpand = true
        };

        main_grid.attach (header_bar, 0, 0);
        main_grid.attach (box, 0, 1);

        var window_handle = new Hdy.WindowHandle ();
        window_handle.add (main_grid);

        add (window_handle);
        set_default (start_pause_button);
        set_focus (start_pause_button);
     }

     private void on_pomodoro_start () {
        start_pause_button.set_pause_image ();

         Timeout.add(200, () => {
             timer_label.set_label_seconds (pomodoro.get_remaining_time ());
             return pomodoro.is_running ();
         });
     }

     private void on_pomodoro_pause () {
        start_pause_button.set_start_image ();
     }

     private void on_pomodoro_finished () {
       NotificationManager.intervalFinished ();

        // dirty fix because present() doesn't work
        if (Application.settings.get_boolean ("raise-window")) {
            this.set_keep_above (true);
            this.set_keep_above (false);
        }

        if (!Application.settings.get_boolean ("autostart-interval")) {
            start_pause_button.set_start_image ();
        }
        on_interval_switch ();
     }

     private void on_interval_switch () {
        var css_provider = new Gtk.CssProvider ();
        var break_css = BG_CSS.printf (pomodoro.interval_color ());
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
        timer_label.set_label_seconds (pomodoro.get_remaining_time ());
     }

     private void on_pomodoro_skip_forward () {
         pomodoro.skip_forward ();
         start_pause_button.set_start_image ();
         on_interval_switch ();
     }

     private void on_pomodoro_skip_backward () {
        pomodoro.skip_backward ();
        start_pause_button.set_start_image ();
        on_interval_switch ();
     }

     private void on_time_change () {
        timer_label.set_label_seconds (pomodoro.get_remaining_time ());
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

    private class StartPauseButton : Gtk.Button {
        public StartPauseButton () {
            image = new Gtk.Image.from_icon_name (
                "media-playback-start-symbolic",
                Gtk.IconSize.DND
            );
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            get_style_context ().add_class ("button");
            set_can_default (true);
        }

        public void set_start_image () {
            image = new Gtk.Image.from_icon_name (
                "media-playback-start-symbolic",
                Gtk.IconSize.DND
            );
        }

        public void set_pause_image () {
            image = new Gtk.Image.from_icon_name (
                "media-playback-pause-symbolic",
                Gtk.IconSize.DND
            );
        }
    }
}
