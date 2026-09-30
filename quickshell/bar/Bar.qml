import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.config

// One taskbar per screen:
// [Start][workspaces] | [windows ..........] | [tray] [VOL][BAT][Notif][clock]
PanelWindow {
    id: bar

    required property ShellScreen modelData

    screen: modelData
    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    exclusiveZone: implicitHeight
    color: "transparent"
    WlrLayershell.namespace: "plasticbar"

    // Full-width bar docked to the bottom edge.
    Bevel {
        anchors.fill: parent
        radius: 0
        faceColor: Theme.bar
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 9
        anchors.rightMargin: 9
        anchors.topMargin: 5
        anchors.bottomMargin: 8
        spacing: 4

        StartButton {
            screen: bar.screen
            Layout.fillHeight: true
        }

        Workspaces {
            screen: bar.screen
            Layout.fillHeight: true
        }

        Separator {}

        Taskbar {
            screen: bar.screen
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Separator {}

        SysTray {
            Layout.fillHeight: true
        }

        VolumeButton {
            Layout.fillHeight: true
        }

        BatteryButton {
            Layout.fillHeight: true
        }

        NotifButton {
            Layout.fillHeight: true
        }

        Clock {
            Layout.fillHeight: true
        }
    }
}
