pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Colours come from config/themes/<id>.json, each with a "light" and a
// "dark" palette. The chosen theme and mode are saved in Quickshell's state
// dir, so they survive restarts. Switch with the Start menu's "Themes..."
// button (or right-click Start) or `qs ipc call theme ...`.
//
// A theme only has to list the colours it changes; the rest fall back to
// `fallback` below (the Grape light palette).
Singleton {
    id: root

    // ---- Settings ------------------------------------------------------

    readonly property string defaultTheme: "bubblegum"
    readonly property bool defaultDark: false

    readonly property int fontSize: 12
    readonly property int fontSizeSmall: 11
    readonly property int barHeight: 36
    // Corner radius of buttons and wells, and of popups / cards.
    readonly property int radius: 9
    readonly property int radiusLarge: 16

    readonly property string startIcon: ""
    readonly property string startLabel: "Start Menu"
    readonly property string terminal: "kitty"

    // ---- Current theme -------------------------------------------------

    readonly property string current: saved.theme
    readonly property bool dark: saved.dark
    readonly property string name: themeFile.parsed?.name ?? current
    // [{ id, name }] for every file in config/themes, sorted by name.
    property var themes: []

    function setTheme(id: string) {
        saved.theme = id
        // Update window border to match theme
        Qt.createQmlObject('import Quickshell.Io; Process { command: ["bash", "/home/sob/hyprland-minions/hypr/assets/update-border.sh"]; running: true }', this)
    }

    function setDark(value: bool) {
        saved.dark = value
    }

    // ---- Palette ---------------------------------------------------------

    // Plastic shading (see components/Bevel.qml): bevelHighlight is the
    // gloss on top, bevelLight the bounce light near the bottom edge,
    // bevelDark the moulded rim and bevelShadow drop and inner shadows.
    readonly property color bevelHighlight: pick("bevelHighlight")
    readonly property color bevelLight: pick("bevelLight")
    readonly property color bevelDark: pick("bevelDark")
    readonly property color bevelShadow: pick("bevelShadow")

    readonly property color bar: pick("bar")
    readonly property color face: pick("face")
    readonly property color faceHover: pick("faceHover")
    readonly property color facePressed: pick("facePressed")
    // Toggled buttons: focused window, open popup, current workspace.
    readonly property color activeFace: pick("activeFace")
    readonly property color activeFaceHover: pick("activeFaceHover")
    readonly property color activeText: palette.activeText ?? pick("text")

    // Popups, tooltips, and sunken wells (text fields, lists, sliders).
    readonly property color window: pick("window")
    readonly property color windowBorder: pick("windowBorder")
    readonly property color field: pick("field")

    readonly property color text: pick("text")
    readonly property color textDim: pick("textDim")
    readonly property color textMuted: pick("textMuted")

    // Highlighted menu rows, notification title bars, start menu banner,
    // slider fill, today in the calendar.
    readonly property color selection: pick("selection")
    readonly property color selectionText: pick("selectionText")
    readonly property color titleInactive: pick("titleInactive")
    readonly property color titleInactiveText: pick("titleInactiveText")
    readonly property color warning: pick("warning")

    // Themes may name a font; if it isn't installed, Inter is used.
    readonly property string font: {
        const wanted = themeFile.parsed?.font ?? ""
        return wanted !== "" && Qt.fontFamilies().includes(wanted) ? wanted : "Comic Sans MS"
    }

    readonly property var fallback: ({
        bevelHighlight: "#ffffff",
        bevelLight: "#ffffff",
        bevelDark: "#d1478c",
        bevelShadow: "#5c1a3a",
        bar: "#ffb3d9",
        face: "#ffc4e0",
        faceHover: "#ffd1e8",
        facePressed: "#ff9ecd",
        activeFace: "#ff69b4",
        activeFaceHover: "#ff7dc0",
        activeText: "#ffffff",
        window: "#fff5fa",
        windowBorder: "#ff8fc7",
        field: "#ffffff",
        text: "#4a1530",
        textDim: "#7a3558",
        textMuted: "#b98aa2",
        selection: "#ff69b4",
        selectionText: "#ffffff",
        titleInactive: "#ffd6ea",
        titleInactiveText: "#4a1530",
        warning: "#d9304a"
    })

    readonly property var palette: themeFile.parsed?.[dark ? "dark" : "light"] ?? {}

    function pick(key) {
        return palette[key] ?? fallback[key]
    }

    // ---- Files ---------------------------------------------------------

    readonly property string themeDir: Quickshell.shellPath("config/themes")

    FileView {
        id: themeFile

        property var parsed: null

        path: `${root.themeDir}/${root.current}.json`
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                parsed = JSON.parse(text())
            } catch (e) {
                console.warn(`Theme ${path}: ${e}`)
                parsed = null
            }
        }
        onLoadFailed: parsed = null
    }

    FileView {
        path: Quickshell.statePath("theme.json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: saved

            property string theme: root.defaultTheme
            property bool dark: root.defaultDark
        }
    }

    // Collect every theme's id and display name.
    Process {
        running: true
        command: ["sh", "-c", 'cd "$1" && grep -H -m1 \'"name"\' -- *.json', "sh", root.themeDir]
        stdout: StdioCollector {
            onStreamFinished: {
                root.themes = text.split("\n").filter(line => line !== "").map(line => {
                    const id = line.slice(0, line.indexOf(".json:"))
                    const name = line.match(/"name"\s*:\s*"([^"]*)"/)?.[1] ?? id
                    return { id, name }
                }).sort((a, b) => a.name.localeCompare(b.name))
            }
        }
    }
}
