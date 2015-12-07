interface vga_if;

  logic   hs;
  logic   vs;
  logic   red;
  logic   green;
  logic   blue;

modport in(

  input  hs,
         vs,
         red,
         green,
         blue

);

modport out(

  output  hs,
          vs,
          red,
          green,
          blue

); 

endinterface
