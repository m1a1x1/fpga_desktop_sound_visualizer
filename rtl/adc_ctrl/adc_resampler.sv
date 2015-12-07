module adc_resampler #(

  parameter IN_SAMP_FRQ = 500000,

  parameter OUT_SAMP_FRQ = 12500

)(

  input           clk_i,
  input           rst_i,

  adc_ctrl_if.in  adc_if,

  output          adc_data_o,
  output          adc_data_val_o

);

localparam SAMP_CNT = ( IN_SAMP_FRQ / OUT_SAMP_FRQ );

logic adc_done_d1;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      adc_done_d1 <= 1'b0;
    else
      adc_done_d1 <= adc_if.done;
  end


logic [11:0] adc_data_d1;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      adc_data_d1 <= 1'b0;
    else
      adc_data_d1 <= adc_if.data;
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      adc_if.go <= 1'b1;
    else
      if( adc_if.go && adc_if.done )
        adc_if.go <= 1'b0;
      else
        if( !adc_if.done && adc_done_d1 )
          adc_if.go <= 1'b1;
  end

logic [$clog2( SAMP_CNT ) - 1: 0 ] sampl_cnt;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      sampl_cnt <= '0;
    else
      if( sampl_cnt == ( SAMP_CNT - 1 ) )
        sampl_cnt <= '0;
      else
        if( adc_if.done )
          sampl_cnt <= sampl_cnt + 1;
  end

assign adc_data_o = adc_data_d1; 
assign adc_data_val_o = ( sampl_cnt == ( SAMP_CNT - 1 ) );

endmodule
