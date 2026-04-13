> **Warning: Requires [BazCore](https://www.curseforge.com/wow/addons/bazcore) and [BazWidgetDrawers](https://www.curseforge.com/wow/addons/bazwidgetdrawers).** If you use the CurseForge app, they will be installed automatically. Manual users must install both separately.

# BazWidgets

![WoW](https://img.shields.io/badge/WoW-12.0_Midnight-blue) ![License](https://img.shields.io/badge/License-GPL_v2-green) ![Version](https://img.shields.io/github/v/tag/bazsec/BazWidgets?label=Version&color=orange)

A widget pack addon for BazWidgetDrawers - adds community and utility widgets that dock into the drawer alongside the built-in ones.

BazWidgets serves two purposes: it provides useful widgets that extend BazWidgetDrawers beyond its core set, and it acts as a reference implementation for third-party addon authors who want to create their own widget packs using the LibBazWidget-1.0 API.

***

## Features

### Dormant Widgets

Some widgets are **dormant** - they only appear in the drawer when they're relevant. When their trigger condition clears, they unregister entirely: no slot, no title bar, no wasted space. Dormant widgets are marked with **[D]** in the settings list and can still be reordered and configured while dormant.

### Seamless Integration

*   Widgets dock into BazWidgetDrawers with full title bar, collapse, and fade support
*   Per-widget settings accessible via BazWidgetDrawers > Widgets
*   Drag-to-reorder, floating mode, and all host features work automatically
*   Widget order is preserved across sessions

***

## Included Widgets

### Dungeon Finder

Queue status panel that auto-appears when you queue for a dungeon via LFG.

*   **Dormant** - only registers when actively queued, disappears when not
*   Role fill indicators (tank / healer / DPS) with color-coded counts
*   Average wait time estimate
*   Live queue timer displayed in the widget title bar
*   Dungeon name subtitle
*   Leave Queue button
*   Title switches to green "Group Found!" on proposal

### Repair

Three-column durability display showing your gear condition at a glance.

*   Paper doll / damaged-slot list / durability percent layout
*   Worst-damaged slots listed first, color-graded green to red
*   Average durability shown in the widget title bar
*   Three paper-doll modes: custom icon grid, native DurabilityFrame, or none
*   Option to permanently hide Blizzard's default durability figure
*   Taint-safe suppression via hooksecurefunc

***

## For Widget Authors

Want to create your own widget pack? BazWidgets is your reference. Each widget file demonstrates the full pattern:

1.  Get the addon handle via `BazCore:GetAddon("BazWidgetDrawers")`
2.  Build your widget frame
3.  Register via `BazCore:RegisterDockableWidget()` for always-on widgets
4.  Or use `LibStub("LibBazWidget-1.0"):RegisterDormantWidget()` for contextual widgets
5.  Implement optional callbacks: `GetDesiredHeight()`, `GetStatusText()`, `GetOptionsArgs()`

See the [LibBazWidget-1.0 README](https://github.com/bazsec/LibBazWidget) for the full widget contract.

***

## Compatibility

*   **WoW Version:** Retail 12.0 (Midnight)
*   **Midnight API Safe:** Uses taint-safe patterns throughout
*   **Combat Safe:** No secure frame reparenting or protected method overrides

***

## Dependencies

**Required:**

*   [BazCore](https://www.curseforge.com/wow/addons/bazcore) - shared framework for Baz Suite addons
*   [BazWidgetDrawers](https://www.curseforge.com/wow/addons/bazwidgetdrawers) - the widget drawer host

***

## Part of the Baz Suite

BazWidgets is part of the **Baz Suite** of addons, all built on the [BazCore](https://www.curseforge.com/wow/addons/bazcore) framework:

*   **[BazBars](https://www.curseforge.com/wow/addons/bazbars)** - Custom extra action bars
*   **[BazWidgetDrawers](https://www.curseforge.com/wow/addons/bazwidgetdrawers)** - Slide-out widget drawer
*   **[BazWidgets](https://www.curseforge.com/wow/addons/bazwidgets)** - Widget pack for BazWidgetDrawers
*   **[BazNotificationCenter](https://www.curseforge.com/wow/addons/baznotificationcenter)** - Toast notification system
*   **[BazLootNotifier](https://www.curseforge.com/wow/addons/bazlootnotifier)** - Animated loot popups
*   **[BazFlightZoom](https://www.curseforge.com/wow/addons/bazflightzoom)** - Auto zoom on flying mounts
*   **[BazMap](https://www.curseforge.com/wow/addons/bazmap)** - Resizable map and quest log window
*   **[BazMapPortals](https://www.curseforge.com/wow/addons/bazmapportals)** - Mage portal/teleport map pins

***

## License

BazWidgets is licensed under the **GNU General Public License v2** (GPL v2).
