/* 
 * 공백을 체크하는 함수
 * 비어있으면 true 아니면 false를 반환하는 함수
 */
function spaceCheck(obj, objName, comment) {
	if(obj == null || obj == "" || obj.length == 0){
		alert(comment);
		$$(objName).focus();
		return true;
	}
	
	return false;
}

// trim
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