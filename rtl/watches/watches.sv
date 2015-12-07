module watches #(
  parameter ST_MIN = 0,
  parameter ST_HR  = 0
) (

  input                         clk_i,
  input                         rst_i,

  input                         user_time_val_i,
  input                         user_min_up_i,
  input                         user_hour_up_i,

  output logic                  sec_blnk_o,
  output logic [$clog2(59)-1:0] min_o,
  output logic [$clog2(23)-1:0] hour_o,
  output logic [$clog2(59)-1:0] sec_o


);

logic [$clog2(59)-1:0] sec;
logic [$clog2(59)-1:0] min;
logic                  last_tact;

sec_cnt sc(

  .clk_i           ( clk_i           ),
  .rst_i           ( rst_i           ),

  .user_time_val_i ( user_time_val_i ),
  .sec_o           ( sec             ),
  .last_tact_o     ( last_tact       )

);

assign sec_o = sec;

min_cnt #(

  .ST_MIN ( ST_MIN )

) mc (

  .clk_i           ( clk_i           ),
  .rst_i           ( rst_i           ),

  .user_min_up_i   ( user_min_up_i   ),
  .user_time_val_i ( user_time_val_i ),

  .sec_i           ( sec             ),

  .last_tact_i     ( last_tact       ),
  .min_o           ( min             )

);

hour_cnt #(
 
  .ST_HR ( ST_HR )

) hc (

  .clk_i           ( clk_i           ),
  .rst_i           ( rst_i           ),

  .user_hour_up_i  ( user_hour_up_i  ),
  .user_time_val_i ( user_time_val_i ),

  .sec_i           ( sec             ),
  .min_i           ( min             ),

  .last_tact_i     ( last_tact       ),

  .hour_o          ( hour_o          )

);

assign min_o = min;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        sec_blnk_o <= 0;
      end
    else
      begin
        if( last_tact )
          sec_blnk_o <= ~sec_blnk_o;
      end
  end

endmodule
