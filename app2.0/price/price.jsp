<%
/*if(session.getAttribute("userid")==null){
  response.sendRedirect(request.getContextPath()+"/login?redirect=/calendar");
}
else if( session.getAttribute("role").equals("FARMER")){*/
%>


<jsp:include page="/app2.0/template/layout.jsp">
  <jsp:param name="filename" value="../price/price_view.jsp"/>
  <jsp:param name="cssfile" value="/assets/css/price/price.css" />
  <jsp:param name="title" value="Crop Price" />
</jsp:include>


<%
/*}
else if(session.getAttribute("role").equals("ADMIN") || session.getAttribute("role").equals("EXPERT")){
  out.println("Coming Soon");
} else {
  out.println("Page doesn't exist");
}*/
%>
