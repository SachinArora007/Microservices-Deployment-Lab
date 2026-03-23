package com.microlab.userservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main entry point for the User Service.
 *
 * @SpringBootApplication combines:
 *   - @Configuration      : marks this as a config class
 *   - @EnableAutoConfiguration : auto-configures Spring (web server, Jackson, etc.)
 *   - @ComponentScan      : finds all @RestController, @Service, @Repository in this package
 */
@SpringBootApplication
public class UserServiceApplication {

    public static void main(String[] args) {
        // SpringApplication.run() boots the embedded Tomcat server on port 8081
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
