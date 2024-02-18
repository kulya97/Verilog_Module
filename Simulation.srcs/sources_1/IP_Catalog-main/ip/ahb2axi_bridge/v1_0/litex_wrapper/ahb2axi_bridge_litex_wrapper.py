#
# This file is part of RapidSilicon's IP_Catalog.
#
# This file is Copyright (c) 2022 RapidSilicon.
#
# SPDX-License-Identifier: MIT
#
# LiteX wrapper around western digital's ahb2axi4.v

import os
import datetime
import logging

from migen import *

from litex.soc.interconnect.axi import *

# logging.basicConfig(level=logging.INFO)
logging.basicConfig(filename="IP.log",filemode="w", level=logging.INFO, format='%(levelname)s: %(message)s\n')

timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
logging.info(f'Log started at {timestamp}')

# AHB_2_AXI4_BRIDGE ---------------------------------------------------------------------------------------
class AHB2AXI4(Module):
    def __init__(self, platform, m_axi):

        # Get Parameters.
        # ---------------------        
        self.logger = logging.getLogger("AHB_2_AXI4")
        
        self.logger.propagate = True

        # Clock Domain.
        # self.logger.info(f"CLOCK_DOMAIN     : {s_ahb.clock_domain}")
        self.logger.info(f"=================== PARAMETERS ====================")
        # Address width.
        address_width = len(m_axi.aw.addr)
        self.logger.info(f"C_AXI_ADDR_WIDTH : {address_width}")

        # Data width.
        data_width = len(m_axi.w.data)
        self.logger.info(f"C_AXI_DATA_WIDTH : {data_width}")

        # ID width.
        id_width = len(m_axi.aw.id)
        self.logger.info(f"C_AXI_ID_WIDTH   : {id_width}")
        
        self.logger.info(f"===================================================")
        
        self.ahb_haddr               = Signal(address_width)
        self.ahb_hburst              = Signal(3)
        self.ahb_hmastlock           = Signal(1)
        self.ahb_hprot               = Signal(4)
        self.ahb_hsize               = Signal(3)
        self.ahb_htrans              = Signal(2)
        self.ahb_hwrite              = Signal(1)
        self.ahb_hwdata              = Signal(data_width)
        self.ahb_hsel                = Signal(1)
        self.ahb_hreadyin            = Signal(1)
        self.ahb_hnonsec             = Signal(1)
        self.ahb_hrdata              = Signal(data_width)
        self.ahb_hreadyout           = Signal(1)
        self.ahb_hresp               = Signal(1)
        
        # Module instance.
        # ----------------
        self.specials += Instance("ahb_to_axi4",
            # Parameters.
            # -----------
            # IP Parameters
            p_IP_TYPE           = Instance.PreformattedParam("IP_TYPE"),
            p_IP_ID             = Instance.PreformattedParam("IP_ID"),
            p_IP_VERSION        = Instance.PreformattedParam("IP_VERSION"),
            # Global AXI
            p_data_width        = Instance.PreformattedParam(data_width),
            p_addr_width        = Instance.PreformattedParam(address_width),
            p_id_width          = Instance.PreformattedParam(id_width),  

            # Clk / Rst.
            i_clk               = ClockSignal(),
            i_rst_l             = ResetSignal(),

            # AHB Slave Interface.
            # --------------------
            
            i_ahb_haddr            		= self.ahb_haddr,
            i_ahb_hburst            	= self.ahb_hburst,
            i_ahb_hmastlock           = self.ahb_hmastlock,
            i_ahb_hprot            		= self.ahb_hprot,
            i_ahb_hsize            		= self.ahb_hsize,
            i_ahb_htrans           		= self.ahb_htrans,
            i_ahb_hwrite           		= self.ahb_hwrite,
            i_ahb_hwdata           		= self.ahb_hwdata, 
            i_ahb_hsel           		  = self.ahb_hsel,
            i_ahb_hreadyin           	= self.ahb_hreadyin,
            i_ahb_hnonsec           	= self.ahb_hnonsec,
            o_ahb_hrdata           		= self.ahb_hrdata,
            o_ahb_hreadyout           = self.ahb_hreadyout,  
            o_ahb_hresp           		= self.ahb_hresp,

            
            
            # AXI master Interface.
            # --------------------
            # AW.
            o_axi_awid            = m_axi.aw.id,
            o_axi_awaddr          = m_axi.aw.addr,
            o_axi_awlen           = m_axi.aw.len,
            o_axi_awsize          = m_axi.aw.size,
            o_axi_awburst         = m_axi.aw.burst,
          #  i_S_AXI_AWLOCK          = m_axi.aw.lock,
          #  i_S_AXI_AWCACHE         = m_axi.aw.cache,
            o_axi_awprot          = m_axi.aw.prot,
          #  i_S_AXI_AWQOS           = m_axi.aw.qos,
            o_axi_awvalid         = m_axi.aw.valid,
            i_axi_awready         = m_axi.aw.ready,

            # W.
            o_axi_wdata           = m_axi.w.data,
            o_axi_wstrb           = m_axi.w.strb,
            o_axi_wlast           = m_axi.w.last,
            o_axi_wvalid          = m_axi.w.valid,
            i_axi_wready          = m_axi.w.ready,

            # B.
            i_axi_bid             = m_axi.b.id,
            i_axi_bresp           = m_axi.b.resp,
            i_axi_bvalid          = m_axi.b.valid,
            o_axi_bready          = m_axi.b.ready,

            # AR.
            o_axi_arid            = m_axi.ar.id,
            o_axi_araddr          = m_axi.ar.addr,
            o_axi_arlen           = m_axi.ar.len,
            o_axi_arsize          = m_axi.ar.size,
            o_axi_arburst         = m_axi.ar.burst,
          #  i_S_AXI_ARLOCK          = m_axi.ar.lock,
          #  i_S_AXI_ARCACHE         = m_axi.ar.cache,
            o_axi_arprot          = m_axi.ar.prot,
          #  i_S_AXI_ARQOS           = m_axi.ar.qos,
            o_axi_arvalid         = m_axi.ar.valid,
            i_axi_arready         = m_axi.ar.ready,

            # R.
            i_axi_rid             = m_axi.r.id,
            i_axi_rdata           = m_axi.r.data,
            i_axi_rresp           = m_axi.r.resp,
          #  o_S_AXI_RLAST           = m_axi.r.last,
            i_axi_rvalid          = m_axi.r.valid,
            o_axi_rready          = m_axi.r.ready,
         
        )

        # Add Sources.
        # ------------
        self.add_sources(platform)

    @staticmethod
    def add_sources(platform):
        rtl_dir = os.path.join(os.path.dirname(__file__), "../src")
        platform.add_source(os.path.join(rtl_dir, "ahb2axi4.sv"))
