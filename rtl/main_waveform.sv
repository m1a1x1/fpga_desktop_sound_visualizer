`include "../defines/colors.vh"

module main_waveform(
 
  input                     clk_50_i,
  input                     clk_25_i,

  input                     rst_i,
  
  input              [1:0]  show_mode_i,

  pixels_if.in              pixels_if,

  watches_ctrl_if.in        watches_ctrl_if,

  vga_if.out                vga_out_if,
  
  adc_ctrl_if.in            adc_if 

); 

time_if  time_info( );

vga_if   time_vga_if( );
vga_if   waveform_vga_if( );
vga_if   default_vga_if( );

watches #(

  .ST_MIN ( 16 ),
  .ST_HR  ( 22 )

)time_inst(

  .clk_i           ( clk_50_i                    ),
  .rst_i           ( rst_i                       ),

  .user_time_val_i ( watches_ctrl_if.usr_time_en ),
  .user_min_up_i   ( watches_ctrl_if.usr_min_up  ),
  .user_hour_up_i  ( watches_ctrl_if.usr_hour_up ),

  .sec_blnk_o      ( time_info.blink             ),
  .min_o           ( time_info.min               ),
  .hour_o          ( time_info.hour              ),
  .sec_o           ( time_info.sec               )

);

time_draw #(

  .BG_COLOR   ( `WIGHT ),
  .TIME_COLOR ( `BLACK )

) time_draw (
  
  .clk_50_i     ( clk_50_i    ),
  .clk_25_i     ( clk_25_i    ),

  .rst_i        ( rst_i       ),

  .time_info    ( time_info   ),

  .pix_if       ( pixels_if   ),

  .vga_if       ( time_vga_if )

);


defaul_draw def_draw (

  .pix_if ( pixels_if      ),
  .vga_if ( default_vga_if )

);


waveform_draw #(

  .WV_COLOR   ( `WIGHT          ),
  .BG_COLOR   ( `BLACK          ) 

) wv_draw (

  .clk_i      ( clk_50_i        ),
  .rst_i      ( rst_i           ),

  .adc_if     ( adc_if          ),

  .pixels_if  ( pixels_if       ),

  .wv_vga_if  ( waveform_vga_if )

);


vga_mux #(

  .DIR_CNT       ( 3               )

) vga_mux (

  .mod_i         ( show_mode_i      ),

  .vga_0_if      ( default_vga_if  ),
  .vga_1_if      ( time_vga_if     ),
  .vga_2_if      ( waveform_vga_if ),

  .vga_out_if    ( vga_out_if      ) 

);

endmodule
