
#!/bin/bash

iverilog picorv32.v al_ip/mem_hi_sim.v al_ip/mem_mh_sim.v al_ip/mem_ml_sim.v al_ip/mem_lo_sim.v al_ip/regfile_dp_sim.v al_sim/al_logic_bram.v al_sim/al_phy_bram.v al_sim/al_phy_glbl.v ./al_sim/al_logic_dram16x4.v ./al_sim/al_phy_mslice.v ./al_sim/al_phy_lslice.v ./al_sim/al_phy_dff.v top.v tb.v -o tb
