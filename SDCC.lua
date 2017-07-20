-------------------------------------------
-- Globals
-------------------------------------------
sdct = {}

-------------------------------------------
-- Locals
-------------------------------------------
local version = 1
local defaults = {
	anykey = true
}
local saved
local LAM = LibStub:GetLibrary("LibAddonMenu-2.0")
local registered = false

-------------------------------------------
-- Bindings
-------------------------------------------
function SDCC_SKIP()
	SlowDialogsGlobal.Skip()
end

function SDCC_ANYKEY()
	if saved.anykey then
		SlowDialogsGlobal.Skip()
	end
end

-------------------------------------------
-- Settings
-------------------------------------------
local function InitSettings()  
 	local panel = {
         type = "panel",
         name = "Slow Dialog - Custom Controlls",
    }

    LAM:RegisterAddonPanel("SDCC", panel)
    local data = {
		[1] = {
			type = "checkbox",
			name = sdct.loc.SDCC_SKIP_TITLE,
			tooltip = sdct.loc.ST_ANY_DESC,
			getFunc = function() return saved.anykey end,
			setFunc = ToggleAnyKey
		}
    }
    LAM:RegisterOptionControls("SDCC", data)
end

local function ToggleAnyKey(value)
	saved.anykey = value
	if value then 
		EVENT_MANAGER:RegisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN, SDCC_ANYKEY)
		registered = true
	elseif registered then
		EVENT_MANAGER:UnregisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN)
		registered = false
	end
end

-------------------------------------------
-- Start
-------------------------------------------
local function OnAddOnLoaded(eventCode, addOnName)
    if(addOnName ~= "SDCC") then return end
	
	saved = ZO_SavedVars:NewAccountWide("SDCC", version, nil, defaults) 

	InitSettings()   

    EVENT_MANAGER:UnregisterForEvent("SDCC", EVENT_ADD_ON_LOADED)
	
	ToggleAnyKey(saved.anykey) 
end
--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent("SDCC", EVENT_ADD_ON_LOADED, OnAddOnLoaded)