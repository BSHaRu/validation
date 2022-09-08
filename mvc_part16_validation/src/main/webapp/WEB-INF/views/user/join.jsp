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
	
	#acceptEmail, #emailCodeWrap, #codeWrap{
		display:none;
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
					<input type="text" id="emailCode" />
					<button type="button" id="emailAcceptBtn">인증완료</button>
				</div>
			</td>
		</tr>
		<!-- 비밀번호 -->
		<tr>
			<td>비밀번호</td>
			<td>
				<input type="password" name="u_pw" id="u_pw" />
				<div class="result">
				
				</div>
			</td>
		</tr>
		<tr>
			<td>비밀번호 확인</td>
			<td>
				<input type="password" id="re_pw" /> 
				<div class="result">
				</div>
			</td>
		</tr>
		<tr>
			<td>이름(한글2~6자 이내)</td>
			<td>
				<input type="text" name="u_name" id="u_name" />
				<div class="result">
				</div>
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
					<input type="button" id="joinBtn" value="회원가입" />
				</label>
			</td>
		</tr>	
	</table>
</form>
<!-- 주소 api -->
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
            if(data.userSelectedType == "R"){
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
	
	$("#u_id").focus();
	
	
	// (메세지를 보여줄 요소, 검사할 값, 비교할 정규식, 출력할 메세지, 비동기 통신 함수)
	function checkRegex(elP, valP, regexP, messageP, ajaxP){
		// 정규 표현식이 일치 하지 않을 때
		if(regexP.test(valP) === false){
			showMessage(elP,messageP,false);
			return false;
		// 정규표현식 일치하고 ajax가 존재하지 않을 때
		}else if(regexP.test(valP) !== false
					&& ajaxP === null){
			showMessage(elP, messageP, true);
			return true;
		}else{
			if(ajaxP !== null){
				ajaxP(elP);
			}
		}
	}
	
	// (메세지를 보여줄 요소, 메세지, 성공 실패 여부)
	function showMessage(elP,messageP,isCheck){
		var html = "<sapn style='margin-left:5px;font-size:12px;";
		html += isCheck ? "color:green;" : "color:red;"
		html += "'>"; // 여기까지가 style 임
		html += messageP;
		html += "</span>";
		$(elP).html(html);		
	}
	
	// u_id 검증 여부
	var boolUid = false;
	var regexEmail =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;  // 이메일
	
	// 입력태그에 값이 작성 될 때
	$("#u_id").on("input",function(){
		var tempVal = $(this).val();
		var elP = $(this).parent().find(".result");
		var message = "올바른 이메일 형식이 아닙니다.";
		boolUid = checkRegex(elP,tempVal,regexEmail,message,checkUidAjax);
	});
	
	// 서버에 등록된 아이디 인지 확인 - ajax
	function checkUidAjax(elP){
		$.ajax({
			type : "GET",
			url : "${path}/user/uidCheck",
			data : {
				u_id : $("#u_id").val()
			},
			dataType : "json",
			success : function(result){
				console.log(result);
				boolUid = result;
				showMessage(
					elP,
					boolUid ? "사용 가능한 아이디 입니다." : "이미 존재하는 아이디 입니다.",
					boolUid
				);
				
				if(boolUid){
					// 사용 가능한 이메일 인증코드 발송 버튼 활성화
					$("#acceptEmail").show();
				}else{
					$("#acceptEmail").hide();
				}
			}
			
		});
	} // checkUid end
	
	// 인증 메일 발송된 코드 저장
	var emailCode = "";
	$("#acceptEmail").click(function(){
		$.ajax({
			type : "GET",
			dataType : "text",
			url : "${path}/checkEmail",
			data :{
				u_id : $("#u_id").val()
			},
			success : function(code){
				console.log(code);
				if(code){
					emailCode = code;
					alert("메일 발송 완료 \n메일을 확인 해주세요.");
					$("#emailCodeWrap").show();
				}else{
					alert("메일 발송 실패 \n관리자에게 문의해주세요.");
				}
			}
		});
	});
	
	// 인증코드 확인 완료 여부
	var boolEmailCode = false;
	// 인증 코드 검사
	$("#emailAcceptBtn").click(function(){
		var userCode = $("#emailCode").val();
		if(emailCode == userCode){
			console.log("일치함");
			boolEmailCode = true;
			alert("이메일 인증이 완료 되었습니다.");
			$("#emailCodeWrap").hide();
		}else{
			boolEmailCode = false;
			alert("인증코드를 다시 확인해 주세요");
		}
	});
	
	// 비밀번호 확인
	var boolPassword = false;
	var regexPass = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,16}$/;	// 특수문자 포함 비밀번호
	
	$("#u_pw").on("input",function(){
		var valP = $(this).val();
		var elP = $(this).parent().find(".result");
		var message = "특수문자 포함 영문/숫자 조합하여 8~16자 이내 작성";
		boolPassword = checkRegex(elP,valP,regexPass,message,null);
	});
	
	// 비밀번호 동일 값 체크 여부
	var boolPassCheck = false;
	
	$("#re_pw").on("input",function(){
		var valP = $(this).val();
		var message = "";
		var originalVal = $("#u_pw").val();
		var elP = $(this).parent().find(".result");
		
		// 정규표현식 통과
		if(boolPassword){
			if(valP == originalVal){
				boolPassCheck = true;
				message = "비밀번호가 일치합니다.";
			}else{
				boolPassCheck = false;
				message = "비밀번호가 일치하지 않습니다.";
			}
		}else{
			// 비밀번호란 확인
			boolPassCheck = false;
			message = "비밀번호를 먼저 확인해 주세요.";
		}
		showMessage(elP,message,boolPassCheck);
	});
	
	// 이름 확인 여부
	var boolName = false;
	var regexName = /^[\uac00-\ud7a3]{2,6}$/; // 2~6글자 이내 한글
	
	$("#u_name").on("input",function(){
		var valP = $(this).val();
		var elP = $(this).parent().find(".result");
		var message = "2~6글자 이내 한글로 작성";
		boolName = checkRegex(elP,valP,regexName,message,null);
	});
	
	// 생년 월일
	var boolBirth = false;
	var regexBirth = /^[0-9]{4}[0-9]{2}[0-9]{2}$/; // 생년월일  19820607
	$("#u_birth").on("input",function(){
		var temVal = $(this).val();
		var message = "19930516 형식으로 작성해주세요.";
		var elP = $(this).find("+ .result");	// + : 형제요소
		boolBirth = checkRegex(elP, temVal, regexBirth, message, null);
	})
	
	// 전화번호 확인 여부
	var boolPhone = false;
	// mobile -표시 없이 숫자만
	var regexMobile = /^[0-9]{2,3}?[0-9]{3,4}?[0-9]{4}$/;					
	$("#u_phone").on("input", function(){
		var tempVal = $("#u_phone").val();
		var elP = $(this).parent().find(".result");
		var message = "-제외 숫자만 입력해주세요.";
		boolPhone = checkRegex(elP, tempVal, regexMobile, message, null);
		
		if(boolPhone){
			$("#sendSMS").attr("disabled", false);
			$("#codeWrap").slideUp();
		}
	});
	
	// 발송된 SMS 코드 저장
	var code = "";
	// 인증 완료 여부
	var boolSMS = false;
	$("#sendSMS").click(function(){
		if(!boolPhone){
			// 정규표현식 실패
			alert("전화번호를 먼저 확인해 주세요.");
			$("#u_phone").focus();
		}else{
			$("#sendSMS").attr("disabled", true);
			
			$.ajax({
				type : "POST",
				dataType : "json",
				url : "${path}/sendSMS",
				data :{
					userPhoneNumber : $("#u_phone").val()
				},
				success : function(data){
					if(data['result'] == 2000){ // 2000 상태코드 : 정상 발송
						$("#codeWrap").slideDown();
						code = data['code'];
					} 
					console.log(data);
					console.log(code);
				} // success end
				
			});	// ajax end
		}
	});
	
	// 사용자가 입력한 인증코드 확인
	$("#acceptCode").click(function(){
		var userCode = $("#code").val();
		if(code != "" 
				&& userCode.length != 0 
				&& code == userCode){
			alert("인증 완료");
			boolSMS = true;
			$("#codeWrap").slideUp();
			$("#code").val("");
		}else{
			alert("발송된 인증코드를 다시 확인해 주세요.");
			$("#code").focus();
		}
	});
	
	// submit event 실행 전 작성내용 검증 확인
	$("#joinBtn").click(function(){
		//$("#joinForm").submit();
	
		if(!boolUid){
			alert("아이디를 확인해 주세요.");
			$("#u_id").focus();
		}else if(!boolEmailCode){
			alert("이메일 인증을 완료해 주세요.");
			$("#emailCode").focus();
		}else if(!boolPassword){
			alert("비밀번호를 확인해 주세요.");
			$("#u_pw").focus();
		}else if(!boolPassCheck){
			alert("비밀번호 일치여부를 확인해 주세요.");
			$("#re_pw").focus();
		}else if(!boolName){
			alert("이름 입력란을 확인해 주세요.");
			$("#u_name").focus();
		}else if(!boolBirth){
			alert("생일 입력란을 확인해 주세요.");
			$("#u_birth").focus();
		}else if(!boolPhone){
			alert("전화번호를 확인해 주세요.");
			$("#u_phone").focus();
		}else if(!boolSMS){
			alert("전화번호 인증을 완료해 주세요.");
			$("#code").focus();
		}else if(!$("#u_info").is(":checked")){
			alert("개인정보 이용 동의를 확인해주세요.");
			$("#u_info").focus();
		}else{
			$("#joinForm").submit();
		}
		 
	});
	
	
</script>

</body>
</html>
