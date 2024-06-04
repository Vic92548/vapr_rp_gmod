VAPR_STATS_CONFIG = {
    limits = {
        money = {default = 1000, min = 0, max = 0, changeOverTime = 0, visible = false},  -- max 0 means no maximum
        health = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = false},
        weight = {default = 0, min = 0, max = 400, changeOverTime = 0, visible = false},
        stamina = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = false},
        hunger = {default = 100, min = 0, max = 100, changeOverTime = -5, visible = false},
        strength = {default = 1, min = 0, max = 100, changeOverTime = 0, visible = true},
        agility = {default = 1, min = 0, max = 100, changeOverTime = 0, visible = true},
        wanted_level = {default = 0, min = 0, max = 100000000, changeOverTime = -50, visible = true}
    },
    DEBUG = false
}

VAPR_ITEMS_CONFIG = {
    -- Health Pack
    health_pack = {
        name = "Health Pack",
        value = 50, -- Amount of health it restores
        weight = 50,
        function_type = "health", -- Type of function
        model = "models/items/healthkit.mdl", -- Path to the model
        description = "Restores 50 health points."
    },
    
    -- Food Item
    food_item = {
        name = "Food Item",
        value = 25, -- Amount of food it restores
        weight = 200,
        stat = "hunger",
        model = "models/props_c17/oildrum001.mdl", -- Path to the model (example)
        description = "Restores 25 food points."
    },

    -- Entity Item
    entity_item = {
        name = "Entity Item",
        value = 100, -- Example value for the entity
        function_type = "entity", -- Type of function
        model = "models/props_combine/breenbust.mdl", -- Path to the model
        description = "An example entity item with a specific function."
    },
    
    -- Weapons
    shotgun = {
        name = "Shotgun",
        value = "weapon_shotgun", -- Example value for the weapon
        weight = 300,
        function_type = "weapon", -- Type of function
        model = "models/weapons/c_shotgun.mdl", -- Path to the model
        description = "THE SHOOOTGUN"
    },

    crossbow = {
        name = "Crossbow",
        value = "weapon_crossbow", -- Example value for the weapon
        weight = 80,
        function_type = "weapon", -- Type of function
        model = "models/weapons/w_crossbow.mdl", -- Path to the model
        description = "A power weapon"
    },



    -- Armor
    armor_item = {
        name = "Armor Item",
        value = 75, -- Amount of armor it provides
        function_type = "armor", -- Type of function
        model = "models/sal/acc/armor01.mdl", -- Path to the model (example)
        description = "Provides 75 armor points."
    }
}

VAPR_CURRENCIES_CONFIG = {
    money = {
        symbol = "$",
        displayOnHUD = true
    }
}

VAPR_SHOPS_CONFIG = {
    shop1 = {
        name = "General Store",
        color = Color(59, 130, 246, 255), -- Couleur configurable
        categories = {
            health = {
                name = "Health Items",
                items = {
                    health_pack = {
                        buy_price = 100,
                        sell_price = 50
                    }
                }
            },
            food = {
                name = "Food Items",
                items = {
                    food_item = {
                        buy_price = 50,
                        sell_price = 25
                    }
                }
            }
        }
    },
    shop2 = {
        name = "Weapons Shop",
        color = Color(27, 40, 56, 255), -- Couleur configurable
        categories = {
            weapons = {
                name = "Weapons",
                items = {
                    shotgun = {
                        buy_price = 500,
                        sell_price = 250
                    },
                    crossbow = {
                        buy_price = 750,
                        sell_price = 375
                    }
                }
            }
        }
    }
}


-- Configuration pour le créateur de personnage
VAPR_CHARACTER_CREATOR_CONFIG = {
    -- Champs disponibles pour la création de personnage
    fields = {
        {name= "Type", type= "ComboBox", options= {"Human", "Undead", "Alien"}},
        {name= "Faction", type= "ComboBox", options= {"Citizens", "Rebels", "Bad Guys"}},
        {name = "Sex", type = "ComboBox", options = {"Male", "Female"}},
        {name = "Age", type = "NumberWang"},
        {name = "First Name", type = "TextEntry"},
        {name = "Last Name", type = "TextEntry"}
    },
    -- Modèles de personnages disponibles classés par sexe et tranche d'âge
    models = {
        {
            type = "Undead",
            path = "models/player/corpse1.mdl"
        },
        {
            type = "Alien",
            path = "models/vortigaunt.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Male",
            path = "models/player/Group01/male_02.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Male",
            path = "models/player/Group01/male_03.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Male",
            path = "models/player/Group01/Male_04.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Male",
            path = "models/player/Group01/Male_05.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Female",
            path = "models/player/Group01/Female_01.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Female",
            path = "models/player/Group01/Female_02.mdl"
        },
        {
            type = "Human",
            faction = "Citizens",
            sex = "Female",
            path = "models/player/Group01/Female_03.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Male",
            path = "models/player/Group03/Male_01.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Male",
            path = "models/player/Group03/male_02.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Male",
            path = "models/player/Group03/male_03.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Female",
            path = "models/player/Group03/Female_01.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Female",
            path = "models/player/Group03/Female_02.mdl"
        },
        {
            type = "Human",
            faction = "Rebels",
            sex = "Female",
            path = "models/player/Group03/Female_03.mdl"
        },
        {
            type = "Human",
            faction = "Bad Guys",
            path = "models/player/Police.mdl"
        },
        {
            type = "Human",
            faction = "Bad Guys",
            path = "models/player/Combine_Soldier.mdl"
        },
        {
            type = "Human",
            faction = "Bad Guys",
            path = "models/player/Combine_Soldier_PrisonGuard.mdl"
        },
        {
            type = "Human",
            faction = "Bad Guys",
            path = "models/player/Combine_Super_Soldier.mdl"
        },
    },
}

NextHUD_config = {
    ShowHealthBar = true,
    ShowArmorBar = true,
    ShowAmmo = true,
    ShowHungerBar = true,
    ShowVehicleHUD = true,
    Show3DDoorInfo = true,
    ShowGesturesMenu = true
}

VAPR_HungerConfig = {
    damagePerSecond = 0, -- Damage per second when hunger is at 0
    decayInterval = 1,   -- Interval in seconds for hunger reduction
    hungerDecrease = 1   -- Hunger points lost per interval
}