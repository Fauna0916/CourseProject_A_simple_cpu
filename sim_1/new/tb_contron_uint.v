`timescale 1ns / 1ps

module tb_control_unit();

    reg clk, rst, alu_end, en_ram_out;
    reg [15:0] ins;
    wire en_ram_in, en_group, en_pc, alu_in_sel;
    wire [3:0] reg_en;
    wire [2:0] alu_func;
    wire [1:0] pc_ctrl;
    wire [15:0] ir_out;

    control_unit control_unit1 (
                     .clk(clk),
                     .rst(rst),
                     .alu_end(alu_end),
                     .ins(ins),
                     .en_ram_out(en_ram_out),
                     .en_ram_in(en_ram_in),
                     .en_group(en_group),
                     .en_pc(en_pc),
                     .reg_en(reg_en),
                     .alu_in_sel(alu_in_sel),
                     .alu_func(alu_func),
                     .pc_ctrl(pc_ctrl),
                     .ir_out(ir_out)
                 );

    parameter Tclk = 10;

    initial
    begin
        clk = 1;
        forever
            #(Tclk/2) clk = ~clk;
    end

    initial
    begin
        rst = 0;
        #(Tclk*3) rst = 1;
    end

    reg [2:0] cnt1;
    always @ (posedge clk)
    begin
        if(!rst)
            cnt1 <= 3'd1;
        else
            cnt1 <= cnt1 + 1;
    end

    always @ (posedge clk)
    begin
        if(!rst)
            alu_end <= 1'b0;
        else if(cnt1 == 3'd4)
        begin
            cnt1 <= 1'b0;
            alu_end <= 1'b1;
        end
        else
            alu_end <= 1'b0;
    end

    always @ (posedge clk)
    begin
        if(!rst)
            en_ram_out <= 1'b0;
        else if(en_ram_in)
            en_ram_out <= 1'b1;
        else
            en_ram_out <= 1'b0;
    end

    initial
    begin
        ins =16'b0000_0000_0000_0010;   //move
        #(Tclk*8) ins = 16'b0010_0000_0000_1000;     // add
        #(Tclk*10) ins = 16'b0101_0100_0000_0100;    // sub
        #(Tclk*10) ins = 16'b0111_1000_0000_0010;    // and
        #(Tclk*10) ins = 16'b1001_1100_0000_0010;    // or
        #(Tclk*10) ins = 16'b1010_0000_0000_0001;    // jump
        #(Tclk*10) ins = 16'b1111_0000_0000_0000; // default
    end

    initial
    begin
        #(Tclk*70) $stop;
    end

endmodule
