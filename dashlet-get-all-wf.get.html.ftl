<script type="text/javascript">//<![CDATA[
	new Alfresco.widget.DashletResizer("${args.htmlid}", "${instance.object.id}");
	//]]>
</script>
<style>
	table {
	border-collapse: collapse;
	width: 100%;
	}
	th, td {
	text-align: left;
	padding: 8px;
	}
	tr:nth-child(even){background-color: #f2f2f2}
	th {
	background-color: #4CAF50;
	color: white;
	}
	wfbutton {
		background-color: #4CAF50; /* Green */
		border: none;
		color: white;
		padding: 7px 15px;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		font-size: 12px;
}	
</style>

<div style="display:none" id="noitens">${msg("list.empty")}</div>
<div style="display:none" id="selectfilter">${msg("value.select")}</div>
<div style="display:none" id="groupthisuser">${groupCurrentUser}</div>

<#if acess == "true"> 
<div style="display:none" id="apllyfiltergroup">false</div>
<#else>	
<div style="display:none" id="apllyfiltergroup">true</div>
</#if>	

		<table id="ghostlist" style="display:none">
			<#list listTasks as task>
			
			<tr>
			 <td><a href="${url.context}/page/workflow-details?workflowId=${task.workflowId}" class="rowlink">				
					<#if task.currentTaskDueDateExpired == "Yes" >
					<img src="/share/res/components/images/account_disabled.png" > 
					<#else>
					<img src="/share/res/components/images/account_enabled.png" >
					</#if>
					${task.workflowName}					
				</td>
				<td>${task.workflowDescription}</td>
				<td>${task.workflowStartDate}</td>
			<!--	<td>${task.currentTaskdescription}</td>-->
				<td><a href="${url.context}/page/task-edit?taskId=${task.currentTaskId}" class="rowlink">	
				${task.currentTaskTitle}				
				</td>
				
				<td>${task.currentTaskOwner}</td>
				<td>${task.currentTaskDueDate}</td>
				<td>${task.workflowGroupInitiator}</td>
				</a>
			</tr>
				
			</#list>       
		</table>
		<div class="dashlet">
			<div class="title" id="labeltaskcount">${msg("header")}: <label id="taskcount"></label> </div>
			
			
			<div class="toolbar flat-button">
				<div class="align-left yui-button yui-menu-button">
					${msg("label.processfilter")} 
					<select id="processdefintion" class="select-width-auto border-width-01">
						<option value="">${msg("value.select")}</option>
						<#if processList?? && (processList?size > 0)>
						<#list processList as process>				
						<option value=${process.workflowName}>${process.workflowName}</option>
						</#list>  
						</#if>	
					</select>
					${msg("label.userownerfilter")} 
					<select id="userowner" class="select-width-auto border-width-01">
						<option value="">${msg("value.select")}</option>
						<#if taskOwnerList?? && (taskOwnerList?size > 0)>
						<#list taskOwnerList as owner>				
						<option value=${owner.taskowner}>${owner.taskowner}</option>
						</#list>  
						</#if>		   			
					</select>
					${msg("label.groupinitiatorfilter")}
					<select id="groupinitiator" class="select-width-auto border-width-01">
						<option value="">${msg("value.select")}</option>
						<#if GroupInitiatorList?? && (GroupInitiatorList?size > 0)>
						<#list GroupInitiatorList as groupinitiator>				
						<option value=${groupinitiator.workflowGroupInit}>${groupinitiator.workflowGroupInit}</option>
						</#list>  
						</#if>		   			
					</select>
					<div class="align-right yui-button yui-push-button search-icon border-width-0">
						<wfbutton id="search-workflows-button" type="button" onclick="myFunction()"> ${msg("btn.search")}</wfbutton>
					</div>
				</div>
				<span class="align-right yui-button-align">
                  <span class="first-child">
                     <a href="${url.context}/page/start-workflow" class="theme-color-1">
                        <img src="${url.context}/res/components/images/workflow-16.png" style="vertical-align: text-bottom" width="16" />
                        ${msg("link.startworkflow")}</a>
                  </span>
               </span>
			</div>
			<div class="body scrollableList" <#if args.height??>style="height: ${args.height}px;"</#if>>
			<div class="detail-list-item first-item last-item">		
				<table id="tbheader" style="display:none">		
					<thead>
						<tr>
							<th>${msg("label.workflowName")}</th>
							<th>${msg("label.workflowDescription")}</th>
							<th>${msg("label.workflowStartDate")}</th>
							<!--<th>${msg("label.currentTaskdescription")}</th> -->
							<th>${msg("label.currentTaskTitle")}</th>
							<th>${msg("label.currentTaskOwner")}</th>
							<th>${msg("label.currentTaskDueDate")}</th>
							<th>${msg("label.workflowGroupInitiator")}</th>		
														
						</tr>
					</thead>		
				</table>
				<table id="maintable" >		
						
				</table>
			</div>
		</div>
		<script>
		function myFunction(){					
			var table = document.getElementById("maintable");
			var tableghost = document.getElementById("ghostlist");
			var comboo = document.getElementById("userowner");
			var owner = comboo.options[comboo.selectedIndex].text;	 
			var combot = document.getElementById("processdefintion");
			var process = combot.options[combot.selectedIndex].text;
	        var comboinit = document.getElementById("groupinitiator");
			var ginit = comboinit.options[comboinit.selectedIndex].text;
			var apllyfiltergroup = document.getElementById("apllyfiltergroup").innerHTML;	
            var groupthisuser=  document.getElementById("groupthisuser").innerHTML;	
			var taskcounter=0;	
			
			if (tableghost.rows.length > 0){
				taskcounter=0;
				table.innerHTML="";
				table.innerHTML=document.getElementById("tbheader").innerHTML;
				for (var i = 0, row; row = tableghost.rows[i]; i++) {
				    
					var show= true;			
					if (owner!=document.getElementById("selectfilter").innerHTML){  
						if (row.cells[4].innerHTML!=owner)	
							show=false;
					}	
					if (process!=document.getElementById("selectfilter").innerHTML){						
						if (row.cells[0].innerHTML.includes(process)==false)	
							show=false;			
					}
					if (ginit!=document.getElementById("selectfilter").innerHTML){						
						if (row.cells[6].innerHTML!=ginit)	
							show=false;								
					}	
					
					if (apllyfiltergroup=="true"){		
						if (row.cells[6].innerHTML!=groupthisuser)	
							show=false;								
					}
					
					if (show){
					    taskcounter ++;
						var rown = table.insertRow(table.rows.length);
						for (var j = 0, col; col = row.cells[j]; j++) {
							var cell1 = rown.insertCell(j);
							cell1.innerHTML = col.innerHTML;								
						}  
					}					
				}				
				if (table.rows.length == 0){
					table.innerHTML="";
					var row = table.insertRow(0);
					var cell1 = row.insertCell(0);
					cell1.innerHTML = "sem nada heheheh";				
				}
			}
			else{		
				table.innerHTML="";
				var row = table.insertRow(0);
				var cell1 = row.insertCell(0);
				cell1.innerHTML = document.getElementById("noitens").innerHTML;
			}
			document.getElementById("taskcount").innerHTML = String(taskcounter);
			
		}
		myFunction();
		
		</script>
		</div>
		