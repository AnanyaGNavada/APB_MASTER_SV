`include "defines.svh"
class apb_test;
virtual apb_interface drv_vif;
virtual apb_interface mon_vif; 
virtual apb_interface im_vif;
apb_environment env;
function new(virtual apb_interface drv_vif,virtual apb_interface mon_vif,virtual apb_interface im_vif);
	this.drv_vif=drv_vif;
	this.mon_vif=mon_vif;
	this.im_vif=im_vif;
endfunction
task run();
	env=new(drv_vif,mon_vif,im_vif);
	env.build();
	env.start();
endtask
endclass
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class apb_test_write extends apb_test;
  apb_write_transaction trans_write;
  function new(virtual apb_interface drv_vif, virtual apb_interface mon_vif, virtual apb_interface im_vif);
    super.new(drv_vif, mon_vif, im_vif);
  endfunction
  task run();
    env = new(drv_vif, mon_vif, im_vif);
    env.build();
    begin
      trans_write = new();
      env.gen.gen_trans = trans_write;
    end
    env.start();
  endtask
endclass

class apb_test_read extends apb_test;
  apb_read_transaction trans_read;
  function new(virtual apb_interface drv_vif, virtual apb_interface mon_vif, virtual apb_interface im_vif);
    super.new(drv_vif, mon_vif, im_vif);
  endfunction
  task run();
    env = new(drv_vif, mon_vif, im_vif);
    env.build();
    begin
      trans_read = new();
      env.gen.gen_trans= trans_read;
    end
    env.start();
  endtask
endclass

class apb_test_addr_boundary extends apb_test;
  apb_addr_boundary_transaction trans_addr_boundary;
  function new(virtual apb_interface drv_vif, virtual apb_interface mon_vif, virtual apb_interface im_vif);
    super.new(drv_vif, mon_vif, im_vif);
  endfunction
  task run();
    env = new(drv_vif, mon_vif, im_vif);
    env.build();
    begin
      trans_addr_boundary = new();
      env.gen.gen_trans = trans_addr_boundary;
    end
    env.start();
  endtask
endclass

class apb_test_back_to_back extends apb_test;
  apb_back_to_back_transaction trans_b2b;
  function new(virtual apb_interface drv_vif, virtual apb_interface mon_vif, virtual apb_interface im_vif);
    super.new(drv_vif, mon_vif, im_vif);
  endfunction
  task run();
    env = new(drv_vif, mon_vif, im_vif);
    env.build();
    begin
      trans_b2b = new();
      env.gen.gen_trans = trans_b2b;
    end
    env.start();
  endtask
endclass

class apb_test_error extends apb_test;
  apb_error_transaction trans_error;
  function new(virtual apb_interface drv_vif, virtual apb_interface mon_vif, virtual apb_interface im_vif);
    super.new(drv_vif, mon_vif, im_vif);
  endfunction
  task run();
    env = new(drv_vif, mon_vif, im_vif);
    env.build();
    begin
      trans_error = new();
      env.gen.gen_trans = trans_error;
    end
    env.start();
  endtask
endclass
