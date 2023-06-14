`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Company : Liyang Milian Electronic Technology Co., Ltd.
Brand: 米联客(msxbo)
Technical forum:uisrc.com
taobao: osrc.taobao.com
Create Date: 2019/12/17
Module Name: ui5640reg
Description: 
Configure the ui5640reg register. video format rgb 565
Copyright: Copyright (c) msxbo
Revision: 1.0
Signal description锛?
1) _i input
2) _o output
3) _n activ low
4) _dg debug signal 
5) _r delay or register
6) _s state mechine
*/
////////////////////////////////////////////////////////////////////////////////
module ui5640reg
(
input      [8 :0]  REG_INDEX,
input      [15 :0] CAM_HSIZE,
input      [15 :0] CAM_VSIZE,
output reg [31:0]  REG_DATA,
output     [8 :0]  REG_SIZE  
);




assign	REG_SIZE = 9'd251;

//-----------------------------------------------------------------
/////////////////////	Config Data REG	  //////////////////////////	
always@(*)
begin
	case(REG_INDEX)
	0:       REG_DATA<=24'h310311;   // system clock from pad, bit[1]
	1:       REG_DATA<=24'h300882;   // software reset, bit[7]
	// delay 5ms
	2:       REG_DATA<=24'h300842;   // software power down, bit[6]
	3:       REG_DATA<=24'h310303;   // system clock from PLL, bit[1]
	4:       REG_DATA<=24'h3017ff;   // FREX, Vsync, HREF, PCLK, D[9:6] output enable
	5:       REG_DATA<=24'h3018ff;   // D[5:0], GPIO[1:0] output enable
	6:       REG_DATA<=24'h30341a;   // MIPI 10-bit
	7:       REG_DATA<=24'h303713;   // PLL root divider, bit[4], PLL pre-divider, bit[3:0]
	8:       REG_DATA<=24'h310801;   // PCLK root divider, bit[5:4], SCLK2x root divider, bit[3:2]
	// SCLK root divider, bit[1:0]
	9:       REG_DATA<=24'h363036;  
	10:      REG_DATA<=24'h36310e;  
	11:      REG_DATA<=24'h3632e2;  
	12:      REG_DATA<=24'h363312;  
	13:      REG_DATA<=24'h3621e0;  
	14:      REG_DATA<=24'h3704a0;  
	15:      REG_DATA<=24'h37035a;  
	16:      REG_DATA<=24'h371578;  
	17:      REG_DATA<=24'h371701;  
	18:      REG_DATA<=24'h370b60;  
	19:      REG_DATA<=24'h37051a;  
	20:      REG_DATA<=24'h390502;  
	21:      REG_DATA<=24'h390610;  
	22:      REG_DATA<=24'h39010a;  
	23:      REG_DATA<=24'h373112;  
	24:      REG_DATA<=24'h360008;   // VCM control
	25:      REG_DATA<=24'h360133;   // VCM control
	26:      REG_DATA<=24'h302d60;   // system control
	27:      REG_DATA<=24'h362052;  
	28:      REG_DATA<=24'h371b20;  
	29:      REG_DATA<=24'h471c50;  
	30:      REG_DATA<=24'h3a1343;   // pre-gain = 1.047x
	31:      REG_DATA<=24'h3a1800;   // gain ceiling
	32:      REG_DATA<=24'h3a19f8;   // gain ceiling = 15.5x
	33:      REG_DATA<=24'h363513;  
	34:      REG_DATA<=24'h363603;  
	35:      REG_DATA<=24'h363440;  
	36:      REG_DATA<=24'h362201;  
	// 50/60Hz detection 50/60Hz 灯光条纹过滤
	37:      REG_DATA<=24'h3c0134;   // Band auto, bit[7]
	38:      REG_DATA<=24'h3c0428;   // threshold low sum
	39:      REG_DATA<=24'h3c0598;   // threshold high sum
	40:      REG_DATA<=24'h3c0600;   // light meter 1 threshold[15:8]
	41:      REG_DATA<=24'h3c0708;   // light meter 1 threshold[7:0]
	42:      REG_DATA<=24'h3c0800;   // light meter 2 threshold[15:8]
	43:      REG_DATA<=24'h3c091c;   // light meter 2 threshold[7:0]
	44:      REG_DATA<=24'h3c0a9c;   // sample number[15:8]
	45:      REG_DATA<=24'h3c0b40;   // sample number[7:0]
	46:      REG_DATA<=24'h381000;   // Timing Hoffset[11:8]
	47:      REG_DATA<=24'h381110;   // Timing Hoffset[7:0]
	48:      REG_DATA<=24'h381200;   // Timing Voffset[10:8]
	49:      REG_DATA<=24'h370864;  
	50:      REG_DATA<=24'h400102;   // BLC start from line 2
	51:      REG_DATA<=24'h40051a;   // BLC always update
	52:      REG_DATA<=24'h300000;   // enable blocks
	53:      REG_DATA<=24'h3004ff;   // enable clocks
	54:      REG_DATA<=24'h300e58;   // MIPI power down, DVP enable
	55:      REG_DATA<=24'h302e00;  
	56:      REG_DATA<=24'h430061;   // YUV 422, YUYV
	57:      REG_DATA<=24'h501f01;   // YUV 422
	58:      REG_DATA<=24'h440e00;  
	59:      REG_DATA<=24'h5000a7;   // Lenc on, raw gamma on, BPC on, WPC on, CIP on
	// AEC target 自动曝光控制
	60:      REG_DATA<=24'h3a0f30;   // stable range in high
	61:      REG_DATA<=24'h3a1028;   // stable range in low
	62:      REG_DATA<=24'h3a1b30;   // stable range out high
	63:      REG_DATA<=24'h3a1e26;   // stable range out low
	64:      REG_DATA<=24'h3a1160;   // fast zone high
	65:      REG_DATA<=24'h3a1f14;   // fast zone low
	// Lens correction for ? 镜头补偿
	66:      REG_DATA<=24'h580023;  
	67:      REG_DATA<=24'h580114;  
	68:      REG_DATA<=24'h58020f;  
	69:      REG_DATA<=24'h58030f;  
	70:      REG_DATA<=24'h580412;  
	71:      REG_DATA<=24'h580526;  
	72:      REG_DATA<=24'h58060c;  
	73:      REG_DATA<=24'h580708;  
	74:      REG_DATA<=24'h580805;  
	75:      REG_DATA<=24'h580905;  
	76:      REG_DATA<=24'h580a08;  
	77:      REG_DATA<=24'h580b0d;  
	78:      REG_DATA<=24'h580c08;  
	79:      REG_DATA<=24'h580d03;  
	80:      REG_DATA<=24'h580e00;  
	81:      REG_DATA<=24'h580f00;  
	82:      REG_DATA<=24'h581003;  
	83:      REG_DATA<=24'h581109;  
	84:      REG_DATA<=24'h581207;  
	85:      REG_DATA<=24'h581303;  
	86:      REG_DATA<=24'h581400;  
	87:      REG_DATA<=24'h581501;  
	88:      REG_DATA<=24'h581603;  
	89:      REG_DATA<=24'h581708;  
	90:      REG_DATA<=24'h58180d;  
	91:      REG_DATA<=24'h581908;  
	92:      REG_DATA<=24'h581a05;  
	93:      REG_DATA<=24'h581b06;  
	94:      REG_DATA<=24'h581c08;  
	95:      REG_DATA<=24'h581d0e;  
	96:      REG_DATA<=24'h581e29;  
	97:      REG_DATA<=24'h581f17;  
	98:      REG_DATA<=24'h582011;  
	99:      REG_DATA<=24'h582111;  
	100:     REG_DATA<=24'h582215;  
	101:     REG_DATA<=24'h582328;  
	102:     REG_DATA<=24'h582446;  
	103:     REG_DATA<=24'h582526;  
	104:     REG_DATA<=24'h582608;  
	105:     REG_DATA<=24'h582726;  
	106:     REG_DATA<=24'h582864;  
	107:     REG_DATA<=24'h582926;  
	108:     REG_DATA<=24'h582a24;  
	109:     REG_DATA<=24'h582b22;  
	110:     REG_DATA<=24'h582c24;  
	111:     REG_DATA<=24'h582d24;  
	112:     REG_DATA<=24'h582e06;  
	113:     REG_DATA<=24'h582f22;  
	114:     REG_DATA<=24'h583040;  
	115:     REG_DATA<=24'h583142;  
	116:     REG_DATA<=24'h583224;  
	117:     REG_DATA<=24'h583326;  
	118:     REG_DATA<=24'h583424;  
	119:     REG_DATA<=24'h583522;  
	120:     REG_DATA<=24'h583622;  
	121:     REG_DATA<=24'h583726;  
	122:     REG_DATA<=24'h583844;  
	123:     REG_DATA<=24'h583924;  
	124:     REG_DATA<=24'h583a26;  
	125:     REG_DATA<=24'h583b28;  
	126:     REG_DATA<=24'h583c42;  
	127:     REG_DATA<=24'h583dce;   // lenc BR offset
	128:     REG_DATA<=24'h5180ff;   // AWB B block
	129:     REG_DATA<=24'h518158;   // AWB control
	130:     REG_DATA<=24'h518211;   // [7:4] max local counter, [3:0] max fast counter
	131:     REG_DATA<=24'h518390;   // AWB advanced
	132:     REG_DATA<=24'h518425;  
	133:     REG_DATA<=24'h518524;  
	134:     REG_DATA<=24'h518609;  
	135:     REG_DATA<=24'h518709;  
	136:     REG_DATA<=24'h518809;  
	137:     REG_DATA<=24'h518975;  
	138:     REG_DATA<=24'h518a54;  
	139:     REG_DATA<=24'h518be0;  
	140:     REG_DATA<=24'h518cb2;  
	141:     REG_DATA<=24'h518d42;  
	142:     REG_DATA<=24'h518e3d;  
	143:     REG_DATA<=24'h518f56;  
	144:     REG_DATA<=24'h519046;  
	145:     REG_DATA<=24'h5191ff;   // AWB top limit
	146:     REG_DATA<=24'h519200;   // AWB bottom limit
	147:     REG_DATA<=24'h5193f0;   // red limit
	148:     REG_DATA<=24'h5194f0;   // green limit
	149:     REG_DATA<=24'h5195f0;   // blue limit
	150:     REG_DATA<=24'h519603;   // AWB control
	151:     REG_DATA<=24'h519702;   // local limit
	152:     REG_DATA<=24'h519804;  
	153:     REG_DATA<=24'h519912;  
	154:     REG_DATA<=24'h519a04;  
	155:     REG_DATA<=24'h519b00;  
	156:     REG_DATA<=24'h519c06;  
	157:     REG_DATA<=24'h519d82;  
	158:     REG_DATA<=24'h519e00;   // AWB control
	// Gamma 伽玛曲线
	159:     REG_DATA<=24'h548001;   // Gamma bias plus on, bit[0]
	160:     REG_DATA<=24'h548108;  
	161:     REG_DATA<=24'h548214;  
	162:     REG_DATA<=24'h548328;  
	163:     REG_DATA<=24'h548451;  
	164:     REG_DATA<=24'h548565;  
	165:     REG_DATA<=24'h548671;  
	166:     REG_DATA<=24'h54877d;  
	167:     REG_DATA<=24'h548887;  
	168:     REG_DATA<=24'h548991;  
	169:     REG_DATA<=24'h548a9a;  
	170:     REG_DATA<=24'h548baa;  
	171:     REG_DATA<=24'h548cb8;  
	172:     REG_DATA<=24'h548dcd;  
	173:     REG_DATA<=24'h548edd;  
	174:     REG_DATA<=24'h548fea;  
	175:     REG_DATA<=24'h54901d;  
	// color matrix 色彩矩阵
	176:     REG_DATA<=24'h53811e;   // CMX1 for Y
	177:     REG_DATA<=24'h53825b;   // CMX2 for Y
	178:     REG_DATA<=24'h538308;   // CMX3 for Y
	179:     REG_DATA<=24'h53840a;   // CMX4 for U
	180:     REG_DATA<=24'h53857e;   // CMX5 for U
	181:     REG_DATA<=24'h538688;   // CMX6 for U
	182:     REG_DATA<=24'h53877c;   // CMX7 for V
	183:     REG_DATA<=24'h53886c;   // CMX8 for V
	184:     REG_DATA<=24'h538910;   // CMX9 for V
	185:     REG_DATA<=24'h538a01;   // sign[9]
	186:     REG_DATA<=24'h538b98;   // sign[8:1]
	// UV adjust UV色彩饱和度调整
	187:     REG_DATA<=24'h558006;   // saturation on, bit[1]
	188:     REG_DATA<=24'h558340;  
	189:     REG_DATA<=24'h558410;  
	190:     REG_DATA<=24'h558910;  
	191:     REG_DATA<=24'h558a00;  
	192:     REG_DATA<=24'h558bf8;  
	193:     REG_DATA<=24'h501d40;   // enable manual offset of contrast
	// CIP 锐化和降噪
	194:     REG_DATA<=24'h530008;   // CIP sharpen MT threshold 1
	195:     REG_DATA<=24'h530130;   // CIP sharpen MT threshold 2
	196:     REG_DATA<=24'h530210;   // CIP sharpen MT offset 1
	197:     REG_DATA<=24'h530300;   // CIP sharpen MT offset 2
	198:     REG_DATA<=24'h530408;   // CIP DNS threshold 1
	199:     REG_DATA<=24'h530530;   // CIP DNS threshold 2
	200:     REG_DATA<=24'h530608;   // CIP DNS offset 1
	201:     REG_DATA<=24'h530716;   // CIP DNS offset 2
	202:     REG_DATA<=24'h530908;   // CIP sharpen TH threshold 1
	203:     REG_DATA<=24'h530a30;   // CIP sharpen TH threshold 2
	204:     REG_DATA<=24'h530b04;   // CIP sharpen TH offset 1
	205:     REG_DATA<=24'h530c06;   // CIP sharpen TH offset 2
	206:     REG_DATA<=24'h502500;  
	207:     REG_DATA<=24'h300802;   // wake up from standby, bit[6]
	// YUV VGA 30fps, night mode 5fps
	// Input Clock = 24Mhz, PCLK = 56MHz
	208:     REG_DATA<=24'h303541;   // PLL
	209:     REG_DATA<=24'h303669;   // PLL
	210:     REG_DATA<=24'h3c0707;   // light meter 1 threshold [7:0]
	211:     REG_DATA<=24'h382040;   // Sensor flip off, ISP flip on
	212:     REG_DATA<=24'h382101;   // Sensor mirror on, ISP mirror on, H binning on
	213:     REG_DATA<=24'h381431;   // X INC
	214:     REG_DATA<=24'h381531;   // Y INC
	215:     REG_DATA<=24'h380000;   // HS
	216:     REG_DATA<=24'h380100;   // HS
	217:     REG_DATA<=24'h380200;   // VS
	218:     REG_DATA<=24'h3803fa;   // VS
	219:     REG_DATA<=24'h38040a; // HW (HE)
	220:     REG_DATA<=24'h38053f; // HW (HE)
	221:     REG_DATA<=24'h380606; // VH (VE)
	222:     REG_DATA<=24'h3807a9; // VH (VE)
	223:     REG_DATA<={16'h3808,CAM_HSIZE[15:8]} ; // DVPHO     (1280)
	224:     REG_DATA<={16'h3809,CAM_HSIZE[ 7:0]}; // DVPHO     (1280)
	225:     REG_DATA<={16'h380a,CAM_VSIZE[15:8]} ; // DVPVO     (720)
	226:     REG_DATA<={16'h380b,CAM_VSIZE[ 7:0]}; // DVPVO     (720)
	227:     REG_DATA<=24'h380c07;   // HTS
	228:     REG_DATA<=24'h380d64;   // HTS
	229:     REG_DATA<=24'h380e02;   // VTS
	230:     REG_DATA<=24'h380fe4;   // VTS
	231:     REG_DATA<=24'h381304;   // Timing Voffset
	232:     REG_DATA<=24'h361800;  
	233:     REG_DATA<=24'h361229;  
	234:     REG_DATA<=24'h370952;  
	235:     REG_DATA<=24'h370c03;  
	236:     REG_DATA<=24'h3a0217;   // 60Hz max exposure, night mode 5fps
	237:     REG_DATA<=24'h3a03e0;   // 60Hz max exposure
	// banding filters are calculated automatically in camera driver
	//:     REG_DATA<=24'h3a0801;   // B50 step
	//:     REG_DATA<=24'h3a0927;   // B50 step
	//:     REG_DATA<=24'h3a0a00;   // B60 step
	//:     REG_DATA<=24'h3a0bf6;   // B60 step
	//:     REG_DATA<=24'h3a0e03;   // 50Hz max band
	//:     REG_DATA<=24'h3a0d04;   // 60Hz max band
	238:     REG_DATA<=24'h3a1417;   // 50Hz max exposure, night mode 5fps
	239:     REG_DATA<=24'h3a1510;   // 50Hz max exposure
	240:     REG_DATA<=24'h400402;   // BLC 2 lines
	241:     REG_DATA<=24'h30021c;   // reset JFIFO, SFIFO, JPEG
	242:     REG_DATA<=24'h3006c3;   // disable clock of JPEG2x, JPEG
	243:     REG_DATA<=24'h471303;   // JPEG mode 3
	244:     REG_DATA<=24'h440704;   // Quantization scale
	245:     REG_DATA<=24'h460b37;  
	246:     REG_DATA<=24'h460c20;  
	247:     REG_DATA<=24'h483716;   // DVP CLK divider
	248:     REG_DATA<=24'h382402;   // DVP CLK divider
	249:     REG_DATA<=24'h500183;   // SDE on, scale on, UV average off, color matrix on, AWB on
	250:     REG_DATA<=24'h350300;   // AEC/AGC on
	default:   REG_DATA<=24'h000000;
	endcase
end

endmodule
