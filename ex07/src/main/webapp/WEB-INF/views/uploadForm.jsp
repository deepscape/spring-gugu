<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
    <form action="uploadFormAction" method="post" enctype="multipart/form-data">
        <!-- input tag name 속성으로 서버에서는 변수 지정 -->
        <input type='file' name='uploadFile' multiple>
        <button>Submit</button>
    </form>
</body>
</html>
