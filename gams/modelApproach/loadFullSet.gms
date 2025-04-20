Sets
*scenario sets
s_in_RL                / s0*s51/
s_out_RL            / s0*s51/
s_DA                   / s0*s51/
s_in_RA             / s0*s51/
s_out_RA            / s0*s51/
t_block                / b1*b2000 /
t_hour             / h1*h8000 /   
t_quarter          / q1*q32000 /
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;
