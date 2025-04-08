Sets
*scenario sets
s_in_RL                	/s0, s5, s10, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RL            	/s0, s5, s10, s15, s20, s25, s30, s35, s40, s45, s50/
s_DA                   	/s0, s5, s10, s15, s20, s25, s30, s35, s40, s45, s50/
s_in_RA             	/s0, s5, s10, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RA            	/s0, s5, s10, s15, s20, s25, s30, s35, s40, s45, s50/
t_block                	/ b4*b4/
t_hour             		/ h16*h19 /   
t_quarter          		/ q64*q79 /
ser                 	/ser1 * ser8/
s_RA                	/s1*s10/
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;
