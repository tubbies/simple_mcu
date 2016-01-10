interface alu_core_if
#(
    parameter   D_BW    =   8       ,//
    parameter   I_BW    =   4        //
)
(   
    input wire              clk     ,//
    input wire              rst_n    //
);
    logic                   i_en    ;
    logic [ I_BW    -1:0]   i_cmd   ;
    logic [ D_BW    -1:0]   i_da    ;
    logic [ D_BW    -1:0]   i_db    ;
    
    logic                   o_en    ;
    logic                   o_of    ;
    logic                   o_ofb   ;
    logic [ D_BW    -1:0]   o_dat   ;
endinterface: alu_core_if
