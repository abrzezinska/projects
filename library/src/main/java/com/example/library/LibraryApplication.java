package com.example.library;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories
public class LibraryApplication {

	public static void main(String[] args) {
//		UserEntity user=new UserEntity();
//		Serwis serwis=new Serwis();
//		serwis.register(user);
		SpringApplication.run(LibraryApplication.class, args);
	}

}
