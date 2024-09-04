
include ${ENV}
RATES :=

RATES += 64
raw: results/dbbench_64.csv
ccdfs: results/ccdf_64.csv

RATES += 128
raw: results/dbbench_128.csv
ccdfs: results/ccdf_128.csv

RATES += 256
raw: results/dbbench_256.csv
ccdfs: results/ccdf_256.csv

RATES += 512
raw: results/dbbench_512.csv
ccdfs: results/ccdf_512.csv
include rules.mk
