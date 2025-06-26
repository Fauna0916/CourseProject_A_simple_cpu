`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/01
// Design Name:
// Module Name: data_path
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
module data_path (
        clk,rst,en_pc,pc_ctrl,offset,en_in,reg_en,alu_in_sel,alu_func,en_out,pc_out,rd,rs,
        mem_to_reg, ram_we, ram_rdata, ram_wdata, ram_addr
    );

    input clk,rst,en_pc,en_in,alu_in_sel;
    input [7:0] offset;
    input [1:0] pc_ctrl,rd,rs;
    input [3:0]  reg_en;
    input [2:0] alu_func;
    output  en_out;
    output [15:0] pc_out;

    input mem_to_reg;
    input ram_we;
    input [7:0] ram_rdata;
    output [7:0] ram_wdata;
    output [3:0] ram_addr;

    wire en_out_group ,en_out_alu_mux;
    wire [15:0] rd_q, rs_q ,alu_a ,alu_b ,alu_out;

    wire [15:0] reg_write_data;
    //reg [7:0] ram_wdata_reg;    // Register for store data

    pc pc1(
           .clk(clk),
           .rst(rst),
           .en_in(en_pc),
           .pc_ctrl(pc_ctrl),
           .offset_addr(offset),
           .pc_out(pc_out)
       );

    reg_group reg_group1(
                  .clk(clk),
                  .rst(rst),
                  .en_in(en_in),
                  .reg_en(reg_en),
                  .d_in(reg_write_data),
                  .rd(rd),
                  .rs(rs),
                  .rd_q(rd_q),
                  .rs_q(rs_q),
                  .en_out(en_out_group)
              );

    alu_mux alu_mux1(
                .clk(clk),
                .rst(rst),
                .en_in(en_out_group),
                .rd_q(rd_q),
                .rs_q(rs_q),
                .offset(offset),
                .alu_in_sel(alu_in_sel),
                .alu_a(alu_a),
                .alu_b(alu_b),
                .en_out(en_out_alu_mux)
            );

    alu alu1 (
            .clk(clk),
            .rst(rst),
            .en_in(en_out_alu_mux),
            .alu_a(alu_a),
            .alu_b(alu_b),
            .alu_func(alu_func),
            .en_out(en_out),
            .alu_out(alu_out )
        );

    assign ram_addr = offset[3:0];
    assign ram_wdata = rs_q[7:0];
    assign reg_write_data = mem_to_reg ? {8'b0, ram_rdata} : alu_out;

endmodule

