<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<jsp:include page="../head/head.jsp" />
		
		<title>스케줄러 - 회원등록</title>
		
		<script type="text/javascript">
			function doSubmit() {
				
				var email = $$("email").getValue();
				// 이메일 공백확인
				if (spaceCheck(email, "email", "이메일을 입력하세요.") == 0) return;
				
				var name = $$("name").getValue();
				
				// 이름 공백 확인
				if (spaceCheck(name, "name", "이름을 입력하세요.") == 0) return;
				
				var pwd = $$("pwd").getValue();
				var pwdCheck = $$("pwdCheck").getValue();
				
				// 비밀번호 공백 확인
				if (spaceCheck(pwd, "pwd", "비밀번호를 입력하세요") == 0) return;
				
				// 비밀번호확인 공백 확인
				if (spaceCheck(pwdCheck, "pwdCheck", "비밀번호 확인을 입력하세요.") == 0) return;
				
				// 비밀번호와 비밀번호 확인이 일치하는지
				if (pwd != pwdCheck) {
					alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					$$("pwd").focus();
					$$("pwdCheck").focus();
					return;
				}
				
				var dept = $$("dept").getValue();
				
				// 부서 선택여부 확인
				if (spaceCheck(dept, "dept", "부서를 선택하세요.") == 0);
				
				var classes = $$("classes").getValue();
				
				// 직급 선택여부 확인
				if (spaceCheck(classes, "classes", "직급을 선택하세요.") == 0);
				
				var gender = $$("gender").getValue();
				
				// 성별 선택여부 확인
				if (spaceCheck(gender, "gender", "성별을 선택하세요.") == 0);
				
				var param = {};
				
				param.name = name;
				param.email = email;
				param.pwd = pwd;
				param.gender = gender;
				param.dept = dept;
				param.classes = classes;
				
				if (memberValidation(param)) {
					return;
				}
				
				var result = {};
				
				$.ajax({
					url:"${pageContext.request.contextPath}/member/createMember.do",
					type:"POST",
					data: param,
					dataType: "json",
					success: function (data) {
						
						if (data.result == "SUCCESS") {
							alert("회원가입이 완료되었습니다. 로그인 하세요");
							goBack("${pageContext.request.contextPath}/member/loginView");
						} else {
							alert(data.errMsg);
						}
					},
					error: function (data) {
						alert(data.responseText);
					}
				});
			}
		</script>
	</head>
	<body>
		<div class="article">
			<div class="text-center">
				<h1>회원가입</h1>
			</div>
			
			<div id="_join"></div>
		</div>
		
		<jsp:include page="../footer/footer.jsp" />
		
		<script type="text/javascript">
		
			webix.ready(function() {
				webix.ui(
					{	
						container:"_join",
						view: "layout", 
						cols: [
							{},
							{
								view:"form",
								id: "join",
								width: 700,
								rows:[
									{ view:"text", type:"email", label: "이메일", id:"email"},
									{ view:"text", label:"이름", id:"name"},
									{ view:"text", type: "password", label: "비밀번호", id:"pwd"},
									{ view:"text", type: "password", label: "비밀번호 확인", id:"pwdCheck"},
									{
										view: "radio",
										id: "gender",
										label: "성별",
										options: [
											{"id": 1, "value": "남자"},
											{"id": 2, "value": "여자"}
										]
										
									},
									{
										view: "radio",
										id: "classes",
										label: "부서",
										options: [
											{"id": 1, "value": "사업"},
											{"id": 2, "value": "개발"},
											{"id": 3, "value": "경영"}
										]
									},
									{
										view: "radio",
										id: "dept",
										label: "직급",
										options: [
											{"id": 1, "value": "인턴"},
											{"id": 2, "value": "사원"},
											{"id": 3, "value": "대리"},
											{"id": 4, "value": "과장"},
											{"id": 5, "value": "차장"},
											{"id": 6, "value": "부장"},
											{"id": 7, "value": "이사"},
											{"id": 8, "value": "대표이사"}
										]
									},
									{
										view: "layout",
										cols: [
											{},
											{
												view: "button",
												id: "submitButton",
												label: "등록",
												width: 50
											},
											{
												view: "button",
												id: "cancelButton",
												label: "이전",
												width: 50
											},
											{}
										]
									}
								]
							},
							{}
						]
					}
				);
				
				// 입력 태그에서 엔터키를 누를경우 submit되게
				enterSubmit("email");
				enterSubmit("name");
				enterSubmit("pwd");
				enterSubmit("pwdCheck");
				enterSubmit("gender");
				enterSubmit("classes");
				enterSubmit("dept");
				
				$$("submitButton").attachEvent("onItemClick", function(id, e) {
					doSubmit();
				});
				
				$$("cancelButton").attachEvent("onItemClick", function(id, e) {
					goBack("${pageContext.request.contextPath}/member/loginView");
				});
			});
		</script>
	</body>
</html>