---
layout: default
title: personalización consola bash
fecha: 2023-12-08
nav_order: 1
---

&nbsp;

# personalización consola bash

&nbsp;

## ~/.bashrc
Se ejecuta automaticamente por bash en un nuevo shell interactivo sin login

    # personalizacion
    alias sudo='sudo '
    alias ll='ls -halF'
    alias catnc="grep -vn -e '^\s*#' -e '^\s*$' "
    bind "set enable-bracketed-paste off"
    shopt -s histappend
    export HISTTIMEFORMAT="%y/%m/%d %T   "
    export HISTSIZE=100000
    export HISTFILESIZE=1000000
    export PROMPT_COMMAND='history -a'        

    #prompt con path absoluto a la derecha y nombre de terminal
    export PROMPT_COMMAND=$PROMPT_COMMAND'; printf "\\e[90m%*s\\e[0m"  $COLUMNS "$(pwd) ($(ps hotty $$)) $(hostname -I)"'
    
En el fichero de personalizacion .bashrc de root , para tener prompt en video inverso (7m), negrita (1m) o subrayado (4m), añadir al final de .bashrc --regresar a modo normal (0m)--:
    ...
    export PS1="\[\e[7m\]$(echo $PS1 | sed 's/ *$//')\[\e[0m\] "

&nbsp;

## ~/.tmux.conf
    
    # cambiar prefix y numeracion de ventanas y paneles
    set  -g prefix M-º
    set  -s escape-time 1
    set  -g base-index 1
    setw -g pane-base-index 1
    set  -g history-limit 10000

    # recargar tmux.conf
    bind  r source ~/.tmux.conf \; display "reloaded!"

    # cambiar de ventana y panel 
    bind -n F1 select-window -t 1
    bind -n F2 select-window -t 2
    bind -n F3 select-window -t 3
    bind -n F4 select-window -t 4
    bind -n F5 select-window -t 5
    bind -n F6 select-window -t 6
    bind -n F7 select-window -t 7
    bind -n F8 select-window -t 8
    bind -n F9 select-window -t 9
    bind -n F10 select-window -t 10
    bind -n F12 select-pane  -t:.+

    # volcar salida de panel a fichero de texto
    bind -n M-F12 run "tmux capture-pane; tmux save-buffer $(date +%Y%m%d-%H%M%S)"

    # seleccionar, copiar y pegar con teclas de vi
    setw -g mode-keys vi
    bind   Escape copy-mode
    bind-key -T copy-mode-vi v send -X begin-selection
    bind-key -T copy-mode-vi y send -X copy-selection
    unbind p
    bind   p paste-buffer        

    # aspecto
    set  -g default-terminal "screen-256color"                                                                                                                                                                                                                                                                                     
    set  -g status-style fg=white,bg=colour236
    setw -g window-status-style fg=white,bg=colour236
    setw -g window-status-current-style fg=black,bg=white
    setw -g pane-border-style fg=colour236,bg=black
    setw -g pane-active-border-style fg=colour236,bg=colour236
    set  -g message-style fg=brightwhite,bg=colour236
    set  -g status-left "#S"
    set  -g status-right "%d %b %R"
    set  -g status-justify centre

&nbsp;

## ~/.vimrc
    
    syntax on
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set number
    set backup
    set cursorline
    set t_Co=256
    set term=xterm-256color
    set colorcolumn=80
    set textwidth=0
    set wrapmargin=0
    set formatoptions+=t
    set linebreak
    set listchars=nbsp:.
    set mmp=2000000

    hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
    hi CursorLineNr cterm=NONE
    hi Visual cterm=none ctermbg=darkgrey ctermfg=cyan
    hi ColorColumn ctermbg=234

    :nnoremap H :set cursorline!<CR>
    noremap <C-Z> :w!<CR>
    inoremap <C-Z> <C-O>:w!<CR>

&nbsp;

## ~/.config/htop/htoprc

    # Beware! This file is rewritten by htop when settings are changed in the interface.
    # The parser is also very primitive, and not human-friendly.
    htop_version=3.2.2
    config_reader_min_version=3
    fields=0 48 17 18 38 39 40 2 46 47 49 1
    hide_kernel_threads=1
    hide_userland_threads=0
    hide_running_in_container=0
    shadow_other_users=0
    show_thread_names=0
    show_program_path=1
    highlight_base_name=0
    highlight_deleted_exe=1
    shadow_distribution_path_prefix=0
    highlight_megabytes=1
    highlight_threads=1
    highlight_changes=0
    highlight_changes_delay_secs=5
    find_comm_in_cmdline=1
    strip_exe_from_cmdline=1
    show_merged_command=0
    header_margin=1
    screen_tabs=1
    detailed_cpu_time=0
    cpu_count_from_one=0
    show_cpu_usage=1
    show_cpu_frequency=0
    show_cpu_temperature=0
    degree_fahrenheit=0
    update_process_names=0
    account_guest_in_cpu_meter=0
    color_scheme=0
    enable_mouse=1
    delay=15
    hide_function_bar=0
    header_layout=three_33_34_33
    column_meters_0=Uptime AllCPUs Memory
    column_meter_modes_0=4 1 1
    column_meters_1=DateTime Hostname System LoadAverage Tasks
    column_meter_modes_1=2 2 2 2 2
    column_meters_2=Systemd SELinux Blank DiskIO NetworkIO
    column_meter_modes_2=2 2 2 2 2
    tree_view=0
    sort_key=46
    tree_sort_key=0
    sort_direction=-1
    tree_sort_direction=1
    tree_view_always_by_pid=0
    all_branches_collapsed=0
    screen:Main=PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME Command
    .sort_key=PERCENT_CPU
    .tree_sort_key=PID
    .tree_view=0
    .tree_view_always_by_pid=0
    .sort_direction=-1
    .tree_sort_direction=1
    .all_branches_collapsed=0
    screen:I/O=PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE Command
    .sort_key=IO_RATE
    .tree_sort_key=PID
    .tree_view=0
    .tree_view_always_by_pid=0
    .sort_direction=-1
    .tree_sort_direction=1
    .all_branches_collapsed=0

&nbsp;
