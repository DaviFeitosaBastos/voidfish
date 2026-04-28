function fish_prompt --description 'Write out the prompt'
    set last_ret $status
    set -g _last_status $last_ret
    set -g _last_duration $CMD_DURATION

    # Palette
    set -l base01 55f
    set -l base02 55a
    set -l base03 777
    set -l c_error f77
    set -l c_success 7f7
    set -l c_yellow ff5
    set -l c_magenta f0d
    set -l c_red c44
    set -l c_blue 55f
    set -l c_cyan 0cc
    set -l c_orange fa0

    # Hostname cache
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
    end
    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    # Virtualenv
    if set -q VIRTUAL_ENV
        set venv (_fisk_concat " " (set_color $c_magenta) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal))
    else
        set venv ""
    end

    # Exit code color
    set ret_color $c_success
    if test $last_ret -gt 0
        set ret_color $c_error
    end

    # Git info
    set -l git_branch (git branch --show-current 2>/dev/null)
    set -l git_part ""
    if test -n "$git_branch"
        set -l staged (git diff --cached --name-only 2>/dev/null | count)
        set -l modified (git diff --name-only 2>/dev/null | count)
        set -l untracked (git ls-files --others --exclude-standard 2>/dev/null | count)
        set -l ahead (git rev-list @{u}..HEAD 2>/dev/null | count)

        # Branches que ainda nao foram merged na branch atual
        set -l unmerged_branches (git branch --no-merged 2>/dev/null | grep -v "^\*" | wc -l | string trim)

        # Behind origin (alguem fez push no remote)
        set -l behind (git rev-list HEAD..@{u} 2>/dev/null | count)

        set -l git_extras ""
        if test $staged -gt 0
            set git_extras (_fisk_concat $git_extras (set_color 7f7) " +$staged")
        end
        if test $modified -gt 0
            set git_extras (_fisk_concat $git_extras (set_color f77) " ~$modified")
        end
        if test $untracked -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $base03) " ?$untracked")
        end
        if test $ahead -gt 0
            set git_extras (_fisk_concat $git_extras (set_color $c_magenta) " ⬆$ahead")
        end
        if test $behind -gt 0
            # tem commits no remote que voce nao tem local — precisa dar pull
            set git_extras (_fisk_concat $git_extras (set_color $c_orange) " ⬇$behind")
        end
        if test $unmerged_branches -gt 0
            # branches secundarias sem merge
            set git_extras (_fisk_concat $git_extras (set_color $c_cyan) " ⎇$unmerged_branches")
        end

        set git_part (_fisk_concat \
            (set_color $base03) " (" \
            (set_color $c_yellow) $git_branch \
            $git_extras \
            (set_color $base03) ")" \
        )
    end

    set -l ret_part (_fisk_concat \
        (set_color $base03) '[' \
        (set_color $ret_color) $last_ret \
        (set_color $base03) ']' \
    )

    set -l user_part (_fisk_concat \
        (set_color $c_red) $USER \
        (set_color $base02) @ \
        (set_color $c_red) $__fish_prompt_hostname \
    )

    set -l context_part (_fisk_concat \
        $__fish_prompt_cwd (prompt_pwd) $venv $git_part \
    )

    set -l prompt_end (_fisk_concat (set_color -o $c_blue) '$')

    echo -n (_fisk_concat $ret_part " " $user_part " " $context_part " " $prompt_end (set_color normal) " ")
end

function fish_right_prompt
    set -l c_time 888
    set -l c_yellow ff5
    set -l base03 777

    set -l duration ""
    if set -q _last_duration
        set -l ms $_last_duration
        if test $ms -ge 1000
            set -l secs (math -s1 "$ms / 1000")
            set duration (_fisk_concat (set_color $c_yellow) "$secs" "s ")
        else if test $ms -gt 100
            set duration (_fisk_concat (set_color $c_time) "$ms" "ms ")
        end
    end

    echo -n (_fisk_concat \
        $duration \
        (set_color $base03) "(" \
        (set_color $c_time) (date "+%H:%M:%S") \
        (set_color $base03) ")" \
        (set_color normal) \
    )
end
