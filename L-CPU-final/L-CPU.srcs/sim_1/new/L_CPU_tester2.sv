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

int memoryposition = 0;

class Memory;
	
	int instcount = 0;
	/*---------------execute---------------*/
	//this task inserts direct loading command with corresponding operand and data which can be loaded into desired register
	//this task starts from falling edge ans ends at falling edge, lasts 2 cycles
	task insertDataDirect(input reg[7:0] dataToinsert, input int operand );
	debug <= 1;
	Aadress_to_ram_debug <= instcount;
	Data_to_ram_debug <= (16 + operand); //first command inserted, which tells to load from next register
	@(posedge clk); //wait for positive edge of clk
	Aadress_to_ram_debug <= (instcount +1);
	instcount++;
	Data_to_ram_debug <= dataToinsert; //inserting data into register so CPU could read it
	$display ("@%g Inserted data %d into register %d", $time, (16 + operand), (instcount -1));
	@(posedge clk);
	@(negedge clk);//wait for negative edge of clock
	debug <= 0;
	Data_to_ram_debug <= 0;
    Aadress_to_ram_debug <= 0;
    instcount++;	
	$display ("@%g Inserted data %d into register %d", $time, dataToinsert, (instcount -1));
	endtask;
	
	//this task starts from falling edge ans ends at falling edge, lasts 1 cycle
	task insertIntoCell(input reg[7:0] aadressToInsert, dataToInsert);
	debug <= 1;
	Aadress_to_ram_debug <= aadressToInsert;
	Data_to_ram_debug <= dataToInsert;
	@(posedge clk);
	@(negedge clk);
	$display ("@%g Inserted data %d into register %d", $time, dataToInsert, aadressToInsert);
	debug <= 0;
	endtask;
	
	
	
endclass: Memory;


class Testprogram extends Memory;
    
    task DirectDataInsert(input reg[7:0] dataToinsert, input int operand);
        insertIntoCell(memoryposition, (16+operand) );
        memoryposition ++;
        insertIntoCell(memoryposition, dataToinsert);
        memoryposition++;
    endtask;
    
    task adding(input reg[7:0] operand1, operand2);
        insertIntoCell(memoryposition, 17);
        memoryposition++;
        insertIntoCell(memoryposition, operand1);
        memoryposition++;
        insertIntoCell(memoryposition, 18);
        memoryposition++;
        insertIntoCell(memoryposition, operand2);
        memoryposition++;
        insertIntoCell(memoryposition, 163); //adding command
        memoryposition++;
    endtask;
    
endclass: Testprogram;


Instruction laadimine1 = new;
Testprogram proge = new;
L_CPU my_cpu(reset, clk, Flags, debug, Data_to_ram_debug, Aadress_to_ram_debug);

initial begin
   //sisendite algväärtustamine
   clk<=0;
   reset<=1;
   debug<=1;
   Data_to_ram_debug <= 0;
   Aadress_to_ram_debug <= 0;
   
#10 reset<=0;

proge.adding(3, 5);

$display ("cpu flags value is %d" , Flags);

#150 $finish;
end


endmodule