public class Pomodoro.MainWindow : Hdy.ApplicationWindow {
    private Timer.Interval pomodoro_interval;
    private Widgets.TimerLabel timer_label;
    private StartPauseButton start_pause_button;
    private Widgets.PreferencesDialog? preferences_dialog = null;
    private const string BG_CSS = """
        @define-color colorBackground %s;

        .bg-color {
            transition: all 250ms ease-in-out;
        }
    """;
    public bool autostart_interval { get; set; default = false;}
    public int work_duration_min {
        get { return Timer.WorkInterval.work_duration_min; }
        set { 
            Timer.WorkInterval.work_duration_min = value;
            on_time_change ();
        }
    }
    public int break_duration_min {
        get { return Timer.BreakInterval.break_duration_min; }
        set { 
            Timer.BreakInterval.break_duration_min = value;
            on_time_change ();
        }
    }

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
        Hdy.init ();

        Application.settings.bind (
            "work-time-minutes",
            this,
            "work_duration_min",
            GLib.SettingsBindFlags.GET
        );
        Application.settings.bind (
            "break-time-minutes",
            this,
            "break_duration_min",
            GLib.SettingsBindFlags.GET
        );
        Application.settings.bind (
            "autostart-interval",
            this,
            "autostart_interval",
            GLib.SettingsBindFlags.GET
        );

        pomodoro_interval = new Timer.WorkInterval ();
        pomodoro_interval.finished.connect_after (on_pomodoro_finished);

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
        timer_label.set_label_seconds (pomodoro_interval.get_remaining_time ());
        timer_label.yalign = 1;

        start_pause_button = new StartPauseButton ();
        start_pause_button.clicked.connect (() => on_start_pause_toggle ());

        var skip_forward_button = new Gtk.Button.from_icon_name (
            "media-skip-forward-symbolic",
            Gtk.IconSize.DND
        );
        skip_forward_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        skip_forward_button.get_style_context ().add_class ("button");
        skip_forward_button.clicked.connect (() => on_skip_forward ());

        var timer_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        timer_controls.halign = Gtk.Align.CENTER;
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
        //set_default (start_pause_button);
        //set_focus (start_pause_button);
    }

    public void on_start_pause_toggle () {
        if (pomodoro_interval.is_running ()) {
            on_pause ();
        } else {
            on_start ();
        }
    }

    private void on_start () {
        start_pause_button.set_pause_image ();
        pomodoro_interval.start();

        Timeout.add (200, () => {
            timer_label.set_label_seconds (pomodoro_interval.get_remaining_time ());
            return pomodoro_interval.is_running ();
        });
    }

    private void on_pause () {
        start_pause_button.set_start_image ();
        pomodoro_interval.pause();
    }

    private void on_pomodoro_finished () {
        NotificationManager.interval_finished ();

        // dirty fix because present() doesn't work
        if (Application.settings.get_boolean ("raise-window")) {
            this.set_keep_above (true);
            this.set_keep_above (false);
        }

        on_interval_switch ();
    }

    private void on_interval_switch () {
        pomodoro_interval = pomodoro_interval.next ();
        var css_provider = new Gtk.CssProvider ();
        var break_css = BG_CSS.printf (pomodoro_interval.color ());
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
        timer_label.set_label_seconds (pomodoro_interval.get_remaining_time ());

        if (autostart_interval) {
            on_start ();
        } else {
            start_pause_button.set_start_image ();
        }
    }

    private void on_skip_forward () {
        on_interval_switch ();
    }

    private void on_time_change () {
        if (pomodoro_interval.is_before_start ()) {
            pomodoro_interval = pomodoro_interval.reset ();
            timer_label.set_label_seconds (pomodoro_interval.get_remaining_time ());
        }
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
                Gtk.IconSize.DIALOG
            );
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            get_style_context ().add_class ("button");
            set_can_default (true);
        }

        public void set_start_image () {
            image = new Gtk.Image.from_icon_name (
                "media-playback-start-symbolic",
                Gtk.IconSize.DIALOG
            );
        }

        public void set_pause_image () {
            image = new Gtk.Image.from_icon_name (
                "media-playback-pause-symbolic",
                Gtk.IconSize.DIALOG
            );
        }
    }
}
