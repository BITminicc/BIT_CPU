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
	input 			we,		//Ϊ1����д�Ĵ�����Ϊ0��д�Ĵ���
	input 	[4:0] 	waddr,
	input 	[31:0] 	wdata
	);
	//����32������Ϊ32λ�ļĴ���
	reg [31:0] regreg[0:31];
	//0�Ĵ�����ֵ��Ϊ0
	assign rdata1 = raddr1 == 0 ? 0 : regreg[raddr1];
	assign rdata2 = raddr2 == 0 ? 0 : regreg[raddr2];
	always @(posedge clk) begin
		//����д��0�Ĵ���
		if (we == 1 & waddr != 0) begin
			regreg[waddr] <= wdata;
		end
	end
endmodule
