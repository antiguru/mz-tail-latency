
class Scenario:
    def __init__(self, query, rate, duration):
        self.query = query
        self.rate = rate
        self.duration = duration

    def dbbench(self):
        return f"""
duration = {self.duration}s

[setup]
query=create view if not exists test2 as select generate_series as x from generate_series(1, 100)
query=create view if not exists tempview1 as select * from test2 where x % 2 = 1
query=create default index on tempview1

[teardown]
# query=drop view tempview1 cascade
query=drop view test2 cascade

[loadtest]
# query=select * from tempview1
# query=select count(*) from tempview1
query={self.query}
rate={self.rate}
# concurrency=64
start=5s
"""


def generate():
    samples = 100000

    with open("Makefile", "w") as m:

        m.write("""
include ${ENV}
RATES :=
""")

        for rate in [64, 128, 256, 512]:
            duration = int(samples / rate)
            experiment = f"experiments/dbbench_{rate}.ini"
            s = Scenario("select * from tempview1", rate, duration)
            with open(experiment, "w") as f:
                f.write(s.dbbench())

            m.write(f"""
RATES += {rate}
raw: results/dbbench_{rate}.csv
ccdfs: results/ccdf_{rate}.csv
""")
        m.write("include rules.mk\n")


if __name__ == "__main__":
    generate()
