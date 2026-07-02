#!/bin/bash

cd "$(dirname "$0")" || exit 1

DIR_CONFIG="./config"
TARGET_LINK="config.jsonc"

if [ ! -d "$DIR_CONFIG" ]; then
    echo "DIR_CONFIG: '$DIR_CONFIG' not found!"
    exit 1
fi

config_list=( $(cd "$DIR_CONFIG" && echo *.jsonc) )

if [ ${#config_list[@]} -eq 0 ] || [ "${config_list}" == "*.jsonc" ]; then
    echo "$DIR_CONFIG empty : no valid fastfetch config file"
    exit 1
fi

echo "====================================="
echo "  SELECT FASTFETCH CONFIG FILE"
echo "====================================="
for i in "${!config_list[@]}"; do
    echo "[$((i+1))] ${config_list[$i]}"
done
echo "====================================="



read -p "input number => (1-${#config_list[@]}): " option

if ! [[ "$option" =~ ^[0-9]+$ ]] || [ "$option" -lt 1 ] || [ "$option" -gt "${#config_list[@]}" ]; then
    echo "❌ invalid option. failed to change config."
    exit 1
fi

selected_config="${config_list[$((option-1))]}"


echo "====================================="

if [ -L "$TARGET_LINK" ] || [ -f "$TARGET_LINK" ]; then
    rm "$TARGET_LINK"
fi

ln -s "$DIR_CONFIG/$selected_config" "$TARGET_LINK"

echo "󰸞 successfully changed the fastfetch '$TARGET_LINK' config to '$DIR_CONFIG/$selected_config'"

exit 0