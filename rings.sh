#!/bin/bash

RING_WIDTH=25
RING_BORDER=3

LIGHT_COLOURS=("green3" "DeepSkyBlue1" "maroon2")
DARK_COLOURS=("DarkGreen" "DeepSkyBlue4" "DeepPink4")

TYPES=("Steps" "Intensity Mins." "Active Cals.")
GOALS=(5000 30 500)
PROGRESS=($1 $2 $3)

cmd=""

ring () {
	offset=$1
	progress=${PROGRESS[$offset]}
	goal=${GOALS[$offset]}
	pct=$(($progress * 100 / $goal))
	light_colour=${LIGHT_COLOURS[$offset]}
	dark_colour=${DARK_COLOURS[$offset]}
	angle=$((270 + (360 * $pct / 100)))
	p0=$((50 + $offset * ($RING_WIDTH + $RING_BORDER)))
	p1=$((300 - $offset * ($RING_WIDTH + $RING_BORDER)))
	cmd="$cmd -stroke $dark_colour -strokewidth $RING_WIDTH -fill none -draw \"arc $p0,$p0 $p1,$p1 270,630\""
	cmd="$cmd -stroke $light_colour -strokewidth $RING_WIDTH -fill none -draw \"arc $p0,$p0 $p1,$p1 270,$angle\""
}

ring 0
ring 1
ring 2

cmd="convert -size 350x350 xc:black $cmd rings.png"

bash -c "$cmd"



cmd="rings.png -background black -extent 350x420+0-15"

text () {
	offset=$1
	progress=${PROGRESS[$offset]}
	goal=${GOALS[$offset]}
	type=${TYPES[$offset]}
	light_colour=${LIGHT_COLOURS[$offset]}
	p0=$((25 + 110*$offset))
	p1=375
	cmd="$cmd -font helvetica -fill $light_colour -pointsize 14 -draw \"text $p0,$p1 '$type'\""
	p1=400
	cmd="$cmd -font helvetica -fill white -pointsize 14 -draw \"text $p0,$p1 '$progress / $goal'\""
}

date=`date -d yesterday +"%d %b"`
cmd="$cmd -font helvetica -fill white -pointsize 14 -draw \"text 10,25 'Dave Health - $date'\""

text 0
text 1
text 2

cmd="convert $cmd rings_with_text.png"

bash -c "$cmd"
