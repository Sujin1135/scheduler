<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
		<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/resources/main.js"></script>
		
		<title>로그인</title>
		
		<script type="text/javascript">
			function doSubmit() {
				var name = $$("name").getValue();
				
				if (spaceCheck(name, "name", "이름을 입력하세요.")) return;
				
				var pwd = $$("pwd").getValue();
				
				if (spaceCheck(pwd, "pwd", "비밀번호를 입력하세요.")) return;
				
				var param = new Object();
				param.name = name;
				param.pwd = pwd;
				
				$.ajax({
					url:"${pageContext.request.contextPath}/member/loginMember.do",
					type: "POST",
					data: param,
					dataType: "json",
					success: function(data) {
						if (data.result == "SUCCESS") {
							goBack("${pageContext.request.contextPath}/sample/sampleListView", "로그인 하였습니다.");
						} else {
							alert("아이디 혹은 비밀번호가 다릅니다.");
						}
					},
					error: function(data) {
						alert(data.responseText);
					}
				});
			}
		</script>
	</head>

	<body>
		<div id="_login"></div>
	
		<script type="text/javascript">
			webix.ready(function () {
				webix.ui(
					{
						container: "_login",
						view: "layout",
						position: "center",
						cols: [
							{},
							{
								id: "login",
								view:"form",
								width: 400,
								rows:[
									{view: "text", label:"이름", id:"name"},
									{view: "text", type:"password", label:"password", id:"pwd"},
									{view: "button", label:"로그인", id:"submitButton"},
									{view: "button", label:"회원가입", id:"joinButton"}
								]
							},
							{}
						]
					}
				)
				
				enterSubmit("name");
				enterSubmit("pwd");
			
				$$("submitButton").attachEvent("onItemClick", function(id, e) {
					doSubmit();
				});
				
				$$("joinButton").attachEvent("onItemClick", function(id, e) {
					goBack("${pageContext.request.contextPath}/member/createView");
				});
			});
		</script>
	</body>
</html>