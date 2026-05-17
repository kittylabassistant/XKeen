# Определение времени для задач cron
choice_cron_time() {
    [ "$choice_geofile_cron_select" = true ] || return

    echo
    printf '%b\n' "  Время автоматического обновления ${yellow}геофайлов${reset}:"
    echo
    echo "  Выберите день"
    echo "     0. Отмена"
    echo "     1. Понедельник"
    echo "     2. Вторник"
    echo "     3. Среда"
    echo "     4. Четверг"
    echo "     5. Пятница"
    echo "     6. Суббота"
    echo "     7. Воскресенье"
    echo "     8. Ежедневно"
    echo

    while :; do
        printf '%s' "  Ваш выбор: "; read -r day_choice
        echo "$day_choice" | grep -qE '^[0-8]$' && break
        printf '%b\n' "  ${red}Некорректный номер действия.${reset} Пожалуйста, выберите снова"
    done

    [ "$day_choice" -eq 0 ] && {
        printf '%b\n' "  Включение автоматического обновления ${yellow}геофайлов${reset} отменено."
        return
    }

    echo

    while :; do
        printf '%s' "  Выберите час (0-23): "; read -r hour
        case "$hour" in
            ''|*[!0-9]*) ;;
            *) [ "$hour" -ge 0 ] && [ "$hour" -le 23 ] && break ;;
        esac
        printf '%b\n' "  ${red}Некорректный час.${reset} Пожалуйста, попробуйте снова"
    done

    while :; do
        printf '%s' "  Выберите минуту (0-59): "; read -r minute
        case "$minute" in
            ''|*[!0-9]*) ;;
            *) [ "$minute" -ge 0 ] && [ "$minute" -le 59 ] && break ;;
        esac
        printf '%b\n' "  ${red}Некорректные минуты.${reset} Пожалуйста, попробуйте снова"
    done

    if [ "$day_choice" -eq 8 ]; then
        cron_expression="$minute $hour * * *"
        day_name="Ежедневно"
    else
        case "$day_choice" in
            1) dow=1; day_name="Понедельник" ;;
            2) dow=2; day_name="Вторник" ;;
            3) dow=3; day_name="Среда" ;;
            4) dow=4; day_name="Четверг" ;;
            5) dow=5; day_name="Пятница" ;;
            6) dow=6; day_name="Суббота" ;;
            7) dow=0; day_name="Воскресенье" ;;
        esac
        cron_expression="$minute $hour * * $dow"
    fi

    formatted_hour=$(printf "%02d" "$hour")
    formatted_minute=$(printf "%02d" "$minute")

    echo
    printf '%b\n' "  Выбранное время обновления ${yellow}геофайлов${reset}: $day_name в $formatted_hour:$formatted_minute"

    choice_geofile_cron_time="$cron_expression"
}