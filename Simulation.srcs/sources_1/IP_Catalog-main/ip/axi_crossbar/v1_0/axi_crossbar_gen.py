#!/usr/bin/env python3
#
# This file is Copyright (c) 2022 RapidSilicon.
#
# SPDX-License-Identifier: MIT

import os
import sys
import logging
import argparse
import math

from datetime import datetime

from litex_wrapper.axi_crossbar_litex_wrapper import AXICROSSBAR

from migen import *

from litex.build.generic_platform import *

from litex.build.osfpga import OSFPGAPlatform

from litex.soc.interconnect.axi import AXIInterface


# IOs/Interfaces -----------------------------------------------------------------------------------
def get_clkin_ios():
    return [
        ("clk",  0, Pins(1)),
        ("rst",  0, Pins(1))
    ]

# AXI CROSSBAR Wrapper ----------------------------------------------------------------------------------
class AXICROSSBARWrapper(Module):
    def __init__(self, platform, m_count, s_count ,data_width, addr_width, s_id_width, aw_user_width, w_user_width, b_user_width, ar_user_width, r_user_width,
                aw_user_en, w_user_en, b_user_en, ar_user_en, r_user_en):
        
        # Clocking ---------------------------------------------------------------------------------
        platform.add_extension(get_clkin_ios())
        self.clock_domains.cd_sys  = ClockDomain()
        self.comb += self.cd_sys.clk.eq(platform.request("clk"))
        self.comb += self.cd_sys.rst.eq(platform.request("rst"))

        # Slave Interfaces
        s_axis = []
        for si_count in range(s_count):
            s_axi = AXIInterface(data_width = data_width , address_width = addr_width, id_width = s_id_width, aw_user_width = aw_user_width,
            w_user_width = w_user_width, b_user_width = b_user_width, ar_user_width = ar_user_width, r_user_width = r_user_width)
            if si_count>9:
                platform.add_extension(s_axi.get_ios("s{}_axi".format(si_count)))
                self.comb += s_axi.connect_to_pads(platform.request("s{}_axi".format(si_count)), mode="slave")
            else:
                platform.add_extension(s_axi.get_ios("s0{}_axi".format(si_count)))
                self.comb += s_axi.connect_to_pads(platform.request("s0{}_axi".format(si_count)), mode="slave")
                
            s_axis.append(s_axi)
        
        # Master Interfaces 
        if s_count<2:
            m_id_width = s_id_width
        else:
            m_id_width = (s_id_width+(math.ceil(math.log2(s_count)))) 
            
        m_axis = []  
        for m_count in range(m_count):
            m_axi = AXIInterface(data_width = data_width , address_width = addr_width, id_width = m_id_width, aw_user_width = aw_user_width,
            w_user_width = w_user_width, b_user_width = b_user_width, ar_user_width = ar_user_width, r_user_width = r_user_width)
            if m_count>9:
                platform.add_extension(m_axi.get_ios("m{}_axi".format(m_count)))
                self.comb += m_axi.connect_to_pads(platform.request("m{}_axi".format(m_count)), mode="master")
            else:
                platform.add_extension(m_axi.get_ios("m0{}_axi".format(m_count)))
                self.comb += m_axi.connect_to_pads(platform.request("m0{}_axi".format(m_count)), mode="master")
            
            m_axis.append(m_axi)
            
        # AXI CROSSBAR
        self.submodules.axi_crossbar = AXICROSSBAR(platform,
            s_axi               = s_axis,
            m_axi               = m_axis,
            s_count             = s_count,
            m_count             = m_count,
            aw_user_en          = aw_user_en,
            w_user_en           = w_user_en,
            b_user_en           = b_user_en,
            ar_user_en          = ar_user_en,
            r_user_en           = r_user_en
            )

# Build --------------------------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="AXI CROSSBAR CORE")

    # Import Common Modules.
    common_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", "lib")
    sys.path.append(common_path)

    from common import IP_Builder

    # Parameter Dependency dictionary
    dep_dict = {
                "aw_user_width"   :   "aw_user_en",   
                "w_user_width"    :   "w_user_en",   
                "b_user_width"    :   "b_user_en",   
                "ar_user_width"   :   "ar_user_en",   
                "r_user_width"    :   "r_user_en"
    }            

    # IP Builder.
    rs_builder = IP_Builder(device="gemini", ip_name="axi_crossbar", language="verilog")

    logging.info("===================================================")
    logging.info("IP    : %s", rs_builder.ip_name.upper())
    logging.info(("==================================================="))

    # Core fix value parameters.
    core_fix_param_group = parser.add_argument_group(title="Core fix parameters")
    core_fix_param_group.add_argument("--data_width",    type=int,      default=32,     choices=[8, 16, 32, 64, 128, 256],  help="AXI Data Width.")
    core_fix_param_group.add_argument("--addr_width",    type=int,      default=32,     choices=[32, 64],                   help="AXI Address Width.")

     # Core range value parameters.
    core_range_param_group = parser.add_argument_group(title="Core range parameters")
    core_range_param_group.add_argument("--m_count",            type=int,       default=4,      choices=range(2,17),         help="Crossbar Master Interfaces.")
    core_range_param_group.add_argument("--s_count",            type=int,       default=4,      choices=range(1,17),         help="Crossbar SLAVE Interfaces.")
    core_range_param_group.add_argument("--s_id_width",         type=int,       default=8,      choices=range(1, 9),         help="AXI SLAVE ID Width.")
    core_range_param_group.add_argument("--aw_user_width",      type=int,       default=1,      choices=range(1, 1025),      help="AW-Channel User Width.")
    core_range_param_group.add_argument("--w_user_width",       type=int,       default=1,      choices=range(1, 1025),      help="W-Channel User Width.")
    core_range_param_group.add_argument("--b_user_width",       type=int,       default=1,      choices=range(1, 1025),      help="B-Channel User Width.")
    core_range_param_group.add_argument("--ar_user_width",      type=int,       default=1,      choices=range(1, 1025),      help="AR-Channel User Width.")
    core_range_param_group.add_argument("--r_user_width",       type=int,       default=1,      choices=range(1, 1025),      help="R-Channel User Width.")

    # Core bool value parameters.
    core_bool_param_group = parser.add_argument_group(title="Core bool parameters")
    core_bool_param_group.add_argument("--aw_user_en",    type=bool,    default=True,      help="AW-Channel User Enable.")
    core_bool_param_group.add_argument("--w_user_en",     type=bool,    default=False,     help="W-Channel User Enable.")
    core_bool_param_group.add_argument("--b_user_en",     type=bool,    default=False,     help="B-Channel User Enable.")
    core_bool_param_group.add_argument("--ar_user_en",    type=bool,    default=True,      help="AR-Channel User Enable.")
    core_bool_param_group.add_argument("--r_user_en",     type=bool,    default=False,     help="R-Channel User Enable.")


    # Build Parameters.
    build_group = parser.add_argument_group(title="Build parameters")
    build_group.add_argument("--build",         action="store_true",                help="Build Core")
    build_group.add_argument("--build-dir",     default="./",                       help="Build Directory")
    build_group.add_argument("--build-name",    default="axi_crossbar_wrapper",     help="Build Folder Name, Build RTL File Name and Module Name")

    # JSON Import/Template
    json_group = parser.add_argument_group(title="JSON Parameters")
    json_group.add_argument("--json",                                           help="Generate Core from JSON File")
    json_group.add_argument("--json-template",  action="store_true",            help="Generate JSON Template")

    args = parser.parse_args()
    details =  {   "IP details": {
    'Name' : 'AXI Crossbar',
    'Version' : 'V1_0',
    'Interface' : 'AXI4 ',
    'Description' : 'The AXI4 Full Crossbar is AXI4 compliance IP core that connects one or more AXI memory mapped master devices to more memory mapped slave devices. Supports all burst types.Fully nonblocking with completely separate read and write paths; ID-based transaction ordering protection logic; and per-port address decode and decode error handling.'}
    }
    # Import JSON (Optional) -----------------------------------------------------------------------
    if args.json:
        args = rs_builder.import_args_from_json(parser=parser, json_filename=args.json)
        rs_builder.import_ip_details_json(build_dir=args.build_dir ,details=details , build_name = args.build_name, version = "v1_0")
        
    summary =  { 
    # "DATA WIDTH": args.data_width,
    "MASTER COUNT":args.m_count,
    "SLAVE COUNT": args.s_count,
    # "PIPELINE OUTPUT": args.pip_out
    }
    # Export JSON Template (Optional) --------------------------------------------------------------
    if args.json_template:
        rs_builder.export_json_template(parser=parser, dep_dict=dep_dict, summary=summary)


    # Create Wrapper -------------------------------------------------------------------------------
    platform = OSFPGAPlatform(io=[], toolchain="raptor", device="gemini")
    module   = AXICROSSBARWrapper(platform,
        m_count       = args.m_count,
        s_count       = args.s_count,
        data_width    = args.data_width,
        addr_width    = args.addr_width,
        s_id_width    = args.s_id_width,
        aw_user_en    = args.aw_user_en,
        aw_user_width = args.aw_user_width,
        w_user_en     = args.w_user_en,
        w_user_width  = args.w_user_width,
        b_user_en     = args.b_user_en,
        b_user_width  = args.b_user_width,
        ar_user_en    = args.ar_user_en,
        ar_user_width = args.ar_user_width,
        r_user_en     = args.r_user_en,
        r_user_width  = args.r_user_width,
    )

    # Build Project --------------------------------------------------------------------------------
    if args.build:
        rs_builder.prepare(
            build_dir  = args.build_dir,
            build_name = args.build_name,
            version    = "v1_0"
        )
        rs_builder.copy_files(gen_path=os.path.dirname(__file__))
        rs_builder.generate_tcl(version    = "v1_0")
        rs_builder.generate_wrapper(
            platform   = platform,
            module     = module,
            version = "v1_0"
        )
        
        # IP_ID Parameter
        now = datetime.now()
        my_year         = now.year - 2022
        year            = (bin(my_year)[2:]).zfill(7) # 7-bits  # Removing '0b' prefix = [2:]
        month           = (bin(now.month)[2:]).zfill(4) # 4-bits
        day             = (bin(now.day)[2:]).zfill(5) # 5-bits
        mod_hour        = now.hour % 12 # 12 hours Format
        hour            = (bin(mod_hour)[2:]).zfill(4) # 4-bits
        minute          = (bin(now.minute)[2:]).zfill(6) # 6-bits
        second          = (bin(now.second)[2:]).zfill(6) # 6-bits
        
        # Concatenation for IP_ID Parameter
        ip_id = ("{}{}{}{}{}{}").format(year, day, month, hour, minute, second)
        ip_id = ("32'h{}").format(hex(int(ip_id,2))[2:])
        
        # IP_VERSION parameter
        #               Base  _  Major _ Minor
        ip_version = "00000000_00000000_0000000000000001"
        ip_version = ("32'h{}").format(hex(int(ip_version, 2))[2:])
        
        wrapper = os.path.join(args.build_dir, "rapidsilicon", "ip", "axi_crossbar", "v1_0", args.build_name, "src",args.build_name + "_" + "v1_0" + ".v")
        new_lines = []
        with open (wrapper, "r") as file:
            lines = file.readlines()
            for i, line in enumerate(lines):
                if ("module {}".format(args.build_name)) in line:
                    new_lines.append("module {} #(\n\tparameter IP_TYPE \t\t= \"CRSSBAR1\",\n\tparameter IP_VERSION \t= {}, \n\tparameter IP_ID \t\t= {}\n)\n(".format(args.build_name, ip_version, ip_id))
                else:
                    new_lines.append(line)
                
        with open(os.path.join(wrapper), "w") as file:
            file.writelines(new_lines)

if __name__ == "__main__":
    main()
