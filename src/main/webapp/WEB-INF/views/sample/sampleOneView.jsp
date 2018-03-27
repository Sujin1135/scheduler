<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	
	<link href="${pageContext.request.contextPath}/resources/webix/webix.css" rel="stylesheet" type="text/css" />
	<link href="${pageContext.request.contextPath}/resources/webix/skins/compact.css" rel="stylesheet" type="text/css" />
	<script src="${pageContext.request.contextPath}/resources/webix/webix.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/resources/jquery/jquery-3.3.1.min.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/resources/main.js"></script>
	
	<title>스케쥴러 - 일정</title>
	</head>
		<script>
			// 일정 정보를 가져온다
			function sampleOne () {
				var param = new Object();
				param.SEQ = ${param.seq};
				param.RESULT = "ONE";
				
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
						
						$("#title").text(data.sample.TITLE);
						/*
						$$("dataview1").parse(data.sample);
						$$("dataview1").show();
						
						$$("MEMBERNO").setValue(data.sample.MEMBER_NO);
						
						$$("CONTENT").setValue(data.sample.CONTENT);
						$$("TYPE").setValue(data.sample.TYPE);
						$$("STARTDATE").setValue(startDate);
						$$("ENDDATE").setValue(endDate);
						*/
					},
					error:function(data, status, xhr){
						alert(data.responseText);
					}
				});
			}
		</script>
	<body>
		<jsp:include page="../navbar/sampleNavbar.jsp" />
		
		<h1 id="title"></h1>
		<hr />
		<div id="_sample"></div>
		<script>
			webix.ready(function() {
				/*
				webix.ui({
				    view:"dataview", 
				    id:"dataview1",
				    type: {
				        height: 200,
				    },
				    template:"<div class='webix_strong'><h1>#TITLE#</h1></div> #NAME#"
				});
				*/
				
				sampleOne();
			});
		</script>
	</body>
</html>