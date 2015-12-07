module defaul_draw(

  pixels_if.in  pix_if,
  vga_if.out    vga_if

);

always_comb
  begin
    vga_if.red = ( pix_if.de ) ? ( 1'b1 ) : ( 1'b0 );
    vga_if.green = ( pix_if.de ) ? ( 1'b1 ) : ( 1'b0 );
    vga_if.blue = ( pix_if.de ) ? ( 1'b1 ) : ( 1'b0 );
    vga_if.hs = pix_if.hs;
    vga_if.vs = pix_if.vs;
  end

endmodule
