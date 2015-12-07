`include "../defines/time_draw_def.vh"

module time_draw #(

  parameter BG_COLOR   = 3'b000,
  parameter TIME_COLOR = 3'b111,
  parameter PIX_X_W    = 12,
  parameter PIX_Y_W    = 12

)(

  input              clk_50_i,
  input              clk_25_i,

  input              rst_i,

  time_if.in         time_info,

  pixels_if.in       pix_if,

  vga_if.out         vga_if 

);

localparam VGA_D = 1;

logic                           cur_number_draw;

logic  [`DOT_W-1:0][`DOT_H-1:0] dot;

logic  [$clog2(10)-1:0]  hour_left_tmp;  
logic  [$clog2(10)-1:0]  hour_right_tmp; 

logic  [$clog2(10)-1:0]  min_left_tmp;   
logic  [$clog2(10)-1:0]  min_right_tmp;  

logic  [$clog2(10)-1:0]  sec_left_tmp;   
logic  [$clog2(10)-1:0]  sec_right_tmp;  

logic  [$clog2(10)-1:0]  hour_left_sync;  
logic  [$clog2(10)-1:0]  hour_right_sync; 

logic  [$clog2(10)-1:0]  min_left_sync;   
logic  [$clog2(10)-1:0]  min_right_sync;  

logic  [$clog2(10)-1:0]  sec_left_sync;   
logic  [$clog2(10)-1:0]  sec_right_sync;  

logic  [$clog2(10)-1:0]  cur_num;  

logic  [3:0]             cur_pos; 

logic  [PIX_X_W-1:0]     pos_x;
logic  [PIX_Y_W-1:0]     pos_y;

logic  [2:0]             vga_color;

logic  [VGA_D:1]         vga_vs_d;
logic  [VGA_D:1]         vga_hs_d;

logic  [VGA_D:1]         vga_de_d;

always_ff @( posedge clk_25_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        vga_vs_d <= '0;
        vga_hs_d <= '0;
                
        vga_de_d <= '0;
      end
    else
      begin
        vga_vs_d[1] <= pix_if.vs;
        vga_hs_d[1] <= pix_if.hs;
                
        vga_de_d[1] <= pix_if.de;
        for( int i = 2; i < VGA_D+1; i++ )
          begin
            vga_vs_d[i] <= vga_vs_d[i-1];
            vga_hs_d[i] <= vga_hs_d[i-1];
                    
            vga_de_d[i] <= vga_de_d[i-1];
          end
      end
  end


always_comb
  begin
    for( int i = 0; i < `DOT_W; i++ )
      begin
        for( int j = 0; j < `DOT_H; j++ )
          dot[i][j] = time_info.blink; 
      end
  end


always_comb
  begin
   hour_left_tmp  = time_info.hour / 10;
   hour_right_tmp = time_info.hour % 10;

   min_left_tmp   = time_info.min / 10;
   min_right_tmp  = time_info.min % 10;

   sec_left_tmp   = time_info.sec / 10;
   sec_right_tmp  = time_info.sec % 10;
  end


localparam H_LL_BORDER = `H_LL_BORDER;
localparam H_LR_BORDER = `H_LR_BORDER;

localparam H_TOP_BORDER = `H_TOP_BORDER;
localparam H_BOT_BORDER = `H_BOT_BORDER;

localparam H_RL_BORDER = `H_RL_BORDER;
localparam H_RR_BORDER = `H_RR_BORDER;

localparam M_LL_BORDER = `M_LL_BORDER;
localparam M_LR_BORDER = `M_LR_BORDER;

localparam M_TOP_BORDER = `M_TOP_BORDER;
localparam M_BOT_BORDER = `M_BOT_BORDER;

localparam M_RL_BORDER = `M_RL_BORDER;
localparam M_RR_BORDER = `M_RR_BORDER;

localparam S_LL_BORDER = `S_LL_BORDER;
localparam S_LR_BORDER = `S_LR_BORDER;

localparam S_TOP_BORDER = `S_TOP_BORDER;
localparam S_BOT_BORDER = `S_BOT_BORDER;

localparam S_RL_BORDER = `S_RL_BORDER;
localparam S_RR_BORDER = `S_RR_BORDER;

localparam DOT_L_BORDER = `DOT_L_BORDER;
localparam DOT_R_BORDER = `DOT_R_BORDER;

localparam DOT_TOP_BORDER = `DOT_TOP_BORDER;
localparam DOT_BOT_BORDER = `DOT_BOT_BORDER;

localparam HDOT_L_BORDER = `HDOT_L_BORDER;
localparam HDOT_TOP_BORDER = `HDOT_TOP_BORDER;

localparam HDOT_R_BORDER = `HDOT_R_BORDER;
localparam HDOT_BOT_BORDER = `HDOT_BOT_BORDER;

always_comb
  begin
    cur_pos = `BG;
    pos_x = '0;
    pos_y = '0;
    if( ( (  H_LL_BORDER  <= pix_if.x ) && ( pix_if.x <  H_LR_BORDER  ) ) &&
        ( (  H_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  H_BOT_BORDER ) )    )
      begin
        cur_pos = `H_LEFT;
        pos_x   = pix_if.x -  H_LL_BORDER;
        pos_y   = pix_if.y -  H_TOP_BORDER;
      end

    else

      begin
        if( ( (  H_RL_BORDER  <= pix_if.x ) && ( pix_if.x <  H_RR_BORDER  ) ) &&
            ( (  H_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  H_BOT_BORDER ) )    )
          begin
            cur_pos = `H_RIGHT;
            pos_x   = ( pix_if.x -  H_RL_BORDER );
            pos_y   = ( pix_if.y -  H_TOP_BORDER );
          end

        else
          begin
            if( ( (  M_LL_BORDER  <= pix_if.x ) && ( pix_if.x <  M_LR_BORDER  ) ) &&
                ( (  M_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  M_BOT_BORDER ) )    )
              begin
                cur_pos = `M_LEFT;
                pos_x   = pix_if.x -  M_LL_BORDER;
                pos_y   = pix_if.y -  M_TOP_BORDER;
              end
            else

              begin
                if( ( (  M_RL_BORDER  <= pix_if.x ) && ( pix_if.x <  M_RR_BORDER  ) ) &&
                    ( (  M_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  M_BOT_BORDER ) )   )
                  begin
                    cur_pos = `M_RIGHT;
                    pos_x   = pix_if.x -  M_RL_BORDER;
                    pos_y   = pix_if.y -  M_TOP_BORDER;
                  end

                else
                  begin
                    if( ( (  S_LL_BORDER  <= pix_if.x ) && ( pix_if.x <  S_LR_BORDER  ) ) &&
                        ( (  S_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  S_BOT_BORDER ) )   )
                      begin
                        cur_pos = `S_LEFT;
                        pos_x   = pix_if.x -  S_LL_BORDER;
                        pos_y   = pix_if.y -  S_TOP_BORDER;
                      end

                    else
                      begin
                        if( ( (  S_RL_BORDER  <= pix_if.x ) && ( pix_if.x <  S_RR_BORDER ) ) &&
                            ( (  S_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  S_BOT_BORDER ) )  )
                          begin
                            cur_pos = `S_RIGHT;
                            pos_x   = pix_if.x -  S_RL_BORDER;
                            pos_y   = pix_if.y -  S_TOP_BORDER;
                          end

                        else
                          begin
                            if( ( (  DOT_L_BORDER   <= pix_if.x ) && ( pix_if.x <  DOT_R_BORDER   ) ) &&
                                ( (  DOT_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  DOT_BOT_BORDER ) )   )
                              begin
                                cur_pos = `DOT;
                                pos_x   = pix_if.x -  DOT_L_BORDER;
                                pos_y   = pix_if.y -  DOT_TOP_BORDER;
                              end

                            else
                              begin
                                if( ( (  HDOT_L_BORDER   <= pix_if.x ) && ( pix_if.x <  HDOT_R_BORDER   ) ) &&
                                    ( (  HDOT_TOP_BORDER <= pix_if.y ) && ( pix_if.y <  HDOT_BOT_BORDER ) )   )
                                  begin
                                    cur_pos = `HDOT;
                                    pos_x   = pix_if.x -  HDOT_L_BORDER;
                                    pos_y   = pix_if.y -  HDOT_TOP_BORDER;
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end

always_comb
  begin
    if( cur_pos == `BG )
      vga_color = BG_COLOR;
    else
      begin
        if( cur_pos == `DOT )
          vga_color =( dot[pos_x][pos_y] ) ? ( TIME_COLOR ) :
                                          ( BG_COLOR   );
        else
          if( cur_pos == `HDOT )
            vga_color = TIME_COLOR;
          else
            vga_color = cur_number_draw ? ( TIME_COLOR ) :
                                          ( BG_COLOR   );
      end
  end

num_sync #(

  .NUM_W          ( $clog2(10)     ),
  .SYNC_D         ( 3              )

) num_sync_inst(

  .clk_sync_i     ( clk_25_i       ),
  
  .rst_i          ( rst_i          ),

  .num_1_i        ( hour_left_tmp  ),           
  .num_2_i        ( hour_right_tmp ),           
  .num_3_i        ( min_left_tmp   ),           
  .num_4_i        ( min_right_tmp  ),           
  .num_5_i        ( sec_left_tmp   ),           
  .num_6_i        ( sec_right_tmp  ),           


  .sync_num_1_o   ( hour_left_sync  ),           
  .sync_num_2_o   ( hour_right_sync ),           
  .sync_num_3_o   ( min_left_sync   ),           
  .sync_num_4_o   ( min_right_sync  ),           
  .sync_num_5_o   ( sec_left_sync   ),           
  .sync_num_6_o   ( sec_right_sync  )           

);

always_comb
  begin
    case( cur_pos )
      `H_LEFT:  begin
                  cur_num = hour_left_sync;
                end

      `H_RIGHT:  begin
                   cur_num = hour_right_sync;
                 end

      `M_LEFT:  begin
                  cur_num = min_left_sync;
                end

      `M_RIGHT:  begin
                   cur_num = min_right_sync;
                 end

      `S_LEFT:  begin
                  cur_num = sec_left_sync;
                end

      `S_RIGHT:  begin
                   cur_num = sec_right_sync;
                 end

      default:  begin
                  cur_num = '0;
                end
    endcase
  end


num_to_pix #(

  .NUM_W     ( $clog2( 10 )    ),

  .PIX_X_W   ( PIX_X_W         ),
  .PIX_Y_W   ( PIX_Y_W         ),
  
  .MAX_X     ( `NUM_W          )

) num_to_pix_inst (

  .clk_i     ( clk_25_i        ),
  .rst_i     ( rst_i           ),

  .num_i     ( cur_num         ),
  
  .pos_x_i   ( pos_x           ),
  .pos_y_i   ( pos_y           ),
  
  .pix_o     ( cur_number_draw )

);


assign vga_if.red   = ( vga_de_d[VGA_D] ) ? ( vga_color[2] ) : 1'b0;
assign vga_if.green = ( vga_de_d[VGA_D] ) ? ( vga_color[1] ) : 1'b0;
assign vga_if.blue  = ( vga_de_d[VGA_D] ) ? ( vga_color[0] ) : 1'b0; 

assign vga_if.hs = vga_hs_d[VGA_D];
assign vga_if.vs = vga_vs_d[VGA_D];

endmodule
