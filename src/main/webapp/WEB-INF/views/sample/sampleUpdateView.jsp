<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head/head.jsp" />

<title>스케줄러 - 일정수정</title>


<script type="text/javascript">
var initializedMember = new Array();
var addMemberArr = new Array();
var deleteMemberArr = new Array();

// Submit
function doSubmit() {
	var title = trim("TITLE");
	if (spaceCheck (title, "TITLE", "제목을 입력하세요.") == 0) return;
	
	var content = trim("CONTENT");
	if (spaceCheck (content, "CONTENT", "내용을 입력하세요.") == 0) return;
	
	var startDate = dateFormat($$("STARTDATE").getValue());
	if (spaceCheck (startDate, "STARTDATE", "시작일을 입력하세요.") == 0) return;
	
	var endDate = dateFormat($$("ENDDATE").getValue());
	if (spaceCheck (endDate, "ENDDATE", "종료일을 입력하세요.") == 0) return;
	
	if (dateCheck(startDate, endDate) == 0) return;
	
	// param에 글 내용 저장
	var param = {};
	
	// 추가해야할 멤버만 골라낸다
	for (var i= 0; i < initializedMember.length; i++) {
		if (addMemberArr.indexOf(initializedMember[i]) != -1) {
			addMemberArr.splice(addMemberArr.indexOf(initializedMember[i]), 1);
		}
	}
	
	param.ADDMEMBERLIST = addMemberArr;
	param.DELETEMEMBERLIST = deleteMemberArr;
	
	param.SEQ = $$("SEQ").getValue();
	param.MEMBERNO = $$("MEMBERNO").getValue();
	param.TITLE = title;
	param.CONTENT = content;
	param.TYPE = $$("TYPE").getValue();
	param.STARTDATE = startDate;
	param.ENDDATE = endDate;
	
	// 수정 정보 전송
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/sample/updateSample.do",
		contentType: "application/json",
		data:JSON.stringify(param),
		dataType:"json",
		success:function(data, status, xhr){
			
			if(data.result == "SUCCESS"){
				goBack("${pageContext.request.contextPath}/sample/sampleListView", "수정되었습니다.");
			}else{
				alert(data.errorMsg);
			}
		},
		error:function(data, status, xhr){
			alert(data.responseText);
		}
	});
		
	
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
			let startDate = new Date(data.sampleList[0].start);
			let endDate = new Date(data.sampleList[0].end);
			
			$$("SEQ").setValue(data.sampleList[0].id);
			$$("MEMBERNO").setValue(data.sampleList[0].memberNo);
			$$("TITLE").setValue(data.sampleList[0].title);
			$$("CONTENT").setValue(data.sampleList[0].content);
			$$("TYPE").setValue(data.sampleList[0].type);
			$$("STARTDATE").setValue(startDate);
			$$("ENDDATE").setValue(endDate);
		},
		error:function(data, status, xhr){
			alert(data.responseText);
		}
	});
}

// 해당 글에 해당된 회원 조회
function selectPartyMember () {
	var memberList = new Array();
	var no = ${param.seq};
	
	$.ajax({
		url: "${pageContext.request.contextPath}/sample/partyMember.do",
		type: "POST",
		dataType: "json",
		data: {"no": no},
		success: function(data, status, xhr){
			memberList = data;
			
			for (var i=0; i < memberList.length; i++) {
				let addMember = memberList[i];
				$("#addMember").append(deleteMemberDiv(addMember));
				
				var member = $(".member"+ addMember.NO);
				
				member.data("no", memberList[i].NO);
				
				deleteEvent (member, addMemberArr, deleteMemberArr);
				addMemberArr.push(addMember.NO);
				initializedMember.push(addMember.NO);
			}
		},
		error: function(data, status, xhr) {
			alert(data.responseText);
		}
	});
}

//회원 조회
function searchName () {
	let memberList = new Array();
	let param = {};
	
	param.name = $(".likeName").val();
	param.type = $(".type").val();
	param.writer = ${member};
	
	// 부서명이나 직급을 검색할 경우 index값으로 치환
	if (param.type == "dept") param.name = deptList.indexOf(param.name);
	if (param.type == "classes") param.name = classesList.indexOf(param.name);
	
	$.ajax({
		url: "${pageContext.request.contextPath}/member/searchMember",
		type: "GET",
		data: param,
		success: function (data, status, xhr) {
			console.log(data);
			if (data.memberList[0] == null) {
				// 검색결과가 없음
				$("#main").text("검색결과가 없습니다.");
			} else {
				$("#main").empty();
				// 검색결과가 있음
				memberList = data.memberList;
				
				for (var i= 0; i < memberList.length; i++) {
					if (addMemberArr.indexOf(memberList[i].NO) == -1) {
						$("#main").append(createMemberDiv(memberList[i]));
						
						var member = $(".addMember"+ memberList[i].NO);
						
						inputElementData (member, memberList[i]);
						
						memberClickEvent (member, addMemberArr, deleteMemberArr);
					}
				}
			}
		},
		error: function (data, status, xhr) {
			alert(data.responseText);
		}
	});
}
</script>
</head>
<body>
	<jsp:include page="../navbar/sampleNavbar.jsp" />
	
	<div class="article">
		<div class="text-center">
			<h1>일정 수정</h1>
		</div>
		
		<div id="_form"></div>
	</div>
	
	<jsp:include page="../sample/addMemberModal.jsp" />
	<jsp:include page="../footer/footer.jsp" />
    
</body>
<script type="text/javascript">
	webix.ready(function() {
		webix.ui({
			container:"_form",
			view:"layout",
			id:"form",
			cols: [
				{},
				{
					rows: [
						{view: "text", id:"SEQ", hidden:true},
						{view: "text", id:"MEMBERNO", hidden:true},
						{view: "layout", cols: [
							{view: "text", label: "제목", id: "TITLE", width: 500}
						]},
						{view: "layout", cols: [
							{view: "textarea", label: "내용", id: "CONTENT", width: 500, height: 200}
						]},
						{view: "layout", cols: [
							{view: "radio", label: "일정", id: "TYPE", width: 500,
								options:[
									{"id": 1, "value": "휴가"},
									{"id": 2, "value": "회의"},
									{"id": 3, "value": "교육"},
									{"id": 4, "value": "야근"}
								]}
						]},
						{view: "layout", cols: [
							{view: "datepicker", events:webix.Date.isHoliday, weekHeader:true, label: "시작일",
								width: 250, id: "STARTDATE"},
							{view: "datepicker", events:webix.Date.isHoliday, weekHeader:true, label: "종료일",
									width: 250, id: "ENDDATE"}
						]},
						{
							view: "layout",
							cols: [
								{
									rows: [
										{view: "button", type: "icon", icon: "users",
											label: "멤버 추가", id: "addUserButton", width: 90}
									]
								},
								{}
							]
						},
						{view: "layout", id: "memberContainer", height: 200, rows: [
							{template: "<div style='overflow-y: scroll; height: 200px;' id='addMember'></div>"}
						]},
						{view: "layout", cols: [
							{},
							{view: "button", label: "등록", id: "submitButton", width: 50},
							{view: "button", label: "뒤로", id: "backButton", width: 50},
							{}
						]}
					]
				},
				{}
			]
		});
		
		enterSubmit("TITLE");
		enterSubmit("CONTENT");
		enterSubmit("TYPE");
		enterSubmit("STARTDATE");
		enterSubmit("ENDDATE");
		
		// 버튼을 눌렀을때 검색
		$$("submitButton").attachEvent("onItemClick", function(id, e) {
			doSubmit();
		});
		
		// 인풋창에서 엔터버튼을 눌렀을때 검색
		$$("backButton").attachEvent("onItemClick", function(id, e) {
			goBack("${pageContext.request.contextPath}/sample/sampleListView");
		});
		
		// 멤버 추가버튼을 눌렀을때 멤버조회 및 등록하는 모달창이 나오게
		$$("addUserButton").attachEvent("onItemClick", function(id, e) {
			
			$('#addMemberModal').modal();
			
			$("#searchButton").click(function() {
				searchName();
			});
			
			$(".likeName").keydown(function(e) {
				if(e.keyCode == 13) searchName();
			});
		});
		
		sampleOne();
		selectPartyMember();
	});
</script>
</html>