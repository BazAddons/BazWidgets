-- BazWidgets Widget: Item Level
--
-- Shows the player's equipped iLevel as the headline number, with the
-- overall (best-available) iLevel as a sub-label. When the two numbers
-- differ, the equipped value tints yellow as a gentle nudge that there
-- is better gear sitting in your bags.

local addon = BazCore:GetAddon("BazWidgetDrawers")
if not addon then return end

local WIDGET_ID     = "bazwidgets_itemlevel"
local DESIGN_WIDTH  = 200
local DESIGN_HEIGHT = 44
local PAD           = 8

local ItemLevel = {}
addon.ItemLevelWidget = ItemLevel

---------------------------------------------------------------------------
-- Read iLevel
--
-- GetAverageItemLevel returns three numbers:
--   overall   — best-available gear (includes items in bags)
--   equipped  — what's currently worn
--   pvp       — PvP-scaled level (we ignore this for the headline)
---------------------------------------------------------------------------

local function GetLevels()
    local overall, equipped = 0, 0
    if GetAverageItemLevel then
        overall, equipped = GetAverageItemLevel()
    end
    return tonumber(overall) or 0, tonumber(equipped) or 0
end

local function FormatLevel(level)
    if level <= 0 then return "—" end
    -- One decimal of precision matches Blizzard's character pane display
    return string.format("%.1f", level)
end

local function ColorForDelta(overall, equipped)
    -- Within half a level: optimally geared → gold
    if math.abs(overall - equipped) < 0.5 then
        return 1.00, 0.82, 0.00
    end
    -- Equipped is meaningfully lower than overall → yellow nudge
    return 1.00, 0.95, 0.40
end

---------------------------------------------------------------------------
-- Frame
---------------------------------------------------------------------------

local frame

function ItemLevel:Build()
    if frame then return frame end
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetSize(DESIGN_WIDTH, DESIGN_HEIGHT)

    -- Chest-piece icon to evoke "gear"
    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetSize(28, 28)
    f.icon:SetPoint("LEFT", PAD, 0)
    f.icon:SetTexture("Interface\\Icons\\inv_chest_plate10")
    f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Equipped level (large headline)
    f.equipped = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.equipped:SetPoint("LEFT", f.icon, "RIGHT", 8, 6)
    f.equipped:SetJustifyH("LEFT")

    -- Sub-label: "Item Level" plus overall in parentheses when it differs
    f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.sub:SetPoint("LEFT", f.icon, "RIGHT", 8, -8)
    f.sub:SetJustifyH("LEFT")
    f.sub:SetTextColor(0.85, 0.85, 0.85)

    frame = f
    return f
end

function ItemLevel:Refresh()
    if not frame then return end
    local overall, equipped = GetLevels()

    frame.equipped:SetText(FormatLevel(equipped))
    frame.equipped:SetTextColor(ColorForDelta(overall, equipped))

    if math.abs(overall - equipped) < 0.5 then
        frame.sub:SetText("Item Level")
    else
        frame.sub:SetText(string.format("Item Level  |cff999999(avg %s)|r",
            FormatLevel(overall)))
    end

    if addon.WidgetHost and addon.WidgetHost.UpdateWidgetStatus then
        addon.WidgetHost:UpdateWidgetStatus(WIDGET_ID)
    end
end

function ItemLevel:GetDesiredHeight() return DESIGN_HEIGHT end

function ItemLevel:GetStatusText()
    local overall, equipped = GetLevels()
    return FormatLevel(equipped), ColorForDelta(overall, equipped)
end

---------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------

function ItemLevel:Init()
    local f = self:Build()

    BazCore:RegisterDockableWidget({
        id           = WIDGET_ID,
        label        = "Item Level",
        designWidth  = DESIGN_WIDTH,
        designHeight = DESIGN_HEIGHT,
        frame        = f,
        GetDesiredHeight = function() return ItemLevel:GetDesiredHeight() end,
        GetStatusText    = function() return ItemLevel:GetStatusText() end,
    })

    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    -- iLevel can change from azerite/relic/sock infusions; cover the
    -- catch-all bag and equipment events too so we don't miss updates.
    f:RegisterEvent("UNIT_INVENTORY_CHANGED")
    f:HookScript("OnEvent", function(_, event, unit)
        if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end
        ItemLevel:Refresh()
    end)

    self:Refresh()
end

BazCore:QueueForLogin(function()
    -- Defer slightly so GetAverageItemLevel returns populated values
    -- (during the very first PLAYER_LOGIN frame it can return zeros).
    C_Timer.After(0.5, function() ItemLevel:Init() end)
end)
