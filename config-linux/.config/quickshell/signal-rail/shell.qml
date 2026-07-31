//@ pragma ShellId signal-rail
//@ pragma IconTheme Colloid-Dracula-Dark
//@ pragma NativeTextRendering

import QtQuick
import Quickshell

ShellRoot {
  SystemStats {
    id: rootStats
  }

  NetworkInfo {
    id: rootNetworkInfo
  }

  Variants {
    model: Quickshell.screens

    Scope {
      id: screenScope
      required property var modelData

      Rail {
        modelData: screenScope.modelData
      }

      Reservation {
        modelData: screenScope.modelData
      }

      Bar {
        modelData: screenScope.modelData
        stats: rootStats
        networkInfo: rootNetworkInfo
      }
    }
  }
}
