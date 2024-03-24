module led(
    input clk_in,
    input btn_rst,
    output reg [5:0] led
);

reg [23:0] counter;

/*  时钟分频之IP调用
wire clk_div;   
Gowin_CLKDIV your_instance_name(
    .clkout(clk_div), //output clkout
    .hclkin(clk_in), //input hclkin
    .resetn(btn_rst) //input resetn
);
*/

wire clk_div;
wire gw_gnd;
assign gw_gnd = 1'b0;
CLKDIV clkdiv_inst (
    .CLKOUT(clk_div),
    .HCLKIN(clk_in),
    .RESETN(btn_rst),
    .CALIB(gw_gnd)
);

defparam clkdiv_inst.DIV_MODE = "2";  //分频系数
defparam clkdiv_inst.GSREN = "false";  //关闭全局复位GSP

always @(posedge clk_div or negedge btn_rst) begin  
    if(!btn_rst)
        counter <= 24'd0;
    else if(counter  < 24'd1349_9999)    //开发板晶振频率为27MHz，计数到13499999约为0.5秒
        counter <= counter + 1'd1;
    else
        counter <= 24'd0;
end

always @(posedge clk_div or negedge btn_rst) begin  
    if(!btn_rst)
        led <= 6'd111110;
    else if(counter  == 24'd1349_9999)    
        led [5:0] <= {led[4:0],led[5]};   //将最高位移到最低位的后面，然后将二者拼接起来，相当于循环移位
    else
        led <= led;
end

endmodule