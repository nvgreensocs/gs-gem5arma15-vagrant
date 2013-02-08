
-- run the scenario:
-- ./A15_testbench --lua-config ../scenarios/A15_testbench.lua


clk1="1 ns" -- 834 ps for 1.2GHz
clk1_arm="1 ns" -- 834 ps for 1.2GHz

A15={}
A15.debug_flags="Exec" -- Exec,BusAddrRanges"--Bus,Fetch,Exec"--Bus,BusBridge"
A15.num_cores=2
A15.clk1_arm = "1 ns"

--Scenarios

--Tasks.test.Task1.kernel="/data/wisap/aromana/bench/arm/edison/stream.arm"
--Tasks.test.Task1.kernel="/data/wisap/aromana/clearcase_view/aromana_1.4_TLM_view/vobs/civTLM/scenarios/benchmarks/edison/ericsson/test_check_on.out"
--Tasks.test.Task1.kernel="/data/wisap/aromana/clearcase_view/aromana_1.4_TLM_view/vobs/civTLM/scenarios/benchmarks/edison/bm_core_nerios_edison.arm"
--Tasks.test.Task1.kernel="/data/wisap/ebis/work/work/BenchSuite/Ericsson/eval_96_obf/ctrl_code/sched_rbs/verif/test_check_on.out"

--Tasks.test.Task1.kernel="/data/wisap/aromana/bench/generic_benchmarks/lm_lat_mem_rd/lm_lat_mem_rd_nerios_edison.arm"
A15.kernel="../arm_binaries/stream.arm"
--Tasks.test.Task1.kernel="/data/wisap/aromana/bench/generic_benchmarks/stream/stream_nerios_edison.arm"

--Tasks.test.Task1.kernel="/data/wisap/ebis/work/work/cibu/generic_benchmarks/lm_lat_mem_rd/lm_lat_mem_rd_nerios_edison.arm"

--Tasks.test.Task1.kernel="/data/wisap/aromana/bench/arm/sandbox/test_nerios.arm"
--Tasks.test.Task1.kernel="/data/wisap/aromana/bench/arm/sandbox/nerios_test.arm"
--Tasks.test.Task1.kernel="/data/wisap/ebis/work/work/omap-benchmarks/bin/omap5430_BM/nbench.elf"
--Tasks.test.Task1.kernel="/data/wisap/ebis/work/work/cibu/generic_benchmarks/lm_.../"
--Tasks.test.Task1.kernel="/data/wisap/ebis/work/work/cibu/generic_benchmarks/test_float/"

