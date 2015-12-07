`include "../defines/waveform_defines.vh"

module top_tb;

timeunit           1ns;
timeprecision      0.1ns;

logic clk_50;
logic clk_25;

logic rst;

bit rst_done;

initial
  begin
    clk_50 = 1'b0;
    forever
      begin
        #10 clk_50 = !clk_50;
      end
  end

initial
  begin
    clk_25 = 1'b0;
    forever
      begin
        #20 clk_25 = !clk_25;
      end
  end

initial
  begin
    rst = 1'b0;
    #43;
    rst = 1'b1;
    #55;
    rst = 1'b0;

    rst_done = 1'b1;
    $display( "RESET DONE" );
  end

logic [1:0] show_type;

initial
  begin
    show_type <= `TIME;
  end

pixels_if #( .PIX_X_W ( 12 ),
             .PIX_Y_W ( 12 )  ) pixels_if( );

initial
  begin
    wait( rst_done );
      for( int k = 0; k < 10; k++ )  
        @( posedge clk_25 );
        @( posedge clk_25 );
        @( posedge clk_25 );
        pixels_if.hs <= '0;
        pixels_if.vs <= '0;
        pixels_if.de <= '0;
        pixels_if.x  <= '0;
        pixels_if.y  <= '0;
        for( int i = 0; i < 480; i++ )
          begin
            pixels_if.y  <= i;
            @( posedge clk_25 );
            @( posedge clk_25 );
            @( posedge clk_25 );
            pixels_if.hs <= 1'b0;
            pixels_if.x  <= '0;
            for( int j = 0; j < 640; j++ )
              begin
                pixels_if.x <= j;
                @( posedge clk_25 );
                @( posedge clk_25 );
              end

            pixels_if.hs <= 1'b1;
          end

        pixels_if.vs <= 1'b1;
        @( posedge clk_25 );
        @( posedge clk_25 );
        @( posedge clk_25 );
  end


watches_ctrl_if watches_ctrl_if( );

vga_if vga_if( );

initial
  begin
    watches_ctrl_if.usr_time_en = '0;
    watches_ctrl_if.usr_min_up = '0;
    watches_ctrl_if.usr_hour_up = '0;
  end

adc_ctrl_if adc_if( );

initial
  begin
  adc_if.done <= 1'b0;
  adc_if.data <= '0;
    wait( rst_done );
      forever
      @( posedge clk_50 );
      if( adc_if.go )
        begin
          @( posedge clk_50 );
          @( posedge clk_50 );
          adc_if.done <= 1'b1;
          adc_if.data <= adc_if.data + 1;
          if( adc_if.go )
            begin
              @( posedge clk_50 );
              adc_if.done <= 1'b0;
            end
          else
            adc_if.done <= 1'b0;
        end
  end

main_waveform main (

  .clk_50_i         ( clk_50    ),
  .clk_25_i         ( clk_25    ),

  .rst_i            ( rst       ),

  .show_mode_i      ( show_type ),
   
  .pixels_if        ( pixels_if ),
  
  .watches_ctrl_if  ( watches_ctrl_if ),

  .vga_out_if       ( vga_if    ),

  .adc_if           ( adc_if    )

);

endmodule
