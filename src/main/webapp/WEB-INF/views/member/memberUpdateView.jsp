<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		
		<title>회원정보 관리</title>
		
		<script type="text/javascript">
			function doSubmit() {
				let name = trim("name");
				if (spaceCheck(name, "name", "이름을 입력하세요.")) return;
				
				let param = new Object();
				param.name = name;
				param.gender = $$("gender").getValue();
				param.classes = $$("classes").getValue();
				param.dept = $$("dept").getValue();
				param.no = ${member.NO};
				
				$.ajax({
					url: "${pageContext.request.contextPath}/member/update.do",
					type: "POST",
					data: param,
					dataType: "json",
					success: function (data, status, xhr) {
						if (data.result == "SUCCESS") {
							alert("회원정보를 수정하였습니다.");
							memberOne();
						} else if (data.result == "FAIL") {
							alert("수정에 실패하였습니다.");
						}
					},
					error: function (data, status, xhr) {
						alert(data.responseText);
					}
				});
			}
			
			function memberOne() {
				$.ajax({
					url: "${pageContext.request.contextPath}/member/memberOne",
					type: "GET",
					data: {"no": "${member.NO}"},
					success: function(data, status, xhr) {
						if (data.result == "SUCCESS") {
							$$("name").setValue(data.NAME);
							$$("gender").setValue(data.GENDER);
							$$("classes").setValue(data.CLASSES);
							$$("dept").setValue(data.DEPT);
						}
						if (data.errMsg) alert(data.errMsg);
					},
					error: function(data, status, xhr) {
						alert(data.responseText);
					}
				});
				
				
			}
		</script>
	</head>
	<body>
		<jsp:include page="../navbar/sampleNavbar.jsp" />
		
		<div id="_updateForm">
			<div style="text-align: center;">
				<h1>회원 정보</h1>
			</div>
		</div>
		<script type="text/javascript">
			webix.ready(function() {
				webix.ui({
					container: "_updateForm",
					view: "layout",
					rows: [
						{view: "text", label: "이름", id: "name"},
						{view: "radio", label: "성별", id: "gender", options: [
							{"id": 1, "value": "남자"},
							{"id": 2, "value": "여자"}
						]},
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
							label: "직급",
							id: "dept",
							options: [
								{"id": 1, "value": "인턴"},
								{"id": 2, "value": "사원"},
								{"id": 3, "value": "대리"},
								{"id": 4, "value": "과장"},
								{"id": 5, "value": "차장"},
								{"id": 6, "value": "부장"},
								{"id": 7, "value": "이사"},
								{"id": 8, "value": "대표이사"}
						]},
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
				});
				
				enterSubmit("name");
				enterSubmit("gender");
				enterSubmit("classes");
				enterSubmit("dept");
				
				$$("submitButton").attachEvent("onItemClick", function(id, e) {
					doSubmit();
				});
				
				$$("cancelButton").attachEvent("onItemClick", function(id, e) {
					goBack("${pageContext.request.contextPath}/sample/sampleListView");
				});
				
				memberOne();
			});
		</script>
	</body>
</html>