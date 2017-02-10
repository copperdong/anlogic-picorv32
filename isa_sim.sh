#!/bin/bash

#iverilog picorv32.v isa_test.v tb.v al_ip/regfile_dp_sim.v ./al_sim/al_logic_dram16x4.v ./al_sim/al_phy_mslice.v ./al_sim/al_phy_lslice.v ./al_sim/al_phy_dff.v al_sim/al_phy_glbl.v -o tb
iverilog picorv32.v isa_test.v tb.v -o tb
#iverilog  dram_tb.v al_ip/regfile_dp_sim.v ./al_sim/al_logic_dram16x4.v ./al_sim/al_phy_mslice.v ./al_sim/al_phy_lslice.v ./al_sim/al_phy_dff.v al_sim/al_phy_glbl.v -o tb
