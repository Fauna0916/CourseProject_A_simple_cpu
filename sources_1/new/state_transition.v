`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/04/01
// Design Name:
// Module Name: state_transition
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
module state_transition(clk,rst,alu_end,rd,opcode,en_fetch,en_pc,pc_ctrl,reg_en,alu_in_sel,alu_func,en_group_pulse,
                            mem_to_reg, ram_en, ram_we
                           );
    input clk,rst;
    input alu_end;
    input [1:0] rd;
    input [3:0] opcode;
    output reg en_fetch;
    output reg en_pc;
    output reg en_group_pulse;
    output reg [1:0] pc_ctrl;
    output reg [3:0] reg_en;
    output reg alu_in_sel;
    output reg [2:0] alu_func;

    output reg mem_to_reg;
    output reg ram_en, ram_we;

    reg en_group_reg, en_group;
    reg [4:0] current_state,next_state;
    parameter Initial = 5'b00000;
    parameter Fetch = 5'b00001;
    parameter Decode = 5'b00010;
    parameter Execute_Moveb = 5'b00011;
    parameter Execute_Add = 5'b00100;
    parameter Execute_Sub_R = 5'b00101;
    parameter Execute_And = 5'b00110;
    parameter Execute_Or = 5'b00111;
    parameter Execute_Jump = 5'b01000;
    parameter Write_back = 5'b01001;
    /*extra*/
    parameter Execute_Add_R = 5'b01010;
    parameter Execute_Sub = 5'b01011;
    parameter Execute_Leftshift = 5'b01100;
    parameter Execute_Rightshift = 5'b01101;

    parameter Execute_Moveb_R = 5'b01110;
    parameter Execute_Xor = 5'b01111;

    parameter Execute_Load = 5'b10000;
    parameter Load_Wait = 5'b10001;
    parameter Execute_Store = 5'b10010;
    parameter Store_Wait = 5'b10011;


    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
            current_state <= Initial;
        else
            current_state <= next_state;
    end

    // Below codes defines state transition for "next_state"
    always @ (*)
    begin
        case (current_state)
            Initial:
            begin
                if(rst)
                    next_state = Fetch;
                else
                    next_state = Initial;
            end
            Fetch:
            begin
                next_state = Decode;
            end
            Decode:
            begin
                case(opcode)
                    4'b0000:
                        next_state = Execute_Moveb;
                    4'b0001:
                        next_state = Execute_Moveb_R;
                    4'b0010:
                        next_state = Execute_Add;
                    4'b0011:
                        next_state = Execute_Add_R;
                    4'b0100:
                        next_state = Execute_Sub;
                    4'b0101:
                        next_state = Execute_Sub_R;
                    4'b0111:
                        next_state = Execute_And;
                    4'b1001:
                        next_state = Execute_Or;
                    4'b1010:
                        next_state = Execute_Jump;
                    4'b1011:
                        next_state = Execute_Leftshift;
                    4'b1100:
                        next_state = Execute_Rightshift ;
                    4'b1101:
                        next_state = Execute_Xor;
                    4'b1110:
                        next_state = Execute_Load;
                    4'b1111:
                        next_state = Execute_Store ;
                    default:
                        next_state = current_state;
                endcase
            end
            Execute_Moveb:
            begin
                if(alu_end)
                    next_state = Write_back;
                else
                    next_state = current_state;
            end
            Execute_Moveb_R:
                next_state = alu_end ? Write_back : current_state;

            Execute_Add:
            begin
                if(alu_end)
                    next_state = Write_back;
                else
                    next_state = current_state;
            end
            Execute_Add_R:
                next_state = alu_end ? Write_back : current_state;

            Execute_Sub:
                next_state = alu_end ? Write_back : current_state;

            Execute_Sub_R:
            begin
                if(alu_end)
                    next_state = Write_back;
                else
                    next_state = current_state;
            end
            Execute_And:
            begin
                if(alu_end)
                    next_state = Write_back;
                else
                    next_state = current_state;
            end

            Execute_Or:
            begin
                if(alu_end)
                    next_state = Write_back;
                else
                    next_state = current_state;
            end

            Execute_Jump:
                next_state = Fetch;

            Write_back:
                next_state = Fetch;


            Execute_Leftshift:
                next_state = alu_end ? Write_back : current_state;

            Execute_Rightshift:
                next_state = alu_end ? Write_back : current_state;

            Execute_Xor:
                next_state = alu_end ? Write_back : current_state;

            Execute_Load:
                next_state = Load_Wait;

            Load_Wait:
                next_state = Write_back;

            Execute_Store:
                next_state = Store_Wait;
            Store_Wait:
                next_state = Fetch;

            default:
                next_state = current_state;
        endcase
    end

    // Below codes provide control signals
    always @(*)
    begin
        if (!rst)
        begin
            en_fetch = 1'b0;
            en_group = 1'b0;
            en_pc = 1'b0;
            pc_ctrl = 2'b00;
            reg_en = 4'b0000;
            alu_in_sel = 1'b0;
            alu_func = 3'b000;
            mem_to_reg = 1'b0;
            ram_en = 1'b0;
            ram_we = 1'b0;
        end
        else
        begin
            case (next_state)
                Initial:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Fetch:
                begin
                    en_fetch = 1'b1;
                    en_group = 1'b0;
                    en_pc = 1'b1;
                    pc_ctrl = 2'b01;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Decode:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Moveb:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Moveb_R:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b1;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Add:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b001;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Add_R:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b1;
                    alu_func = 3'b001;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Sub:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b010;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Sub_R:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b1;
                    alu_func = 3'b010;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_And:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b1;
                    alu_func = 3'b011;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Or:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b1;
                    alu_func = 3'b100;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Jump:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b1;
                    pc_ctrl = 2'b10;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Write_back:
                begin
                    case (rd)
                        2'b00:
                            reg_en = 4'b0001;
                        2'b01:
                            reg_en = 4'b0010;
                        2'b10:
                            reg_en = 4'b0100;
                        2'b11:
                            reg_en = 4'b1000;
                        default:
                            reg_en = 4'b0000;
                    endcase
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = (current_state == Load_Wait) ? 1'b1 : 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Leftshift:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b101;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Rightshift:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b110;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Xor:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b111;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Load:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b1;
                    ram_we = 1'b0;
                end
                Load_Wait:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Execute_Store:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b1;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
                Store_Wait:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b1;
                    ram_we = 1'b1;
                end
                default:
                begin
                    en_fetch = 1'b0;
                    en_group = 1'b0;
                    en_pc = 1'b0;
                    pc_ctrl = 2'b00;
                    reg_en = 4'b0000;
                    alu_in_sel = 1'b0;
                    alu_func = 3'b000;
                    mem_to_reg = 1'b0;
                    ram_en = 1'b0;
                    ram_we = 1'b0;
                end
            endcase
        end
    end

    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            en_group_reg <= 1'b0;
        end
        else
        begin
            en_group_reg <= en_group;
        end
    end

    always @ (en_group_reg or en_group)
    begin
        en_group_pulse <= en_group & (~en_group_reg);
    end
endmodule
