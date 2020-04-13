# Traktor S5 Mod

This is my attempt to fix all the shortcomings of this near-perfect DJ controller.

Please reach out to me with any bugs or feature requests.

## Compatibility

Traktor Pro:
- 2.11.0
- 3.2.19

NOTE: Traktor Pro 2 is no longer supported and may not contain all features listed below.

## Modifications

### Display

- Spectrum colors to distinguish highs, mids, and lows
- Deck header shows
  - color-coded Camelot key (when key is LOCKED)
  - approximate Camelot key (when key is UNLOCKED)
- Browser SortBy reduced to three variables: artist, bpm, and key
- Removed overlay hide delays

### Controller

#### Transport

- TURN (right knob) to adjust loop size
- PUSH (right knob) to loop
- TURN (left knob) to seek (by loop size) or move the loop

#### Browser

- PUSH (left knob) to browse
- Preview:
  - PUSH (right knob) to start playing selected track in preview mode
  - TURN (right knob) to seek through preview track
- Sorting:
  - SHIFT + PUSH (right knob) to invert sorting
  - SHIFT + TURN (right knob) to change sorting type
- Preparation [1]:
  - PUSH □ (top right) to toggle selected track in and out of your preparation playlist
  - PUSH □ (bottom right) to jump to preparation playlist

[1] Preparation requires you to manually mark a playlist as "preparation" using the Traktor software.

#### Beatgrid Edit

- From any track screen:
  - SHIFT + PUSH □ (top left) to toggle beat grid edit mode
  - SHIFT + PUSH □ (top right) to set load marker at cursor
  - SHIFT + PUSH □ (top right) to reset the load marker
- From edit mode:
  - PUSH □ (top left) to lock edit mode
  - PUSH □ (bottom left) to enable tick [2]
  - PUSH □ (top right) to tap the beat [3]
  - PUSH □ (bottom right) to reset BPM
  - PUSH [<] or [>] to halve or double the BPM
  - PUSH (left knob) to zoom in on a single beat
  - PUSH back (<) to switch between seek and edit mode
  - When in edit mode (back button blinking):
    - TURN (left knob) to adjust offset
    - TURN (right knob) to adjust BPM
  - When in seek mode (back button not blinking):
    - TURN (left knob) to seek through track

[2] Tick plays an audible sound on every beat. This feature requires headphones routed from the monitor channel and for the track to be CUEd.

[3] Tap allows you to fix the beat grid alignment by tapping four consecutive beats while the song is playing.

#### Misc
- Global and deck tempo knobs perform coarse adjustment when SHIFT is not held
- Hold back (<) in deck view to reset key
- SHIFT + FLUX for flux reverse

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
4. Copy the qml folder to `Contents/Resources` and select merge. (Note: Merge preserves newer items. Make sure to download this mod AFTER installing or updating Traktor.)

## Screenshots

![Colored Camelot key](images/color_key.jpg)
![Approximate Camelot key](images/approx_key.jpg)
