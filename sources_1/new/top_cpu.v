`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/01
// Design Name:
// Module Name: top_cpu
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
module top_cpu(
        input clk, rst
    );
    wire en_ram_in, en_ram_out;
    wire [15:0] addr, ins;
    wire [3:0] ram_addr;
    wire [7:0] ram_wdata, ram_rdata;
    wire ram_en, ram_we;


    cpu cpu_0 (
            .clk(clk),
            .rst(rst),
            .addr(addr),
            .ins(ins),
            .en_ram_in(en_ram_in),
            .en_ram_out(en_ram_out),
            .ram_addr(ram_addr),
            .ram_wdata(ram_wdata),
            .ram_rdata(ram_rdata),
            .ram_en(ram_en),
            .ram_we(ram_we)
        );

    rom ram_0 (
            .clk(clk),
            .rst(rst),
            .ready(en_ram_in),
            .addr(addr),
            .dout(ins),
            .en_out(en_ram_out)
        );

    ip_ram ip_rom_0 (
               .sys_clk(clk),
               .sys_rst(rst),
               .ram_en(ram_en),
               .ram_we(ram_we),
               .ram_addr(ram_addr),
               .w_data(ram_wdata),
               .r_data(ram_rdata)
           );

endmodule


