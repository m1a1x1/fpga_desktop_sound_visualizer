`define NUM_W 12'd80
`define NUM_H 12'd100

`define DOT_W 'd10
`define DOT_H 'd10

`define BG      4'd0
`define H_LEFT  4'd1
`define H_RIGHT 4'd2
`define M_LEFT  4'd3
`define M_RIGHT 4'd4
`define S_LEFT  4'd5
`define S_RIGHT 4'd6
`define DOT     4'd7
`define HDOT    4'd8

`define L_OFFSET 12'd40

`define H_TOP_BORDER 12'd190
`define H_BOT_BORDER `H_TOP_BORDER + `NUM_H
`define M_TOP_BORDER 12'd190
`define M_BOT_BORDER `M_TOP_BORDER + `NUM_H
`define S_TOP_BORDER 12'd190
`define S_BOT_BORDER `M_TOP_BORDER + `NUM_H

`define H_LL_BORDER `L_OFFSET 
`define H_LR_BORDER `L_OFFSET + `NUM_W

`define H_RL_BORDER `H_LR_BORDER
`define H_RR_BORDER `H_RL_BORDER + `NUM_W

`define HDOT_L_BORDER `H_RR_BORDER + 12'd5
`define HDOT_R_BORDER `HDOT_L_BORDER + `DOT_W

`define HDOT_TOP_BORDER `H_BOT_BORDER - `DOT_H 
`define HDOT_BOT_BORDER `DOT_TOP_BORDER + `DOT_H

`define M_LL_BORDER `HDOT_R_BORDER + 12'd5
`define M_LR_BORDER `M_LL_BORDER + `NUM_W

`define M_RL_BORDER `M_LR_BORDER
`define M_RR_BORDER `M_RL_BORDER + `NUM_W

`define DOT_L_BORDER `M_RR_BORDER + 12'd5
`define DOT_R_BORDER `DOT_L_BORDER + `DOT_W

`define DOT_TOP_BORDER `H_BOT_BORDER - `DOT_H 
`define DOT_BOT_BORDER `DOT_TOP_BORDER + `DOT_H

`define S_LL_BORDER `DOT_R_BORDER + 12'd5
`define S_LR_BORDER `S_LL_BORDER + `NUM_W

`define S_RL_BORDER `S_LR_BORDER 
`define S_RR_BORDER `S_LR_BORDER + `NUM_W 
