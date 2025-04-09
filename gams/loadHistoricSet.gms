Sets
*scenario sets
s_in_RL                	/s0, s5, s7, s8, s9, s10, s11, s12, s13, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RL            	/s0, s5, s7, s8, s9, s10, s11, s12, s13, s15, s20, s25, s30, s35, s40, s45, s50/
s_DA                   	/s0, s5, s7, s8, s9, s10, s11, s12, s13, s15, s20, s25, s30, s35, s40, s45, s50/
s_in_RA             	/s0, s5, s7, s8, s9, s10, s11, s12, s13, s15, s20, s25, s30, s35, s40, s45, s50/
s_out_RA            	/s0, s5, s7, s8, s9, s10, s11, s12, s13, s15, s20, s25, s30, s35, s40, s45, s50/
t_block                	/ b0*b5/
t_hour             		/ h0*h23 /   
t_quarter          		/ q0*q95 /
ser                 	/ser1 * ser8/
s_RA                	/s1*s10/
;

Sets
*time mapping
map_quarter_hour(t_quarter, t_hour)
map_quarter_block(t_quarter, t_block)
map_hour_block(t_hour, t_block); 
;
