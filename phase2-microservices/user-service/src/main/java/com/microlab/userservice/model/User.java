package com.microlab.userservice.model;

/**
 * User model — represents a user in our system.
 *
 * In a real app this would be a JPA @Entity backed by a database.
 * For this lab we use plain Java objects (POJOs) stored in memory.
 *
 * Why no database? → We want to focus on DevOps concepts, not JPA setup.
 * The frontend will still get real JSON from these endpoints.
 */
public class User {

    private Long id;
    private String name;
    private String email;
    private String role;   // e.g. "ADMIN", "USER", "GUEST"

    // ── Constructors ───────────────────────────────────────────────

    public User() {}

    public User(Long id, String name, String email, String role) {
        this.id    = id;
        this.name  = name;
        this.email = email;
        this.role  = role;
    }

    // ── Getters and Setters ────────────────────────────────────────
    // Spring's Jackson library uses these to convert objects → JSON

    public Long getId()             { return id; }
    public void setId(Long id)      { this.id = id; }

    public String getName()              { return name; }
    public void   setName(String name)   { this.name = name; }

    public String getEmail()              { return email; }
    public void   setEmail(String email)  { this.email = email; }

    public String getRole()              { return role; }
    public void   setRole(String role)   { this.role = role; }
}
