module num_sync #(

  parameter NUM_W = 3,
  parameter SYNC_D = 3

) (

  input               clk_sync_i,
  
  input               rst_i,

  input [NUM_W-1:0]   num_1_i,           
  input [NUM_W-1:0]   num_2_i,           
  input [NUM_W-1:0]   num_3_i,           
  input [NUM_W-1:0]   num_4_i,           
  input [NUM_W-1:0]   num_5_i,           
  input [NUM_W-1:0]   num_6_i,           


  output logic [NUM_W-1:0]  sync_num_1_o,           
  output logic [NUM_W-1:0]  sync_num_2_o,           
  output logic [NUM_W-1:0]  sync_num_3_o,           
  output logic [NUM_W-1:0]  sync_num_4_o,           
  output logic [NUM_W-1:0]  sync_num_5_o,           
  output logic [NUM_W-1:0]  sync_num_6_o           

);

logic [SYNC_D:1][NUM_W-1:0] num_1_d;
logic [SYNC_D:1][NUM_W-1:0] num_2_d;
logic [SYNC_D:1][NUM_W-1:0] num_3_d;
logic [SYNC_D:1][NUM_W-1:0] num_4_d;
logic [SYNC_D:1][NUM_W-1:0] num_5_d;
logic [SYNC_D:1][NUM_W-1:0] num_6_d;

always_ff @( posedge clk_sync_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        num_1_d <= '0;     
        num_2_d <= '0;
        num_3_d <= '0;
        num_4_d <= '0;
        num_5_d <= '0;
        num_6_d <= '0;
      end
    else
      begin
        num_1_d[1] <= num_1_i;
        num_2_d[1] <= num_2_i;
        num_3_d[1] <= num_3_i;
        num_4_d[1] <= num_4_i;
        num_5_d[1] <= num_5_i;
        num_6_d[1] <= num_6_i;

        for( int i = 2; i < SYNC_D+1; i++ )
          begin
            num_1_d[i] <= num_1_d[i-1];
            num_2_d[i] <= num_2_d[i-1];
            num_3_d[i] <= num_3_d[i-1];
            num_4_d[i] <= num_4_d[i-1];
            num_5_d[i] <= num_5_d[i-1];
            num_6_d[i] <= num_6_d[i-1];
          end
      end
  end

always_comb
  begin
    sync_num_1_o = num_1_d[SYNC_D];
    sync_num_2_o = num_2_d[SYNC_D];
    sync_num_3_o = num_3_d[SYNC_D];
    sync_num_4_o = num_4_d[SYNC_D];
    sync_num_5_o = num_5_d[SYNC_D];
    sync_num_6_o = num_6_d[SYNC_D];
  end

endmodule
