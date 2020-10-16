`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:58:15
// Design Name: 
// Module Name: Decoder
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


module decoder_3_8(
	input [2:0] in, 
	output [7:0] out
	);
	assign out = 	(in == 3'b000) ? 8'b00000001 : 
					(in == 3'b001) ? 8'b00000010 :
					(in == 3'b010) ? 8'b00000100 :
					(in == 3'b011) ? 8'b00001000 :
					(in == 3'b100) ? 8'b00010000 :
					(in == 3'b101) ? 8'b00100000 :
					(in == 3'b110) ? 8'b01000000 :
									 8'b10000000 ;
									 
endmodule

module decoder_6_64(
	input [5:0] in, 
	output [63:0] out
	);
	wire [7:0] subout;
	decoder_3_8  decoder0(
		.in (in[2:0]),
		.out (subout)
		);
	assign out = 	(in[5:3] == 3'b000) ? {56'b0,subout} : 
					(in[5:3] == 3'b001) ? {48'b0,subout,8'b0} :
					(in[5:3] == 3'b010) ? {40'b0,subout,16'b0}:
					(in[5:3] == 3'b011) ? {32'b0,subout,24'b0} :
					(in[5:3] == 3'b100) ? {24'b0,subout,32'b0} :
					(in[5:3] == 3'b101) ? {16'b0,subout,40'b0} :
					(in[5:3] == 3'b110) ? {8'b0,subout,48'b0} :
									 	  {subout,56'b0};
									 	  
endmodule

module decoder_5_32(
	input [4:0] in, 
	output [31:0] out
	);
	wire [7:0] subout;
	decoder_3_8  decoder0(
		.in (in[2:0]),
		.out (subout)
		);
	assign out = 	(in[4:3] == 2'b00) ? {24'b0,subout}: 
					(in[4:3] == 2'b01) ? {16'b0,subout,8'b0} :
					(in[4:3] == 2'b10) ? {8'b0,subout,16'b0}:
										 {subout,24'b0};
										 
endmodule
