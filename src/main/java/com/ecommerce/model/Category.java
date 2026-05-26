package com.ecommerce.model;

public class Category {

    private int id;
    private String name;
    private String description;
    private boolean active;

    public Category() {}

    public Category(String name, String description, boolean active) {
        this.name        = name;
        this.description = description;
        this.active      = active;
    }

    // Getters & Setters
    public int getId()                         { return id; }
    public void setId(int id)                  { this.id = id; }

    public String getName()                    { return name; }
    public void setName(String name)           { this.name = name; }

    public String getDescription()             { return description; }
    public void setDescription(String desc)    { this.description = desc; }

    public boolean isActive()                  { return active; }
    public void setActive(boolean active)      { this.active = active; }
}
