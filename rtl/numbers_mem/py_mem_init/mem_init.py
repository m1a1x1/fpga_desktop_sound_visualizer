from PIL import Image

MIF_HEAD = """DEPTH = 8192;
WIDTH = 1;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;

CONTENT
BEGIN"""

MIF_ENDING = "END;"

def get_string( im ):

  raw = ""
  mem = ""

  for i in range( 100 ):
    print( raw )
    raw=""
    for j in range( 80 ):
      pix = im.getpixel( (j, i) )
      if( pix[0] > 120 ):
        color = 0;
      else:
        color = 1;
      raw = raw + str(color)
      mem = mem + hex(80*i+j)[2:] + " : " + str(color) + ";\n"

  return( mem )

def write_file( fname, header, content, ending):
  f = open(fname, 'w')
  f.write( header + "\n\n" + content + "\n\n" + ending)
  f.close()

all_img = [0,1,2,3,4,5,6,7,8,9]

all_img[0] = Image.open("0.jpg")
all_img[1] = Image.open("1.jpg")
all_img[2] = Image.open("2.jpg")
all_img[3] = Image.open("3.jpg")
all_img[4] = Image.open("4.jpg")
all_img[5] = Image.open("5.jpg")
all_img[6] = Image.open("6.jpg")
all_img[7] = Image.open("7.jpg")
all_img[8] = Image.open("8.jpg")
all_img[9] = Image.open("9.jpg")

for i in range(10):
  mem_init_data = get_string( all_img[i] )
  mem_fname = "../" + str(i) + ".mif"
  write_file( mem_fname, MIF_HEAD, mem_init_data, MIF_ENDING)

