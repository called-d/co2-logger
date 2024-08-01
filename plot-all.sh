#!/bin/bash

file="$(mktemp /tmp/plot-all.XXXXXX)"
cat logs/*-*-* > "$file"
gnuplot << EOF
  set term x11 size 1300,600
  set title "co2 and temperature | all"

  set xdata time
  set timefmt "%s"
  set format x "%Y-%m-%d %H"
  set xtics 86400

  set y2tics

  set label at graph 0.01,first 400 front 'auto calibration'
  set arrow from graph 0,first 400 to graph 1,first 400 nohead lc rgb "gray"
  set arrow from graph 0,first 800 to graph 1,first 800 nohead lc rgb "gold"
  set arrow from graph 0,first 1200 to graph 1,first 1200 nohead lc rgb "red"

  set label at graph 1,second 28 right front '28 degrees Celsius' tc "red"
  set arrow from graph 0,second 28 to graph 1,second 28 nohead lc rgb "red" dt '-'

  plot '${file}' using (\$1+(9*3600)):2 axis x1y1 with lines linewidth 2 title "co2"
  replot '${file}' using (\$1+(9*3600)):3 axis x1y2 with lines title "temperature"

  pause mouse close
EOF
rm "$file"
