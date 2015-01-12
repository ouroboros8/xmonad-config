#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Set sensible pointer
xsetroot -cursor_name left_ptr

# keymap
setxkbmap gb

# Merge clipboards
autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork

# background
feh --bg-scale ~/.background.jpg

# trayer
sh ~/.xmonad/trayer.sh

# redshift
redshift &

# xcompmgr
xcompmgr -F &

# Xresources
xrdb ~/.Xresources

# ssh-agent
eval $(ssh-agent)

# pulseaudio
pulseaudio --start

exec xmonad
