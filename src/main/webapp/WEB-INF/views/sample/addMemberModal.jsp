<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 멤버등록 모달 -->
<div id="addMemberModal" class="modal fade">
	<div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background-color: #00bfff; color: white" >
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span> <span class="sr-only">close</span></button>
                <h4 id="modalTitle" class="modal-title text-center">멤버 등록</h4>
            </div>
            <div id="modalBody" class="modal-body">
            	<div style='margin-top: 2em;'>
            		<div class='text-center'>
            			<select class='type'>
            				<option value='name'>이름</option>
            				<option value='dept'>부서</option>
							<option value='classes'>직급</option>
						</select>
						<input type='text' class='likeName' />
						<button id='searchButton'>검색</button></div>
					<div id='main' style='margin: 2em; overflow-y: scroll; height: 300px;'></div>
				</div>
            </div>
        </div>
    </div>
</div>