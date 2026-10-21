#!/usr/bin/env bash

battery_dir="/sys/class/power_supply/BAT0"

capacity=$(< "$battery_dir/capacity")
status=$(< "$battery_dir/status")

icon="󰁹"
color="#a6e3a1" # green
state="normal"

if [[ "$status" == "Charging" ]]; then
  # Material Design charging icons: 10% through 100%.
  if (( capacity <= 10 )); then
    icon="󰂅"
  elif (( capacity <= 20 )); then
    icon="󰂆"
  elif (( capacity <= 30 )); then
    icon="󰂇"
  elif (( capacity <= 40 )); then
    icon="󰂈"
  elif (( capacity <= 50 )); then
    icon="󰂉"
  elif (( capacity <= 60 )); then
    icon="󰂊"
  elif (( capacity <= 70 )); then
    icon="󰂋"
  elif (( capacity <= 80 )); then
    icon="󰂌"
  elif (( capacity < 100 )); then
    icon="󰂍"
  else
    icon="󰂎"
  fi
  color="#94e2d5" # teal
  state="charging"

elif (( capacity <= 5 )); then
  icon="󰂃" # battery alert / almost empty
  color="#f38ba8" # red
  state="critical"

elif (( capacity <= 10 )); then
  icon="󰁺" # battery 10%
  color="#f38ba8" # red
  state="critical"

elif (( capacity <= 20 )); then
  icon="󰁻" # battery 20%
  color="#f38ba8" # red
  state="critical"

elif (( capacity <= 30 )); then
  icon="󰁼" # battery 30%
  color="#f9e2af" # yellow
  state="low"

elif (( capacity <= 40 )); then
  icon="󰁽" # battery 40%
  color="#f9e2af" # yellow
  state="low"

elif (( capacity <= 50 )); then
  icon="󰁾" # battery 50%
  color="#f9e2af" # yellow
  state="low"

elif (( capacity <= 60 )); then
  icon="󰁿" # battery 60%

elif (( capacity <= 70 )); then
  icon="󰂀" # battery 70%

elif (( capacity <= 80 )); then
  icon="󰂁" # battery 80%

elif (( capacity < 100 )); then
  icon="󰂂" # battery 90%

else
  icon="󰁹" # battery 100%
  color="#a6e3a1" # green
  state="normal"
fi

jq -cn \
  --argjson capacity "$capacity" \
  --arg status "$status" \
  --arg icon "$icon" \
  --arg color "$color" \
  --arg state "$state" \
  '{
    capacity: $capacity,
    status: $status,
    icon: $icon,
    color: $color,
    state: $state
  }'
