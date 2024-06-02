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

VAPR_SHOP_CONFIG = {

}

-- Configuration pour le créateur de personnage
VAPR_CHARACTER_CREATOR_CONFIG = {
    -- Champs disponibles pour la création de personnage
    fields = {
        {name = "Sex", type = "ComboBox", options = {"Male", "Female"}},
        {name = "Age", type = "NumberWang"},
        {name = "First Name", type = "TextEntry"},
        {name = "Last Name", type = "TextEntry"}
    },
    -- Modèles de personnages disponibles classés par sexe et tranche d'âge
    models = {
        Male = {
            Adult = {
                "models/player/Group01/male_01.mdl",
                "models/player/Group01/male_02.mdl",
                "models/player/Group01/male_03.mdl"
            },
            Child = {
                "models/player/child/male_01.mdl"
                -- Ajouter d'autres modèles d'enfants masculins si disponibles
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
                -- Ajouter d'autres modèles d'enfants féminins si disponibles
            }
        }
    },
}
