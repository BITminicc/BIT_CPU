`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:57:31
// Design Name: 
// Module Name: DataSRam
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


module DataSRam(
    input clk,
	input [3:0] wen,
	input [9:0] addr,
	input [31:0] wdata,
	output [31:0] rdata
	);
	//暂时定义1024*4字节大小的内存
	reg [31:0] sram [0:1023];
	assign rdata[31:0] = sram[addr];
	always @(posedge clk) begin
		if (wen == 4'hf) begin
			sram[addr] <= wdata[31:0];
		end
	end
endmodule
