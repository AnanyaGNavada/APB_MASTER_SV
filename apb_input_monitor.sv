`include "defines.svh"
 
class apb_input_monitor;
apb_transaction mon_trans_in;
mailbox #(apb_transaction) mbx_ims;
virtual apb_interface.im vif_in;
covergroup im_cg;
	addr_in_cp : coverpoint mon_trans_in.addr_in{bins low={[0:100]}; bins mid ={[101:175]}; bins high ={[176:255]};}
	//presetn_cp: coverpoint im_trans.PRESETn{bins p1[]={0,1};}
	pready_cp: coverpoint mon_trans_in.PREADY{bins pr1[]={0,1};}
	pslverr_cp: coverpoint mon_trans_in.PSLVERR{bins ps1[]={0,1};}
	transfer_cp: coverpoint mon_trans_in.transfer{bins t[]={0,1};}
	write_read_cp : coverpoint mon_trans_in.write_read{bins wr[]={0,1};}
	wdata_in_cp: coverpoint mon_trans_in.wdata_in{bins wd_low={[32'h00000000:32'h0FFFFFFF]}; bins wd_mid={[32'h10000000:32'h50000000]}; bins wd_high={[32'h50000001:32'hFFFFFFFF]};}
	strb_in_cp: coverpoint mon_trans_in.strb_in{bins s[]={[0:(`DATA_WIDTH/8)]};}
endgroup
function new(mailbox #(apb_transaction) mbx_ims,virtual apb_interface.im vif_in);
  this.vif_in=vif_in;
  this.mbx_ims=mbx_ims;
  im_cg=new();
endfunction
task start();
repeat(3)@ (vif_in.im_cb);
for(int i=0;i<`no_of_transactions;i++)
begin
 do
 @(vif_in.im_cb);
 	while(!(vif_in.im_cb.transfer));
    mon_trans_in=new();
   mon_trans_in.transfer=vif_in.im_cb.transfer;
   mon_trans_in.write_read=vif_in.im_cb.write_read;
   mon_trans_in.addr_in=vif_in.im_cb.addr_in;
   mon_trans_in.strb_in=vif_in.im_cb.strb_in;
   do
            @(vif_in.im_cb);
        while(!(vif_in.im_cb.PREADY));
   mon_trans_in.PSLVERR=vif_in.im_cb.PSLVERR;
   mon_trans_in.PREADY=vif_in.im_cb.PREADY;
      mon_trans_in.wdata_in=vif_in.im_cb.wdata_in;
   mon_trans_in.PRDATA=vif_in.im_cb.PRDATA;
  $display("INPUT MONITOR PASSING THE INPUT DATA TO SCOREBOARD transfer=%0d,write_read=%0d,addr_in=%0h,wrdata_in=%0h,strb_in=%0b,PSLVERR=%0d,PREADY=%0d,PRDATA=%0h",
mon_trans_in.transfer,mon_trans_in.write_read,mon_trans_in.addr_in,mon_trans_in.wdata_in,mon_trans_in.strb_in,
mon_trans_in.PSLVERR,mon_trans_in.PREADY,mon_trans_in.PRDATA);
  mbx_ims.put(mon_trans_in);
  im_cg.sample();
   //@(vif_in.im_cb);
end
$display("Input Functional coverage =%f",im_cg.get_coverage());
endtask
endclass
