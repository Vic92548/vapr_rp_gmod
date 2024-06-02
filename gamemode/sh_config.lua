VAPR_STATS_CONFIG = {
    limits = {
        money = {default = 1000, min = 0, max = 0, changeOverTime = 0, visible = true},  -- max 0 means no maximum
        health = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = true},
        stamina = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = true},
        stamina = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = true},
        hunger = {default = 100, min = 0, max = 100, changeOverTime = -5, visible = true},
        wanted_level = {default = 0, min = 0, max = 100000000, changeOverTime = -50, visible = true}
    }
}

VAPR_ITEMS_CONFIG = {
    -- Health Pack
    health_pack = {
        name = "Health Pack",
        value = 50, -- Amount of health it restores
        function_type = "health", -- Type of function
        model = "models/items/healthkit.mdl", -- Path to the model
        description = "Restores 50 health points."
    },
    
    -- Food Item
    food_item = {
        name = "Food Item",
        value = 25, -- Amount of food it restores
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
        function_type = "weapon", -- Type of function
        model = "models/weapons/c_shotgun.mdl", -- Path to the model
        description = "THE SHOOOTGUN"
    },

    crossbow = {
        name = "Crossbow",
        value = "weapon_crossbow", -- Example value for the weapon
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

VAPR_SHOP_CONFIG = {

}

VAPR_CHARACTER_CREATOR_CONFIG = {
    -- Available fields for character creation
    fields = {
        {name = "Sex", type = "ComboBox", options = {"Male", "Female"}},
        {name = "Age", type = "NumberWang"},
        {name = "First Name", type = "TextEntry"},
        {name = "Last Name", type = "TextEntry"}
    },
    -- Available character models categorized by sex and age range
    models = {
        Male = {
            Adult = {
                "models/player/Group01/male_01.mdl",
                "models/player/Group01/male_02.mdl",
                "models/player/Group01/male_03.mdl"
            },
            Child = {
                "models/player/child/male_01.mdl"
                -- Add more child male models if available
            }
        },
        Female = {
            Adult = {
                "models/player/Group01/female_01.mdl",
                "models/player/Group01/female_02.mdl",
                "models/player/Group01/female_03.mdl"
            },
            Child = {
                "models/player/child/female_01.mdl"
                -- Add more child female models if available
            }
        }
    }
}