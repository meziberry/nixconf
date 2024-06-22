use re
use builtin
use readline-binding
use path
use str
use math

# Where all the Go stuff is
# if (path:is-dir ~/Dropbox/Personal/devel/go) {
#   set E:GOPATH = ~/Dropbox/Personal/devel/go
# } else {
#   set E:GOPATH = ~/go
# }

# Optional paths, add only those that exist
var optpaths = [
  $E:XDG_CONFIG_HOME/doom/bin
  $E:XDG_CONFIG_HOME/emacs/bin
  $E:HOME/.cargo/bin
  # /usr/local/opt/python/libexec/bin
]
var optpaths-filtered = [(each {|p|
      if (path:is-dir $p) { put $p }
} $optpaths)]

set paths = [
  # ~/bin
  # $E:GOPATH/bin
  $@optpaths-filtered
  /etc/profiles/per-user/$E:USER/bin
  /nix/var/nix/profiles/system/sw/bin
  /usr/local/bin
  /usr/sbin
  /sbin
  /usr/bin
  /bin
]

each {|p|
  if (not (path:is-dir &follow-symlink $p)) {
    echo (styled "Warning: directory "$p" in $paths no longer exists." red)
  }
} $paths

use epm

epm:install &silent-if-installed       ^
github.com/zzamboni/elvish-modules     ^
github.com/zzamboni/elvish-completions ^
github.com/zzamboni/elvish-themes      ^
github.com/xiaq/edit.elv               ^
github.com/muesli/elvish-libs          ^
github.com/iwoloschin/elvish-packages

set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

set edit:insert:binding[Alt-d] = $edit:kill-small-word-right~

set edit:insert:binding[Alt-m] = $edit:-instant:start~

set edit:max-height = 20

# use github.com/zzamboni/elvish-modules/1pass
# 1pass:read-aliases

use github.com/zzamboni/elvish-modules/lazy-vars

# set E:USER_750WORDS = diego@zzamboni.org
# lazy-vars:add-var PASS_750WORDS { 1pass:get-password "750words.com" }
# lazy-vars:add-alias 750words-client.py [ PASS_750WORDS ]

use alias

fn have-external { |prog|
  put ?(which $prog >/dev/null 2>&1)
}
fn only-when-external { |prog lambda|
  if (have-external $prog) { $lambda }
}

alias:bash-alias g=git
alias:bash-alias v=vim
alias:new vf 'vim (fzf)'
alias:new e emacsclient --create-frame '{}' '&'
alias:new et emacsclient --create-frame --tty
alias:new ef 'et (fzf)'
only-when-external just { alias:bash-alias j=just }
only-when-external lsd {
  alias:bash-alias l=lsd
  alias:bash-alias ls=lsd
  alias:new ll lsd -l
  alias:new la lsd -A
  alias:new lt lsd -l --tree
  alias:new lla lsd -lA
  alias:new t lsd --tree
  alias:new tree lsd --tree
}

only-when-external dfc {
  alias:new dfc e:dfc -p -/dev/disk1s4,devfs,map,com.apple.TimeMachine
}

only-when-external bat {
  alias:new cat bat
  alias:new more bat --paging always
  set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
}

fn manpdf {|@cmds|
  each {|c|
    man -t $c | open -f -a /System/Applications/Preview.app
  } $cmds
}

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply

# Enable the universal command completer if available.
# See https://github.com/rsteube/carapace-bin
if (has-external carapace) {
  eval (carapace _carapace | slurp)
}

use github.com/zzamboni/elvish-completions/ssh

#   eval (starship init elvish | sed 's/except/catch/')
# Temporary fix for use of except in the output of the Starship init code
eval (starship init elvish --print-full-init | slurp)

set edit:prompt-stale-transform = {|x| styled $x "bright-black" }

set edit:-prompt-eagerness = 10

use github.com/zzamboni/elvish-modules/long-running-notifications

use github.com/zzamboni/elvish-modules/bang-bang

set edit:insert:binding[Ctrl-R] = {
  edit:histlist:start
}

only-when-external  zoxide {
  eval (zoxide init elvish | slurp)
  fn __zoxide_zi {|@rest|
      var path
      try {
          fn item {|x| put [&to-show=$x &to-accept=$x &to-filter=$x] }
          set path = [(zoxide query -l $@rest | each $item~)]
      } catch e {
      } else {
          edit:listing:start-custom $path &accept=$builtin:cd~
      }
  }
  edit:add-var zi~ $__zoxide_zi~
}

use github.com/zzamboni/elvish-modules/terminal-title

var private-loaded = ?(use private)

use github.com/zzamboni/elvish-modules/atlas

use github.com/zzamboni/elvish-modules/opsgenie

only-when-external pyenv {
  set paths = [ ~/.pyenv/shims $@paths ]
  set-env PYENV_SHELL elvish
}

set E:LESS = "-i -R"

set E:EDITOR = "vim"

set E:LC_ALL = "en_US.UTF-8"

use github.com/zzamboni/elvish-modules/util

use github.com/muesli/elvish-libs/git

use github.com/iwoloschin/elvish-packages/update
set update:curl-timeout = 3
update:check-commit &verbose

use github.com/zzamboni/elvish-modules/util-edit
util-edit:electric-delimiters

use github.com/zzamboni/elvish-modules/spinners
use github.com/zzamboni/elvish-modules/tty
