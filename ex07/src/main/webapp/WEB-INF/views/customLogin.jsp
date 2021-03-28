<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
<body>
    <h1>Custom Login Page</h1>
    <h2><c:out value="${error}" /></h2>
    <h2><c:out value="${logout}" /></h2>

    <!-- 실제로 로그인의 처리 작업은 /login 을 통해서 이뤄지며, 반드시 POST 방식 사용할 것 -->
    <!-- 즉, GET:/customLogin => POST:/login -->
    <form method="post" action="/login">
        <div>
            <!-- name 속성은 기본적으로 username -->
            <input type="text" name="username" value="admin" />
        </div>
        <div>
            <!-- name 속성은 기본적으로 password -->
            <input type="password" name="password" value="admin" />
        </div>
        <div>
            <input type="checkbox" name="remember-me" /> Remember Me
        </div>
        <div>
            <input type="submit" />
        </div>

        <!-- CSRF(Cross-site request forgery, 사이트간 위조 방지) 공격과 토큰 : Spring Security 는 POST 방식을 이용하면 기본적으로 CSRF Token 사용 -->
        <!-- 예를 들어, 특정 유저의 권한 등급을 admin 으로 변경하는 코드를 A 사이트에 심어 놓고, -->
        <!-- A 사이트를 방문한 쇼핑몰 관리자가 해당 코드가 심어진 글을 클릭해서 그 코드를 실행시키면, 해커의 유저 등급은 admin 이 된다. -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

    <!-- 사용자가 인증 실패하면, 자동으로 다시 로그인 페이지로 이동 -->
</body>
</html>