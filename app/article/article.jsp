<%
if(session.getAttribute("userid")==null){
  response.sendRedirect(request.getContextPath()+"/login?redirect=/article?id="+request.getParameter("id"));
}
else if( session.getAttribute("role").equals("FARMER")){
%>


<jsp:include page="/app/user/layout.jsp">
  <jsp:param name="filename" value="<%=\"../article/article_view.jsp?id=\"+request.getParameter(\"id\") %>" />
  <jsp:param name="title" value="Article" />
</jsp:include>


<%
}
else if(session.getAttribute("role").equals("ADMIN") || session.getAttribute("role").equals("EXPERT")){
  out.println("Coming Soon");
} else {
  out.println("Page doesn't exist");
}
%>
