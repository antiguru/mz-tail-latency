set output output
set terminal terminal

do for [file in input] {
  stats file using 3 nooutput
}

set grid

#set format x "%.0e"
#set format x "10^{%T}"
set logscale x
set xtics add (50, 60, 70, 80, 90, 150, 200, 300)
set mxtics 10
set xlabel 'latency [ms]'

set format y "10^{%T}"
set logscale y
set ylabel 'CCDF'

set key noenhanced

plot for [file in input] file using ($1/1000):(1-$3/STATS_max)  with lines title file
