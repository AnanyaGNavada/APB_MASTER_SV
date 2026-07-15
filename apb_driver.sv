`include "defines.svh"
class apb_driver;
//ADDED  EXTRA
int counting;


apb_transaction dr_trans;
mailbox #(apb_transaction) mbx_gd;
virtual apb_interface.drv vif_dr;
function new(mailbox #(apb_transaction) mbx_gd,virtual apb_interface.drv vif_dr);
	this.mbx_gd=mbx_gd;
	this.vif_dr=vif_dr;
endfunction
task start();
	repeat(3) @(vif_dr.drv_cb);
	for(int i=0;i<`no_of_transactions;i++)
	begin
		repeat(1) @(vif_dr.drv_cb);
		if(vif_dr.drv_cb.PRESETn==0)
		begin
			vif_dr.drv_cb.PRDATA<=0;
			vif_dr.drv_cb.PREADY<=0;
			vif_dr.drv_cb.PSLVERR<=0;
			vif_dr.drv_cb.transfer<=0;
			vif_dr.drv_cb.write_read<=0;
			vif_dr.drv_cb.addr_in<=0;
			vif_dr.drv_cb.wdata_in<=0;
			vif_dr.drv_cb.strb_in<=0;
			$display("DRIVER (RESET)  ->  iteration = %d PRDATA = %h PREADY = %b PSLVERR = %b transfer = %b write_read = %b addr_in = %h wdata_in = %h strb_in = %h ",i,dr_trans.PRDATA,dr_trans.PREADY,dr_trans.PSLVERR,dr_trans.transfer,dr_trans.write_read,dr_trans.addr_in,dr_trans.wdata_in,dr_trans.strb_in);
		end
		dr_trans=new();
		mbx_gd.get(dr_trans);	
		$display("Reset didnt happen i will get from mailbox [DRIVER]");
		fork
		begin
		@(vif_dr.drv_cb);
		vif_dr.drv_cb.transfer<=dr_trans.transfer;
		vif_dr.drv_cb.write_read<=dr_trans.write_read;
		vif_dr.drv_cb.addr_in<=dr_trans.addr_in;
		vif_dr.drv_cb.wdata_in<=dr_trans.wdata_in;
		vif_dr.drv_cb.strb_in<=dr_trans.strb_in;
		@(vif_dr.drv_cb);
                vif_dr.drv_cb.transfer <= 1'b0; 
			/*do  begin
				@(vif_dr.drv_cb);
			end
			while (!(vif_dr.drv_cb.PSEL && vif_dr.drv_cb.PENABLE));*/
			if(dr_trans.transfer) begin
				while(!(vif_dr.drv_cb.PSEL && vif_dr.drv_cb.PENABLE))
				@(vif_dr.drv_cb);
                dr_trans.PSEL = vif_dr.drv_cb.PSEL;
                dr_trans.PENABLE = vif_dr.drv_cb.PENABLE;
				vif_dr.drv_cb.PREADY<=1; 
				vif_dr.drv_cb.PRDATA<=dr_trans.PRDATA;
				vif_dr.drv_cb.PSLVERR<=dr_trans.PSLVERR;
				@(vif_dr.drv_cb);
			$display("%0t : 1: DRIVER  -> iteration = %d  PRDATA = %h PREADY = %b PSLVERR = %b transfer = %b write_read = %b addr_in = %h wdata_in = %h strb_in = %h, PSEL =%b ,PENABLE = %b ",$time,i,dr_trans.PRDATA,dr_trans.PREADY,dr_trans.PSLVERR,dr_trans.transfer,dr_trans.write_read,dr_trans.addr_in,dr_trans.wdata_in,dr_trans.strb_in,dr_trans.PSEL,dr_trans.PENABLE);
				@(vif_dr.drv_cb);
				vif_dr.drv_cb.PREADY<=0; 
			end
            /*counting++;
			$display("%0t : 2: DRIVER  ->iteration = %d  PRDATA = %h PREADY = %b PSLVERR = %b transfer = %b write_read = %b addr_in = %h wdata_in = %h strb_in = %h, PSEL =%b ,PENABLE = %b ",$time,i,dr_trans.PRDATA,dr_trans.PREADY,dr_trans.PSLVERR,dr_trans.transfer,dr_trans.write_read,dr_trans.addr_in,dr_trans.wdata_in,dr_trans.strb_in,dr_trans.PSEL,dr_trans.PENABLE);
			$display("EXITING THE TRANSFER %0d CONDITION",counting);*/
		end
		begin
		wait(!(vif_dr.drv_cb.PRESETn));
		end
		join_any
		disable fork;
		if(vif_dr.drv_cb.PRESETn==0)
		begin
			vif_dr.drv_cb.PRDATA<=0;
			vif_dr.drv_cb.PREADY<=0;
			vif_dr.drv_cb.PSLVERR<=0;
			vif_dr.drv_cb.transfer<=0;
			vif_dr.drv_cb.write_read<=0;
			vif_dr.drv_cb.addr_in<=0;
			vif_dr.drv_cb.wdata_in<=0;
			vif_dr.drv_cb.strb_in<=0;
			$display("DRIVER (RESET)  -> PRDATA = %h PREADY = %b PSLVERR = %b transfer = %b write_read = %b addr_in = %h wdata_in = %h strb_in = %h ",dr_trans.PRDATA,dr_trans.PREADY,dr_trans.PSLVERR,dr_trans.transfer,dr_trans.write_read,dr_trans.addr_in,dr_trans.wdata_in,dr_trans.strb_in);
		end
	end
endtask
endclass
