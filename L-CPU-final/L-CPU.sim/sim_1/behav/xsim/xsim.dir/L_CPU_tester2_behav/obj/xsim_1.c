/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_2(char*, char *);
extern void execute_68(char*, char *);
extern void execute_69(char*, char *);
extern void execute_74(char*, char *);
extern void execute_61(char*, char *);
extern void execute_62(char*, char *);
extern void execute_66(char*, char *);
extern void execute_67(char*, char *);
extern void execute_64(char*, char *);
extern void execute_65(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_73(char*, char *);
extern void execute_75(char*, char *);
extern void execute_76(char*, char *);
extern void execute_77(char*, char *);
extern void execute_78(char*, char *);
extern void execute_79(char*, char *);
extern void transaction_11(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_13(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_30(char*, char*, unsigned, unsigned, unsigned);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_1(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_3(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_4(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_5(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[28] = {(funcp)execute_2, (funcp)execute_68, (funcp)execute_69, (funcp)execute_74, (funcp)execute_61, (funcp)execute_62, (funcp)execute_66, (funcp)execute_67, (funcp)execute_64, (funcp)execute_65, (funcp)execute_71, (funcp)execute_72, (funcp)execute_73, (funcp)execute_75, (funcp)execute_76, (funcp)execute_77, (funcp)execute_78, (funcp)execute_79, (funcp)transaction_11, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_13, (funcp)transaction_30, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_0, (funcp)transaction_1, (funcp)transaction_3, (funcp)transaction_4, (funcp)transaction_5};
const int NumRelocateId= 28;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/L_CPU_tester2_behav/xsim.reloc",  (void **)funcTab, 28);
	iki_vhdl_file_variable_register(dp + 18656);
	iki_vhdl_file_variable_register(dp + 18712);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/L_CPU_tester2_behav/xsim.reloc");
}

void simulate(char *dp)
{
iki_register_root_pointers(1, 13864, 1,0) ; 
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/L_CPU_tester2_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 23064, dp + 21144, 0, 4, 0, 4, 5, 1);
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/L_CPU_tester2_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/L_CPU_tester2_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/L_CPU_tester2_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
