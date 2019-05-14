<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>TODO list - 써머코딩 2019</title>
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<script src="${pageContext.request.contextPath}/resources/js/jquery_1.11.1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/stylecustom.css" rel="stylesheet" type="text/css" />
	<script>
		var addable = false;
		var modable = false;
		var modno;
		var btnmodok;
		var btnmodcancel;
		$(document).ready(function() {
			firstSet();
		});
		function firstSet() {
			setColor();
			$('.panel-new').hide();
			$('.panel-mod').hide();
			$('.pb').hide();
			$('.btn-order').hide();
			$('.btn-modok').hide();
			$('.btn-modcancel').hide();
			$('#btn-orderok').hide();
			$('#btn-ordercancel').hide();
			$('.ph').each(function(i,element){
				$(element).on('click',function(){
					allPanelHide();
					if($(this).parent().find('.pb').is(":hidden")==true){
						$(this).parent().find('.pb').slideDown();
					};
				});
			});
			$('#btn-orderchange').on('click',function(){
				removeBtns();
				$('.btn-order').show();
				orderStart();
			});
			$('#btn-orderok').on('click',function(){
				var nums = $('.ex-no');
				var exnos = new Array(nums.length);
				for(var i=0; i<exnos.length; i++) {
					exnos[i] = $(nums[i]).val();
				}
				if(exnos.length>0) {
					formOrder(exnos);
				} else {
					killAllBtns();
					redirect();
				};
			});
			$('#btn-newform').on('click',function(){
				allPanelHide();
				removeBtns();
				$('.panel-new').show();
			});
			$('#new-deadable').on('change',function(){
				newable = false;
				if($('#new-deadable').is(":checked")==true) {
					$('#new-date').prop('disabled',false);
					$('#new-time').prop('disabled',false);
				} else {
					$('#new-date').prop('disabled',true);
					$('#new-time').prop('disabled',true);
				};
			});
			$('#mod-deadable').on('change',function(){
				modable = false;
				if($('#mod-deadable').is(":checked")==true) {
					$('#mod-date').prop('disabled',false);
					$('#mod-time').prop('disabled',false);
				} else {
					$('#mod-date').prop('disabled',true);
					$('#mod-time').prop('disabled',true);
				};
			});
			$('#btn-regist').on('click',function(){
				if(addable!=true) {
					checkAdd();
					if(addable==true) {
						formAdd();
					};
				} else {
					formAdd();
				};
			});
			$('.btn-cancel').on('click',function(){
				killAllBtns();
				redirect();
			});
			$('.btn-del').each(function(i,element){
				$(element).on('click',function(){
					var result = confirm('정말로 이 항목을 삭제합니까?');
					if(result) {
						formDel($(this).parent().find('.ex-no').val());
					}
				});
			});
			$('.btn-mod').each(function(i,element){
				$(element).on('click',function(){
					modno = $(this).parent().find('.ex-no').val();
					removeBtns();
					$(this).parent().parent().parent().find('.ph').off('click');
					$(this).parent().parent().removeClass('pb');
					var extr = $(this).parent().parent().parent().find('.ph').find('.table').find('tbody').find('tr');
					if($(extr).hasClass('danger')==true) {
						$('#mod-tr').addClass('danger');
					} else if($(extr).hasClass('success')==true) {
						$('#mod-tr').addClass('success');
					} else if($(extr).hasClass('prior1')==true) {
						$('#mod-tr').addClass('active');
						$('#mod-tr').addClass('prior1');
					} else if($(extr).hasClass('prior2')==true) {
						$('#mod-tr').addClass('active');
						$('#mod-tr').addClass('prior2');
					}
					btnmodok = $(this).parent().find('.btn-modok');
					btnmodcancel = $(this).parent().find('.btn-modcancel');
					$(btnmodok).show();
					$(btnmodcancel).show();
					$('#mod-title').val(extr.find('.ex-title').text());
					$('#mod-note').val($(this).parent().find('.ex-note').val());
					$('#mod-priority').val(extr.find('.ex-priority').val());
					var deadline = extr.find('.ex-deadline').text().trim();
					if(deadline!='-') {
						$('#mod-deadable').prop('checked',true);
						$('#mod-date').prop('disabled',false);
						$('#mod-time').prop('disabled',false);
						$('#mod-date').val(deadline.substring(0,10));
						$('#mod-time').val(deadline.substring(11,17));
					};
					var complete = extr.find('.ex-complete').text().trim();
					if(complete=='YES') {
						$('#mod-complete').val(1);
					} else {
						$('#mod-complete').val(0);
					};
					extr.replaceWith($('#mod-tr'));
					$(this).parent().find('.ex-note').replaceWith($('#mod-note'));
				});
			});
			$('.btn-modok').each(function(i,element){
				$(element).on('click',function(){
					if(modable!=true) {
						checkMod();
						if(modable==true) {
							formMod();
						};
					} else {
						formMod();
					};
				});
			});
		};
		function setColor() {
			var fired = new Array();
			var prior1 = new Array();
			var prior2 = new Array();
			var completed = new Array();
			var allf = $('.fired');
			for(var i=0; i<allf.length; i++) {
				if($(allf[i]).parent().find('table').find('tbody').find('tr').find('.ex-complete').text().trim()=='NO') {
					if(allf[i].value=='true') {
						fired.push($(allf[i]).parent().find('table').find('tbody').find('tr'));
					} else {
						var thisprior = $(allf[i]).parent().find('table').find('tbody').find('tr').find('.text-center').find('.ex-priority').val();
						if(thisprior==1) {
							prior1.push($(allf[i]).parent().find('table').find('tbody').find('tr'));
						}
						else if(thisprior==2) {
							prior2.push($(allf[i]).parent().find('table').find('tbody').find('tr'));
						};
					};
				} else {
					completed.push($(allf[i]).parent().find('table').find('tbody').find('tr'));
				};
			};
			for(var i=0; i<fired.length; i++) {
				$(fired[i]).addClass('danger');
			};
			for(var i=0; i<prior1.length; i++) {
				$(prior1[i]).addClass('active');
				$(prior1[i]).addClass('prior1');
			};
			for(var i=0; i<prior2.length; i++) {
				$(prior2[i]).addClass('active');
				$(prior2[i]).addClass('prior2');
			};
			for(var i=0; i<completed.length; i++) {
				$(completed[i]).addClass('success');
			};
		};
		function allPanelHide() {
			$('.pb').slideUp();
		};
		function removeBtns() {
			$('.btn-remove').hide();
		};
		function forReNew() {
			$('.btns-new').show();
		};
		function forReDel() {
			$('.btn-mod').show();
			$('.btn-del').show();
		};
		function forReMod() {
			$(btnmodok).show();
			$(btnmodcancel).show();
		};
		function forReOrder() {
			$('.btn-order').show();
			$('#btn-orderok').show();
			$('#btn-ordercancel').show();
		};
		function orderStart() {
			$('#btn-orderok').show();
			$('#btn-ordercancel').show();
			allPanelHide();
			$('.ph').off();
			$('.btn-orderup').each(function(i,element){
				$(element).on('click',function(){
					var nowpanel = $(this).parent().parent().parent().parent().parent().parent();
					var otherpanel = $(nowpanel).prev();
					if($(otherpanel).hasClass('ex-panel')) {
						var temp = $(otherpanel).detach();
						$(nowpanel).after(temp);
					};
				});
			});
			$('.btn-orderdown').each(function(i,element){
				$(element).on('click',function(){
					var nowpanel = $(this).parent().parent().parent().parent().parent().parent();
					var otherpanel = $(nowpanel).next();
					if($(otherpanel).hasClass('ex-panel')) {
						var temp = $(otherpanel).detach();
						$(nowpanel).before(temp);
					};
				});
			});
			
		};
		function allRemoveBtns() {
			$('.btn').hide();
		};
		function killAllBtns() {
			$('.btn').off();
		};
		function redirect() {
			window.location.replace('home');
		};
		function checkAdd() {
			if($('#new-title').val()=='') {
				alert('제목은 필수입니다!');
				return false;
			};
			if($('#new-deadable').is(":checked")==true) {
				var regex = /^[\d]{4}-[0-1][\d]-[0-3][\d]$/;
				if(!$('#new-date').val()) {
					alert('마감 기한을 사용하려면 날짜 입력이 필요합니다!');
					return false;
				} else if(regex.test($('#new-date').val())) {
					if(parseInt($('#new-date').val().substring(5,7))>12) {
						alert('월은 01~12월까지 허용됩니다.');
						return false;
					} else if($('#new-date').val().substring(5,7)==00) {
						alert('00월은 올바른 월이 아닙니다.');
						return false;
					};
					if(parseInt($('#new-date').val().substring(8,10))>31) {
						alert('일은 01~31일까지 허용됩니다.');
						return false;
					} else if($('#new-date').val().substring(8,10)==00) {
						alert('00일은 올바른 일이 아닙니다.');
						return false;
					};
				} else {
					alert('마감 기한을 사용하려면 올바른 날짜(YYYY-MM-DD)가 필요합니다!');
					return false;
				};
				regex = /^[0-2][\d]:[0-5][\d]$/;
				if(!$('#new-time').val()) {
					alert('마감 기한을 사용하려면 시간 입력이 필요합니다!');
					return false;
				} else if(regex.test($('#new-time').val())) {
					if(parseInt($('#mod-time').val().substring(0,2))>23) {
						alert('시는 00~23시까지 허용됩니다.');
						return false;
					};
				} else {
					alert('마감 기한을 사용하려면 올바른 시간(HH:mm)이 필요합니다!');
					return false;
				};
			};
			addable = true;
		};
		function checkMod() {
			if($('#mod-title').val()=='') {
				alert('제목은 필수입니다!');
				return false;
			};
			if($('#mod-deadable').is(":checked")==true) {
				var regex = /^[\d]{4}-[0-1][\d]-[0-3][\d]$/;
				if(!$('#mod-date').val()) {
					alert('마감 기한을 사용하려면 날짜 입력이 필요합니다!');
					return false;
				} else if(regex.test($('#mod-date').val())) {
					if(parseInt($('#mod-date').val().substring(5,7))>12) {
						alert('월은 01~12월까지 허용됩니다.');
						return false;
					} else if($('#mod-date').val().substring(5,7)==00) {
						alert('00월은 올바른 월이 아닙니다.');
						return false;
					};
					if(parseInt($('#mod-date').val().substring(8,10))>31) {
						alert('일은 01~31일까지 허용됩니다.');
						return false;
					} else if($('#mod-date').val().substring(8,10)==00) {
						alert('00일은 올바른 일이 아닙니다.');
						return false;
					};
				} else {
					alert('마감 기한을 사용하려면 올바른 날짜(YYYY-MM-DD)가 필요합니다!');
					return false;
				};
				regex = /^[0-2][\d]:[0-5][\d]$/;
				if(!$('#mod-time').val()) {
					alert('마감 기한을 사용하려면 시간 입력이 필요합니다!');
					return false;
				} else if(regex.test($('#mod-time').val())) {
					if(parseInt($('#mod-time').val().substring(0,2))>23) {
						alert('시는 00~23시까지 허용됩니다.');
						return false;
					};
				} else {
					alert('마감 기한을 사용하려면 올바른 시간(HH:mm)이 필요합니다!');
					return false;
				};
			};
			modable = true;
		};
		function formAdd() {
			allRemoveBtns();
			$.ajax({
                url: "ajax/new",
                data:{
                	title:$('#new-title').val(),
                	note:$('#new-note').val(),
                	priority:$('#new-priority').val(),
                	deadable:$('#new-deadable').is(":checked"),
                	deaddate:$('#new-date').val(),
                	deadtime:$('#new-time').val(),
                },
                type:"post",
                success:function(response){
	                if(response == 'OK') {
	                	alert('등록 성공');
	                	redirect();
	                } else {
	                	alert('등록에 실패했습니다. 마감 기한 날짜와 시간을 검토해주세요.');
	                	forReNew();
	                }
                },
                error:function(){
                	alert('서버가 응답하지 않습니다. 조금 후 다시 시도해주세요.');
                	forReNew();
                },
            });
		};
		function formDel(varno) {
			allRemoveBtns();
			$.ajax({
                url: "ajax/del",
                data:{
                	no:varno,
                },
                type:"post",
                success:function(response){
	                if(response == 'OK') {
	                	alert('삭제했습니다.');
	                	redirect();
	                } else {
	                	alert('삭제에 실패했습니다. 조금 후 다시 시도해주세요.');
	                	forReDel();
	                }
                },
                error:function(){
                	alert('서버가 응답하지 않습니다. 조금 후 다시 시도해주세요.');
                	forReDel();
                },
            });
		};
		function formMod() {
			allRemoveBtns();
			$.ajax({
                url: "ajax/mod",
                data:{
                	no:modno,
                	title:$('#mod-title').val(),
                	note:$('#mod-note').val(),
                	priority:$('#mod-priority').val(),
                	deadable:$('#mod-deadable').is(":checked"),
                	deaddate:$('#mod-date').val(),
                	deadtime:$('#mod-time').val(),
                	complete:$('#mod-complete').val(),
                },
                type:"post",
                success:function(response){
	                if(response == 'OK') {
	                	alert('수정했습니다.');
	                	redirect();
	                } else {
	                	alert('수정에 실패했습니다. 마감 기한 날짜와 시간을 검토해주세요.');
	                	forReMod();
	                }
                },
                error:function(){
                	alert('서버가 응답하지 않습니다. 조금 후 다시 시도해주세요.');
                	forReMod();
                },
            });
		};
		function formOrder(sequence) {
			allRemoveBtns();
			$.ajax({
                url: "ajax/order",
                traditional : true,
                data:{
                	sequence:sequence,
                },
                type:"post",
                success:function(response){
	                if(response == 'OK') {
	                	alert('순서를 바꿨습니다.');
	                	redirect();
	                } else {
	                	alert('순서를 바꾸지 못했습니다. 다시 시도해주세요.');
	                	forReOrder();
	                }
                },
                error:function(){
                	alert('서버가 응답하지 않습니다. 조금 후 다시 시도해주세요.');
                	forReOrder();
                },
            });
		};
	</script>
<body>
	<div class="container-fluid">
		<div class="jumbotron text-center maindiv">
			<h2>TODO list - Summer Coding 2019</h2>
			<p>윤동수</p>
		</div>
		<c:if test="${not empty deadlist}">
			<div class="alert alert-dismissible alert-danger maindiv">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<h3 class="alert-h">알림! 마감 기한이 지난 항목이 존재합니다!</h3>
				<c:forEach var="dead" items="${deadlist}">
					<p>
						${dead.title} (~${dead.strdeadline})
					</p>
				</c:forEach>
			</div>
		</c:if>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-offset-2 col-lg-8 col-md-offset-1 col-md-10 col-sm-12 col-xs-12">
				<div class="maindiv">
					<table class="table table-bordered table-striped table-hover">
						<thead>
							<tr>
								<th id="menu-title">제목</th>
								<th style="width: 90px;">중요도</th>
								<th style="width: 185px;">마감 기한</th>
								<th style="width: 90px;">완료여부</th>
							</tr>
						</thead>
					</table>
					
					<!-- 신규생성용 -->
					<div class="panel panel-new">
						<div class="panel-heading">
							<table class="table">
								<tbody>
									<tr class="active">
										<td class="text-center">
											새로운 할 일
											<input class="form-control" id="new-title" type="text" placeholder="제목(30자 이내)" maxlength="30" required></td>
										<td class="text-center" style="width: 90px;">
											중요도
											<select class="form-control" id="new-priority" style="padding: 0px;">
												<option value="0">보통</option>
												<option value="1">중요</option>
												<option value="2">매우 중요</option>
											</select>
										</td>
										<td class="text-center" style="width: 185px;">
											<input type="checkbox" id="new-deadable">
											마감 기한 있음
											<input class="form-control" id="new-date" type="date" disabled>
											<input class="form-control" id="new-time" type="time" disabled>
										</td>
										<td class="text-center" style="width: 90px;">-</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="panel-body">
							<div class="text-right">
								<textarea class="form-control text-question" id="new-note" rows="6" placeholder="상세(1000자 이내)" maxlength="1000"></textarea>
								<button type="button" class="btn btn-info btn-sm btns-new" id="btn-regist">등록</button>
								<button type="button" class="btn btn-primary btn-sm btn-cancel btns-new">취소</button>
							</div>
						</div>
					</div>
					
					<!-- 수정용 -->
					<div class="panel panel-mod">
						<div class="panel-heading">
							<table class="table">
								<tbody>
									<tr id="mod-tr">
										<td class="text-center">
											할 일 수정
											<input class="form-control" id="mod-title" type="text" placeholder="제목(30자 이내)" maxlength="30" required></td>
										<td class="text-center" style="width: 90px;">
											중요도
											<select class="form-control" id="mod-priority" style="padding: 0px;">
												<option value="0">보통</option>
												<option value="1">중요</option>
												<option value="2">매우 중요</option>
											</select>
										</td>
										<td class="text-center" style="width: 185px;">
											<input type="checkbox" id="mod-deadable">
											마감 기한 있음
											<input class="form-control" id="mod-date" type="date" disabled>
											<input class="form-control" id="mod-time" type="time" disabled>
										</td>
										<td class="text-center" style="width: 90px;">
											<select class="form-control" id="mod-complete" style="padding: 0px;">
												<option value="0">NO</option>
												<option value="1">YES</option>
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="panel-body">
							<div class="text-right">
								<textarea class="form-control" id="mod-note" rows="6" placeholder="상세(1000자 이내)" maxlength="1000"></textarea>
							</div>
						</div>
					</div>
					
					<!-- 기존목록 -->
					<c:forEach var="todo" items="${alllist}">
						<div class="panel ex-panel">
							<div class="panel-heading ph">
								<input type="hidden" class="fired" value="${todo.fired}">
								<table class="table">
									<tbody>
										<tr>
											<td class="title ex-title">${todo.title}</td>
											<td class="text-right td-order" style="width: 70px;">
												<button type="button" class="btn btn-primary btn-xs btn-order btn-orderup">▲</button>
												<button type="button" class="btn btn-primary btn-xs btn-order btn-orderdown">▼</button>
											</td>
											<td class="text-center" style="width: 90px;">
												<input type="hidden" class="ex-priority" value="${todo.priority}">
												<c:choose>
													<c:when test="${todo.priority==2}">매우 중요</c:when>
													<c:when test="${todo.priority==1}">중요</c:when>
													<c:when test="${todo.priority==0}">보통</c:when>
												</c:choose>
											</td>
											<td class="text-center ex-deadline" style="width: 185px;">
												<c:choose>
													<c:when test="${todo.deadable==0}">-</c:when>
													<c:otherwise>${todo.strdeadline}</c:otherwise>
												</c:choose>
											</td>
											<td class="text-center ex-complete" style="width: 90px;">
												<c:choose>
													<c:when test="${todo.complete==1}">YES</c:when>
													<c:when test="${todo.complete==0}">NO</c:when>
												</c:choose>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="panel-body pb">
								<div class="text-right">
									<textarea class="form-control ex-note" name="question" rows="6" maxlength="1000" placeholder="(내용없음)" disabled>${todo.note}</textarea>
									<input type="hidden" class="ex-no" value="${todo.no}">
									<button type="button" class="btn btn-sm btn-warning btn-remove btn-mod">수정</button>
									<button type="button" class="btn btn-sm btn-danger btn-remove btn-del">삭제</button>
									<button type="button" class="btn btn-sm btn-primary btn-cancel btn-modcancel">취소</button>
									<button type="button" class="btn btn-sm btn-warning btn-modok">적용</button>
								</div>
							</div>
						</div>
					</c:forEach>
                </div>
				<div class="empty-row"></div>
				<div class="maindiv">
					<p>※ 항목을 클릭하면 상세설명(내용) 확인과 관리(수정, 삭제, 완료처리)가 가능합니다.</p>
				</div>
				<div class="empty-row"></div>
				<div>
					<button type="button" class="btn btn-md btn-info btn-remove" id="btn-newform">새로운 할 일</button>
					<button type="button" class="btn btn-md btn-primary btn-remove" id="btn-orderchange">순서 변경 ▲▼</button>
					<button type="button" class="btn btn-md btn-success" id="btn-orderok">순서 적용</button>
					<button type="button" class="btn btn-md btn-primary btn-cancel" id="btn-ordercancel">순서 복구</button>
				</div>
				<div class="empty-row"></div>
				<div class="empty-row"></div>
				<div class="empty-row"></div>
				<div class="empty-row"></div>
				<div class="empty-row"></div>
			</div>
		</div>
	</div>
</body>
</html>