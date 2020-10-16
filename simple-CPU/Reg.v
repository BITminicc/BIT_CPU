`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:56:14
// Design Name: 
// Module Name: Reg
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

module Reg(
    input 			clk,
	input 	[4:0] 	raddr1,
	output 	[31:0] 	rdata1,
	input 	[4:0] 	raddr2,
	output 	[31:0] 	rdata2,
	input 			we,		//为1控制写寄存器，为0不写寄存器
	input 	[4:0] 	waddr,
	input 	[31:0] 	wdata
	);
	//设置32个长度为32位的寄存器
	reg [31:0] regreg[0:31];
	//0寄存器的值恒为0
	assign rdata1 = raddr1 == 0 ? 0 : regreg[raddr1];
	assign rdata2 = raddr2 == 0 ? 0 : regreg[raddr2];
	always @(posedge clk) begin
		//不能写入0寄存器
		if (we == 1 & waddr != 0) begin
			regreg[waddr] <= wdata;
		end
	end
endmodule
