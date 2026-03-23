package com.microlab.productservice.model;

/**
 * Product model — represents a product in our catalog.
 * Stored in-memory (no database) to keep the lab focused on DevOps.
 */
public class Product {

    private Long   id;
    private String name;
    private String category;
    private Double price;
    private Integer stock;

    // ── Constructors ───────────────────────────────────────────────

    public Product() {}

    public Product(Long id, String name, String category, Double price, Integer stock) {
        this.id       = id;
        this.name     = name;
        this.category = category;
        this.price    = price;
        this.stock    = stock;
    }

    // ── Getters and Setters ────────────────────────────────────────

    public Long    getId()                   { return id; }
    public void    setId(Long id)            { this.id = id; }

    public String  getName()                 { return name; }
    public void    setName(String name)      { this.name = name; }

    public String  getCategory()                    { return category; }
    public void    setCategory(String category)     { this.category = category; }

    public Double  getPrice()                { return price; }
    public void    setPrice(Double price)    { this.price = price; }

    public Integer getStock()                { return stock; }
    public void    setStock(Integer stock)   { this.stock = stock; }
}
