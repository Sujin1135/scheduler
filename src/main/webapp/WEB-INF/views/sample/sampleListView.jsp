<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>스케쥴러 - 조회</title>
<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/main.js"></script>

<script type="text/javascript">

// 검색
function doSubmit() {
	var param = new Object();
	param.likeTitle = $$("likeTitle").getValue();
	param.calendarSelect = $$("calendarSelect").getValue();
	param.typeSelect = $$("typeSelect").getValue();
	
	// 결과를 받을 객체
	var result = new Object();
	
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/sample/searchSample.do",
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
	
	$$("sampleCount").setValue("총 " + result.sampleList.length + "건");
	
	$$("sample").clearAll();
	
	$$("sample").parse(result.sampleList);
	
	if(result.sampleList.length > 0){
		$$("sample").hideOverlay();
	}else{
		$$("sample").showOverlay("검색결과가 존재하지 않습니다.");
	}
}

// 글 작성 페이지로 이동
function goSampleCreate() {
	window.location.href = "${pageContext.request.contextPath}/sample/sampleCreateView";
}

// 글 수정 페이지로 이동
function goSampleUpdate(seq) {
	window.location.href = "${pageContext.request.contextPath}/sample/sampleUpdateView?seq=" + seq;
}

function doDeleteSample() {
	var sampleList = new Array();
	
	for(var i = 0; i < $$("sample").count(); i++) {
		var sample = $$("sample").getItem($$("sample").getIdByIndex(i));
		if(sample.CHECK){
			sampleList.push(sample);
		}
	}
	
	if(sampleList.length == 0){
		alert("삭제할 목록을 선택하세요.");
		return;
	}
	
	if(confirm("선택한 목록을 삭제하시겠습니까?")){
		var param = new Object();
		param.sampleList = JSON.stringify(sampleList);
		
		var result = new Object();
		
		// 삭제할 객체 정보 전송
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/sample/deleteSample.do",
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
	}
	
	if(result.result == "SUCCESS"){
		alert("삭제 되었습니다.");
		doSearchSample();
	}else{
		alert(result.errorMsg);
	}
}

</script>
</head>
<body>
<jsp:include page="../navbar/sampleNavbar.jsp" />

<div>
	<div id="_sample"></div>
</div>
</body>
<script type="text/javascript">

webix.ready(function() {
	webix.ui({
		container:"_sample",
		view:"layout",
		rows: [
			{height: 70},
			{
				cols:[
					{},
					{
						view:"label",
						id:"sampleCount",
						width: 50
					},
					{
						view:"layout",
						id:"submit",
						width: 800,
						cols: [
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
								width:200
							},
							{
								view:"layout",
								cols:[
									{
										view:"button",
										id:"sampleSearchButton",
										label:"검색",
										width:50
									},
								]
							},
							{}
						]
					},
					{
						view:"button",
						id:"sampleAditButton",
						label:"추가",
						width:50
					},
					{width: 10},
					{
						view:"button",
						id:"sampleDeleteButton",
						label:"삭제",
						width:50
					},
					{}
				],
			},
			{height: 10},
			{
				cols: [
					{},
					{
						view:"datatable",
						id:"sample",
						height:400,
						width: 1000,
						columns:[
							{
								id:"CHECK",
								header:{content:"masterCheckbox", contentId:"CHECK"},
								template:"{common.checkbox()}",
								checkValue:true,
								uncheckValue:false,
								css:{"text-align":"center"},
								width:40
							},
							{
								id:"SEQ",
								header:"SEQ",
								template:"#!SEQ#",
								css:{"text-align":"center"},
								width:60
							},
							{
								id:"TITLE",
								header:"제목",
								template:function(obj, common, value, config) {
									return "<a href=\"javascript:;\" onclick=\"goSampleUpdate('" + obj.SEQ + "');\">" + value + "</a>";
								},
								width:200
							},
							{
								id:"MEMBER",
								header:"이름",
								template:"#!NAME#",
								width: 100
							},
							{
								id:"TYPE",
								header:"일정",
								template:function(obj, common, value, config) {
									if (value == 1) return "휴가";
									if (value == 2) return "회의";
									if (value == 3) return "교육";
									if (value == 4) return "외근";
								},
								width: 100
							},
							{
								id:"CONTENT",
								header:"내용",
								template:"#!CONTENT#",
								fillspace:true,
								width: 400
							}
						]
					},
					{}
				]
			}
		]
	});
	
	// list 이벤트 초기화
	enterSubmit("likeTitle");
	enterSubmit("calendarSelect");
	enterSubmit("typeSelect");
	
	$$("sampleSearchButton").attachEvent("onItemClick", function(id, e) {
		doSubmit();
	});
	
	$$("sampleAditButton").attachEvent("onItemClick", function(id, e) {
		goSampleCreate();
	});
	
	$$("sampleDeleteButton").attachEvent("onItemClick", function(id, e) {
		doDeleteSample();
	});
	
	doSubmit();
});

</script>
</html>