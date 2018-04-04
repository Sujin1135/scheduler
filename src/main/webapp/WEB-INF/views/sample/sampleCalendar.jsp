<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="article" >
	<!-- 캘린더창 -->
	<div id="calendar-div">
		<div id="calendar"></div>
	</div>
	<!-- 상세 모달창 -->
	<div id="fullCalModal" class="modal fade">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header" style="color: white">
	                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
	                <h4 id="modalTitle" class="modal-title"></h4>
	            </div>
	            <div id="modalBody" class="modal-body">
	            	<div id="date" style="margin-top: 15px;">
	            	</div>
	            	
	            	<div id="content" style="margin-top: 15px;">
	            	</div>
	            	
	            	<div id="type" style="margin-top: 15px;">
	            	</div>
	            	
	            	<div id="name" style="margin-top: 15px;">
	            	</div>
	            	
	            	<div id="addMember" style="margin-top: 30px;">
	            	</div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">이전</button>
	                <button class="btn btn-info update-button"><a id="eventUrl">수정</a></button>
	                <button class="btn btn-warning delete-button">삭제</button>
	            </div>
	        </div>
	    </div>
	</div>
</div>