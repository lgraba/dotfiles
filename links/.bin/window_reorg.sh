#! /usr/bin/env bash

# Get the total number of displays connected
display_count=$(yabai -m query --displays | jq length)

echo "number of displays found: ${display_count}"

save_window_positions() {
  yabai -m query --windows |
    jq '[.[] | {window: .id, app: .app, title: .title, space: .space, display: .display, position: {x: .frame.x, y: .frame.y}}]' > /tmp/window_positions-${display_count}.json
}

move_windows() {
	origin_space=$1
	dest_space=$2

	yabai -m query --windows --space "$origin_space" |
    jq '[.[] | {window: ., position: (.frame.x + .frame.y)}] | sort_by(.position) | .[].window.id' |
		xargs -I {} yabai -m window {} --space "$dest_space"

#	yabai -m query --windows --space "$origin_space" |
#		jq -r '.[] | "yabai -m window " + (.id | tostring) + " --space '"$dest_space"'"' |
#		sh
}

restore_window_positions() {
  positions_file="/tmp/window_positions-${1}.json"
  if [ -f "$positions_file" ]; then
    jq -r '.[] | "\(.window) \(.space)"' "$positions_file" | while read -r window_id space_id; do
      final_space_id=$space_id
      if [ "$1" -eq 3 ]; then
        case "$space_id" in
          11)
            final_space_id=2
            ;;
          12)
            final_space_id=3
            ;;
        esac
      elif [ "$1" -eq 1 ]; then
        case "$space_id" in
          2)
            final_space_id=11
            ;;
          3)
            final_space_id=12
            ;;
        esac
      fi
      yabai -m window "$window_id" --space "$final_space_id"
    done
    echo "Window spaces restored."
  else
    echo "No window positions file found."
  fi
}

if [ "$1" = "dump" ]; then
  save_window_positions
elif [ "$1" = "restore" ]; then
  restore_window_positions ${display_count}
elif [ "$1" = "adapt" ]; then
	from=$2
	to=$3
	if [[ -z $from ]] || [[ -z $to ]]; then
		echo "usage $0 adapt <from> <to>"
		exit -1
	fi
  restore_window_positions $from
elif [ "$1" = "transform" ]; then
  case "$display_count" in
    1)
      to=3
      ;;
    3)
      to=1
      ;;
  esac
  restore_window_positions $to
fi 
