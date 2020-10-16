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
	//�趨��СΪ4KB�����Դ洢1024��32λָ��
	reg [31:0] inst_rom[0:1023];
	//����Ӧ��ַ��ָ��
	assign rdata = inst_rom[addr];
	//��ʼ�����е�ָ��
	initial
		$readmemh("inst_rom.txt", inst_rom);

endmodule