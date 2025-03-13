icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        join_paths('icons', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps'),
        rename: '@0@.svg'.format(app_id)
    )
    install_data(
        join_paths('icons', i + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps'),
        rename: '@0@.svg'.format(app_id)
    )
endforeach

install_data (
    'gschema.xml',
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas'),
    rename: '@0@.gschema.xml'.format(app_id)
)

#Translate and install our .desktop file
i18n.merge_file(
    input: configure_file(
        input: files('pomodoro.desktop.in'),
        output: 'desktop_file.desktop.in',
        configuration: conf_data
    ),
    output: '@0@.desktop'.format(app_id),
    po_dir: meson.source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .appdata file
i18n.merge_file(
    input: configure_file(
        input: files('pomodoro.appdata.xml.in'),
        output: 'appdata_file.appdata.xml.in',
        configuration: conf_data
    ),
    output: '@0@.appdata.xml'.format(app_id),
    po_dir: meson.source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)
