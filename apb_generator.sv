`include "defines.svh"
class apb_generator;
apb_transaction gen_trans;
mailbox #(apb_transaction) mbx_gd;
function new(mailbox #(apb_transaction) mbx_gd);
this.mbx_gd=mbx_gd;
gen_trans=new();
endfunction
task start();
for(int i=0;i<`no_of_transactions;i++)
begin
assert(gen_trans.randomize());
mbx_gd.put(gen_trans.copy());
$display("GENERATOR  PRDATA = %h  PREADY = %b  PSLVERR = %b  transfer = %b write_read = %b addr_in = %h  wdata_in = %h  strb_in=%h",gen_trans.PRDATA,gen_trans.PREADY,gen_trans.PSLVERR,gen_trans.transfer,gen_trans.write_read,gen_trans.addr_in,gen_trans.wdata_in,gen_trans.strb_in);
end
endtask
endclass
