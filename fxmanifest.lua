fx_version 'cerulean'
game 'gta5'

author 'The Illusion Squid'
version '1.0.0'
description 'Skydiving script'

client_scripts {
	"client.lua",
	"config.lua",

}

server_scripts {
	"server.lua",
	"config.lua",
    '@oxmysql/lib/MySQL.lua',
}

