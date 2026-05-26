package com.ecommerce.model;

import java.math.BigDecimal;

public class CartItem {

    private int productId;
    private String productName;
    private BigDecimal price;
    private int quantity;
    private String imageUrl;
    private int maxStock; // stok kontrolü için

    public CartItem() {}

    public CartItem(int productId, String productName,
                    BigDecimal price, int quantity,
                    String imageUrl, int maxStock) {
        this.productId   = productId;
        this.productName = productName;
        this.price       = price;
        this.quantity    = quantity;
        this.imageUrl    = imageUrl;
        this.maxStock    = maxStock;
    }

    /** Kalem toplam tutarı */
    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    // Getters & Setters
    public int getProductId()                       { return productId; }
    public void setProductId(int productId)         { this.productId = productId; }

    public String getProductName()                  { return productName; }
    public void setProductName(String name)         { this.productName = name; }

    public BigDecimal getPrice()                    { return price; }
    public void setPrice(BigDecimal price)          { this.price = price; }

    public int getQuantity()                        { return quantity; }
    public void setQuantity(int quantity)           { this.quantity = quantity; }

    public String getImageUrl()                     { return imageUrl; }
    public void setImageUrl(String imageUrl)        { this.imageUrl = imageUrl; }

    public int getMaxStock()                        { return maxStock; }
    public void setMaxStock(int maxStock)           { this.maxStock = maxStock; }
}
