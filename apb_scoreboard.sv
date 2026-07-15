`include "defines.svh"
class apb_scoreboard;
apb_transaction mon2sb_trans, im2sb_trans;
mailbox #(apb_transaction) mbx_ims;
mailbox #(apb_transaction) mbx_ms;
int pass_count, fail_count;
function new(mailbox #(apb_transaction) mbx_ims, mailbox #(apb_transaction) mbx_ms);
	this.mbx_ims = mbx_ims;
	this.mbx_ms  = mbx_ms;
endfunction

task start();
	for(int i=0; i<`no_of_transactions; i++)
	begin
		/*bit [`DATA_WIDTH-1:0] wdata_in_1;
		wdata_in_1='0;*/
		mbx_ims.get(im2sb_trans);
		mbx_ms.get(mon2sb_trans);

	/*for(int i=0;i<`PSTRB_WIDTH;i++) begin
		if(im2sb_trans.strb_in[i])
                 wdata_in_1[i*8+:8]=im2sb_trans.wdata_in[i*8+:8];
         end*/
               	if(im2sb_trans.write_read)
		begin 
			if(im2sb_trans.addr_in  == mon2sb_trans.PADDR  &&
			   im2sb_trans.wdata_in == mon2sb_trans.PWDATA &&
			   im2sb_trans.strb_in  == mon2sb_trans.PSTRB  &&
			   mon2sb_trans.PWRITE  == 1'b1)
			begin
				$display("SCOREBOARD: WRITE MATCH  -> addr=%h wdata=%h strb=%h",im2sb_trans.addr_in,im2sb_trans.wdata_in,im2sb_trans.strb_in);
				pass_count++;
			end
			else
			begin
				$display("SCOREBOARD: WRITE MISMATCH -> exp addr=%h wdata=%h strb=%h | got addr=%h wdata=%h strb=%h pwrite=%b",
					im2sb_trans.addr_in, im2sb_trans.wdata_in, im2sb_trans.strb_in,
					mon2sb_trans.PADDR, mon2sb_trans.PWDATA, mon2sb_trans.PSTRB, mon2sb_trans.PWRITE);
				fail_count++;
			end
		end
		else
		begin 
			if(im2sb_trans.addr_in == mon2sb_trans.PADDR    &&
			   im2sb_trans.PRDATA  == mon2sb_trans.rdata_out &&
			   mon2sb_trans.PWRITE == 1'b0)
			begin
				$display("SCOREBOARD: READ MATCH  -> addr=%h rdata=%h",im2sb_trans.addr_in,im2sb_trans.PRDATA);
				pass_count++;
			end
			else
			begin
				$display("SCOREBOARD: READ MISMATCH -> exp addr=%h rdata=%h | got addr=%h rdata=%h pwrite=%b",
					im2sb_trans.addr_in, im2sb_trans.PRDATA,
					mon2sb_trans.PADDR, mon2sb_trans.rdata_out, mon2sb_trans.PWRITE);
				fail_count++;
			end
		end

		if((mon2sb_trans.PSEL && mon2sb_trans.PENABLE && mon2sb_trans.PREADY && im2sb_trans.PSLVERR)== mon2sb_trans.error) begin
			$display("SCOREBOARD: ERROR  MATCH -> exp=%b got=%b",(mon2sb_trans.PSEL && mon2sb_trans.PENABLE && mon2sb_trans.PREADY && im2sb_trans.PSLVERR),mon2sb_trans.error);
			pass_count++;
		end
		else begin
			$display("SCOREBOARD: ERROR  MISMATCH -> exp=%b got=%b",(mon2sb_trans.PSEL && mon2sb_trans.PENABLE && mon2sb_trans.PREADY && im2sb_trans.PSLVERR),mon2sb_trans.error);
			fail_count++;
		end
		/*if(im2sb_trans.transfer == mon2sb_trans.transfer_done)
			$display("SCOREBOARD: TRANSFER-> exp=%b got=%b",im2sb_trans.transfer,mon2sb_trans.transfer_done);
		else
			$display("SCOREBOARD: TRANSFER MISMATCH -> exp=%b got=%b",im2sb_trans.transfer,mon2sb_trans.transfer_done);*/
	end

	$display("SCOREBOARD REPORT: PASS=%0d FAIL=%0d TOTAL=%0d",pass_count,fail_count,pass_count+fail_count);
endtask
endclass


