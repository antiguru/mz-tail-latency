set title 'query latency scatter'
set xlabel 'time [s]'
set ylabel 'latency [ms]'
set yrange [30:]
set logscale y
set grid
set datafile separator ','
plot input using 2:($3/1000) with dots
set xrange [GPVAL_DATA_X_MIN/1000000:GPVAL_DATA_X_MAX/1000000+30]
plot input using ($2/1000000):($3/1000) with dots
