`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: ZHC
// 
// Create Date: 2020/09/07 15:37:03
// Design Name: 
// Module Name: test_mips
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


module test_sim(
    input clk,//时钟信号--1ns//
    input pause,//暂停信号//
    input clr,//清除信号//
    output [7:0]out,//八位数码管输出//
    output [3:0]open,//四位段选输出//
    output light1,light2,light3,light4,light5,light6,light7,light8,warning
    //八个LED灯表示半位"1"，warning为超时警报//
    );
        reg  rled_out1;reg [7:0] led1;// 10*ms//
        reg  rled_out2;reg [7:0] led2;//100*ms//
        reg  rled_out3;reg [7:0] led3;//s//
        reg  rled_out4;reg [7:0] led4;//10*s//
        parameter time0 = 40'd2_500;//scan//
        parameter time1 = 40'd500_000;//create 10ms//
        reg [39:0] count0;reg  rled_out0;reg [3:0] q0;
        reg [39:0] count1;reg [3:0] q1;reg temp1;
        reg [39:0] count2;reg [3:0] q2;reg temp2;
        reg [39:0] count3;reg [3:0] q3;reg temp3;
        reg [39:0] count4;reg [3:0] q4;reg temp4;
        reg [39:0] count5;reg  rled_out5;reg q5;reg q6;
        reg [39:0] count6;reg  rled_out6;reg [7:0]led0;reg [3:0]temp;
//-------------------------------create ms-------------------------------------------//
        always @(posedge clk or negedge pause)
         if(!pause )//暂停信号为0时，执行
         begin
            count1 <= count1;
            rled_out1<=0;
         end
         else if(count1 == time1) 
         begin 
            count1 <= 0;
            rled_out1<=~rled_out1;
         end
         else count1 <= count1 + 1;
        //----------------------------1-------------------------//
        always @(posedge rled_out1 or negedge clr )
        begin
           if(clr==0)
            q1 <= 4'b0000;
           else 
            begin
             if(q1==9)
              begin 
               q1 <= 0;
               rled_out2 <= 1;
              end
             else
              begin
              q1 <= q1+1;
              rled_out2 <= 0;
              end
            end
        end
        //----------------------1-------------------//
        always @ (*)
                case(q1)
                4'b0000: led1 = 8'b11000000;  //0  
                4'b0001: led1 = 8'b11111001;  //1  
                4'b0010: led1 = 8'b10100100;  //2  
                4'b0011: led1 = 8'b10110000;  //3  
                4'b0100: led1 = 8'b10011001;  //4  
                4'b0101: led1 = 8'b10010010;  //5  
                4'b0110: led1 = 8'b10000010;  //6  
                4'b0111: led1 = 8'b11111000;  //7  
                4'b1000: led1 = 8'b10000000;  //8  
                4'b1001: led1 = 8'b10010000;  //9  
                endcase
        //----------------------------2-------------------------//
        always @(posedge rled_out2 or negedge clr )
        begin
           if(clr==0)
            q2 <= 4'b0000;
           else 
            begin
             if(q2==9)
              begin 
               q2 <= 0;
               rled_out3 <= 1;
              end
             else
              begin
              q2 <= q2+1;
              rled_out3 <= 0;
              end
            end
        end
        //----------------------2-------------------//
        always @ (*)
                case(q2)
                4'b0000: led2 = 8'b11000000;  //0  
                4'b0001: led2 = 8'b11111001;  //1  
                4'b0010: led2 = 8'b10100100;  //2  
                4'b0011: led2 = 8'b10110000;  //3  
                4'b0100: led2 = 8'b10011001;  //4  
                4'b0101: led2 = 8'b10010010;  //5  
                4'b0110: led2 = 8'b10000010;  //6  
                4'b0111: led2 = 8'b11111000;  //7  
                4'b1000: led2 = 8'b10000000;  //8  
                4'b1001: led2 = 8'b10010000;  //9   
                endcase
        //----------------------------3-------------------------//
        always @(posedge rled_out3 or negedge clr )
        begin
           if(clr==0)
            q3 <= 4'b0000;
           else 
            begin
             if(q3==9)
              begin 
               q3 <= 0;
               rled_out4 <= 1;
              end
             else
              begin
              q3 <= q3+1;
              rled_out4 <= 0;
              end
            end
        end
        //----------------------3-------------------//
        always @ (*)
                case(q3)
                4'b0000: led3 = 8'b01000000;  //0  
                4'b0001: led3 = 8'b01111001;  //1  
                4'b0010: led3 = 8'b00100100;  //2  
                4'b0011: led3 = 8'b00110000;  //3  
                4'b0100: led3 = 8'b00011001;  //4  
                4'b0101: led3 = 8'b00010010;  //5  
                4'b0110: led3 = 8'b00000010;  //6  
                4'b0111: led3 = 8'b01111000;  //7  
                4'b1000: led3 = 8'b00000000;  //8  
                4'b1001: led3 = 8'b00010000;  //9  
                endcase
        //----------------------------4-------------------------//
        always @(posedge rled_out4 or negedge clr )
        begin
           if(clr==0)
            q4 <= 4'b0000;
           else 
            begin
             if(q4==5)
              begin 
               q4 <= 0;
               rled_out5 <= 1;
              end
             else
              begin
              q4 <= q4+1;
              rled_out5 <= 0;
              end
            end
        end
        //----------------------4-------------------//
        always @ (*)
                case(q4)
                4'b0000: led4 = 8'b11000000;  //0  
                4'b0001: led4 = 8'b11111001;  //1  
                4'b0010: led4 = 8'b10100100;  //2  
                4'b0011: led4 = 8'b10110000;  //3  
                4'b0100: led4 = 8'b10011001;  //4  
                4'b0101: led4 = 8'b10010010;  //5  
                4'b0110: led4 = 8'b10000010;  //6  
                4'b0111: led4 = 8'b11111000;  //7  
                4'b1000: led4 = 8'b10000000;  //8  
                4'b1001: led4 = 8'b10010000;  //9 
                endcase
        //--------------------------片区选择-------------------------//
        always @(posedge clk or negedge clr)//100//
        if(!clr  )//复位信号为0时，执行
        begin
          count0 <= count0;
          rled_out0<=4'b0;
        end
        else if(count0 == time0) 
        begin 
          count0 <= 40'd0;
          rled_out0<=~rled_out0;
        end
        else count0 <= count0 + 1'b1;
      //--------------------------片区选择-------------------------//
        always @(posedge rled_out0 or negedge clr )
        begin
           if(clr==0)
            q0 <= 4'b0000;
           else 
            begin
             if(q0==3)
              begin 
               q0 <= 0;
              end
             else
              begin
              q0 <= q0+1;
              end
            end
        end
        //------------------片区选择-----------------------//
        always @(*)
              case (q0)
          //    4'b0000:begin led0<=led1;temp1<=1;temp2<=0;temp3<=0;temp4<=0;end
          //    4'b0001:begin led0<=led2;temp1<=0;temp2<=1;temp3<=0;temp4<=0;end
           //   4'b0010:begin led0<=led3;temp1<=0;temp2<=0;temp3<=1;temp4<=0;end
           //   4'b0011:begin led0<=led4;temp1<=0;temp2<=0;temp3<=0;temp4<=1;end
               4'b0000:begin led0=~led1;temp=4'b0001;end
               4'b0001:begin led0=~led2;temp=4'b0010;end
               4'b0010:begin led0=~led3;temp=4'b0100;end
               4'b0011:begin led0=~led4;temp=4'b1000;end
              endcase
          assign out=led0;//assign open1=temp1;assign open2=temp2;assign open3=temp3;assign open4=temp4;
          assign open=temp;
           //--------------------分钟------------------------------//
            always @(posedge rled_out5 or negedge clr )
                   begin
                      if(clr==0)
                       q5 <= 4'b0000;
                      else 
                       begin
                        if(q5==1)
                         begin 
                          q5 <= 0;
                          rled_out6 <= 1;
                         end
                        else
                         begin
                         q5 <= q5+1;
                         rled_out6 <= 0;
                         end
                       end
                   end
              assign light1=q5;assign light2=q5;assign light3=q5;assign light4=q5;
              assign light5=q5;assign light6=q5;assign light7=q5;assign light8=q5;
              //---------------------------报警------------------------------------------//
              always @(posedge rled_out6 or negedge clr )
                      begin
                         if(clr==0)
                          q6 <= 4'b0000;
                         else 
                          begin
                           if(q6==1)
                            begin 
                             q6 <= 0;
                            end
                           else
                            begin
                            q6 <= q6+1;
                            end
                          end
                      end
               assign warning=q6;
endmodule
