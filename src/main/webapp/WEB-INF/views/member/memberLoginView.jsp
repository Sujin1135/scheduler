<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<jsp:include page="../head/head.jsp" />
		
		<title>로그인</title>
		
		<script type="text/javascript">
			function doSubmit() {
				var email = $$("email").getValue();
				
				if (spaceCheck(email, "email", "이메일을 입력하세요.") == 0) return;
				
				var pwd = $$("pwd").getValue();
				
				if (spaceCheck(pwd, "pwd", "비밀번호를 입력하세요.") == 0) return;
				
				var param = {};
				param.email = email;
				param.pwd = pwd;
				
				$.ajax({
					url:"${pageContext.request.contextPath}/member/loginMember.do",
					type: "POST",
					data: param,
					dataType: "json",
					success: function(data) {
						if (data.result == "SUCCESS") {
							goBack("${pageContext.request.contextPath}/sample/sampleListView", "로그인 하였습니다.");
						} else if (data.result == "IDFAIL") {
							alert("아이디가 존재하지 않습니다.");
						} else if (data.result == "PWDFAIL") {
							alert ("비밀번호가 다릅니다.");
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
		<div class="article">
			<div class="text-center">
				<h1>로그인</h1>
			</div>
			
			<div id="_login"></div>
		</div>
		
		<jsp:include page="../footer/footer.jsp" />
	
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
									{view: "text", type:"email", label:"이메일", id:"email"},
									{view: "text", type:"password", label:"password", id:"pwd"},
									{view: "button", label:"로그인", id:"submitButton"},
									{view: "button", label:"회원가입", id:"joinButton"}
								]
							},
							{}
						]
					}
				)
				
				enterSubmit("email");
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