package net.koreate.valid;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
	locations= {"file:src/main/webapp/WEB-INF/spring/root-context.xml"}
)
public class SendMailTest {

	// mailSender
	@Autowired @Qualifier(value="mailSender")
	JavaMailSender mailSender;
	
	@Test
	public void mailSenderTest() throws Exception {
		System.out.println(mailSender);
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper 
			= new MimeMessageHelper(message,"UTF-8");
		messageHelper.setFrom("show5901@gmail.com");
		messageHelper.setTo("suj0309@naver.com");
		messageHelper.setSubject("메일 전송 테스트 제목");
		// true - html을 사용하겠다는 의미
		messageHelper.setText("<h1>내용 텍스트</h>",true);
		mailSender.send(message);
		System.out.println("발신 완료");
	}
}
