import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.bar
import qs.config
import qs.notifications
import qs.services

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Bar {}
    }

    Toasts {}

    // `qs ipc call startmenu toggle` (e.g. bound to SUPER in Hyprland)
    // opens the start menu on the focused monitor.
    IpcHandler {
        target: "startmenu"

        function toggle(): void {
            Popups.startMenuRequested(Hyprland.focusedMonitor?.name ?? "")
        }
    }

    IpcHandler {
        target: "notifications"

        function toggleDnd(): void {
            Notifs.dnd = !Notifs.dnd
        }

        function clear(): void {
            Notifs.clear()
        }
    }
}
