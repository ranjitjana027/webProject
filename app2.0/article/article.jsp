<%
/*if(session.getAttribute("userid")==null){
  response.sendRedirect(request.getContextPath()+"/login?redirect=/calendar");
}
else if( session.getAttribute("role").equals("FARMER")){*/
%>


<jsp:include page="/app2.0/template/layout.jsp">
  <jsp:param name="filename" value="<%=\"../article/article_view.jsp?id=\"+request.getParameter(\"id\") %>" />
  <jsp:param name="cssfile" value="/assets/css/article2.0/article.css" />
  <jsp:param name="title" value="Article" />
</jsp:include>


<%
/*}
else if(session.getAttribute("role").equals("ADMIN") || session.getAttribute("role").equals("EXPERT")){
  out.println("Coming Soon");
} else {
  out.println("Page doesn't exist");
}*/
%>