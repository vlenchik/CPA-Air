# CPA Animated Map — Application Documentation

**GitHub Repository:** [https://github.com/vlenchik/CPA-Air](https://github.com/vlenchik/CPA-Air)

## Purpose

This is a single-file, browser-based playback tool for visualizing a **Closest Point of Approach (CPA)** event between two aircraft. It replays a ±60-second window around the CPA moment, animating both aircraft positions on a map while synchronizing optional ATC audio recorded during the event.

The specific event captured here is a CPA between **N748PK** (an RV-series aircraft, red) and **N89WD** (blue) near **KLVK (San Jose, CA)** on 2026-01-26 at 21:38:48 UTC. The animation plays 120 frames at 1-second intervals at 1× speed, covering the full 120-second window around the CPA.

The intended audience is pilots, controllers, or investigators reviewing the geometry and radio communications of a close encounter.

---

## Architecture

The application is a single self-contained HTML file. There are no build steps, no server, and no framework dependencies beyond the Leaflet mapping library. Everything — data, audio, logic — lives in one file.

### External Dependencies (require internet)

- **Leaflet 1.9.4** — loaded from `unpkg.com`. Provides the interactive map, tile rendering, markers, polylines, and the coordinate math that underpins all positioning.
- **OpenStreetMap tiles** — the map background imagery, fetched on demand from `tile.openstreetmap.org`. The map is still interactive and the animation works without these, but the background will be blank/gray if offline.

### Embedded Data (no internet required)

- **Frame data** — a JSON array of 120 objects (`frames[]`), each containing a timestamp and the following fields for both aircraft: latitude, longitude, altitude, ground speed, track heading, vertical speed, and 3D/horizontal/vertical separation distances.
- **Audio** — after running the embed script, the MP3 recording is encoded as a base64 data URL directly in the `<audio>` element. No external file reference is needed.

### Key Components

**Map Layer**
Leaflet initializes a map centered on the event area at zoom level 15. Two polylines draw the full track of each aircraft for the entire 120-second window. A yellow circle marker indicates the CPA midpoint with a tooltip showing the exact CPA time.

**Aircraft Markers**
Each aircraft is represented by an SVG triangle `divIcon` that rotates in real time to match the aircraft's current track heading. A small black-and-white dot sits exactly on the aircraft's position beneath the triangle.

**Callout Boxes**
Each aircraft has a dark semi-transparent callout displaying callsign, altitude, ground speed, and vertical speed. These are Leaflet `divIcon` markers with specific anchor points:
- **N748PK (RV)** uses a `bottom-left` anchor (`iconAnchor: [0, 80]`). The callout box extends up and to the right, placing it NNE of the aircraft. The leader line connects the aircraft position to the bottom-left corner of the box.
- **N89WD (WD)** uses the default `top-left` anchor. The callout is nudged forward along the aircraft's current track heading using `forwardOffsetPx()`, placing it SSE of the aircraft. The leader line connects the aircraft to the top-left corner of the box.

The two callouts are positioned symmetrically — RV's NNE placement mirrors WD's SSE placement at roughly equal visual distance from each aircraft.

**Leader Lines**
Dashed polylines in each aircraft's color connect the position dot to its callout box anchor point. These update every frame as both the aircraft and callout positions change.

**Positioning Math**
`offsetLatLng(lat, lon, dx, dy)` converts a pixel offset into a lat/lng delta by round-tripping through Leaflet's layer-point coordinate system. `forwardOffsetPx(lat, lon, track, px)` computes a pixel-space vector along a given magnetic track heading, used to nudge the WD callout forward along its direction of travel.

**Control Panel**
A floating panel in the bottom-right corner provides:
- Play / Pause / Step buttons
- Mute/Unmute toggle for audio
- Playback speed slider (0.25× to 6×)
- Timeline scrub slider (frame 0–120)
- Live readouts: current timestamp, current frame number, and 3D separation (with horizontal and vertical components)

**Audio Sync Engine**
Audio playback is driven by the same `rate` variable that controls animation speed. On Play, the audio `currentTime` is calculated from the current frame index as a proportion of total frames mapped to total audio duration, then `playbackRate` is set to match the speed slider. On scrub, the same proportional seek is applied. On Pause, both the interval timer and audio are stopped together.

### Timing

Each frame represents 1 second of real time. At 1× speed, `baseIntervalMs` is 1000ms, so the full 120-frame sequence plays back in 120 seconds — matching real-time event duration. The speed slider scales both the animation interval and `audioPlayer.playbackRate` identically, keeping them locked together at any speed.

---

## File Structure

```
CPA_map_with_audio.html          ← base file (audio placeholder)
embed_audio.py                   ← script to embed audio into the HTML
recording.mp3                    ← your ATC audio file
CPA_map_with_audio_embedded.html ← final self-contained output
```

---

## Steps to Build and Run

### Step 1 — Obtain the Base Files

Download the two files provided:
- `CPA_map_with_audio.html` — the map and animation with an audio placeholder
- `embed_audio.py` — the Python script that embeds audio into the HTML

### Step 2 — Obtain Your Audio File

Place your ATC audio recording (MP3, WAV, OGG, M4A, or AAC) in the same directory as the two files above. The audio must cover the same time window as the animation and be trimmed to align with frame 0.

### Step 3 — Embed the Audio

Run the embed script from the command line, passing your audio file and the HTML file:

```bash
python3 embed_audio.py recording.mp3 CPA_map_with_audio.html
```

The script reads the audio file, base64-encodes it, and replaces the placeholder in the HTML. It outputs a new file: `CPA_map_with_audio_embedded.html`. It will print the input/output sizes so you can confirm it ran correctly.

### Step 4 — Open in a Browser

Open `CPA_map_with_audio_embedded.html` in any modern browser (Chrome, Firefox, Safari, Edge). No server is needed — just double-click or drag into the browser.

The map will load, the tracks will draw, and the animation will initialize at frame 0. Press **Play** to start. Audio will begin playing synchronized to the animation.

### Step 5 (Optional) — Adjust Audio Alignment

If the audio does not align perfectly with the animation, you have two options:

- **Trim the audio** before embedding so that its start time matches frame 0.
- **Scrub the timeline** to find where audio and visuals drift, then re-trim accordingly.

Re-run the embed script after any audio changes.

---

## Controls Reference

| Control | Action |
|---|---|
| **Play** | Starts animation and audio from the current frame |
| **Pause** | Stops animation and pauses audio |
| **Step** | Advances one frame without playing |
| **🔊 Mute / 🔇 Unmute** | Toggles audio mute without stopping playback |
| **Speed slider** | Sets playback rate (0.25× – 6×); affects both animation and audio |
| **Timeline scrub** | Seeks to any frame; audio seeks to the matching position |

---

## Offline Behavior

| Component | Works Offline? |
|---|---|
| Animation and all aircraft data | ✅ Yes |
| Embedded audio | ✅ Yes |
| Callouts, leaders, separation data | ✅ Yes |
| Leaflet map controls (zoom, pan) | ✅ Yes |
| Map background tiles | ❌ No — background will be blank |

The application is fully usable offline. Only the OpenStreetMap background imagery will not render. All aircraft tracks, callouts, leader lines, and audio remain functional.
