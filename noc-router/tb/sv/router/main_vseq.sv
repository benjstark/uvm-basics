/*
 this virtual sequence can inject packets in all input ports in parallel
*/
class main_vseq extends base_vseq; 
`uvm_object_utils(main_vseq)

function new(string name = "main_vseq");
  super.new(name);
endfunction: new


task body();
	basic_seq seq[];
	int j=0;
	seq = new[router_pkg::NPORT];
	foreach (seq[i]) begin
		seq[i] = basic_seq::type_id::create($sformatf("seq[%0d]",i));
		// set the input router port where the sequence will inject its packets
		seq[i].port = j;
		j = j +1 ;
	end 
	// set the # of packets generated by the sequence. default is 50
	seq[4].npackets = 20;

	// solution from https://verificationacademy.com/forums/systemverilog/fork-within-loop-join-all
	// to wait all threads to finish
	fork 
	  begin : isolating_thread
	    for(int index=0;index<router_pkg::NPORT;index++)begin : for_loop
	      fork
	      automatic int idx=index;
	        begin
	            seq[idx].start (sequencer[idx]);
	        end
	      join_none;
	    end : for_loop
	  wait fork; // This block the current thread until all child threads have completed. 
	  end : isolating_thread
	join

endtask: body

endclass: main_vseq

