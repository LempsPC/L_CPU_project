`timescale 1ns/10ps
//+++++++++++++++++++++++++++++++++++++++++++++++
//   Testbench Code
//+++++++++++++++++++++++++++++++++++++++++++++++
module L_CPU_tester2();

reg clk;
reg reset;
reg [4:0] Flags;
reg debug;
reg [7:0] Data_to_ram_debug; 
reg [7:0] Aadress_to_ram_debug;

always #5 clk ++;

initial begin
   //sisendite algv‰‰rtustamine
   clk<=0;
   reset<=1;
   debug<=0;
   Data_to_ram_debug <= "00000000";
   Aadress_to_ram_debug <= "00000000";
#10 reset<=0;
   
  
  #100 $finish;
end

L_CPU my_cpu(reset, clk, Flags, debug, Data_to_ram_debug, Aadress_to_ram_debug);

endmodule 