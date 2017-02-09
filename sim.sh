#!/bin/bash

iverilog picorv32.v al_ip/mem_hi_sim.v al_ip/mem_mh_sim.v al_ip/mem_ml_sim.v al_ip/mem_lo_sim.v al_sim/al_logic_bram.v al_sim/al_phy_bram.v al_sim/al_phy_glbl.v top.v tb.v -o tb
