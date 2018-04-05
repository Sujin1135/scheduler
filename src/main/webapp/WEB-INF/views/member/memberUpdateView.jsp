<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<jsp:include page="../head/head.jsp" />
		
		<title>스케줄러 - 회원정보 관리</title>
		
		<script type="text/javascript">
			function doSubmit() {
				let name = trim("name");
				if (spaceCheck(name, "name", "이름을 입력하세요.") == 0) return;
				
				let param = {};
				param.name = name;
				param.gender = $$("gender").getValue();
				param.classes = $$("classes").getValue();
				param.dept = $$("dept").getValue();
				param.no = ${member};
				
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
					data: {"no": "${member}"},
					success: function(data, status, xhr) {
						if (data.result == "SUCCESS") {
							$$("email").setValue(data.EMAIL);
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
		
		<div class="article" style="margin-bottom: 15em;">
			<div style="text-align: center; margin-bottom: 3em;" >
				<h1>회원 정보</h1>
			</div>
		
			<div id="_updateForm"></div>
		</div>
		
		<jsp:include page="../footer/footer.jsp" />
		
		<script type="text/javascript">
			webix.ready(function() {
				webix.ui({
					container: "_updateForm",
					view: "layout",
					cols: [
						{},
						{
							rows: [
								{view: "text", type: "email", label: "이메일", id: "email", readonly: true},
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
						},
						{}
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