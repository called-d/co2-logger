#!/bin/bash

data="logs/$(date +%F)"
gnuplot << EOF
  set term x11 size 1300,600
  set title "${data} co2 and temperature"

  set xdata time
  set timefmt "%s"
  set format x "%H:%M"
  set xtics 3600

  set y2tics

  set label at graph 0.01,first 400 front 'auto calibration'
  set arrow from graph 0,first 400 to graph 1,first 400 nohead lc rgb "gray"
  set arrow from graph 0,first 800 to graph 1,first 800 nohead lc rgb "gold"
  set arrow from graph 0,first 1200 to graph 1,first 1200 nohead lc rgb "red"

  set label at graph 1,second 28 right front '28 degrees Celsius' tc "red"
  set arrow from graph 0,second 28 to graph 1,second 28 nohead lc rgb "red" dt '-'

  while (1) {
    plot '${data}' using (\$1+(9*3600)):2 axis x1y1 with lines linewidth 2 title "co2"
    replot '${data}' using (\$1+(9*3600)):3 axis x1y2 with lines title "temperature"
    pause 30
  }
EOF
