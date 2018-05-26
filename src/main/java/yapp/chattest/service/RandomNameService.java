package yapp.chattest.service;

import java.util.Random;

import org.springframework.stereotype.Service;

@Service
public class RandomNameService {

	public String getRandomName() {
		Random name = new Random();
		String[] fname = { "도도한 ", "시크한 ", "수줍은 ", "세젤귀 ", "낭만적인 ", "청순한 ", "러블리 ", "영원히 ", "볼매 ", "상냥한 ", "사랑에 빠진 ",
				"행복한 ", "유능한 ", "꼼꼼한 ", "생각이 깊은 ", "용감한 ", "세련된 ", "우아한 ", "수다쟁이 ", "다정한 ", "친절한 ", "겸손한 ", "긍정적인 ",
				"친근한 ", "멋있는 ", "예쁜 ", "빛나는 ", "호감형 ", "똑똑한 ", "예의 바른 ", "열정적인 ", "성실한 ", "믿음직스러운 ", "명랑한 ", "순수한 ",
				"차분한 ", "기분 좋은 ", "상큼한 ", "유쾌한 ", "나긋나긋한 ", "마음이 넓은 ", "수다쟁이 ", "점잖은 ", "당찬 ", "예리한 ", "엉뚱한 ", "따뜻한 " };
		String[] lname = { "A", "B", "C", "D", "E" };
		String fullname = new StringBuilder(fname[name.nextInt(fname.length)]).append(lname[name.nextInt(lname.length)])
				.toString();

		System.out.println("randomName= " + fullname);

		return fullname;
	}

}
