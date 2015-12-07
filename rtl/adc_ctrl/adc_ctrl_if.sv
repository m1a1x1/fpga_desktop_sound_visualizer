interface adc_ctrl_if;

  logic                go;
  logic                done;
  logic  [11:0]        data;

modport in(

  output  go,
  input   done,
          data

);

modport out(

  output  go,
  input   done,
          data

); 

endinterface
