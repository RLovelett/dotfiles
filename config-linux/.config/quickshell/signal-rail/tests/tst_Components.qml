import QtQuick
import QtTest
import qs.components
import qs.theme

TestCase {
  name: "Components"

  Theme { id: rootTheme; reducedMotion: true }

  Component {
    id: morphComponent
    MorphingCapsule {
      theme: rootTheme
      contentWidth: 40
      expandedWidth: 220
      expandedHeight: 120
      headerData: Rectangle {
        objectName: "headerProbe"
        anchors.fill: parent
      }
      Rectangle {
        objectName: "expandedProbe"
        anchors.fill: parent
      }
    }
  }

  Component {
    id: cardComponent
    Card {
      theme: rootTheme
      minimumWidth: 160
      StyledText {
        text: "Notification content"
        theme: rootTheme
      }
    }
  }

  function test_morphOwnsExpandedGeometryAndStableRadius() {
    const morph = createTemporaryObject(morphComponent, this)
    verify(morph !== null)
    compare(morph.width, morph.collapsedWidth)
    morph.expanded = true
    tryCompare(morph, "width", 220)
    tryCompare(morph, "height", 120)
    compare(morph.cornerRadius, rootTheme.metrics.capsuleHeight / 2)
    verify(morph.contentRevealed)
  }

  function test_morphSlotsOwnTheirChildGeometry() {
    const morph = createTemporaryObject(morphComponent, this)
    verify(morph !== null)
    const header = findChild(morph, "headerProbe")
    const expanded = findChild(morph, "expandedProbe")
    verify(header !== null)
    verify(expanded !== null)
    compare(header.height, rootTheme.metrics.capsuleHeight)
    compare(header.width, morph.width)
    morph.expanded = true
    tryCompare(expanded, "width", morph.expandedWidth - morph.expandedContentHorizontalPadding * 2)
  }

  function test_cardSizesFromContentAndConstraints() {
    const card = createTemporaryObject(cardComponent, this)
    verify(card !== null)
    compare(card.width, 160)
    verify(card.height > rootTheme.metrics.capsulePadding * 2)
    verify(card.desiredWidth > rootTheme.metrics.capsulePadding * 2)
  }
}
