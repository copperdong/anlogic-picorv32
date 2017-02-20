# anlogic-picorv32
Optimized picorv32 core for anlogic FPGA.

RV32IMC Toolchain for Windows download: 

https://pan.baidu.com/s/1kUAfWsZ

NSIS-Packaged version:

http://pan.baidu.com/s/1o7SY4Gi

Required Resources
--------

On Anlogic AL3 FPGA, it can be configured as RV32I processor while it requires 1.8K LUTs. 

If it configured as RV32IC processor, then it needs 2.3K LUTs or less. You can also choose bram-dev branch to use BRAM as register file.

It requires 4-M9K BRAM at least, which provides it's program memory and data memory, you can also use M32K to replace it.

It contains a simple bus. You needn't any bus-matrix to connect it's I and D port. Although it is not very powerful, but if it compares to 8051, it's powerful enough.

When it configured as a RV32IC processor, it can run up to 73MHz on AL3 FPGA. And we're optimizing for more speed.
