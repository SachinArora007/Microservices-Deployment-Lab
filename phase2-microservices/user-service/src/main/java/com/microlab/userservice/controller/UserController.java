package com.microlab.userservice.controller;

import com.microlab.userservice.model.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * UserController — handles all HTTP requests for /api/users
 *
 * @RestController = @Controller + @ResponseBody
 *   → Automatically converts return values to JSON using Jackson
 *
 * @RequestMapping("/api/users")
 *   → All methods in this class are prefixed with /api/users
 *
 * @CrossOrigin
 *   → Allows Angular frontend (different port) to call this API
 *     Without this, the browser blocks the request (CORS policy)
 */
@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")   // In production, restrict to your domain
public class UserController {

    // ── In-memory "database" (a simple List) ──────────────────────
    // In a real app: @Autowired UserRepository from Spring Data JPA
    private final List<User> users = new ArrayList<>();

    // Pre-load some sample data when the service starts
    public UserController() {
        users.add(new User(1L, "Sachin Arora",   "sachin@microlab.com",   "ADMIN"));
        users.add(new User(2L, "Priya Sharma",   "priya@microlab.com",    "USER"));
        users.add(new User(3L, "Rahul Verma",    "rahul@microlab.com",    "USER"));
        users.add(new User(4L, "Anjali Singh",   "anjali@microlab.com",   "GUEST"));
        users.add(new User(5L, "DevOps Engineer","devops@microlab.com",   "ADMIN"));
    }

    // ── GET /api/users ─────────────────────────────────────────────
    // Returns ALL users as a JSON array
    // Example response: [{"id":1,"name":"Sachin Arora",...}, ...]
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(users);
    }

    // ── GET /api/users/{id} ────────────────────────────────────────
    // Returns ONE user by ID
    // {id} is a path variable: /api/users/1  →  id = 1
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = users.stream()
                .filter(u -> u.getId().equals(id))
                .findFirst();
        // 200 OK if found, 404 Not Found if not
        return user.map(ResponseEntity::ok)
                   .orElse(ResponseEntity.notFound().build());
    }

    // ── POST /api/users ────────────────────────────────────────────
    // Creates a new user
    // Angular sends JSON in the request body → @RequestBody converts it to User object
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        // Auto-generate ID (max existing id + 1)
        long newId = users.stream().mapToLong(User::getId).max().orElse(0L) + 1;
        user.setId(newId);
        users.add(user);
        // 201 Created is the correct HTTP status for a newly created resource
        return ResponseEntity.status(201).body(user);
    }

    // ── DELETE /api/users/{id} ─────────────────────────────────────
    // Deletes a user by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        boolean removed = users.removeIf(u -> u.getId().equals(id));
        return removed
                ? ResponseEntity.noContent().build()   // 204 No Content
                : ResponseEntity.notFound().build();    // 404 Not Found
    }

    // ── GET /api/users/health ──────────────────────────────────────
    // Quick custom health check (separate from /actuator/health)
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("User Service is UP | Total users: " + users.size());
    }
}
