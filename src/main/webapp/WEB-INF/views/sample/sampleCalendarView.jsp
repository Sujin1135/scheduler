<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<jsp:include page="../head/head.jsp" />
		
		<link href="${pageContext.request.contextPath}/resources/fullcalendar-3.9.0/fullcalendar.min.css" rel="stylesheet" type="text/css" />
		<script src="${pageContext.request.contextPath}/resources/fullcalendar-3.9.0/lib/moment.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/fullcalendar-3.9.0/fullcalendar.min.js"></script>
		
		<title>Insert title here</title>
		
		<script>
			function doSubmit() {
				/*
				*	풀캘린더 특성상 캘린더가 한번만 랜더링된다
				*	풀캘린더 div를 없앤 후 다시 생성한 후 랜더링시킨다
				*/
				$("#calendar-div").empty();
				$("#calendar-div").html('<div id="calendar"></div>');
				
				var param = {};
				param.likeTitle = trim("likeTitle");
			    param.calendarSelect = $$("calendarSelect").getValue();
			    param.typeSelect = $$("typeSelect").getValue();
			    
			    param.result = "CALENDAR";
			    
			    var contextPath = "${pageContext.request.contextPath}";
			    var memberNo = ${member};
				
				$.ajax({
					url: "${pageContext.request.contextPath}/sample/searchSample.do",
					type: "POST",
					data: param,
					dataType: "json",
					success: function(data) {
						setCalendar(data.sampleList, contextPath, memberNo);
					},
					error: function(data) {
						alert(data.responseText);
					}
				});
			}
		</script>
	</head>
	<body>
		<jsp:include page="../navbar/sampleNavbar.jsp" />
		<div>
			<div id="_search">
			</div>
		</div>
		
		<jsp:include page="../sample/sampleCalendar.jsp" />
		<jsp:include page="../footer/footer.jsp" />
	</body>
	<script>
		
		webix.ready(function() {
			webix.ui({
				container: "_search",
				view: "layout",
				cols: [
					{},
					{
						view:"select",
						id:"calendarSelect",
						options: [
							{"id": 0, "value": "전체"},
							{"id": 1, "value": "휴가"},
							{"id": 2, "value": "회의"},
							{"id": 3, "value": "교육"},
							{"id": 4, "value": "외근"}
						],
						width: 70
					},
					{
						view:"select",
						id:"typeSelect",
						options: [
							{"id": 1, "value": "이름"},
							{"id": 2, "value": "제목"}
						],
						width: 70
					},
					{
						view:"text",
						id:"likeTitle",
						width:350
					},
					{
						view:"button",
						id:"sampleSearchButton",
						label:"검색",
						width:50
					},
					{}
				]
			});
			
			// submit event
			$$("sampleSearchButton").attachEvent("onItemClick", function(id, e) {
				doSubmit();
			});
			
			// 검색창과 선택창에서 엔터를 누를경우 검색되게
			enterSubmit("likeTitle");
			enterSubmit("calendarSelect");
			enterSubmit("typeSelect");
			
			doSubmit();
		});
		
		
	</script>
</html>