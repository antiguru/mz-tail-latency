MAKEFLAGS += --no-builtin-rules

.PHONY: all raw ccdfs
.SUFFIXES:
.PRECIOUS: results/dbbench_%.csv

all: raw ccfds

dbbench/dbbench:
	cd dbbench && go build

results:
	mkdir -p results

results/dbbench_%.csv: experiments/dbbench_%.ini dbbench/dbbench
	@dbbench/dbbench \
    -host "${HOST}" \
    -port "${PORT}" \
    -username "${USER}" \
    -password "${PASSWORD}" \
    -database "${DATABASE}" \
    -driver postgres \
    -params "sslmode=${SSLMODE}&cluster=${CLUSTER}&transaction_isolation=serializable" \
    -force-pre-auth \
    -max-active-conns 1024 \
    -query-stats-file $@ \
    $<

results/ccdf_%.csv: results/dbbench_%.csv
	awk -F, '{print $$3}' $< \
        | sort -n \
        | uniq --count \
        | awk 'BEGIN{sum=0}{print $$2,$$1,sum; sum=sum+$$1}' \
        > $@

results/timeline_%.pdf: results/dbbench_%.csv
	gnuplot -e "input='$<'" -e "output='$@'" -e "terminal='pdf'" timeline.gnuplot

results/ccdf_%.pdf: results/ccdf_%.csv
	gnuplot -e "input='$<'" -e "output='$@'" -e "terminal='pdf'" ccdf.gnuplot

results/ccdfs.pdf: $(foreach rate,$(RATES),results/ccdf_$(rate).csv)
	gnuplot -e "input='$^'" -e "output='$@'" -e "terminal='pdf'" ccdf.gnuplot

ccdfs: raw results/ccdfs.pdf
