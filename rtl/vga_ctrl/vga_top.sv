//TODO CGH5 2KAB02;OBL =>2>5 87>1@045=85 ?> ?>;>6B5;L=><C D@>=BC vga_hs (8A?>;L7>20BL 2K45;8B5;L D@>=B0)
`define RST_IMG   2'd0
`define TIME      2'd1
`define WAVEFORM  2'd2
module vga_top(

 input         clk_50_i,
 input         rst_i,

 input [1:0]   show_mode,

 input         waveform,
 input         spectrun,
 time_if.in    time_info,

 output        vga_hs_o,
 output        vga_vs_o,
 output logic  vga_r_o,
 output logic  vga_g_o,
 output logic  vga_b_o

);

localparam PIX_WIDTH = 12;

localparam H_DISP   = 640;
localparam H_FPORCH = 16;
localparam H_SYNC   = 96;
localparam H_BPORCH = 48;
localparam V_DISP   = 480;
localparam V_FPORCH = 10;
localparam V_SYNC   = 2;
localparam V_BPORCH = 33;



logic      pix_hs;
logic      pix_vs;
logic      pix_de;

pll vga_pll(

  .inclk0 ( clk_50_i ),
  .c0     ( clk_25   )

);

logic [PIX_WIDTH-1:0] pix_x;
logic [PIX_WIDTH-1:0] pix_y;

vga_time_generator vga_time_generator_instance(
  .clk                 ( clk_25   ),
  .reset_n             ( ~rst_i   ),

  .h_disp              ( H_DISP   ),
  .h_fporch            ( H_FPORCH ),
  .h_sync              ( H_SYNC   ),
  .h_bporch            ( H_BPORCH ),
                              
  .v_disp              ( V_DISP   ),
  .v_fporch            ( V_FPORCH ),
  .v_sync              ( V_SYNC   ),
  .v_bporch            ( V_BPORCH ),
  .hs_polarity         ( 1'b0     ),
  .vs_polarity         ( 1'b0     ),
  .frame_interlaced    ( 1'b0     ),
                  
  .vga_hs              ( pix_hs   ),
  .vga_vs              ( pix_vs   ),
  .vga_de              ( pix_de   ),
  .pixel_x             ( pix_x    ),
  .pixel_y             ( pix_y    ),
  .pixel_i_odd_frame   (          )

);

logic                 pix_hs_d1;
logic                 pix_vs_d1;
logic                 pix_de_d1;

always_ff @( posedge clk_25 or posedge rst_i )
  begin
    if( rst_i )
      begin
        pix_hs_d1 <= 0;
        pix_vs_d1 <= 0;
        pix_de_d1 <= 0;
      end
    else
      begin
        // delay because draw_strings/field got latency
        pix_hs_d1 <= pix_hs;
        pix_vs_d1 <= pix_vs;
        pix_de_d1 <= pix_de;
      end
  end

assign vga_hs_o = pix_hs_d1;
assign vga_vs_o = pix_vs_d1;

logic [2:0]  vga_data;
logic [2:0]  vga_data_tmp;

localparam R = 80;

time_draw time_draw(

  .clk_i        ( clk_25_i  ),
  .rst_i        ( rst_i     ),

  .time_info    ( time_info ),
  .cur_x_i      ( pix_x     ),
  .cur_y_i      ( pix_y     ),

  .vga_data_o   ( vga_time  )
);


always_comb 
  begin
    case( show_mode )
      `RST_IMG:
         begin
           vga_data_tmp = 3'b000;
         end
      `TIME:
         begin
           vga_data_tmp = vga_time;
         end
      default:
        begin
           vga_data_tmp = 3'b111;
        end
    endcase
  end

assign vga_data = ( pix_de_d1 ) ? vga_data_tmp : 0;

always_ff @( posedge clk_25 or posedge rst_i )
  begin
    if( rst_i )
      begin
        vga_r_o <= 0;
        vga_g_o <= 0;
        vga_b_o <= 0;
      end
    else
      begin
        vga_r_o <= vga_data[0];
        vga_g_o <= vga_data[1];
        vga_b_o <= vga_data[2];
      end
  end

endmodule
