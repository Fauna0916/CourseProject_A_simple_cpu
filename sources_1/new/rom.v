`timescale 1 ns / 1 ns
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/01
// Design Name:
// Module Name: rom
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
module rom #(
        parameter DWIDTH = 16,
        parameter AWIDTH = 16,
        parameter DEPTH  = 16
    )(
        input clk,
        input rst,
        input [AWIDTH - 1 : 0] addr,
        input ready,
        output [DWIDTH - 1 : 0] dout,
        output en_out
    );
    reg [DWIDTH - 1 : 0] mem[0 : DEPTH - 1];
    reg [15:0] result=0;
    reg valid;
    reg [15:0] result_reg;

    initial
    begin
        // mem[0]  = 16'b0000_0000_0000_0000; // NOP
        // mem[1]  = 16'b0000_0000_0000_1000; // MOVEB R0, #8	R0=8
        // mem[2]  = 16'b0000_0100_0000_0010; // MOVEB R1, #2	R1=2
        // mem[3]  = 16'b0010_0100_0000_0001; // ADD R1, #1	R1=3
        // mem[4]  = 16'b0101_0001_0000_0000; // SUB_R R0, R1	R0=5
        // mem[5]  = 16'b1001_0001_0000_0000; // OR R0, R1		R0=5
        // mem[6]  = 16'b0010_0000_0000_0001; // ADD R1, #1	R0=8
        // mem[7]  = 16'b1010_0000_0000_0111; // JUMP, #7	

        /*extar ins test*/

        mem[0]  = 16'b0000_0000_0000_0000; // NOP
        mem[1]  = 16'b0000_0000_0000_1000; // MOVEB R0, #8	R0=8
        mem[2]  = 16'b1111_0000_0000_0010; // STORE R0, #2	
        mem[3]  = 16'b1110_0100_0000_0010; // LOAD R1, #2	R1=8
        mem[4]  = 16'b1100_0100_0000_0001; // rightshift R1, #1 R1=4
        mem[5]  = 16'b1011_0100_0000_0010; // leftshift R1, #2 R1=16
        mem[6]  = 16'b0010_0100_0000_0001; // ADD R1, #1	R1=17
        mem[7]  = 16'b1101_0100_0000_1011; // Xor R1, #11, 
        mem[8]  = 16'b1010_0000_0000_0111; // JUMP, #7	R1=16


    end

    always @(posedge clk or negedge rst)
    begin
        if (rst == 0)
        begin
            result_reg <= 16'b0000_0000_0000_0000;
        end
        else
        begin
            result_reg <= result;
        end
    end

    always @(*)
    begin
        if (rst == 0)
        begin
            result = 16'b0000_0000_0000_0000;
            valid = 0;
        end
        else
        begin
            if (ready)
            begin
                result = mem[addr];
                valid = 1;
            end
            else
            begin
                result = result_reg;
                valid = 0;
            end
        end
    end

    assign dout = result;
    assign en_out = valid;

endmodule
