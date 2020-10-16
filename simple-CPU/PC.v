`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:54:16
// Design Name: 
// Module Name: PC
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

module PC(
    input clk,
	input reset,
	output reg [31:0] pc,
	input [31:0] next_pc
	);
	always @(posedge clk) begin
		if (reset) 	pc <= 32'b0;	//³õÊ¼»¯pcÎª0
		else 		pc <= next_pc;
	end
endmodule
