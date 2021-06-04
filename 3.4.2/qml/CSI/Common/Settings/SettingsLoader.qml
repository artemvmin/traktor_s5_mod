import CSI 1.0
import QtQuick 2.0

import "../../../Defines"

Module {
  id: settingsloader

  property string surface
  property string settingsPath:           "mapping.settings"

  // Traktor root path
  AppProperty { id: propSettingsRoot; path: "app.traktor.settings.paths.root" }
  MappingPropertyDescriptor { id: osType; path: "mapping.settings.osType"; type: MappingPropertyDescriptor.Integer; value: 0 }

  // MixerFX Settings
  MappingPropertyDescriptor { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4"; type: MappingPropertyDescriptor.Integer; value: 0 }

  function extractMixerFXSettings(sSettings) {
    var sSearch = '<Entry Name="Audio.ChannelFX.1.Type" Type="1" Value="';
    sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
    mixerFXAssigned1.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

    sSearch = '<Entry Name="Audio.ChannelFX.2.Type" Type="1" Value="';
    sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
    mixerFXAssigned2.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

    sSearch = '<Entry Name="Audio.ChannelFX.3.Type" Type="1" Value="';
    sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
    mixerFXAssigned3.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

    sSearch = '<Entry Name="Audio.ChannelFX.4.Type" Type="1" Value="';
    sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
    mixerFXAssigned4.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;
  }

  function readTraktorSettings() {
  var filePath = propSettingsRoot.value;
  if (filePath.indexOf(":\\") == 1) {
    // Windows
    osType.value = 2;
    filePath = "file:///" + filePath.replace(/\\/g,"/") + "Traktor Settings.tsi";
    }
  else {
    // macOS
    osType.value = 1;
    filePath = "file:///Volumes/" + filePath.replace(/:/g, "/") + "Traktor Settings.tsi";
    }

    var request = new XMLHttpRequest();
    request.onreadystatechange = function() {
      // Need to wait for the DONE state
      if (request.readyState === XMLHttpRequest.DONE) {
        extractMixerFXSettings(request.responseText);
        traktorSettingsRead = request.responseText;
      }
    }
    request.open("GET", filePath, true); // only async supported
    request.send();
  }
}
