<%
if(session.getAttribute("userid")==null )
	response.sendRedirect("../index.jsp");
else{
%>
<!DOCTYPE html>
<html>
<head>
	<title><%= ((String)session.getAttribute("role")).substring(0,1).toUpperCase()+((String)session.getAttribute("role")).substring(1).toLowerCase() %> | Dashboard</title>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<%
	if(session.getAttribute("role").equals("FARMER")){
	%>
		<link rel="stylesheet" href="../../assets/css/user/dashboard.css">
		<link rel="stylesheet" href="../../assets/css/user/header.css">
		<link rel="stylesheet" href="../../assets/css/user/footer.css">
		<script src="../../assets/js/admin/layout.js" charset="utf-8"></script>
	<% }
	%>

</head>
<body>
	<%
	if(session.getAttribute("role").equals("FARMER")){
	%>
		<div class="grid">
			<jsp:include page="header.jsp" >
				<jsp:param name="userid" value="<%= session.getAttribute(\"userid\") %>" />
			</jsp:include >
			<!-- page content -->
			<div class="grid-section">
				<div class="grid-left">
					<div class="weather-window">
					<jsp:include page="../weather/weather.html"/>
					</div>
					<div class="ad-window">
					<jsp:include page="../ad/ad.jsp" />
					</div>
				</div>
				<div class="grid-content">
					<div class="grid-item5">
						<div>
							Welcome to our site!<br>
							<h2>Stay Home, Be Safe.</h2>

							<jsp:include page="../article/article.html" />
						</div>
					</div>
					<div class="grid-item6">
						<h3>Trending Topics</h3>

					</div>
				</div>


			</div>

			<jsp:include page="footer.html" />
		</div>
	<% }else if(session.getAttribute("role").equals("ADMIN")){
	%>

	<%
	response.sendRedirect("../admin/dashboard.jsp");
	}
	%>

	</body>
</html>
<%
}
%>
