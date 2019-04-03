function main()
{
	    var json = remote.call("/worflowdashlet/get-all-wf.get");
  
        var results = eval('(' + json + ')');
  
	model.listTasks = results["tasks"]; 
	model.GroupInitiatorList = results["workflowGroupsInitiators"];
	model.acess = results["acess"];
	model.processList=results["process"];
	model.taskOwnerList=results["taksowners"];
	model.groupCurrentUser=results["groupCurrentUser"];
}
main();




