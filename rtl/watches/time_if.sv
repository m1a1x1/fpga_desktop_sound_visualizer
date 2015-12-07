interface time_if;

  logic                    blink;
  logic  [$clog2(59)-1:0]  min;
  logic  [$clog2(59)-1:0]  hour;
  logic  [$clog2(59)-1:0]  sec;

modport in(

  input  blink,
  input  min,
  input  hour,
  input  sec

); 

modport out(

  output  blink,
  output  min,
  output  hour,
  output  sec

); 

endinterface
