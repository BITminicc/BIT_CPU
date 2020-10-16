`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:55:09
// Design Name: 
// Module Name: InstRom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module InstRom(
    input [9:0] addr, 
	output[31:0] rdata
	);
	//设定大小为4KB，可以存储1024条32位指令
	reg [31:0] inst_rom[0:1023];
	//读相应地址的指令
	assign rdata = inst_rom[addr];
	//初始化所有的指令
	initial
		$readmemh("inst_rom.txt", inst_rom);

endmodule