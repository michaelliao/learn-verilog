// data write to fifo, then read and send

module tx_fsm (
    input clk_wr,
    input clk_rd,
    input wr_rst_n,
    input rd_rst_n,
    input wr_req,
    input [31:0] wr_data,
    output wr_full,
    output out_tx_data
);
    // fsm
    localparam
        IDLE  = 2'b00,
        FETCH = 2'b01,
        SEND  = 2'b11;

    reg [1:0] state;
    reg rd_req;
    wire rd_empty;
    wire tx_sending;
    reg tx_data_en;
    wire [7:0] rd_data;
    reg [7:0] rd_data_cache;

    always @ (posedge clk_rd or negedge rd_rst_n) begin
        if (! rd_rst_n) begin
            state <= IDLE;
            rd_req <= 1'b0;
            rd_data_cache <= 8'b0;
        end else begin
            case (state)
            IDLE: begin
                if (! rd_empty && ! tx_sending) begin
                    // 在下一个周期读取fifo:
                    state <= FETCH;
                    rd_req <= 1'b1;
                end
            end
            FETCH: begin
                // 读fifo:
                rd_data_cache <= rd_data;
                rd_req <= 1'b0;
                // 下一个状态发送tx:
                tx_data_en <= 1'b1;
                state <= SEND;
            end
            SEND: begin
                tx_data_en <= 1'b0;
                state <= IDLE;
            end
            default: state <= IDLE;
            endcase
        end
    end

    reg wr_data_req;
    reg [31:0] wr_data_cache;
    reg [2:0] wr_data_cnt;

    always @ (posedge clk_wr or negedge wr_rst_n) begin
        if (! wr_rst_n) begin
            wr_data_req <= 1'b0;
            wr_data_cache <= 32'b0;
            wr_data_cnt <= 3'b0;
        end else begin
            if (wr_req) begin
                wr_data_cache <= wr_data;
                wr_data_cnt <= 3'd4;
                wr_data_req <= 1'b1;
            end
            // 4, 5, 6, 7:
            if (wr_data_cnt > 0) begin
                wr_data_cache[31:8] <= wr_data_cache[23:0];
                wr_data_cnt <= wr_data_cnt + 1;
            end else begin
                wr_data_req <= 1'b0;
            end
        end
    end

    fifo_async_8bit tx_fifo_inst (
        // 写入fifo:
        .wrclk (clk_wr),
	    .wrreq (wr_data_req),
	    .data (wr_data_cache[31:24]),
        // 读取fifo:
	    .rdclk (clk_rd),
	    .rdreq (rd_req),
	    .q (rd_data),
        // fifo状态:
	    .rdempty (rd_empty),
        .wrfull (wr_full)
	);

    uart_tx uart_tx_inst (
        .clk (clk_rd),
        .rst_n (rd_rst_n),
        .in_data (rd_data_cache),
        .in_en (tx_data_en),
        .out_en (tx_sending),
        .out_data (out_tx_data)
    );

endmodule
