interface pixels_if;

parameter PIX_X_W = 12;
parameter PIX_Y_W = 12;

  logic                hs;
  logic                vs;
  logic                de;
  logic [PIX_X_W-1:0]  x;
  logic [PIX_Y_W-1:0]  y;

modport in(

  input  hs,
         vs,
         de,
         x,
         y

);

modport out(

  output  hs,
          vs,
          de,
          x,
          y

); 

endinterface
