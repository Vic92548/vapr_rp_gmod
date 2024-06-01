VAPR_STATS_CONFIG = {
    limits = {
        money = {default = 1000, min = 0, max = 0, changeOverTime = 0, visible = true},  -- max 0 means no maximum
        health = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = true},
        stamina = {default = 100, min = 0, max = 100, changeOverTime = 0, visible = true},
        hunger = {default = 100, min = 0, max = 100, changeOverTime = -5, visible = true},
        wanted_level = {default = 0, min = 0, max = 100000000, changeOverTime = -50, visible = true}
    }
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