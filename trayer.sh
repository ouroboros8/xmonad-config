#!/bin/sh

TRAYER_DOCKINESS="--SetDockType true --SetPartialStrut true"
TRAYER_POS="--edge bottom --align right"
TRAYER_SIZE="--widthtype pixel --width 200 --heighttype pixel --height 20"
TRAYER_COLOR="--transparent true --alpha 0 --tint 0x1D1D1D"
trayer $(echo $TRAYER_DOCKINESS $TRAYER_POS $TRAYER_SIZE $TRAYER_COLOR) &
