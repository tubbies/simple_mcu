interface alu_res_if (input bit clk, input bit rst_n);
    logic                               o_en    ;
    logic                               o_of    ;
    logic                               o_ofb   ;
    logic [D_BW-1:0]                    o_dat   ;
endinterface
