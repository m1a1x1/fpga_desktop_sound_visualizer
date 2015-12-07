module rst #(
  
  parameter RST_DELAY = 5

)(

  input   clk_i,
  input   key_i,

  output  rst_o

);

logic [RST_DELAY:1] rst_d;

always_ff @( posedge clk_i )
  begin
    rst_d[1] <= key_i;
    for ( int i = 2; i <= RST_DELAY; i++)
      rst_d[ i ] <= rst_d[ i - 1 ];
  end

assign rst_o = rst_d[ RST_DELAY ];

endmodule
