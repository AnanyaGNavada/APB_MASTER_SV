`include "defines.svh"
class apb_monitor;
//EXTRA SIGNAL
//int counting;
//------------------
apb_transaction mon_trans;
mailbox #(apb_transaction) mbx_ms;
virtual apb_interface.mon vif_mon;
/*covergroup mon_cg;
	psel_cp: coverpoint mon_trans.PSEL { bins ps1[]={0,1};}
	penable_cp : coverpoint mon_trans.PENABLE { bins pe[]={0,1};}
	pwrite_cp : coverpoint mon_trans.PWRITE { bins pw[]={0,1};}
	pwdata_cp : coverpoint mon_trans.PWDATA { bins low={[0:100]}; bins mid ={[101:188]}; bins high ={[189:255]};}
	pstrb_cp : coverpoint mon_trans.PSTRB { bins pst1[] ={[0:3]};}
	rdataout_cp : coverpoint mon_trans.rdata_out{bins rd1_low={[0:100]}; bins rd2_mid ={[101:188]}; bins rd3_high ={[189:255]};}
	transferdone_cp : coverpoint mon_trans.transfer_done { bins td[]={0,1};}
	error_cp : coverpoint mon_trans.error { bins e[]={0,1};}
endgroup*/
function new(mailbox #(apb_transaction) mbx_ms,virtual apb_interface.mon vif_mon);
this.vif_mon=vif_mon;
this.mbx_ms=mbx_ms;
//mon_cg=new();
endfunction
task start();
repeat(4)@(vif_mon.mon_cb);
for(int i=0;i<`no_of_transactions;i++) 
begin
	mon_trans=new();
    do 
		@(vif_mon.mon_cb); 
		while(! (vif_mon.mon_cb.transfer_done));
	/*repeat(1)@(vif_mon.mon_cb) begin
		wait(vif_mon.mon_cb.PSEL && vif_mon.mon_cb.PENABLE && vif_mon.mon_cb.PREADY);*/
		mon_trans.PSEL=vif_mon.mon_cb.PSEL;
		mon_trans.PENABLE=vif_mon.mon_cb.PENABLE;
		mon_trans.PADDR    = vif_mon.mon_cb.PADDR;
		mon_trans.PWRITE=vif_mon.mon_cb.PWRITE;
		mon_trans.PWDATA=vif_mon.mon_cb.PWDATA;
		mon_trans.PSTRB=vif_mon.mon_cb.PSTRB;
		mon_trans.rdata_out=vif_mon.mon_cb.rdata_out;
		mon_trans.transfer_done=vif_mon.mon_cb.transfer_done;
		mon_trans.error=vif_mon.mon_cb.error;
		//end
       // counting++;
	$display("OUTPUT MONITOR PSEL = %d PENABLE = %d PWRITE =%d PWDATA = %h PSTRB = %h rdata_out = %h transfer_done = %d  error = %d",mon_trans.PSEL,mon_trans.PENABLE,mon_trans.PWRITE,mon_trans.PWDATA,mon_trans.PSTRB,mon_trans.rdata_out,mon_trans.transfer_done,mon_trans.error);
    //$display("%0d counting",counting);
	mbx_ms.put(mon_trans);
	//mon_cg.sample();
end
	//$display("OUTPUT FUNCTIONAL COVERAGE =%f",mon_cg.get_coverage());
endtask
endclass
