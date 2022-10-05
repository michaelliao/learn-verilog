
module  encode (
    input   wire            sys_clk     ,   //时钟信号
    input   wire            sys_rst_n   ,   //复位信号,低有效
    input   wire    [7:0]   data_in     ,   //输入8bit待编码数据
    input   wire            c0          ,   //控制信号c0
    input   wire            c1          ,   //控制信号c1
    input   wire            de          ,   //使能信号

    output  reg     [9:0]   data_out        //输出编码后的10bit数据
);

    //parameter define
    parameter   DATA_OUT0   =   10'b1101010100,
                DATA_OUT1   =   10'b0010101011,
                DATA_OUT2   =   10'b0101010100,
                DATA_OUT3   =   10'b1010101011;

    //wire  define
    wire            condition_1 ;   //条件1
    wire            condition_2 ;   //条件2
    wire            condition_3 ;   //条件3
    wire    [8:0]   q_m         ;   //第一阶段转换后的9bit数据

    //reg   define
    reg     [3:0]   data_in_n1  ;   //待编码数据中1的个数
    reg     [7:0]   data_in_reg ;   //待编码数据打一拍
    reg     [3:0]   q_m_n1      ;   //转换后9bit数据中1的个数
    reg     [3:0]   q_m_n0      ;   //转换后9bit数据中0的个数
    reg     [4:0]   cnt         ;   //视差计数器,0-1个数差别,最高位为符号位
    reg             de_reg1     ;   //使能信号打一拍
    reg             de_reg2     ;   //使能信号打两拍
    reg             c0_reg1     ;   //控制信号c0打一拍
    reg             c0_reg2     ;   //控制信号c0打两拍
    reg             c1_reg1     ;   //控制信号c1打一拍
    reg             c1_reg2     ;   //控制信号c1打两拍
    reg     [8:0]   q_m_reg     ;   //q_m信号打一拍

    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            data_in_n1  <=  4'd0;
        else
            data_in_n1  <=  data_in[0] + data_in[1] + data_in[2]
                            + data_in[3] + data_in[4] + data_in[5]
                            + data_in[6] + data_in[7];

    //data_in_reg:待编码数据打一拍
    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            data_in_reg <=  8'b0;
        else
            data_in_reg <=  data_in;

    //condition_1:条件1
    assign  condition_1 = ((data_in_n1 > 4'd4) || ((data_in_n1 == 4'd4)
                            && (data_in_reg[0] == 1'b0)));

    //q_m:第一阶段转换后的9bit数据
    assign q_m[0] = data_in_reg[0];
    assign q_m[1] = (condition_1) ? (q_m[0] ^~ data_in_reg[1]) : (q_m[0] ^ data_in_reg[1]);
    assign q_m[2] = (condition_1) ? (q_m[1] ^~ data_in_reg[2]) : (q_m[1] ^ data_in_reg[2]);
    assign q_m[3] = (condition_1) ? (q_m[2] ^~ data_in_reg[3]) : (q_m[2] ^ data_in_reg[3]);
    assign q_m[4] = (condition_1) ? (q_m[3] ^~ data_in_reg[4]) : (q_m[3] ^ data_in_reg[4]);
    assign q_m[5] = (condition_1) ? (q_m[4] ^~ data_in_reg[5]) : (q_m[4] ^ data_in_reg[5]);
    assign q_m[6] = (condition_1) ? (q_m[5] ^~ data_in_reg[6]) : (q_m[5] ^ data_in_reg[6]);
    assign q_m[7] = (condition_1) ? (q_m[6] ^~ data_in_reg[7]) : (q_m[6] ^ data_in_reg[7]);
    assign q_m[8] = (condition_1) ? 1'b0 : 1'b1;

    //q_m_n1:转换后9bit数据中1的个数
    //q_m_n0:转换后9bit数据中0的个数
    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            begin
                q_m_n1  <=  4'd0;
                q_m_n0  <=  4'd0;
            end
        else
            begin
                q_m_n1  <=  q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
                q_m_n0  <=  4'd8 - (q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7]);
            end

    assign  condition_2 = ((cnt == 5'd0) || (q_m_n1 == q_m_n0));

    assign  condition_3 = (((~cnt[4] == 1'b1) && (q_m_n1 > q_m_n0))
                        || ((cnt[4] == 1'b1) && (q_m_n0 > q_m_n1)));

    always@(posedge sys_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            begin
                de_reg1 <=  1'b0;
                de_reg2 <=  1'b0;
                c0_reg1 <=  1'b0;
                c0_reg2 <=  1'b0;
                c1_reg1 <=  1'b0;
                c1_reg2 <=  1'b0;
                q_m_reg <=  9'b0;
            end
        else
            begin
                de_reg1 <=  de;
                de_reg2 <=  de_reg1;
                c0_reg1 <=  c0;
                c0_reg2 <=  c0_reg1;
                c1_reg1 <=  c1;
                c1_reg2 <=  c1_reg1;
                q_m_reg <=  q_m;
            end

    always @ (posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0) begin
                data_out    <=  10'b0;
                cnt         <=  5'b0;
        end else begin
            if(de_reg2 == 1'b1)
                begin
                    if(condition_2 == 1'b1)
                        begin
                            data_out[9]     <=  ~q_m_reg[8]; 
                            data_out[8]     <=  q_m_reg[8]; 
                            data_out[7:0]   <=  (q_m_reg[8]) ? q_m_reg[7:0] : ~q_m_reg[7:0];
                            cnt <=  (~q_m_reg[8]) ? (cnt + q_m_n0 - q_m_n1) : (cnt + q_m_n1 - q_m_n0);
                        end
                    else
                        begin
                            if(condition_3 == 1'b1)
                                begin
                                    data_out[9]     <= 1'b1;
                                    data_out[8]     <= q_m_reg[8];
                                    data_out[7:0]   <= ~q_m_reg[7:0];
                                    cnt <=  cnt + {q_m_reg[8], 1'b0} + (q_m_n0 - q_m_n1);
                                end
                            else
                                begin
                                    data_out[9]     <= 1'b0;
                                    data_out[8]     <= q_m_reg[8];
                                    data_out[7:0]   <= q_m_reg[7:0];
                                    cnt <=  cnt - {~q_m_reg[8], 1'b0} + (q_m_n1 - q_m_n0);
                                end
                            
                        end
                end
            else
                begin
                    case    ({c1_reg2, c0_reg2})
                        2'b00:  data_out <= DATA_OUT0;
                        2'b01:  data_out <= DATA_OUT1;
                        2'b10:  data_out <= DATA_OUT2;
                        default:data_out <= DATA_OUT3;
                    endcase
                    cnt <=  5'b0;
                end
        end
    end
endmodule
