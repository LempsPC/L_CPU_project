`timescale 1ns/10ps
//+++++++++++++++++++++++++++++++++++++++++++++++
//   Testbench Code
//+++++++++++++++++++++++++++++++++++++++++++++++

//käsud, mida ma testin:
/*
liitmine - funktsioonile antakse 2 random arvu ette, kontrollib tulemust
ringnihe
dekrementeerimine
inverteerimine
võrdlus

*/

module L_CPU_tester2();

reg clk;
reg reset;
reg [4:0] Flags;
reg debug;
reg RW_debug;
reg [7:0] Data_to_ram_debug; 
reg [7:0] Aadress_to_ram_debug;
reg [7:0] Data_from_ram_debug;

always #5 clk ++;

int memoryposition = 0;
int randomnumber = 0;
reg [7:0] datareg, datareg2;
class Memory;
	
	int instcount = 0;
	/*---------------execute---------------*/
	//this task inserts direct loading command with corresponding operand and data which can be loaded into desired register
	//this task starts from falling edge ans ends at falling edge, lasts 2 cycles
	task insertDataDirect(input reg[7:0] dataToinsert, input int operand );
	debug <= 1;
	RW_debug <= 1;
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
	RW_debug <= 0;
	Data_to_ram_debug <= 0;
    Aadress_to_ram_debug <= 0;
    instcount++;	
	$display ("@%g Inserted data %d into register %d", $time, dataToinsert, (instcount -1));
	endtask;
	
	//this task starts from falling edge ans ends at falling edge, lasts 1 cycle
	task insertIntoCell(input reg[7:0] aadressToInsert, dataToInsert);
	debug <= 1;
	RW_debug <=1;
	Aadress_to_ram_debug <= aadressToInsert;
	Data_to_ram_debug <= dataToInsert;
	@(posedge clk);
	@(negedge clk);
	$display ("@%g Inserted data %d into register %d", $time, dataToInsert, aadressToInsert);
	debug <= 0;
	RW_debug <= 0;
	endtask;
	
	
	
endclass: Memory;


class Testprogram extends Memory;
    
    task DirectDataInsert(input reg[7:0] dataToinsert, input int operand);
        insertIntoCell(memoryposition, (16+operand) );
        memoryposition ++;
        insertIntoCell(memoryposition, dataToinsert);
        memoryposition++;
    endtask;
    
    
    //this task checks cpu addition operation with adding 2 numbers and then checking answers
    task adding(input reg[7:0] operand1, operand2);
        int result = 0;
        reset <=1;
        @(negedge clk);
        reset <= 0;
        insertIntoCell(memoryposition, 8'h11);
        memoryposition++;
        insertIntoCell(memoryposition, operand1);
        memoryposition++;
        insertIntoCell(memoryposition, 18);
        memoryposition++;
        insertIntoCell(memoryposition, operand2);
        memoryposition++;
        insertIntoCell(memoryposition, 163); //adding command
        memoryposition++;
        insertIntoCell(memoryposition, 40);
        memoryposition = memoryposition +1;
        //28 times loop, waiting for program to finish
        for( int i = 0; i < 28; i++) begin
            @(negedge clk);
        end;
        debug <= 1;
        Aadress_to_ram_debug <= memoryposition;
        @(posedge clk);
        $display ("Reading result from cell %d", memoryposition);
        result =  Data_from_ram_debug;
        $display ("Result value is %d" ,result); 
        @(posedge clk);
        debug <= 0;
        if (operand1 + operand2 != result)
            $display ("Fault in addition testing");
        else
            $display ("Addition testing completed successfully");
        memoryposition = 0;  
    endtask;
    
    task shiftleft(input reg[7:0] operand);
        
        int resultfromcpu = 0;
        reg[7:0] actualresult; 
        actualresult <= {operand[6:0], operand[7]}; 
        reset <= 1;
        @(posedge clk);
        
        $display("Shiftable value before shifting: %b", operand);
        $display("Actuable result should be: %b", actualresult);
        reset <= 0;
        
        insertIntoCell(memoryposition, 8'h11); //load into A register from next emmory cell
        memoryposition++;
        insertIntoCell(memoryposition, operand);
        memoryposition++;
        insertIntoCell(memoryposition, 8'hD3); //A shift left, result into C
        memoryposition++;
        insertIntoCell(memoryposition, 8'h28);
        memoryposition++;
        for( int i = 0; i < 20; i++) begin
            @(negedge clk);
        end;
        
        debug <= 1;
        $display ("Reading result from cell %d", memoryposition);
        resultfromcpu =  Data_from_ram_debug;
        
    endtask;
endclass: Testprogram;



Testprogram proge = new;
L_CPU my_cpu(reset, clk, Flags, debug, RW_debug, Data_to_ram_debug, Aadress_to_ram_debug, Data_from_ram_debug);

initial begin
   //sisendite algväärtustamine
   clk<=0;
   reset<=1;
   debug<=1;
   RW_debug<=0;
   Data_to_ram_debug <= 0;
   Aadress_to_ram_debug <= 0;
   datareg <= 8'h91;
#10 reset<=0;

proge.shiftleft($urandom_range(255,1));

/*
for(int i=0; i < 5; i++) begin
    proge.adding($urandom_range(128,1), $urandom_range(128,1));
end;
*/
    $display("Initial number is %b", datareg);
    datareg2 <= {datareg[6:0], datareg[7]};
    @(posedge clk);
    $display("Shifted left number is %b", datareg2);
    $finish;




end


endmodule