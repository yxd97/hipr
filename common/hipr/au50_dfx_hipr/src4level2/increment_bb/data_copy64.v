// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="data_copy64_data_copy64,hls_ip_2022_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xczu9eg-ffvb1156-2-e,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.085000,HLS_SYN_LAT=1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=2,HLS_SYN_LUT=107,HLS_VERSION=2022_1}" *)

module data_copy64 (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        Input_1_TDATA,
        Input_1_TVALID,
        Input_1_TREADY,
        Output_1_TDATA,
        Output_1_TVALID,
        Output_1_TREADY
);

parameter    ap_ST_fsm_state1 = 2'd1;
parameter    ap_ST_fsm_state2 = 2'd2;

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [63:0] Input_1_TDATA;
input   Input_1_TVALID;
output   Input_1_TREADY;
output  [63:0] Output_1_TDATA;
output   Output_1_TVALID;
input   Output_1_TREADY;

reg ap_done;
reg ap_idle;
reg ap_ready;

 reg    ap_rst_n_inv;
(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    Input_1_TDATA_blk_n;
reg    Output_1_TDATA_blk_n;
wire    ap_CS_fsm_state2;
reg    ap_block_state1;
wire    regslice_both_Output_1_U_apdone_blk;
reg    ap_block_state2;
reg   [1:0] ap_NS_fsm;
reg    ap_ST_fsm_state1_blk;
reg    ap_ST_fsm_state2_blk;
wire    regslice_both_Input_1_U_apdone_blk;
wire   [63:0] Input_1_TDATA_int_regslice;
wire    Input_1_TVALID_int_regslice;
reg    Input_1_TREADY_int_regslice;
wire    regslice_both_Input_1_U_ack_in;
wire   [63:0] Output_1_TDATA_int_regslice;
reg    Output_1_TVALID_int_regslice;
wire    Output_1_TREADY_int_regslice;
wire    regslice_both_Output_1_U_vld_out;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 2'd1;
end

data_copy64_regslice_both #(
    .DataWidth( 64 ))
regslice_both_Input_1_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(Input_1_TDATA),
    .vld_in(Input_1_TVALID),
    .ack_in(regslice_both_Input_1_U_ack_in),
    .data_out(Input_1_TDATA_int_regslice),
    .vld_out(Input_1_TVALID_int_regslice),
    .ack_out(Input_1_TREADY_int_regslice),
    .apdone_blk(regslice_both_Input_1_U_apdone_blk)
);

data_copy64_regslice_both #(
    .DataWidth( 64 ))
regslice_both_Output_1_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .data_in(Output_1_TDATA_int_regslice),
    .vld_in(Output_1_TVALID_int_regslice),
    .ack_in(Output_1_TREADY_int_regslice),
    .data_out(Output_1_TDATA),
    .vld_out(regslice_both_Output_1_U_vld_out),
    .ack_out(Output_1_TREADY),
    .apdone_blk(regslice_both_Output_1_U_apdone_blk)
);

always @ (posedge ap_clk) begin
    if (ap_rst_n_inv == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (*) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        Input_1_TDATA_blk_n = Input_1_TVALID_int_regslice;
    end else begin
        Input_1_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (1'b0 == Output_1_TREADY_int_regslice) | (1'b0 == Input_1_TVALID_int_regslice)) & (1'b1 == ap_CS_fsm_state1))) begin
        Input_1_TREADY_int_regslice = 1'b1;
    end else begin
        Input_1_TREADY_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) | ((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1)))) begin
        Output_1_TDATA_blk_n = Output_1_TREADY_int_regslice;
    end else begin
        Output_1_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((ap_start == 1'b0) | (1'b0 == Output_1_TREADY_int_regslice) | (1'b0 == Input_1_TVALID_int_regslice)) & (1'b1 == ap_CS_fsm_state1))) begin
        Output_1_TVALID_int_regslice = 1'b1;
    end else begin
        Output_1_TVALID_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) | (1'b0 == Output_1_TREADY_int_regslice) | (1'b0 == Input_1_TVALID_int_regslice))) begin
        ap_ST_fsm_state1_blk = 1'b1;
    end else begin
        ap_ST_fsm_state1_blk = 1'b0;
    end
end

always @ (*) begin
    if (((regslice_both_Output_1_U_apdone_blk == 1'b1) | (1'b0 == Output_1_TREADY_int_regslice))) begin
        ap_ST_fsm_state2_blk = 1'b1;
    end else begin
        ap_ST_fsm_state2_blk = 1'b0;
    end
end

always @ (*) begin
    if ((~((regslice_both_Output_1_U_apdone_blk == 1'b1) | (1'b0 == Output_1_TREADY_int_regslice)) & (1'b1 == ap_CS_fsm_state2))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if ((~((regslice_both_Output_1_U_apdone_blk == 1'b1) | (1'b0 == Output_1_TREADY_int_regslice)) & (1'b1 == ap_CS_fsm_state2))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if ((~((ap_start == 1'b0) | (1'b0 == Output_1_TREADY_int_regslice) | (1'b0 == Input_1_TVALID_int_regslice)) & (1'b1 == ap_CS_fsm_state1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if ((~((regslice_both_Output_1_U_apdone_blk == 1'b1) | (1'b0 == Output_1_TREADY_int_regslice)) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign Input_1_TREADY = regslice_both_Input_1_U_ack_in;

assign Output_1_TDATA_int_regslice = (Input_1_TDATA_int_regslice + 64'd1);

assign Output_1_TVALID = regslice_both_Output_1_U_vld_out;

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

always @ (*) begin
    ap_block_state1 = ((ap_start == 1'b0) | (1'b0 == Output_1_TREADY_int_regslice) | (1'b0 == Input_1_TVALID_int_regslice));
end

always @ (*) begin
    ap_block_state2 = ((regslice_both_Output_1_U_apdone_blk == 1'b1) | (1'b0 == Output_1_TREADY_int_regslice));
end

always @ (*) begin
    ap_rst_n_inv = ~ap_rst_n;
end

endmodule //data_copy64
