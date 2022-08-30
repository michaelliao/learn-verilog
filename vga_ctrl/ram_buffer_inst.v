ram_buffer	ram_buffer_inst (
	.data ( data_sig ),
	.rdaddress ( rdaddress_sig ),
	.rdclock ( rdclock_sig ),
	.wraddress ( wraddress_sig ),
	.wrclock ( wrclock_sig ),
	.wren ( wren_sig ),
	.q ( q_sig )
	);
