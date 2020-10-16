`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 09:59:06
// Design Name: 
// Module Name: CU
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


module CU(
    input clk,
	input reset,
	/*与指令存储器模块交互*/
	input [31:0] inst,
	/*与寄存器模块交互*/
	output [4:0] rf_raddr1,
	input [31:0] rs_value,
	output [4:0] rf_raddr2,
	input [31:0] rt_value,
	output rf_we,
	output [4:0] rf_waddr,
	/*与ALU模块交互*/
	output [11:0] alu_op,
	output [31:0] alu_src1,
	output [31:0] alu_src2,
	/*与程序计数器模块交互*/
	input [31:0] pc,
	output [31:0] next_pc,
	/*与数据存储器模块交互*/
	output [3:0] data_sram_wen,
	/*选择数据存储器中读取的值 or ALU计算结果*/
	output res_or_mem
	);

	//声明指令中所有部分
	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] sa;
	wire [5:0] func;
	wire [15:0] imm;
	wire [25:0] jidx;
	//声明解码后的指令部分
	wire [63:0] op_d;
	wire [63:0] func_d;
	wire [31:0] rs_d;
	wire [31:0] rt_d;
	wire [31:0] rd_d;
	wire [31:0] sa_d;
	//声明所有可能的指令类型
	wire inst_addu;
	wire inst_subu;
	wire inst_slt;
	wire inst_sltu;
	wire inst_and;
	wire inst_or;
	wire inst_xor;
	wire inst_nor;
	wire inst_sll;
	wire inst_srl;
	wire inst_sra;
	wire inst_addiu;
	wire inst_lui;
	wire inst_lw;
	wire inst_sw;
	wire inst_beq;
	wire inst_bne;
	wire inst_jal;
	wire inst_jr;
	//声明标记符
	wire src1_is_sa;
	wire src1_is_pc;	
	wire src2_is_imm;	
	wire src2_is_8;		
	wire dst_is_r31;
	wire dst_is_rt; 		
	wire mem_we;
	//声明指令跳转标记符
	wire rs_eq_rt;
	wire br_taken;
	wire [31:0] bd_pc;
	wire [31:0] br_target;


	//为指令中所有部分赋值
	assign op 	= inst[31:26];
	assign rs 	= inst[25:21];
	assign rt 	= inst[20:16];
	assign rd 	= inst[15:11];
	assign sa 	= inst[10: 6];
	assign func = inst[ 5: 0];
	assign imm	= inst[15: 0];
	assign jidx = inst[25: 0];

	//将原编码转换为one-hot编码，易于操作
	decoder_6_64 u_dec0(.in(op), .out(op_d));		
	decoder_6_64 u_dec1(.in(func), .out(func_d));	
	decoder_5_32 u_dec2(.in(rs), .out(rs_d));		
	decoder_5_32 u_dec3(.in(rt), .out(rt_d));
	decoder_5_32 u_dec4(.in(rd), .out(rd_d));
	decoder_5_32 u_dec5(.in(sa), .out(sa_d));

	//判断是否为以下指令
	assign inst_addu = op_d[6'h00] & func_d[6'h21] & sa_d[5'h00];
	assign inst_subu = op_d[6'h00] & func_d[6'h23] & sa_d[5'h00];
	assign inst_slt  = op_d[6'h00] & func_d[6'h2a] & sa_d[5'h00];
	assign inst_sltu = op_d[6'h00] & func_d[6'h2b] & sa_d[5'h00];
	assign inst_and  = op_d[6'h00] & func_d[6'h24] & sa_d[5'h00];
	assign inst_or   = op_d[6'h00] & func_d[6'h25] & sa_d[5'h00];
	assign inst_xor  = op_d[6'h00] & func_d[6'h26] & sa_d[5'h00];
	assign inst_nor  = op_d[6'h00] & func_d[6'h27] & sa_d[5'h00];
	assign inst_sll  = op_d[6'h00] & func_d[6'h00] & rs_d[5'h00];
	assign inst_srl  = op_d[6'h00] & func_d[6'h02] & rs_d[5'h00];
	assign inst_sra  = op_d[6'h00] & func_d[6'h03] & rs_d[5'h00];
	assign inst_addiu= op_d[6'h09];
	assign inst_lui  = op_d[6'h0f] & rs_d[5'h00];
	assign inst_lw   = op_d[6'h23];
	assign inst_sw   = op_d[6'h2b];
	assign inst_beq  = op_d[6'h04];
	assign inst_bne  = op_d[6'h05];
	assign inst_jal  = op_d[6'h03];
	assign inst_jr   = op_d[6'h00] & func_d[6'h08] & rt_d[5'h00] & rd_d[5'h00] & sa_d[5'h00];


	//标记符
	assign src1_is_sa = inst_sll | inst_srl | inst_sra;					//源操作数1是sa
	assign src1_is_pc = inst_jal;										//源操作数1是pc
	assign src2_is_imm = inst_addiu | inst_lui | inst_lw | inst_sw;		//源操作数2是立即数
	assign src2_is_8 = inst_jal;										//处理jal，pc+8得到对应延迟槽之后的指令
	assign dst_is_r31 = inst_jal;										//处理jal，对应延迟槽之后的指令放入31号寄存器中
	assign dst_is_rt = inst_addiu | inst_lui | inst_lw; 				//需要存数据，目标寄存器为rt


	/*与寄存器模块交互*/
	//确定是否需要在寄存器中存数据
	assign rf_we = ~inst_sw & ~inst_beq & ~inst_bne & ~inst_jr; 		//不需要存数据
	//确定读哪个寄存器
	assign rf_raddr1 = rs;
	assign rf_raddr2 = rt;
	//确定写入哪个寄存器
	assign rf_waddr = 	dst_is_r31? 5'd31   :	//处理jal指令，将结果写入31号寄存器中
						dst_is_rt?	rt 		:	//写入目标寄存器rt
									rd;			//写入默认目标寄存器rd

	/*与ALU模块交互*/
	//将指令以ALU的执行特点组合起来
	assign alu_op[ 0] = inst_addu || inst_addiu || inst_lw || inst_sw || inst_jal;	//ALU都进行加法操作
	assign alu_op[ 1] = inst_subu || inst_beq || inst_bne; //ALU都进行减法操作
	assign alu_op[ 2] = inst_slt;
	assign alu_op[ 3] = inst_sltu;
	assign alu_op[ 4] = inst_and;
	assign alu_op[ 5] = inst_nor;
	assign alu_op[ 6] = inst_or;
	assign alu_op[ 7] = inst_xor;
	assign alu_op[ 8] = inst_sll;
	assign alu_op[ 9] = inst_srl;
	assign alu_op[10] = inst_sra;
	assign alu_op[11] = inst_lui;
	//整理ALU的操作数
	assign alu_src1 = 	src1_is_sa ? {27'b0, sa[4:0]} 	:
						src1_is_pc ? pc[31:0]			:
									rs_value;
	assign alu_src2 = 	src2_is_imm ? {{16{imm[15]}}, imm[15:0]} :
						src2_is_8	? 32'd8				:
								  	rt_value;

	/*与PC模块交互*/
	//处理所有指令的跳转
	assign rs_eq_rt = (rs_value == rt_value);
	assign br_taken = inst_beq && rs_eq_rt		//跳转指令出现后，判断其是否有条件进行跳转
					|| inst_bne && !rs_eq_rt
					|| inst_jal
					|| inst_jr;
	assign bd_pc = pc + 32'h4;
	assign br_target = (inst_beq || inst_bne) ? (bd_pc + {{14{imm[15]}}, imm[15:0], 2'b0}) :
						(inst_jr)			  ? rs_value:
												{bd_pc[31:28], jidx[25:0], 2'b0};
    assign next_pc = br_taken ? br_target : bd_pc;


	/*选择数据存储器中读取的值 or ALU计算结果*/
	assign res_or_mem = inst_lw;	//读数据存储器
	/*与数据存储器模块交互*/
	//处理数据存储器
	assign mem_we = inst_sw;		//写数据存储器
	assign data_sram_wen = mem_we ? 4'hf : 4'h0;

endmodule
