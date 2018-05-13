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
	task insertCommand(input reg[7:0]command1, command2 );
	debug <= 1;
	Aadress_to_ram_debug <= instcount;
	Data_to_ram_debug <= command1;
	@(posedge clk); //wait for positive edge of clk
	Aadress_to_ram_debug <= (instcount +1);
	instcount++;
	Data_to_ram_debug <= command2;
	@(posedge clk);
	@(negedge clk);//wait for negative edge of clock
	debug <= 0;
	Data_to_ram_debug <= 0;
    Aadress_to_ram_debug <= 0;
    instcount++;	
	$display ("@%g Value passed is %d", $time, command2);
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
laadimine1.insertCommand(17, 58);
laadimine1.insertCommand(18, 25);

$display ("cpu flags value is %d" , Flags);

#150 $finish;
end


endmodule 

