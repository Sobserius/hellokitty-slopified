pragma Singleton

import Quickshell
import QtQuick

// Bubblegum Hello Kitty theme — the one and only.
Singleton {
    id: root

    // ---- Settings ------------------------------------------------------

    readonly property int fontSize: 12
    readonly property int fontSizeSmall: 11
    readonly property int barHeight: 36
    readonly property int radius: 9
    readonly property int radiusLarge: 16

    readonly property string startIcon: ""
    readonly property string startLabel: "Start Menu"
    readonly property string terminal: "kitty"

    // ---- Palette (bubblegum light) ------------------------------------

    readonly property color bar: "#f5a3c7"
    readonly property color face: "#f8b8d4"
    readonly property color faceHover: "#fbc8df"
    readonly property color facePressed: "#ee94bb"
    readonly property color activeFace: "#e8559a"
    readonly property color activeFaceHover: "#ee69a7"
    readonly property color activeText: "#ffffff"

    readonly property color bevelHighlight: "#ffffff"
    readonly property color bevelLight: "#ffffff"
    readonly property color bevelDark: "#c0457f"
    readonly property color bevelShadow: "#5c1a3a"

    readonly property color window: "#fff8fb"
    readonly property color windowBorder: "#f29cc3"
    readonly property color field: "#ffffff"

    readonly property color text: "#4a1530"
    readonly property color textDim: "#7a3558"
    readonly property color textMuted: "#b98aa2"

    readonly property color selection: "#ec6aa8"
    readonly property color selectionText: "#ffffff"
    readonly property color titleInactive: "#f8cde0"
    readonly property color titleInactiveText: "#4a1530"
    readonly property color warning: "#d9304a"

    readonly property string font: "Comic Sans MS"
}
