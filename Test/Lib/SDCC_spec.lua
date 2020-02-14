require("Test.ZOMock")
require("Lib.Core.Constants")
require("Lib.I18n.en")

describe("ZOMock", function()
    it("should return defaults", function()
        local tTable = {test = 1}
        local tReturn = ZO_SavedVars:NewAccountWide(nil,nil,nil,tTable)
        assert.is.same(tTable, tReturn)
    end)

    it("should call function with name", function()
        local tSpy = spy.new(function(_, _) end)
        local tName = "Test"
        EVENT_MANAGER:RegisterForEvent(tName, nil, tSpy)
        assert.spy(tSpy).was.called_with(nil, tName)
    end)
end)

describe("SDCC", function()
    local match = require("luassert.match")
    insulate("functions", function()
        require("Lib.SDCC")
        it("should register menu", function()
            LibAddonMenu2 = mock(LibAddonMenu2, true)
            SDCC:InitSettings()
            assert.spy(LibAddonMenu2.RegisterAddonPanel).was.called_with(
                    match.is_ref(LibAddonMenu2), match.is_string(), match.is_table()
            )
            assert.spy(LibAddonMenu2.RegisterOptionControls).was.called_with(
                    match.is_ref(LibAddonMenu2), match.is_string(), match.is_table()
            )
        end)
        describe("setup mouse event", function()
            EVENT_MANAGER = mock(EVENT_MANAGER)
            it("should register mouse event if true", function()
                SDCC:SetSkipWithMouse(true)
                assert.spy(EVENT_MANAGER.RegisterForEvent).was.called_with(
                        match.is_ref(EVENT_MANAGER),
                        match.is_string(), EVENT_GLOBAL_MOUSE_DOWN, match.is_ref(SDCC_SKIP)
                )
            end)
            it("should unregister mouse event if false", function()
                SDCC:SetSkipWithMouse(false)
                assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
                        match.is_ref(EVENT_MANAGER), match.is_string(), EVENT_GLOBAL_MOUSE_DOWN
                )
            end)
            it("should store parameter in saved variable", function()
                local opposite = not SDCC.saved.skipWithMouse
                SDCC:SetSkipWithMouse(opposite)
                assert.is.equal(opposite, SDCC.saved.skipWithMouse)
            end)
        end)
        it("should call parent skip", function()
            SlowDialogsGlobal = mock(SlowDialogsGlobal)
            SDCC_SKIP()
            assert.spy(SlowDialogsGlobal.Skip).was.called()
        end)
    end)
    insulate("initialize event", function()
        setup(function()
            EVENT_MANAGER = mock(EVENT_MANAGER)
            ZO_SavedVars = mock(ZO_SavedVars)
            require("Lib.SDCC")
            SDCC = mock(SDCC)
            SDCC:Initialize()
        end)
        it("should create saved var when started", function()
            assert.spy(ZO_SavedVars.NewAccountWide).was.called_with(
                    match.is_ref(ZO_SavedVars), match.is_string(), match.is_number(), nil, match.is_table())
        end)
        it("should register menu", function()
            assert.spy(SDCC.InitSettings).was.called_with(match.is_ref(SDCC))
        end)
        it("should setup mouse event from saved variable", function()
            assert.spy(SDCC.SetSkipWithMouse).was.called_with(match.is_ref(SDCC), SDCC.saved.skipWithMouse)
        end)
        it("should unregister from load event", function()
            assert.spy(EVENT_MANAGER.UnregisterForEvent).was.called_with(
                    match.is_ref(EVENT_MANAGER), match.is_string(), EVENT_ADD_ON_LOADED)
        end)
    end)
end)