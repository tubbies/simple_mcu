// vim:ts=4:sw=4:et:fdm=marker:fdl=0
/******************************************************************
*
* alu_core
* Description - 
*
* Author(s): 
*         Jinmo Kwon <jinmo.kwon@lge.com>
*
* Copyright (C) 2016 LG Electronics, Inc.
*
* Change Log
* - 2016.01.08 Initially composed 
*
*******************************************************************/
`default_nettype none // Help to detect undeclared wires
module alu_core
#(
    parameter   I_BW        =               4                       ,// Instruction Bandwidth
    parameter   D_BW        =               4                        // Data Bandwidth
)
(
    input  wire                             clk                     ,// System clock
    input  wire                             rst_n                   ,// Active low reset signal

    input  wire                             i_en                    ,// input  data enable
    input  wire [   I_BW    -1:0]           i_cmd                   ,// input  command
    input  wire [   D_BW    -1:0]           i_da                    ,// input  data a
    input  wire [   D_BW    -1:0]           i_db                    ,// input  data b

    // add sub interface
    output reg                              o_en                    ,// output data enable
    output reg                              o_of                    ,// output overflow flag
    output reg                              o_ofb                   ,// output overflow bit
    output reg  [   D_BW    -1:0]           o_dat                    // output data
);
/*******************************/
/**        Parameters         **/
/*******************************/
/*{{{*/
localparam  CMD_ADD     =   0        ;
localparam  CMD_SUB     =   1        ;
localparam  CMD_MUXA    =   2        ;
localparam  CMD_MUXB    =   3        ;
localparam  CMD_MUXIA   =   4        ;
localparam  CMD_MUXIB   =   5        ;
localparam  CMD_AND     =   6        ;
localparam  CMD_OR      =   7        ;
localparam  CMD_XOR     =   8        ;
/*}}}*/

/*******************************/
/**         Functions         **/
/*******************************/
/*{{{*/
/*}}}*/

/*******************************/
/**    Wire and Registers     **/
/*******************************/
/*{{{*/
wire                        r_overflow                      ;//
wire [  D_BW+1  -1:0]       r_add_5b                        ;//
wire [  D_BW    -1:0]       r_add                           ;//
wire                        r_underflow                     ;//
wire [  D_BW    -1:0]       r_sub                           ;//
wire [  D_BW    -1:0]       r_not_da                        ;//
wire [  D_BW    -1:0]       r_not_db                        ;//
wire [  D_BW    -1:0]       r_and                           ;//
wire [  D_BW    -1:0]       r_or                            ;//
wire [  D_BW    -1:0]       r_xor                           ;//
/*}}}*/

/*******************************/
/**       Instantiation       **/
/*******************************/
/*{{{*/
/*}}}*/

/*******************************/
/**    Procedural Statement   **/
/*******************************/
/*{{{*/
/*{{{*/ // add
assign r_add_5b         = i_da + i_db;
assign r_overflow       = r_add_5b[D_BW];
assign r_add            = (r_overflow) ? 4'b1111 : r_add_5b[0 +: D_BW];
/*}}}*/
/*{{{*/ // sub
assign r_underflow      = ( i_da < i_db ) ? 1'b1 : 1'b0;
assign r_sub            = ( r_underflow ) ? (i_db - i_da) : (i_da - i_db);
/*}}}*/
/*{{{*/ // not
assign r_not_da = ~ i_da ;
assign r_not_db = ~ i_db ;

/*}}}*/
/*{{{*/ // bit operations
assign r_and = i_da & i_db ;
assign r_or  = i_da | i_db ;
assign r_xor = i_da ^ i_db ;
/*}}}*/
/*{{{*/ // alu output
always @(posedge clk or negedge rst_n)
begin :p_aluout
    if(~rst_n) begin
        o_en    <= 1'b0;
        o_of    <= 1'b0;
        o_ofb   <= 1'b0;
        o_dat   <= {D_BW{1'b0}};
    end // end of async reset
    else begin
        o_en    <= i_en;
        
        o_of    <= ( (i_en == 1'b1) && (i_cmd <  4'd2) ) ? (r_underflow |  r_overflow) : 1'b0 ;
        o_ofb   <= ( (i_en == 1'b1) && (i_cmd == 4'd1) ) ? (r_underflow              ) : 1'b0 ;
        if(i_en) begin
            case(i_cmd)
            CMD_ADD     : begin o_dat <=  r_add ;   end 
            CMD_SUB     : begin o_dat <=  r_sub ;   end
            CMD_MUXA    : begin o_dat <=  i_da  ;   end
            CMD_MUXB    : begin o_dat <=  i_db  ;   end 
            CMD_MUXIA   : begin o_dat <= ~i_da  ;   end 
            CMD_MUXIB   : begin o_dat <= ~i_db  ;   end
            CMD_AND     : begin o_dat <=  r_and ;   end
            CMD_OR      : begin o_dat <=  r_or  ;   end
            CMD_XOR     : begin o_dat <=  r_xor ;   end
            default     : begin o_dat <= {D_BW{1'b0}};end
            endcase
        end
    end // end of positive sync clk
end // end of always
/*}}}*/
/*}}}*/

endmodule
`resetall // Restore compile directives to their default

//synopsys translate_off
module tb_alu_core;
/*******************************/
/**   Local Testbench Block   **/
/*******************************/
/*{{{*/
//clock
/*{{{*/ // clock / reset generation
reg                         clk                             ;// System clock
reg                         rst_n                           ;// System reset
reg                         apb_clk                         ;// apb clock
reg                         rst_apb_n                       ;// apb reset

initial begin:p_sys_clk_gen
    clk     =   1'b1;
    while (1) begin #2  clk = ~clk; end
end // end of p_sys_clk_gen

initial begin:p_apb_clk_gen
    apb_clk =   1'b1;
    while (1) begin #3 apb_clk = ~apb_clk; end
end // end of p_apb_clk_gen

initial begin:p_sys_rst_gen
    rst_n   =   1'b0;
    repeat(1000) @(posedge clk);
    rst_n   =   1'b1;
end // end of p_sys_rst_gen

initial begin:p_apb_rst_n
    rst_apb_n   =   1'b0;
    repeat(800) @(posedge apb_clk);
    rst_apb_n   =   1'b1;
end // end of p_apb_rst_n
/*}}}*/
/*{{{*/ // init / start generation
reg                         init                            ;
reg                         start                           ;
initial begin:p_init_gen
    init    =   1'b0;
    repeat(1000) @(posedge clk);
    init    =   1'b1;
    repeat(5   ) @(posedge clk);
    init    =   1'b0;
end // end of p_init_gen
initial begin:p_start_gen
    start   =   1'b0;
    repeat(1010) @(posedge clk);
    start   =   1'b1;
    repeat(1   ) @(posedge clk);
    start   =   1'b0;
end // end of p_start_gen
/*}}}*/
//end of clock
localparam  D_BW    =   8   ;
localparam  I_BW    =   4   ;

reg                  i_en        ;
reg  [I_BW   -1:0]   i_cmd       ;
reg  [D_BW   -1:0]   i_da        ;
reg  [D_BW   -1:0]   i_db        ;
wire                 o_en        ;
wire                 o_of        ;
wire                 o_ofb       ;
wire [D_BW   -1:0]   o_dat       ;

/*{{{*/ // data generation
always @(posedge clk or negedge rst_n)
begin :p_data_rand_gen
    if(~rst_n) begin
        i_en  <= 1'b0;
        i_cmd <= 4'b0;
        i_da  <= {D_BW{1'b0}};
        i_db  <= {D_BW{1'b0}};
    end // end of async reset
    else begin
        if($random % 2 == 0) begin
            i_en  <= 1'b1;
            i_cmd <= $random % 9;
            i_da  <= $random;
            i_db  <= $random;
        end
        else begin
            i_en  <= 1'b0;
        end
    end // end of positive sync clk
end // end of always
/*}}}*/

alu_core #(.D_BW(D_BW), .I_BW(I_BW)) DUT
(/*{{{*/
.clk        (clk                ),
.rst_n      (rst_n              ),

.i_en       (i_en               ),
.i_cmd      (i_cmd              ),
.i_da       (i_da               ),
.i_db       (i_db               ),
                  
.o_en       (o_en               ),
.o_of       (o_of               ),
.o_ofb      (o_ofb              ),
.o_dat      (o_dat              ) 
);/*}}}*/

/*}}}*/
endmodule
//synopsys translate_on
