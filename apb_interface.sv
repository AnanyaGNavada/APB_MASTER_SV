`include "defines.svh"
interface apb_interface(input bit PCLK,PRESETn);
bit [`ADDR_WIDTH-1:0] PADDR,addr_in;
bit PSEL,  PENABLE, PWRITE, PREADY, PSLVERR, write_read, transfer,transfer_done,error;
bit[`DATA_WIDTH-1:0] PWDATA,PRDATA,wdata_in,rdata_out;
bit [(`DATA_WIDTH/8)-1:0] PSTRB, strb_in;
clocking drv_cb@(posedge PCLK);
default input #0 output #0;
output PRDATA, PREADY, PSLVERR, transfer,write_read,addr_in, wdata_in, strb_in;
input PSEL,PENABLE,PRESETn;
endclocking
clocking im_cb@(posedge PCLK);
default input #0 output #0;
input PRDATA, PREADY, PSLVERR, transfer,write_read,addr_in, wdata_in, strb_in;
endclocking
clocking mon_cb@(posedge PCLK);
default input #0 output #0;
input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;
endclocking
modport drv (clocking drv_cb);
modport im (clocking im_cb);
modport mon(clocking mon_cb);
endinterface
