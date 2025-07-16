<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ua = request.getHeader("User-Agent");
	if(!ua.contains("Chrome")){
		out.print("<script>alert('지원하지 않는 브라우저 입니다.\\n권장 브라우저 : Chrome');window.open('about:blank','_self').close();</script>");
	}
%>