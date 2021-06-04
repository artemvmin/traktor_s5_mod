import QtQuick 2.0
import QtGraphicalEffects 1.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

import '../../Widgets' as Widgets

Item {
  id: scrollBar
  property int currentPosition: 0
  anchors.fill: parent
  anchors.verticalCenter: parent.verticalCenter

  Column {
    spacing: 3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    Repeater {
      model: 8
      Rectangle {
        width: 6
        height: 16
        color: (scrollBar.currentPosition == index) ? colors.colorWhite : colors.colorGrey40
      }
    }
  }

  Widgets.Triangle {
    id : arrowUp
    width:  10
    height: 9
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:  10
    color: colors.colorGrey40
    rotation: 180
    antialiasing: true
  }

  Widgets.Triangle {
    id : arrowDown
    width:  10
    height: 9
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin:  11
    color: colors.colorGrey40
    rotation: 0
    antialiasing: true
  }
}

