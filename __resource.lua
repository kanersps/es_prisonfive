resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

resource_type 'gametype' { name = 'PrisonFive' }

dependency 'essentialmode'

ui_page 'ui/index.html'

files {
    'ui/index.html'
}

client_scripts {
    'roles/cl_selection.lua',
    'roles/cl_prisoner.lua',
    'roles/cl_warden.lua',
    'roles/cl_officer.lua',
    'systems/cl_spawning.lua'
}

server_scripts {
    'roles/sv_selection.lua',
    'roles/sv_prisoner.lua',
    'roles/sv_warden.lua',
    'roles/sv_officer.lua',
    'systems/sv_spawning.lua',
    'systems/sv_economy.lua',
    'systems/sv_main.lua'
}