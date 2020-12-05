project('com.github.oowoosh0.pomodoro', 'vala', 'c')

gnome = import('gnome')

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
    'src/Widgets/TimerLabel.vala',
    dependencies : [
        dependency('gtk+-3.0')
    ]
)
