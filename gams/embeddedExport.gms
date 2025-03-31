
EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_in_RL
- Projection:
	name: Q_in_RL.l(t_block, s_in_RL)
	newName: Q_in_RL_level(t_block, s_in_RL)
- ExcelWriter:
	file: Q_in_RL.xlsx
	symbols:
		- name: Q_in_RL_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_out_RL
- Projection:
	name: Q_out_RL.l(t_block, s_out_RL)
	newName: Q_out_RL_level(t_block, s_out_RL)
- ExcelWriter:
	file: Q_out_RL.xlsx
	symbols:
		- name: Q_out_RL_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rB_DA
- Projection:
	name: Q_rB_DA.l(t_hour)
	newName: Q_rB_DA_level(t_hour)
- ExcelWriter:
	file: Q_rB_DA.xlsx
	symbols:
		- name: Q_rB_DA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_outrB_RA
- Projection:
	name: Q_outrB_RA.l(t_quarter, s_out_RA)
	newName: Q_outrB_RA_level(t_quarter, s_out_RA)
- ExcelWriter:
	file: Q_outrB_RA.xlsx
	symbols:
		- name: Q_outrB_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_inrB_RA
- Projection:
	name: Q_inrB_RA.l(t_quarter, s_in_RA)
	newName: Q_inrB_RA_level(t_quarter, s_in_RA)
- ExcelWriter:
	file: Q_inrB_RA.xlsx
	symbols:
		- name: Q_inrB_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rB_reload
- Projection:
	name: Q_rB_reload.l(t_hour)
	newName: Q_rB_reload_level(t_hour)
- ExcelWriter:
	file: Q_rB_reload.xlsx
	symbols:
		- name: Q_rB_reload_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_outrI_RA
- Projection:
	name: Q_outrI_RA.l(t_quarter, s_out_RA)
	newName: Q_outrI_RA_level(t_quarter, s_out_RA)
- ExcelWriter:
	file: Q_outrI_RA.xlsx
	symbols:
		- name: Q_outrI_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_inrI_RA
- Projection:
	name: Q_inrI_RA.l(t_quarter, s_in_RA)
	newName: Q_inrI_RA_level(t_quarter, s_in_RA)
- ExcelWriter:
	file: Q_inrI_RA.xlsx
	symbols:
		- name: Q_inrI_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rI_DA
- Projection:
	name: Q_rI_DA.l(t_hour)
	newName: Q_rI_DA_level(t_hour)
- ExcelWriter:
	file: Q_rI_DA.xlsx
	symbols:
		- name: Q_rI_DA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rI_reload
- Projection:
	name: Q_rI_reload.l(t_hour)
	newName: Q_rI_reload_level(t_hour)
- ExcelWriter:
	file: Q_rI_reload.xlsx
	symbols:
		- name: Q_rI_reload_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_outrO_RA
- Projection:
	name: Q_outrO_RA.l(t_quarter, s_out_RA)
	newName: Q_outrO_RA_level(t_quarter, s_out_RA)
- ExcelWriter:
	file: Q_outrO_RA.xlsx
	symbols:
		- name: Q_outrO_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_inrO_RA
- Projection:
	name: Q_inrO_RA.l(t_quarter, s_in_RA)
	newName: Q_inrO_RA_level(t_quarter, s_in_RA)
- ExcelWriter:
	file: Q_inrO_RA.xlsx
	symbols:
		- name: Q_inrO_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rO_DA
- Projection:
	name: Q_rO_DA.l(t_hour)
	newName: Q_rO_DA_level(t_hour)
- ExcelWriter:
	file: Q_rO_DA.xlsx
	symbols:
		- name: Q_rO_DA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rO_reload
- Projection:
	name: Q_rO_reload.l(t_hour)
	newName: Q_rO_reload_level(t_hour)
- ExcelWriter:
	file: Q_rO_reload.xlsx
	symbols:
		- name: Q_rO_reload_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_outrN_RA
- Projection:
	name: Q_outrN_RA.l(t_quarter, s_out_RA)
	newName: Q_outrN_RA_level(t_quarter, s_out_RA)
- ExcelWriter:
	file: Q_outrN_RA.xlsx
	symbols:
		- name: Q_outrN_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_inrN_RA
- Projection:
	name: Q_inrN_RA.l(t_quarter, s_in_RA)
	newName: Q_inrN_RA_level(t_quarter, s_in_RA)
- ExcelWriter:
	file: Q_inrN_RA.xlsx
	symbols:
		- name: Q_inrN_RA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rN_DA
- Projection:
	name: Q_rN_DA.l(t_hour)
	newName: Q_rN_DA_level(t_hour)
- ExcelWriter:
	file: Q_rN_DA.xlsx
	symbols:
		- name: Q_rN_DA_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rN_reload
- Projection:
	name: Q_rN_reload.l(t_hour)
	newName: Q_rN_reload_level(t_hour)
- ExcelWriter:
	file: Q_rN_reload.xlsx
	symbols:
		- name: Q_rN_reload_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_rB_reload
- Projection:
	name: Q_rB_reload.l(t_hour)
	newName: Q_rB_reload_level(t_hour)
- ExcelWriter:
	file: Q_rB_reload.xlsx
	symbols:
		- name: Q_rB_reload_level
endEmbeddedCode

EmbeddedCode Connect:  
- GAMSReader:
    symbols:
      - name: Q_rI_reload
- Projection:
	name:Q_rI_reload.l(t_hour)
	newName: Q_rI_reload_level(t_hour)
- ExcelWriter:
	file: Q_rI_reload.xlsx
	symbols:
		- name: Q_rI_reload_level
endEmbeddedCode

EmbeddedCode Connect:	  
- GAMSReader:
    symbols:
      - name: Q_ro_reload
- Projection:
	name: Q_ro_reload.l(t_hour)
	newName: Q_rO_reload_level(t_hour)
- ExcelWriter:
	file: Q_rO_reload.xlsx
	symbols:
		- name: Q_rO_reload_level
endEmbeddedCode

EmbeddedCode Connect:
- GAMSReader:
    symbols:
      - name: Q_reload(t_hour)
- Projection:
	name: Q_reload.(t_hour)
	newName: Q_reload_level(t_hour)
- ExcelWriter:
	file: Q_reload.xlsx
	symbols:
		- name: Q_reload_level
endEmbeddedCode