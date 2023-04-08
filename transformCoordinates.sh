#!/bin/bash

# ORIG_W=1654
# ORIG_H=1080
# NEW_W=1654
# NEW_H=1080
# X_OFFSET=-169
# Y_OFFSET=0
# AFFECT=Upper

ORIG_W=1654
ORIG_H=1080
NEW_W=1654
NEW_H=1080
X_OFFSET=1402
Y_OFFSET=-18
AFFECT=Lower

FACTOR_X=$( echo "$NEW_W / $ORIG_W" | bc -l )
FACTOR_Y=$( echo "$NEW_H / $ORIG_H" | bc -l )

for sector in sectors/*
do
	ARC="$( cat "$sector/sector.txt" | grep -oP '^[^,]+' )"

	if [[ $ARC == $AFFECT ]]
	then

		ORIG="$( cat "$sector/mainMapPos.txt" )"
		ORIG_X=${ORIG%%,*}
		ORIG_Y=${ORIG##*,}

		NEW_X="$( echo "$ORIG_X * $FACTOR_X + $X_OFFSET" | bc -l | awk '{ print int($1 + 0.5) }')"
		NEW_Y="$( echo "$ORIG_Y * $FACTOR_Y + $Y_OFFSET" | bc -l | awk '{ print int($1 + 0.5) }')"

		echo "Transforming $sector from $ORIG_X:$ORIG_Y to $NEW_X:$NEW_Y"

		echo "$NEW_X,$NEW_Y" > "$sector/mainMapPos.txt"
	fi
done

