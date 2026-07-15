`include "defines.svh"
class apb_transaction;
rand bit [`ADDR_WIDTH-1:0] addr_in;
rand bit  PSLVERR, write_read, transfer;
rand bit[`DATA_WIDTH-1:0] PRDATA,wdata_in;
rand bit [(`DATA_WIDTH/8)-1:0]  strb_in;
bit [`ADDR_WIDTH-1:0] PADDR;
bit PSEL,  PENABLE, PWRITE,transfer_done,error;
bit [`DATA_WIDTH-1:0] PWDATA,rdata_out;
bit [(`DATA_WIDTH/8)-1:0] PSTRB;
bit  PREADY;
constraint transfer_range { transfer ==1;}
constraint addr_in_range {addr_in inside {[0:200]};}
constraint pstrb_not_read { !write_read->strb_in==0;}
constraint strb_values { write_read-> strb_in !=0;}
constraint distribution_wr { write_read dist {0:=1,1:=1};}
virtual function apb_transaction copy();
copy=new();
copy.addr_in=this.addr_in;
copy.PREADY=this.PREADY;
copy.PSLVERR=this.PSLVERR;
copy.write_read=this.write_read;
copy.transfer=this.transfer;
copy.PRDATA=this.PRDATA;
copy.wdata_in=this.wdata_in;
copy.strb_in=this.strb_in;
return copy;
endfunction
endclass
/////////////////////////////////////////////////////////////////////////////////////////////////
class apb_write_transaction extends apb_transaction;
  constraint write_wr { write_read == 1; }
  virtual function apb_transaction copy();
    apb_write_transaction copy1;
    copy1 = new();
    copy1.addr_in    = this.addr_in;
    copy1.PREADY     = this.PREADY;
    copy1.PSLVERR    = this.PSLVERR;
    copy1.write_read = this.write_read;
    copy1.transfer   = this.transfer;
    copy1.PRDATA     = this.PRDATA;
    copy1.wdata_in   = this.wdata_in;
    copy1.strb_in    = this.strb_in;
    return copy1;
  endfunction
endclass

class apb_read_transaction extends apb_transaction;
  constraint read_wr { write_read == 0; }
  virtual function apb_transaction copy();
    apb_read_transaction copy2;
    copy2 = new();
    copy2.addr_in    = this.addr_in;
    copy2.PREADY     = this.PREADY;
    copy2.PSLVERR    = this.PSLVERR;
    copy2.write_read = this.write_read;
    copy2.transfer   = this.transfer;
    copy2.PRDATA     = this.PRDATA;
    copy2.wdata_in   = this.wdata_in;
    copy2.strb_in    = this.strb_in;
    return copy2;
  endfunction
endclass

class apb_addr_boundary_transaction extends apb_transaction;
  constraint addr_range { addr_in inside {32'h00000000,32'hFFFFFFFF }; }
  virtual function apb_transaction copy();
    apb_addr_boundary_transaction copy3;
    copy3 = new();
    copy3.addr_in    = this.addr_in;
    copy3.PREADY     = this.PREADY;
    copy3.PSLVERR    = this.PSLVERR;
    copy3.write_read = this.write_read;
    copy3.transfer   = this.transfer;
    copy3.PRDATA     = this.PRDATA;
    copy3.wdata_in   = this.wdata_in;
    copy3.strb_in    = this.strb_in;
    return copy3;
  endfunction
endclass

class apb_back_to_back_transaction extends apb_transaction;
  constraint distribution_wr { write_read == 1; }
  constraint transfer_range  { transfer == 1; }
  virtual function apb_transaction copy();
    apb_back_to_back_transaction copy4;
    copy4 = new();
    copy4.addr_in    = this.addr_in;
    copy4.PREADY     = this.PREADY;
    copy4.PSLVERR    = this.PSLVERR;
    copy4.write_read = this.write_read;
    copy4.transfer   = this.transfer;
    copy4.PRDATA     = this.PRDATA;
    copy4.wdata_in   = this.wdata_in;
    copy4.strb_in    = this.strb_in;
    return copy4;
  endfunction
endclass

class apb_error_transaction extends apb_transaction;
  constraint wr_rd { write_read dist {0:=1, 1:=1}; }
  constraint give_error  { PSLVERR == 1; }
  virtual function apb_transaction copy();
    apb_error_transaction copy5;
    copy5 = new();
    copy5.addr_in    = this.addr_in;
    copy5.PREADY     = this.PREADY;
    copy5.PSLVERR    = this.PSLVERR;
    copy5.write_read = this.write_read;
    copy5.transfer   = this.transfer;
    copy5.PRDATA     = this.PRDATA;
    copy5.wdata_in   = this.wdata_in;
    copy5.strb_in    = this.strb_in;
    return copy5;
  endfunction
endclass

