`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2025/05/08 09:25:53
// Design Name:
// Module Name: ip_ram
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


module ip_ram (
        input          sys_clk,
        input          sys_rst,
        input          ram_en,
        input          ram_we,
        input  [3:0]   ram_addr,
        input  [7:0]   w_data,
        output [7:0]   r_data
    );

    blk_mem_gen_0 blk_mem_gen_1 (
                      .clka(sys_clk),
                      .ena(ram_en),            // Port A enable
                      .wea(ram_we),            // Write enable
                      .addra(ram_addr),
                      .dina(w_data),
                      .douta(r_data)
                  );

endmodule
