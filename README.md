# CPA-Air

**Repository:** [https://github.com/vlenchik/CPA-Air](https://github.com/vlenchik/CPA-Air)  
**Live Site:** [https://vlenchik.github.io/CPA-Air/](https://vlenchik.github.io/CPA-Air/)

## Overview

CPA-Air is a browser-based visualization tool for analyzing Closest Point of Approach (CPA) events between aircraft. The application provides an animated map playback synchronized with ATC audio recordings to help pilots, controllers, and investigators review close encounter geometry and communications.

## Features

- **Interactive Map Visualization**: Animated aircraft tracks with real-time position updates
- **Synchronized ATC Audio**: Embedded audio playback aligned with the visual timeline
- **Detailed Flight Data**: Altitude, ground speed, vertical speed, and separation distances
- **Playback Controls**: Variable speed playback (0.25× to 6×), scrubbing, and step-by-step navigation
- **Self-Contained**: Single HTML file deployment with no server requirements

## Current Event

This repository contains analysis of a CPA event between:
- **N748PK** (RV-series aircraft) and **N89WD**
- Location: Near KLVK (San Jose, CA)
- Date/Time: 2026-01-26 at 21:38:48 UTC
- Duration: 120-second window (±60 seconds around CPA)

## Quick Start

### Option 1: View Online (Recommended)

Visit the live site at: **[https://vlenchik.github.io/CPA-Air/](https://vlenchik.github.io/CPA-Air/)**

Available pages:
- [Main Visualization](https://vlenchik.github.io/CPA-Air/CPA_map_with_audio_embedded.html) - Interactive map with embedded audio
- [Event Analysis](https://vlenchik.github.io/CPA-Air/KLVK%20CPA%20250ft%2020260126.html) - Specific CPA event visualization
- [Home Page](https://vlenchik.github.io/CPA-Air/) - Project overview and navigation

### Option 2: Run Locally

1. Clone or download the repository
2. Open `CPA_map_with_audio_embedded.html` in any modern web browser
3. Press **Play** to start the animation and audio
4. Use the controls to adjust playback speed or scrub to specific moments

For detailed documentation on how to build and customize the application, see [CPA_Map_App.md](CPA_Map_App.md).

## Project Structure

- `CPA_map_with_audio.html` - Base HTML file with audio placeholder
- `CPA_map_with_audio_embedded.html` - Final version with embedded audio
- `CPA_map_with_audio_fixed.html` - Fixed version of the map
- `CPA_Map_App.md` - Comprehensive application documentation
- `recording.mp3` / `KLVK2-Jan-26-2026-2130Z.mp3` - ATC audio recordings
- `track_*.csv` / `track_*.json` - Flight track data
- `separation_*.png` - Separation analysis charts
- `trim_atc.sh` - Script for trimming ATC audio

## Dependencies

- **Leaflet 1.9.4** - Interactive mapping library (loaded from CDN)
- **OpenStreetMap** - Map background tiles

Both dependencies require internet connectivity for initial load. Once loaded, the application works offline.

## License

Please refer to the repository for license information.

## Contributing

Contributions are welcome! Please visit the [GitHub repository](https://github.com/vlenchik/CPA-Air) to open issues or submit pull requests.
