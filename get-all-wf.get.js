function main() {

    var currentdate = new Date();
    var taskDetailsList = [];
    var processDefinitionInstancesActiveList = [];
    var taskOwnerList = [];
    var GroupInitiatorList = [];

    var workflowlistAllDefinitions = workflow.getAllDefinitions();


    if (checkUserIsWF_MANAGER()) { // somente irá iniciar a pesquisa, se o usuario logado fizer parte do grupo: WF_MANAGERS
        for each(var workflowDefinition in workflowlistAllDefinitions) {

            var activeInstancesList = workflowDefinition.getActiveInstances();

            for each(var MyInstanceworkflow in activeInstancesList) {

                var WorkflowPathsList = MyInstanceworkflow.getPaths();
                for each(var currentPath in WorkflowPathsList) {
                    var currentTaskList = currentPath.getTasks();

                    for each(var currentTask in currentTaskList) {
                       
                        var wfDescription = "";
						var wfuserInitiator="";
						var owner =String(currentTask.getProperties().owner);
						if(owner=="null"){
							owner="N\u00e3o atribuido";
						}

                        if (currentTask.getProperties()["wfRepromaq:userInitiator"] != null) {
                            
							wfuserInitiator = (String(currentTask.getProperties()["wfRepromaq:userInitiator"]));
                        } 
                            wfDescription = (String(currentTask.getProperties()["bpm:workflowDescription"]));
                        
						
                        var taskDetails = {

                            workflowId: MyInstanceworkflow.getId(),
                            workflowGroupInitiator: wfuserInitiator,
							workflowName:String(workflowDefinition.getDescription()),
                            workflowDescription: String(wfDescription),                             
                            workflowStartDate: MyInstanceworkflow.getStartDate(),
						   currentTaskId: currentTask.getId(),  	
                            currentTaskdescription: currentTask.getDescription(),
                            currentTaskTitle: currentTask.getTitle(),
                            currentTaskOwner: owner,
                            currentTaskDueDate: currentTask.getProperties()["bpm:dueDate"],
                            currentTaskDueDateExpired: "No"
                        };
                        

                        if (!(taskDetails.currentTaskDueDate == undefined || taskDetails.currentTaskDueDate == null)) {
                            if (currentTask.getProperties()["bpm:dueDate"].getTime() < currentdate.getTime()) {

                                taskDetails.currentTaskDueDateExpired = "Yes";
                            }
                        }


                        taskDetailsList.push(taskDetails);

                        if (processDefinitionInstancesActiveList.indexOf(taskDetails.workflowName) == -1) {
                            processDefinitionInstancesActiveList.push(taskDetails.workflowName);
                        }

                        if (taskOwnerList.indexOf(taskDetails.currentTaskOwner) == -1) {
                            taskOwnerList.push(taskDetails.currentTaskOwner);
                        }

                        if (GroupInitiatorList.indexOf(taskDetails.workflowGroupInitiator) == -1) {
                            GroupInitiatorList.push(taskDetails.workflowGroupInitiator);
                        }
                        


                    }

                }
            }
        }
    }
	
    model.listTasks = taskDetailsList;
    model.acess = checkUserIsWF_MANAGER();
    model.processDefinitionInstancesActiveList = processDefinitionInstancesActiveList;
    model.taskOwnerList = taskOwnerList;
    model.GroupInitiatorList = GroupInitiatorList;
	model.groupCurrentUser=getWfGroup(person.properties.userName);
}

function checkUserIsWF_MANAGER() {
    var user;
    var strcurrentuser = person.properties.userName;	
    var currentuser = people.getPerson(strcurrentuser);
    var node = people.getGroup("GROUP_MANAGERS"); // 	
    if (node != null) {
        var membersGroup = people.getMembers(node);
        for each(var member in membersGroup) {
            if ("" + String(member.getNodeRef()) == String(currentuser.getNodeRef())) {				
                return "true";

            }
        }

    }
    return "false";
}

function getWfGroup(username) {
    //var strcurrentuser = person.properties.userName;	
    //var strcurrentuser = "itamar";	
    var currentuser = people.getPerson(username);
    var groupes = people.getContainerGroups(currentuser);
    for each(var g in groupes) {
        var group = g.getQnamePath();
        var p = group.split(":");
        var gname = String(p[p.length - 1]).toUpperCase();
        var keycompare = "WF";
        if (gname.search(keycompare) > -1) {
            return(gname.replace("GROUP_WF_", ""));
        }
    }

}


main();