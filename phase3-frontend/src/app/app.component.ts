import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from './services/api.service';
import { User } from './models/user.model';
import { Product } from './models/product.model';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="app-container">
      <header>
        <h1>Microservices Lab Dashboard</h1>
        <p class="subtitle">Real-time status of your Java Spring Boot microservices</p>
      </header>

      <!-- ── SERVICE STATUS ── -->
      <div class="grid" style="grid-template-columns: 1fr 1fr; margin-bottom: 2rem;">
        <div class="glass-card status-card">
          <div class="section-title">
            <span class="status-dot" [class.online]="userHealth?.includes('UP')"></span>
            <h3>User Service (8081)</h3>
          </div>
          <p>{{ userHealth || 'Connecting...' }}</p>
        </div>

        <div class="glass-card status-card">
          <div class="section-title">
            <span class="status-dot" [class.online]="productHealth?.includes('UP')"></span>
            <h3>Product Service (8082)</h3>
          </div>
          <p>{{ productHealth || 'Connecting...' }}</p>
        </div>
      </div>

      <!-- ── USER SECTION ── -->
      <section class="glass-card">
        <h2 class="section-title">👥 User Management</h2>
        <table class="data-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>Role</th>
            </tr>
          </thead>
          <tbody>
            <tr *ngFor="let user of users">
              <td>{{ user.id }}</td>
              <td><strong>{{ user.name }}</strong></td>
              <td>{{ user.email }}</td>
              <td><span class="badge" [ngClass]="user.role === 'ADMIN' ? 'badge-admin' : 'badge-user'">{{ user.role }}</span></td>
            </tr>
          </tbody>
        </table>
      </section>

      <!-- ── PRODUCT SECTION ── -->
      <section>
        <h2 class="section-title">📦 Product Catalog</h2>
        <div class="grid">
          <div *ngFor="let product of products" class="glass-card product-card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
              <span class="badge badge-user">{{ product.category }}</span>
              <span style="font-weight: 700; color: var(--primary);">₹{{ product.price | number }}</span>
            </div>
            <h3 style="margin-bottom: 0.5rem;">{{ product.name }}</h3>
            <div style="display: flex; justify-content: space-between; font-size: 0.875rem; color: var(--text-secondary);">
              <span>Stock: <strong>{{ product.stock }}</strong></span>
              <span>ID: #{{ product.id }}</span>
            </div>
            <button class="btn btn-primary" style="width: 100%; margin-top: 1.5rem; font-size: 0.875rem;">View Details</button>
          </div>
        </div>
      </section>

      <footer style="text-align: center; margin-top: 4rem; padding-bottom: 2rem; color: var(--text-secondary); font-size: 0.875rem;">
        <p>© 2026 Microservices Deployment Lab · No-Docker / No-K8s Architecture</p>
      </footer>
    </div>

    <style>
      .status-dot { width: 10px; height: 10px; border-radius: 50%; background: #ef4444; box-shadow: 0 0 10px #ef4444; }
      .status-dot.online { background: #10b981; box-shadow: 0 0 10px #10b981; }
      .status-card h3 { margin: 0; }
      .product-card { padding: 1.5rem; }
    </style>
  `
})
export class AppComponent implements OnInit {
  users: User[] = [];
  products: Product[] = [];
  userHealth: string = '';
  productHealth: string = '';

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.loadData();
    // Refresh health every 10 seconds
    setInterval(() => this.checkHealth(), 10000);
  }

  loadData() {
    this.api.getUsers().subscribe(data => this.users = data);
    this.api.getProducts().subscribe(data => this.products = data);
    this.checkHealth();
  }

  checkHealth() {
    this.api.getUserHealth().subscribe({
      next: h => this.userHealth = h,
      error: () => this.userHealth = 'ERROR: Service Unreachable'
    });
    this.api.getProductHealth().subscribe({
      next: h => this.productHealth = h,
      error: () => this.productHealth = 'ERROR: Service Unreachable'
    });
  }
}
