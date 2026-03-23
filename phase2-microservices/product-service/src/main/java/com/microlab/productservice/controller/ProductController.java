package com.microlab.productservice.controller;

import com.microlab.productservice.model.Product;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * ProductController — handles all HTTP requests for /api/products
 */
@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

    // ── In-memory product catalog ──────────────────────────────────
    private final List<Product> products = new ArrayList<>();

    public ProductController() {
        products.add(new Product(1L, "Laptop Pro 15",       "Electronics", 89999.0,  50));
        products.add(new Product(2L, "Wireless Mouse",      "Electronics",  1499.0, 200));
        products.add(new Product(3L, "Mechanical Keyboard", "Electronics",  4999.0, 150));
        products.add(new Product(4L, "USB-C Hub 7-in-1",   "Electronics",  2999.0,  75));
        products.add(new Product(5L, "DevOps Handbook",     "Books",         799.0, 300));
        products.add(new Product(6L, "Standing Desk Mat",   "Office",        999.0, 120));
    }

    // ── GET /api/products ──────────────────────────────────────────
    // Returns all products.  Optional ?category=Electronics filter
    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts(
            @RequestParam(required = false) String category) {

        if (category != null && !category.isBlank()) {
            List<Product> filtered = new ArrayList<>();
            for (Product p : products) {
                if (p.getCategory().equalsIgnoreCase(category)) {
                    filtered.add(p);
                }
            }
            return ResponseEntity.ok(filtered);
        }
        return ResponseEntity.ok(products);
    }

    // ── GET /api/products/{id} ─────────────────────────────────────
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = products.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst();
        if (product.isPresent()) {
            return ResponseEntity.ok(product.get());
        }
        return ResponseEntity.notFound().build();
    }

    // ── POST /api/products ─────────────────────────────────────────
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        long newId = products.stream().mapToLong(Product::getId).max().orElse(0L) + 1;
        product.setId(newId);
        products.add(product);
        return ResponseEntity.status(201).body(product);
    }

    // ── DELETE /api/products/{id} ──────────────────────────────────
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        boolean removed = products.removeIf(p -> p.getId().equals(id));
        if (removed) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    // ── GET /api/products/health ───────────────────────────────────
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Product Service is UP | Total products: " + products.size());
    }
}
