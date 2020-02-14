std = "min+busted+eso"
stds.eso = {
    globals = {
        "SDCC",
        "SlowDialogsGlobal",
        "LibAddonMenu2",
        "ZO_SavedVars",
        "ZO_CreateStringId",
        "EVENT_MANAGER",
        "EVENT_ADD_ON_LOADED",
        "EVENT_GLOBAL_MOUSE_DOWN",
    },
    read_globals = {
    }
}
self = false
exclude_files = {
    "Test/ZOMock.lua",
}
include_files = {
    "Lib/**/*.lua",
    "Test/**/*.lua"
}