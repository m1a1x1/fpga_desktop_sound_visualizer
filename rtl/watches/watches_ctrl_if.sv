interface watches_ctrl_if;

  logic     usr_time_en;
  logic     usr_min_up;
  logic     usr_hour_up;

modport in(

  input  usr_time_en,
         usr_min_up,
         usr_hour_up

);

modport out(

  output  usr_time_en,
          usr_min_up,
          usr_hour_up

); 

endinterface
