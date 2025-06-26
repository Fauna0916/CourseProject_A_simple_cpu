`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/01 20:34:27
// Design Name:
// Module Name: tb_top_cpu
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


`timescale 1ns / 1ps

module tb_top_cpu();

    reg clk, rst;
    wire [15:0] ins;
    wire        en_ram_in;
    wire        en_ram_out;
    wire [15:0] addr;

    wire [4:0] ram_addr;
    wire [7:0] ram_wdata, ram_rdata;
    wire ram_en, ram_we;

    parameter Tclk = 10;

    top_cpu test_top_cpu (
                .clk(clk),
                .rst(rst)
            );

    initial
    begin
        // Define clk
        clk=1;
        forever
            #(Tclk/2) clk=~clk;
    end

    initial
    begin
        // Define rst
        rst=0;
        #(Tclk*3)	rst=1;
    end

    initial
    begin
        #(Tclk*70)      $stop;

    end

endmodule

