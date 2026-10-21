#!/usr/bin/env bash

wifi_device=$(
  nmcli -t -f DEVICE,TYPE device 2>/dev/null |
    awk -F: '$2 == "wifi" { print $1; exit }'
)

state="disconnected"
ssid=""
signal=0
icon="󰤭"
color="#6c7086"

if [[ -n "$wifi_device" ]]; then
  device_state=$(
    nmcli -t -f DEVICE,STATE device 2>/dev/null |
      awk -F: -v device="$wifi_device" '$1 == device { print $2; exit }'
  )

  if [[ "$device_state" == "connected" ]]; then
    state="connected"

    connection=$(
      nmcli -g GENERAL.CONNECTION device show "$wifi_device" 2>/dev/null
    )

    ssid=$(
      nmcli -g 802-11-wireless.ssid connection show "$connection" 2>/dev/null |
        head -n 1
    )

    # Если SSID не удалось получить, используем имя подключения
    [[ -z "$ssid" || "$ssid" == "--" ]] && ssid="$connection"

    signal=$(
      nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null |
        awk -F: '$1 == "*" { print $2; exit }'
    )

    [[ -z "$signal" ]] && signal=0

    if (( signal >= 75 )); then
      icon="󰤨"
      color="#a6e3a1" # Catppuccin Mocha green
    elif (( signal >= 50 )); then
      icon="󰤥"
      color="#a6e3a1" # green
    elif (( signal >= 25 )); then
      icon="󰤢"
      color="#f9e2af" # yellow
    else
      icon="󰤟"
      color="#f38ba8" # red
    fi
  fi
fi

jq -cn \
  --arg state "$state" \
  --arg ssid "$ssid" \
  --arg icon "$icon" \
  --arg color "$color" \
  --argjson signal "$signal" \
  '{
    state: $state,
    ssid: $ssid,
    signal: $signal,
    icon: $icon,
    color: $color
  }'