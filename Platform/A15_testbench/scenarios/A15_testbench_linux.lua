
-- run the scenario:
-- ./A15_testbench --lua-config ../scenarios/A15_testbench_linux.lua


clk1="1 ns" 
clk1_arm="1 ns" 

A15={}
A15.debug_flags="" -- Exec,BusAddrRanges"--Bus,Fetch,Exec"--Bus,BusBridge"
A15.num_cores=1
A15.clk1_arm = "1 ns"

A15.gem5_uart_addr=true
A15.system_config="linux"
A15.linux_boot_loader="../scripts/binaries/boot.arm"
A15.linux_kernel="../scripts/binaries/vmlinux.arm.smp.fb.2.6.38.8"
A15.linux_disk_image="../scripts/binaries/linux-arm-ael.img"
