function fish_prompt --description 'Write out the prompt'
    set last_ret $status
    set -g _last_status $last_ret
    set -g _last_duration $CMD_DURATION

    # Palette root - tons de vermelho/laranja
    set -l c_red ff2222
    set -l c_orange ff6600
    set -l c_dark_red 880000
    set -l c_yellow ff5
    set -l c_magenta f0d
    set -l c_base 555
    set -l c_cyan 0cc


    # Hostname cache
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
    end
    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    # Git info
    set -l git_branch (git branch --show-current 2>/dev/null)
    set -l git_part ""
    if test -n "$git_branch"
        set -l staged (git diff --cached --name-only 2>/dev/null | count)
        set -l modified (git diff --name-only 2>/dev/null | count)
        set -l untracked (git ls-files --others --exclude-standard 2>/dev/null | count)
        set -l ahead (git rev-list @{u}..HEAD 2>/dev/null | count)
        set -l behind (git rev-list HEAD..@{u} 2>/dev/null | count)
        set -l unmerged_branches (git branch --no-merged 2>/dev/null | grep -v "^\*" | wc -l | string trim)

        set -l git_extras ""
        if test $staged -gt 0
            set git_extras (_fisk_concat $git_extras (set_color 7f7) " +$staged")
        end
        if test $modified -gt 0
            set git_extras (_fisk_concat $git_extras (set_color f77) " ~$modified")
        end
        if test $untracked -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $c_base) " ?$untracked")
        end
        if test $ahead -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $c_magenta) " ⬆$ahead")
        end
        if test $behind -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $c_orange) " ⬇$behind")
        end
        if test $unmerged_branches -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $c_cyan) " ⎇$unmerged_branches")
        end

        set git_part (_fisk_concat \
            (set_color $c_dark_red) " (" \
            (set_color $c_yellow) $git_branch \
            $git_extras \
            (set_color $c_dark_red) ")" \
        )
    end

    # ⚡ user@host
    set -l user_part (_fisk_concat \
        (set_color $c_red) "⚡ " \
        (set_color $c_red) $USER \
        (set_color $c_orange) "@" \
        (set_color $c_orange) $__fish_prompt_hostname \
    )

    # diretorio
    set -l context_part (_fisk_concat \
        (set_color $c_dark_red) " " \
        (set_color $c_red) (prompt_pwd) \
        $git_part \
    )
    
    # [ROOT]
    set -l root_badge (_fisk_concat \
        " " (set_color -o $c_red) "[ROOT]" \
    )

    # ➜#
    set -l prompt_end (_fisk_concat \
        " " (set_color -o $c_red) "➜" \
        (set_color -o ff4444) "#" \
    )

    echo -n (_fisk_concat $user_part $context_part $root_badge $prompt_end (set_color normal) " ")
end

function fish_right_prompt
    set -l c_time 883333
    set -l c_red ff2222
    set -l c_base 553333

    set -l duration ""
    if set -q _last_duration
        set -l ms $_last_duration
        if test $ms -ge 1000
            set -l secs (math -s1 "$ms / 1000")
            set duration (_fisk_concat (set_color $c_red) "$secs" "s ")
        else if test $ms -gt 100
            set duration (_fisk_concat (set_color $c_time) "$ms" "ms ")
        end
    end

    echo -n (_fisk_concat \
        $duration \
        (set_color $c_base) "(" \
        (set_color $c_time) (date "+%H:%M:%S") \
        (set_color $c_base) ")" \
        (set_color normal) \
    )
end
