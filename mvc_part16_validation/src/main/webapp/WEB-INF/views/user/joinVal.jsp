<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<!-- user/join.jsp -->

<style>
	table{
		max-width:500px;
		margin:0 auto;
	}

	.uploadImage{
		width:100px;
		height:100px;
		border-radius:50px;
		border:1px solide #ccc;
	}
	
	#emailCodeWrap{
		display:none;
	}
	
	.text-danger{
		display : block;
		color : red;
		font-size : 14px;
	}
</style>

<form id="joinForm" action="${path }/user/joinPost" 
	method="POST" enctype="multipart/form-data">
	<table border="1">
		<tr>
			<th colspan="2">
				<h1>회원가입 페이지</h1>
			</th>
		</tr>
		<!-- name은 submit 할때 필요 / id는 유효성 검사할 때 필요 -->
		<!-- 프로필 이미지 -->
		<tr>
			<td>프로필 이미지</td>
			<td style="text-align:center">
				<img src="${path }/resources/img/profile_m.png" 
					 id="uploadImage" class="uploadImage" />
				<input type="file" id="profileImage" name="profileImage" 
						accept="image/*"/> <!-- accept : 타입 지정  -->
			</td>
		</tr>
		<!-- 아이디 -->
		<tr>
			<td>아이디(email)</td>
			<td>
				<input type="text" name="u_id" id="u_id" autocomplete="off" />
				<input type="button" id="acceptEmail" value="이메일 인증" />
				<div class="result"></div>
				<div id="emailCodeWrap">
					<input type="text" name="emailCode" id="emailCode" />
					<input type="hidden" id="code" />
				</div>
			</td>
		</tr>
		<!-- 비밀번호 -->
		<tr>
			<td>비밀번호</td>
			<td>
				<input type="password" name="u_pw" id="u_pw" />
				<div class="result"></div>
			</td>
		</tr>
		<tr>
			<td>비밀번호 확인</td>
			<td>
				<input type="password" name="re_pw" id="re_pw" /> 
				<div class="result"></div>
			</td>
		</tr>
		<tr>
			<td>이름(한글2~6자 이내)</td>
			<td>
				<input type="text" name="u_name" id="u_name" />
				<div class="result"></div>
			</td>
		</tr>
		<tr>
			<td>생년월일(ex-19930516)</td>
			<td>
				<input type="text" name="u_birth" id="u_birth" />
				<div class="result">
				</div>
			</td>
		</tr>
		<tr>
			<td>주소</td>
			<td>
				<div>
					<input type="text" name="u_post" 
							id="u_post" placeholder="우편번호" />
					<input type="button" value="주소찾기"
						onclick="daumPostCode();" />
				</div>
				<input type="text" name="u_addr" 
						id="u_addr" placeholder="주소" />
				<input type="text" name="u_addr_detail" 
						id="u_addr_detail" placeholder="상세주소" />
			</td>	
		</tr>
		<tr>
			<td>전화번호(-제외 숫자만 입력)</td>
			<td>
				<div id="phoneWrap">
					<input type="text" name="u_phone" id="u_phone"  />
					<input type="button" value="인증코드 전송" id="sendSMS" />
					<div class="result"></div>
				</div>
				
				<div id="codeWrap">
					<input type="text" id="code" />
					<input type="button" id="acceptCode" value="인증" />
				</div>
				 
			</td>	
		</tr>
		<tr>
			<!-- https://www.privacy.go.kr -->
			<td colspan="2">
				<h4>이용약관</h4>
				<textarea readonly rows="5" cols="50">개인정보는 내가 무작위로 쓸 수 있으니 동의하면 가입하셈</textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<label>
					<input type="checkbox" name="u_info" id="u_info" value="y" />
					개인정보 이용 동의
				</label>
				<div class="result">
				
				</div>
			</td>
		</tr>
			<tr>
			<td colspan="2">
				<label>
					<input type="submit" id="joinBtn" value="회원가입" />
				</label>
			</td>
		</tr>	
	</table>
</form>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function daumPostCode(){
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
            // 예제를 참고하여 다양한 활용법을 확인해 보세요.
            console.log(data);
            
            var fullAddr = ""; 	// 최종 주소
            var extraAddr = ""; // 조합형 주소
            var postCode = "";	// 우편번호
            
            // 사용자가 선택한 타입이 지번인지 도로명 주소인지 확인
            if(data.userSelectedType === "R"){
            	// 도로명 주소
            	fullAddr = data.roadAddress;
            	
            	// 법정 동명
            	if(data.bname !== ''){
            		extraAddr += data.bname;
            	}
            	
            	if(data.buildingName !== ''){	// 법정 동명이 존재하면 ", 빌딩이름" | 존재 안하면 그냥 빌딩이름 만 추가
            		extraAddr += extraAddr !== '' ? ', '+data.buildingName : +data.buildingName;
            	}
            	
            	fullAddr += (extraAddr !== '') ? '('+extraAddr+')' : '';
            }else{
            	// 지번 주소
            	fullAddr = data.jibunAddress;
            }
            
            // 우편 번호
            postCode = data.zonecode;
            
            // 입력 필드에 값 넣기
            $("#u_post").val(postCode);
            $("#u_addr").val(fullAddr);
            $("#u_addr_detail").focus();
            
        }
    }).open();
}
</script>

<script>
	var imgTemp = $(".uploadImage").attr("src");
	$("#profileImage").on("change", function(){
		var files = $(this)[0].files[0];
		if(files != null && files.type.startsWith("image/")){
			console.log(files.type);
			var path = window.URL.createObjectURL(files);
			$("#uploadImage").attr("src",path);
		}else{
			alert("이미지를 선택해 주세요.");
		}
	});
	
	// 문서가 모두 준비 되었을 때
	$(function(){
		
		$("#acceptEmail").click(function(){
			// checkEmail
			$.ajax({
				type : "GET",
				dataType : "text",
				url : "${path}/checkEmail",
				data :{
					u_id : $("#u_id").val()
				},
				success : function(code){
					if(code){
						alert("메일 전송 성공");
						$("#code").val(code);
						$("#emailCodeWrap").show();
					}else{
						alert("메일 전송 실패");
					}
				}
			});
		});
		// mobile -표시 없이 숫자만
		var regexMobile = /^[0-9]{2,3}?[0-9]{3,4}?[0-9]{4}$/;					
							// value, element는 꼭 있어야되고, regexpr는 있어도 되고 없어도됨
		$.validator.addMethod("regex",function(value,element,regexpr){
			return regexpr.test(value);	// 정규표현식의 값이 들어가있으면 true
		});
		
		$.validator.addMethod("code",function(value,elememt){
			var code = $("#code").val();
			if(code == '' || value == ''){
				return false;
			}
			return value == code;
		});
							
		$("#joinForm").validate({
			onkeyup : function(el){
				$(el).valid();
			},
			rules : {	// 규칙 지정해줌
				u_id : { // u_id == name값 
					required : true,	// 필수 등록
					email : true,
					remote : {
						type : "GET",
						url : "${path}/user/uidCheck"
					}
				}, // u_id end
				
				emailCode :{
					code : ""
				},
				
				u_pw : {
					required : true,
					minlength : 6,
					maxlength : 20
				},
				re_pw : {
					required : true,
					minlength : 6,
					maxlength : 20,
					equalTo : "#u_pw"
				},
				
				u_name : {
					required : true,
					rangelength : [2,6]	// 2~6글자 이내
				},
				
				u_phone : {
					required : true,
					regex : regexMobile
				},
				
				u_info : {
					required : true
				}
			},
			messages : {
				u_id : {
					required : "아이디(email)를 작성해주세요.",
					email : "올바른 이메일 형식이 아닙니다.",
					remote : "이미 존재하는 아이디입니다."
				},
				
				emailCode : {
					code : "이메일 인증 코드를 확인해 주세요"
				},
				
				u_pw : {
					required : "비밀번호를 작성해 주세요.",
					minlength : "비밀번호는 최소 6자리 이상입니다.",
					maxlength : "비밀번호는 최대 20자리까지 가능합니다."
				},
				re_pw : {
					required : "비밀번호를 작성해 주세요.",
					minlength : "비밀번호는 최소 6자리 이상입니다.",
					maxlength : "비밀번호는 최대 20자리까지 가능합니다.",
					equalTo : "비밀번호가 일치하지 않습니다."
				},
				
				u_name : {
					required : "이름을 입력해 주세요.",
					rangelength : "이름은 2~6글자 이내 작성해주세요."
				},
				
				u_phone : {
					required : "전화번호를 작성해 주세요.",
					regex : "올바른 전화번호 형식이 아닙니다."
				},
				
				u_info : {
					required : "개인정보이용동의를 확인 해주세요."
				}
				
			},
			errorClass : "text-danger",
			// error때 어떤 태그로 보여줄껀지 지정
			errorElement : "span",
			// error때 어디에다가 배치 시킬껀지 지정
			errorPlacement : function(error, element){	
				if(element.prop("type") === 'checkbox'){ // prop : 속성값
					element.removeClass("text-danger");
					error.insertAfter(element.parent());
				}else{
					error.insertAfter(element);
				}
			},
			//debug : true,	// 기본값은 false | submit 눌려도 해당 submit 처리가 안됨.
			submitHandler : function(form){
				// submit 하기 전에 전처리 공간
				$(form).submit();
			}
		});
	});
	
</script>

</body>
</html>
