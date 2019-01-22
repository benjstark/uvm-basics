/*
 this flat sequence injects a single packet into a single port 'port'
*/
class single_seq extends base_vseq; 
`uvm_object_utils(single_seq)

// sequence configuration 
seq_config cfg;

function new(string name = "single_seq");
  super.new(name);
endfunction: new

task pre_body();
  super.pre_body();
  // the configuration and the sequencer must be set in the tests
  if(!uvm_config_db #(seq_config)::get(get_sequencer(), "", "config", cfg))
    `uvm_fatal(get_type_name(), "config config_db lookup failed")
endtask


task body;
  packet_t tx;

  tx = packet_t::type_id::create("tx");
  // set the driver port where these packets will be injected
  tx.dport = cfg.port;

  start_item(tx);
  if( ! tx.randomize() with {
      tx.p_size == cfg.p_size;
      tx.header == cfg.header;
    }
  )
    `uvm_error("single_seq", "invalid seq item randomization"); 
  `uvm_info("single_seq", cfg.convert2string(), UVM_HIGH)

  finish_item(tx);
endtask: body

endclass: single_seq

