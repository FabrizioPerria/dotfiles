#compdef tc teamcity
# Self-contained TeamCity completion — mirrors the Windows PSReadLine completer.
# Everything on plain TAB; fzf-tab renders it. No cobra, no ** trigger.
# Replaces the entire previous tc setup (source <(tc completion zsh), compdef
# _teamcity tc, and the _fzf_complete_tc block).
#
# Queries call `teamcity` directly — zsh does not expand the `tc` alias inside
# a function, so `tc ...` here would fail.

_tc_jobs()     { teamcity job list -n 9999 --json     2>/dev/null | jq -r '.buildType[].id' }
_tc_projects() { teamcity project list -n 9999 --json 2>/dev/null | jq -r '.project[].id' }
_tc_agents()   { teamcity agent list -n 9999 --json   2>/dev/null | jq -r '.agent[].name' }
_tc_pools()    { teamcity pool list --json            2>/dev/null | jq -r '.pool[].name' }
_tc_runs()     { teamcity run list -n 9999 --json     2>/dev/null | jq -r '.build[].id' }
_tc_queue()    { teamcity queue list -n 9999 --json   2>/dev/null | jq -r '.build[].id' }
_tc_branches() { git branch --format='%(refname:short)' 2>/dev/null }

_tc_add() { local -a i=( ${(f)"$($1)"} ); compadd -a i }

_tc() {
  local cmd=${words[2]} sub=${words[3]} prev=${words[CURRENT-1]}

  # 1. top-level subcommand
  if (( CURRENT == 2 )); then
    local -a c=(
      'agent:Manage build agents'
      'alias:Manage command aliases'
      'api:Make an authenticated API request'
      'auth:Authenticate with TeamCity'
      'completion:Generate the autocompletion script'
      'config:Manage CLI configuration'
      'help:Help about any command'
      'job:Manage jobs (build configurations)'
      'pipeline:Manage pipelines (YAML configurations)'
      'pool:Manage agent pools'
      'project:Manage projects'
      'queue:Manage build queue'
      'run:Manage runs (builds)'
      'skill:Manage AI coding agent skills'
      'update:Check for CLI updates'
    )
    _describe 'tc command' c
    return
  fi

  # 2. sub-subcommand
  if (( CURRENT == 3 )); then
    local -a c
    case $cmd in
      run)     c=(artifacts cancel changes comment download list log pin restart start tag tests unpin untag view watch) ;;
      job)     c=(list param pause resume tree view) ;;
      project) c=(list param settings token tree view) ;;
      agent)   c=(authorize deauthorize disable enable exec jobs list move reboot term view) ;;
      queue)   c=(approve list remove top) ;;
      pool)    c=(link list unlink view) ;;
    esac
    (( ${#c} )) && compadd -a c
    return
  fi

  # while typing a flag name, offer nothing (let it be)
  [[ ${words[CURRENT]} == -* ]] && return

  # 3. flag values
  case $prev in
    --project)   _tc_add _tc_projects; return ;;
    --job|-j)    _tc_add _tc_jobs;     return ;;
    --agent)     _tc_add _tc_agents;   return ;;
    --pool)      _tc_add _tc_pools;    return ;;
    --branch|-b) _tc_add _tc_branches; return ;;
    --status)    compadd success failure running error unknown; return ;;
  esac

  # 4. positional values
  case $cmd in
    run)
      case $sub in
        start) _tc_add _tc_jobs ;;
        cancel|restart|pin|unpin|tag|untag|view|log|watch|artifacts|download|changes|comment|tests) _tc_add _tc_runs ;;
      esac ;;
    job)     [[ $sub == (view|pause|resume|tree|param) ]] && _tc_add _tc_jobs ;;
    project) [[ $sub == (view|param|settings|token) ]]    && _tc_add _tc_projects ;;
    agent)   [[ $sub == (view|enable|disable|authorize|deauthorize|reboot|exec|term|jobs|move) ]] && _tc_add _tc_agents ;;
    queue)   [[ $sub == (approve|remove|top) ]]           && _tc_add _tc_queue ;;
    pool)    [[ $sub == (view|link|unlink) ]]             && _tc_add _tc_pools ;;
  esac
}

compdef _tc tc teamcity
