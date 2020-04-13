import CSI 1.0

Module
{
  // Input
  id: channel
  property int number:     1
  property string surface: ""
  property bool shift:     false

  // Helpers
  property string surface_prefix:  surface + "." + number + "." 
  property string app_prefix:      "app.traktor.mixer.channels." + number + "."

  // Channel Strip
  Wire { from: surface_prefix + "volume";     to: DirectPropertyAdapter { path: app_prefix + "volume"    } }
  Wire { from: surface_prefix + "gain";       to: DirectPropertyAdapter { path: app_prefix + "gain"      } }
  Wire { from: surface_prefix + "eq.high";    to: DirectPropertyAdapter { path: app_prefix + "eq.high"   } }
  Wire { from: surface_prefix + "eq.mid";     to: DirectPropertyAdapter { path: app_prefix + "eq.mid"    } }
  Wire { from: surface_prefix + "eq.low";     to: DirectPropertyAdapter { path: app_prefix + "eq.low"    } }
  Wire { from: surface_prefix + "filter";     to: DirectPropertyAdapter { path: app_prefix + "fx.adjust" } }
  Wire { from: surface_prefix + "filter_on";  to: TogglePropertyAdapter { path: app_prefix + "fx.on"     } enabled: !shift }
  Wire { from: surface_prefix + "cue";        to: TogglePropertyAdapter { path: app_prefix + "cue"       } }

  // Level Meter
  LEDLevelMeter { name: "meter"; dBThresholds: [-30,-20,-10,-6,-4,-2,0,2,4,6,8] }
  Wire { from: surface_prefix + "levelmeter"; to: "meter" }
  Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.sum"; input: false } }

  // FX Assign
  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

  WiresGroup
  {
    enabled: !shift // || (fxMode.value == FxMode.TwoFxUnits)  // Disabled for MixerFX
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"; } }
  }

  // MixerFX
  AppProperty { id: mixerFXA;       path: "app.traktor.mixer.channels.1.fx.select" }
  AppProperty { id: mixerFXB;       path: "app.traktor.mixer.channels.2.fx.select" }
  AppProperty { id: mixerFXC;       path: "app.traktor.mixer.channels.3.fx.select" }
  AppProperty { id: mixerFXD;       path: "app.traktor.mixer.channels.4.fx.select" }

  WiresGroup
  {
    enabled: shift

    Wire { from: "s5.mixer.channels.1.fx.assign.1"; to: ButtonScriptAdapter { onPress: { mixerFXA.value ==4 ? mixerFXA.value = mixerFXA.value - 4 : mixerFXA.value = mixerFXA.value + 1; } } }
    Wire { from: "s5.mixer.channels.1.fx.assign.2"; to: ButtonScriptAdapter { onPress: { mixerFXA.value ==0 ? mixerFXA.value = mixerFXA.value + 4 : mixerFXA.value = mixerFXA.value - 1; } } }
    Wire { from: "s5.mixer.channels.2.fx.assign.1"; to: ButtonScriptAdapter { onPress: { mixerFXB.value ==4 ? mixerFXB.value = mixerFXB.value - 4 : mixerFXB.value = mixerFXB.value + 1; } } }
    Wire { from: "s5.mixer.channels.2.fx.assign.2"; to: ButtonScriptAdapter { onPress: { mixerFXB.value ==0 ? mixerFXB.value = mixerFXB.value + 4 : mixerFXB.value = mixerFXB.value - 1; } } }
    Wire { from: "s5.mixer.channels.3.fx.assign.1"; to: ButtonScriptAdapter { onPress: { mixerFXC.value ==4 ? mixerFXC.value = mixerFXC.value - 4 : mixerFXC.value = mixerFXC.value + 1; } } }
    Wire { from: "s5.mixer.channels.3.fx.assign.2"; to: ButtonScriptAdapter { onPress: { mixerFXC.value ==0 ? mixerFXC.value = mixerFXC.value + 4 : mixerFXC.value = mixerFXC.value - 1; } } }
    Wire { from: "s5.mixer.channels.4.fx.assign.1"; to: ButtonScriptAdapter { onPress: { mixerFXD.value ==4 ? mixerFXD.value = mixerFXD.value - 4 : mixerFXD.value = mixerFXD.value + 1; } } }
    Wire { from: "s5.mixer.channels.4.fx.assign.2"; to: ButtonScriptAdapter { onPress: { mixerFXD.value ==0 ? mixerFXD.value = mixerFXD.value + 4 : mixerFXD.value = mixerFXD.value - 1; } } }
  }

  WiresGroup
  {
    enabled: shift && (fxMode.value == FxMode.FourFxUnits)
    Wire { from: surface_prefix + "fx.assign.1"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.3"; } }
    Wire { from: surface_prefix + "fx.assign.2"; to: TogglePropertyAdapter { path: app_prefix + "fx.assign.4"; } }
  }
}
