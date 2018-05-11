`timescale 1ns/10ps
//+++++++++++++++++++++++++++++++++++++++++++++++
//   Testbench Code
//+++++++++++++++++++++++++++++++++++++++++++++++
module L_CPU_tester2();

reg clk = 0;
reg reset = 0;
reg [4:0] Flags;
always #5 clk ++;

initial begin
   reset<=1;
#1 reset<=0;
  
  #100 $finish;
end

L_CPU my_cpu(reset, clk, Flags);

endmodule 