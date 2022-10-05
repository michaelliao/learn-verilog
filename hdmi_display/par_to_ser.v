// par_to_ser

module par_to_ser
(
    input clk_5x,
    input [9:0] par_data,

    output ser_data_p,
    output ser_data_n
);

    //wire  define
    wire    [4:0]   data_rise = {par_data[8],par_data[6],
                                par_data[4],par_data[2],par_data[0]};
    wire    [4:0]   data_fall = {par_data[9],par_data[7],
                                par_data[5],par_data[3],par_data[1]};

    //reg   define
    reg     [4:0]   data_rise_s = 0;
    reg     [4:0]   data_fall_s = 0;
    reg     [2:0]   cnt = 0;

    always @ (posedge clk_5x) begin
        cnt <= (cnt[2]) ? 3'd0 : cnt + 3'd1;
        data_rise_s  <= cnt[2] ? data_rise : data_rise_s[4:1];
        data_fall_s  <= cnt[2] ? data_fall : data_fall_s[4:1];

    end

    //------------- ddio_out_inst0 -------------
    ddio_out    ddio_out_inst0 (
        .datain_h   (data_rise_s[0] ),
        .datain_l   (data_fall_s[0] ),
        .outclock   (~clk_5x        ),
        .dataout    (ser_data_p     )
    );

    //------------- ddio_out_inst1 -------------
    ddio_out    ddio_out_inst1 (
        .datain_h   (~data_rise_s[0]),
        .datain_l   (~data_fall_s[0]),
        .outclock   (~clk_5x        ),
        .dataout    (ser_data_n     )
    );

endmodule
