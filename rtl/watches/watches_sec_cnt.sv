`include "../defines/waveform_defines.vh"

module sec_cnt #(

  parameter CLK_FREQ = 50

) (

  input                           clk_i,
  input                           rst_i,
 
  input                           user_time_val_i,

  output logic [$clog2( 59 )-1:0] sec_o,

  output                          last_tact_o

);

logic [$clog2( CLK_FREQ*(10**6) )-1:0] tacts_cnt;
logic                                last_tact_w;

assign last_tact_o = last_tact_w; 

generate
  if( `SIM == 1'b1 )
    assign last_tact_w = ( tacts_cnt == ( CLK_FREQ - 1 ) );
  else
    assign last_tact_w = ( tacts_cnt == ( CLK_FREQ*(10**6) - 1 ) );
endgenerate
 
always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        tacts_cnt <= 0;
        sec_o     <= 0;
      end
    else
      begin
        if( user_time_val_i || ( ( sec_o == 59 ) && ( last_tact_w ) ) )
          begin
            tacts_cnt <= 0;
            sec_o     <= 0;
          end
        else
          begin
            if( last_tact_o )
              begin
                sec_o     <= sec_o + 1;
                tacts_cnt <= 0;
              end
            else
              begin
                sec_o     <= sec_o;
                tacts_cnt <= tacts_cnt + 1; 
              end
          end
      end 
  end



endmodule
