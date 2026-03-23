package com.microlab.userservice;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Smoke test — verifies the Spring context loads without errors.
 * Run with: mvn test
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserServiceApplicationTests {

    @Test
    void contextLoads() {
        // If the Spring context fails to start, this test will fail.
        // A passing test means all beans were created successfully.
    }
}
