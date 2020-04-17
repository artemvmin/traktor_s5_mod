import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../Widgets' as Widgets

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

Item {
  id: deck_header

  // QML-only deck types
  readonly property int thruDeckType:  4

  // Placeholder variables for properties that have to be set in the elements for completeness - but are actually set
  // in the states
  readonly property int    _intSetInState:    0

  // Here all the properties defining the content of the DeckHeader are listed. They are set in DeckView.
  property int    deck_Id:           0
  property string headerState:      "large" // this property is used to set the state of the header (large/small)

  readonly property variant deckLetters:        ["A",                         "B",                          "C",                  "D"                 ]
  readonly property variant textColors:         [colors.colorDeckBlueBright,  colors.colorDeckBlueBright,   colors.colorGrey232,  colors.colorGrey232 ]
  readonly property variant darkerTextColors:   [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey72,   colors.colorGrey72  ]
  // color for empty cover bg
  readonly property variant coverBgEmptyColors: [colors.colorDeckBlueDark,    colors.colorDeckBlueDark,     colors.colorGrey48,   colors.colorGrey48  ]
  // color for empty cover circles
  readonly property variant circleEmptyColors:  [colors.rgba(0, 37, 54, 255),  colors.rgba(0,  37, 54, 255),                       colors.colorGrey24,   colors.colorGrey24  ]

  readonly property variant loopText:           ["/32", "/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]
  readonly property variant emptyDeckCoverColor:["Blue", "Blue", "White", "White"] // deckId = 0,1,2,3

  // these variables can not be changed from outside
  readonly property int speed: 40  // Transition speed
  readonly property int smallHeaderHeight: 17
  readonly property int largeHeaderHeight: 45

  readonly property int topMargin: 2
  readonly property int topMarginSecondRow: 20
  readonly property int sideMargin: 5
  readonly property int timeOffset: 40
  readonly property int deckRightMargin: 14

  readonly property int rightMargin_middleText_large: 115
  readonly property int rightMargin_rightText_large:  45

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property double syncPhase:   (headerPropertySyncPhase.value*2.0).toFixed(2)
  readonly property int    loopSizePos: headerPropertyLoopSize.value

  function hasTrackStyleHeader(deckType)      { return (deckType == DeckType.Track  || deckType == DeckType.Stem);  }

  // PROPERTY SELECTION
  // IMPORTANT: See 'stateMapping' in DeckHeaderText.qml for the correct Mapping from
  //            the state-enum in c++ to the corresponding state
  // NOTE: For now, we set fix states in the DeckHeader! But we wanna be able to
  //       change the states.
  property int topLeftState:      0                                 // headerSettingTopLeft.value
  property int topMiddleState:    hasTrackStyleHeader(deckType) ? 12 : 30 // headerSettingTopMid.value
  property int topRightState:     23                                // headerSettingTopRight.value

  property int bottomLeftState:   1                                 // headerSettingMidLeft.value
  property int bottomMiddleState: hasTrackStyleHeader(deckType) ? 17 : 29 // headerSettingMidMid.value
  property int bottomRightState:  24

  property int mixerState: 31

  height: largeHeaderHeight
  clip: false //true
  Behavior on height { NumberAnimation { duration: speed } }

  readonly property int warningTypeNone:    0
  readonly property int warningTypeWarning: 1
  readonly property int warningTypeError:   2

  property bool isError:   (deckHeaderWarningType.value == warningTypeError)

//--------------------------------------------------------------------------------------------------------------------
//  TEMPO PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propMixerStableTempo; path: "app.traktor.decks." + (deckId+1) + ".tempo.true_tempo" }

  function getTempoBendColor() {
    var tempo = (propMixerStableTempo.value - 1) * 100;

    if (-5 < tempo && tempo < 5){
      return colors.colorBendLow;
    }
    return colors.colorBendHigh;
  }

//--------------------------------------------------------------------------------------------------------------------
//  KEY PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: keyId;      path: "app.traktor.decks." + (deckId+1) + ".track.key.final_id" }
  AppProperty { id: keyEnable;  path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }

  property var keyColor: keyEnable.value && keyId.value >= 0 ? colors.musicalKeyColors[keyId.value] : colors.colorWhite

  function toInt(val) { return parseInt(val); }

//--------------------------------------------------------------------------------------------------------------------
//  MIXERFX PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: mixerFX;   path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.select" }
  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.on" }

  property var mixerFXColor: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72

//--------------------------------------------------------------------------------------------------------------------
//  DECK PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: deckTypeProperty;           path: "app.traktor.decks." + (deck_Id+1) + ".type" }

  AppProperty { id: directThru;                 path: "app.traktor.decks." + (deck_Id+1) + ".direct_thru"; onValueChanged: { updateHeader() } }
  AppProperty { id: headerPropertyCover;        path: "app.traktor.decks." + (deck_Id+1) + ".content.cover_md5" }
  AppProperty { id: headerPropertySyncPhase;    path: "app.traktor.decks." + (deck_Id+1) + ".tempo.phase"; }
  AppProperty { id: headerPropertyLoopActive;   path: "app.traktor.decks." + (deck_Id+1) + ".loop.active"; }
  AppProperty { id: headerPropertyLoopSize;     path: "app.traktor.decks." + (deck_Id+1) + ".loop.size"; }

  AppProperty { id: deckHeaderWarningActive;       path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".active"; }
  AppProperty { id: deckHeaderWarningType;         path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".type";   }
  AppProperty { id: deckHeaderWarningMessage;      path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".long";   }
  AppProperty { id: deckHeaderWarningShortMessage; path: "app.traktor.informer.deckheader_message." + (deck_Id+1) + ".short";  }

//--------------------------------------------------------------------------------------------------------------------
//  STATE OF THE DECK HEADER LABELS
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: headerSettingTopLeft;       path: "app.traktor.settings.deckheader.top.left";  }
  AppProperty { id: headerSettingTopMid;        path: "app.traktor.settings.deckheader.top.mid";   }
  AppProperty { id: headerSettingTopRight;      path: "app.traktor.settings.deckheader.top.right"; }
  AppProperty { id: headerSettingMidLeft;       path: "app.traktor.settings.deckheader.mid.left";  }
  AppProperty { id: headerSettingMidMid;        path: "app.traktor.settings.deckheader.mid.mid";   }
  AppProperty { id: headerSettingMidRight;      path: "app.traktor.settings.deckheader.mid.right"; }

  AppProperty { id: sequencerOn;   path: "app.traktor.decks." + (deckId + 1) + ".remix.sequencer.on" }
  readonly property bool showStepSequencer: (deckType == DeckType.Remix) && sequencerOn.value && (screen.flavor != ScreenFlavor.S5)
  onShowStepSequencerChanged: { updateLoopSize(); }

//--------------------------------------------------------------------------------------------------------------------
//  UPDATE VIEW
//--------------------------------------------------------------------------------------------------------------------

  Component.onCompleted:  { updateHeader(); }
  onHeaderStateChanged:   { updateHeader(); }
  onIsLoadedChanged:      { updateHeader(); }
  onDeckTypeChanged:      { updateHeader(); }
  onSyncPhaseChanged:     { updateHeader(); }
  onIsMasterChanged:      { updateHeader(); }

  function updateHeader() {
    updateExplicitDeckHeaderNames();
    updateCoverArt();
    updateLoopSize();
    updatePhaseSyncBlinker();
  }



//--------------------------------------------------------------------------------------------------------------------
//  PHASE SYNC BLINK
//--------------------------------------------------------------------------------------------------------------------

  function updatePhaseSyncBlinker() {
    phase_sync_blink.enabled = (  headerState != "small"
                               && isLoaded
                               && !directThru.value
                               && !isMaster
                               && deckType != DeckType.Live
                               && bottom_right_text.text == "SYNC"
                               && syncPhase != 0.0 ) ? 1 : 0;
  }

  Timer {
    id: phase_sync_blink
    property bool enabled: false
    interval: 200; running: true; repeat: true
    onTriggered: bottom_right_text.visible = enabled ? !bottom_right_text.visible : true
    onEnabledChanged: { bottom_right_text.visible = true }
  }



//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id:top_line;
    anchors.horizontalCenter: parent.horizontalCenter
    width:  (headerState == "small") ? deck_header.width-18 : deck_header.width
    height: 0 // 1
    color:  textColors[deck_Id]
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  Rectangle {
    id: stem_text
    width:  35; height: 14
    y: 3
    x: top_left_text.x + top_left_text.paintedWidth + 5

    color:         colors.colorBgEmpty
    border.width:  1
    border.color:  textColors[deck_Id]
    radius:        3
    opacity:        0.6

    visible:       (deckType == DeckType.Stem) || showStepSequencer
    Text { x: showStepSequencer ? 5 : 3; y:1; text: showStepSequencer ? "STEP" : "STEM"; color: textColors[deck_Id]; font.pixelSize:fonts.miniFontSize }

    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // top_left_text: TITLE
  DeckHeaderText {
    id:                 top_left_text
    deckId:             deck_Id
    explicitName:       ""

    maxTextWidth:       (deckType == DeckType.Stem) ? 175 - stem_text.width : 175
    color:              textColors[deck_Id]
    textState:          topLeftState
    font.family:         "Pragmatica"
    elide:              Text.ElideRight

    anchors.top:        top_line.bottom
    anchors.left:       cover_small.right
    anchors.topMargin:  0

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on font.pixelSize     { NumberAnimation { duration: speed } }
    Behavior on maxTextWidth       { NumberAnimation { duration: speed } }
  }

  // bottom_left_text: ARTIST
  DeckHeaderText {
    id:                 bottom_left_text
    deckId:             deck_Id
    explicitName:       ""

    maxTextWidth:       directThru.value ? 1000 : 175
    color:              darkerTextColors[deck_Id]
    textState:          bottomLeftState
    font.family:         "Pragmatica"
    font.pixelSize:     fonts.middleFontSize
    elide:              Text.ElideRight

    anchors.top:        top_line.bottom
    anchors.left:       cover_small.right
    anchors.leftMargin: sideMargin
    anchors.topMargin:  topMarginSecondRow

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
  }

  // top_middle_text: REMAINING TIME
  DeckHeaderText {
    id:                  top_middle_text
    deckId:              deck_Id
    explicitName:        ""

    maxTextWidth:        80
    color:               textColors[deck_Id]
    textState:           topMiddleState
    font.family:         "Pragmatica"
    horizontalAlignment: Text.AlignRight
    elide:               Text.ElideRight

    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.topMargin:   topMargin

    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
    Behavior on font.pixelSize      { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // bottom_middle_text: DYNAMIC KEY
  DeckHeaderText {
    id:                  bottom_middle_text
    deckId:              deck_Id
    explicitName:        ""

    maxTextWidth :       80
    color:               keyColor
    textState:           bottomMiddleState
    font.family:         "Pragmatica"
    font.pixelSize:      fonts.middleFontSize
    horizontalAlignment: Text.AlignRight
    elide:               Text.ElideRight

    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.rightMargin: rightMargin_middleText_large

    Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
  }

  // top_right_text: BPM
  DeckHeaderText {
    id:                  top_right_text
    deckId:              deck_Id
    explicitName:        ""

    maxTextWidth:        80
    color:               textColors[deck_Id]
    textState:           topRightState
    font.family:         "Pragmatica"
    font.pixelSize:      fonts.largeFontSize
    horizontalAlignment: Text.AlignRight
    elide:               Text.ElideRight

    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.topMargin:   topMargin
    anchors.rightMargin: rightMargin_rightText_large

    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  // bottom_right_text: TEMPO BEND
  DeckHeaderText {
    id:                   bottom_right_text
    deckId:               deck_Id
    explicitName:         ""

    maxTextWidth:         80
    color:                getTempoBendColor()
    textState:            bottomRightState
    font.family:          "Pragmatica"
    font.pixelSize:       fonts.middleFontSize
    horizontalAlignment:  Text.AlignRight
    elide:                Text.ElideRight

    anchors.top:          top_line.bottom
    anchors.right:        parent.right
    anchors.rightMargin:  rightMargin_rightText_large

    onTextChanged:                { updateHeader() }
    Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
//  Deck Letter
//--------------------------------------------------------------------------------------------------------------------

  Text {
    id:                  deck_letter

    color:               textColors[deck_Id]
    text:                deckLetters[deck_Id]
    font.family:         "Pragmatica"
    font.pixelSize:      fonts.largeFontSize
    horizontalAlignment: Text.AlignRight

    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.topMargin:   topMargin
    anchors.rightMargin: deckRightMargin

    Behavior on opacity  { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
//  Mixer FX
//--------------------------------------------------------------------------------------------------------------------

  DeckHeaderText {
    id:                  mixer_fx_text
    deckId:              deck_Id
    explicitName:        ""

    color:               mixerFXColor
    textState:           mixerState
    font.family:         "Pragmatica"
    font.pixelSize:      fonts.middleFontSize
    horizontalAlignment: Text.AlignRight

    anchors.top:         top_line.bottom
    anchors.right:       parent.right
    anchors.rightMargin: sideMargin

    Behavior on anchors.topMargin { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
//  Unloaded Deck
//--------------------------------------------------------------------------------------------------------------------

  function updateExplicitDeckHeaderNames()
  {
    if (directThru.value) {
      top_left_text.explicitName      = "Direct Thru";
      bottom_left_text.explicitName   = "The Mixer Channel is currently In Thru mode";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Live) {
      top_left_text.explicitName      = "Live Input";
      bottom_left_text.explicitName   = "Traktor Audio Passthru";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if ((deckType == DeckType.Track)  && !isLoaded) {
      top_left_text.explicitName      = "No Track Loaded";
      bottom_left_text.explicitName   = "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Stem && !isLoaded) {
      top_left_text.explicitName      = "No Stem Loaded";
      bottom_left_text.explicitName   = "Push Browse Knob";
      // Force the the following DeckHeaderText to be empty
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else if (deckType == DeckType.Remix && !isLoaded) {
      top_left_text.explicitName      = " ";
      // Force the the following DeckHeaderText to be empty
      bottom_left_text.explicitName   = " ";
      top_middle_text.explicitName    = " ";
      top_right_text.explicitName     = " ";
      bottom_middle_text.explicitName = " ";
      bottom_right_text.explicitName  = " ";
    }
    else {
      // Switch off explicit naming!
      top_left_text.explicitName      = "";
      bottom_left_text.explicitName   = "";
      top_middle_text.explicitName    = "";
      top_right_text.explicitName     = "";
      bottom_middle_text.explicitName = "";
      bottom_right_text.explicitName  = "";
    }
  }

//--------------------------------------------------------------------------------------------------------------------
//  Cover Art
//--------------------------------------------------------------------------------------------------------------------

  // Inner Border
  function updateCoverArt() {
    if (headerState == "small" || deckType == DeckType.Live || directThru.value) {
      cover_small.opacity       = 0;
      cover_small.width         = 0;
      cover_small.height        = 17;
      cover_innerBorder.opacity = 0;
    } else {
      cover_small.opacity       = 1;
      cover_small.width         = (!isLoaded ? 0 : 36);
      cover_small.height        = 36;
      cover_innerBorder.opacity = (!isLoaded || (headerPropertyCover.value == "")) ? 0 : 1;
    }
  }

  Rectangle {
    id: blackBorder
    color: "black"
    anchors.fill: cover_small
    anchors.margins: -1
  }

  DropShadow {
    anchors.fill: blackBorder
    cached: false
    fast: false
    horizontalOffset: 0
    verticalOffset: 0
    radius: 3.0
    samples: 32
    spread: 0.5
    color: "#000000"
    transparentBorder: true
    source: blackBorder
  }

  Rectangle {
    id: cover_small
    anchors.top: top_line.bottom
    anchors.left: parent.left
    anchors.topMargin: topMargin
    anchors.leftMargin: 3
    width:  _intSetInState
    height: _intSetInState

    // if no cover can be found: blue / grey background (set in parent). Otherwise transparent
    opacity:  (headerPropertyCover.value == "") ? 1.0 : 0.0
    //visible: headerState == "large" && (opacity == 1.0)
    color:  coverBgEmptyColors[deck_Id]
    Behavior on opacity { NumberAnimation { duration: speed } }
    Behavior on width { NumberAnimation { duration: speed } }
    Behavior on height { NumberAnimation { duration: speed } }

    Image {
      id: coverImage
      source: "image://covers/" + ((isLoaded) ? headerPropertyCover.value : "" )
      anchors.fill: parent
      sourceSize.width: width
      sourceSize.height: height
      visible: isLoaded
      opacity: (headerPropertyCover.value == "") ? 0.3 : 1.0
      fillMode: Image.PreserveAspectCrop
      Behavior on height   { NumberAnimation { duration: speed } }
    }
  }

  Rectangle {
    id: cover_innerBorder
    color: "transparent"
    border.width: 1
    border.color: colors.colorWhite16
    height: cover_small.height
    width: height
    anchors.top: cover_small.top
    anchors.left: cover_small.left
  }

//--------------------------------------------------------------------------------------------------------------------
//  Loop Size
//--------------------------------------------------------------------------------------------------------------------

  function updateLoopSize() {
    if (  headerState == "large" && isLoaded && (hasTrackStyleHeader(deckType) || (deckType == DeckType.Remix )) && !directThru.value ) {
      loop_size.opacity = 1.0;
      loop_size.opacity = showStepSequencer ? 0.0 : 1.0;
      stem_text.opacity = 0.6
    } else {
      loop_size.opacity = 0.0;
      stem_text.opacity = 0.0;
    }
  }

  Widgets.SpinningWheel {
    id: loop_size
    anchors.top: top_line.bottom
    anchors.topMargin: topMargin
    anchors.horizontalCenter: parent.horizontalCenter
    // anchors.right: parent.right
    // anchors.rightMargin: 178

    width: 30
    height: 30

    spinning: false
    opacity: loop_size.opacity
    textColor: headerPropertyLoopActive.value ? colors.colorGreen50 : textColors[deck_Id]
    Behavior on opacity             { NumberAnimation { duration: speed } }
    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }

    Text {
      id: numberText
      text: loopText[loopSizePos]
      color: headerPropertyLoopActive.value ? colors.colorGreen : textColors[deck_Id]
      font.pixelSize: fonts.scale((loopSizePos < 5) ? 14 : 18);
      font.family: "Pragmatica MediumTT"
      anchors.fill: loop_size
      anchors.rightMargin: 1
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment:   Text.AlignVCenter
    }
  }

//--------------------------------------------------------------------------------------------------------------------
//  WARNING MESSAGES
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: warning_box
    anchors.bottom:     parent.bottom
    anchors.topMargin:  topMarginSecondRow
    anchors.right:      deck_letter.left
    anchors.left:       cover_small.right
    anchors.leftMargin: sideMargin
    height:             parent.height -1
    color:              colors.colorBlack
    visible:            deckHeaderWarningActive.value

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }

    Text {
      id: top_warning_text
      color:              isError ? colors.colorRed : colors.colorOrange
      font.pixelSize:     fonts.largeFontSize // set in state

      text: deckHeaderWarningShortMessage.value

      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  -1 // set by 'state'
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    Text {
      id: bottom_warning_text
      color:      isError ? colors.colorRed : colors.colorOrangeDimmed
      elide:      Text.ElideRight
      font.pixelSize:     fonts.middleFontSize

      text: deckHeaderWarningMessage.value


      anchors.top:        parent.top
      anchors.left:       parent.left
      anchors.topMargin:  topMarginSecondRow
      Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
      Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }
  }

  Timer {
    id: warningTimer
    interval: 1200
    repeat: true
    running: deckHeaderWarningActive.value
    onTriggered: {
      if (warning_box.opacity == 1) {
        warning_box.opacity = 0;
      } else {
        warning_box.opacity = 1;
      }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
//  STATES FOR THE DIFFERENT HEADER SIZES
//--------------------------------------------------------------------------------------------------------------------

  state: headerState

  states: [
    State {
      name: "small";
      PropertyChanges { target: deck_header;
                        height: smallHeaderHeight }

      PropertyChanges { target: top_left_text;
                        anchors.leftMargin: 1;
                        font.pixelSize: fonts.middleFontSize;
                        maxTextWidth: (deckType == DeckType.Stem) ? 210 - stem_text.width : 210 }

      PropertyChanges { target: bottom_left_text;    opacity: 0; }
      PropertyChanges { target: bottom_warning_text; opacity: 0; }

      PropertyChanges { target: top_middle_text;
                        font.pixelSize: fonts.middleFontSize;
                        anchors.rightMargin: (deckType == DeckType.Track) ? rightMargin_middleText_large + timeOffset : rightMargin_middleText_large;
                        opacity: (deckType == DeckType.Track) ? 1 : 0 }

      PropertyChanges { target: top_right_text;      opacity: 0; }
      PropertyChanges { target: deck_letter;         opacity: 0; }

      PropertyChanges { target: bottom_middle_text;
                        anchors.topMargin: topMargin }
      PropertyChanges { target: bottom_right_text;
                        anchors.topMargin: topMargin }
      PropertyChanges { target: mixer_fx_text;
                        anchors.topMargin: topMargin }
    },
    State {
      name: "large";
      PropertyChanges { target: deck_header;
                        height: largeHeaderHeight }

      PropertyChanges { target: top_left_text;
                        anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : sideMargin;
                        font.pixelSize: fonts.largeFontSize;
                        maxTextWidth: (deckType == DeckType.Stem) ? 175 - stem_text.width : 175 }

      PropertyChanges { target: bottom_left_text;   opacity: 1;
                        anchors.leftMargin: (deckType.description === "Live Input" || directThru.value) ? -1 : sideMargin }

      PropertyChanges { target: top_middle_text;
                        font.pixelSize: fonts.largeFontSize;
                        anchors.rightMargin: rightMargin_middleText_large;
                        opacity: 1 }

      PropertyChanges { target: top_right_text;      opacity: 1; }
      PropertyChanges { target: deck_letter;         opacity: 1; }

      PropertyChanges { target: bottom_middle_text;  opacity: 1;
                        anchors.topMargin: topMarginSecondRow }
      PropertyChanges { target: bottom_right_text;   opacity: 1;
                        anchors.topMargin: topMarginSecondRow }
      PropertyChanges { target: mixer_fx_text;       opacity: 1;
                        anchors.topMargin: topMarginSecondRow }
    }
  ]
}
