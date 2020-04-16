import QtQuick 2.0
import CSI 1.0

Rectangle {
  id: footer

  property int            deckId:             0
  property bool           isAnalyzing:        false
  readonly property int   maxHeight:          20

  readonly property variant knobLabel:    ["OFFSET", "BPM"]
  readonly property variant xPositioning: [35, 405]
  // readonly property variant margin:       [19, 8, 0, 6]

  height: 20
  color:  colors.colorBgEmpty

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: bpm; path: "app.traktor.decks." + (deckId+1) + ".track.grid.adjust_bpm" }

  //--------------------------------------------------------------------------------------------------------------------  

  // dividers
  Rectangle { id: line1; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 119 }
  Rectangle { id: line2; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 359 }

  // large BPM value
  Text {
    text:                     (isAnalyzing) ? "analyzing..." : bpm.value.toFixed(2).toString()
    color:                    colors.colorWhite
    font.pixelSize:           fonts.largeValueFontSize
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter:   parent.verticalCenter
    anchors.verticalCenterOffset:        1
  }


  Repeater {
    model: 4
    // labels
    Text {
      id: text

      text:                   knobLabel[index]
      width:                  footer.width/4 - 12         // 3px space left and right
      x:                      xPositioning[index]
      y:                      7
      color:                  colors.colorFontFxHeader
      font.pixelSize:         fonts.smallFontSize
      visible:                !isAnalyzing;
    }
  }
}
