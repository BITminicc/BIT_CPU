`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/10 10:00:54
// Design Name: 
// Module Name: project_1
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


module project_1(
    input clk,
	input reset,
	/*PC模块*/
	output [31:0] pc,
	output [31:0] next_pc,
	/*指令存储器模块*/
	output [31:0] inst_sram_addr,
	output [31:0] inst_sram_rdata,
	/*主译码模块*/
	output [31:0] inst,
	
	/*寄存器模块*/
	output [4:0] rf_raddr1,
	output [4:0] rf_raddr2,
	output [31:0] rf_rdata1,
	output [31:0] rf_rdata2,
	output rf_we,
	output [4:0] rf_waddr,
	output [31:0] rf_wdata,
	/*ALU模块*/
	output [11:0] alu_op,
	output [31:0] alu_src1,
	output [31:0] alu_src2,
	output [31:0] alu_result,
	/*数据存储器模块*/
	output [3:0] data_sram_wen,
	output [31:0] data_sram_addr,
	output [31:0] data_sram_wdata,
	output [31:0] data_sram_rdata,
	output [31:0] final_result
	
	);
	wire res_or_mem;
	wire [31:0] mem_result;

	/*PC模块*/
	PC   My_pc(
		.clk 	(clk	), //In
		.reset	(reset	), //In
		.pc 	(pc 	), //Out
		.next_pc(next_pc)  //In
	);

	/*指令存储器模块*/
	assign inst_sram_addr	= pc;
	InstRom My_inst_rom(
		.addr 	(inst_sram_addr[11:2]),//In
		.rdata	(inst_sram_rdata 	 ) //Out
	);
    
	/*主译码模块*/
	assign inst = inst_sram_rdata;
	CU Main(
		.clk			(clk			),//In
		.reset			(reset			),//In
		.inst 			(inst 			),//In
		.rf_raddr1 		(rf_raddr1		),//Out
		.rs_value 		(rf_rdata1		),//In
		.rf_raddr2 		(rf_raddr2		),//Out
		.rt_value 		(rf_rdata2		),//In
		.rf_we 			(rf_we			),//Out
		.rf_waddr 		(rf_waddr		),//Out
		.alu_op 		(alu_op			),//Out
		.alu_src1 		(alu_src1		),//Out
		.alu_src2 		(alu_src2		),//Out
		.pc 			(pc 			),//In
		.next_pc 		(next_pc		),//Out
		.data_sram_wen 	(data_sram_wen	),//Out
		.res_or_mem 	(res_or_mem		) //Out
	);

	/*寄存器模块*/
	Reg My_reg(
		.clk 	(clk		),//In
		.raddr1 (rf_raddr1	),//In
		.rdata1 (rf_rdata1	),//Out
		.raddr2 (rf_raddr2	),//In
		.rdata2 (rf_rdata2	),//Out
		.we     (rf_we		),//In
		.waddr  (rf_waddr	),//In
		.wdata  (rf_wdata	) //In
	);

	/*ALU模块*/
	ALU My_alu(
		.alu_op 	(alu_op		),//In
		.alu_src1 	(alu_src1	),//In
		.alu_src2 	(alu_src2	),//In
		.alu_result (alu_result	) //Out
	);

	assign data_sram_addr = alu_result;
	assign data_sram_wdata = rf_rdata2;

	/*数据存储器模块*/
	DataSRam My_data_SRam(
		.clk	(clk				 ),//In
		.wen 	(data_sram_wen 		 ),//In
		.addr 	(data_sram_addr[11:2]),//In
		.wdata 	(data_sram_wdata 	 ),//In
		.rdata	(data_sram_rdata 	 ) //Out
	);
    
	assign mem_result = data_sram_rdata;
	assign final_result = res_or_mem ? mem_result : alu_result;
	assign rf_wdata = final_result;	//最后得到的结果可能需要写入寄存器中

endmodule
