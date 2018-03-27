<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>sample list</title>
<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/main.js"></script>

<script type="text/javascript">

// Submit
function doSubmit() {
	var title = trim("TITLE");
	if (spaceCheck (title, "TITLE", "제목을 입력하세요.")) return;
	
	var content = trim("CONTENT");
	if (spaceCheck (content, "CONTENT", "내용을 입력하세요.")) return;
	
	var startDate = dateFormat($$("STARTDATE").getValue());
	if (spaceCheck (startDate, "STARTDATE", "시작일을 입력하세요.")) return;
	
	var endDate = dateFormat($$("ENDDATE").getValue());
	if (spaceCheck (endDate, "ENDDATE", "종료일을 입력하세요.")) return;
	
	// param에 글 내용 저장
	var param = new Object();
	param.SEQ = $$("SEQ").getValue();
	param.MEMBERNO = $$("MEMBERNO").getValue();
	param.TITLE = title;
	param.CONTENT = content;
	param.TYPE = $$("TYPE").getValue();
	param.STARTDATE = startDate;
	param.ENDDATE = endDate;
	
	var result = new Object();
	
	// 수정 정보 전송
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/sample/updateSample.do",
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
		
	if(result.result == "SUCCESS"){
		goBack("${pageContext.request.contextPath}/sample/sampleListView", "수정되었습니다.");
	}else{
		alert(result.errorMsg);
	}
}

// 일정 정보를 가져온다
function sampleOne () {
	var param = new Object();
	param.SEQ = ${param.seq};
	param.RESULT = "UPDATE";
	
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/sample/selectSample.do",
		async:false,
		data:param,
		dataType:"json",
		success:function(data, status, xhr){
			// 날짜 형식 변환
			let startDate = new Date(data.sample.START_DATE);
			let endDate = new Date(data.sample.END_DATE);
			
			$$("SEQ").setValue(data.sample.SEQ);
			$$("MEMBERNO").setValue(data.sample.MEMBER_NO);
			$$("TITLE").setValue(data.sample.TITLE);
			$$("CONTENT").setValue(data.sample.CONTENT);
			$$("TYPE").setValue(data.sample.TYPE);
			$$("STARTDATE").setValue(startDate);
			$$("ENDDATE").setValue(endDate);
		},
		error:function(data, status, xhr){
			alert(data.responseText);
		}
	});
}

</script>
</head>
<body>
	<jsp:include page="../navbar/sampleNavbar.jsp" />
	
	<div id="_form">
		<div style="text-align:center;">
			<h1>일정 수정</h1>
		</div>
	</div>
</body>
<script type="text/javascript">

webix.ready(function() {
	webix.ui({
		container:"_form",
		view:"layout",
		id:"form",
		rows: [
			{view: "text", id:"SEQ", hidden:true},
			{view: "text", id:"MEMBERNO", hidden:true},
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
	
	$$("submitButton").attachEvent("onItemClick", function(id, e) {
		doSubmit();
	});
	
	$$("backButton").attachEvent("onItemClick", function(id, e) {
		goBack("${pageContext.request.contextPath}/sample/sampleListView");
	});
	
	sampleOne();
});

</script>
</html>