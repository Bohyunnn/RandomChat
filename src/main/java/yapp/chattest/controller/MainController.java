package yapp.chattest.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import yapp.chattest.dao.ChatsDao;
import yapp.chattest.dao.UserDao;
import yapp.chattest.model.Chat;
import yapp.chattest.model.User;
import yapp.chattest.service.RandomNameService;

@Controller
public class MainController {

	@Autowired
	private UserDao _userDao;

	@Autowired
	private ChatsDao _chatDao;

	@Autowired
	private RandomNameService randomNameService;

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	@RequestMapping("/abc")
	public ModelAndView index(@RequestParam("name") String name, @RequestParam("aaa") String aaa,
			@RequestParam("bbb") String bbb, HttpServletResponse response) {

		System.out.println("name= " + name);
		System.out.println("aaa= " + aaa);
		System.out.println("bbb= " + bbb);
		logger.info("<randomName> = " + name);
		// 1.이름이 비어있다면 loginPage()로 이동
		if (name == null) {
			logger.info("Name is null");
			return loginPage();
		}

		// 2.비어있지 않으면 ChatPage()로 이동
		else {
			logger.info("Name is not null.");
			Cookie cookie = new Cookie("name", URLEncoder.encode(name));
			cookie.setMaxAge(60 * 60 * 24);
			response.addCookie(cookie);

			return chatsPage();
		}
	}

	// 1-1. login Page로 가는 Controller
	// login Form에서 "method=post, action=/create-user" 로 넘어감.
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView loginPage() {
		return new ModelAndView("login");
	}

	// 2-2. logout하면 redirect됨. 이때, Cookie 값 저장!
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) {
		for (Cookie cookie : request.getCookies()) { // 요청정보로부터 쿠키를 가져옴.
			if ("name".equals(URLDecoder.decode(cookie.getName()))) { // 쿠키네임을
																		// 가져옴.
				logger.info("<cookie name>=" + cookie.getName());
				cookie.setMaxAge(0); // 쿠키 삭제
				response.addCookie(cookie); // 해당 쿠키를 응답에 추가함.
			}
		}
		return new ModelAndView("redirect:/");
	}

	// 1-2. login Form에서 넘어오면 '/create-user' URL로 이동
	// login Form에서 crate-user하면 [DB에 저장 + Cookie에 저장]
	@RequestMapping(value = "/create-user", method = RequestMethod.POST)
	public ModelAndView createUser(HttpServletRequest request,RedirectAttributes redirectAttributes, @RequestParam(value = "aaa") String aaa,
			@RequestParam(value = "bbb") String bbb) {
		try {
			// User 객체 생성
			User user = new User();
			// (익명 아이디 부여)
			String name = randomNameService.getRandomName();

			// User=> [Name, Time] 설정
			user.setName(name);
			user.setTimestamp(new Date().getTime());

			// save user in db (if new)
			// 만약에 새로운 user라면 DB 저장함.
			if (_userDao.getByName(name) == null) {
				_userDao.save(user); // DB 객체 저장
			}
			// !!!!!!!!!!!!
			redirectAttributes.addAttribute("name", name);
			redirectAttributes.addAttribute("aaa", aaa);
			redirectAttributes.addAttribute("bbb", bbb);
			// 쿠키에 저장
			// Cookie cookie = new Cookie("name", name);
			// response.addCookie(cookie);

		} catch (Exception e) {
			logger.error("Exception in creating user: ", e.getStackTrace());
		}

		return new ModelAndView("redirect:/abc");
	}

	// 2-1. chat Page로 가는 Controller
	@RequestMapping(value = "/chats", method = RequestMethod.GET)
	public ModelAndView chatsPage() {
		return new ModelAndView("chats");
	}

	// get-all-chats: 전체 채팅 내용
	@ResponseBody
	@RequestMapping(value = "/get-all-chats", method = RequestMethod.GET)
	public List<Chat> getAllChats() {
		try {
			return _chatDao.getAll();
		} catch (Exception e) {
			logger.error("Exception in fetching chats: ", e.getStackTrace());
		}
		return null;
	}

	// get-all-users: 전체 사용자
	@ResponseBody
	@RequestMapping(value = "/get-all-users", method = RequestMethod.GET)
	public List<User> getAllUsers() {
		try {
			return _userDao.getAll();
		} catch (Exception e) {
			logger.error("Exception in fetching users: ", e.getStackTrace());
		}
		return null;
	}

	// chat화면에서 sendChat()하면 post-chat으로 넘어옴.
	@ResponseBody
	@RequestMapping(value = "/post-chat", method = RequestMethod.POST)
	public ModelAndView postChat(HttpServletRequest request, HttpServletResponse response, @RequestParam String message,
			@CookieValue(required = true) String name) {
		try {
			// 사용자의 정보에 해당하는 user 가져옴
			User user = _userDao.getByName(URLDecoder.decode(name));

			if (user == null) {
				return logout(request, response);
			}

			// Chat 객체 = [message, user, Time] 저장
			Chat chat = new Chat();
			chat.setMessage(message);
			chat.setUser(user);
			chat.setTimestamp(new Date().getTime());

			// chatDao에 chat 객체 저장
			_chatDao.save(chat);
		} catch (Exception e) {
			logger.error("Exception in saving chat: ", e.getStackTrace());
		}
		return null;
	}

}
