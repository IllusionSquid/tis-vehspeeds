fx_version 'cerulean'
game 'gta5'

author 'The Illusion Squid'
version '1.0.0'
description 'Vehicle speeds'

client_scripts {
	"client.lua",
	"config.lua",

}

server_scripts {
	"server.lua",
	"config.lua",
    '@oxmysql/lib/MySQL.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/jquery.js',
	'html/init.js',
}