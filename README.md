# 🚢 N-LOGISTIC — Enterprise Cargo & Supply Chain Management System

[![Java](https://img.shields.io/badge/Java-11-orange.svg)](https://www.oracle.com/java/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-9.0-yellow.svg)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)

An end-to-end multi-tier **Logistics, Warehouse, and Shipping Management System** designed for international maritime freight operations, automated invoicing with atomic GST calculations, shipment tracking, and container inventory management.

---

## 🌟 Key Features & 7 Functional Modules

1. **Module 1 — User & Role-Based Access Control (RBAC):**
   - 3 Distinct Personas: `ADMIN`, `SELLER` (Exporters), and `CONSUMER` (Importers).
   - Organization linking, company profile verification, failed login lockout protection, and comprehensive audit logs.
2. **Module 2 — Port, Vessel & Shipment Infrastructure:**
   - Multi-leg movement tracking, vessel schedules, route planning, port terminal management, and live journey progression.
3. **Module 3 — Container Allocation & Dynamic Pricing:**
   - Real-time container capacity reservation, dynamic freight pricing, weight/TEU validation, and automated pricing audit trails.
4. **Module 4 — Warehouse & Inventory Stock Control:**
   - Ledger entries, automated stock movements, SKU cataloging, and ABC inventory classification.
5. **Module 5 — Billing, Atomic GST Invoicing & Payments:**
   - Database-enforced 18% GST calculation, receipt generation, invoice status tracking, and printable tax receipts.
6. **Module 6 — Executive Analytics & Financial Reporting:**
   - Profit/Loss summaries, vessel turnaround time metrics, voyage profitability, and cargo movement KPIs.
7. **Module 7 — Cargo Claims & Settlement Lifecycle:**
   - Claim submission, document upload verification, incident audit history, and financial claim resolutions.

---

## 🗄️ Database Architecture

* **Database Engine**: MySQL 8.0 (`InnoDB`, `utf8mb4`)
* **Tables**: 28 normalized base tables (Foreign-Key safe schema)
* **Stored Procedures**: 134+ business logic routines
* **Functions**: 5+ deterministic calculations (including `fn_get_booking_gst_rate()`)
* **Triggers**: 73+ database consistency and audit triggers
* **Views**: 6 analytical and reporting views

---

## 🔑 Demo Accounts (For Quick Evaluation)

The system includes pre-seeded accounts for evaluation:

| Role | Email | Password | Access Rights |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@gmail.com` | `Admin@2026QA!` | Full system control, ports, vessels, analytics, audit logs |
| **Seller (Exporter)** | `seller@gmail.com` | `Seller@2026QA!` | Shipments, container bookings, warehouse stock, sales invoices |
| **Consumer (Buyer)** | `user@gmail.com` | `User@2026QA!` | Cargo tracking, incoming orders, payments, claim submissions |

*(The login page includes convenient 1-click fill buttons for these demo roles).*

---

## 🚀 Quick Start (Run Locally with Docker)

### Prerequisites
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running.

### 1-Step Execution
Clone the repository and run:
```bash
docker-compose up --build -d
```

* **Web Application**: Accessible at `http://localhost:8080/`
* **MySQL Database**: Running on `localhost:3306` (Database: `n_logistic_test_db`)

To stop the containers:
```bash
docker-compose down
```

---

## ☁️ Production / Live Cloud Deployment

### Method 1: Render / Railway (Recommended PaaS)
1. Push this project to your GitHub repository.
2. In **Render** or **Railway**, create a **New Web Service** connected to your repository.
3. Select **Docker** as the runtime environment.
4. Set up a MySQL instance (or connect to a remote MySQL 8 database) and configure environment variables:
   * `DB_HOST`: Hostname of your database server
   * `DB_PORT`: `3306`
   * `DB_NAME`: `n_logistic_test_db`
   * `DB_USER`: Your DB username
   * `DB_PASSWORD`: Your DB password
5. Import `db/01_schema.sql` and `db/02_seed.sql` into your database.
6. Deploy! Render/Railway will build the Docker container and give you a live HTTPS URL.

### Method 2: AWS EC2 (Ubuntu Linux)
1. Launch an `Ubuntu 22.04 LTS` EC2 instance (t2.micro / t3.micro).
2. Install Docker & Docker Compose:
   ```bash
   sudo apt update && sudo apt install -y docker.io docker-compose
   ```
3. Clone your GitHub repository and start the containers:
   ```bash
   cd Nlogistic
   sudo docker-compose up -d --build
   ```
4. Access `http://<EC2-PUBLIC-IP>:8080/`.

---

## 🛠️ Tech Stack & Engineering Practices
* **Language & Framework**: Java 11, Java EE / Servlet 4.0.1, JSP, JSTL
* **Build Tool**: Apache Maven (`war` packaging)
* **Application Server**: Apache Tomcat 9.0
* **Database**: MySQL 8.0
* **DevOps**: Docker Multi-stage Builds, Docker Compose, 12-Factor App Environment Configuration
