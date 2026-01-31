#!/usr/bin/env bash
set -euo pipefail

IN="KLVK2-Jan-26-2026-2130Z.mp3"
OUT="atc_cpa_window.mp3"

# CPA time from your report (UTC)
CPA_UTC="2026-01-26T21:38:48+00:00"

# IMPORTANT: audio start must be the SAME DAY as CPA unless you truly recorded on a different day.
# Your filename suggests Jan 26 21:30Z, so use Jan 26 (not Jan 27).
AUDIO_START_UTC="2026-01-26T21:30:00Z"

# Window around CPA
PRE_SEC=60
DUR_SEC=120

# --- Convert times to epoch seconds (macOS/BSD date) ---

# Parse CPA_UTC like: 2026-01-26T21:38:48+00:00  (note: %z needs +0000, so strip the colon)
CPA_UTC_NO_COLON_TZ="${CPA_UTC%:*}${CPA_UTC##*:}"   # +00:00 -> +0000
CPA_EPOCH=$(date -u -j -f "%Y-%m-%dT%H:%M:%S%z" "$CPA_UTC_NO_COLON_TZ" +%s)

# Parse AUDIO_START_UTC like: 2026-01-26T21:30:00Z
AUDIO_EPOCH=$(date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$AUDIO_START_UTC" +%s)

START_EPOCH=$((CPA_EPOCH - PRE_SEC))
OFFSET_SEC=$((START_EPOCH - AUDIO_EPOCH))

# --- Safety checks ---
if (( OFFSET_SEC < 0 )); then
  echo "ERROR: Computed OFFSET_SEC is negative ($OFFSET_SEC)."
  echo "This means AUDIO_START_UTC is later than (CPA - $PRE_SEC seconds)."
  echo "CPA_UTC        = $CPA_UTC"
  echo "AUDIO_START_UTC= $AUDIO_START_UTC"
  exit 2
fi

echo "Trimming from audio offset: ${OFFSET_SEC}s for ${DUR_SEC}s"
echo "CPA_UTC=$CPA_UTC"
echo "AUDIO_START_UTC=$AUDIO_START_UTC"

# Most reliable (re-encode) — avoids MP3 VBR copy issues
ffmpeg -hide_banner -y \
  -ss "${OFFSET_SEC}" -t "${DUR_SEC}" \
  -i "$IN" \
  -c:a libmp3lame -q:a 3 \
  "$OUT"

echo "Wrote: $OUT"
