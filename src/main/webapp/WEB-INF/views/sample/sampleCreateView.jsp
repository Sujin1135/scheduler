<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>sample list</title>
<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/main.js?ver=1"></script>

<script type="text/javascript">

// Submit
function doSubmit() {
	/*
	* spaceCheck(Object, 태그id, alert내용)을 입력하여 널체크와 경고창을 띄우는 메서드
	* trim(태그id)는 해당 태그id의 getValue값의 좌우 공백이 있을 경우 좌우 공백을 제거해주는 메서드
	*/
	var memberNo = ${member.NO};
	
	var title = trim("TITLE");
	if (spaceCheck(title, "TITLE", "제목을 입력하세요.")) return;
	
	var content = trim("CONTENT");
	if (spaceCheck(content, "CONTENT", "내용을 입력하세요.")) return;
	
	var type = $$("TYPE").getValue();
	if (spaceCheck(type, "TYPE", "일정 종류를 체크하세요.")) return;
	
	var startDate = dateFormat($$("STARTDATE").getValue());
	if (spaceCheck(startDate, "STARTDATE", "일정 시작일을 입력하세요")) return;
	
	var endDate = dateFormat($$("ENDDATE").getValue());
	if (spaceCheck(endDate, "ENDDATE", "일정 종료일을 입력하세요")) return;
	
	// param에 값 저장
	var param = new Object();
	param.TITLE = title;
	param.CONTENT = content;
	param.TYPE = type;
	param.STARTDATE = startDate;
	param.ENDDATE = endDate;
	param.MEMBERNO = memberNo;
	
	var result = new Object();
	
	// 서버에 데이터 전송
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/sample/insertSample.do",
		async:false,
		data:param,
		dataType:"json",
		success:function(data, status, xhr){
			result = data;
		},
		error:function(data, status, xhr){
			alert(data.responseText);
		}
	});
	
	// result 키값에 저장한다.
	if(result.result == "SUCCESS"){
		goBack("${pageContext.request.contextPath}/sample/sampleListView", "글작성이 완료되었습니다.");
	} else{
		alert(result.errorMsg);
	}
}
</script>
</head>
<body>
	
	<div>
		<div style="text-align:center;">
			<h1>일정 등록</h1>
		</div>
		
		<div id="_form"></div>
	</div>
</body>
<script type="text/javascript">

webix.ready(function() {
	webix.ui({
		container:"_form",
		view:"layout",
		id:"form",
		rows: [
			{view: "layout", cols: [
				{},
				{view: "text", label: "제목", id: "TITLE", width: 500},
				{}
			]},
			{view: "layout", cols: [
				{},
				{view: "textarea", label: "내용", id: "CONTENT", width: 500, height: 200},
				{}
			]},
			{view: "layout", cols: [
				{},
				{view: "radio", label: "일정", id: "TYPE", width: 500,
					options:[
						{"id": 1, "value": "휴가"},
						{"id": 2, "value": "회의"},
						{"id": 3, "value": "교육"},
						{"id": 4, "value": "야근"}
					]},
				{}
			]},
			{view: "layout", cols: [
				{},
				{view: "datepicker", events:webix.Date.isHoliday, weekHeader:true, label: "시작일",
					width: 250, id: "STARTDATE"},
				{view: "datepicker", events:webix.Date.isHoliday, weekHeader:true, label: "종료일",
						width: 250, id: "ENDDATE"},
				{}
			]},
			{view: "layout", cols: [
				{},
				{view: "button", label: "등록", id: "submitButton", width: 50},
				{view: "button", label: "뒤로", id: "backButton", width: 50},
				{}
			]}
		]
	});
	
	// 입력 화면에서 엔터를 눌렀을 경우 submit되게
	enterSubmit("TITLE");
	enterSubmit("CONTENT");
	enterSubmit("TYPE");
	enterSubmit("STARTDATE");
	enterSubmit("ENDDATE");
	
	//등록 버튼을 눌렀을 경우 submit되게
	$$("submitButton").attachEvent("onItemClick", function(id, e) {
		doSubmit();
	});

	// 뒤로 버튼을 눌렀을 경우 이전 화면으로 돌아가게
	$$("backButton").attachEvent("onItemClick", function(id, e) {
		goBack("${pageContext.request.contextPath}/sample/sampleListView");
	});
});

</script>
</html>