import CSI 1.0
import QtQuick 2.0

import '../../../../Defines' as Defines

// dimensions are set in CenterOverlay.qml

CenterOverlay {
  id: captureSource

  Defines.Margins { id: customMargins }

  property int  deckId:    0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: captureSrc; path: "app.traktor.decks." + (deckId+1) + ".capture_source" }

  function captureSourceColor() {
    var src = captureSrc.description

    if (src == "Deck A" || src == "Deck B") {
      return colors.colorDeckBlueBright
    }
    return colors.colorWhite
  }

  //--------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "CAPTURE"
  }

  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        39
    font.pixelSize:           fonts.superLargeValueFontSize
    font.capitalization:      Font.AllUppercase
    color:                    captureSourceColor()
    text:                     captureSrc.description
  }
}
