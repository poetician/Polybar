#!/usr/bin/env bash

# terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null 2>&1; do sleep 1; done

# gather the list of monitors into an array
mapfile -t MONITORS < <( polybar --list-monitors | cut -f 1 -d : )

# iterate through the array indexes
for MON_IDX in "${!MONITORS[@]}"; do
  # launch the first bar at every monitor
  MONITOR="${MONITORS[$MON_IDX]}" polybar mainbar-bspwm &

  # but launch the second one if only on the first one
  if [[ $MON_IDX -eq 0 ]]; then
    MONITOR="${MONITORS[$MON_IDX]}" polybar mainbar-bspwm-extra &
  fi
  # and we're done
done
