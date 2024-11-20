-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}

Config.jobMenu = 'F6' -- Default job menu key

Config.customCarlock = false -- If you use wasabi_carlock(Add your own carlock system in client/cl_customize.lua)
Config.billingSystem = false -- Current options: 'esx' (For esx_billing) / 'okok' (For okokBilling) (Easy to add more/fully customize in client/cl_customize.lua)
Config.skinScript = true -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) (Custom can be added in client/cl_customize.lua)
Config.customJail = true -- Set to true if you want to add jail option to menu(Requires you to edit wasabi_police:sendToJail event in client/cl_customize.lua)

Config.inventory = 'ox' -- NEEDED FOR SEARCHING PLAYERS - Current options: 'ox' (For ox_inventory) / 'mf' (For mf inventory) / 'qs' (For qs_inventory) / 'cheeza' (For cheeza_inventory) / 'custom' (Custom can be added in client/cl_customize.lua)
Config.searchPlayers = true -- Allow police jobs to search players (Must set correct inventory above)

Config.weaponsAsItems = true -- This is typically for older ESX and inventories that still use weapons as weapons and not items(If you're unsure leave as true!)
Config.esxIdentity = false -- Enable to gain option additional information when checking ID of suspect. (Requires esx_identity/esx_status or similar)
Config.esxLicense = false -- Enable if you use esx_license or something similar for weapon licenses/etc (May require additional config of the open portions of code)

Config.spikeStripsEnabled = true -- Enable functionility of spike strips (Disable if you use difference script for spike strips)

Config.tackle = {
    enabled = true, -- Enable tackle?
    policeOnly = true, -- Police jobs only use tackle?
    hotkey = 'G' -- What key to press while sprinting to start tackle of target
}

Config.handcuff = { -- Config in regards to cuffing
    timer = 20 * minutes, -- Time before player is automatically unrestrained(Set to false if not desired)
    hotkey = 'J', -- What key to press to handcuff people(Set to false for no hotkey)
    skilledEscape = {
        enabled = true, -- Allow criminal to simulate resisting by giving them a chance to break free from cuffs via skill check
        difficulty = {'easy', 'easy', 'easy'} -- Options: 'easy' / 'medium' / 'hard' (Can be stringed along as they are in config)
    }
}

Config.policeJobs = { -- Police jobs
    'police',
    'sheriff'
}

Config.Props = { -- What props are avaliable in the "Place Objects" section of the job menu

    {
        title = 'Barrier', -- Label
        description = '', -- Description (optional)
        model = `prop_barrier_work05`, -- Prop name within `
        groups = { -- ['job_name'] = min_rank
            ['police'] = 0,
            ['sheriff'] = 0,
        }
    },
    {
        title = 'Barricade',
        description = '',
        model = `prop_mp_barrier_01`,
        groups = {
            ['police'] = 0,
            ['sheriff'] = 0,
        }
    },
    {
        title = 'Traffic Cones',
        description = '',
        model = `prop_roadcone02a`,
        groups = {
            ['police'] = 0,
            ['sheriff'] = 0,
        }
    },
    {
        title = 'Spike Strip',
        description = '',
        model = `p_ld_stinger_s`,
        groups = {
            ['police'] = 0,
            ['sheriff'] = 0,
        }
    },

}

Config.Locations = {
    LSPD = {
        blip = {
            enabled = true,
            coords = vec3(464.57, -992.0, 30.69),
            sprite = 60,
            color = 29,
            scale = 1.0,
            string = 'Mission Row PD'
        },

        bossMenu = {
            enabled = true, -- Enable boss menu?
            jobLock = 'police', -- Lock to specific police job? Set to false if not desired
            coords = vec3(460.64, -985.64, 30.73), -- Location of boss menu (If not using target)
            label = '[E] - Access Boss Menu', -- Text UI label string (If not using target)
            distance = 3.0, -- Distance to allow access/prompt with text UI (If not using target)
            target = {
                enabled = false, -- If enabled, the location and distance above will be obsolete
                label = 'Access Boss Menu',
                coords = vec3(460.64, -985.64, 30.73),
                heading = 269.85,
                width = 2.0,
                length = 1.0,
                minZ = 30.73-0.9,
                maxZ = 30.73+0.9
            }
        },

        armoury = {
            enabled = true, -- Set to false if you don't want to use
            coords = vec3(480.32, -996.67, 30.69-0.9), -- Coords of armoury
            heading = 86.95, -- Heading of armoury NPC
            ped = 's_f_y_cop_01',
            label = '[E] - Access Armoury', -- String of text ui
            jobLock = 'police', -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            weapons = {
                [0] = { -- Grade number will be the name of each table(this would be grade 0)
                    ['WEAPON_PISTOL'] = { label = 'Pistol', multiple = false, price = 75 }, -- Set price to false if undesired
                    ['WEAPON_NIGHTSTICK'] = { label = 'Night Stick', multiple = false, price = 50 },
--                    ['ammo-9'] = { label = '9mm Ammo', multiple = true, price = 10 }, -- Set multiple to true if you want ability to purchase more than one at a time
--                    ['armour'] = { label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example

                },
                [1] = { -- This would be grade 1
                    ['WEAPON_COMBATPISTOL'] = { label = 'Combat Pistol', multiple = false, price = 150 },
                    ['WEAPON_NIGHTSTICK'] = { label = 'Night Stick', multiple = false, price = 50 },
--                    ['ammo-9'] = { label = '9mm Ammo', multiple = true, price = 10 }, -- Example
--                    ['armour'] = { label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
                [2] = { -- This would be grade 2
                    ['WEAPON_COMBATPISTOL'] = { label = 'Combat Pistol', multiple = false, price = 150 },
                    ['WEAPON_NIGHTSTICK'] = { label = 'Night Stick', multiple = false, price = 50 },
                    ['WEAPON_ASSAULTRIFLE'] = { label = 'Assault Rifle', multiple = false, price = 1100 },
--                    ['ammo-9'] = { label = '9mm Ammo', multiple = true, price = 10 }, -- Example
--                    ['ammo-rifle'] = { label = '5.56 Ammo', multiple = true, price = 20 }, -- Example
--                    ['armour'] = { label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
                [3] = { -- This would be grade 3
                    ['WEAPON_COMBATPISTOL'] = { label = 'Combat Pistol', multiple = false, price = 150 },
                    ['WEAPON_NIGHTSTICK'] = { label = 'Night Stick', multiple = false, price = 50 },
                    ['WEAPON_ASSAULTRIFLE'] = { label = 'Assault Rifle', multiple = false, price = 1100 },
              --    ['ammo-9'] = { label = '9mm Ammo', multiple = true, price = 10 }, -- Example
              --    ['ammo-rifle'] = { label = '5.56 Ammo', multiple = true, price = 20 }, -- Example
              --    ['armour'] = { label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
            }
        },

        cloakroom = {
            enabled = true, -- Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            jobLock = 'police', -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            coords = vec3(462.36, -999.62, 30.69), -- Coords of cloakroom
            label = '[E] - Change Clothes', -- String of text ui of cloakroom
            range = 2.0, -- Range away from coords you can use.
            uniforms = { -- Uniform choices

                [1] = { -- Name of outfit that will display in menu
                    label = 'Recruit',
                    male = { -- Male variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 5,   ['torso_2'] = 2,
                        ['arms'] = 5,
                        ['pants_1'] = 6,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 7,
                        ['helmet_1'] = 44,  ['helmet_2'] = 7,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },

                [2] = {
                    label = 'Patrol',
                    male = {
                        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
                        ['torso_1'] = 55,   ['torso_2'] = 0,
                        ['arms'] = 30,
                        ['pants_1'] = 24,   ['pants_2'] = 0,
                        ['shoes_1'] = 10,   ['shoes_2'] = 0,
                        ['helmet_1'] = 46,  ['helmet_2'] = 0,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },

                [3] = {
                    label = 'Chief',
                    male = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 5,   ['torso_2'] = 2,
                        ['arms'] = 5,
                        ['pants_1'] = 6,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 7,
                        ['helmet_1'] = 44,  ['helmet_2'] = 7,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                
            }

        },

        vehicles = { -- Vehicle Garage
            enabled = true, -- Enable? False if you have you're own way for medics to obtain vehicles.
            jobLock = 'police', -- Job lock? or access to all police jobs by using false
            zone = {
                coords = vec3(463.69, -1019.72, 28.1), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Access Garage',
                return_label = '[E] - Return Vehicle'
            },
            spawn = {
                land = {
                    coords = vec3(449.37, -1025.46, 28.59), -- Coords of where land vehicle spawn/return
                    heading = 3.68
                },
                air = {
                    coords = vec3(449.29, -981.76, 43.69), -- Coords of where air vehicles spawn/return
                    heading =  0.01
                }
            },
            options = {

                [0] = { -- Job grade as table name
                    ['police'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air', -- Options are 'land' and 'air'
                    },
                },

                [1] = { -- Job grade as table name
                    ['police'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air', -- Options are 'land' and 'air'
                    },
                },

                [2] = { -- Job grade as table name
                    ['police'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air', -- Options are 'land' and 'air'
                    },
                },

                [3] = { -- Job grade as table name
                    ['police'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air', -- Options are 'land' and 'air'
                    },
                },

            }
        }

    },

}
