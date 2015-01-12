my-xmonad-config
================

This is my personal config for xmonad and other components of my desktop
environment. **As with all personal configs, don't just clone this repo and use
as-is**. You will probably want to make changes, and even if you don't, I may
break things. **So fork the repo, and then clone from your fork**.

If you are thinking of using this more or less as-is, bear in mind that
currently this config only technically supports a single 1366x768 screen; you'll
have to resize the dzen bars appropriate to your actual screen size, and if you
have multiple monitors you'll need to make major changes to the layout/number of
bars. I'm hoping to add out-of the box support for different sizes and numbers
of monitors in the future.

In order to use this you will need, installed and in your PATH, conky (with CLI
and lua support), lua, dzen2, and xmonad with the necessary libraries installed.
You will also need to start X using some technique that sources
'$HOME/.xinitrc'. I use xdm.

## Install

Firstly, you will need to back up (or
just delete, I guess?) any existing xmonad config in your home directory, and
then remove .xmonad.

```bash
$ # Backup .xmonad if necessary
$ rm -rf .xmonad
```

Once you're sure there's no .xmonad folder in your home directory, clone the
repo from where you forked it to:
```bash
$ git clone https://github.com/<your_username>/my-xmonad-config .xmonad
```

Once you've cloned the repo (remember to fork it first!), you'll need to do a
couple more things. Firstly, link the xinitrc file to ~/.xinitrc
```bash
$ ln -s ~/.xmonad/xinitrc ~/.xinitrc
```
This config uses
[conky\_dzen\_applets](https://github.com/ouroboros8/conky_dzen_applets), which
is included in this repo as a
[submodule](http://git-scm.com/book/en/v2/Git-Tools-Submodules). To download the
submodule, you'll need to do
```bash
$ git clone https://github.com/ouroboros8/xmonad-config.git
$ cd xmonad-config
$ git submodule init
$ git submodule update
```

Once all that's done, you should restart xmonad.
