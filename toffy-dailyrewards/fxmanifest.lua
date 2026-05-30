fx_version 'cerulean'
game 'gta5'

description 'Toffy Daily Rewards'
author 'Toffy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'locales/tr.lua',
    'locales/en.lua',
    'config/config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}

lua54 'yes'
