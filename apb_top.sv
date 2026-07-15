`include "defines.svh"
`include "apb_interface.sv"
`include "apb_package.sv"
`include "apb_master.sv"
module apb_top;
import apb_package ::*;
bit PCLK=0;
bit PRESETn=0;
initial begin
forever #10 PCLK=~PCLK;
end
initial begin
@(posedge PCLK);
PRESETn=0;
repeat(1) @(posedge PCLK);
PRESETn=1;
@(posedge PCLK);
PRESETn=0;
repeat(1) @(posedge PCLK);
PRESETn=1;
end

apb_interface intrf(PCLK,PRESETn);

apb_master  #(.ADDR_WIDTH(`ADDR_WIDTH),.DATA_WIDTH(`DATA_WIDTH)) duv  (.PCLK(PCLK), .PRESETn(PRESETn), .PADDR(intrf.PADDR), .PSEL(intrf.PSEL), .PENABLE(intrf.PENABLE), .PWRITE(intrf.PWRITE), .PWDATA(intrf.PWDATA), .PSTRB(intrf.PSTRB),.PRDATA(intrf.PRDATA), 
.PREADY(intrf.PREADY), .PSLVERR(intrf.PSLVERR), .transfer(intrf.transfer),.write_read(intrf.write_read), .addr_in(intrf.addr_in), .wdata_in(intrf.wdata_in), .strb_in(intrf.strb_in), .rdata_out(intrf.rdata_out), 
.transfer_done(intrf.transfer_done), .error(intrf.error));
apb_test test=new(intrf.drv,intrf.im,intrf.mon);
 apb_test_write t1 = new(intrf.drv, intrf.im, intrf.mon);
  apb_test_read  t2 = new(intrf.drv, intrf.im, intrf.mon);
  apb_test_addr_boundary t3 = new(intrf.drv, intrf.im, intrf.mon);
  apb_test_back_to_back  t4 = new(intrf.drv, intrf.im, intrf.mon);
  apb_test_error  t5 = new(intrf.drv, intrf.im, intrf.mon);
initial begin
test.run();
t1.run();   
t2.run(); 
t3.run(); 
t4.run(); 
t5.run(); 
$finish;
end
endmodule
