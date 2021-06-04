import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

import './../Widgets' as Widgets
import '../../../../Defines'

//------------------------------------------------------------------------------------------------------------------
// LIST ITEM - DEFINES THE INFORMATION CONTAINED IN ONE LIST ITEM
//------------------------------------------------------------------------------------------------------------------

Rectangle {
  id: footer

  property string propertiesPath: ""
  property real  sortingKnobValue: 0.0
  property bool  isContentList:    qmlBrowser.isContentList

  /*
  0 --> Sort By
  1 --> Icons
  2 --> Title
  3 --> Artist
  4 --> Time
  5 --> BPM
  6 --> Track
  7 --> Release
  8 --> Label
  9 --> Genre
  10 --> KEY Text
  11 --> Comment
  12 --> Lyrics
  13 --> Comment 2
  14 --> File
  15 --> Analyzed
  16 --> Remixer
  17 --> Producer
  18 --> Mix
  19 --> Catalog Number
  20 --> Release Date
  21 --> Bitrate
  22 --> Rating
  23 --> Play Count
  24 --> PreListen
  25 --> Cover Art
  26 --> Last Played
  27 --> Import Date
  28 --> KEY
  29 --> Color
  */

  readonly property variant sortIds:          [0, 5, 28, 3, 2]
  readonly property variant sortNames:        ["Sort By", "BPM", "Key", "Artist", "Title"]

  property          real    preSortingKnobValue: 0.0

  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: previewIsLoaded;     path : "app.traktor.browser.preview_player.is_loaded" }
  AppProperty { id: previewTrackLenght;  path : "app.traktor.browser.preview_content.track_length" }
  AppProperty { id: previewTrackElapsed; path : "app.traktor.browser.preview_player.elapsed_time" }

  MappingProperty { id: isContentListProp; path: propertiesPath + ".browser.is_content_list" }

//--------------------------------------------------------------------------------------------------------------------
// Behavior on Sorting Changes (show/hide sorting widget, select next allowed sorting)
//--------------------------------------------------------------------------------------------------------------------

  onIsContentListChanged: {
    // We need this to be able do disable mappings (e.g. sorting ascend/descend)
    isContentListProp.value = isContentList;
  }

  onSortingKnobValueChanged: {
    if (!footer.isContentList) {
      return
    }

    var delta = parseInt(clamp(footer.sortingKnobValue - footer.preSortingKnobValue, -1, 1))
    if (delta != 0) {
      qmlBrowser.sortingId   = getSortingIdWithDelta(delta)
      footer.preSortingKnobValue = footer.sortingKnobValue
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// View
//--------------------------------------------------------------------------------------------------------------------

  clip: true
  anchors.left:   parent.left
  anchors.right:  parent.right
  anchors.bottom: parent.bottom
  height:         21 // set in state
  color:          "transparent"

  // Background Color
  Rectangle {
    id: browserFooterBg
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: parent.bottom
    height:         15
    color:          colors.colorBrowserHeader // footer background color
  }

  // Sorting Arrow
  Widgets.Triangle {
    id :                 sortArrow
    width:               (qmlBrowser.sortingId > 0 ? 8 : 0)
    height:              4
    anchors.top:         browserFooterBg.top
    anchors.topMargin:   6
    anchors.right:       browserFooterBg.right
    anchors.rightMargin: (qmlBrowser.sortingId > 0 ? 10 : 0)
    antialiasing:        false
    visible:             (qmlBrowser.isContentList && qmlBrowser.sortingId > 0)
    color:               colors.colorGrey80
    rotation:            ((qmlBrowser.sortingDirection == 0) ? 0 : 180)
  }

  // Sorting Text
  Text {
    font.pixelSize:      fonts.scale(12)
    anchors.top:         browserFooterBg.top
    anchors.right:       sortArrow.left
    anchors.rightMargin: 10
    font.capitalization: Font.AllUppercase
    color:               colors.colorFontBrowserHeader
    text:                getSortingNameForSortId(qmlBrowser.sortingId)
    visible:             qmlBrowser.isContentList
  }

  // Preview Text
  Text {
    id:                  previewText
    anchors.top:         browserFooterBg.top
    anchors.left:        browserFooterBg.left
    anchors.leftMargin:  10
    font.pixelSize:      fonts.scale(12)
    font.capitalization: Font.AllUppercase
    color:               colors.colorFontBrowserHeader
    text:                "Preview"
  }

  // Preview Icon
  Image {
    id:                  previewIcon
    anchors.top:         browserFooterBg.top
    anchors.topMargin:   2
    anchors.left:        previewText.right
    anchors.leftMargin:  10
    visible:             previewIsLoaded.value
    antialiasing:        false
    source:              "../Images/PreviewIcon_Small.png"
    fillMode:            Image.Pad
    cache:               false
    sourceSize.width:    width
    sourceSize.height:   height
  }

  // Preview Elapsed Time
  Text {
    id:                  previewElapsed
    anchors.top:         browserFooterBg.top
    anchors.topMargin:   2
    anchors.left:        previewIcon.right
    anchors.leftMargin:  10
    font.pixelSize:      fonts.scale(12)
    font.capitalization: Font.AllUppercase
    font.family:         "Pragmatica"
    visible:             previewIsLoaded.value
    color:               colors.browser.prelisten
    text:                utils.convertToTimeString(previewTrackElapsed.value)
  }

//--------------------------------------------------------------------------------------------------------------------
// black border & shadow
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: browserHeaderBottomGradient
    height:         3
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserHeaderBlackBottomLine.top
    gradient: Gradient {
      GradientStop { position: 0.0; color: colors.colorBlack0 }
      GradientStop { position: 1.0; color: colors.colorBlack38 }
    }
  }

  Rectangle {
    id: browserHeaderBlackBottomLine
    height:         2
    color:          colors.colorBlack
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserFooterBg.top
  }

  //------------------------------------------------------------------------------------------------------------------

  state: "show"
  states: [
  State {
    name: "show"
    PropertyChanges{ target: footer; height: 21 }
    },
    State {
      name: "hide"
      PropertyChanges{ target: footer; height: 0 }
    }
  ]


//--------------------------------------------------------------------------------------------------------------------
// Necessary Functions
//--------------------------------------------------------------------------------------------------------------------

  function getSortingIdWithDelta(delta) {
    var curPos = getPosForSortId(qmlBrowser.sortingId)
    var newPos = (curPos + delta + sortIds.length) % sortIds.length
    return sortIds[newPos]
  }

  function getPosForSortId(id) {
    if (id == -1) return 0; // -1 is a special case which should be interpreted as "0"
    for (var i=0; i<sortIds.length; i++) {
      if (sortIds[i] == id) return i;
    }
    return -1;
  }

  function getSortingNameForSortId(id) {
    var pos = getPosForSortId(id);
    if (pos < 0 || pos >= sortNames.length)
      pos = 0;
    return sortNames[pos];
  }

  function clamp(val, min, max){
    return Math.max( Math.min(val, max) , min );
  }
}
