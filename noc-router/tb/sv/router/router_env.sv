class router_env extends uvm_env;
`uvm_component_utils(router_env);

router_agent       agent_h [router_pkg::NPORT];
router_coverage    coverage_h;
router_scoreboard  scoreboard_h;
bit [3:0] cred_distrib = 2; // TODO allow different credit distribution for each agent. now, all agents have the same value 

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  // build the agent and pass its parameters
  foreach (agent_h[i]) begin
    agent_h[i] = router_agent::type_id::create($sformatf("agent%0d",i), this);
    uvm_config_db #(bit [3:0])              ::set(this, $sformatf("agent%0d*",i), "port", i);
    uvm_config_db #(bit [3:0])              ::set(this, "*", "cred_distrib", cred_distrib);
    uvm_config_db #(uvm_active_passive_enum)::set(this, $sformatf("agent%0d*",i), "is_active", UVM_ACTIVE);
  end

  coverage_h   = router_coverage::type_id::create("coverage", this);
  scoreboard_h = router_scoreboard::type_id::create("scoreboard", this);
  `uvm_info("msg", "ENV Done !", UVM_HIGH)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  `uvm_info("msg", "Connecting ENV", UVM_HIGH)
  foreach (agent_h[i]) begin
    // connect monitors/drivers with the sb
    agent_h[i].monitor_h.aport.connect(scoreboard_h.mon_ap);
    agent_h[i].driver_h.aport.connect(scoreboard_h.drv_ap);
  end
  // conenct sb with coverage
  scoreboard_h.cov_ap.connect(coverage_h.analysis_export);
  `uvm_info("msg", "Connecting ENV Done !", UVM_HIGH)
endfunction: connect_phase

endclass: router_env
