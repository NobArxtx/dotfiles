from invoke import task
from provisioning.utils import platform


if platform() == "Darwin":
  from provisioning.apps import *
  from provisioning.core import *
  from provisioning.homebrew import *

  @task(
    # Core
    homebrew,
    dotfiles,

    # CLI utils
    ack,
    autojump,
    coreutils,
    ctags,
    htop,
    httpie,
    jq,
    parallel,
    python,
    tmux,
    tree,
    zsh,

    # Applications
    alfred,
    chrome,
    dropbox,
    iterm2,
    keepassx,
    macvim,
  )
  def all(ctx):
    pass

elif platform() == "Linux":
  from provisioning.apt import *
  from provisioning.core import dotfiles

  @task(
    ag,
    alsamixergui,
    dotfiles,
    dropbox,
    fish,
    flake8,
    fzf,
    htop,
    keepass2,
    spotify,
    terminator,
    tmux,
    vim,
    xclip,
    xmonad,
    zsh,
  )
  def all(ctx):
    "Install all recommended packages."
    pass

else:
  raise Exception("Unknown platform: " + platform())
