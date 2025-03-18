project('com.github.oowoosh0.pomodoro', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

profile = get_option('profile')
if profile == 'devel'
    app_id = meson.project_name() + '.Devel'
    app_name = 'PomodoroDevel'
else
    app_id = meson.project_name()
    app_name = 'Pomodoro'
endif

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (app_id), language:'c')

conf_data = configuration_data()
conf_data.set_quoted('APP_ID', app_id)
conf_data.set('APP_ID_UNQUOTED', app_id)
conf_data.set('APP_NAME', app_name)
conf_data.set_quoted('PROFILE', profile)
conf_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
conf_data.set_quoted('GETTEXT_PACKAGE', app_id)
conf_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: conf_data
)

gresources = gnome.compile_resources(
    'as-resources', 'data/css.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    app_id,
    gresources,
    conf_file,
    'src/Application.vala',
    'src/Views/MainWindow.vala',
    'src/Views/PreferencesDialog.vala',
    'src/Controllers/Timer.vala',
    'src/Models/Interval.vala',
    dependencies : [
        dependency('glib-2.0'),
        dependency ('gtk4'),
        dependency ('granite-7')
    ],
    install: true
)


subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
