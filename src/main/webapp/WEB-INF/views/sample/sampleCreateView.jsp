<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="../head/head.jsp" />

<title>sample create</title>

<script type="text/javascript">
var addMemberArr = new Array();

// Submit
function doSubmit() {
	/*
	* spaceCheck(Object, 태그id, alert내용)을 입력하여 널체크와 경고창을 띄우는 메서드
	* trim(태그id)는 해당 태그id의 getValue값의 좌우 공백이 있을 경우 좌우 공백을 제거해주는 메서드
	*/
	var memberNo = ${member};
	
	var title = trim("TITLE");
	if (spaceCheck(title, "TITLE", "제목을 입력하세요.") == 0) return;
	
	var content = trim("CONTENT");
	if (spaceCheck(content, "CONTENT", "내용을 입력하세요.") == 0) return;
	
	var type = $$("TYPE").getValue();
	if (spaceCheck(type, "TYPE", "일정 종류를 체크하세요.") == 0) return;
	
	var startDate = dateFormat($$("STARTDATE").getValue());
	if (spaceCheck(startDate, "STARTDATE", "일정 시작일을 입력하세요") == 0) return;
	
	var endDate = dateFormat($$("ENDDATE").getValue());
	if (spaceCheck(endDate, "ENDDATE", "일정 종료일을 입력하세요") == 0) return;
	
	if (dateCheck(startDate, endDate) == 0) return;
	
	if (title.length > 20 || title.length < 2) {
		alert("글 제목은 2글자 이상 20글자 이하로 작성하세요.");
		return;
	}
	
	if (content.length > 50 || content.length < 2) {
		alert("글 내용은 2글자 이상 50글자 이하로 입력하세요.");
		return ;
	}
	
	// param에 값 저장
	var param = {};
	param.TITLE = title;
	param.CONTENT = content;
	param.TYPE = type;
	param.STARTDATE = startDate;
	param.ENDDATE = endDate;
	param.MEMBERNO = memberNo;
	
	if (addMemberArr.length != 0) {
		param.addMemberArr = addMemberArr;
		console.log(param.addMemberArr);
	}
	
	var result = {};
	
	// 서버에 데이터 전송
	$.ajax({
		url:"${pageContext.request.contextPath}/sample/insertSample.do",
		contentType: "application/json",
		type:"POST",
		data:JSON.stringify(param),
		dataType:"json",
		success:function(data, status, xhr){
			result = data;
			
			// result 키값에 저장한다.
			if(result.result == "SUCCESS"){
				goBack("${pageContext.request.contextPath}/sample/sampleListView", "글작성이 완료되었습니다.");
			} else{
				alert("what?");
				alert(result.errorMsg);
			}
		},
		error:function(data, status, xhr){
			alert("error");
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
						
						memberClickEvent (member, addMemberArr);
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
			<h1>일정 등록</h1>
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
		
});

</script>
</html>