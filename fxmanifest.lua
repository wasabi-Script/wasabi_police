-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Wasabi ESX Police Job'
author 'wasabirobby#5110'
version '1.1.2'

shared_scripts {
  '@ox_lib/init.lua',
  'configuration/*.lua'
}

client_scripts {
  'client/*.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/*.lua'
}

dependencies {
  'es_extended',
  'mysql-async',
  'ox_lib'
}

provides {
  'esx_policejob'
}

escrow_ignore {
  'configuration/*.lua',
  'client/*.lua',
  'server/*.lua'
}

dependency '/assetpacks'