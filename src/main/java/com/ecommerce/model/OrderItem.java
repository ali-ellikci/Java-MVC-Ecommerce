package com.ecommerce.model;

import java.math.BigDecimal;

public class OrderItem {

    private int id;
    private int orderId;
    private int productId;
    private String productName;  // JOIN sonucu
    private String imageUrl;     // JOIN sonucu
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;

    public OrderItem() {}

    // Getters & Setters
    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getOrderId()                         { return orderId; }
    public void setOrderId(int orderId)             { this.orderId = orderId; }

    public int getProductId()                       { return productId; }
    public void setProductId(int productId)         { this.productId = productId; }

    public String getProductName()                  { return productName; }
    public void setProductName(String name)         { this.productName = name; }

    public String getImageUrl()                     { return imageUrl; }
    public void setImageUrl(String imageUrl)        { this.imageUrl = imageUrl; }

    public int getQuantity()                        { return quantity; }
    public void setQuantity(int quantity)           { this.quantity = quantity; }

    public BigDecimal getUnitPrice()                { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice)  { this.unitPrice = unitPrice; }

    public BigDecimal getSubtotal()                 { return subtotal; }
    public void setSubtotal(BigDecimal subtotal)    { this.subtotal = subtotal; }
}
