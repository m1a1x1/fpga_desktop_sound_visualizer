module waveform_draw #(

  parameter WV_COLOR = 3'b000,
  parameter BG_COLOR = 3'b111

)(

  input           clk_i,
  input           rst_i,

  adc_ctrl_if.in  adc_if,

  pixels_if.in    pixels_if,

  vga_if.out      wv_vga_if

);

localparam WV_SCREEN_CNT = 3; // Сколько "экранов" держться 1 картинка

localparam VGA_D = 1;

logic [11:0] adc_data;
logic        adc_data_val;

logic [11:0] adc_fifo_data;

logic [11:0] adc_ram_data;

logic  [VGA_D:1]         vga_vs_d;
logic  [VGA_D:1]         vga_hs_d;

logic  [VGA_D:1]         vga_de_d;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        vga_vs_d <= '0;
        vga_hs_d <= '0;
                
        vga_de_d <= '0;
      end
    else
      begin
        vga_vs_d[1] <= pixels_if.vs;
        vga_hs_d[1] <= pixels_if.hs;
                
        vga_de_d[1] <= pixels_if.de;
        for( int i = 2; i < VGA_D+1; i++ )
          begin
            vga_vs_d[i] <= vga_vs_d[i-1];
            vga_hs_d[i] <= vga_hs_d[i-1];
                    
            vga_de_d[i] <= vga_de_d[i-1];
          end
      end
  end

// Понижение скорости потока данныйх
adc_resampler #(

  .IN_SAMP_FRQ  ( 500000 ),
  .OUT_SAMP_FRQ ( 12500  )

) adc_resp (

  .clk_i          ( clk_i        ),
  .rst_i          ( rst_i        ),

  .adc_if         ( adc_if       ),

  .adc_data_o     ( adc_data     ),
  .adc_data_val_o ( adc_data_val )

);

// Временное храненние данных на 1 экран

logic fifo_afull;
logic fifo_empty;
logic fifo_rd;

logic ram_wr_en;

one_screen_fifo screen_fifo(

	.clock       ( clk_i        ),
	.data        ( adc_data     ),
	.rdreq       ( ram_wr_en    ),
	.wrreq       ( adc_data_val ),
	.almost_full ( fifo_afull   ),
	.empty       ( fifo_empty   ),
	.full        ( ),
	.q           ( adc_fifo_data )

);


// synthesis translate_off 

//assert property ( !(adc_data_val && fifo_afull) );

//assert property ( !(ram_wr_en && fifo_empty));

// synthesis translate_on 



// RAM память на экран

logic ram_wr_addr; 

logic [$clog2(640) - 1 : 0] screen_sampl_cnt;

one_screen_ram screen_ram (

	.clock       ( clk_i            ),
	.data        ( adc_fifo_data    ),
	.rdaddress   ( pixels_if.y      ),
	.wraddress   ( screen_sampl_cnt ),
	.wren        ( ram_wr_en        ),
	.q           ( adc_ram_data     )

);

logic [$clog2(60)-1:0] same_screen_cnt;

logic last_screen_pix;

logic out_of_screen;

assign last_screen_pix = ( ( pixels_if.x == 639 ) && ( pixels_if.y == 479 ) );

assign out_of_screen = ( ( pixels_if.x > 639 ) && ( pixels_if.y > 479 ) );

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      same_screen_cnt <= '0;
    else
      begin
        if( ( same_screen_cnt == (WV_SCREEN_CNT-1) ) && ( last_screen_pix ) )
          same_screen_cnt <= '0;
        else
          if( last_screen_pix )
            same_screen_cnt <= same_screen_cnt + 1;      
      end
  end

assign new_ram_en = ( out_of_screen && ( same_screen_cnt == ( WV_SCREEN_CNT - 1 ) ) );


always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      screen_sampl_cnt <= '0;
    else
      begin
        if( screen_sampl_cnt == 0 )
          begin
            if( new_ram_en && fifo_afull )
              screen_sampl_cnt <= 1;
          end
        else
          begin
            if( screen_sampl_cnt == 639 )
              screen_sampl_cnt <= 0;
            else 
              screen_sampl_cnt <= screen_sampl_cnt + 1;
          end
      end
        
  end

assign ram_wr_en = ( ( new_ram_en && fifo_afull ) || ( screen_sampl_cnt > 0 ) );

logic [2:0] vga_tmp_data;

assign vga_tmp_data = ( ( pixels_if.y == adc_ram_data ) ? ( WV_COLOR ) : ( BG_COLOR ) ); 

assign wv_vga_if.red   = ( vga_de_d[VGA_D] ) ? ( vga_tmp_data[2] ) : 1'b0;
assign wv_vga_if.green = ( vga_de_d[VGA_D] ) ? ( vga_tmp_data[1] ) : 1'b0;
assign wv_vga_if.blue  = ( vga_de_d[VGA_D] ) ? ( vga_tmp_data[0] ) : 1'b0; 

assign wv_vga_if.hs = vga_hs_d[VGA_D];
assign wv_vga_if.vs = vga_vs_d[VGA_D];

endmodule
