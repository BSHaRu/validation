<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<c:set var="path" value="${pageContext.request.contextPath }" scope="session" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>header.jsp</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
</head>
<body>
	<header>
		<a href="${path }/regex">정규 표현식</a>
		<a href="${path }/user/join">회원가입</a>
		<a href="${path }/user/joinVal">회원가입 validata</a>
		<a href="${path }/user/login">로그인</a>
	</header>
