ram_buffer	ram_buffer_inst (
	.clock ( clock_sig ),
	.data ( data_sig ),
	.rdaddress ( rdaddress_sig ),
	.wraddress ( wraddress_sig ),
	.wren ( wren_sig ),
	.q ( q_sig )
	);
