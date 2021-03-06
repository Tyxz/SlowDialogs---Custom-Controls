--[[----------------------------------------------
    Project:    Slow Dialogs - Custom Controls
    Author:     Arne Rantzen (Tyx)
    Created:    2017-07-20
    Updated:    2020-02-14
    License:    GPL-3.0
----------------------------------------------]]--
SDCC = SDCC or {}

-- -----------------------------------------
-- Bindings
-- -----------------------------------------

--- Call the parent skip function
function SDCC_SKIP()
	SlowDialogsGlobal.Skip()
end

-- -----------------------------------------
-- Settings
-- -----------------------------------------

--- Create menu in LibAddonMenu2 settings if available
function SDCC:InitSettings()
    local LAM = LibAddonMenu2
    if LAM then
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
                    getFunc = function() return self.saved.skipWithMouse end,
                    setFunc = function(value) self:SetSkipWithMouse(value) end
                }
            }
            LAM:RegisterOptionControls(self.name, data)
        end
    end
end

--- Register if skipped when mouse pressed
--- @param useMouse boolean if mouse down can be used to skip
function SDCC:SetSkipWithMouse(useMouse)
    self.saved.skipWithMouse = useMouse
	if useMouse then
		EVENT_MANAGER:RegisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN, SDCC_SKIP)
	else
		EVENT_MANAGER:UnregisterForEvent("SDCC_ANYKEY", EVENT_GLOBAL_MOUSE_DOWN)
	end
end

-- -----------------------------------------
-- Start
-- -----------------------------------------

--- Initialize addon
--- @param _ number of event
--- @param addOnName string name of addon
function SDCC:Initialize(_, addOnName)
    if(addOnName ~= self.name) then return end

    self.saved = ZO_SavedVars:NewAccountWide(self.name .. "_Settings", self.version, nil, self.defaults)

    self:InitSettings()

    self:SetSkipWithMouse(self.saved.skipWithMouse)

    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
end

--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(SDCC.name, EVENT_ADD_ON_LOADED, function(...) SDCC:Initialize(...) end)