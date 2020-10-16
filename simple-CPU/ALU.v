`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:56:56
// Design Name: 
// Module Name: ALU
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

module ALU(
	input [11:0] alu_op,
	input [31:0] alu_src1,
	input [31:0] alu_src2,
	output [31:0] alu_result
	);
	//声明所有操作符
	wire op_add;	//加法
	wire op_sub;	//减法
	wire op_slt;	//有符号数比较，小于置1
	wire op_sltu;	//无符号数比较，小于置1
	wire op_and;	//按位与
	wire op_nor;	//按位或非
	wire op_or;		//按位或
	wire op_xor;	//按位异或
	wire op_sll;	//逻辑左移
	wire op_srl;	//逻辑右移
	wire op_sra;	//算术右移
	wire op_lui;	//立即数置于高半部分

	//为所有操作符赋值
	assign op_add 	= alu_op[ 0];
	assign op_sub 	= alu_op[ 1];
	assign op_slt 	= alu_op[ 2];
	assign op_sltu 	= alu_op[ 3];
	assign op_and 	= alu_op[ 4];
	assign op_nor 	= alu_op[ 5];
	assign op_or 	= alu_op[ 6];
	assign op_xor 	= alu_op[ 7];
	assign op_sll 	= alu_op[ 8];
	assign op_srl 	= alu_op[ 9];
	assign op_sra 	= alu_op[10];
	assign op_lui 	= alu_op[11];

	//声明所有结果
	wire [31:0] add_sub_result;
	wire [31:0] slt_result;
	wire [31:0] sltu_result;
	wire [31:0] and_result;
	wire [31:0] nor_result;
	wire [31:0] or_result;
	wire [31:0] xor_result;
	wire [31:0] lui_result;
	wire [31:0] sll_result;
	wire [31:0] sr64_result;
	wire [31:0] sr_result;

	//声明中间变量
	wire [31:0] adder_a;
	wire [31:0] adder_b;
	wire 		adder_cin;
	wire [31:0] adder_result;
	wire 		adder_cout;

	/*实现加减法*/
	assign adder_a = alu_src1;
	assign adder_b = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2; 
	//如果是减法则先取反，再加1得到补码
	assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1 : 1'b0;
	assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;
	assign add_sub_result = adder_result;

	/*实现有符号数无符号数的比较*/
	assign slt_result[31:1] = 31'b0;
	//两个操作数一负一正，或两个操作数同号结果为负数
	assign slt_result[0] = (alu_src1[31] & ~alu_src2[31])
							| ((~alu_src1[31] ^ alu_src2[31]) & adder_result[31]);
	//无符号数相加，无进位，说明小于
	assign sltu_result[31:1] = 31'b0;
	assign sltu_result[0] = ~adder_cout;

	/*实现位运算*/
	assign and_result = alu_src1 & alu_src2;
	assign or_result = alu_src1 | alu_src2;
	assign nor_result = ~or_result;
	assign xor_result = alu_src1 ^ alu_src2;

	assign lui_result = {alu_src2[15:0], 16'b0};

	/*实现左移右移*/
	assign sll_result = alu_src2 << alu_src1[4:0];
	//如果是sra则右移补充符号位，如果是srl则右移补充0
	assign sr64_result = {{32{op_sra & alu_src2[31]}}, alu_src2[31:0]} >> alu_src1[4:0];
	assign sr_result = sr64_result[31:0];

	//最后的多路选择器
	assign alu_result = ({32{op_add | op_sub}} & add_sub_result)
				  	  | ({32{op_slt}} & slt_result)
				  	  | ({32{op_sltu}} & sltu_result)
				  	  | ({32{op_and}} & and_result)
				  	  | ({32{op_nor}} & nor_result)
				  	  | ({32{op_or}} & or_result)
				  	  | ({32{op_xor}} & xor_result)
				  	  | ({32{op_lui}} & lui_result)
				  	  | ({32{op_sll}} & sll_result)
				  	  | ({32{op_sra | op_srl}} & sr_result);
endmodule
