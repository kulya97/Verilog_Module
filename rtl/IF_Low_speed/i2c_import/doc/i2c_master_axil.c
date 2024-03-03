#include "sleep.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xuartps.h"
#include <stdio.h>
#include <xil_io.h>
#define IIC_STATUS 0x40000000
#define IIC_COMMAND 0x40000004
#define IIC_DATA 0x40000008
#define IIC_PRE 0x4000000c

XUartPs Uart_Ps_0; /* The instance of the UART Driver */
#define	XUARTPS_BASEADDRESS		XPAR_XUARTPS_0_BASEADDR
int UART_init() {
  XUartPs_Config *Config;
  int Status;

  Config = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
  Status = XUartPs_CfgInitialize(&Uart_Ps_0, Config, Config->BaseAddress);
  XUartPs_SetBaudRate(&Uart_Ps_0, 115200);

  return Status;
}
int main(void) {
  UART_init();
  printf("6666666");
  //设置 iic时钟分频系数
  Xil_Out32(IIC_PRE, 0x00000100);
  //
  Xil_Out32(IIC_DATA, 0x00000000);
  Xil_Out32(IIC_DATA, 0x00000004);
  Xil_Out32(IIC_DATA, 0x00000011);
  Xil_Out32(IIC_DATA, 0x00000022);
  Xil_Out32(IIC_DATA, 0x00000033);
  Xil_Out32(IIC_DATA, 0x00000044);
  //
  Xil_Out32(IIC_COMMAND, 0x00000550);
  Xil_Out32(IIC_COMMAND, 0x00000450);
  Xil_Out32(IIC_COMMAND, 0x00000450);
  Xil_Out32(IIC_COMMAND, 0x00000450);
  Xil_Out32(IIC_COMMAND, 0x00000450);
  Xil_Out32(IIC_COMMAND, 0x00000450);
  Xil_Out32(IIC_COMMAND, 0x00001050);
  while (1) {
    Xil_Out32(IIC_DATA, 0x00000000);
    Xil_Out32(IIC_DATA, 0x00000004);
    Xil_Out32(IIC_DATA, 0x00000011);
    Xil_Out32(IIC_DATA, 0x00000022);
    Xil_Out32(IIC_DATA, 0x00000033);
    Xil_Out32(IIC_DATA, 0x00000044);
    //
    Xil_Out32(IIC_COMMAND, 0x00000550);
    Xil_Out32(IIC_COMMAND, 0x00000450);
    Xil_Out32(IIC_COMMAND, 0x00000450);
    Xil_Out32(IIC_COMMAND, 0x00000450);
    Xil_Out32(IIC_COMMAND, 0x00000450);
    Xil_Out32(IIC_COMMAND, 0x00000450);
    Xil_Out32(IIC_COMMAND, 0x00001050);
    usleep(1);
  }
}