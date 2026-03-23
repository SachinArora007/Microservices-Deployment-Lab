import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../models/user.model';
import { Product } from '../models/product.model';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  // During Phase 3, we connect directly to the service ports.
  // In Phase 4, we will update these to use the Nginx proxy on Port 80.
  private userApiUrl = 'http://localhost:8081/api/users';
  private productApiUrl = 'http://localhost:8082/api/products';

  constructor(private http: HttpClient) { }

  // ── User Endpoints ──────────────────────────────────────────
  getUsers(): Observable<User[]> {
    return this.http.get<User[]>(this.userApiUrl);
  }

  getUserById(id: number): Observable<User> {
    return this.http.get<User>(`${this.userApiUrl}/${id}`);
  }

  // ── Product Endpoints ───────────────────────────────────────
  getProducts(category?: string): Observable<Product[]> {
    let url = this.productApiUrl;
    if (category) {
      url += `?category=${category}`;
    }
    return this.http.get<Product[]>(url);
  }

  getProductById(id: number): Observable<Product> {
    return this.http.get<Product>(`${this.productApiUrl}/${id}`);
  }

  // ── Health Checks ───────────────────────────────────────────
  getUserHealth(): Observable<string> {
    return this.http.get(`${this.userApiUrl}/health`, { responseType: 'text' });
  }

  getProductHealth(): Observable<string> {
    return this.http.get(`${this.productApiUrl}/health`, { responseType: 'text' });
  }
}
