Sets
*scenario sets
s_in_RL                /s5, s10, s15/
s_out_RL            /s5, s10, s15/
s_DA                   /s5, s10, s15/
s_in_RA             /s5, s10, s15/
s_out_RA            /s5, s10, s15/
t_block                / b1*b6 /
t_hour             / h1*h24 /   
t_quarter          / q1*q96 /
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;
