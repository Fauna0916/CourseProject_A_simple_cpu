`timescale 1ns / 1ps

module tb_data_path();

    reg clk, rst, en_pc, en_in, alu_in_sel;
    reg [7:0] offset;
    reg [1:0] pc_ctrl, rd, rs;
    reg [3:0] reg_en;
    reg [2:0] alu_func;

    wire en_out;
    wire [15:0] pc_out;

    data_path test_data_path (
                  .clk(clk),
                  .rst(rst),
                  .en_pc(en_pc),
                  .en_in(en_in),
                  .pc_ctrl(pc_ctrl),
                  .offset(offset),
                  .reg_en(reg_en),
                  .alu_in_sel(alu_in_sel),
                  .alu_func(alu_func),
                  .rd(rd),
                  .rs(rs),
                  .en_out(en_out),
                  .pc_out(pc_out)
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
        if (!rst)
            cnt1 <= 3'd1;
        else
            cnt1 <= cnt1 + 1;
    end

    initial
    begin
        rd = 2'b00;
        #(Tclk*8) rd = 2'b01;
    end

    initial
    begin
        rs = 2'b00;
        #(Tclk*8)  rs = 2'b00; // ADD
        #(Tclk*10) rs = 2'b01; // SUB
        #(Tclk*10) rs = 2'b10; // AND
        #(Tclk*10) rs = 2'b11; // OR
        #(Tclk*10) rs = 2'b00; // JUMP
        #(Tclk*10) rs = 2'b01; // Default
    end

    initial
    begin
        offset = 8'h01; // MOVEB
        #(Tclk*8)  offset = 8'h00; // ADD
        #(Tclk*10) offset = 8'h00; // SUB
        #(Tclk*10) offset = 8'h00; // AND
        #(Tclk*10) offset = 8'h00; // OR
        #(Tclk*10) offset = 8'h78; // JUMP
        #(Tclk*10) offset = 8'h00; // Default
    end

    initial
    begin
        alu_func = 3'b000; // MOVEB
        #(Tclk*8)  alu_func = 3'b001; // ADD
        #(Tclk*10) alu_func = 3'b010; // SUB
        #(Tclk*10) alu_func = 3'b011; // AND
        #(Tclk*10) alu_func = 3'b100; // OR
        #(Tclk*10) alu_func = 3'b000; // JUMP
        #(Tclk*10) alu_func = 3'b000; // Default
    end

    initial
    begin
        alu_in_sel = 0; // MOVEB
        #(Tclk*8)  alu_in_sel = 1; // ADD
        #(Tclk*10) alu_in_sel = 1; // SUB
        #(Tclk*10) alu_in_sel = 1; // AND
        #(Tclk*10) alu_in_sel = 1; // OR
        #(Tclk*10) alu_in_sel = 0; // JUMP
        #(Tclk*10) alu_in_sel = 1; // Default
    end

    initial
    begin
        pc_ctrl = 2'b01; // Increment
        #(Tclk*48) pc_ctrl = 2'b10; // JUMP
        #(Tclk*10) pc_ctrl = 2'b01;
    end

    initial
    begin
        en_pc = 0;
        en_in = 0;
        reg_en = 4'b0000;

        #(Tclk*3);

        movb_sequence();

        add_sequence();

        sub_sequence();

        and_sequence();

        or_sequence();

        jump_sequence();

        default_sequence();
    end



    task movb_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 0;
            en_in = 1;
            #(Tclk*4) en_in = 0;
            reg_en = 4'b0001;
            #(Tclk*1) reg_en = 4'b0000;
        end
    endtask

    task add_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 0;
            en_in = 1;
            #(Tclk*4) en_in = 0;
            reg_en = 4'b0010;
            #(Tclk*1) reg_en = 4'b0000;
        end
    endtask

    task sub_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 0;
            en_in = 1;
            #(Tclk*4) en_in = 0;
            reg_en = 4'b0010;
            #(Tclk*1) reg_en = 4'b0000;
        end
    endtask

    task and_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 0;
            en_in = 1;
            #(Tclk*4) en_in = 0;
            reg_en = 4'b0010;
            #(Tclk*1) reg_en = 4'b0000;
        end
    endtask

    task or_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 0;
            en_in = 1;
            #(Tclk*4) en_in = 0;
            reg_en = 4'b0010;
            #(Tclk*1) reg_en = 4'b0000;
        end
    endtask

    task jump_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 1;
            pc_ctrl = 2'b10; // JUMP
            #(Tclk*4) en_pc = 0;
        end
    endtask

    task default_sequence;
        begin
            #(Tclk*1) en_pc = 1;
            #(Tclk*1) en_pc = 1;
            pc_ctrl = 2'b10; // JUMP
            #(Tclk*4) en_pc = 0;
        end
    endtask

    initial
    begin
        #(Tclk*70) $stop;
    end

endmodule
