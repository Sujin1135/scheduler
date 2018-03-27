<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<nav id="_navbar"></nav>

<script>
	webix.ready(function() {
		webix.ui({
			container: "_navbar",
			rows: [
				{
				view: "toolbar",
				id: "tollbar",
				css: "main_toolbar",
				elements: [
					{view: "label", label: "메니인소프트 스케쥴러", css: "toolbar_label", id: "navLabel"},
					{view: "menu", id:"myPage", align: "right", width: 80, data:[
						{id: 1, value: "마이 페이지", submenu:["내 일정", "내 정보"]}
					]},
					{view: "menu", id: "logOut", type: "button", align: "right", width: 80, data: [
						{id: 1, value: "로그아웃"}
					]},
					{width: 70}
				]},
				{height: 100}
			]
		});
		
		// 마이페이지의 메뉴 정보를 가져온다
		let myPage = $$("myPage").getSubMenu(1);
		
		// 마이페이지의 메뉴의 서브메뉴에 클릭 이벤트 등록
		myPage.attachEvent("onItemClick", function(id, e) {
			if (id == "내 일정") alert("준비중입니다.");
			if (id == "내 정보") window.location.href="${pageContext.request.contextPath}/member/updateView"; 
		});
		
		// 로그아웃 메뉴에 클릭 이벤트 등록 
		$$("logOut").attachEvent("onItemClick", function(id, e) {
			logOut();
		});
	});
	
	function logOut () {
		$.ajax({
			url: "${pageContext.request.contextPath}/member/logoutMember",
			type: "GET",
			dataType: "json",
			async:false,
			success: function(data) {
				if (data.result == "SUCCESS") alert("로그아웃 하였습니다.");
				if (data.result == "FAIL") alert("로그인 되어있지 않습니다.");
				
				window.location.href="${pageContext.request.contextPath}/member/loginView";
			},
			error: function(data) {
				alert (data.responseText);
			}
		});
	}
</script>