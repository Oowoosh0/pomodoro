project('com.github.oowoosh0.pomodoro', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

gresources = gnome.compile_resources(
    'as-resources', 'data/css.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    gresources,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/NotificationManager.vala',
    'src/Widgets/TimerLabel.vala',
    'src/Widgets/PreferencesDialog.vala',
    'src/Timer/PomodoroTimer.vala',
    'src/Timer/Interval.vala',
    'src/Timer/IntervalState.vala',
    'src/Timer/WorkInterval.vala',
    'src/Timer/BreakInterval.vala',
    dependencies : [
        dependency('gtk+-3.0')
    ]
)

meson.add_install_script('meson/post_install.py')

subdir('data')
subdir('po')
