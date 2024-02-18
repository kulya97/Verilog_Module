# AXI-LITE-INTERCONNECT Core Generation 
## Introduction
AXI-LITE-INTERCONNECT is AXI4-Lite based IP core.

For more information, visit: http://alexforencich.com/wiki/en/verilog/axi/start

## Generator Script
This directory contains the generator script which places the RTL to `rapidsilicon/ip/axil_interconnect/v1_0/<build-name>/src` directory and generates its wrapper in the same directory. 

## Parameters
User can configure AXI_LITE_INTERCONNECT CORE using following parameters:

| Sr.No.|     Parameter    |      Keyword        |    Value             |
|-------|------------------|---------------------|-------------         |
|   1.  |   DATA_WIDTH     |     data_width      |  8,16,32,64,128,256  |
|   2.  |   ADDR_WIDTH     |     addr_width      |  32,64,128,256       |
|   3.  |   S_COUNT        |     s_count         |  1-16                |
|   4.  |   M_COUNT        |     m_count         |  1-16                |


To generate RTL with above parameters, run the following command:
```
python3 axil_interconnect_gen.py --data_width=32 --addr_width=64 --s_count=5 --m_count=2 --build-name=interconnect_wrapper --build
```

## TCL File
This python script also generates a raptor.tcl file which will be placed in `rapidsilicon/ip/axil_interconnect/v1_0/<build-name>/synth` directory.


## References
https://github.com/alexforencich/verilog-axi/blob/master/rtl/axil_interconnect.v