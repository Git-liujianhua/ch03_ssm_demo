<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() +
                      "://" +
                      request.getServerName() +
                      ":" +
                      request.getServerPort() +
                      request.getContextPath() +
                      "/";
%>
<base href="<%=basePath%>">
<link rel="stylesheet" href="static/css/bootstrap.css">
<script type="text/javascript" src="static/js/jquery-3.5.1.js"></script>
<script type="text/javascript" src="static/js/bootstrap.js"></script>




