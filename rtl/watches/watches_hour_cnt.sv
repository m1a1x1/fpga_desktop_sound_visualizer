module hour_cnt #(

  parameter ST_HR = 0

)(

  input                         clk_i,
  input                         rst_i,
 
  input                         user_hour_up_i,
  input                         user_time_val_i,

  input        [$clog2(59)-1:0] sec_i,
  input        [$clog2(59)-1:0] min_i,

  input                         last_tact_i,

  output logic [$clog2(59)-1:0] hour_o

);

logic [$clog2(59)-1:0] user_hour;

logic                  hour_up;
logic                  hour_up_d;

logic                  hour_up_ena;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        hour_up   <= 0;
        hour_up_d <= 0;        
      end
    else
      begin
        hour_up   <= user_hour_up_i;
        hour_up_d <= hour_up;
      end
  end

assign hour_up_ena = hour_up & ~hour_up_d;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        user_hour <= 0;
      end
    else
      begin
        if( user_time_val_i )
          begin
            if( ( user_hour == 23 ) & ( hour_up_ena ) )
              begin
                user_hour <= 0;
              end
            else
              begin
                if( hour_up_ena )
                  begin
                    user_hour <= user_hour + 1;
                  end
              end
          end
        else
          begin
            user_hour <= hour_o;
          end
      end
  end


always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        hour_o <= ST_HR;
      end
    else
      begin
        if( user_time_val_i )
          begin
            hour_o <= user_hour;
          end
        else
          begin
            if( ( hour_o == 23 ) & ( min_i == 59 ) & ( sec_i == 59 ) & last_tact_i )
              begin
                hour_o <= 0;
              end
            else
              begin
                if( ( min_i == 59 ) & ( sec_i == 59 ) & last_tact_i )
                  hour_o <= hour_o + 1; 
              end
          end
      end 
  end

endmodule
