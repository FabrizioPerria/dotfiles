#compdef p4
# Perforce completion for zsh — unified on plain TAB.
# With fzf-tab loaded, every candidate set below renders through fzf
# automatically. No ** trigger; this replaces the split _p4 / _fzf_complete_p4.
# Source it from .zshrc AFTER compinit (and after fzf-tab is loaded).

# --- candidate sources (each hits the p4 server; expect latency) ---
_p4_changes()  { p4 changes -s pending -m 9999 2>/dev/null | awk '{print $2}' }
_p4_clients()  { p4 clients 2>/dev/null | awk '{print $2}' }
_p4_opened()   { p4 opened  2>/dev/null | awk -F'#' '{print $1}' }
_p4_branches() { p4 branches 2>/dev/null | awk '{print $3}' }
_p4_labels()   { p4 labels  2>/dev/null | awk '{print $2}' }
_p4_users()    { p4 users   2>/dev/null | awk '{print $1}' }
_p4_groups()   { p4 groups  2>/dev/null }
_p4_jobs()     { p4 jobs -m 9999 2>/dev/null | awk '{print $1}' }
_p4_scope() {
  local spec
  spec=$(p4 where . 2>/dev/null | awk '{print $1}' | sed 's|/\.\.\.$||')
  [[ -n $spec ]] && echo "${spec}/..." || echo "//..."
}
_p4_files_local() { p4 have "$(_p4_scope)" 2>/dev/null | awk -F' - ' '{print $2}' }
_p4_files_depot() { p4 have "$(_p4_scope)" 2>/dev/null | awk '{print $1}' | cut -d'#' -f1 }
_p4_files_add()   { find . -type f 2>/dev/null | grep -v '/\.' | sed 's|^\./||' }

# compadd from a candidate-source function's newline-separated output
_p4_add() { local -a i=( ${(f)"$($1)"} ); compadd -a i }

# Depot paths this client maps (left column of the View). Uses -ztag, not -F.
_p4_view_roots() {
  p4 -ztag client -o 2>/dev/null | awk '/^\.\.\. View[0-9]+ / {print $3}'
}

_p4_sync_dirs() {
  local w=${words[CURRENT]}
  if [[ $w == //*/?* ]]; then
    # inside a real depot path: complete the segment under the typed directory
    compset -P '*/'                       # IPREFIX becomes //PRJ_KNT/trunk/Tools/
    local base=${IPREFIX%/}               # //PRJ_KNT/trunk/Tools
    local -a kids=( ${(f)"$(p4 dirs "${base}/*" 2>/dev/null)"} )
    local -a leaves=( ${kids##*/} )       # Automation Build Config ...
    compadd -S / -- $leaves               # descend into a subdir
    compadd -- ${^leaves}/...             # sync that subtree
    compadd -- '...'                      # sync the current dir
  else
    # top level: the client's mapped areas
    local -a roots=( ${(f)"$(_p4_view_roots)"} )
    compadd -U -- $roots
    compadd -U -S / -- ${roots%/...}
  fi
}

# Complete versioned files + local subdirs, one level at a time. Fast.
_p4_have_files() {
  local dir pat
  if compset -P '*/'; then dir=${IPREFIX%/}; else dir='.'; fi
  [[ $dir == . ]] && pat='*' || pat="${dir}/*"

  # subdirectories at this level — instant, local, for navigating down
  local -a subdirs=( ${dir}/*(/N) ); subdirs=( ${subdirs:t} )
  # versioned files in THIS directory only — one scoped, non-recursive p4 have
  local -a vfiles=( ${(f)"$(p4 have "$pat" 2>/dev/null | awk -F' - ' 'NF>1{print $2}')"} )
  vfiles=( ${vfiles:t} )

  (( ${#subdirs} ))     && compadd -S / -- $subdirs
  [[ -n ${vfiles[1]} ]] && compadd -- $vfiles
}

_p4() {
  local cmd=${words[2]} prev=${words[CURRENT-1]}

  # 1. subcommand position
  if (( CURRENT == 2 )); then
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
    _describe 'p4 command' cmds
    return
  fi

  # 2. flag values (previous word is the flag)
  case $prev in
    -c)
      if [[ $cmd == (changes|changelists|clients|workspaces) ]]; then
        _p4_add _p4_clients
      else
        _p4_add _p4_changes
      fi
      return ;;
    -u) _p4_add _p4_users; return ;;
  esac

  # 3. positional values by subcommand
  case $cmd in
    describe|change|changelist|shelve|unshelve|submit|fix|reopen) _p4_add _p4_changes ;;
    client|workspace)                                             _p4_add _p4_clients ;;
    branch)                                                       _p4_add _p4_branches ;;
    label|labelsync|tag)                                          _p4_add _p4_labels ;;
    revert|resolve|lock|unlock|move|rename)                       _p4_add _p4_opened ;;
    edit|delete|diff|annotate|filelog|fstat|print|grep)           _p4_have_files ;;
    add|reconcile|rec)                                            _files ;;
    sync|flush|update)                                            _p4_sync_dirs ;;
    user)                                                         _p4_add _p4_users ;;
    group)                                                        _p4_add _p4_groups ;;
    job)                                                          _p4_add _p4_jobs ;;
  esac
}

compdef _p4 p4
