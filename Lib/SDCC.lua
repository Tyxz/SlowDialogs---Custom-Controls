--[[----------------------------------------------
    Project:    Slow Dialogs - Custom Controls
    Author:     Arne Rantzen (Tyx)
    Created:    2017-07-20
    Updated:    2020-02-14
    License:    GPL-3.0
----------------------------------------------]]--

-- -----------------------------------------
-- Globals
-- -----------------------------------------
SDCC = SDCC or {}

-- -----------------------------------------
-- Locals
-- -----------------------------------------
SDCC.name = "SDCC"
SDCC.version = 1
SDCC.defaults = {
    anykey = true
}

-- -----------------------------------------
-- Bindings
-- -----------------------------------------
function SDCC.SKIP()
	SlowDialogsGlobal.Skip()
end

-- -----------------------------------------
-- Settings
-- -----------------------------------------

--- Create menu in LibAddonMenu2 settings if available
function SDCC:InitSettings()
    local LAM = LibAddonMenu2
    local panel = {
        type = "panel",
        name = "Slow Dialog - Custom Controlls",
    }

    if LAM then
        LAM:RegisterAddonPanel(self.name, panel)
        local data = {
            [1] = {
                type = "checkbox",
                name = self.loc.SDCC_SKIP_TITLE,
                tooltip = self.loc.ST_ANY_DESC,
                getFunc = function() return self.saved.anykey end,
                setFunc = function(value) self:SetAnyKey(value) end
            }
        }
        LAM:RegisterOptionControls(self.name, data)
    end
end

--- Register if skipped when mouse pressed
-- @param bool if mouse down can be used to skip
function SDCC:SetAnyKey(useMouse)
	self.saved.anykey = useMouse
	if useMouse then
		EVENT_MANAGER:RegisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN, SDCC.SKIP)
	else
		EVENT_MANAGER:UnregisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN)
	end
end

-- -----------------------------------------
-- Start
-- -----------------------------------------
local function OnAddOnLoaded(_, addOnName)
    if(addOnName ~= "SDCC") then return end

	SDCC.saved = ZO_SavedVars:NewAccountWide(SDCC.name, SDCC.version, nil, SDCC.defaults)

	SDCC:InitSettings()

    EVENT_MANAGER:UnregisterForEvent(SDCC.name, EVENT_ADD_ON_LOADED)

	SDCC:SetAnyKey(SDCC.saved.anykey)
end
--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(SDCC.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)