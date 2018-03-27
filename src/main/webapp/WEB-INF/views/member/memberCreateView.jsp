<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>회원 등록</title>
		
		<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
		<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
		<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/resources/main.js"></script>
		
		<script type="text/javascript">
			function doSubmit() {
				
				var name = $$("name").getValue();
				
				// 이름 공백 확인
				if (name == null || name == "" || name.length == 0 ) {
					alert("이름을 입력하세요.");
					$$("name").focus();
					return;
				}
				
				var pwd = $$("pwd").getValue();
				var pwdCheck = $$("pwdCheck").getValue();
				
				// 비밀번호 공백 확인
				if (pwd == null || pwd == "" || pwd.length == 0) {
					alert("비밀번호를 입력하세요.");
					$$("pwd").focus();
					return;
				}
				
				// 비밀번호확인 공백 확인
				if (pwdCheck == null || pwdCheck == "" || pwdCheck.length == 0) {
					alert("비밀번호 확인을 입력하세요.");
					$$("pwdCheck").focus();
					return;
				}
				
				if (pwd != pwdCheck) {
					alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					$$("pwd").focus();
					$$("pwdCheck").focus();
					return;
				} 
				
				var dept = $$("dept").getValue();
				
				// 부서 선택여부 확인
				if (dept == null || dept == "" || dept.length == 0) {
					alert("부서를 선택해 주세요.");
					$$("dept").focus();
					return;
				}
				
				var classes = $$("classes").getValue();
				
				// 직급 선택여부 확인
				if (classes == null || classes == "" || classes.length == 0) {
					alert("직급을 선택해 주세요");
					$$("classes").focus();
					return;
				}
				
				var gender = $$("gender").getValue();
				
				// 성별 선택여부 확인
				if (gender == null || gender == "" || gender.length == 0) {
					alert("성별을 선택해 주세요");
					$$("gender").focus();
					return;
				}
				
				var param = new Object();
				
				param.name = name;
				param.pwd = pwd;
				param.gender = gender;
				param.dept = dept;
				param.classes = classes;
				
				var result = new Object();
				
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
		<div id="_join"></div>
	
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