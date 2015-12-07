module min_cnt #(

  parameter ST_MIN = 0

)
(

  input                         clk_i,
  input                         rst_i,
 
  input                         user_min_up_i,
  input                         user_time_val_i,

  input        [$clog2(59)-1:0] sec_i,
  
  input                         last_tact_i,

  output logic [$clog2(59)-1:0] min_o

);

logic [$clog2(59)-1:0] user_min;

logic                  min_up;
logic                  min_up_d;

logic                  min_up_ena;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        min_up   <= 0;
        min_up_d <= 0;        
      end
    else
      begin
        min_up   <= user_min_up_i;
        min_up_d <= min_up;
      end
  end

assign min_up_ena = min_up & ~min_up_d;

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        user_min <= 0;
      end
    else
      begin
        if( user_time_val_i )
          begin
            if( ( user_min == 59 ) & ( min_up_ena ) )
              begin
                user_min <= 0;
              end
            else
              begin
                if( min_up_ena )
                  begin
                    user_min <= user_min + 1;
                  end
              end
          end
        else
          begin
            user_min <= min_o;
          end
      end
  end


always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        min_o <= ST_MIN;
      end
    else
      begin
        if( user_time_val_i )
          begin
            min_o <= user_min;
          end
        else
          begin
            if( ( min_o == 59 ) & ( sec_i == 59 ) & last_tact_i )
              begin
                min_o <= 0;
              end
            else
              begin
                if( ( sec_i == 59 ) & last_tact_i )
                  min_o <= min_o + 1; 
              end
          end
      end 
  end

endmodule
