package net.koreate.valid;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import net.koreate.valid.vo.ValidationMemberVO;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Controller
public class HomeController {
	
	// 문자 발송해주는 친구
	private DefaultMessageService messageService;

	@PostConstruct 
	// @PostConstruct : 의존성 주입이 이루어진 후 초기화를 수행 시켜주는 친구
	// - bean이 초기화 됨과 동시에 의존성을 확인할 수 있음
	// - bean이 여러번 초기화되는 것을 방지할 수 있음
    public void init(){ // 문자 인증(api key, api 시크릿 비번, 문자 발송해주는곳(고정))
        this.messageService = NurigoApp.INSTANCE.initialize("NCSIA5IIYYBCCHTZ", "YHERRFBC76LCQGTRG6ZYHG6QHEPBIP54", "https://api.coolsms.co.kr");
    }
	
	@Autowired
	JavaMailSender mailSender;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "home";
	}
	
	@GetMapping("regex")
	public void regex() {
		
	}
	
	@GetMapping("/user/join")
	public String join() {
		return "user/join";
	}
	
	@GetMapping("/user/joinVal")
	public void joinVal() {
		
	}
	
	@GetMapping("/user/login")
	public String login() {
		return "user/login";
	}
	
	@GetMapping("/user/uidCheck")
	@ResponseBody
	public boolean isCheck(String u_id) {
		boolean isCheck = false;
		System.out.println("u_id : " + u_id);
		if(u_id != null && !u_id.equals("asdf@gmail.com")) {
			// 등록되지 않은 이메일 아이디
			isCheck = true;
		}
		return isCheck;
	}
	
	@GetMapping("/checkEmail")
	@ResponseBody
	public String sendMail(
			@RequestParam("u_id") String email
			) throws Exception{
		System.out.println(email);
		String code = "";
		
		for(int i=0; i<5; i++) {
			code +=(int)(Math.random()*10);
		}
		
		MimeMessage mesage = mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(mesage,"UTF-8");
		helper.setFrom("show5901@gmail.com");
		helper.setTo(email);
		helper.setSubject("이메일 인증 코드 확인");
		helper.setText("다음 인증 코드를 입력해주세요 <h3><["+code+"]/h3>", true);
		mailSender.send(mesage);
		System.out.println("발신 완료");
		
		return code;
	}
	
	// 전화번호 인증 문자 메세지 전송
	@PostMapping("/sendSMS")
	@ResponseBody
	public Map<String, String> sendSMS(
			String userPhoneNumber
			) throws Exception{
		// code 생성
		String code="";
		for(int i=0; i<5; i++) {
			code += (int)(Math.random()*10);
		}
		
		Message message = new Message();
        // 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
        message.setFrom("01045725901");
        // 01000000000 : 테스트 번호 - 금액 차감 안됨
//	    message.setTo("01000000000");
        message.setTo(userPhoneNumber);
        message.setText("테스트 전송 메세지 입니다.해당 인증번호는["+code+"]입니다.");
        
        System.out.println(message.getText());
        System.out.println(code);
        
        SingleMessageSentResponse response 
        	= this.messageService.sendOne(new SingleMessageSendingRequest(message));
        System.out.println(response);

		Map<String,String> map = new HashMap<>();
		map.put("code", code);
		map.put("result", response.getStatusCode());
		return map;
	}
	
	@Autowired
	ServletContext context;
	
	// 회원 등록 요청
	@PostMapping("/user/joinPost")
	public String joinPost(
				ValidationMemberVO vo,
				MultipartFile profileImage
			) throws Exception{
		System.out.println(vo);
		// 전달된 파일 정보가 존재하지 않으면 true
		System.out.println(profileImage.isEmpty());
		System.out.println(profileImage.getOriginalFilename());
		System.out.println(profileImage.getContentType());
		// 입력 태그 파라미터 이름
		System.out.println(profileImage.getName());
		
		if(!profileImage.isEmpty()) {
			// src/main/webapp/upload/profile/u_id/image
			String path = "upload"+File.separator
							+"profile"+File.separator
							+vo.getU_id();
			String realPath = context.getRealPath(path);
			File file = new File(realPath);
			if(!file.exists()) {
				file.mkdirs();
			}
			file = new File(
					realPath, 
					profileImage.getOriginalFilename()
			);
			profileImage.transferTo(file);
			String u_profile
				= path+File.separator+profileImage.getOriginalFilename();
			vo.setU_profile(u_profile);
		}
		System.out.println(vo);
		
		return "home";
	}
	
}
