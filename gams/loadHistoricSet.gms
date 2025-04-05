Sets
*scenario sets
s_in_RL                	/s0, s5, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RL            	/s0, s5, s15, s20, s25, s30, s35, s40, s45, s50/
s_DA                   	/s0, s5, s15, s20, s25, s30, s35, s40, s45, s50/
s_in_RA             	/s0, s5, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RA            	/s0, s5, s15, s20, s25, s30, s35, s40, s45, s50/
t_block                	/ b1*b6 /
t_hour             		/ h1*h24 /   
t_quarter          		/ q1*q96 /
ser                 	/ser1 * ser8/
s_RA                	/s1*s10/
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;
