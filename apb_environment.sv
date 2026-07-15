`include "defines.svh"
class apb_environment;
virtual apb_interface drv_vif;
virtual apb_interface mon_vif; 
virtual apb_interface im_vif;
mailbox #(apb_transaction) mbx_gd;
mailbox #(apb_transaction)mbx_ims;
mailbox #(apb_transaction) mbx_ms;
apb_generator gen;
apb_driver dri;
apb_input_monitor inpmon;
apb_monitor outmon;
apb_scoreboard sb;
function new(virtual apb_interface drv_vif,virtual apb_interface mon_vif,virtual apb_interface im_vif);
	this.drv_vif=drv_vif;
	this.mon_vif=mon_vif;
	this.im_vif=im_vif;
endfunction
task build();
	mbx_gd=new();
	mbx_ims=new();
	mbx_ms=new();
	gen=new(mbx_gd);
	dri=new(mbx_gd,drv_vif);
	inpmon=new(mbx_ims,im_vif);
	outmon=new(mbx_ms,mon_vif);
	sb=new(mbx_ims,mbx_ms);
endtask
task start();
	fork
		gen.start();
		dri.start();
		inpmon.start();
		outmon.start();
		sb.start();
	join
	$finish;
endtask
endclass
