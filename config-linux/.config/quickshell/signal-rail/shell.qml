//@ pragma ShellId signal-rail
//@ pragma IconTheme Colloid-Dracula-Dark
//@ pragma NativeTextRendering

import QtQuick
import Quickshell
import qs.components
import qs.services
import qs.surfaces
import qs.theme

ShellRoot {
  id: root

  property bool reducedMotion: false

  Theme { id: rootTheme; reducedMotion: root.reducedMotion }
  IconGlyphs { id: rootGlyphs }
  WorkspacePreviewService { id: rootWorkspacePreview }

  SystemStats {
    id: rootStats
  }

  NetworkInfo {
    id: rootNetworkInfo
  }
  ConnectivityService {
    id: rootConnectivity
    networkInfo: rootNetworkInfo
  }
  AudioService { id: rootAudio }
  AppService { id: rootAppService }
  NotificationService { id: rootNotifications; theme: rootTheme }

  Variants {
    model: Quickshell.screens

    Scope {
      id: screenScope
      required property var modelData

      RailSurface {
        modelData: screenScope.modelData
        theme: rootTheme
      }

      ReservationSurface {
        modelData: screenScope.modelData
        theme: rootTheme
      }

      BarSurface {
        modelData: screenScope.modelData
        theme: rootTheme
        stats: rootStats
        connectivity: rootConnectivity
        audio: rootAudio
        appService: rootAppService
        workspacePreview: rootWorkspacePreview
        glyphs: rootGlyphs
      }

      NotificationSurface {
        modelData: screenScope.modelData
        theme: rootTheme
        notificationService: rootNotifications
        closeGlyph: rootGlyphs.close
      }
    }
  }
}
