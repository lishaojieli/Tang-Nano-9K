/*通过开发板上的LED直观地将38译码器译码情况展示出来，但开发板上只有6个LED灯，所以实际上最后两种状态是无效的*/
module top (
    input clk_in,
    input btn_rst,
    output wire [5:0] led  //并发任务要使用线型变量
);

reg a,b,c;

decoder38 decoder38_inst(
    .a(a),
    .b(b),
    .c(c),
    .out(led)
);

reg [2:0] cnt;
reg [23:0] counter;

always @(posedge clk_in or negedge btn_rst) begin  
    if(!btn_rst)
        counter <= 24'd0;
    else if(counter  < 24'd1349_9999)    
        counter <= counter + 1'd1;
    else begin
        counter <= 24'd0;
        if(cnt < 3'd7)
            cnt <= cnt + 1'b1;
        else    
            cnt <= 1'b0;
        
        case(cnt)
            3'b000 : begin a<=1'b0; b<=1'b0; c<=1'b0; end
            3'b001 : begin a<=1'b0; b<=1'b0; c<=1'b1; end
            3'b010 : begin a<=1'b0; b<=1'b1; c<=1'b0; end
            3'b011 : begin a<=1'b0; b<=1'b1; c<=1'b1; end
            3'b100 : begin a<=1'b1; b<=1'b0; c<=1'b0; end
            3'b101 : begin a<=1'b1; b<=1'b0; c<=1'b1; end
            3'b110 : begin a<=1'b1; b<=1'b1; c<=1'b0; end
            3'b111 : begin a<=1'b1; b<=1'b1; c<=1'b1; end
        endcase 
    end
end

endmodule