import CSI 1.0
import QtQuick 2.0

//--------------------------------------------------------------------------------------------------------------------
//  DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

Text {
  id: header_text

  property int              maxTextWidth : 200
  property int              textState: 0       // this property sets the state of this label (artist, album, bpm, ...)
  property int              deckId: 0
  property double           syncLabelOpacity: 0.6

  // by setting this string, we can suppres the properties below and expicit define a name
  property string           explicitName: " "

  readonly property int     deckType:  propDeckType.value
  readonly property int     isLoaded:  (primaryKey.value > 0) || (deckType == DeckType.Remix)
  readonly property double  cuePos:    (propNextCuePoint.value >= 0) ? propNextCuePoint.value : propTrackLength.value*1000
  readonly property int     isInSync:  propIsInSync.value
  readonly property int     isMaster:  (propSyncMasterDeck.value == deckId) ? 1 : 0

  readonly property string  fontForNumber: "Pragmatica"
  readonly property string  fontForString: "Pragmatica MediumTT"


  // Properties of the TextItem itself. Anchors are set from outside
  x:        0
  y:        0
  width:       (maxTextWidth == 0 || text.paintedWidth > maxTextWidth) ? text.paintedWidth : maxTextWidth
  text:        ""
  font.family: fontForString


//--------------------------------------------------------------------------------------------------------------------
//  DECK PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: propDeckType;       path: "app.traktor.decks." + (deckId+1) + ".type" }
  AppProperty { id: primaryKey;         path: "app.traktor.decks." + (deckId+1) + ".track.content.entry_key" }

  AppProperty { id: propTitle;          path: "app.traktor.decks." + (deckId+1) + ".content.title" }
  AppProperty { id: propArtist;         path: "app.traktor.decks." + (deckId+1) + ".content.artist" }
  AppProperty { id: propAlbum;          path: "app.traktor.decks." + (deckId+1) + ".content.album" }
  AppProperty { id: propGenre;          path: "app.traktor.decks." + (deckId+1) + ".content.genre" }
  AppProperty { id: propComment;        path: "app.traktor.decks." + (deckId+1) + ".content.comment" }
  AppProperty { id: propComment2;       path: "app.traktor.decks." + (deckId+1) + ".content.comment2" }
  AppProperty { id: propLabel;          path: "app.traktor.decks." + (deckId+1) + ".content.label" }
  AppProperty { id: propMix;            path: "app.traktor.decks." + (deckId+1) + ".content.mix" }
  AppProperty { id: propRemixer;        path: "app.traktor.decks." + (deckId+1) + ".content.remixer" }
  AppProperty { id: propCatNo;          path: "app.traktor.decks." + (deckId+1) + ".content.catalog_number" }
  AppProperty { id: propGridOffset;     path: "app.traktor.decks." + (deckId+1) + ".content.grid_offset" }
  AppProperty { id: propBitrate;        path: "app.traktor.decks." + (deckId+1) + ".content.bitrate"; }

  AppProperty { id: propTrackLength;    path: "app.traktor.decks." + (deckId+1) + ".track.content.track_length"; }
  AppProperty { id: propElapsedTime;    path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; }
  AppProperty { id: propNextCuePoint;   path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }

  AppProperty { id: propMusicalKey;       path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }
  AppProperty { id: propLegacyKey;        path: "app.traktor.decks." + (deckId+1) + ".content.legacy_key" }
  AppProperty { id: propPitchRange;       path: "app.traktor.decks." + (deckId+1) + ".tempo.range_value" }
  AppProperty { id: propTempoAbsolute;    path: "app.traktor.decks." + (deckId+1) + ".tempo.absolute" }
  AppProperty { id: propMixerBpm;         path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propMixerStableBpm;   path: "app.traktor.decks." + (deckId+1) + ".tempo.true_bpm" }
  AppProperty { id: propMixerStableTempo; path: "app.traktor.decks." + (deckId+1) + ".tempo.true_tempo" }
  AppProperty { id: propTempo;            path: "app.traktor.decks." + (deckId+1) + ".tempo.tempo_for_display" }
  AppProperty { id: propMixerTotalGain;   path: "app.traktor.decks." + (deckId+1) + ".content.total_gain" }

  AppProperty { id: propIsInSync;       path: "app.traktor.decks." + (deckId+1) + ".sync.enabled"; }
  AppProperty { id: propSyncMasterDeck; path: "app.traktor.masterclock.source_id" }

  //--- Special Remix Deck Properties
  AppProperty { id: propRemixBeatPos;     path: "app.traktor.decks." + (deckId+1) + ".remix.current_beat_pos"; }
  AppProperty { id: propRemixQuantize;    path: "app.traktor.decks." + (deckId+1) + ".remix.quant_index"; }
  AppProperty { id: propRemixIsQuantize;  path: "app.traktor.decks." + (deckId+1) + ".remix.quant"; }
  //property string propRemixQuantize: "1/4"

//--------------------------------------------------------------------------------------------------------------------
//  KEY PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: keyId;      path: "app.traktor.decks." + (deckId+1) + ".track.key.final_id" }
  AppProperty { id: keyEnable;  path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }

  property var keyColor: keyEnable.value && keyId.value >= 0 ? colors.musicalKeyColors[keyId.value] : colors.colorWhite

//--------------------------------------------------------------------------------------------------------------------
//  TEMPO PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  function getStableTempoString() {
    var tempo = propMixerStableTempo.value - 1
    return ((tempo < 0) ? "" : "+") + (tempo * 100).toFixed(1).toString() + "%"
  }

  function getTempoBendColor() {
    var tempo = (propMixerStableTempo.value - 1) * 100

    if (-5 < tempo && tempo < 5){
      return colors.colorBendLow
    }
    return colors.colorBendHigh
  }

//--------------------------------------------------------------------------------------------------------------------
//  MIXERFX PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  MappingProperty { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1" }
  MappingProperty { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2" }
  MappingProperty { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3" }
  MappingProperty { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4" }
  AppProperty { id: mixerFX;   path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.select" }
  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + (deckId+1) + ".fx.on" }

  property var mixerFXColor: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72

  // readonly property variant mxrFXNames: ["Filter", "Reverb", "Dual Delay", "Noise", "Time Gater", "Flanger", "Barber Pole", "Dual Delay", "Crush"]
  readonly property variant mxrFXLabels: ["FTR", "RVB", "DEL", "NOS", "TMG", "FLG", "FLG", "DEL", "CRU"]
  property variant mixerFXLabels: [mxrFXLabels[0], mxrFXLabels[mixerFXAssigned1.value], mxrFXLabels[mixerFXAssigned2.value], mxrFXLabels[mixerFXAssigned3.value], mxrFXLabels[mixerFXAssigned4.value] ]

//--------------------------------------------------------------------------------------------------------------------
//  CAPTURE SOURCE PROPERTIES
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
//  MAPPING FROM TRAKTOR ENUM TO QML-STATE!
//--------------------------------------------------------------------------------------------------------------------

  readonly property variant stateMapping:  ["title", "artist", "release", "mix", "label", "catNo", "genre",
                                            "trackLength", "bitrate", "bpmTrack", "gain", "elapsedTime", "remainingTime",
                                            "beats", "beatsToCue", "bpm", "tempo", "key", "keyText", "comment", "comment2",
                                            "remixer", "pitchRange", "bpmStable", "tempoStable", "sync", "off", "off", "bpmTrack",
                                            "remixBeats", "remixQuantize", "mixerFX", "captureSource"]

/*
  readonly property variant stateMapping:  [0:  "title",          1: "artist",       2:  "release",
                                            3:  "mix",            4: "label",        5:  "catNo",
                                            6:  "genre",          7: "trackLength",  8:  "bitrate",
                                            9:  "bpmTrack",      10: "gain",        11: "elapsedTime",
                                            12: "remainingTime", 13: "beats",       14: "beatsToCue",
                                            15: "bpm",           16: "tempo",       17: "key",
                                            18: "keyText",       19: "comment",     20: "comment2",
                                            21: "remixer",       22: "pitchRange",  23: "bpmStable",
                                            24: "tempoStable",   25: "sync",        26: "off",
                                            27: "off",           28: "bpmTrack"     29: "remixBeats"
                                            30: "remixQuantize", 31: "mixerFX",     32: "captureSource"]
*/

//--------------------------------------------------------------------------------------------------------------------
//  STATES FOR THE LABELS IN THE DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  state: (explicitName == "") ? stateMapping[textState] : "explicitName"

  states: [
    State {
      name: "explicitName";
      PropertyChanges { target: header_text;  text: explicitName }
    },

    //------------------------------------------------------------------------------------------------------------------

    State {
      name: "off";
      PropertyChanges { target: header_text;  text: "" }
    },
    State {
      name: "title"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propTitle.value; }
    },
    State {
      name: "artist";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propArtist.value; }
    },
    State {
      name: "release"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propAlbum.value; }
    },
    State {
      name: "genre";   // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propGenre.value; }
    },
    State {
      name: "comment"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propComment.value; }
    },
    State {
      name: "comment2";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propComment2.value; }
    },
    State {
      name: "label";// Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propLabel.value; }
    },
    State {
      name: "mix";     // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propMix.value; }
    },
    State {
      name: "remixer"; // Top1 and Bottom1 ONLY
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propRemixer.value; }
    },
    State {
      name: "catNo";
      PropertyChanges { target: header_text; font.family: fontForString;
                        text:   (!isLoaded)?"":propCatNo.value }
    },

  //--------------------------------------------------------------------------------------------------------------------

    State {
      name: "trackLength";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":utils.convertToTimeString(propTrackLength.value); }
    },
    State {
      name: "elapsedTime";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":utils.convertToTimeString(propElapsedTime.value); }
    },
    State {
      name: "remainingTime";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":utils.computeRemainingTimeString(propTrackLength.value, propElapsedTime.value); }
    },

  //--------------------------------------------------------------------------------------------------------------------

    State {
      name: "key";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":propMusicalKey.value.toString();
                        color:  keyColor }
    },
    State {
      name: "keyText";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":propLegacyKey.value.toString(); }
    },
    State {
      name: "pitchRange";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":toInt_round(propPitchRange.value*100).toString() + "%"; }
    },
    State {
      name: "bpm";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":propMixerBpm.value.toFixed(2).toString(); }
    },
    State {
      name: "bpmStable";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"": propMixerStableBpm.value.toFixed(2).toString(); }
    },
    State {
      name: "bpmTrack";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":propMixerStableBpm.value.toFixed(2).toString();  }
    },
    State {
      name: "tempo";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":((propTempo.value-1 < 0)?"":"+") + ((propTempo.value-1)*100).toFixed(1).toString() + "%"; }
    },
    State {
      name: "tempoStable";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   getStableTempoString();
                        color:  getTempoBendColor() }
    },
    State {
      name: "gain";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":convertToDb(propMixerTotalGain.value).toFixed(1).toString() + "dB"; }
    },

  //--------------------------------------------------------------------------------------------------------------------

    State {
      name: "beats";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":computeBeatCounterStringFromPosition(((propElapsedTime.value*1000-propGridOffset.value)*propMixerBpm.value)/60000.0); }
    },
    State {
      name: "beatsToCue";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded)?"":computeBeatCounterStringFromPosition(((propElapsedTime.value*1000-cuePos)*propMixerBpm.value)/60000.0); }
    },
    State {
      name: "bitrate";
      PropertyChanges { target: header_text;  font.family: fontForNumber;
                        text:   (!isLoaded)?"":toInt(propBitrate.value / 1000).toString(); }
    },

    State {
      name: "sync";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:  getSyncStatusString(); }
    },
    State {
      name: "remixBeats";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:  (!isLoaded)?"":computeBeatCounterStringFromPosition(propRemixBeatPos.value);
                        color:  colors.White }
    },
    State {
      name: "remixQuantize";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded) ? "" : ((propRemixIsQuantize.value)? "Q " + propRemixQuantize.description : "Off");
                        color:  colors.White }
    },

  //--------------------------------------------------------------------------------------------------------------------

    State {
      name: "mixerFX";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded) ? "" : mixerFXLabels[mixerFX.value];
                        color:  mixerFXColor }
    },

    State {
      name: "captureSource";
      PropertyChanges { target: header_text; font.family: fontForNumber;
                        text:   (!isLoaded) ? "" : captureSrc.description;
                        color:  captureSourceColor() }
    }
  ]

//--------------------------------------------------------------------------------------------------------------------
//  CONVERSION FUNCTIONS
//--------------------------------------------------------------------------------------------------------------------

  function toInt(val)       { return parseInt(val); }
  function toInt_round(val) { return parseInt(val+0.5); }
  function log10(num)       { return Math.log(num) / Math.LN10; }

  function convertToDb(gain) {
    var level0dB = 1.0;
    var norm = gain / level0dB;
    if (norm <= 0.0)
      return -0.0000000001;

    return 20.0*log10(norm);
  }

  function computeBeatCounterStringFromPosition(beat) {
    var phraseLen = 4;
    var curBeat  = parseInt(beat);

    if (beat < 0.0)
      curBeat = curBeat*-1;

    var value1 = parseInt(((curBeat/4)/phraseLen)+1);
    var value2 = parseInt(((curBeat/4)%phraseLen)+1);
    var value3 = parseInt( (curBeat%4)+1);

    if (beat < 0.0)
      return "- " + value1.toString() + "." + value2.toString() + "." + value3.toString();

    return value1.toString() + "." + value2.toString() + "." + value3.toString();
  }

  function getSyncStatusString() {
    if ( !isLoaded )
      return " ";
    else if (isMaster)
      return "MASTER";
    else if (isInSync)
      return "SYNC";

    // Show the decks current pitch value in the area of the Master/Sync indicator
    // if a deck is neither synced nor set to maste (TP-8070)
    return getStableTempoString();
  }
}
