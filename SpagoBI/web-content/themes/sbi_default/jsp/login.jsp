<%-- SpagoBI, the Open Source Business Intelligence suite

Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. --%>

  
<%@ page language="java"
         extends="it.eng.spago.dispatching.httpchannel.AbstractHttpJspPagePortlet"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" 
         import="it.eng.spago.base.*,
                 it.eng.spagobi.commons.constants.SpagoBIConstants"
%>
<%@page import="it.eng.spagobi.commons.utilities.ChannelUtilities"%>
<%@page import="it.eng.spagobi.commons.utilities.messages.IMessageBuilder"%>
<%@page import="it.eng.spagobi.commons.utilities.messages.MessageBuilderFactory"%>
<%@page import="it.eng.spagobi.commons.utilities.urls.UrlBuilderFactory"%>
<%@page import="it.eng.spagobi.commons.utilities.urls.IUrlBuilder"%>
<%@page import="it.eng.spago.base.SourceBean"%>
<%@page import="it.eng.spago.navigation.LightNavigationManager"%>
<%@page import="it.eng.spagobi.utilities.themes.ThemesManager"%>
<%@page import="it.eng.spagobi.commons.constants.ObjectsTreeConstants"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Enumeration"%>


<%
	String contextName = ChannelUtilities.getSpagoBIContextName(request);	
    

	String authFailed = "";
	String startUrl = "";
	ResponseContainer aResponseContainer = ResponseContainerAccess
	.getResponseContainer(request);
	//RequestContainer requestContainer = RequestContainerAccess.getRequestContainer(request); 
	RequestContainer requestContainer = RequestContainer
	.getRequestContainer();
	//SessionContainer sessionContainer = requestContainer.getSessionContainer();

	SingletonConfig serverConfig = SingletonConfig.getInstance();
	String strActiveSignup = serverConfig
	.getConfigValue("SPAGOBI.SECURITY.ACTIVE_SIGNUP_FUNCTIONALITY");
	boolean activeSignup = (strActiveSignup.equalsIgnoreCase("true"))?true:false;

	String strInternalSecurity = serverConfig
	.getConfigValue("SPAGOBI.SECURITY.PORTAL-SECURITY-CLASS.className");
	boolean isInternalSecurity = (strInternalSecurity
	.indexOf("InternalSecurity") > 0) ? true : false;
	String roleToCheckLbl = 
	(SingletonConfig.getInstance().getConfigValue("SPAGOBI.SECURITY.ROLE_LOGIN") == null)?"" :
	 SingletonConfig.getInstance().getConfigValue("SPAGOBI.SECURITY.ROLE_LOGIN");
	String roleToCheckVal = "";
	if (!("").equals(roleToCheckLbl)) {
		roleToCheckVal = (request.getParameter(roleToCheckLbl) != null) ? request
		.getParameter(roleToCheckLbl) : "";
		if (("").equals(roleToCheckVal)) {
	//			roleToCheckVal = ( sessionContainer.getAttribute(roleToCheckLbl)!=null)?
	//						(String)sessionContainer.getAttribute(roleToCheckLbl):"";
	roleToCheckVal = (session.getAttribute(roleToCheckLbl) != null) ? (String) session
			.getAttribute(roleToCheckLbl) : "";
		}
	}

	String currTheme = ThemesManager.getCurrentTheme(requestContainer);
	if (currTheme == null)
		currTheme = ThemesManager.getDefaultTheme();

	if (aResponseContainer != null) {
		SourceBean aServiceResponse = aResponseContainer
		.getServiceResponse();
		if (aServiceResponse != null) {
	SourceBean loginModuleResponse = (SourceBean) aServiceResponse
			.getAttribute("LoginModule");
	if (loginModuleResponse != null) {
		String authFailedMessage = (String) loginModuleResponse
				.getAttribute(SpagoBIConstants.AUTHENTICATION_FAILED_MESSAGE);
		startUrl = (loginModuleResponse
				.getAttribute("start_url") == null) ? ""
				: (String) loginModuleResponse
						.getAttribute("start_url");
		if (authFailedMessage != null) {
			authFailed = authFailedMessage;
		}
	}
		}
	}

	IMessageBuilder msgBuilder = MessageBuilderFactory
	.getMessageBuilder();

	String sbiMode = "WEB";
	IUrlBuilder urlBuilder = null;
	urlBuilder = UrlBuilderFactory.getUrlBuilder(sbiMode);
%>






<%@page import="it.eng.spagobi.commons.SingletonConfig"%>
<html>
  <head>
  <style media="screen" type="text/css">

	input.login    {
	display:block;
	border: 1px solid #a9a9a9; 
	color: #7b7575;
	background:#d4d4d4; 
	height: 25px;
	width: 250px;
	-webkit-box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);
	-moz-box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);
	box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);
	}
	body {
with:100%;
height: 100%;
margin: 0;
background-repeat: no-repeat;
background-attachment: fixed;
	}
	td.login-label{
 	font-family: Tahoma,Verdana,Geneva,Helvetica,sans-serif;
	font-size: 10 px;
      color: #7d7d7d;
}

a:link{
 	font-family: Tahoma,Verdana,Geneva,Helvetica,sans-serif;
	font-size: 9px;
	color:#7d7d7d;
}
a:visited{
 	font-family: Tahoma,Verdana,Geneva,Helvetica,sans-serif;
	font-size: 9px;
	color: #7d7d7d;
}
a:hover{
 	font-family: Tahoma,Verdana,Geneva,Helvetica,sans-serif;
	font-size: 9px;
	color: #7d7d7d;
}
lable.lable_a{
 color: #FF6600;
 font-size: 16px;
 font-family: Tahoma,Verdana,Geneva,Helvetica,sans-serif;
font-weight: bold;
padding-right:10px;
}
 </style>
  
  
  <script type="text/javascript">
    function signup(){
    	var form = document.getElementById('formId');
    	var act = '${pageContext.request.contextPath}/restful-services/signup/prepare';
    	form.action = act;
    	form.submit();
    	
    }
	function escapeUserName(){
	
	userName = document.login.userID.value;
	
		if (userName.indexOf("<")>-1 || userName.indexOf(">")>-1 || userName.indexOf("'")>-1 || userName.indexOf("\"")>-1 || userName.indexOf("%")>-1)
			{
			alert('Invalid username');
			return false;
			}
		else
			{return true;}
	}
	
	function setUser(userV, pswV){
		var password = document.getElementById('password');
		var user = document.getElementById('userID');
		password.value = pswV;
		user.value = userV;
	//	document.forms[0].submit();
	}
	</script>
	<link rel="shortcut icon" href="<%=urlBuilder.getResourceLink(request, "img/favicon.ico")%>" />
    <title>SpagoBI</title>
    <style>
      body {
	       padding: 0;
	       margin: 0;
	       backgroud-color: #FFCC22;
      }
    </style> 
  </head>

  <body style='height:100%;backgroud-color: #FFCC22'>

	
	<LINK rel='StyleSheet' 
    href='<%=urlBuilder.getResourceLinkByTheme(request, "css/spagobi_shared.css",currTheme)%>' 
    type='text/css' />


	
        <form id="formId" name="login" action="<%=contextName%>/servlet/AdapterHTTP?PAGE=LoginPage&NEW_SESSION=TRUE" method="POST" onsubmit="return escapeUserName()">
        	<input type="hidden" id="isInternalSecurity" name="isInternalSecurity" value="<%=isInternalSecurity %>" />        	
        	<input type="hidden" id="<%=roleToCheckLbl%>" name="<%=roleToCheckLbl%>" value="<%=roleToCheckVal%>" />
        	<%	
        	//manages backUrl after login
        	String backUrl = (String)request.getAttribute(SpagoBIConstants.BACK_URL);
        	if (backUrl != null && !backUrl.equals("")) {
        		String objLabel = (String)request.getAttribute(SpagoBIConstants.OBJECT_LABEL);
        		backUrl += (backUrl.indexOf("?")<0)?"?":"&";
        		backUrl += "fromLogin=true";
			%>
			
			<input type="hidden" name="<%= SpagoBIConstants.BACK_URL %>" value="<%= backUrl %>" />
			<input type="hidden" name="<%= SpagoBIConstants.OBJECT_LABEL %>" value="<%= objLabel %>" />
			<input type="hidden" name="fromLogin" value="true" />
			<%
        	}
        	// propagates parameters (if any) for document execution
        	if (request.getParameter(ObjectsTreeConstants.OBJECT_LABEL) != null) {
        		String label = request.getParameter(ObjectsTreeConstants.OBJECT_LABEL);
        	    String subobjectName = request.getParameter(SpagoBIConstants.SUBOBJECT_NAME);
        	    %>
        	    <input type="hidden" name="<%= ObjectsTreeConstants.OBJECT_LABEL %>" value="<%= StringEscapeUtils.escapeHtml(label) %>" />
        	    <% if (subobjectName != null && !subobjectName.trim().equals("")) { %>
        	    	<input type="hidden" name="<%= SpagoBIConstants.SUBOBJECT_NAME %>" value="<%= StringEscapeUtils.escapeHtml(subobjectName) %>" />
        	    <% } %>
        	    <%
        	    // propagates other request parameters than PAGE, NEW_SESSION, OBJECT_LABEL and SUBOBJECT_NAME
        	    Enumeration parameters = request.getParameterNames();
        	    while (parameters.hasMoreElements()) {
        	    	String aParameterName = (String) parameters.nextElement();
        	    	if (aParameterName != null 
        	    			&& !aParameterName.equalsIgnoreCase("PAGE") && !aParameterName.equalsIgnoreCase("NEW_SESSION") 
        	    			&& !aParameterName.equalsIgnoreCase(ObjectsTreeConstants.OBJECT_LABEL)
        	    			&& !aParameterName.equalsIgnoreCase(SpagoBIConstants.SUBOBJECT_NAME) 
        	    			&& request.getParameterValues(aParameterName) != null) {
        	    		String[] values = request.getParameterValues(aParameterName);
        	    		for (int i = 0; i < values.length; i++) {
        	    			%>
        	    			<input type="hidden" name="<%= StringEscapeUtils.escapeHtml(aParameterName) %>" 
        	    								 value="<%= StringEscapeUtils.escapeHtml(values[i]) %>" />
        	    			<%
        	    		}
        	    	}
        	    }
        	} 
        	%>
        	
	        <div id="content" style="height:100%;">
		       
		        	<div style="padding-top:50px" >
		        	<!--
		        	DO NOT DELETE THIS COMMENT
		        	If you change the tag table with this one  you can have the border of the box with the shadow via css
		        	the problem is that it doesn't work with ie	
		     		
		     		<table style="background: none repeat scroll 0 0 #fff; border-radius: 10px 10px 10px 10px;  box-shadow: 0 0 10px #888; color: #009DC3; display: block; font-size: 14px; line-height: 18px; padding: 20px;">
		        	 -->

				<table border=0 align="center" style="border-collapse:separate;background: none repeat scroll 0 0;  color: #FF5511; display: block; font-size: 14px; padding-top:0px;">
				<tr>
				<td style="background-color:#FFFFFF;padding-left:145px">
				</td>
						<td style="background-color:#FFFFFF;">
						  <img
							src='<%=urlBuilder.getResourceLinkByTheme(request, "/img/wapp/title_q.jpg", currTheme)%>'
							width="100%" height="100%" style="margin: 0px auto;"/>
						</td>
						<td style="background-color:#FFFFFF;"></td>
					</tr>
					<tr style="background-color:#F4F5F9;">
					<td>
					</td>
						<td style="width:868px;background-color:#FFFFFF; align:right" >
						<img
							src="<%=urlBuilder.getResourceLinkByTheme(request, "/img/wapp/login_a.png", currTheme)%>"
							style="margin:auto;"/>
							
						</td>					
						<td with="250px">
							<table border=0 >
								<tr class='header-row-portlet-section'>
									<td class='login-label' width="90px" align="left">
									</td>
									<td width="25px">&nbsp;</td>
                                
								</tr>
								<tr>
									<td><input id="userID" name="userID" type="text" size="25" placeholder="用户名"
										class="login">
									</td>
									<td></td>

								</tr>
								<tr class='header-row-portlet-section'>
									<td class='login-label' width="90px" align="left">
									</td>
									<td width="25px">&nbsp;</td>

								</tr>

								<tr>
									<td><input id="password" name="password" type="password" placeholder="密码"
										size="25" class="login"></td>
									<td></td>

								</tr>
								<tr>
									<td colspan=3 height="30px">&nbsp;</td>
								</tr>
								<tr>
									<td>
									<table>
										<tr> 
										<% if (activeSignup){ %>
											<td>
												<a href="#"	onclick="signup();">
												<img
												src='<%=urlBuilder.getResourceLinkByTheme(request, "/img/wapp/signup.png", currTheme)%>'
												width='100px' height='37px' />
												</a>
											</td>
											<%} %>
											<td>
												<input type="image" align="left"
												src='<%=urlBuilder.getResourceLinkByTheme(request, "/img/wapp/sigin_a.PNG", currTheme)%>'
												title='<%=msgBuilder.getMessage("login")%>'
												alt='<%=msgBuilder.getMessage("login")%>'>
											</td>
											
										</tr>
									</table>
									</td>
									<td></td>
								</tr>
								<tr>
									<td colspan=3 height="30px">&nbsp;</td>
								</tr>

								<tr>
						
									<!-- Uncommet this for adding the Change Password Link -->
									<!-- <td class='login-label'><a
										href="<%=contextName %>/ChangePwdServlet?start_url=<%=startUrl%>">
											<%=msgBuilder.getMessage("changePwd")%> </a></td> -->
									<td>&nbsp;</td>
									<td class='login-label' width="150px"></td>
								</tr>

							</table>
						</td>
						
						
					</tr>							
								</table>

							</div></td>
						<td></td>
						<td></td>
					</tr>
					<tr style="background-color: #FFCC22">
						<td>&nbsp;</td>
						<td style='color: red; font-size: 11pt;'><br /><%=authFailed%></td>
						<td></td>
						<td>&nbsp;</td>
					</tr>

				</table>
			</div>
	        </div>
        </form>
        <spagobi:error/>

   
  </body>
</html>
