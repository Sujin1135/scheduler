/* 
 * 공백을 체크하는 함수
 * 비어있으면 true 아니면 false를 반환하는 함수
 */

// 부서, 직급, 성별의 1차원 배열정보
let deptList = ["","사업", "개발", "경영"];
let classesList = ["","인턴", "사원", "대리", "과장", "차장", "부장", "이사", "대표이사"];
let genderList = ["", "남자", "여자"];
let calendarType = ["","휴가", "회의", "교육", "외근"];

// 공백여부 체크
function spaceCheck(obj, objName, comment) {
	if(obj == null || obj == "" || obj.length == 0){
		alert(comment);
		$$(objName).focus();
		return 0;
	}
	
	return 1;
}

// webix의 value값 trim
function trim(objName) {
	return $.trim($$(objName).getValue());
}

// 목록 화면으로 되돌아간다
function goBack(path, comment) {
	// comment가 있을 경우 alert 함수 호출
	if (arguments.length == 2) alert (comment);
	
	window.location.href = path;
}

// 엔터 Submit
function enterSubmit(objName) {
	$$(objName).attachEvent("onKeyPress", function(code, e) {
		if (code == 13) {
			doSubmit();
		}
	});
}

// date -> String 변환
function dateFormat(date) {
	var yyyy = date.getFullYear().toString();                                    
    var mm = (date.getMonth()+1).toString(); 
    var dd  = date.getDate().toString();
    
    return yyyy + '-' + (mm[1]?mm:"0"+mm[0]) + '-' + (dd[1]?dd:"0"+dd[0]);
}

// 회원정보 벨리데이션 체크
function memberValidation (param) {
	/*
	 * member param 정보
		param.name = name;
		param.email = email;
		param.pwd = pwd;
		param.gender = gender;
		param.dept = dept;
		param.classes = classes;
	*/
	
	// 이메일, 이름, 비밀번호의 벨리데이션 체크에 필요한 정규식 표현들
	var emailRegex = RegExp("^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$");
	var nameRegex = RegExp("^[가-힣a-zA-Z]{2,10}$");
	var pwdRegex = RegExp("^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!~`@#&$%^*()\\-_=+\\\\\\|\\[\\]{};:\\'\"<>\\/?]).{8,16}$"); // 영문 + 숫자 + 특수문자(_ 는 제외) 조합으로 8자 이상 16자 이하로 조합하여야 한다
	
	if (regexCheck(emailRegex, param.email, "이메일 형식이 올바르지 않습니다.") == 0) return true;
	if (regexCheck(nameRegex, param.name, "이름은 2~10글자 내외로 한글, 영문만 입력가능합니다.") == 0) return true;
	if (regexCheck(pwdRegex, param.pwd, "비밀번호는 8~16글자 내외로 문자, 숫자, 특수문자를 조합하여 등록하세요.") == 0) return true;
	
	return false;
}

// 정규식 표현 체크를 위한 메서드
function regexCheck (regex, obj, comment) {
	if (!regex.test(obj)) {
		alert (comment);
		return 0;
	}
	
	return 1;
}

/*
 *	일정등록 및 수정
 */


//member태그의 정보 속성값을 넣어주는 메서드
function inputElementData (member, data) {
	member.data("no", data.NO);
	member.data("name", data.NAME);
	member.data("email", data.EMAIL);
	member.data("dept", data.DEPT);
	member.data("classes", data.CLASSES);
	member.data("gender", data.GENDER);
}

//멤버 엘리먼트 클릭이벤트 설정
function memberClickEvent (member, addMemberArr, deleteMemberArr) {
	member.click(function(e) {
		if (confirm("해당 멤버를 일정 인원에 추가하시겠습니까?")) {
			
			// 해당 멤버가 등록되어 있는경우 중복등록을 막는다
			if (addMemberArr.find(function(element) { return element == member.data("no") }) != null) {
				alert("이미 등록되어있습니다.");
				return;
			}
			
			if (deleteMemberArr) {
				if (deleteMemberArr.find(function(element) {return element == member.data("no")}) != null) {
					deleteMemberArr.splice(deleteMemberArr.indexOf(member.data("no")),1);
				}
			}
			
			// 멤버를 추가한다
			addMemberArr.push(member.data("no"));
			$("#addMember").append("<div class='div-border text-center member"
										+ member.data("no") 
										+ "' style='margin: 1em;'>"
										+ member.data("name")
										+ " / " + deptList[member.data("dept")] 
										+ " / " + classesList[member.data("classes")]
										+ "</div>");
			
			$(".member"+member.data("no")).click(function(e) {
				addMemberArr.splice(addMemberArr.indexOf(member.data("no")),1);
				if (deleteMemberArr) deleteMemberArr.push(member.data("no"));
				$(".member"+member.data("no")).remove();
			});
			
			// 추가했을 경우 검색창에서 해당 엘리먼트 삭제
			$(".addMember" + member.data("no")).remove();
		}
	});
}

// 시작일 종료일 체크
function dateCheck (start, end) {
	if (start > end) {
		alert("종료일이 시작일보다 이전일 수 없습니다.");
		return 0;
	}
	return 1;
}

// 일정에 참여하는 멤버 엘리먼트 세팅
function deleteMemberDiv (member) {
	return "<div class='div-border text-center member"
				+ member.NO
				+ "' style='margin: 1em;'>"
				+ member.NAME
				+ " / " + deptList[member.DEPT] 
				+ " / " + classesList[member.CLASSES]
				+ "</div>";
}

// 삭제 이벤트 등록
function deleteEvent (member, addMemberArr, deleteMemberArr) {
	member.click(function(e) {
		addMemberArr.splice(addMemberArr.indexOf(member.data("no")),1);
		deleteMemberArr.push(member.data("no"));
		$(".member"+member.data("no")).remove();
	});
}

// 멤버 디비젼 생성
function createMemberDiv (addMember) {
	return "<div class='div-border text-center addMember"
			+ addMember.NO
			+ "' style='margin: 1em;'>"
			+ addMember.NAME
			+ " / " + deptList[addMember.DEPT] 
			+ " / " + classesList[addMember.CLASSES]
			+ "</div>";
}

// 게시글의 등록자 pk와 로그인한 멤버의 pk확인
function primaryKeyCheck (memberNo, sampleNo, addMemberArr, deleteMemberArr) {
	if (memberNo == sampleNo) return 1
	return 0
}

//풀캘린더 세팅
function setCalendar (data, contextPath, memberNo, seq) {
	if (data.length != 0) {
		$("#calendar").fullCalendar({
			header: {
				left: 'prev next',
				center: 'title',
				right: 'month, basicWeek'
			},
			allDay: true,
		    defaultDate: moment(data[0].start).toISOString(),
		    monthNames: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
	        monthNamesShort: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
	        dayNames: ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"],
	        dayNamesShort: ["일","월","화","수","목","금","토"],
	        buttonText: {
	              today : "오늘",
	              month : "월별",
	              week : "주별",
	              day : "일별",
	        },
			events: data,
			eventClick: function(event) {
				let startFull;
				let endFull;
				
				// 시작일과 종료일을 자바스크립트 Date 형으로 저장한다
				var start = new Date(event.start);
				var end = new Date(event.end);
				var appendMember;
				
				// 년도, 달, 일별로 나눈다
				var sYear = start.getFullYear();
				var sMonth = start.getMonth() + 1;
				var sDate = start.getDate();
				startFull = sYear + "년 " + sMonth + "월 " + sDate + "일";
				
				var eYear = end.getFullYear();
				var eMonth = end.getMonth() + 1;
				var eDate = end.getDate();
				endFull = eYear + "년 " + eMonth + "월 " + eDate + "일";
				
				if (primaryKeyCheck(memberNo, event.memberNo) == 0) {
					$(".update-button").css("display", "none");
					$(".delete-button").css("display", "none");
				}
				
				$.ajax({
					url: contextPath+ "/sample/partyMember.do",
					type: "POST",
					dataType: "json",
					data: {"no": event.id},
					success: function(data) {
						for (var i = 0; i < data.length; i++) {
							let addMember = data[i];
							$("#addMember").append(deleteMemberDiv(addMember));
							
							var member = $(".member"+ addMember.NO);
							
							member.data("no", data[i].NO);
						}
					},
					error: function(data) {
						alert(data.responseText);
					}
				});
				
				replysList(event.id, contextPath, memberNo);
				
				if (event.type == 1) {
					$(".modal-header").css("background-color", "#00bfff");
				} else if (event.type == 2) {
					$(".modal-header").css("background-color", "#32cd32");
				} else if (event.type == 3) {
					$(".modal-header").css("background-color", "#088A68");
				} else if (event.type == 4) {
					$(".modal-header").css("background-color", "#7401DF");
				}
				
				$('#modalTitle').html(event.title);
	            $('#content').html('<i class="fa fa-align-left" style="margin-right: 15px;"></i>' + event.content);
	            $('#date').html('<i class="fa fa-calendar" style="margin-right: 15px;"></i>' + startFull + " ~ " + endFull);
	            $('#eventUrl').attr('href',event.url);
	            $("#type").html('<i class="fa fa-arrow-right" style="margin-right: 15px;"></i>'+ calendarType[event.type]);
	            $('#name').html('<i class="fa fa-id-card-o" style="margin-right: 15px;"></i>' + event.name);
	            $("#addMember").html('<i class="fa fa-address-book-o" style="margin-right: 15px;"> 일정 참여멤버</i>');
	            $('#fullCalModal').modal();
	            
            	$("#reply-button").click(function() {
            		// seq, memberNo, contextPath, depth, parentNo, groupNo
					createReplys(event.id, event.memberNo, $("#reply-input").val(), contextPath, 0);
				});
	            
	            $('.delete-button').click(function() {
	            	scheduleDelete(event.id, contextPath, memberNo);
	            });
	            
	            $('#reply-input').keydown(function(key) {
	            	if (key.keyCode == 13) {
	            		createReplys(event.id, event.memberNo, $("#reply-input").val(), contextPath, 0);
	            		$("#reply-input").val('');
	            	}
	            });
	            return false;
			}
		});
	} else {
		$("#calendar").html("<div class='text-center'>검색 결과가 없습니다.</div>");
	}
}

// 일정 삭제 메서드
function scheduleDelete (seq, contextPath, memberNo) {
	var param = {};
	param.seq = seq;
	param.memberNo = memberNo;
	
	$.ajax({
		url: contextPath+ "/sample/deleteSample.do",
		type: "POST",
		data: param,
		dataType: "json",
		success: function(data) {
			if (data.result == "SUCCESS") {
				alert("해당 일정이 삭제되었습니다.");
				window.location.href= contextPath+ "/sample/sampleListView";
			} else {
				alert("삭제되지 않았습니다.");
			}
		},
		error: function(data) {
			alert(data.responseText);
		}
	});
}

// 댓글목록
function replysList (seq, contextPath, memberNo) {
	
	$.ajax({
		url: contextPath + "/sample/replyList.do",
		type: "POST",
		data: {"seq": seq},
		dataType: "json",
		success: function(data) {
			$("#reply-list").empty();
			if (data != null) {
				for (var i =0; i < data.length; i++) {
					var replySeq = data[i].SEQ;
					var groupNo = data[i].GROUP_NO;
					var parentNo = data[i].PARENT_REPLYS_NO;
					
					// 날짜를 yyyy-MM-dd 형식으로 포맷한다
					var date = new Date(data[i].CRE_DATE).toISOString().split('T')[0];
					data[i].CRE_DATE = date;
					createReply(data[i], contextPath, memberNo);
					
					// 댓글 등록자와 사용자가 일치하지 않을 경우 댓글 수정, 삭제 아이콘을 숨긴다.
					if (data[i].MEMBER_NO != memberNo) {
						$(".reply-update"+ replySeq).css("display", "none");
						$(".reply-remove"+ replySeq).css("display", "none");
					}
					
					// 대댓글일 경우
					if (data[i].DEPTH != 0) {
						$(".reply-reply"+ replySeq).css("display", "none");
						$(".reply"+ replySeq).css("background-color", "#C0C0C0");
						$(".reply"+ replySeq).css("border-radius", "15px");
					}
				}
			} else {
				$("#reply-list").html("등록된 댓글이 없습니다.");
			}
		},
		error: function(data) {
			alert(data.responseText);
		}
	});
}

// 댓글등록
function createReplys (seq, memberNo, comment, contextPath, depth, parentNo, groupNo) {
	var param = {};
	param.sample_seq = seq;
	param.memberNo = memberNo;
	param.depth = depth;
	param.comment = comment
	if (parentNo != null) {
		param.parentNo = parentNo;
		param.groupNo = groupNo;
	}
	
	// 댓글 조회 비동기 통신
	$.ajax({
		url: contextPath + "/sample/addReply.do",
		type: "POST",
		data: param,
		dataType: "json",
		success: function(data) {
			// 댓글목록 div창을 비운 후 댓글 리스트 출력 메서드를 재호출한다.
			if (data.result == "SUCCESS") {
				alert("댓글이 등록되었습니다.");
				$("#reply-list").empty();
				replysList(seq, contextPath, memberNo);
			} else {
				alert (data.errMsg);
			}
		},
		error: function(data) {
			alert(data.responseText);
		}
	});
}

// 댓글 수정
function updateReplys (seq, sampleSeq, comment, contextPath, memberNo) {
	var param = {};
	param.seq = seq;
	param.comment = comment;
	
	$.ajax({
		url: contextPath+ "/sample/updateReply.do",
		type: "POST",
		data: param,
		dataType: "json",
		success: function(data) {
			var cancelButton = $(".uCancel-button"+ seq);
			resultCheck(data, "댓글이 수정되었습니다.");
			replysList(sampleSeq, contextPath, memberNo);
		},
		error: function(data) {
			alert(data.responseText);
		}
	});
}

// 댓글 삭제
function deleteReplys (seq, sampleSeq, contextPath, memberNo) {
	console.log(seq);
	var param = {};
	param.seq = seq;
	param.memberNo = memberNo;
	
	$.ajax({
		url: contextPath+ "/sample/deleteReply.do",
		type: "POST",
		data: param,
		dataType: "json",
		success: function(data) {
			resultCheck(data, "댓글이 삭제되었습니다.");
			replysList(sampleSeq, contextPath, memberNo);
		},
		error: function(data) {
			alert(data.responseText);
		}
	});
}

// ajax 요청의 성공 실패여부에 따른 간단한 alert메세지
function resultCheck (data, comment) {
	if (data.result == "SUCCESS") {
		alert(comment);
	} else {
		alert(data.errMsg);
	}
}

// 댓글 엘리먼트 생성 메서드
function createReply(data, contextPath, memberNo) {
	$("#reply-list").append(
			"<div class='reply"+ data.SEQ +"'"
			+ "data-groupNo='"+ data.GROUP_NO +"' "
			+ "data-memberNo='"+ data.MEMBER_NO +"'"
			+ "style='padding-left:" + 2 * data.DEPTH + "em'>"
			+ "<div style='justify-content: space-around;'> <span class='reply-member'>" + data.NAME + "</span>"
			+ "<span class='reply-date'>" + data.CRE_DATE + "</span> "
			+ "<i class='fa fa-reply cursor-pointer reply-reply"+ data.SEQ +"'></i>"
			+ "<i class='glyphicon glyphicon-pencil cursor-pointer update-button"+ data.SEQ +"'></i> "
			+ "<i class='glyphicon glyphicon-remove cursor-pointer reply-remove"+ data.SEQ +"'></i> </div>"
			+ "<div style='margin-top: 20px;'><p class='reply-comment"+ data.SEQ +"'>" + data.COMMENT + "</p></div>"
			+ "<div class='reply-update"+ data.SEQ +"'></div>"
			+ "<div class='reply-add"+ data.SEQ +"'></div>"
			+ "</div>");
	
	// 댓글 삭제버튼 이벤트 등록
	$(".reply-remove"+ data.SEQ).click(function() {
		// deleteReplys (seq, memberNo, contextPath)
		deleteReplys(data.SEQ, data.SAMPLE_SEQ, contextPath, memberNo)
	});
	
	// 댓글 수정버튼 이벤트 등록
	$(".update-button"+ data.SEQ).click(function() {
		// 댓글 내용을 안보이게 한다
		$(".reply-comment"+ data.SEQ).css("display", "none");
		$(".reply-update"+ data.SEQ).html(
				"<div>"
				+ "<input type='text' class='form-control update-input"+ data.SEQ +"' style='width: 50%; height:27px;" +
						" margin-bottom: 10px; display:inline' value='"+ data.COMMENT +"' placeholder='댓글을 입력해주세요.'>"
				+ "<button class='btn btn-info rUpdate-button"+ data.SEQ +"' style='width:20% display:inline'>등록</button>"
				+ "<button class='btn btn-default uCancel-button"+ data.SEQ +"'>취소</button>"
				+ "</div>"
		);
		
		// 댓글수정 엔터 이벤트
		$(".update-input"+ data.SEQ).keydown(function(key) {
			if (key.keyCode == 13) {
				updateReplys(data.SEQ, data.SAMPLE_SEQ, $(".update-input"+ data.SEQ).val(), contextPath, memberNo);
			}
		});
		
		// 댓글수정 등록버튼 이벤트
		$(".rUpdate-button"+ data.SEQ).click(function() {
			updateReplys(data.SEQ, data.SAMPLE_SEQ, $(".update-input"+ data.SEQ).val(), contextPath, memberNo);
		});
		
		// 댓글수정 닫기버튼 이벤트
		$(".uCancel-button"+ data.SEQ).click(function() {
			$(".reply-comment"+ data.SEQ).css("display", "block");
			$(".reply-update"+ data.SEQ).empty();
		});
	});
	
	// 댓글일 경우, depth가 0이면 댓글 1이면 대댓글이다.
	if (data.DEPTH == 0) {
		// 대댓글 등록 엘리먼트 생성
		$(".reply-reply"+ data.SEQ).click(function() {
			$(".reply-add"+ data.SEQ).html(
					"<div>"
					+ "<input type='text' class='form-control add-input"+ data.SEQ +"' style='width: 50%; height:27px;" +
							" margin-bottom: 10px; display:inline' placeholder='댓글을 입력해주세요.'>"
					+ "<button class='btn btn-info add-button"+ data.SEQ +"' style='width:20% display:inline'>등록</button>"
					+ "<button class='btn btn-default cancel-button"+ data.SEQ +"'>취소</button>"
					+ "</div>"
			);
			// 대댓글 등록버튼
			$(".add-button"+ data.SEQ).click(function() {
				// (seq, memberNo, comment, contextPath, depth, parentNo, groupNo)
				createReplys (data.SAMPLE_SEQ, data.MEMBER_NO, $(".add-input"+ data.SEQ).val(), contextPath,
						data.DEPTH+1, data.SEQ, data.GROUP_NO);
			});
			
			// 대댓글 입력창 닫기 이벤트
			$(".cancel-button"+ data.SEQ).click(function() {
				$(".reply-add"+ data.SEQ).empty();
			});
			
			$(".add-input"+ data.SEQ).keydown(function(key) {
				if (key.keyCode == 13) {
					createReplys (data.SAMPLE_SEQ, data.MEMBER_NO, $(".add-input"+ data.SEQ).val(), contextPath,
							data.DEPTH+1, data.SEQ, data.GROUP_NO);
				}
			});
		});
	}
}