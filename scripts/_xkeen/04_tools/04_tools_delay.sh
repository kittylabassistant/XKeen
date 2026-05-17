get_current_delay() {
    awk -F= '/^[[:space:]]*start_delay=/{print $2; exit}' "$1" | tr -d '[:space:]"'
}

delay_autostart() {
    new_delay="$1"

    if [ ! -f "$initd_file" ]; then
        printf '%b\n' "  ${red}Ошибка${reset}: Не найден файл автозапуска ${yellow}S05xkeen${reset}"
        return 1
    fi

    current_delay=$(get_current_delay "$initd_file")

    if [ -z "$new_delay" ]; then
        printf '%b\n' "  Текущая задержка автозапуска XKeen ${yellow}${current_delay} секунд(ы)${reset}"
        return 0
    fi

    case "$new_delay" in
        ''|*[!0-9]*)
            printf '%b\n' "  ${red}Ошибка${reset}"
            echo "  Новая задержка должна быть числом"
            return 1
        ;;
    esac

    if [ "$current_delay" = "$new_delay" ]; then
        echo "  Обновление задержки автозапуска XKeen не требуется"
        return 0
    fi

    tmpfile=$(mktemp) || return 1

    awk -v d="$new_delay" '
    /^[[:space:]]*start_delay=/ && !done {
        sub(/=.*/, "=" d)
        done=1
    }
    {print}
    ' "$initd_file" > "$tmpfile" && mv "$tmpfile" "$initd_file"

    if [ "$(get_current_delay "$initd_file")" = "$new_delay" ]; then
        printf '%b\n' "  Установлена задержка автозапуска XKeen ${yellow}${new_delay} секунд(ы)${reset}"
    else
        printf '%b\n' "  ${red}Ошибка${reset}: не удалось обновить параметр"
        return 1
    fi
}