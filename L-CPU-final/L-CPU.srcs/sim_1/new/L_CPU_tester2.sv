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

class Instruction;
	/*--Test classes have 'test' task's that will check CPU status  */
	int instcount = 0;
	/*---------------execute---------------*/
	task insertCommand;
	debug <= 1;
	Aadress_to_ram_debug <= instcount;
	Data_to_ram_debug <= 17;
	@(posedge clk); //wait for positive edge of clk
	Aadress_to_ram_debug <= (instcount +1);
	Data_to_ram_debug <= 58;
	@(posedge clk);
	@(negedge clk);//wait for negative edge of clock
	debug <= 0;
	Data_to_ram_debug <= 0;
    Aadress_to_ram_debug <= 0;	
	endtask;
endclass: Instruction

Instruction laadimine1 = new;

L_CPU my_cpu(reset, clk, Flags, debug, Data_to_ram_debug, Aadress_to_ram_debug);

initial begin
   //sisendite algväärtustamine
   clk<=0;
   reset<=1;
   debug<=1;
   Data_to_ram_debug <= 0;
   Aadress_to_ram_debug <= 0;
   
#10 reset<=0;
laadimine1.insertCommand;

#150 $finish;
end


endmodule 

