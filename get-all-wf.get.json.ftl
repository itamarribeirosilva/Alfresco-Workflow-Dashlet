<#macro dateTimeFormate date>${date?string("dd MMM yyyy HH:mm:ss")}</#macro>
<#macro dateFormat date>${date?string("dd MMM yyyy")}</#macro>
<#escape x as jsonUtils.encodeJSONString(x)>

{"acess": "${acess}", 
"groupCurrentUser": "${groupCurrentUser}", 
 "process":[
<#list processDefinitionInstancesActiveList as process>

{
   "workflowName": "${process}"
   
   } <#if process_has_next>,</#if>
   </#list>
   ],
   "taksowners":[
<#list taskOwnerList as taskowner>
{
   "taskowner": "${taskowner}"
  
   } <#if taskowner_has_next>,</#if>
   </#list>
   ],
   
   "workflowGroupsInitiators":[
<#list GroupInitiatorList as workflowGroupInit>
{
   "workflowGroupInit": "${workflowGroupInit}"
  
   } <#if workflowGroupInit_has_next>,</#if>
   </#list>
   ],

"tasks":[
<#list listTasks as task>

{
   "workflowId": "${task.workflowId}",
   "workflowGroupInitiator": "${task.workflowGroupInitiator}",
   "workflowName": "${task.workflowName}",
   "workflowDescription": "${task.workflowDescription}",
   "workflowStartDate": "<@dateTimeFormate task.workflowStartDate />",
   "currentTaskId": "${task.currentTaskId}", 
   "currentTaskdescription": "${task.currentTaskdescription}",   
   "currentTaskTitle": "${task.currentTaskTitle}",
   "currentTaskOwner": "${task.currentTaskOwner}",
   "currentTaskDueDate": <#if task.currentTaskDueDate?? > "<@dateFormat task.currentTaskDueDate />" <#else> "" </#if>,	
   "currentTaskDueDateExpired": "${task.currentTaskDueDateExpired}"
   } <#if task_has_next>,</#if>
   </#list>
   ]
}
</#escape>