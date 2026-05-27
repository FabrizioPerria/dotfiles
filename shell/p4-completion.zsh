# p4 subcommand completion (regular TAB, no ** trigger needed)
_p4() {
  local -a cmds=(
    'add:Open a new file to add it to the depot'
    'annotate:Print file lines along with their revisions'
    'branch:Create or edit a branch specification'
    'branches:Display list of branches'
    'change:Create or edit a changelist description'
    'changes:Display list of pending and submitted changelists'
    'changelist:Create or edit a changelist description'
    'changelists:Display list of pending and submitted changelists'
    'clean:Delete or refresh local files to match depot state'
    'client:Create or edit a client specification'
    'clients:Display list of known clients'
    'copy:Schedule copy of latest rev from one file to another'
    'delete:Open an existing file to delete it from the depot'
    'describe:Display a changelist description'
    'diff:Display diff of client file with depot file'
    'diff2:Display diff of two depot files'
    'dirs:List subdirectories of a given depot directory'
    'edit:Open an existing file for edit'
    'filelog:List revision history of files'
    'files:List files in the depot'
    'fix:Mark jobs as being fixed by named changelists'
    'fixes:List what changelists fix what job'
    'flush:Fake a sync by not moving files'
    'fstat:Dump file info'
    'grep:Print lines from text files matching a pattern'
    'group:Change members of a user group'
    'groups:List groups of users'
    'have:List revisions last synced'
    'help:Print help message'
    'info:Print out client/server information'
    'integrate:Schedule integration from one file to another'
    'integrated:Show integrations that have been submitted'
    'istat:Show integrations needed for a stream'
    'job:Create or edit a job specification'
    'jobs:Display list of jobs'
    'label:Create or edit a label specification'
    'labels:Display list of labels'
    'labelsync:Synchronize label with current client contents'
    'lock:Lock an opened file against changelist submission'
    'login:Login to Helix Core'
    'logout:Logout of Helix Core'
    'merge:Schedule merge from one file to another'
    'move:Move files from one location to another'
    'opened:Display list of files opened for pending changelist'
    'populate:Populate a branch or stream with files'
    'print:Retrieve a depot file to standard output'
    'rec:Reconcile client to offline workspace changes'
    'reconcile:Reconcile client to offline workspace changes'
    'rename:Move files from one location to another'
    'reopen:Change the type or changelist number of an opened file'
    'reshelve:Copy shelved files to a new or existing shelf'
    'resolve:Merge open files with other revisions or files'
    'resolved:Show files that have been merged but not submitted'
    'revert:Discard changes from an opened file'
    'shelve:Store files from a pending changelist into the depot'
    'status:Preview reconcile of client to offline workspace changes'
    'stream:Create or edit a stream specification'
    'streams:Display list of streams'
    'submit:Submit open files to the depot'
    'switch:Switch to a different stream'
    'sync:Synchronize the client with its view of the depot'
    'tag:Tag files with a label'
    'undo:Undo a range of revisions'
    'unlock:Release a locked file but leave it open'
    'unshelve:Restore shelved files from a pending changelist'
    'update:Update the client with its view of the depot'
    'user:Create or edit a user specification'
    'users:Display list of known users'
    'where:Show how file names map through the client view'
    'workspace:Create or edit a client specification'
    'workspaces:Display list of known clients'
  )
  if (( CURRENT == 2 )); then
    _describe 'p4 commands' cmds
  fi
}
compdef _p4 p4

# Perforce p4 fzf completion
# Trigger: p4 <cmd> **<TAB>  or  p4 <cmd> -flag **<TAB>
#
# fzf calls _fzf_complete_p4 with the full left buffer as ONE string ($1).
# Use ${(z)1} to split into words.

_p4_changes()      { p4 changes -s pending -m 9999 | awk '{print $2}'; }
_p4_clients()      { p4 clients | awk '{print $2}'; }
_p4_opened()       { p4 opened | awk -F'#' '{print $1}'; }
_p4_branches()     { p4 branches | awk '{print $3}'; }
_p4_labels()       { p4 labels  | awk '{print $2}'; }
_p4_users()        { p4 users   | awk '{print $1}'; }
_p4_groups()       { p4 groups; }
_p4_jobs()         { p4 jobs -m 9999 | awk '{print $1}'; }
_p4_scope() {
  # Use current-dir scope if inside workspace, else fall back to full client
  local spec
  spec=$(p4 where . 2>/dev/null | awk '{print $1}' | sed 's|/\.\.\.$||')
  [[ -n "$spec" ]] && echo "${spec}/..." || echo "//..."
}
_p4_files_local()  { p4 have "$(_p4_scope)" 2>/dev/null | awk -F' - ' '{print $2}'; }
_p4_files_depot()  { p4 have "$(_p4_scope)" 2>/dev/null | awk '{print $1}' | cut -d'#' -f1; }
_p4_files_add()    { find . -type f 2>/dev/null | grep -v '/\.' | sed 's|^\./||'; }

_fzf_complete_p4() {
  local -a words=(${(z)1})
  local -a o=(--height 50% --border --ansi)
  local last="${words[-1]}" sub="${words[2]}"

  # Flag value completions
  case "$last" in
    -c)
      # -c = client in 'changes'/'clients', changelist everywhere else
      if [[ "$sub" == "changes" || "$sub" == "changelists" || "$sub" == "clients" || "$sub" == "workspaces" ]]; then
        _fzf_complete "${o[@]}" -- "$@" < <(_p4_clients)
      else
        _fzf_complete "${o[@]}" -- "$@" < <(_p4_changes)
      fi; return ;;
    -u)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_users)
      return ;;
  esac

  # Positional completions
  case "$sub" in
    describe|change|changelist|shelve|unshelve|submit|fix|reopen)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_changes) ;;
    client|workspace)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_clients) ;;
    branch)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_branches) ;;
    label|labelsync|tag)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_labels) ;;
    revert|resolve|lock|unlock|move|rename)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_opened) ;;
    edit|delete|diff|annotate|filelog|fstat|print|grep)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_files_local) ;;
    sync|flush|update)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_files_depot) ;;
    add|reconcile|rec)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_files_add) ;;
    user)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_users) ;;
    group)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_groups) ;;
    job)
      _fzf_complete "${o[@]}" -- "$@" < <(_p4_jobs) ;;
  esac
}

_fzf_complete_p4_post() { awk '{print $1}'; }
