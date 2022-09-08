<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div>
	<!-- <button id="sendOne">send-one</button> -->
	<button id="balance">get-balance</button>
</div>

<script>
	$("#balance").click(function(){
		$.get("get-balance",function(result){
			console.log(result);
		});
	});

	$("#sendOne").click(function(){
		$.post("send-one",function(result){
			console.log(result);
		});
	});
</script>

</body>
</html>
