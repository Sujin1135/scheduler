<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<nav id="_navbar" class="navbar"></nav>
<script>
	webix.ready(function() {
		webix.ui({
			container: "_navbar",
			id: "navbar",
			rows: [
				{
				view: "toolbar",
				id: "toolbar",
				css: "main_toolbar",
				elements: [
					{
			            view: "icon", icon: "bars",
			            click: function(){
			                if( $$("menu").config.hidden){
			                    $$("menu").show();
			                }
			                else
			                    $$("menu").hide();
			            }
			        },
					{view: "label", label: "메니인소프트 스케쥴러", css: "toolbar_label", id: "navLabel"},
					{view: "menu", id:"myPage", align: "right", width: 80, data:[
						{id: 1, value: "마이 페이지", submenu:["내 일정", "내 정보"]}
					]},
					{view: "menu", id: "logOut", type: "button", align: "right", width: 80, data: [
						{id: 1, value: "로그아웃"}
					]},
					{width: 70}
				]}
			]
		});
		
		webix.ui({
		    view: "sidemenu",
		    position: "left",
		    id: "menu",
		    width: 200,
		    state:function(state){
		        var toolbarHeight = $$("toolbar").$height;
		        state.top = toolbarHeight;
		        state.height -= toolbarHeight;
		    },
		    body:{
		    	view:"list",
		        borderless:true,
		        scroll: false,
		        template: "<span class='webix_icon fa-#icon#'></span> #value#",
		        data:[
		            {id: 1, value: "일정목록", icon: "bars"},
		            {id: 2, value: "캘린더", icon: "calendar"}
		        ]
		    }
		});
		
		// 마이페이지의 메뉴 정보를 가져온다
		let myPage = $$("myPage").getSubMenu(1);
		let calendar = $$("menu").getChildViews()[0];
		
		calendar.attachEvent("onItemClick", function(id, e) {
			if (id == 1) window.location.href="${pageContext.request.contextPath}/sample/sampleListView";
			if (id == 2) window.location.href="${pageContext.request.contextPath}/sample/sampleCalendarView";
		});
		
		// 마이페이지의 메뉴의 서브메뉴에 클릭 이벤트 등록
		myPage.attachEvent("onItemClick", function(id, e) {
			if (id == "내 일정") window.location.href="${pageContext.request.contextPath}/sample/mySamplesView?seq=${member}";
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