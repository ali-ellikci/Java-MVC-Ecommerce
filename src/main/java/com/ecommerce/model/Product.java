package com.ecommerce.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Product {

    private int id;
    private int categoryId;
    private String categoryName;   // JOIN sonucu — veritabanında yok
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private String imageUrl;
    private boolean active;
    private LocalDateTime createdAt;

    public Product() {}

    // Getters & Setters
    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public int getCategoryId()                  { return categoryId; }
    public void setCategoryId(int categoryId)   { this.categoryId = categoryId; }

    public String getCategoryName()             { return categoryName; }
    public void setCategoryName(String n)       { this.categoryName = n; }

    public String getName()                     { return name; }
    public void setName(String name)            { this.name = name; }

    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }

    public BigDecimal getPrice()                { return price; }
    public void setPrice(BigDecimal price)      { this.price = price; }

    public int getStock()                       { return stock; }
    public void setStock(int stock)             { this.stock = stock; }

    public String getImageUrl()                 { return imageUrl; }
    public void setImageUrl(String imageUrl)    { this.imageUrl = imageUrl; }

    public boolean isActive()                   { return active; }
    public void setActive(boolean active)       { this.active = active; }

    public LocalDateTime getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)   { this.createdAt = createdAt; }

    /** Ürün stokta mı? */
    public boolean isInStock() { return stock > 0; }
}
