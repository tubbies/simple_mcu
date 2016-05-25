interface alu_core_if
#(
    parameter   I_BW        =               4                       ,// Instruction Bandwidth
    parameter   D_BW        =               4                        // Data Bandwidth
);
//(   
//    input wire              clk     ,//
//    input wire              rst_n    //
//);
    logic                                   i_en                    ;
    logic       [   I_BW    -1:0]           i_cmd                   ;
    logic       [   D_BW    -1:0]           i_da                    ;
    logic       [   D_BW    -1:0]           i_db                    ;
endinterface: alu_core_if
