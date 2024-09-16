#! /usr/bin/env bash

# Get the total number of displays connected
display_count=$(yabai -m query --displays | jq length)

echo -e "\n============== Executing on $(date) (w/ ${display_count} displays) ==============="

save_window_positions() {
  # Phase 1: Read positions from yabai
  yabai -m query --windows |
    jq '[.[] | {window: .id, app: .app, title: .title, space: .space, display: .display, position: {x: .frame.x, y: .frame.y}}]' > /tmp/window_positions_raw.json

  # Phase 2: Perform the translation if on 1 display
  if [ "$display_count" -eq 1 ]; then
    jq '[.[] | {
      window: .window,
      app: .app,
      title: .title,
      space: (if .space == 2 then 11 elif .space == 3 then 12 else .space end),
      display: .display,
      position: .position
    }]' /tmp/window_positions_raw.json > /tmp/window_positions.json
  else
    # If 3 displays, no translation needed, just copy the raw data
    cp /tmp/window_positions_raw.json /tmp/window_positions.json
  fi

  echo "Window positions saved for ${display_count} displays."
}

restore_window_positions() {
  display_count=$1
  positions_file="/tmp/window_positions.json"
  echo "Restoring window positions..."
  
  if [ -f "$positions_file" ]; then
    jq -r '.[] | "\(.window) \(.space) \(.app)"' "$positions_file" | while read -r window_id space_id app_name; do
      final_space_id=$space_id

      # Translate spaces based on the display count
      if [ "$display_count" -eq 1 ]; then
        case "$space_id" in
          11) final_space_id=2 ;;
          12) final_space_id=3 ;;
        esac
      fi

      echo "Restoring window ${app_name} to space ${final_space_id} (window #${window_id})"
      yabai -m window "$window_id" --space "$final_space_id"
    done
    echo "Window positions restored."
  else
    echo "No window positions file found."
  fi
}

if [ "$1" = "dump" ]; then
  save_window_positions
elif [ "$1" = "restore" ]; then
  restore_window_positions $2
elif [ "$1" = "transform" ]; then
  restore_window_positions $display_count
fi