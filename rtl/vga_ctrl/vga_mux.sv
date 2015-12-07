`include "../defines/waveform_defines.vh"

module vga_mux #(

  parameter DIR_CNT = 3,
  parameter MOD_W = $clog2(DIR_CNT)

) (

  input [MOD_W-1:0]  mod_i,

  vga_if             vga_0_if, 
  vga_if             vga_1_if, 
  vga_if             vga_2_if, 

  vga_if             vga_out_if

);

always_comb
  begin
    vga_out_if.hs    = '0;
    vga_out_if.vs    = '0;
    vga_out_if.red   = '0;
    vga_out_if.green = '0;
    vga_out_if.blue  = '0; 
    case( mod_i )
      'd0: begin
             vga_out_if.hs    = vga_0_if.hs;
             vga_out_if.vs    = vga_0_if.vs;
             vga_out_if.red   = vga_0_if.red;
             vga_out_if.green = vga_0_if.green;
             vga_out_if.blue  = vga_0_if.blue;
           end
      'd1: begin
             vga_out_if.hs    = vga_1_if.hs;
             vga_out_if.vs    = vga_1_if.vs;
             vga_out_if.red   = vga_1_if.red;
             vga_out_if.green = vga_1_if.green;
             vga_out_if.blue  = vga_1_if.blue;
           end
      'd2: begin
             vga_out_if.hs    = vga_2_if.hs;
             vga_out_if.vs    = vga_2_if.vs;
             vga_out_if.red   = vga_2_if.red;
             vga_out_if.green = vga_2_if.green;
             vga_out_if.blue  = vga_2_if.blue;
           end
    endcase
  end


endmodule
