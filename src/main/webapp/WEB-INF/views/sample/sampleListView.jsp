<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head/head.jsp" />

<title>스케쥴러 - 조회</title>

<script type="text/javascript">

// 검색
function doSubmit() {
	var param = new Object();
	param.likeTitle = $$("likeTitle").getValue();
	param.calendarSelect = $$("calendarSelect").getValue();
	param.typeSelect = $$("typeSelect").getValue();
	
	// 결과를 받을 객체
	var result = {};
	
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
	
	if(result.sampleList.length == 0){
		$(".webix_dataview").html("<div class='text-center' style='margin-top: 10em;'>검색결과가 존재하지 않습니다.</div>");
	}
}

// 글 작성 페이지로 이동
function goSampleCreate() {
	window.location.href = "${pageContext.request.contextPath}/sample/sampleCreateView";
}

</script>
</head>
<body>
<jsp:include page="../navbar/sampleNavbar.jsp" />

<div class="article">
	<div id="_sample"></div>
</div>

<jsp:include page="../footer/footer.jsp" />
</body>
<script type="text/javascript">

webix.ready(function() {
	webix.ui({
		container:"_sample",
		view:"layout",
		cols: [
			{},
			{	
				rows: [
					{height: 70},
					{
						cols:[
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
								width: 60
							}
						],
					},
					{height: 10},
					{
						view:"dataview",
						id:"sample",
						xCount: 3,
						pager:"sample_pager",
						height: 450,
						css: "movies",
						margin: 10,
						type: {
							width: 317,
							height: 90,
							template: function(data) {
								return "<div class='overall' >"+
								"<div class='id' name='id' style='display: none;'>"+ data.id +"</div>"+
								"<div class='title'>"+ data.title +"</div>"+
								calendarTypeDiv(data.type, data.color)+
								"<div class='name'>"+ data.name +"</div>"+
								"</div>";	
							}	
						}
					},
					{
						cols: [
							{},
							{
								view: "pager",
						      	id: "sample_pager",
						      	animate:{
						      		subtype:"out"
						        },
						      	align: "center", 
						      	size: 15
							},
							{}
						]
				     	
				    }   
				]
			},
			{}
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
	
	doSubmit();
	
	$$("sample").attachEvent("onItemClick", function(id, e, node) {
		window.location.href= "${pageContext.request.contextPath}/sample/sampleOneView?seq="+ id;
	});
});

function calendarTypeDiv (no, color) {
	return "<div class='type' style='color: "+ color +"'>" + calendarType[no] + "</div>";
}
</script>
</html>