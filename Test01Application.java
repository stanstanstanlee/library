package com.kim.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
//전체 프로젝트를 돌리는 실행의 주체가 Application.java
@EnableScheduling
@SpringBootApplication
public class Test01Application {

	public static void main(String[] args) {
		SpringApplication.run(Test01Application.class, args);
	}

}
