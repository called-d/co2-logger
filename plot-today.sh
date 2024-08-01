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

  while (1) {
    plot '${data}' using (\$1+(9*3600)):2 axis x1y1 with lines title "co2"
    replot '${data}' using (\$1+(9*3600)):3 axis x1y2 with lines title "temperature"
    pause 30
  }
EOF
