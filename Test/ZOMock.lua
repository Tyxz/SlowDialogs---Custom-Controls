--- Mocks the ZO functions for ESO
--- luarocks install luasocket

SlowDialogsGlobal = {
    Skip = function() end
}

LibAddonMenu2 = {}
function LibAddonMenu2:RegisterAddonPanel(_, _) end
function LibAddonMenu2:RegisterOptionControls(_, _) end

ZO_SavedVars = {}
function ZO_SavedVars:NewAccountWide(_, _, _, defaults) return defaults end

function ZO_CreateStringId(_, _) end

EVENT_MANAGER = {}
function EVENT_MANAGER:RegisterForEvent(eventHandle, _, OnCall)
    OnCall(nil, eventHandle)
end
function EVENT_MANAGER:UnregisterForEvent(_, _) end
EVENT_GLOBAL_MOUSE_DOWN = 0
EVENT_ADD_ON_LOADED = 1
