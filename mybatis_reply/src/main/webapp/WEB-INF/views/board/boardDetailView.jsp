<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board List</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
	$(() => {
		$("#replyInsert").click(function() {
			// serialize() : form안의 input, select, textarea의 value값을 간단하게 표준 url인코딩 형태의 문자열로 만들어줌
			//               content=내용&bnum=2&userId=user02
			event.preventDefault();
			let rdata = $("#rFrm").serialize();
			$.ajax({
				url:"rinsert.bo",
				data : rdata,
				success:function(result) {
					console.log(result);
					if(result > 0) {
						replyList();
						$("#content").val("");
					}
				},
				error:function() {
					console.log("ajax 통신 실패");
				}
			})
		})
		
		function replyList() {
			$.ajax({
				url:"detail.bo",
				data:{bno: $("#rhead input[name='bnum']").val() },
				type:"post",
				success:function(result) {
					console.log(result);
					let list = "";
					$.each(result, function(i, r) {
						list += "<tr>"
							  + "	<td>" + r.replyWriter + "</td>"
							  + "	<td>" + r.replyContent + "</td>"
							  + "	<td>" + r.createDate.substring(0,10) + "</td>"
							  + "</tr>"
					})
					$("#replyList").html(list);	
				},
				error:function(){
					console.log("ajax 통신 실패");
				}
			})
		}
	}) 
</script>
<style>
	.outer table {
		border:2px solid ;
		border-collapse : collapse;
	}
</style>
</head>
<body>
	<jsp:include page="../common/menubar.jsp" />
	<div class="outer" align="center">
		<h1 align="center">게시판 상세조회</h1>
		
		<table border="1">
			<tr>
				<td width="100">글번호</td>
				<td width="500">${ b.boardNo }</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>${ b.boardTitle }</td>
			</tr>
			<tr>
				<td>작성자</td>
				<td>${ b.boardWriter }</td>
			</tr>
			<tr>
				<td>조회수</td>
				<td>${ b.count }</td>
			</tr>
			<tr>
				<td>작성일</td>
				<td>${ b.createDate.substring(0,10) }</td>
			</tr>
			<tr>
				<td>내용</td>
				<td height="100">${ b.boardContent }</td>
			</tr>
		</table>
		<br>
		<table border="1">
			<thead id="rhead">
				<c:choose>
					<c:when test="${loginUser != null}">
						<form id="rFrm">
							<tr>
								<th width="100">댓글작성</th>
								<th width="400"><textarea cols="53" rows="3" name="content" id="content"></textarea></th>
								<th width="100"><button id="replyInsert">등록</button></th>
							</tr>
							<input type="hidden" name="bnum" value="${b.boardNo}">
							<input type="hidden" name="userId" value="${loginUser.userId}">
						</form>
					</c:when>
					<c:otherwise>
						<tr>
							<th width="100">댓글작성</th>
							<th width="400"><textarea cols="53" rows="3" readonly>로그인 후 이용 가능한 서비스입니다</textarea></th>
							<th width="100"><button disabled>등록</button></th>
						</tr>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${rlist.size() > 0}">
						<tr>
							<th colspan="3" style="text-align:center">댓글(${rlist.size()})</th>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th colspan="3" style="text-align:center">댓글이 없습니다</th>
						</tr>
					</c:otherwise>
				</c:choose>
			</thead>
			<tbody id="replyList">
				<c:forEach var="r" items="${rlist}">
					<tr>
						<td>${r.replyWriter}</td>
						<td>${r.replyContent}</td>
						<td>${r.createDate.substring(0,10)}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>