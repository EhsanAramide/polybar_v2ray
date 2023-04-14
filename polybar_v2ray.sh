#!/bin/sh

ICON_CONNECTED="󰞀"
ICON_DISCONNECTED="󰻌"

COLOR_CONNECTED="#a5fb8f"
COLOR_DISCONNECTED="#e42f6b"

ROFI_MENU_TITLE=" VPN Configs"

CONFIGS_DIR_PATH=/etc/v2ray/configs
CONFIGS_FILE_PATH=/home/ehsan/.config/polybar/plugins/polybar_v2ray/configs
SERVICE_ENV_FILE_PATH=/home/ehsan/.config/polybar/plugins/polybar_v2ray/service_env

source $SERVICE_ENV_FILE_PATH

_current_config () {
    echo "${CONFIG_PATH##*/}" # /path/to/config.json => config.json
}

v2ray_status () {
    isActive=$(systemctl --user is-active v2ray.service)
    if [[ $isActive != "active" ]]; then
        echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED disconnected%{F-}"
    else
        echo "%{F$COLOR_CONNECTED}$ICON_CONNECTED connected%{F-}"
    fi
}

v2ray_toggle_connection () {
    isActive=$(systemctl --user is-active v2ray.service)
    if [[ $isActive != "active" ]]; then
        systemctl --user start v2ray.service
        echo "%{F$COLOR_CONNECTED}$ICON_CONNECTED connected%{F-}"
        dunstify "V2ray connected!" "connected to $(_current_config)" -r 2222 -i /usr/share/icons/Papirus-Dark/16x16/devices/network-vpn.svg
    else
        systemctl --user stop v2ray.service
        echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED disconnected%{F-}"
        dunstify "V2ray disconnected!" "disconnected from $(_current_config)" -r 2222 -i /usr/share/icons/Papirus-Dark/16x16/devices/network-vpn.svg
    fi
    # v2ray_status
}

v2ray_change_configs () {
    $(ls $CONFIGS_DIR_PATH | cat > $CONFIGS_FILE_PATH)
    config=$(rofi -location 3 -xoffset -45 -yoffset +35 -sep "\n" -dmenu -i -p "$ROFI_MENU_TITLE" -input $CONFIGS_FILE_PATH)
    if [[ -z "$config" ]]; then
        return 0
    fi
    echo "CONFIG_PATH=$CONFIGS_DIR_PATH/$config" > $SERVICE_ENV_FILE_PATH
    
    systemctl --user restart v2ray.service

    dunstify "V2ray connected!" "$config configuration currently is running" -r 2222 -i /usr/share/icons/Papirus-Dark/16x16/devices/network-vpn.svg
}

case "$1" in
    status)
        v2ray_status
    ;;

    toggle)
        v2ray_toggle_connection
    ;;

    menu)
        v2ray_change_configs
    ;;
esac
