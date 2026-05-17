show_deprecation_warning() {
    printf '%b\n' "  ${red}Внимание!${reset} Команда устарела и удалена из XKeen"
    printf '%b\n' "  Компонент '${yellow}Модули ядра подсистемы Netfilter${reset}' обязателен"
    echo
}

migration_modules() {
    show_deprecation_warning && return
}

remove_modules() {
    show_deprecation_warning && return
}