interface hermes_if (input bit clock, input bit reset);
	import hermes_pkg::*;

//	bit reset;

/*
Each of the five interfaces has the following ports:
--                             PORT
--                         _____________
--                   RX ->|             |-> TX
--              DATA_IN ->|             |-> DATA_OUT
--             CLOCK_RX ->|             |-> CLOCK_TX
--             CREDIT_O <-|             |<- CREDIT_I
--                        |             |
                           _____________
*/

    logic        clk, avail,  credit;//从这里看不出clock和clk的关系，在wrapper里能理清楚
    logic [15:0]  data;

    modport datain (
            input clk, avail, data,
            output credit
        );
    modport dataout (
            output clk, avail, data,
            input credit
        );     

endinterface : hermes_if
