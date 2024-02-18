#
# This file is part of RapidSilicon's IP_Catalog.
#
# This file is Copyright (c) 2022 RapidSilicon.
#
# SPDX-License-Identifier: MIT
#


import os
import datetime
import logging

from migen import *

from litex.soc.interconnect.axi import *

# logging.basicConfig(level=logging.INFO)
logging.basicConfig(filename="IP.log",filemode="w", level=logging.INFO, format='%(levelname)s: %(message)s\n')

timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
logging.info(f'Log started at {timestamp}')

# Helpers ------------------------------------------------------------------------------------------

def freq_calc(self, fast_clk_freq, ref_clk_freq, c_range, d_range):
    self.product = Signal()
    self.ready = Signal()
    a = fast_clk_freq
    b = ref_clk_freq
    c_range = 1000
    d_range = 63
    # Nested loop for iterating over c and d
    for c in range(c_range):
        for d in range(d_range):
            # Calculate 2 * (a / b)
            product_candidate = 2 * (a/ b)
            # Check if the candidate product matches the formula with c and d
            if product_candidate == ((c+1) / (d+1)):
                # If a match is found, assign c, d, and the product to the respective signals
                pll_mult = c + 1
                pll_div  = d + 1
                return pll_mult, pll_div
        #break                    

    
class Open(Signal): pass

def colorer(s, color="bright"):
    header  = {
        "bright": "\x1b[1m",
        "green":  "\x1b[32m",
        "cyan":   "\x1b[36m",
        "red":    "\x1b[31m",
        "yellow": "\x1b[33m",
        "underline": "\x1b[4m"}[color]
    trailer = "\x1b[0m"
    return header + str(s) + trailer

# PLL Wrapper ------------------------------------------------------------------------------------

class PLL(Module):
    def __init__(self, platform, divide_clk_in_by_2, fast_clk_freq, ref_clk_freq, pll_post_div, **kwargs):
        self.logger = logging.getLogger("PLL")
        self.logger.propagate = True

        
        # Logger
        self.logger = logging.getLogger("PLL")
        
        self.logger.propagate = True
        
        self.logger.info(f"=================== PARAMETERS ====================")
        
        self.logger.info(f"DIVIDE_CLK_IN_BY_2   : {divide_clk_in_by_2}")
#        self.logger.info(f"PLL_MULT             : {pll_mult}")
#        self.logger.info(f"PLL_DIV              : {pll_div}")
#        self.logger.info(f"CLK_OUT0_DIV         : {clk_div_1}")
#        self.logger.info(f"CLK_OUT1_DIV         : {clk_div_2}")
#        self.logger.info(f"CLK_OUT2_DIV         : {clk_div_3}")
#        self.logger.info(f"CLK_OUT3_DIV         : {clk_div_4}")        
        self.logger.info(f"===================================================")
        
        # Create input/output signals
        self.PLL_EN = Signal()
        self.CLK_IN = Signal()
        self.CLK_OUT = Signal()
        self.CLK_OUT_DIV2 = Signal()
        self.CLK_OUT_DIV3 = Signal()
        self.CLK_OUT_DIV4 = Signal()
        self.SERDES_FAST_CLK = Signal()
        self.LOCK = Signal()

        pll_mult, pll_div = freq_calc(self, fast_clk_freq, ref_clk_freq, c_range=63, d_range=1000)

        if (divide_clk_in_by_2 == 1):
            divide_by_2 = "TRUE"
        else:
            divide_by_2 = "FALSE"

        self.specials += Instance("PLL",
                    **kwargs,
                    p_DIVIDE_CLK_IN_BY_2    = (divide_by_2),
                    p_PLL_MULT              = Instance.PreformattedParam(pll_mult),
                    p_PLL_DIV               = Instance.PreformattedParam(pll_div),
                    p_PLL_POST_DIV          = Instance.PreformattedParam(pll_post_div),

                    i_PLL_EN                = 1,
                    i_CLK_IN                = self.CLK_IN,
                    o_CLK_OUT               = self.CLK_OUT,
                    o_CLK_OUT_DIV2          = self.CLK_OUT_DIV2,
                    o_CLK_OUT_DIV3          = self.CLK_OUT_DIV3,
                    o_CLK_OUT_DIV4          = self.CLK_OUT_DIV4,
                    o_SERDES_FAST_CLK       = self.SERDES_FAST_CLK,
                    o_LOCK                  = self.LOCK
                )
#        elif clk_div_2 == True:
#            self.specials += Instance("PLL",
#                    **kwargs,
#                    p_DIVIDE_CLK_IN_BY_2    = Instance.PreformattedParam(divide_clk_in_by_2),
#                    p_PLL_MULT              = Instance.PreformattedParam(pll_mult),
#                    p_PLL_DIV               = Instance.PreformattedParam(pll_div),
#                    p_CLK_OUT0_DIV          = Instance.PreformattedParam(1),
#                    p_CLK_OUT1_DIV          = Instance.PreformattedParam(2),
#                    p_CLK_OUT2_DIV          = Instance.PreformattedParam(3),
#                    p_CLK_OUT3_DIV          = Instance.PreformattedParam(4),
#
#                    i_PLL_EN                = 1,
#                    i_CLK_IN                = self.CLK_IN,
#                    i_CLK_OUT0_EN           = 1,
#                    i_CLK_OUT1_EN           = 1,
#                    i_CLK_OUT2_EN           = 0,
#                    i_CLK_OUT3_EN           = 0,
#                    o_CLK_OUT0              = self.CLK_OUT0,
#                    o_CLK_OUT1              = self.CLK_OUT1,
#                    o_GEARBOX_FAST_CLK      = self.GEARBOX_FAST_CLK,
#                    o_LOCK                  = self.LOCK
#                )
#
#        elif clk_div_3 == True:
#            self.specials += Instance("PLL",
#                    **kwargs,
#                    p_DIVIDE_CLK_IN_BY_2    = Instance.PreformattedParam(divide_clk_in_by_2),
#                    p_PLL_MULT              = Instance.PreformattedParam(pll_mult),
#                    p_PLL_DIV               = Instance.PreformattedParam(pll_div),
#                    p_CLK_OUT0_DIV          = Instance.PreformattedParam(1),
#                    p_CLK_OUT1_DIV          = Instance.PreformattedParam(2),
#                    p_CLK_OUT2_DIV          = Instance.PreformattedParam(3),
#                    p_CLK_OUT3_DIV          = Instance.PreformattedParam(34),
#
#                    i_PLL_EN                = 1,
#                    i_CLK_IN                = self.CLK_IN,
#                    i_CLK_OUT0_EN           = 1,
#                    i_CLK_OUT1_EN           = 1,
#                    i_CLK_OUT2_EN           = 1,
#                    i_CLK_OUT3_EN           = 0,
#                    o_CLK_OUT0              = self.CLK_OUT0,
#                    o_CLK_OUT1              = self.CLK_OUT1,
#                    o_CLK_OUT2              = self.CLK_OUT2,
#                    o_GEARBOX_FAST_CLK      = self.GEARBOX_FAST_CLK,
#                    o_LOCK                  = self.LOCK
#                )
#
#        elif clk_div_4 == True:
#            self.specials += Instance("PLL",
#                    **kwargs,
#                    p_DIVIDE_CLK_IN_BY_2    = Instance.PreformattedParam(divide_clk_in_by_2),
#                    p_PLL_MULT              = Instance.PreformattedParam(pll_mult),
#                    p_PLL_DIV               = Instance.PreformattedParam(pll_div),
#                    p_CLK_OUT0_DIV          = Instance.PreformattedParam(1),
#                    p_CLK_OUT1_DIV          = Instance.PreformattedParam(2),
#                    p_CLK_OUT2_DIV          = Instance.PreformattedParam(3),
#                    p_CLK_OUT3_DIV          = Instance.PreformattedParam(4),
#
#                    i_PLL_EN                = 1,
#                    i_CLK_IN                = self.CLK_IN,
#                    i_CLK_OUT0_EN           = 1,
#                    i_CLK_OUT1_EN           = 1,
#                    i_CLK_OUT2_EN           = 1,
#                    i_CLK_OUT3_EN           = 1,
#                    o_CLK_OUT0              = self.CLK_OUT0,
#                    o_CLK_OUT1              = self.CLK_OUT1,
#                    o_CLK_OUT2              = self.CLK_OUT2,
#                    o_CLK_OUT3              = self.CLK_OUT3,
#                    o_GEARBOX_FAST_CLK      = self.GEARBOX_FAST_CLK,
#                    o_LOCK                  = self.LOCK
#                )


#        self.add_sources(platform)

#    @staticmethod
#    def add_sources(platform):
#        rtl_dir = os.path.join(os.path.dirname(__file__), "../src")
#        platform.add_source(os.path.join(rtl_dir, "PLL.v"))
