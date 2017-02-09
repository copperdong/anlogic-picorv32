#!/bin/bash

iverilog picorv32_presyn.v bram_register.v isa_test.v tb.v -o tb
