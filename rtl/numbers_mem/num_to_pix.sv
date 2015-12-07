module num_to_pix #(

  parameter NUM_W = 4,
  parameter PIX_X_W = 12,
  parameter PIX_Y_W = 12,
  parameter MAX_X   = 80

)(

  input               clk_i,
  input               rst_i,

  input [NUM_W-1:0]   num_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

logic [12:0] pix_addr;

logic [9:0] pix_all; 


assign pix_addr = ( pos_y_i * MAX_X ) + pos_x_i;

numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/0.mif" )

) mem_0_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[0] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/1.mif" )

) mem_1_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[1] )

);

numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/2.mif" )

) mem_2_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[2] )

);

numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/3.mif" )

) mem_3_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[3] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/4.mif" )

) mem_4_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[4] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/5.mif" )

) mem_5_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[5] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/6.mif" )

) mem_6_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[6] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/7.mif" )

) mem_7_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[7] )

);


numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/8.mif" )

) mem_8_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[8] )

);

numbers_mem #(

  .MIF_FNAME ( "../rtl/numbers_mem/9.mif" )

) mem_9_inst (

  .address ( pix_addr   ),
  .clock   ( clk_i      ),
  .q       ( pix_all[9] )

);

assign pix_o = pix_all[ num_i ];

endmodule
