# Traktor S5 Mod

My dream is to DJ without a keyboard and mouse.

## Compatibility

Traktor Pro:

- 2.11.0
- 3.2.1 9

NOTE: Traktor Pro 2 is no longer supported and may not contain all features listed below.

## Modifications

### Display

- Spectrum colors to distinguish highs, mids, and lows
- Deck header shows
  - color-coded Camelot key (when key is LOCKED)
  - approximate Camelot key (when key is UNLOCKED)
- Removed overlay hide delays

### Transport

**Loop and Move:**

- TURN LOOP KNOB to adjust loop size
- PUSH LOOP KNOB to loop
- TURN BROWSE KNOB to seek (by loop size) or move the loop

**Cue:**

- SHIFT + CUE to jump to the cue point [1] or set a cue point
- CUE to play from the cue point

**Reverse:**

- SHIFT + PLAY for reverse
- SHIFT + FLUX for flux reverse

**Tempo:**

- TURN TEMPO KNOB for coarse adjustment
- SHIFT + TURN TEMPO KNOB for fine adjustment

[1] A cue point is either set manually or automatically when you trigger any hotcue.

### Browser

- PUSH BROWSE KNOB to open the browser
- Loading:
  - TURN BROWSE KNOB to browse
  - PUSH BROWSE KNOB to load the selected track
- Sorting:
  - TURN LOOP KNOB to change sorting type
  - PUSH LOOP KNOB to invert sorting
- Preview:
  - SHIFT + PUSH LOOP KNOB to start playing selected track in preview mode
  - SHIFT + TURN LOOP KNOB to seek through preview track
- Preparation [2]:
  - TOP RIGHT □ to toggle selected track in and out of your preparation playlist
  - BOTTOM RIGHT □ to jump to preparation playlist

[2] Preparation requires you to manually select a preparation playlist by right clicking on a playlist in the Traktor software.

### Beatgrid Edit

- From any track screen:
  - SHIFT + TOP LEFT □ to toggle beat grid edit mode
  - SHIFT + TOP RIGHT □ to set load marker at cursor
  - SHIFT + BOTTOM RIGHT □ to reset the load marker
- From edit mode:
  - TOP LEFT □ to lock edit mode
  - BOTTOM LEFT □ to enable tick [3]
  - TOP RIGHT □ to tap the beat [4]
  - BOTTOM RIGHT □ to reset BPM
  - SCREEN ARROWS [<] or [>] to halve or double the BPM
  - PUSH BROWSE KNOB to zoom in on a single beat
  - BACK [<] to switch between seek and edit mode
  - When in edit mode (back button blinking):
    - TURN BROWSE KNOB to adjust offset
    - TURN LOOP KNOB to adjust BPM
  - When in seek mode (back button not blinking):
    - TURN BROWSE KNOB to seek through track

[3] Tick plays an audible sound on every beat. This feature requires headphones routed from the monitor channel and for the track to be CUEd.

[4] Tap allows you to fix the beat grid alignment by tapping four consecutive beats while the song is playing.

### Jump Mode

Jump mode allows you to skip around the track using the pads.

- FREEZE for jump mode
- SHIFT + FREEZE for freeze mode

Layout:

| -2 | -1 | 1 | 2 |
|:--:|:--:|:-:|:-:|
| -8 | -4 | 4 | 8 |

Layout (with SHIFT held):

| -16 | -1 | 1 | 16 |
|:---:|:--:|:-:|:--:|
| -32 | -4 | 4 | 32 |

### Loop Mode

Loop mode allows you to initiate loops using the pads. This works really well with FLUX enabled.

- REMIX for loop mode
- SHIFT + REMIX for remix mode

Layout:

| 1/32 | 1/16 | 1/8 | 1/4 |
|:----:|:----:|:---:|:---:|
|  1/2 |   1  |  2  |  4  |

### Mixer FX

Mixer FX allow you to change the behavior of a deck's filter knob.

- BACK [<] to open the Mixer FX menu
  - TURN BROWSE KNOB to browse effects
  - PUSH BROWSE KNOB to set current effect on all decks
  - BACK [<] again to reset to filter

You can specify four effects in addition to filter. To customize, quit Traktor and modify the Traktor Settings file at:

```Documents/Native Instruments/Traktor 3.2.1/Traktor Settings.tsi```

Find the lines beginning with:

```<Entry Name="Audio.ChannelFX.<1-4>.Type" ... >```

and set the Values based on the following mapping:

- 0: Reverb
- 1: Dual Delay
- 2: Noise
- 3: Time Gater
- 4: Flanger
- 5: Barber Pole
- 6: Dual Delay
- 7: Crush

## Credit

As far as I'm aware, all inputs and ouputs for these configuration scripts are completely undocumented. That means that this process requires tedious guess and checking with no guarantee of success. There are some features I simply would not have figured out on my own. A huge thanks to the following trailblazers:

- [Aleix Jiménez](https://www.patreon.com/supremeedition) makes an incredibly feature-rich Traktor mod. It's seriously light years ahead of mine and you should go support him on Patreon.

## Installation

**Windows:**

1. Download or clone the repository.
2. Depending on your Traktor Pro version, copy the corresponding qml folder to:
   `C:\Program Files\Native Instruments\Traktor 2\Resources64`
   or
   `C:\Program Files\Native Instruments\Traktor Pro 3\Resources64`
   and replace all files.

**Mac:**

1. Download or clone the repository.
2. Depending on your Traktor Pro version, navigate to:
   `Applications/Native Instruments/Traktor 2`
   or
   `Applications/Native Instruments/Traktor Pro 3`.
3. Right click on Traktor and select `Show Package Contents`.
4. Manually copy each qml file to the appropriate folder in `Contents/Resources`. (Note: MacOS does not make this process easy because I chose to have a small file footprint. Merging will preserve newer items, but there is no guarantee that the mod files are newer than your current Traktor files.)

## Screenshots (outdated)

![Colored Camelot key](images/color_key.jpg)
![Approximate Camelot key](images/approx_key.jpg)
