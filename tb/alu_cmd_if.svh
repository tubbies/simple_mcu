interface alu_cmd_if (input bit clk, input bit rst_n);
    logic                               i_en    ;
    logic [I_BW-1:0]                    i_cmd   ;
    logic [D_BW-1:0]                    i_da    ;
    logic [D_BW-1:0]                    i_db    ;
endinterface
