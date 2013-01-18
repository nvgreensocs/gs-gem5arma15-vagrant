/*
 */

/*CS******************************************************************

 Project :	

 Author	:   

 Date	:	

 File	:	

 Purpose	:	

 Description:



 ******************************************************************CE*/
/*************** standard files inclusion ***************/
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <execinfo.h>
#include <signal.h>
#include <stdlib.h>
#include <limits.h>
#include <Python.h>

/*************** pre-processor options definition ***********/

/*************** application files inclusion ***************/

#ifdef CHECK_MEM_LEAKS
#include "MemoryTrace.hpp"
#endif
#ifdef GOOPROF
#include <google/profiler.h>
#endif

#include "greencontrol/gcnf/plugin/configdatabase.h" // ConfigDatabase to be bound to port of ConfigPlugin
#include "greencontrol/gcnf/apis/luaFileApi/luafile_tool.h" // lua file tool

#include <boost/filesystem.hpp>
#include <boost/program_options.hpp>

#include "sim/init.hh"
#include "sim/core.hh"

#include "cortexA15_wrapper.hpp"
#include "ace_slave_wrapper.hpp"

using namespace boost::filesystem;

/*************** macros definition ***************/

/*************** types definition ***************/

/*************** constants definition ***************/

/*************** pre-processor autocheck ***************/

/*************** global variables and arrays definition ***************/

std::string output_dir;
lua_State* L;
std::string nerios_design_name;


/*************** local variables and arrays definition ***************/

/*************** local routines definition ***************/

char* exe = 0;

int initialiseExecutableName()
{
    char exepath [PATH_MAX] = {0};
    ssize_t result = readlink("/proc/self/exe", exepath, sizeof(exepath));
    printf("Executable name initialized: %s\n",exepath);
    exe=exepath;
}

const char* getExecutableName()
{
    if (exe == 0)
        initialiseExecutableName();
    return exe;
}

/* get REG_EIP from ucontext.h */
#define __USE_GNU
#include <ucontext.h>


/*************** functions definition  ***************/

int sc_main(int argc, char **argv)
{
   
    cout << "*************************************************" << endl;
    cout << "A15 testbench VERSION " << __DATE__ << " " << __TIME__ << endl;
    cout << "*************************************************" << endl;

	// Parsing arguments
	std::vector<std::string> config_files;


    namespace po = boost::program_options;
	// Declare the supported options.
	po::options_description desc("Allowed options");
	desc.add_options()
    	("help", "produce help message")
    	("lua-config", po::value<std::vector<std::string> >()->multitoken(), "lua configuration files")
	;

	po::variables_map vm;
	po::store(po::parse_command_line(argc, argv, desc), vm);
	po::notify(vm);    

	if (vm.count("help")) {
		cout << desc << std::endl;
		return 1;
	}

	if (vm.count("lua-config"))
	{
		config_files= vm["lua-config"].as< std::vector<std::string> >();
	}

	output_dir=".";

	//GreenConfig...

	  /// GreenControl Core instance
	  gs::ctr::GC_Core       core();

	  // GreenConfig Plugin
	  gs::cnf::ConfigDatabase* cnfdatabase = new gs::cnf::ConfigDatabase("ConfigDatabase");
	  gs::cnf::ConfigPlugin configPlugin(cnfdatabase);

	  //LuaTool

		/* initialize Lua */
		L = luaL_newstate();

		/* load Lua base libraries */
		luaL_openlibs(L);

	  gs::cnf::LuaFile_Tool luareader("luareader");
	  for (unsigned i = 0; i< config_files.size(); i++ )
	  {
		if (luareader.config(config_files.at(i).c_str()) != 0)
		{
			cout << "ERROR in the lua config file " << config_files.at(i) << "...aborting" << endl;
			exit(-1);
		}
		/* run the script */
		luaL_loadfile(L, config_files.at(i).c_str());
	  }

	// Show the config values which have been set

	std::ofstream* fout = new ofstream((output_dir+"/Config_settings.txt").c_str());
	gs::cnf::cnf_api* capi = gs::cnf::GCnf_Api::getApiInstance(NULL);
	std::vector<std::string> vars= capi->getParamList();

	for (unsigned v = 0;v<vars.size();v++)
	{
		(*fout) << "[LUA] " << vars[v] << " = " << capi->getValue(vars[v]) << std::endl;
	}

	// Create the architecture

	sc_core::sc_object* a15 = create_cortexA15 ("A15");
	sc_core::sc_object* ace_slave = create_ace_slave ("ace_slave");
	nerios_design_name = "A15";
	
	// Connect the architecture
	
	//Connecting the master/slave ACE
	amba::amba_master_socket<> *tout = NULL;
	amba::amba_slave_socket<> *tin = NULL;
	
	
	std::vector<sc_object*> children = ace_slave->get_child_objects() ;
	for (uint32_t i = 0; i < children.size(); i++)
	{
		if (std::string(children[i]->basename()) == "ace_slave")
			tin = dynamic_cast<amba::amba_slave_socket<>*> (children[i]);
	}
	
	children = a15->get_child_objects() ;
	for (uint32_t i = 0; i < children.size(); i++)
	{
		if (std::string(children[i]->basename()) == "A15_toACEbridge")
		{
			std::vector<sc_object*> children2 = children[i]->get_child_objects() ;
			for (uint32_t j = 0; j < children2.size(); j++)
			{
				if (std::string(children2[j]->basename()) == "ace_master")
					tout = dynamic_cast<amba::amba_master_socket<>*> (children2[j]);
			}
		}
	}
	assert(tin);
	assert(tout);
	tout->bind(*tin);

	//Connecting master/slave debug ports
	multi_passthrough_target_socket<ACE_slave <128> > *dbg_in = NULL;
	tlm::tlm_initiator_socket<> *dbg_out=NULL;

	children = ace_slave->get_child_objects() ;
	for (uint32_t i = 0; i < children.size(); i++)
	{
		if (std::string(children[i]->basename()) == "debug_port")
			dbg_in = dynamic_cast<multi_passthrough_target_socket<ACE_slave <128> > *> (children[i]);
	}
	
	children = a15->get_child_objects() ;
	for (uint32_t i = 0; i < children.size(); i++)
	{
		if (std::string(children[i]->basename()) == "A15_toACEbridge")
		{
			std::vector<sc_object*> children2 = children[i]->get_child_objects() ;
			for (uint32_t j = 0; j < children2.size(); j++)
			{
				if (std::string(children2[j]->basename()) == "debug_master")
					dbg_out = dynamic_cast<tlm::tlm_initiator_socket<> *> (children2[j]);
			}
		}
	}
	assert(dbg_in);
	assert(dbg_out);
	dbg_out->bind(*dbg_in);

	// GEM5 support

    // Initialize m5 special signal handling.
    // initSignals();

    //Py_SetProgramName(argv[0]);

    // initialize embedded Python interpreter
    Py_Initialize();

    // Initialize the embedded m5 python library
    int ret = initM5Python();

	// Turn off the deprecated warning
	sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);


#ifdef CHECK_MEM_LEAKS
    // starting monitoring allocations
    leaktracer::MemoryTrace::GetInstance().startMonitoringAllThreads();
#endif

#ifdef GOOPROF
    ProfilerStart("NeriosProf");
#endif

    sc_set_stop_mode(sc_core::SC_STOP_IMMEDIATE);

	// Start the simulation

	time_t start_time = time(NULL);
	
    /* The following few lines are specific to setting the Run Length through LUA.
     * The values passed through -d and -u are ignored if the LUA file has the
     * run length specified using "TestRunLengthMicroSec".
     */
	bool hasException=false;
	try
	{
		sc_start(1000000, SC_US);
	} 
	catch (const std::exception& ex) 
	{
	    std::cout << "EXITING AFTER CATCHING AN EXCEPTION: " << ex.what() << std::endl;
	    hasException=true;
	} 
	catch (const std::string& ex) 
	{
		std::cout << "EXITING AFTER CATCHING AN EXCEPTION STRING: " << ex << std::endl;
		hasException=true;
	} 
	catch (...) 
	{
		std::cout << "EXITING AFTER CATCHING AN UNKNOWN EXCEPTION: " << std::endl;
		hasException=true;
	}
	// Simulation MUST execute an sc_stop in order to force execution of end_of_simulation method
	//   in each module
	sc_stop();
	if (hasException)
	{
		  void *trace[16];
		  char **messages = (char **)NULL;
		  int i, trace_size = 0;
		  trace_size = backtrace(trace, 16);
		  messages = backtrace_symbols(trace, trace_size);
		  /* skip first stack frame (points here) */
		  printf("[bt] Execution path:\n");
		  for (i=1; i<trace_size; ++i)
		  {
			  printf("[bt] #%d %s\n", i, messages[i]);
		    char syscom[256];
		    sprintf(syscom,"addr2line %p -e %s", trace[i] , getExecutableName() ); //last parameter is the name of this app
		    int result = system(syscom);
		  }
	}


	// clean up Python intepreter.
	Py_Finalize();

#ifdef GOOPROF
    ProfilerStop();
#endif

#ifdef CHECK_MEM_LEAKS
    // stop all monitoring, print report
    leaktracer::MemoryTrace::GetInstance().stopAllMonitoring();

    std::ofstream oleaks;
    oleaks.open("leaks.out", std::ios_base::out);
    if (oleaks.is_open())
            leaktracer::MemoryTrace::GetInstance().writeLeaks(oleaks);
    else
            std::cerr << "Failed to write to \"leaks.out\"\n";

    oleaks.close();
#endif

	  // Dump out the new "ti_collector" statistics.
	  //ti_collector_registry::print(output_dir+"/collector_stats.rpt");

	  /* cleanup Lua */
	  	lua_close(L);

	time_t end_time = time(NULL);
	cout << "Simulation took " << difftime(end_time, start_time) << " seconds"	<< endl;

	return 0;
}
