<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정규식 표현 / regex.jsp</title>
</head>
<body>
	<script>
		/* 정규식 표현
			문자열에 포함된 문자 조합을 찾기 위해 사용되는 패턴
			javascript의 정규식은 java와 상이 할 수 있으나 기본 맥락은 동일
		*/
		const regex = /\d{3}-\d{4}-\d{4}/;
		var bool = regex.test("010-1234-5678");
		console.log(bool);	// true
		bool = regex.test("02-123-4567");
		console.log(bool);	// false
		
		const text = "ㅎㅇ 내 번호 010-1234-5678 이야. 만관부"
		var result = text.match(regex); // match : 해당 문자열 안에 동일한(정규식)친구가 있으면 해당값 전달 
		console.log(result);			// -> 없으면 null | => 배열로 전달함
		
		const pattern = /\d{5}-\d{4}-\d{4}/;
		result= text.match(pattern);
		console.log(result);
		
		var regexEmail =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;       // 이메일
		const url = "hap0p9y@nate.com";
		console.log(url.match(regexEmail));
		console.log(regexEmail.test(url));
	</script>

</body>
</html>