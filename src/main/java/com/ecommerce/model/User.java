package com.ecommerce.model;

import java.time.LocalDateTime;

public class User {

    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role;
    private LocalDateTime createdAt;

    public User() {}

    public User(String fullName, String email, String password,
                String phone, String address, String role) {
        this.fullName = fullName;
        this.email    = email;
        this.password = password;
        this.phone    = phone;
        this.address  = address;
        this.role     = role;
    }

    // Getters & Setters
    public int getId()                       { return id; }
    public void setId(int id)                { this.id = id; }

    public String getFullName()              { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }

    public String getPassword()              { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone()                 { return phone; }
    public void setPhone(String phone)       { this.phone = phone; }

    public String getAddress()               { return address; }
    public void setAddress(String address)   { this.address = address; }

    public String getRole()                  { return role; }
    public void setRole(String role)         { this.role = role; }

    public LocalDateTime getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)    { this.createdAt = createdAt; }

    public boolean isAdmin()                 { return "admin".equals(this.role); }
}
