import QtQuick 2.0
import CSI 1.0

import '../../../../Defines' as Defines

CenterOverlay {
  id: mixerfx

  property int  deckId:    0

  Defines.Margins {id: customMargins }

  //--------------------------------------------------------------------------------------------------------------------
  AppProperty { id: mixerFXOn;     path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.on" }
  AppProperty { id: mixerFX;       path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.select" }

  MappingProperty { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1" }
  MappingProperty { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2" }
  MappingProperty { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3" }
  MappingProperty { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4" }

  readonly property variant mixerFXNames: ["Filter", "Reverb", "Delay", "Noise", "Gater"]

  //--------------------------------------------------------------------------------------------------------------------

  // headline
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        customMargins.topMarginCenterOverlayHeadline
    font.pixelSize:           fonts.largeFontSize
    color:                    colors.colorCenterOverlayHeadline
    text:                     "MIXER FX"
  }

  // value
  Text {
    anchors.top:              parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:        50
    font.pixelSize:           fonts.extraLargeValueFontSize
    font.family:              "Pragmatica"
    color:                    mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey40
    text:                     mixerFXNames[mixerFX.value]
  }

  // footline
  Text {
    anchors.bottom:           parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:     30.0
    font.pixelSize:           fonts.smallFontSize
    color:                    colors.colorGrey72
    text:                     "Push BROWSE to set " + mixerFXNames[mixerFX.value] + " on all decks"
  }

  Text {
    anchors.bottom:            parent.bottom
    anchors.horizontalCenter:  parent.horizontalCenter
    anchors.bottomMargin:      14.0
    font.pixelSize:            fonts.smallFontSize
    visible:                   mixerFX.value != 0 ? 1 : 0	
    color:                     colors.colorGrey104
    text:                      "Press BACK to reset to Filter"
  }
}
