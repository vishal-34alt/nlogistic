
SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;
CREATE DATABASE n_logistic_test_db;
USE n_logistic_test_db;

-- ============================================================================
-- SECTION 01 — ALL 28 TABLES (FOREIGN-KEY-SAFE CREATION ORDER)
-- ============================================================================
-- SRS tables retain their original names, columns, datatypes, keys and constraints.
-- Tables are kept in FK-safe order; their module labels make them easy to locate.

-- ----------------------------------------------------------------------------
-- TABLE: companies | MODULE 1 — User and Access Management
-- Purpose: Consumer/Seller organizations with validated country and company identifiers.
-- ----------------------------------------------------------------------------
CREATE TABLE companies (
    company_id    INT AUTO_INCREMENT PRIMARY KEY,
    company_name  VARCHAR(150) NOT NULL,
    company_type  ENUM('CONSUMER','SELLER') NOT NULL,
    gst_number    VARCHAR(20) UNIQUE,
    iec_code      VARCHAR(15),
    address       TEXT,
    city          VARCHAR(60),
    country       VARCHAR(60)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: users | MODULE 1 — User and Access Management
-- Purpose: Role-based accounts, credentials, login statistics and account state.
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    user_id          INT AUTO_INCREMENT PRIMARY KEY,
    role             ENUM('ADMIN','CONSUMER','SELLER') NOT NULL,
    company_id       INT NULL,
    full_name        VARCHAR(100) NOT NULL,
    email            VARCHAR(120) NOT NULL UNIQUE,
    password_hash    VARCHAR(255) NOT NULL,
    phone            VARCHAR(20),
    status           ENUM('ACTIVE','INACTIVE','LOCKED') DEFAULT 'ACTIVE',
    failed_attempts  INT DEFAULT 0,
    last_login       DATETIME,
    CONSTRAINT fk_users_company
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: customers | MODULE 1 — User and Access Management
-- Purpose: Buyer profile linked to one Consumer user and its company.
-- ----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL UNIQUE,
    company_id       INT NOT NULL,
    contact_person   VARCHAR(100),
    billing_address  TEXT,
    credit_limit     DECIMAL(12,2) DEFAULT 0,
    CONSTRAINT fk_customers_user
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_customers_company
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: audit_log | MODULE 1 — User and Access Management
-- Purpose: Preserve user actions, changed values and source IP.
-- Note: No creation-time column; date-based audit filtering is unavailable.
-- ----------------------------------------------------------------------------
CREATE TABLE audit_log (
    log_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT,
    action        VARCHAR(100) NOT NULL,
    table_name    VARCHAR(60),
    record_id     BIGINT,
    old_value     JSON,
    new_value     JSON,
    ip_address    VARCHAR(45),
    CONSTRAINT fk_audit_user
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: ports | MODULE 2 — Shipment and Container Movement Tracking
-- Purpose: Origin and destination reference ports with optional GPS coordinates.
-- ----------------------------------------------------------------------------
CREATE TABLE ports (
    port_id     INT AUTO_INCREMENT PRIMARY KEY,
    port_code   VARCHAR(10) NOT NULL UNIQUE,
    port_name   VARCHAR(100) NOT NULL,
    city        VARCHAR(60),
    country     VARCHAR(60),
    latitude    DECIMAL(9,6),
    longitude   DECIMAL(9,6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: vessels | MODULE 2 — Shipment and Container Movement Tracking
-- Purpose: Admin-managed ships, IMO identifiers and maintenance status.
-- ----------------------------------------------------------------------------
CREATE TABLE vessels (
    vessel_id         INT AUTO_INCREMENT PRIMARY KEY,
    vessel_name       VARCHAR(100) NOT NULL,
    imo_number        VARCHAR(15) UNIQUE,
    owner_company_id  INT,
    capacity_teu      INT,
    status            ENUM('ACTIVE','MAINTENANCE') NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_vessels_owner
    FOREIGN KEY (owner_company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: containers | MODULE 3 — Container Allocation, Booking and Pricing
-- Purpose: Seller-owned container capacity, location and allocation state.
-- ----------------------------------------------------------------------------
CREATE TABLE containers (
    container_id      INT AUTO_INCREMENT PRIMARY KEY,
    container_number  VARCHAR(15) NOT NULL UNIQUE,
    seller_id         INT NOT NULL,
    container_type    ENUM('DRY','REEFER','OPEN_TOP','TANK') NOT NULL,
    size_ft           TINYINT,
    max_weight_kg     DECIMAL(10,2) NOT NULL,
    max_volume_cbm    DECIMAL(8,2) NOT NULL,
    current_port_id   INT,
    status            ENUM('AVAILABLE','ALLOCATED','IN_TRANSIT','MAINTENANCE')
    DEFAULT 'AVAILABLE',
    CONSTRAINT fk_containers_seller
    FOREIGN KEY (seller_id) REFERENCES companies(company_id),
    CONSTRAINT fk_containers_port
    FOREIGN KEY (current_port_id) REFERENCES ports(port_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: shipment | MODULE 2 — Shipment and Container Movement Tracking
-- Purpose: One confirmed booking with buyer, Seller, route, cargo and status.
-- ----------------------------------------------------------------------------
CREATE TABLE shipment (
    shipment_id        INT AUTO_INCREMENT PRIMARY KEY,
    shipment_no        VARCHAR(20) NOT NULL UNIQUE,
    consumer_id        INT NOT NULL,
    seller_id          INT NOT NULL,
    container_id       INT NOT NULL,
    vessel_id          INT,
    origin_port_id     INT NOT NULL,
    dest_port_id       INT NOT NULL,
    cargo_description  VARCHAR(255),
    cargo_weight_kg    DECIMAL(10,2) NOT NULL,
    cargo_volume_cbm   DECIMAL(8,2) NOT NULL,
    quoted_price       DECIMAL(12,2) NOT NULL,
    status
    ENUM('BOOKED','LOADED','DEPARTED','IN_TRANSIT','ARRIVED','CUSTOMS_CLEARED','DELIVERED','CANCELLED') DEFAULT 'BOOKED',
    etd                DATE,
    eta                DATE,
    actual_arrival     DATE,
    CONSTRAINT fk_shipment_consumer
    FOREIGN KEY (consumer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_shipment_seller
    FOREIGN KEY (seller_id) REFERENCES companies(company_id),
    CONSTRAINT fk_shipment_container
    FOREIGN KEY (container_id) REFERENCES containers(container_id),
    CONSTRAINT fk_shipment_vessel
    FOREIGN KEY (vessel_id) REFERENCES vessels(vessel_id),
    CONSTRAINT fk_shipment_origin
    FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
    CONSTRAINT fk_shipment_dest
    FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: container_movements | MODULE 2 — Shipment and Container Movement Tracking
-- Purpose: Chronological immutable status events for shipment tracking.
-- ----------------------------------------------------------------------------
CREATE TABLE container_movements (
    movement_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    shipment_id    INT NOT NULL,
    container_id   INT NOT NULL,
    status
    ENUM('BOOKED','LOADED','DEPARTED','IN_TRANSIT','ARRIVED','CUSTOMS_CLEARED','DELIVERED','CANCELLED') NOT NULL,
    port_id        INT,
    location_text  VARCHAR(150),
    event_time     DATETIME NOT NULL,
    remarks        VARCHAR(255),
    updated_by     INT,
    CONSTRAINT fk_movements_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_movements_container
    FOREIGN KEY (container_id) REFERENCES containers(container_id),
    CONSTRAINT fk_movements_port
    FOREIGN KEY (port_id) REFERENCES ports(port_id),
    CONSTRAINT fk_movements_user
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: products | MODULE 4 — Products, Stock and Inventory Management
-- Purpose: Seller products, unit weight and price; CBM is supplied at booking.
-- ----------------------------------------------------------------------------
CREATE TABLE products (
    product_id        INT AUTO_INCREMENT PRIMARY KEY,
    sku               VARCHAR(40) NOT NULL UNIQUE,
    product_name      VARCHAR(120) NOT NULL,
    category          VARCHAR(60),
    hs_code           VARCHAR(12),
    unit              VARCHAR(10),
    unit_weight_kg    DECIMAL(8,3),
    unit_price        DECIMAL(12,2) NOT NULL,
    owner_company_id  INT NOT NULL,
    CONSTRAINT fk_products_owner
    FOREIGN KEY (owner_company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: shipment_items | MODULE 2 — Shipment and Container Movement Tracking
-- Purpose: Products and quantities reserved against each shipment.
-- ----------------------------------------------------------------------------
CREATE TABLE shipment_items (
    item_id      INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id  INT NOT NULL,
    product_id   INT NOT NULL,
    quantity     INT NOT NULL,
    unit_price   DECIMAL(12,2) NOT NULL,
    weight_kg    DECIMAL(10,2),
    volume_cbm   DECIMAL(8,2),
    amount       DECIMAL(14,2) NOT NULL,
    CONSTRAINT chk_shipment_items_qty CHECK (quantity > 0),
    CONSTRAINT fk_items_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: stock | MODULE 4 — Products, Stock and Inventory Management
-- Purpose: General and shipment-linked stock with damaged quantities.
-- ----------------------------------------------------------------------------
CREATE TABLE stock (
    stock_id      INT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT NOT NULL,
    shipment_id   INT NULL,
    container_id  INT,
    quantity      INT NOT NULL,
    damaged_qty   INT DEFAULT 0,
    last_updated  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_stock_qty CHECK (quantity >= 0),
    CONSTRAINT fk_stock_product
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_stock_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_stock_container
    FOREIGN KEY (container_id) REFERENCES containers(container_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: inventory_ledger | MODULE 4 — Products, Stock and Inventory Management
-- Purpose: Append-only stock movements and resulting balances.
-- ----------------------------------------------------------------------------
CREATE TABLE inventory_ledger (
    ledger_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    stock_id        INT NOT NULL,
    product_id      INT NOT NULL,
    txn_type        ENUM('IN','OUT','DAMAGE','ADJUST','CLAIM_LOSS') NOT NULL,
    quantity        INT NOT NULL,
    balance_after   INT NOT NULL,
    reference_type  VARCHAR(30),
    reference_id    BIGINT,
    txn_time        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ledger_stock
    FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
    CONSTRAINT fk_ledger_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: sales_transactions | MODULE 4 — Products, Stock and Inventory Management
-- Purpose: Sales rows used for stock/sales analytics and profitability.
-- ----------------------------------------------------------------------------
CREATE TABLE sales_transactions (
    sale_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT NOT NULL,
    customer_id   INT NOT NULL,
    shipment_id   INT,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(12,2) NOT NULL,
    total_amount  DECIMAL(14,2) NOT NULL,
    sale_date     DATE NOT NULL,
    CONSTRAINT fk_sales_product
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_sales_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_sales_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: pricing_rules | MODULE 3 — Container Allocation, Booking and Pricing
-- Purpose: Seller route/type price formula, validity dates and multipliers.
-- ----------------------------------------------------------------------------
CREATE TABLE pricing_rules (
    rule_id            INT AUTO_INCREMENT PRIMARY KEY,
    seller_id          INT NOT NULL,
    origin_port_id     INT NOT NULL,
    dest_port_id       INT NOT NULL,
    container_type     ENUM('DRY','REEFER','OPEN_TOP','TANK') NOT NULL,
    base_rate          DECIMAL(12,2) NOT NULL,
    rate_per_kg        DECIMAL(8,4) DEFAULT 0,
    rate_per_cbm       DECIMAL(8,2) DEFAULT 0,
    season_multiplier  DECIMAL(4,2) DEFAULT 1.00,
    demand_multiplier  DECIMAL(4,2) DEFAULT 1.00,
    valid_from         DATE,
    valid_to           DATE,
    is_active          BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_pricing_seller
    FOREIGN KEY (seller_id) REFERENCES companies(company_id),
    CONSTRAINT fk_pricing_origin
    FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
    CONSTRAINT fk_pricing_dest
    FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: pricing_audit | MODULE 3 — Container Allocation, Booking and Pricing
-- Purpose: History of changes to base rates and combined price multipliers.
-- ----------------------------------------------------------------------------
CREATE TABLE pricing_audit (
    audit_id        INT AUTO_INCREMENT PRIMARY KEY,
    rule_id         INT NOT NULL,
    old_rate        DECIMAL(12,2),
    new_rate        DECIMAL(12,2),
    old_multiplier  DECIMAL(4,2),
    new_multiplier  DECIMAL(4,2),
    changed_by      INT,
    changed_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pricing_audit_rule
    FOREIGN KEY (rule_id) REFERENCES pricing_rules(rule_id),
    CONSTRAINT fk_pricing_audit_user
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: demand_forecast | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Manual demand predictions and suggested (not automatic) multipliers.
-- ----------------------------------------------------------------------------
CREATE TABLE demand_forecast (
    forecast_id           INT AUTO_INCREMENT PRIMARY KEY,
    origin_port_id        INT NOT NULL,
    dest_port_id          INT NOT NULL,
    container_type        ENUM('DRY','REEFER','OPEN_TOP','TANK'),
    forecast_month        DATE NOT NULL,
    predicted_bookings    INT,
    confidence_pct        DECIMAL(5,2),
    suggested_multiplier  DECIMAL(4,2),
    CONSTRAINT fk_forecast_origin
    FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
    CONSTRAINT fk_forecast_dest
    FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: billing_invoices | MODULE 5 — Billing, Invoices and Payments
-- Purpose: Invoices created for shipments and synchronized with payments.
-- ----------------------------------------------------------------------------
CREATE TABLE billing_invoices (
    invoice_id    INT AUTO_INCREMENT PRIMARY KEY,
    invoice_no    VARCHAR(20) NOT NULL UNIQUE,
    shipment_id   INT NOT NULL UNIQUE,
    consumer_id   INT NOT NULL,
    seller_id     INT NOT NULL,
    sub_total     DECIMAL(12,2) NOT NULL,
    tax_amount    DECIMAL(12,2) DEFAULT 0,
    total_amount  DECIMAL(12,2) NOT NULL,
    paid_amount   DECIMAL(12,2) DEFAULT 0,
    status        ENUM('UNPAID','PARTIAL','PAID') DEFAULT 'UNPAID',
    issue_date    DATE NOT NULL,
    due_date      DATE NOT NULL,
    CONSTRAINT fk_invoices_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_invoices_consumer
    FOREIGN KEY (consumer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_invoices_seller
    FOREIGN KEY (seller_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: invoice_line_items | MODULE 5 — Billing, Invoices and Payments
-- Purpose: Detailed freight, handling, customs, tax, insurance charges.
-- ----------------------------------------------------------------------------
CREATE TABLE invoice_line_items (
    item_id      INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id   INT NOT NULL,
    item_type    ENUM('FREIGHT','HANDLING','CUSTOMS','TAX','INSURANCE','OTHER')
    NOT NULL,
    description  VARCHAR(150),
    quantity     DECIMAL(8,2) DEFAULT 1,
    unit_price   DECIMAL(12,2) NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_line_items_invoice
    FOREIGN KEY (invoice_id) REFERENCES billing_invoices(invoice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: payments | MODULE 5 — Billing, Invoices and Payments
-- Purpose: Recorded full/partial payments; gateway processing is out of scope.
-- ----------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id    INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id    INT NOT NULL,
    amount        DECIMAL(12,2) NOT NULL,
    payment_mode  ENUM('BANK','UPI','CHEQUE','CASH'),
    reference_no  VARCHAR(50),
    payment_date  DATE NOT NULL,
    recorded_by   INT,
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT fk_payments_invoice
    FOREIGN KEY (invoice_id) REFERENCES billing_invoices(invoice_id),
    CONSTRAINT fk_payments_user
    FOREIGN KEY (recorded_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: claims | MODULE 7 — Claims and Evidence Management
-- Purpose: Loss, damage, delay and shortage requests with Seller decisions.
-- ----------------------------------------------------------------------------
CREATE TABLE claims (
    claim_id         INT AUTO_INCREMENT PRIMARY KEY,
    claim_no         VARCHAR(20) NOT NULL UNIQUE,
    shipment_id      INT NOT NULL,
    container_id     INT,
    consumer_id      INT NOT NULL,
    claim_type       ENUM('LOSS','DAMAGE','DELAY','SHORTAGE') NOT NULL,
    description      TEXT NOT NULL,
    claimed_amount   DECIMAL(12,2) NOT NULL,
    approved_amount  DECIMAL(12,2) DEFAULT 0,
    status
    ENUM('SUBMITTED','UNDER_REVIEW','APPROVED','PARTIALLY_APPROVED','REJECTED','SETTLED') DEFAULT 'SUBMITTED',
    seller_remarks   VARCHAR(255),
    raised_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    settled_at       DATETIME,
    CONSTRAINT fk_claims_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_claims_container
    FOREIGN KEY (container_id) REFERENCES containers(container_id),
    CONSTRAINT fk_claims_consumer
    FOREIGN KEY (consumer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: claim_documents | MODULE 7 — Claims and Evidence Management
-- Purpose: Evidence metadata and server file paths for claim documents.
-- ----------------------------------------------------------------------------
CREATE TABLE claim_documents (
    cdoc_id      INT AUTO_INCREMENT PRIMARY KEY,
    claim_id     INT NOT NULL,
    file_name    VARCHAR(150) NOT NULL,
    file_path    VARCHAR(255) NOT NULL,
    file_type    VARCHAR(10),
    uploaded_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_claim_docs_claim
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: claim_status_history | MODULE 7 — Claims and Evidence Management
-- Purpose: Append-only claim status transitions and two-party comments.
-- ----------------------------------------------------------------------------
CREATE TABLE claim_status_history (
    history_id  BIGINT AUTO_INCREMENT PRIMARY KEY,
    claim_id    INT NOT NULL,
    old_status  VARCHAR(20),
    new_status  VARCHAR(20),
    changed_by  INT,
    remarks     VARCHAR(255),
    changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_claim_hist_claim
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id),
    CONSTRAINT fk_claim_hist_user
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: profit_loss | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Revenue, expense, claim loss and generated net profit by shipment/month.
-- ----------------------------------------------------------------------------
CREATE TABLE profit_loss (
    pl_id          INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id    INT,
    seller_id      INT NOT NULL,
    period_month   DATE NOT NULL,
    revenue        DECIMAL(14,2) DEFAULT 0,
    freight_cost   DECIMAL(14,2) DEFAULT 0,
    port_cost      DECIMAL(14,2) DEFAULT 0,
    handling_cost  DECIMAL(14,2) DEFAULT 0,
    claim_loss     DECIMAL(14,2) DEFAULT 0,
    net_profit     DECIMAL(14,2) GENERATED ALWAYS AS
    (revenue - freight_cost - port_cost - handling_cost -
    claim_loss) STORED,
    CONSTRAINT fk_pl_shipment
    FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id),
    CONSTRAINT fk_pl_seller
    FOREIGN KEY (seller_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: abc_classification_result | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Cached A/B/C product Pareto contributions.
-- ----------------------------------------------------------------------------
CREATE TABLE abc_classification_result (
    result_id       INT AUTO_INCREMENT PRIMARY KEY,
    product_id      INT NOT NULL,
    annual_value    DECIMAL(14,2),
    cumulative_pct  DECIMAL(5,2),
    abc_class       CHAR(1),
    calculated_on   DATE,
    CONSTRAINT fk_abc_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: inventory_turnover_result | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Cached turnover ratio = cost of goods sold / average stock.
-- ----------------------------------------------------------------------------
CREATE TABLE inventory_turnover_result (
    result_id       INT AUTO_INCREMENT PRIMARY KEY,
    product_id      INT NOT NULL,
    period_start    DATE,
    period_end      DATE,
    cogs            DECIMAL(14,2),
    avg_inventory   DECIMAL(14,2),
    turnover_ratio  DECIMAL(8,2),
    CONSTRAINT fk_turnover_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: profitability_result | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Cached product revenue, allocated cost and margin.
-- ----------------------------------------------------------------------------
CREATE TABLE profitability_result (
    result_id     INT AUTO_INCREMENT PRIMARY KEY,
    product_id    INT NOT NULL,
    period_month  DATE,
    revenue       DECIMAL(14,2),
    cost          DECIMAL(14,2),
    margin_pct    DECIMAL(6,2),
    CONSTRAINT fk_profitability_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- TABLE: sales_trend_result | MODULE 6 — Analytics, Forecasting and Profit & Loss
-- Purpose: Cached monthly route sales, quantity and growth.
-- ----------------------------------------------------------------------------
CREATE TABLE sales_trend_result (
    result_id       INT AUTO_INCREMENT PRIMARY KEY,
    period_month    DATE NOT NULL,
    origin_port_id  INT,
    dest_port_id    INT,
    total_sales     DECIMAL(14,2),
    total_qty       INT,
    growth_pct      DECIMAL(6,2),
    CONSTRAINT fk_trend_origin
    FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
    CONSTRAINT fk_trend_dest
    FOREIGN KEY (dest_port_id) REFERENCES ports(port_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- BOOKING GST CONFIGURATION: one DB-owned setting, no schema/table changes.
-- For a new rate, replace this function in the DATABASE; Java reads the rate
-- returned by sp_process_booking and does not contain an independent rate.
-- This is a project-wide demonstration rate, not HSN/export-specific tax advice.
-- ============================================================================
DELIMITER $$
CREATE FUNCTION fn_get_booking_gst_rate()
RETURNS DECIMAL(5,2)
DETERMINISTIC NO SQL
BEGIN
    RETURN 18.00;
END$$
DELIMITER ;

-- ============================================================================
-- SECTION 02 — STORED PROCEDURES
-- ============================================================================
DELIMITER $$

-- ============================================================================
-- MODULE 1 — User and Access Management — 33 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Shared role and reference validation
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_assert_country_name
-- Group: Shared role and reference validation
-- Operation: Shared validation helper
-- Purpose: Check optional country against the embedded ISO 3166 name/alias list.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_assert_country_name(IN p_country VARCHAR(60))
BEGIN
    IF p_country IS NOT NULL THEN
        IF TRIM(p_country) = '' OR TRIM(p_country) NOT IN (
        'Afghanistan', 'Albania', 'Algeria', 'American Samoa',
        'Andorra', 'Angola', 'Anguilla', 'Antarctica',
        'Antigua and Barbuda', 'Argentina', 'Armenia', 'Aruba',
        'Australia', 'Austria', 'Azerbaijan', 'Bahamas',
        'Bahrain', 'Bangladesh', 'Barbados', 'Belarus',
        'Belgium', 'Belize', 'Benin', 'Bermuda',
        'Bhutan', 'Bolivia', 'Bolivia, Plurinational State of', 'Bonaire, Sint Eustatius and Saba',
        'Bosnia and Herzegovina', 'Botswana', 'Bouvet Island', 'Brazil',
        'British Indian Ocean Territory', 'Brunei', 'Brunei Darussalam', 'Bulgaria',
        'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cambodia',
        'Cameroon', 'Canada', 'Cape Verde', 'Cayman Islands',
        'Central African Republic', 'Chad', 'Chile', 'China',
        'Christmas Island', 'Cocos (Keeling) Islands', 'Colombia', 'Comoros',
        'Congo', 'Congo, The Democratic Republic of the', 'Cook Islands', 'Costa Rica',
        'Croatia', 'Cuba', 'Curaçao', 'Cyprus',
        'Czech Republic', 'Czechia', 'Côte d''Ivoire', 'Democratic Republic of the Congo',
        'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic',
        'DR Congo', 'East Timor', 'Ecuador', 'Egypt',
        'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia',
        'Eswatini', 'Ethiopia', 'Falkland Islands (Malvinas)', 'Faroe Islands',
        'Federated States of Micronesia', 'Fiji', 'Finland', 'France',
        'French Guiana', 'French Polynesia', 'French Southern Territories', 'Gabon',
        'Gambia', 'Georgia', 'Germany', 'Ghana',
        'Gibraltar', 'Greece', 'Greenland', 'Grenada',
        'Guadeloupe', 'Guam', 'Guatemala', 'Guernsey',
        'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
        'Heard Island and McDonald Islands', 'Holy See (Vatican City State)', 'Honduras', 'Hong Kong',
        'Hungary', 'Iceland', 'India', 'Indonesia',
        'Iran', 'Iran, Islamic Republic of', 'Iraq', 'Ireland',
        'Isle of Man', 'Israel', 'Italy', 'Ivory Coast',
        'Jamaica', 'Japan', 'Jersey', 'Jordan',
        'Kazakhstan', 'Kenya', 'Kiribati', 'Korea, Democratic People''s Republic of',
        'Korea, Republic of', 'Kuwait', 'Kyrgyzstan', 'Lao People''s Democratic Republic',
        'Laos', 'Latvia', 'Lebanon', 'Lesotho',
        'Liberia', 'Libya', 'Liechtenstein', 'Lithuania',
        'Luxembourg', 'Macao', 'Macau', 'Madagascar',
        'Malawi', 'Malaysia', 'Maldives', 'Mali',
        'Malta', 'Marshall Islands', 'Martinique', 'Mauritania',
        'Mauritius', 'Mayotte', 'Mexico', 'Micronesia, Federated States of',
        'Moldova', 'Moldova, Republic of', 'Monaco', 'Mongolia',
        'Montenegro', 'Montserrat', 'Morocco', 'Mozambique',
        'Myanmar', 'Namibia', 'Nauru', 'Nepal',
        'Netherlands', 'New Caledonia', 'New Zealand', 'Nicaragua',
        'Niger', 'Nigeria', 'Niue', 'Norfolk Island',
        'North Korea', 'North Macedonia', 'Northern Mariana Islands', 'Norway',
        'Oman', 'Pakistan', 'Palau', 'Palestine',
        'Palestine, State of', 'Panama', 'Papua New Guinea', 'Paraguay',
        'Peru', 'Philippines', 'Pitcairn', 'Poland',
        'Portugal', 'Puerto Rico', 'Qatar', 'Republic of the Congo',
        'Romania', 'Russia', 'Russian Federation', 'Rwanda',
        'Réunion', 'Saint Barthélemy', 'Saint Helena, Ascension and Tristan da Cunha', 'Saint Kitts and Nevis',
        'Saint Lucia', 'Saint Martin (French part)', 'Saint Pierre and Miquelon', 'Saint Vincent and the Grenadines',
        'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia',
        'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone',
        'Singapore', 'Sint Maarten (Dutch part)', 'Slovakia', 'Slovenia',
        'Solomon Islands', 'Somalia', 'South Africa', 'South Georgia and the South Sandwich Islands',
        'South Korea', 'South Sudan', 'Spain', 'Sri Lanka',
        'Sudan', 'Suriname', 'Svalbard and Jan Mayen', 'Sweden',
        'Switzerland', 'Syria', 'Syrian Arab Republic', 'Taiwan',
        'Taiwan, Province of China', 'Tajikistan', 'Tanzania', 'Tanzania, United Republic of',
        'Thailand', 'The Gambia', 'The Netherlands', 'Timor-Leste',
        'Togo', 'Tokelau', 'Tonga', 'Trinidad and Tobago',
        'Tunisia', 'Turkey', 'Turkmenistan', 'Turks and Caicos Islands',
        'Tuvalu', 'Türkiye', 'UAE', 'Uganda',
        'UK', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
        'United States', 'United States Minor Outlying Islands', 'United States of America', 'Uruguay',
        'USA', 'Uzbekistan', 'Vanuatu', 'Vatican City',
        'Venezuela', 'Venezuela, Bolivarian Republic of', 'Viet Nam', 'Vietnam',
        'Virgin Islands, British', 'Virgin Islands, U.S.', 'Wallis and Futuna', 'Western Sahara',
        'Yemen', 'Zambia', 'Zimbabwe', 'Åland Islands'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Country must be a recognized country or territory';
        END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_internal_check_user_company
-- Group: Shared role and reference validation
-- Operation: Shared validation helper
-- Purpose: Enforce Admin company=NULL and Seller/Consumer user-company role consistency.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_internal_check_user_company(
IN p_role        VARCHAR(10),
IN p_company_id  INT
)
BEGIN
    DECLARE v_type ENUM('CONSUMER','SELLER') DEFAULT NULL;
    IF p_role = 'ADMIN' THEN
        IF p_company_id IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SRS 7.3: an Admin user must not belong to a
            company';
        END IF;
    ELSE
        SELECT company_type
        INTO v_type
        FROM companies
        WHERE company_id = p_company_id;
        IF v_type IS NULL OR v_type <> p_role THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SRS 7.3: user role must match the type of the
            company';
        END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_require_active_admin
-- Group: Shared role and reference validation
-- Operation: Shared validation helper
-- Purpose: Ensure the supplied account is an active Admin.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_require_active_admin(IN p_user_id INT)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM users
        WHERE user_id = p_user_id
          AND role = 'ADMIN'
          AND status = 'ACTIVE'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR1.3: an active Admin user is required';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Companies
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_company
-- Group: Companies
-- Operation: CREATE / INSERT
-- Purpose: Insert company while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_company(
IN p_company_name  VARCHAR(150),
IN p_company_type  ENUM('CONSUMER','SELLER'),
IN p_gst_number    VARCHAR(20),
IN p_iec_code      VARCHAR(15),
IN p_address       TEXT,
IN p_city          VARCHAR(60),
IN p_country       VARCHAR(60)
)
BEGIN
    INSERT INTO companies (
    company_name,
    company_type,
    gst_number,
    iec_code,
    address,
    city,
    country
    )
    VALUES (
    p_company_name,
    p_company_type,
    p_gst_number,
    p_iec_code,
    p_address,
    p_city,
    p_country
    );
    SELECT LAST_INSERT_ID() AS company_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_company_field
-- Group: Companies
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update company field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_company_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM companies t JOIN users u ON u.user_id = p_user_id AND u.status='ACTIVE' WHERE t.company_id=p_record_id AND (u.role='ADMIN' OR (u.company_id=t.company_id AND u.role IN ('CONSUMER','SELLER')));
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;
    -- Company type governs user roles; only Admin may request a type change.
    IF p_field_name = 'company_type' THEN
        SELECT COUNT(*) INTO v_admin FROM users WHERE user_id=p_user_id AND role='ADMIN' AND status='ACTIVE';
        IF v_admin <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only Admin can change company type';
        END IF;
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'company_name' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 150 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for company_name';
        END IF;
        UPDATE companies SET company_name = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'company_type' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('CONSUMER','SELLER') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid company_type value';
        END IF;
        UPDATE companies SET company_type = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'gst_number' THEN
        IF CHAR_LENGTH(p_new_value) > 20 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for gst_number';
        END IF;
        UPDATE companies SET gst_number = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'iec_code' THEN
        IF CHAR_LENGTH(p_new_value) > 15 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for iec_code';
        END IF;
        UPDATE companies SET iec_code = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'address' THEN
        UPDATE companies SET address = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'city' THEN
        IF CHAR_LENGTH(p_new_value) > 60 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for city';
        END IF;
        UPDATE companies SET city = p_new_value WHERE company_id = p_record_id;
    ELSEIF p_field_name = 'country' THEN
        IF CHAR_LENGTH(p_new_value) > 60 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for country';
        END IF;
        UPDATE companies SET country = p_new_value WHERE company_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','companies',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM companies WHERE company_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_company
-- Group: Companies
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove company while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_company(
IN p_company_id INT
)
BEGIN
    DELETE FROM companies
    WHERE company_id = p_company_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_companies
-- Group: Companies
-- Operation: SHOW / list records
-- Purpose: Display companies while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_companies()
BEGIN
    SELECT *
    FROM companies
    ORDER BY company_name;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_companies
-- Group: Companies
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search companies while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_companies(
IN p_keyword       VARCHAR(100),
IN p_company_type  ENUM('CONSUMER','SELLER')
)
BEGIN
    SELECT *
    FROM companies
    WHERE (p_keyword IS NULL
    OR company_name LIKE CONCAT('%', p_keyword, '%')
    OR gst_number   LIKE CONCAT('%', p_keyword, '%')
    OR city         LIKE CONCAT('%', p_keyword, '%'))
    AND (p_company_type IS NULL OR company_type = p_company_type)
    ORDER BY company_name;
END$$

-- ----------------------------------------------------------------------------
-- Login and user accounts
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_user
-- Group: Login and user accounts
-- Operation: CREATE / INSERT
-- Purpose: Insert user while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_user(
    IN p_role ENUM('ADMIN','CONSUMER','SELLER'),
    IN p_company_id INT,
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(120),
    IN p_password VARCHAR(255),
    IN p_phone VARCHAR(20)
)
BEGIN
    DECLARE v_salt CHAR(32);
    DECLARE v_hash VARCHAR(255);
    -- The caller passes a password, not a hash; persist only the salted digest.
    IF p_password IS NULL OR CHAR_LENGTH(p_password) < 8
       OR CHAR_LENGTH(p_password) > 255 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Password must have 8 to 255 characters';
    END IF;
    SET v_salt=REPLACE(UUID(),'-','');
    SET v_hash=CONCAT('S256I10000$',v_salt,'$',fn_password_digest(p_password,v_salt));
    INSERT INTO users(role,company_id,full_name,email,password_hash,phone)
    VALUES(p_role,p_company_id,p_full_name,p_email,v_hash,p_phone);
    SELECT LAST_INSERT_ID() AS user_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_user_field
-- Group: Login and user accounts
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update user field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_user_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE v_salt CHAR(32) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM users t JOIN users u ON u.user_id=p_user_id AND u.status='ACTIVE' WHERE t.user_id=p_record_id AND (u.role='ADMIN' OR u.user_id=t.user_id);
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;
    -- Only an Admin may change account status; users may edit own profile fields.
    IF p_field_name = 'status' THEN
        SELECT COUNT(*) INTO v_admin FROM users WHERE user_id=p_user_id AND role='ADMIN' AND status='ACTIVE';
        IF v_admin <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only Admin can change user status';
        END IF;
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'full_name' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 100 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for full_name';
        END IF;
        UPDATE users SET full_name = p_new_value WHERE user_id = p_record_id;
    ELSEIF p_field_name = 'email' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 120 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for email';
        END IF;
        UPDATE users SET email = p_new_value WHERE user_id = p_record_id;
    ELSEIF p_field_name = 'password_hash' THEN
        -- Password changes are received as plaintext and stored as a salted digest.
        IF p_new_value IS NULL OR CHAR_LENGTH(p_new_value)<8
           OR CHAR_LENGTH(p_new_value)>255 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Password must have 8 to 255 characters';
        END IF;
        SET v_salt=REPLACE(UUID(),'-','');
        UPDATE users SET password_hash=CONCAT('S256I10000$',v_salt,'$',
              fn_password_digest(p_new_value,v_salt))
        WHERE user_id=p_record_id;
    ELSEIF p_field_name = 'phone' THEN
        IF CHAR_LENGTH(p_new_value) > 20 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for phone';
        END IF;
        UPDATE users SET phone = p_new_value WHERE user_id = p_record_id;
    ELSEIF p_field_name = 'status' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('ACTIVE','INACTIVE','LOCKED') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status value';
        END IF;
        UPDATE users SET status = p_new_value WHERE user_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','users',p_record_id,
        NULL,JSON_OBJECT(p_field_name,IF(p_field_name='password_hash','[REDACTED]',p_new_value)),p_ip_address);
    COMMIT;
    SELECT user_id,role,company_id,full_name,email,phone,status,failed_attempts,last_login
    FROM users WHERE user_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_user
-- Group: Login and user accounts
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove user while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_user(
IN p_user_id INT
)
BEGIN
    DELETE FROM users
    WHERE user_id = p_user_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_users
-- Group: Login and user accounts
-- Operation: SHOW / list records
-- Purpose: Display users while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_users()
BEGIN
    SELECT u.user_id,
    u.role,
    u.company_id,
    c.company_name,
    u.full_name,
    u.email,
    u.phone,
    u.status,
    u.failed_attempts,
    u.last_login
    FROM users u
    LEFT JOIN companies c ON c.company_id = u.company_id
    ORDER BY u.user_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_users
-- Group: Login and user accounts
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search users while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_users(
IN p_keyword  VARCHAR(100),
IN p_role     VARCHAR(10),
IN p_status   VARCHAR(10)
)
BEGIN
    SELECT u.user_id,
    u.role,
    u.company_id,
    c.company_name,
    u.full_name,
    u.email,
    u.phone,
    u.status,
    u.failed_attempts,
    u.last_login
    FROM users u
    LEFT JOIN companies c ON c.company_id = u.company_id
    WHERE (p_keyword IS NULL
    OR u.full_name LIKE CONCAT('%', p_keyword, '%')
    OR u.email     LIKE CONCAT('%', p_keyword, '%'))
    AND (p_role   IS NULL OR u.role   = p_role)
    AND (p_status IS NULL OR u.status = p_status)
    ORDER BY u.user_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_user_for_login
-- Group: Login and user accounts
-- Operation: GET / detail report
-- Purpose: Return user for login while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_user_for_login(
    IN p_email VARCHAR(120),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_id INT DEFAULT NULL;
    DECLARE v_status VARCHAR(10) DEFAULT NULL;
    DECLARE v_stored VARCHAR(255) DEFAULT NULL;
    DECLARE v_salt VARCHAR(32) DEFAULT NULL;
    DECLARE v_expected VARCHAR(255) DEFAULT NULL;
    DECLARE v_authenticated INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    -- Both email and password are mandatory; do not expose password hashes.
    IF p_email IS NULL OR TRIM(p_email)='' OR p_password IS NULL
       OR CHAR_LENGTH(p_password)=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Email and password are required';
    END IF;
    START TRANSACTION;
    SELECT MAX(user_id) INTO v_id FROM users WHERE email=p_email;
    IF v_id IS NOT NULL THEN
        SELECT status,password_hash INTO v_status,v_stored
        FROM users WHERE user_id=v_id FOR UPDATE;
        IF LEFT(v_stored,11)='S256I10000$' AND CHAR_LENGTH(v_stored)=108 THEN
            SET v_salt=SUBSTRING(v_stored,12,32);
            SET v_expected=CONCAT('S256I10000$',v_salt,'$',fn_password_digest(p_password,v_salt));
            IF BINARY v_expected = BINARY v_stored AND v_status='ACTIVE' THEN
                SET v_authenticated=1;
            END IF;
        END IF;
        IF v_authenticated=1 THEN
            UPDATE users SET failed_attempts=0,last_login=NOW() WHERE user_id=v_id;
        ELSE
            -- Approved assumption: failed attempts are counted, never auto-locked.
            UPDATE users SET failed_attempts=failed_attempts+1 WHERE user_id=v_id;
        END IF;
        INSERT INTO audit_log(user_id,action,table_name,record_id)
        VALUES(v_id,IF(v_authenticated=1,'LOGIN','LOGIN_FAILED'),'users',v_id);
    END IF;
    COMMIT;
    IF v_authenticated=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid credentials or inactive account';
    END IF;
    SELECT user_id,full_name,email,role,company_id,status,last_login
    FROM users WHERE user_id=v_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_logout
-- Group: Login and user accounts
-- Operation: Business logic / processing
-- Purpose: Record logout and audit action.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_logout(IN p_user_id INT)
BEGIN
    IF p_user_id IS NULL OR NOT EXISTS
       (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.5: logout user does not exist';
    END IF;
    CALL sp_record_audit_action(p_user_id, 'LOGOUT', 'users',
                                p_user_id, NULL, NULL, NULL);
END$$

-- ----------------------------------------------------------------------------
-- Consumers and customers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_customer
-- Group: Consumers and customers
-- Operation: CREATE / INSERT
-- Purpose: Insert customer while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_customer(
IN p_user_id          INT,
IN p_company_id       INT,
IN p_contact_person   VARCHAR(100),
IN p_billing_address  TEXT,
IN p_credit_limit     DECIMAL(12,2)
)
BEGIN
    INSERT INTO customers (
    user_id,
    company_id,
    contact_person,
    billing_address,
    credit_limit
    )
    VALUES (
    p_user_id,
    p_company_id,
    p_contact_person,
    p_billing_address,
    COALESCE(p_credit_limit, 0)
    );
    SELECT LAST_INSERT_ID() AS customer_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_customer_field
-- Group: Consumers and customers
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update customer field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_customer_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM customers t JOIN users u ON u.user_id=p_user_id AND u.status='ACTIVE' WHERE t.customer_id=p_record_id AND (u.role='ADMIN' OR (u.role='CONSUMER' AND u.user_id=t.user_id));
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'contact_person' THEN
        IF CHAR_LENGTH(p_new_value) > 100 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for contact_person';
        END IF;
        UPDATE customers SET contact_person = p_new_value WHERE customer_id = p_record_id;
    ELSEIF p_field_name = 'billing_address' THEN
        UPDATE customers SET billing_address = p_new_value WHERE customer_id = p_record_id;
    ELSEIF p_field_name = 'credit_limit' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}([.][0-9]{1,2})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for credit_limit';
        END IF;
        UPDATE customers SET credit_limit = CAST(p_new_value AS DECIMAL(12,2)) WHERE customer_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','customers',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM customers WHERE customer_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_consumer
-- Group: Consumers and customers
-- Operation: DELETE / controlled correction
-- Purpose: Remove an unused Consumer profile; retain the linked user for audit.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_consumer(IN p_actor_id INT,IN p_customer_id INT)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT user_id INTO v_owner FROM customers
    WHERE customer_id=p_customer_id FOR UPDATE;
    SELECT role INTO v_role FROM users WHERE user_id=p_actor_id AND status='ACTIVE';
    IF v_owner IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consumer profile does not exist';
    END IF;
    IF v_role IS NULL OR NOT (v_role='ADMIN' OR (v_role='CONSUMER' AND v_owner=p_actor_id)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only Admin or the owning Consumer may delete';
    END IF;
    IF EXISTS(SELECT 1 FROM shipment WHERE consumer_id=p_customer_id)
       OR EXISTS(SELECT 1 FROM billing_invoices WHERE consumer_id=p_customer_id)
       OR EXISTS(SELECT 1 FROM sales_transactions WHERE customer_id=p_customer_id)
       OR EXISTS(SELECT 1 FROM claims WHERE consumer_id=p_customer_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consumer has historical transactions: deactivate user instead';
    END IF;
    DELETE FROM customers WHERE customer_id=p_customer_id;
    UPDATE users SET status='INACTIVE' WHERE user_id=v_owner;
    INSERT INTO audit_log(user_id,action,table_name,record_id)
    VALUES(p_actor_id,'DELETE','customers',p_customer_id);
    COMMIT;
    SELECT p_customer_id AS deleted_consumer_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_customers
-- Group: Consumers and customers
-- Operation: SHOW / list records
-- Purpose: Display customers while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_customers()
BEGIN
    SELECT cu.*,
    u.full_name,
    u.email,
    co.company_name
    FROM customers cu
    JOIN users     u  ON u.user_id     = cu.user_id
    JOIN companies co ON co.company_id = cu.company_id
    ORDER BY cu.customer_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_customers
-- Group: Consumers and customers
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search customers while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_customers(
IN p_keyword VARCHAR(100)
)
BEGIN
    SELECT cu.*,
    u.full_name,
    u.email,
    co.company_name
    FROM customers cu
    JOIN users     u  ON u.user_id     = cu.user_id
    JOIN companies co ON co.company_id = cu.company_id
    WHERE p_keyword IS NULL
    OR cu.contact_person LIKE CONCAT('%', p_keyword, '%')
    OR u.full_name       LIKE CONCAT('%', p_keyword, '%')
    OR co.company_name   LIKE CONCAT('%', p_keyword, '%')
    ORDER BY cu.customer_id;
END$$

-- ----------------------------------------------------------------------------
-- Ports
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_port
-- Group: Ports
-- Operation: CREATE / INSERT
-- Purpose: Insert port while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_port(IN p_user_id INT,

IN p_port_code  VARCHAR(10),
IN p_port_name  VARCHAR(100),
IN p_city       VARCHAR(60),
IN p_country    VARCHAR(60),
IN p_latitude   DECIMAL(9,6),
IN p_longitude  DECIMAL(9,6)
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    INSERT INTO ports (
    port_code,
    port_name,
    city,
    country,
    latitude,
    longitude
    )
    VALUES (
    p_port_code,
    p_port_name,
    p_city,
    p_country,
    p_latitude,
    p_longitude
    );
    SELECT LAST_INSERT_ID() AS port_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_port_field
-- Group: Ports
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update port field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_port_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM ports t JOIN users u ON u.user_id=p_user_id AND u.role='ADMIN' AND u.status='ACTIVE' WHERE t.port_id=p_record_id;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;
    -- Latitude and longitude are signed coordinates (their original DECIMAL types are retained).
    IF p_field_name='latitude' AND p_new_value IS NOT NULL THEN
        IF p_new_value NOT REGEXP '^-?[0-9]{1,3}([.][0-9]{1,6})?$' OR CAST(p_new_value AS DECIMAL(9,6)) NOT BETWEEN -90 AND 90 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Latitude must be between -90 and 90';
        END IF;
    END IF;
    IF p_field_name='longitude' AND p_new_value IS NOT NULL THEN
        IF p_new_value NOT REGEXP '^-?[0-9]{1,3}([.][0-9]{1,6})?$' OR CAST(p_new_value AS DECIMAL(9,6)) NOT BETWEEN -180 AND 180 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Longitude must be between -180 and 180';
        END IF;
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'port_code' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 10 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for port_code';
        END IF;
        UPDATE ports SET port_code = p_new_value WHERE port_id = p_record_id;
    ELSEIF p_field_name = 'port_name' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 100 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for port_name';
        END IF;
        UPDATE ports SET port_name = p_new_value WHERE port_id = p_record_id;
    ELSEIF p_field_name = 'city' THEN
        IF CHAR_LENGTH(p_new_value) > 60 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for city';
        END IF;
        UPDATE ports SET city = p_new_value WHERE port_id = p_record_id;
    ELSEIF p_field_name = 'country' THEN
        IF CHAR_LENGTH(p_new_value) > 60 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for country';
        END IF;
        UPDATE ports SET country = p_new_value WHERE port_id = p_record_id;
    ELSEIF p_field_name = 'latitude' THEN
        IF p_new_value IS NOT NULL AND p_new_value NOT REGEXP '^-?[0-9]{1,3}([.][0-9]{1,6})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for latitude';
        END IF;
        UPDATE ports SET latitude = CAST(p_new_value AS DECIMAL(9,6)) WHERE port_id = p_record_id;
    ELSEIF p_field_name = 'longitude' THEN
        IF p_new_value IS NOT NULL AND p_new_value NOT REGEXP '^-?[0-9]{1,3}([.][0-9]{1,6})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for longitude';
        END IF;
        UPDATE ports SET longitude = CAST(p_new_value AS DECIMAL(9,6)) WHERE port_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','ports',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM ports WHERE port_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_port
-- Group: Ports
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove port while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_port(IN p_user_id INT,

IN p_port_id INT
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    DELETE FROM ports
    WHERE port_id = p_port_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_ports
-- Group: Ports
-- Operation: SHOW / list records
-- Purpose: Display ports while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_ports(IN p_user_id INT)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    SELECT *
    FROM ports
    ORDER BY port_name;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_ports
-- Group: Ports
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search ports while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_ports(IN p_user_id INT,

IN p_keyword VARCHAR(100)
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    SELECT *
    FROM ports
    WHERE p_keyword IS NULL
    OR port_code LIKE CONCAT('%', p_keyword, '%')
    OR port_name LIKE CONCAT('%', p_keyword, '%')
    OR city      LIKE CONCAT('%', p_keyword, '%')
    OR country   LIKE CONCAT('%', p_keyword, '%')
    ORDER BY port_name;
END$$

-- ----------------------------------------------------------------------------
-- Vessels
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_vessel
-- Group: Vessels
-- Operation: CREATE / INSERT
-- Purpose: Insert vessel while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_vessel(IN p_user_id INT,

IN p_vessel_name       VARCHAR(100),
IN p_imo_number        VARCHAR(15),
IN p_owner_company_id  INT,
IN p_capacity_teu      INT,
IN p_status            VARCHAR(15)
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    INSERT INTO vessels (
    vessel_name,
    imo_number,
    owner_company_id,
    capacity_teu,
    status
    )
    VALUES (
    p_vessel_name,
    p_imo_number,
    p_owner_company_id,
    p_capacity_teu,
    p_status
    );
    SELECT LAST_INSERT_ID() AS vessel_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_vessel_field
-- Group: Vessels
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update vessel field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_vessel_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM vessels t JOIN users u ON u.user_id=p_user_id AND u.role='ADMIN' AND u.status='ACTIVE' WHERE t.vessel_id=p_record_id;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'vessel_name' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 100 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for vessel_name';
        END IF;
        UPDATE vessels SET vessel_name = p_new_value WHERE vessel_id = p_record_id;
    ELSEIF p_field_name = 'imo_number' THEN
        IF CHAR_LENGTH(p_new_value) > 15 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for imo_number';
        END IF;
        UPDATE vessels SET imo_number = p_new_value WHERE vessel_id = p_record_id;
    ELSEIF p_field_name = 'owner_company_id' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}$' OR CAST(p_new_value AS UNSIGNED) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid integer for owner_company_id';
        END IF;
        UPDATE vessels SET owner_company_id = CAST(p_new_value AS UNSIGNED) WHERE vessel_id = p_record_id;
    ELSEIF p_field_name = 'capacity_teu' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}$' OR CAST(p_new_value AS UNSIGNED) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid integer for capacity_teu';
        END IF;
        UPDATE vessels SET capacity_teu = CAST(p_new_value AS UNSIGNED) WHERE vessel_id = p_record_id;
    ELSEIF p_field_name = 'status' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('ACTIVE','MAINTENANCE') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status value';
        END IF;
        UPDATE vessels SET status = p_new_value WHERE vessel_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','vessels',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM vessels WHERE vessel_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_vessel
-- Group: Vessels
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove vessel while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_vessel(IN p_user_id INT,

IN p_vessel_id INT
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    DELETE FROM vessels
    WHERE vessel_id = p_vessel_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_vessels
-- Group: Vessels
-- Operation: SHOW / list records
-- Purpose: Display vessels while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_vessels(IN p_user_id INT)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    SELECT v.*,
    c.company_name AS owner_company
    FROM vessels v
    LEFT JOIN companies c ON c.company_id = v.owner_company_id
    ORDER BY v.vessel_name;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_vessels
-- Group: Vessels
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search vessels while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_vessels(IN p_user_id INT,

IN p_keyword  VARCHAR(100),
IN p_status   VARCHAR(15)
)
BEGIN
    CALL sp_require_active_admin(p_user_id);
    SELECT v.*,
    c.company_name AS owner_company
    FROM vessels v
    LEFT JOIN companies c ON c.company_id = v.owner_company_id
    WHERE (p_keyword IS NULL
    OR v.vessel_name LIKE CONCAT('%', p_keyword, '%')
    OR v.imo_number  LIKE CONCAT('%', p_keyword, '%'))
    AND (p_status IS NULL OR v.status = p_status)
    ORDER BY v.vessel_name;
END$$

-- ----------------------------------------------------------------------------
-- Audit logs
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_audit_log
-- Group: Audit logs
-- Operation: SHOW / list records
-- Purpose: Display audit log while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_audit_log()
BEGIN
    SELECT a.*,
    u.full_name
    FROM audit_log a
    LEFT JOIN users u ON u.user_id = a.user_id
    ORDER BY a.log_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_audit_log
-- Group: Audit logs
-- Operation: SEARCH / filtered retrieval
-- Purpose: Search audit entries by acting user and affected table.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_audit_log(
    IN p_user_id INT,
    IN p_table_name VARCHAR(60),
    IN p_from_date DATE,
    IN p_to_date DATE
)
BEGIN
    IF p_from_date IS NOT NULL OR p_to_date IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Audit date filtering unavailable: no timestamp column';
    END IF;
    SELECT a.*, u.full_name
    FROM audit_log a
    LEFT JOIN users u ON u.user_id = a.user_id
    WHERE (p_user_id IS NULL OR a.user_id = p_user_id)
      AND (p_table_name IS NULL OR a.table_name = p_table_name)
    ORDER BY a.log_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_record_audit_action
-- Group: Audit logs
-- Operation: RECORD / financial or audit action
-- Purpose: Add audit entry using caller-supplied actor, changed fields and IP.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_record_audit_action(
IN p_user_id     INT,
IN p_action      VARCHAR(100),
IN p_table_name  VARCHAR(60),
IN p_record_id   BIGINT,
IN p_old_value   JSON,
IN p_new_value   JSON,
IN p_ip_address  VARCHAR(45)
)
BEGIN
    IF p_user_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR1.5: audit user does not exist';
    END IF;
    INSERT INTO audit_log (
    user_id,
    action,
    table_name,
    record_id,
    old_value,
    new_value,
    ip_address
    )
    VALUES (
    p_user_id,
    p_action,
    p_table_name,
    p_record_id,
    p_old_value,
    p_new_value,
    p_ip_address
    );
END$$

-- ============================================================================
-- MODULE 2 — Shipment and Container Movement Tracking — 12 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Shipments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_shipment_field
-- Group: Shipments
-- Operation: Specific UPDATE / state change
-- Purpose: Update one whitelisted shipment metadata attribute after Seller/Admin authorization.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_shipment_field(
    IN p_user_id INT,IN p_shipment_id INT,
    IN p_field_name VARCHAR(40),IN p_new_value VARCHAR(255)
)
BEGIN
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_etd DATE DEFAULT NULL;
    DECLARE v_eta DATE DEFAULT NULL;
    DECLARE v_new_date DATE DEFAULT NULL;
    DECLARE v_vessel INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT seller_id,status,etd,eta INTO v_seller,v_status,v_etd,v_eta
    FROM shipment WHERE shipment_id=p_shipment_id FOR UPDATE;
    IF v_seller IS NULL OR v_status IN ('DELIVERED','CANCELLED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shipment missing or closed';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id=p_user_id AND status='ACTIVE'
       AND (role='ADMIN' OR (role='SELLER' AND company_id=v_seller))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only owning Seller/Admin may update shipment';
    END IF;
    IF p_field_name='vessel_id' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[1-9][0-9]*$'
           OR CHAR_LENGTH(p_new_value)>10 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vessel ID must be positive';
        END IF;
        SET v_vessel=CAST(p_new_value AS UNSIGNED);
        IF NOT EXISTS(SELECT 1 FROM vessels WHERE vessel_id=v_vessel AND status='ACTIVE') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Assigned vessel must be active';
        END IF;
        UPDATE shipment SET vessel_id=v_vessel WHERE shipment_id=p_shipment_id;
    ELSEIF p_field_name='cargo_description' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value)='' OR CHAR_LENGTH(p_new_value)>255 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid cargo description';
        END IF;
        UPDATE shipment SET cargo_description=p_new_value WHERE shipment_id=p_shipment_id;
    ELSEIF p_field_name IN ('etd','eta') THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Use a valid YYYY-MM-DD date';
        END IF;
        SET v_new_date=STR_TO_DATE(p_new_value,'%Y-%m-%d');
        IF v_new_date IS NULL OR DATE_FORMAT(v_new_date,'%Y-%m-%d')<>p_new_value THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid shipment date';
        END IF;
        IF (p_field_name='eta' AND v_etd IS NOT NULL AND v_new_date<v_etd)
           OR (p_field_name='etd' AND v_eta IS NOT NULL AND v_new_date>v_eta) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='ETA cannot precede ETD';
        END IF;
        IF p_field_name='etd' THEN
            UPDATE shipment SET etd=v_new_date WHERE shipment_id=p_shipment_id;
        ELSE
            UPDATE shipment SET eta=v_new_date WHERE shipment_id=p_shipment_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shipment field is not editable';
    END IF;
    COMMIT;
    SELECT shipment_id,shipment_no,vessel_id,cargo_description,etd,eta,status
    FROM shipment WHERE shipment_id=p_shipment_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_shipment
-- Group: Shipments
-- Operation: Controlled logical cancellation with stock release and history retained.
-- Scope: Added shipment-cancellation improvement; no table changes.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_shipment(
    IN p_user_id INT,
    IN p_shipment_id INT,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_consumer_id INT DEFAULT NULL;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_origin_port INT DEFAULT NULL;
    DECLARE v_old_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_user_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    DECLARE v_invoice INT DEFAULT NULL;
    DECLARE v_paid DECIMAL(12,2) DEFAULT 0;
    DECLARE v_stock_id INT DEFAULT NULL;
    DECLARE v_product_id INT DEFAULT NULL;
    DECLARE v_stock_qty INT DEFAULT NULL;
    DECLARE v_damaged_qty INT DEFAULT NULL;
    DECLARE v_general_stock_id INT DEFAULT NULL;
    DECLARE v_total_items BIGINT DEFAULT 0;
    DECLARE v_total_returned BIGINT DEFAULT 0;
    DECLARE v_stock_left BIGINT DEFAULT 0;
    DECLARE v_current_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_container_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_done TINYINT DEFAULT 0;
    DECLARE v_previous_ledger_type VARCHAR(20) DEFAULT NULL;
    DECLARE v_previous_ref_type VARCHAR(30) DEFAULT NULL;
    DECLARE v_previous_ref_id BIGINT DEFAULT NULL;

    -- Keep the original cursor-based inventory reversal. Opening the
    -- FOR UPDATE cursor locks the shipment's reserved stock rows.
    DECLARE reserved_stock_cursor CURSOR FOR
        SELECT stock_id, product_id, quantity, damaged_qty
        FROM stock
        WHERE shipment_id = p_shipment_id
          AND quantity > 0
        ORDER BY product_id, stock_id
        FOR UPDATE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET @ledger_txn_type = v_previous_ledger_type;
        SET @ledger_ref_type = v_previous_ref_type;
        SET @ledger_ref_id = v_previous_ref_id;
        RESIGNAL;
    END;

    -- Capture session context before any statement which could fail.
    SET v_previous_ledger_type = @ledger_txn_type;
    SET v_previous_ref_type = @ledger_ref_type;
    SET v_previous_ref_id = @ledger_ref_id;

    IF p_user_id IS NULL OR p_shipment_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User ID and shipment ID are required';
    END IF;
    IF p_reason IS NULL OR TRIM(p_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cancellation reason is required';
    END IF;

    START TRANSACTION;

    -- Lock the booking first. Concurrent cancellation cannot pass twice.
    SELECT seller_id, consumer_id, container_id, origin_port_id, status
    INTO v_seller, v_consumer_id, v_container, v_origin_port, v_old_status
    FROM shipment
    WHERE shipment_id = p_shipment_id
    FOR UPDATE;

    IF v_seller IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment not found';
    END IF;

    SELECT role, company_id
    INTO v_role, v_user_company
    FROM users
    WHERE user_id = p_user_id AND status = 'ACTIVE';

    IF v_role = 'CONSUMER' THEN
        SELECT customer_id INTO v_customer
        FROM customers WHERE user_id = p_user_id;
        IF v_customer IS NULL OR v_customer <> v_consumer_id THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Only the booking Consumer may cancel this shipment';
        END IF;
        IF v_old_status <> 'BOOKED' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Consumer cancellation is permitted only while BOOKED';
        END IF;
    ELSEIF v_role = 'ADMIN' OR
          (v_role = 'SELLER' AND v_user_company = v_seller) THEN
        IF v_old_status NOT IN ('BOOKED','LOADED') THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Seller/Admin can cancel only BOOKED or LOADED shipments';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only the booking Consumer, owning Seller or Admin may cancel';
    END IF;

    -- The SRS requires an invoice at booking. Lock it so payment records
    -- and cancellation cannot progress against the same invoice concurrently.
    SELECT invoice_id, paid_amount
    INTO v_invoice, v_paid
    FROM billing_invoices
    WHERE shipment_id = p_shipment_id
    FOR UPDATE;
    IF v_invoice IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Booking invoice is missing; cancellation needs review';
    END IF;
    IF v_paid <> 0 OR EXISTS (
        SELECT 1 FROM payments WHERE invoice_id = v_invoice
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Payments exist; contact support before cancellation';
    END IF;
    IF EXISTS (SELECT 1 FROM claims WHERE shipment_id = p_shipment_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Claim history exists; this booking cannot be cancelled';
    END IF;
    -- A shared active allocation must never be released by accident.
    IF EXISTS (
        SELECT 1 FROM shipment s2
        WHERE s2.container_id = v_container
          AND s2.shipment_id <> p_shipment_id
          AND s2.status NOT IN ('CANCELLED','DELIVERED')
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Container has another active shipment; cancellation needs review';
    END IF;

    -- Do not silently return incorrect inventory.
    SELECT COALESCE(SUM(quantity),0)
    INTO v_total_items
    FROM shipment_items
    WHERE shipment_id = p_shipment_id;
    IF v_total_items <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No booked items found for stock reversal';
    END IF;

    -- Refuse mismatched quantities, extra reserved product rows or damage.
    IF EXISTS (
        SELECT 1
        FROM stock st
        WHERE st.shipment_id = p_shipment_id
          AND (st.damaged_qty <> 0 OR
               st.container_id IS NULL OR st.container_id <> v_container)
    ) OR EXISTS (
        SELECT 1
        FROM (
            SELECT product_id, SUM(quantity) AS booked_qty
            FROM shipment_items WHERE shipment_id = p_shipment_id
            GROUP BY product_id
        ) si
        LEFT JOIN (
            SELECT product_id, SUM(quantity) AS reserved_qty
            FROM stock WHERE shipment_id = p_shipment_id
            GROUP BY product_id
        ) st ON st.product_id = si.product_id
        WHERE st.product_id IS NULL OR st.reserved_qty <> si.booked_qty
    ) OR EXISTS (
        SELECT 1 FROM stock st
        WHERE st.shipment_id = p_shipment_id AND st.quantity > 0
          AND NOT EXISTS (
             SELECT 1 FROM shipment_items si
             WHERE si.shipment_id=p_shipment_id AND si.product_id=st.product_id
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Reserved stock mismatch: cancellation needs inventory review';
    END IF;

    SET @ledger_txn_type = NULL;
    SET @ledger_ref_type = 'SHIPMENT';
    SET @ledger_ref_id = p_shipment_id;

    -- Open before recording movement so the stock row set is locked.
    SET v_done = 0;
    OPEN reserved_stock_cursor;

    -- FR2.3: movement is inserted FIRST; the approved AFTER INSERT
    -- trigger synchronizes shipment status and releases the container.
    -- MySQL 1442 protection: DO NOT use INSERT ... SELECT ... FROM shipment.
    -- The movement AFTER INSERT trigger updates shipment, so SELECTing
    -- shipment inside the INSERT statement would make it an invoking table.
    -- Container and origin IDs were loaded earlier under the shipment row lock.
    INSERT INTO container_movements
        (shipment_id,container_id,status,port_id,location_text,
         event_time,remarks,updated_by)
    VALUES (p_shipment_id,v_container,'CANCELLED',v_origin_port,
            'Booking cancellation',NOW(),
            LEFT(CONCAT('Cancelled: ',TRIM(p_reason)),255),p_user_id);

    stock_loop: LOOP
        FETCH reserved_stock_cursor
        INTO v_stock_id, v_product_id, v_stock_qty, v_damaged_qty;
        IF v_done = 1 THEN LEAVE stock_loop; END IF;

        SET @ledger_txn_type = 'OUT';
        UPDATE stock SET quantity = 0
        WHERE stock_id = v_stock_id AND shipment_id = p_shipment_id;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Reserved stock reversal failed; no changes saved';
        END IF;

        -- A general-stock row is updated atomically; if absent, insert it.
        SELECT MIN(stock_id) INTO v_general_stock_id
        FROM stock
        WHERE product_id = v_product_id
          AND shipment_id IS NULL AND container_id IS NULL;

        SET @ledger_txn_type = 'IN';
        IF v_general_stock_id IS NULL THEN
            INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty)
            VALUES(v_product_id,NULL,NULL,v_stock_qty,0);
        ELSE
            UPDATE stock SET quantity = quantity + v_stock_qty
            WHERE stock_id = v_general_stock_id
              AND shipment_id IS NULL AND container_id IS NULL;
            IF ROW_COUNT() <> 1 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'General stock restoration failed; no changes saved';
            END IF;
        END IF;
        SET v_total_returned = v_total_returned + v_stock_qty;
    END LOOP;
    CLOSE reserved_stock_cursor;

    IF v_total_returned <> v_total_items THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Restored stock differs from booked quantity; rolled back';
    END IF;

    -- Verify the database-generated state, not just that INSERT succeeded.
    SELECT status INTO v_current_status
    FROM shipment WHERE shipment_id = p_shipment_id;
    SELECT status INTO v_container_status
    FROM containers WHERE container_id = v_container;
    SELECT COALESCE(SUM(quantity),0) INTO v_stock_left
    FROM stock WHERE shipment_id = p_shipment_id;

    IF v_current_status IS NULL OR v_container_status IS NULL
       OR v_current_status <> 'CANCELLED'
       OR v_container_status <> 'AVAILABLE'
       OR v_stock_left <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cancellation state verification failed; rolled back';
    END IF;

    CALL sp_record_audit_action(
        p_user_id,'CANCEL_SHIPMENT','shipment',p_shipment_id,
        JSON_OBJECT('status',v_old_status,'container_id',v_container),
        JSON_OBJECT('status','CANCELLED',
                    'reason',TRIM(p_reason),
                    'stock_units_returned',v_total_returned,
                    'invoice_preserved',v_invoice),
        NULL
    );

    SET @ledger_txn_type = v_previous_ledger_type;
    SET @ledger_ref_type = v_previous_ref_type;
    SET @ledger_ref_id = v_previous_ref_id;
    COMMIT;

    SELECT p_shipment_id AS shipment_id,
           'CANCELLED' AS shipment_status,
           v_total_returned AS returned_stock_units,
           'Cancellation recorded; invoice retained for audit' AS result;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_shipments
-- Group: Shipments
-- Operation: SHOW / list records
-- Purpose: Display shipments while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_shipments(
IN p_user_id INT
)
BEGIN
    CALL sp_search_shipments(p_user_id, NULL, NULL, NULL, NULL);
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_shipments
-- Group: Shipments
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search shipments while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_shipments(
IN p_user_id           INT,
IN p_container_number  VARCHAR(15),
IN p_shipment_id       INT,
IN p_port_id           INT,
IN p_status            VARCHAR(20)
)
BEGIN
    DECLARE v_role     VARCHAR(10) DEFAULT NULL;
    DECLARE v_company  INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role, company_id
    INTO v_role, v_company
    FROM users
    WHERE user_id = p_user_id
    AND status = 'ACTIVE';
    SELECT customer_id
    INTO v_customer
    FROM customers
    WHERE user_id = p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR1.3: an active user is required';
    END IF;
    SELECT s.shipment_id,
    s.shipment_no,
    c.container_number,
    s.consumer_id,
    s.seller_id,
    op.port_name AS origin_port,
    dp.port_name AS dest_port,
    s.status,
    s.etd,
    s.eta,
    s.actual_arrival,
    s.quoted_price
    FROM shipment s
    JOIN containers c ON c.container_id = s.container_id
    JOIN ports op     ON op.port_id     = s.origin_port_id
    JOIN ports dp     ON dp.port_id     = s.dest_port_id
    WHERE (v_role = 'ADMIN'
    OR (v_role = 'SELLER'   AND s.seller_id   = v_company)
    OR (v_role = 'CONSUMER' AND s.consumer_id = v_customer))
    AND (p_container_number IS NULL OR c.container_number = p_container_number)
    AND (p_shipment_id      IS NULL OR s.shipment_id      = p_shipment_id)
    AND (p_port_id          IS NULL OR s.origin_port_id   = p_port_id
    OR s.dest_port_id     = p_port_id)
    AND (p_status           IS NULL OR s.status           = p_status)
    ORDER BY s.shipment_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- Shipment items
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_shipment_item
-- Group: Shipment items
-- Operation: DELETE / controlled correction
-- Purpose: Remove an item from CANCELLED unpaid booking, returning its stock.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_shipment_item(IN p_user_id INT,IN p_item_id INT,IN p_reason VARCHAR(255))
BEGIN
    DECLARE v_ship INT DEFAULT NULL;
    DECLARE v_product INT DEFAULT NULL;
    DECLARE v_qty INT DEFAULT NULL;
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_stock INT DEFAULT NULL;
    DECLARE v_general INT DEFAULT NULL;
    DECLARE v_previous_type VARCHAR(20) DEFAULT NULL;
    DECLARE v_previous_ref_type VARCHAR(30) DEFAULT NULL;
    DECLARE v_previous_ref_id BIGINT DEFAULT NULL;
    DECLARE v_previous_allow INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @ledger_txn_type=v_previous_type;
        SET @ledger_ref_type=v_previous_ref_type;
        SET @ledger_ref_id=v_previous_ref_id;
        SET @shipment_item_delete_id=v_previous_allow;
        ROLLBACK;
        RESIGNAL;
    END;
    IF p_reason IS NULL OR TRIM(p_reason)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Item deletion requires an explanation';
    END IF;
    START TRANSACTION;
    SELECT si.shipment_id,si.product_id,si.quantity,s.seller_id,s.status
    INTO v_ship,v_product,v_qty,v_seller,v_status
    FROM shipment_items si JOIN shipment s ON s.shipment_id=si.shipment_id
    WHERE si.item_id=p_item_id FOR UPDATE;
    IF v_ship IS NULL OR v_status<>'CANCELLED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only items from cancelled shipments can be deleted';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id=p_user_id AND status='ACTIVE'
        AND (role='ADMIN' OR (role='SELLER' AND company_id=v_seller))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only owning Seller/Admin may delete shipment items';
    END IF;
    IF EXISTS(SELECT 1 FROM billing_invoices i JOIN payments p ON p.invoice_id=i.invoice_id
       WHERE i.shipment_id=v_ship)
       OR EXISTS(SELECT 1 FROM claims WHERE shipment_id=v_ship) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paid or claimed shipment items cannot be deleted';
    END IF;
    SELECT MAX(stock_id) INTO v_stock FROM stock
    WHERE shipment_id=v_ship AND product_id=v_product AND quantity=v_qty AND damaged_qty=0;
    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Matching reserved stock missing: cannot safely reverse';
    END IF;
    SET v_previous_type=@ledger_txn_type;
    SET v_previous_ref_type=@ledger_ref_type;
    SET v_previous_ref_id=@ledger_ref_id;
    SET v_previous_allow=@shipment_item_delete_id;
    SET @ledger_txn_type='OUT';
    SET @ledger_ref_type='SHIPMENT';
    SET @ledger_ref_id=v_ship;
    UPDATE stock SET quantity=0 WHERE stock_id=v_stock;
    SELECT MIN(stock_id) INTO v_general FROM stock
    WHERE product_id=v_product AND shipment_id IS NULL AND container_id IS NULL;
    SET @ledger_txn_type='IN';
    IF v_general IS NULL THEN
        INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty)
        VALUES(v_product,NULL,NULL,v_qty,0);
    ELSE
        UPDATE stock SET quantity=quantity+v_qty WHERE stock_id=v_general;
    END IF;
    SET @ledger_txn_type=v_previous_type;
    SET @ledger_ref_type=v_previous_ref_type;
    SET @ledger_ref_id=v_previous_ref_id;
    SET @shipment_item_delete_id=p_item_id;
    DELETE FROM shipment_items WHERE item_id=p_item_id;
    CALL sp_record_audit_action(p_user_id,'DELETE','shipment_items',p_item_id,
       JSON_OBJECT('shipment_id',v_ship,'product_id',v_product,'quantity',v_qty,'reason',p_reason),NULL,NULL);
    SET @shipment_item_delete_id=v_previous_allow;
    COMMIT;
    SELECT p_item_id AS deleted_item_id,v_qty AS returned_to_general_stock;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_shipment_items
-- Group: Shipment items
-- Operation: SHOW / list records
-- Purpose: Display shipment items while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_shipment_items(IN p_shipment_id INT)
BEGIN
    SELECT si.*,
    p.sku,
    p.product_name
    FROM shipment_items si JOIN products p ON p.product_id = si.product_id
    WHERE p_shipment_id IS NULL OR si.shipment_id = p_shipment_id
    ORDER BY si.item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_shipment_items
-- Group: Shipment items
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search shipment items while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_shipment_items(IN p_shipment_id INT,
IN p_product_id INT)
BEGIN
    SELECT si.*,
    p.sku,
    p.product_name
    FROM shipment_items si JOIN products p ON p.product_id = si.product_id
    WHERE (p_shipment_id IS NULL OR si.shipment_id = p_shipment_id)
    AND (p_product_id IS NULL OR si.product_id = p_product_id)
    ORDER BY si.item_id;
END$$

-- ----------------------------------------------------------------------------
-- Movement tracking
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_container_movement
-- Group: Movement tracking
-- Operation: CREATE / INSERT
-- Purpose: Insert container movement while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_container_movement(
IN p_shipment_id    INT,
IN p_status         VARCHAR(20),
IN p_port_id        INT,
IN p_location_text  VARCHAR(150),
IN p_event_time     DATETIME,
IN p_remarks        VARCHAR(255),
IN p_updated_by     INT
)
BEGIN
    DECLARE v_container INT DEFAULT NULL;
    SELECT container_id
    INTO v_container
    FROM shipment
    WHERE shipment_id = p_shipment_id;
    IF v_container IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR2.3: shipment does not exist';
    END IF;
    IF p_status = 'BOOKED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR2.2: the BOOKED event is created automatically
        by booking';
    END IF;
    INSERT INTO container_movements (
    shipment_id,
    container_id,
    status,
    port_id,
    location_text,
    event_time,
    remarks,
    updated_by
    )
    VALUES (
    p_shipment_id,
    v_container,
    p_status,
    p_port_id,
    p_location_text,
    COALESCE(p_event_time, NOW()),
    p_remarks,
    p_updated_by
    );
    SELECT LAST_INSERT_ID() AS movement_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_container_movement
-- Group: Movement tracking
-- Operation: DELETE / controlled correction
-- Purpose: Correct only the latest mistaken event; retain earlier events + audit.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_container_movement(IN p_user_id INT,IN p_movement_id BIGINT,IN p_reason VARCHAR(255))
BEGIN
    DECLARE v_ship INT DEFAULT NULL;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_latest BIGINT DEFAULT NULL;
    DECLARE v_previous VARCHAR(20) DEFAULT NULL;
    DECLARE v_previous_port INT DEFAULT NULL;
    DECLARE v_origin INT DEFAULT NULL;
    DECLARE v_previous_allowed BIGINT DEFAULT NULL;
    DECLARE v_previous_ship INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @movement_delete_id=v_previous_allowed;
        SET @movement_correction_shipment_id=v_previous_ship;
        ROLLBACK;
        RESIGNAL;
    END;
    IF p_reason IS NULL OR TRIM(p_reason)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Movement deletion requires a correction reason';
    END IF;
    START TRANSACTION;
    SELECT cm.shipment_id,cm.container_id,cm.status,s.seller_id,s.origin_port_id
    INTO v_ship,v_container,v_status,v_seller,v_origin
    FROM container_movements cm JOIN shipment s ON s.shipment_id=cm.shipment_id
    WHERE cm.movement_id=p_movement_id FOR UPDATE;
    IF v_ship IS NULL OR v_status IN ('BOOKED','DELIVERED','CANCELLED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booked or terminal movement cannot be deleted';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id=p_user_id AND status='ACTIVE'
        AND (role='ADMIN' OR (role='SELLER' AND company_id=v_seller))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only owning Seller/Admin may correct movements';
    END IF;
    IF EXISTS(SELECT 1 FROM claims WHERE shipment_id=v_ship) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Movement with claim history cannot be deleted';
    END IF;
    SELECT MAX(movement_id) INTO v_latest FROM container_movements WHERE shipment_id=v_ship;
    IF v_latest<>p_movement_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only the latest movement may be corrected';
    END IF;
    SELECT cm.status,cm.port_id INTO v_previous,v_previous_port FROM container_movements cm
    WHERE cm.shipment_id=v_ship AND cm.movement_id<p_movement_id
    ORDER BY cm.movement_id DESC LIMIT 1;
    IF v_previous IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Previous movement is required';
    END IF;
    SET v_previous_allowed=@movement_delete_id;
    SET v_previous_ship=@movement_correction_shipment_id;
    SET @movement_delete_id=p_movement_id;
    SET @movement_correction_shipment_id=v_ship;
    DELETE FROM container_movements WHERE movement_id=p_movement_id;
    UPDATE shipment SET status=v_previous,
        actual_arrival=IF(v_previous IN ('ARRIVED','CUSTOMS_CLEARED'),actual_arrival,NULL)
    WHERE shipment_id=v_ship;
    UPDATE containers SET status=IF(v_previous IN ('DEPARTED','IN_TRANSIT','ARRIVED','CUSTOMS_CLEARED'),
          'IN_TRANSIT','ALLOCATED'),current_port_id=COALESCE(v_previous_port,v_origin)
    WHERE container_id=v_container;
    CALL sp_record_audit_action(p_user_id,'DELETE','container_movements',p_movement_id,
        JSON_OBJECT('shipment_id',v_ship,'status',v_status,'reason',p_reason),
        JSON_OBJECT('restored_status',v_previous),NULL);
    SET @movement_delete_id=v_previous_allowed;
    SET @movement_correction_shipment_id=v_previous_ship;
    COMMIT;
    SELECT p_movement_id AS deleted_movement_id,v_previous AS restored_shipment_status;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_container_movements
-- Group: Movement tracking
-- Operation: SHOW / list records
-- Purpose: Display container movements while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_container_movements(
IN p_shipment_id INT
)
BEGIN
    SELECT m.*,
    s.shipment_no,
    c.container_number,
    p.port_name,
    u.full_name AS updated_by_name
    FROM container_movements m
    JOIN shipment   s ON s.shipment_id  = m.shipment_id
    JOIN containers c ON c.container_id = m.container_id
    LEFT JOIN ports p ON p.port_id      = m.port_id
    LEFT JOIN users u ON u.user_id      = m.updated_by
    WHERE p_shipment_id IS NULL
    OR m.shipment_id = p_shipment_id
    ORDER BY m.event_time DESC, m.movement_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_container_movements
-- Group: Movement tracking
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search container movements while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_container_movements(
    IN p_user_id INT,IN p_shipment_id INT,IN p_status VARCHAR(20),
    IN p_start_date DATE,IN p_end_date DATE)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    IF p_start_date IS NOT NULL AND p_end_date IS NOT NULL AND p_start_date>p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid movement date range';
    END IF;
    SELECT m.* FROM container_movements m JOIN shipment sh ON sh.shipment_id=m.shipment_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND sh.seller_id=v_company)
        OR (v_role='CONSUMER' AND sh.consumer_id=v_customer))
       AND (p_shipment_id IS NULL OR m.shipment_id=p_shipment_id)
       AND (p_status IS NULL OR m.status=p_status)
       AND (p_start_date IS NULL OR DATE(m.event_time)>=p_start_date)
       AND (p_end_date IS NULL OR DATE(m.event_time)<=p_end_date)
     ORDER BY m.event_time DESC,m.movement_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_shipment_timeline
-- Group: Movement tracking
-- Operation: GET / detail report
-- Purpose: Return shipment timeline while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_shipment_timeline(
IN p_user_id      INT,
IN p_shipment_id  INT
)
BEGIN
    DECLARE v_role     VARCHAR(10) DEFAULT NULL;
    DECLARE v_company  INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    DECLARE v_ok       INT DEFAULT 0;
    SELECT role, company_id
    INTO v_role, v_company
    FROM users
    WHERE user_id = p_user_id
    AND status = 'ACTIVE';
    SELECT customer_id
    INTO v_customer
    FROM customers
    WHERE user_id = p_user_id;
    SELECT COUNT(*)
    INTO v_ok
    FROM shipment s
    WHERE s.shipment_id = p_shipment_id
    AND (v_role = 'ADMIN'
    OR (v_role = 'SELLER'   AND s.seller_id   = v_company)
    OR (v_role = 'CONSUMER' AND s.consumer_id = v_customer));
    IF v_ok = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR1.3: you are not allowed to view this shipment';
    END IF;
    SELECT s.shipment_id,
    s.shipment_no,
    s.status AS current_status,
    c.container_number,
    op.port_name AS point_a,
    dp.port_name AS point_b,
    s.etd,
    s.eta AS estimated_arrival,
    s.actual_arrival,
    CASE
    WHEN s.eta IS NULL THEN 0
    WHEN s.actual_arrival IS NOT NULL THEN IF(s.actual_arrival > s.eta,
    1, 0)
    WHEN s.status = 'CANCELLED' THEN 0
    ELSE IF(CURDATE() > s.eta, 1, 0)
    END AS is_delayed
    FROM shipment s
    JOIN containers c ON c.container_id = s.container_id
    JOIN ports op     ON op.port_id     = s.origin_port_id
    JOIN ports dp     ON dp.port_id     = s.dest_port_id
    WHERE s.shipment_id = p_shipment_id;
    SELECT m.movement_id,
    m.status,
    p.port_name,
    m.location_text,
    m.event_time,
    m.remarks,
    u.full_name AS updated_by_name
    FROM container_movements m
    LEFT JOIN ports p ON p.port_id = m.port_id
    LEFT JOIN users u ON u.user_id = m.updated_by
    WHERE m.shipment_id = p_shipment_id
    ORDER BY m.event_time, m.movement_id;
END$$

-- ============================================================================
-- MODULE 3 — Container Allocation, Booking and Pricing — 17 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Containers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_container
-- Group: Containers
-- Operation: CREATE / INSERT
-- Purpose: Insert container while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_container(IN p_container_number VARCHAR(15),
IN p_seller_id INT,
IN p_container_type VARCHAR(10),
IN p_size_ft TINYINT,
IN p_max_weight_kg DECIMAL(10,2),
IN p_max_volume_cbm DECIMAL(8,2),
IN p_current_port_id INT)
BEGIN
    INSERT INTO containers (container_number,
    seller_id,
    container_type,
    size_ft,
    max_weight_kg,
    max_volume_cbm,
    current_port_id)
    VALUES (p_container_number,
    p_seller_id,
    p_container_type,
    p_size_ft,
    p_max_weight_kg,
    p_max_volume_cbm,
    p_current_port_id);
    SELECT LAST_INSERT_ID() AS container_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_container_field
-- Group: Containers
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update container field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_container_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM containers t JOIN users u ON u.user_id=p_user_id AND u.role='SELLER' AND u.status='ACTIVE' AND u.company_id=t.seller_id WHERE t.container_id=p_record_id;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;
    -- Confirmed and moving containers cannot be edited as master inventory.
    IF NOT EXISTS (SELECT 1 FROM containers WHERE container_id=p_record_id AND status IN ('AVAILABLE','MAINTENANCE')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Allocated or in-transit container is not editable';
    END IF;
    IF EXISTS (SELECT 1 FROM shipment WHERE container_id=p_record_id AND status NOT IN ('CANCELLED','DELIVERED')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Active shipment prevents container metadata edits';
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'container_number' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value) = '' OR CHAR_LENGTH(p_new_value) > 15 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid text value for container_number';
        END IF;
        UPDATE containers SET container_number = p_new_value WHERE container_id = p_record_id;
    ELSEIF p_field_name = 'container_type' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('DRY','REEFER','OPEN_TOP','TANK') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid container_type value';
        END IF;
        UPDATE containers SET container_type = p_new_value WHERE container_id = p_record_id;
    ELSEIF p_field_name = 'size_ft' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('20','40') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid size_ft value';
        END IF;
        UPDATE containers SET size_ft = p_new_value WHERE container_id = p_record_id;
    ELSEIF p_field_name = 'max_weight_kg' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,8}([.][0-9]{1,2})?$' OR CAST(p_new_value AS DECIMAL(18,5)) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for max_weight_kg';
        END IF;
        UPDATE containers SET max_weight_kg = CAST(p_new_value AS DECIMAL(10,2)) WHERE container_id = p_record_id;
    ELSEIF p_field_name = 'max_volume_cbm' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,6}([.][0-9]{1,2})?$' OR CAST(p_new_value AS DECIMAL(18,5)) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for max_volume_cbm';
        END IF;
        UPDATE containers SET max_volume_cbm = CAST(p_new_value AS DECIMAL(8,2)) WHERE container_id = p_record_id;
    ELSEIF p_field_name = 'current_port_id' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}$' OR CAST(p_new_value AS UNSIGNED) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid integer for current_port_id';
        END IF;
        UPDATE containers SET current_port_id = CAST(p_new_value AS UNSIGNED) WHERE container_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','containers',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM containers WHERE container_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_container
-- Group: Containers
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove container while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_container(IN p_container_id INT)
BEGIN
    DELETE FROM containers WHERE container_id = p_container_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_containers
-- Group: Containers
-- Operation: SHOW / list records
-- Purpose: Display containers while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_containers(IN p_seller_id INT)
BEGIN
    SELECT c.*,
    co.company_name AS seller_company,
    p.port_name AS current_port
    FROM containers c
    JOIN companies co ON co.company_id = c.seller_id
    LEFT JOIN ports p ON p.port_id = c.current_port_id
    WHERE p_seller_id IS NULL OR c.seller_id = p_seller_id
    ORDER BY c.container_number;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_containers
-- Group: Containers
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search containers while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_containers(
IN p_seller_id INT,
IN p_keyword VARCHAR(100),
IN p_container_type VARCHAR(10),
IN p_status VARCHAR(15),
IN p_port_id INT
)
BEGIN
    SELECT
    c.*,
    co.company_name AS seller_company,
    p.port_name AS current_port
    FROM containers c
    JOIN companies co ON co.company_id = c.seller_id
    LEFT JOIN ports p ON p.port_id = c.current_port_id
    WHERE (p_seller_id IS NULL OR c.seller_id = p_seller_id)
    AND (p_keyword IS NULL OR c.container_number LIKE CONCAT('%', p_keyword, '%'))
    AND (p_container_type IS NULL OR c.container_type = p_container_type)
    AND (p_status IS NULL OR c.status = p_status)
    AND (p_port_id IS NULL OR c.current_port_id = p_port_id)
    ORDER BY c.container_number;
END$$

-- ----------------------------------------------------------------------------
-- Booking and quotation
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_calculate_quote
-- Group: Booking and quotation
-- Operation: Business logic / processing
-- Purpose: Calculate quote while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_calculate_quote(
    IN p_user_id INT, IN p_origin_port_id INT, IN p_dest_port_id INT,
    IN p_booking_date DATE, IN p_items_json JSON
)
BEGIN
    CALL sp_process_booking(p_user_id,p_origin_port_id,p_dest_port_id,
                            p_booking_date,p_items_json,NULL,'QUOTE');
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_confirm_booking
-- Group: Booking and quotation
-- Operation: Business logic / processing
-- Purpose: Execute confirm booking using existing database business rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_confirm_booking(
    IN p_user_id INT, IN p_origin_port_id INT, IN p_dest_port_id INT,
    IN p_booking_date DATE, IN p_items_json JSON, IN p_due_date DATE
)
BEGIN
    CALL sp_process_booking(p_user_id,p_origin_port_id,p_dest_port_id,
                            p_booking_date,p_items_json,p_due_date,'CONFIRM');
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_process_booking
-- Group: Booking and quotation
-- Operation: Business logic / processing
-- Purpose: Quote/confirm using item unit_cbm inputs; reserve stock and bill atomically.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_process_booking(
    IN p_user_id INT,
    IN p_origin_port_id INT,
    IN p_dest_port_id INT,
    IN p_booking_date DATE,
    IN p_items_json JSON,
    IN p_due_date DATE,
    IN p_mode VARCHAR(10)
)
BEGIN
    -- Booking uses JSON_EXTRACT loops, compatible with XAMPP MariaDB 10.4.
    -- JSON item format: {"product_id":1,"quantity":2,"unit_cbm":0.25}.
    -- No JSON_TABLE, temporary tables, additional schema attributes or SQL events.
    DECLARE v_customer INT DEFAULT NULL;
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_item_seller INT DEFAULT NULL;
    DECLARE v_invalid INT DEFAULT 0;
    DECLARE v_json_len INT DEFAULT 0;
    DECLARE v_idx INT DEFAULT 0;
    DECLARE v_j INT DEFAULT 0;
    DECLARE v_pid_text VARCHAR(100) DEFAULT NULL;
    DECLARE v_qty_text VARCHAR(100) DEFAULT NULL;
    DECLARE v_unit_cbm_text VARCHAR(100) DEFAULT NULL;
    DECLARE v_previous_pid_text VARCHAR(100) DEFAULT NULL;
    DECLARE v_previous_qty_text VARCHAR(100) DEFAULT NULL;
    DECLARE v_product INT DEFAULT NULL;
    DECLARE v_needed INT DEFAULT 0;
    DECLARE v_combined_needed BIGINT DEFAULT 0;
    DECLARE v_item_weight DECIMAL(8,3) DEFAULT NULL;
    DECLARE v_item_price DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_item_name VARCHAR(120) DEFAULT NULL;
    DECLARE v_item_cbm DECIMAL(18,3) DEFAULT 0;
    DECLARE v_item_volume DECIMAL(18,3) DEFAULT 0;
    DECLARE v_weight_raw DECIMAL(18,3) DEFAULT 0;
    DECLARE v_volume_raw DECIMAL(18,3) DEFAULT 0;
    DECLARE v_weight DECIMAL(10,2) DEFAULT 0;
    DECLARE v_volume DECIMAL(8,2) DEFAULT 0;
    DECLARE v_goods_value DECIMAL(14,2) DEFAULT 0;
    DECLARE v_verified_goods DECIMAL(14,2) DEFAULT 0;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_type VARCHAR(10) DEFAULT NULL;
    DECLARE v_rule_id INT DEFAULT NULL;
    DECLARE v_base DECIMAL(12,2) DEFAULT 0;
    DECLARE v_per_kg DECIMAL(8,4) DEFAULT 0;
    DECLARE v_per_cbm DECIMAL(8,2) DEFAULT 0;
    DECLARE v_season DECIMAL(4,2) DEFAULT 1;
    DECLARE v_demand DECIMAL(4,2) DEFAULT 1;
    DECLARE v_handling DECIMAL(12,2) DEFAULT 0;
    DECLARE v_freight DECIMAL(12,2) DEFAULT 0;
    DECLARE v_shipping_freight DECIMAL(12,2) DEFAULT 0;
    DECLARE v_gst_rate DECIMAL(5,2) DEFAULT NULL;
    DECLARE v_tax DECIMAL(12,2) DEFAULT 0;
    DECLARE v_subtotal DECIMAL(12,2) DEFAULT 0;
    DECLARE v_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_shipment_id INT DEFAULT NULL;
    DECLARE v_shipment_no VARCHAR(20) DEFAULT NULL;
    DECLARE v_invoice_id INT DEFAULT NULL;
    DECLARE v_invoice_no VARCHAR(20) DEFAULT NULL;
    DECLARE v_description VARCHAR(255) DEFAULT NULL;
    DECLARE v_stock_id INT DEFAULT NULL;
    DECLARE v_stock_available INT DEFAULT 0;
    DECLARE v_remaining INT DEFAULT 0;
    DECLARE v_take INT DEFAULT 0;
    DECLARE v_not_found BOOLEAN DEFAULT FALSE;
    DECLARE v_started_transaction BOOLEAN DEFAULT FALSE;
    DECLARE v_previous_ledger_ref_type VARCHAR(30) DEFAULT NULL;
    DECLARE v_previous_ledger_ref_id BIGINT DEFAULT NULL;
    DECLARE v_previous_ledger_txn_type VARCHAR(20) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_not_found=TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        IF v_started_transaction THEN ROLLBACK; END IF;
        SET @ledger_ref_type=v_previous_ledger_ref_type;
        SET @ledger_ref_id=v_previous_ledger_ref_id;
        SET @ledger_txn_type=v_previous_ledger_txn_type;
        RESIGNAL;
    END;

    -- Keep trigger context from the calling session intact after execution.
    SET v_previous_ledger_ref_type=@ledger_ref_type;
    SET v_previous_ledger_ref_id=@ledger_ref_id;
    SET v_previous_ledger_txn_type=@ledger_txn_type;

    -- Step 1: Validate booking identity, route, mode and item JSON.
    IF p_mode IS NULL OR p_mode NOT IN ('QUOTE','CONFIRM') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: mode must be QUOTE or CONFIRM';
    END IF;
    IF p_origin_port_id IS NULL OR p_dest_port_id IS NULL
       OR p_origin_port_id=p_dest_port_id OR p_booking_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: valid distinct ports and date required';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM ports WHERE port_id=p_origin_port_id)
       OR NOT EXISTS(SELECT 1 FROM ports WHERE port_id=p_dest_port_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: selected port does not exist';
    END IF;
    IF p_items_json IS NULL OR JSON_VALID(p_items_json)=0
       OR JSON_TYPE(p_items_json)<>'ARRAY' OR JSON_LENGTH(p_items_json)=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: non-empty goods JSON array required';
    END IF;
    IF p_mode='CONFIRM' AND p_due_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR5.1: due date is required';
    END IF;
    SELECT MAX(cu.customer_id) INTO v_customer
    FROM users u JOIN customers cu ON cu.user_id=u.user_id
    WHERE u.user_id=p_user_id AND u.role='CONSUMER' AND u.status='ACTIVE';
    IF v_customer IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR1.3: active Consumer required for booking';
    END IF;

    -- Step 2: Strictly validate each item before casting JSON values to numbers.
    SET v_json_len=JSON_LENGTH(p_items_json);
    SET v_idx=0;
    WHILE v_idx<v_json_len DO
        SET v_pid_text=JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].product_id')));
        SET v_qty_text=JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].quantity')));
        SET v_unit_cbm_text=JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].unit_cbm')));
        IF v_pid_text IS NULL OR v_qty_text IS NULL
           OR v_pid_text NOT REGEXP '^[1-9][0-9]*$'
           OR v_qty_text NOT REGEXP '^[1-9][0-9]*$'
           OR CHAR_LENGTH(v_pid_text)>10 OR CHAR_LENGTH(v_qty_text)>10
           OR CAST(v_pid_text AS DECIMAL(20,0))>2147483647
           OR CAST(v_qty_text AS DECIMAL(20,0))>2147483647 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='FR3.2: positive integer product_id and quantity required';
        END IF;
        -- The SRS products table has no volume field; booking JSON carries CBM/unit.
        IF v_unit_cbm_text IS NULL
           OR v_unit_cbm_text NOT REGEXP '^[0-9]{1,6}([.][0-9]{1,3})?$'
           OR CAST(v_unit_cbm_text AS DECIMAL(18,3))<=0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='FR3.4: positive unit_cbm (max 3 decimals) required';
        END IF;
        SET v_idx=v_idx+1;
    END WHILE;

    -- Step 3: Validate product existence, seller ownership, stock and cargo limits.
    SET v_idx=0;
    WHILE v_idx<v_json_len DO
        SET v_product=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].product_id'))) AS UNSIGNED);
        SET v_needed=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].quantity'))) AS UNSIGNED);
        SET v_item_cbm=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].unit_cbm'))) AS DECIMAL(18,3));
        IF NOT EXISTS(SELECT 1 FROM products WHERE product_id=v_product) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: one or more products do not exist';
        END IF;
        SELECT owner_company_id,unit_weight_kg,unit_price,product_name
          INTO v_item_seller,v_item_weight,v_item_price,v_item_name
          FROM products WHERE product_id=v_product;
        IF v_item_weight IS NULL OR v_item_weight<=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.4: product unit weight must be positive';
        END IF;
        IF v_seller IS NULL THEN SET v_seller=v_item_seller; END IF;
        IF v_item_seller<>v_seller THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.2: all goods must belong to one Seller';
        END IF;
        SET v_item_volume=v_needed*v_item_cbm;
        IF ROUND(v_item_volume,2)<=0 OR ROUND(v_item_volume,2)>999999.99 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.4: item volume exceeds shipment_items precision';
        END IF;
        SET v_weight_raw=v_weight_raw+v_needed*v_item_weight;
        SET v_volume_raw=v_volume_raw+v_item_volume;
        SET v_goods_value=v_goods_value+v_needed*v_item_price;

        -- Count all occurrences of a product, preventing double-booking with duplicates.
        SET v_combined_needed=0;
        SET v_j=0;
        WHILE v_j<v_json_len DO
            SET v_previous_pid_text=JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_j,'].product_id')));
            IF CAST(v_previous_pid_text AS UNSIGNED)=v_product THEN
                SET v_previous_qty_text=JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_j,'].quantity')));
                SET v_combined_needed=v_combined_needed+CAST(v_previous_qty_text AS UNSIGNED);
            END IF;
            SET v_j=v_j+1;
        END WHILE;
        SELECT COALESCE(SUM(quantity-damaged_qty),0) INTO v_stock_available
        FROM stock WHERE product_id=v_product AND shipment_id IS NULL AND container_id IS NULL;
        IF v_stock_available<v_combined_needed THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.6: insufficient general stock';
        END IF;
        SET v_idx=v_idx+1;
    END WHILE;
    IF v_weight_raw<=0 OR v_volume_raw<=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.4: cargo kg and CBM must be positive';
    END IF;
    IF v_weight_raw>99999999.99 OR v_volume_raw>999999.99 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.4: cargo exceeds shipment precision';
    END IF;
    SET v_weight=ROUND(v_weight_raw,2);
    SET v_volume=ROUND(v_volume_raw,2);
    IF v_weight<=0 OR v_volume<=0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.4: rounded cargo kg and CBM must be positive';
    END IF;

    -- Step 4: Find a suitable available container and active pricing rule.
    IF p_mode='CONFIRM' THEN
        START TRANSACTION;
        SET v_started_transaction=TRUE;
    END IF;
    SET v_not_found=FALSE;
    IF p_mode='CONFIRM' THEN
        SELECT c.container_id,c.container_type,r.rule_id,r.base_rate,r.rate_per_kg,
               r.rate_per_cbm,r.season_multiplier,r.demand_multiplier
        INTO v_container,v_type,v_rule_id,v_base,v_per_kg,v_per_cbm,v_season,v_demand
        FROM containers c JOIN pricing_rules r
          ON r.seller_id=c.seller_id AND r.origin_port_id=p_origin_port_id
         AND r.dest_port_id=p_dest_port_id AND r.container_type=c.container_type
        WHERE c.seller_id=v_seller AND c.current_port_id=p_origin_port_id
          AND c.status='AVAILABLE' AND c.max_weight_kg>=v_weight_raw
          AND c.max_volume_cbm>=v_volume_raw AND r.is_active=TRUE
          AND (r.valid_from IS NULL OR r.valid_from<=p_booking_date)
          AND (r.valid_to IS NULL OR r.valid_to>=p_booking_date)
        ORDER BY c.max_weight_kg,c.container_id,r.valid_from DESC,r.rule_id DESC
        LIMIT 1 FOR UPDATE;
    ELSE
        SELECT c.container_id,c.container_type,r.rule_id,r.base_rate,r.rate_per_kg,
               r.rate_per_cbm,r.season_multiplier,r.demand_multiplier
        INTO v_container,v_type,v_rule_id,v_base,v_per_kg,v_per_cbm,v_season,v_demand
        FROM containers c JOIN pricing_rules r
          ON r.seller_id=c.seller_id AND r.origin_port_id=p_origin_port_id
         AND r.dest_port_id=p_dest_port_id AND r.container_type=c.container_type
        WHERE c.seller_id=v_seller AND c.current_port_id=p_origin_port_id
          AND c.status='AVAILABLE' AND c.max_weight_kg>=v_weight_raw
          AND c.max_volume_cbm>=v_volume_raw AND r.is_active=TRUE
          AND (r.valid_from IS NULL OR r.valid_from<=p_booking_date)
          AND (r.valid_to IS NULL OR r.valid_to>=p_booking_date)
        ORDER BY c.max_weight_kg,c.container_id,r.valid_from DESC,r.rule_id DESC
        LIMIT 1;
    END IF;
    IF v_not_found OR v_container IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.3/FR3.4: no available container with sufficient kg/CBM and active price';
    END IF;

    -- Step 5: Quote using the faculty-approved pricing formula and configured charges.
    SET v_subtotal=ROUND((v_base+v_weight_raw*COALESCE(v_per_kg,0)
                         +v_volume_raw*COALESCE(v_per_cbm,0))
                         *COALESCE(v_season,1)*COALESCE(v_demand,1),2);
    SET v_handling=fn_get_pricing_handling_charge(v_rule_id);
    SET v_shipping_freight=v_subtotal-v_handling;
    SET v_gst_rate=fn_get_booking_gst_rate();
    IF v_shipping_freight<0 OR v_handling<0 OR v_goods_value<0 OR v_gst_rate IS NULL
       OR v_gst_rate<0 OR v_gst_rate>100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.5: invalid freight, goods, handling or database GST setting';
    END IF;
    -- Freight Amount contains goods exactly once; handling is separate.
    -- Fail before assigning a DECIMAL(12,2) if it would exceed the SRS precision.
    IF v_goods_value + v_subtotal > 9999999999.99 / (1 + v_gst_rate / 100) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.5: taxable value exceeds invoice precision';
    END IF;
    SET v_freight=v_shipping_freight+v_goods_value;
    SET v_subtotal=v_freight+v_handling;
    SET v_tax=ROUND(v_subtotal*v_gst_rate/100,2);
    SET v_total=v_subtotal+v_tax;
    IF v_total<0 OR v_total>9999999999.99 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.5: total payable exceeds invoice precision';
    END IF;

    -- Step 6: On confirmation, create shipment, reserve stock and generate invoice.
    IF p_mode='CONFIRM' THEN
        -- Build description from goods supplied, without JSON_TABLE or extra tables.
        SET v_description=NULL;
        SET v_idx=0;
        WHILE v_idx<v_json_len DO
            SET v_product=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].product_id'))) AS UNSIGNED);
            SET v_needed=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].quantity'))) AS UNSIGNED);
            SELECT product_name INTO v_item_name FROM products WHERE product_id=v_product;
            SET v_description=LEFT(CONCAT_WS(', ',v_description,CONCAT(v_item_name,' x',v_needed)),255);
            SET v_idx=v_idx+1;
        END WHILE;

        SET v_shipment_no=CONCAT('SHP',UPPER(SUBSTRING(REPLACE(UUID(),'-',''),1,17)));
        INSERT INTO shipment(
            shipment_no,consumer_id,seller_id,container_id,vessel_id,
            origin_port_id,dest_port_id,cargo_description,cargo_weight_kg,
            cargo_volume_cbm,quoted_price,status,etd
        ) VALUES (
            v_shipment_no,v_customer,v_seller,v_container,NULL,p_origin_port_id,
            p_dest_port_id,v_description,v_weight,v_volume,v_total,'BOOKED',p_booking_date
        );
        SET v_shipment_id=LAST_INSERT_ID();
        INSERT INTO container_movements(
            shipment_id,container_id,status,port_id,location_text,event_time,remarks,updated_by
        ) VALUES (
            v_shipment_id,v_container,'BOOKED',p_origin_port_id,
            'Booking confirmed',NOW(),'Created automatically at booking',p_user_id
        );
        UPDATE containers SET status='ALLOCATED'
        WHERE container_id=v_container AND status='AVAILABLE';
        IF ROW_COUNT()<>1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR3.3: container already allocated';
        END IF;

        -- Reserve requested units in shipment-linked stock; triggers keep the ledger.
        SET @ledger_ref_type='SHIPMENT';
        SET @ledger_ref_id=v_shipment_id;
        SET @ledger_txn_type=NULL;
        SET v_idx=0;
        WHILE v_idx<v_json_len DO
            SET v_product=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].product_id'))) AS UNSIGNED);
            SET v_needed=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].quantity'))) AS UNSIGNED);
            SET v_item_cbm=CAST(JSON_UNQUOTE(JSON_EXTRACT(p_items_json,CONCAT('$[',v_idx,'].unit_cbm'))) AS DECIMAL(18,3));
            SET v_remaining=v_needed;
            WHILE v_remaining>0 DO
                SET v_not_found=FALSE;
                SET v_stock_id=NULL;
                SELECT stock_id,quantity-damaged_qty
                  INTO v_stock_id,v_stock_available
                FROM stock
                WHERE product_id=v_product AND shipment_id IS NULL
                  AND container_id IS NULL AND quantity>damaged_qty
                ORDER BY stock_id LIMIT 1 FOR UPDATE;
                IF v_not_found OR v_stock_id IS NULL THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.6: insufficient stock at booking confirmation';
                END IF;
                SET v_take=LEAST(v_remaining,v_stock_available);
                UPDATE stock SET quantity=quantity-v_take
                WHERE stock_id=v_stock_id AND quantity-damaged_qty>=v_take;
                IF ROW_COUNT()<>1 THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.6: stock changed concurrently';
                END IF;
                SET v_remaining=v_remaining-v_take;
            END WHILE;
            INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty)
            VALUES(v_product,v_shipment_id,v_container,v_needed,0);

            -- Each JSON row becomes a shipment item and sales row; duplicated
            -- products remain valid and are included in cumulative capacity checks.
            SELECT unit_price,unit_weight_kg INTO v_item_price,v_item_weight
            FROM products WHERE product_id=v_product;
            INSERT INTO shipment_items(
                shipment_id,product_id,quantity,unit_price,weight_kg,volume_cbm,amount
            ) VALUES (
                v_shipment_id,v_product,v_needed,v_item_price,
                ROUND(v_needed*v_item_weight,2),ROUND(v_needed*v_item_cbm,2),
                ROUND(v_needed*v_item_price,2)
            );
            INSERT INTO sales_transactions(
                product_id,customer_id,shipment_id,quantity,unit_price,total_amount,sale_date
            ) VALUES (
                v_product,v_customer,v_shipment_id,v_needed,v_item_price,
                ROUND(v_needed*v_item_price,2),p_booking_date
            );
            SET v_idx=v_idx+1;
        END WHILE;
        SET @ledger_ref_type=v_previous_ledger_ref_type;
        SET @ledger_ref_id=v_previous_ledger_ref_id;
        SET @ledger_txn_type=v_previous_ledger_txn_type;

        -- Protect the invoice if a product's price changed during confirmation.
        -- All inventory and shipment changes roll back if it differs from the quote.
        SELECT COALESCE(SUM(amount),0) INTO v_verified_goods
          FROM shipment_items WHERE shipment_id=v_shipment_id;
        IF v_verified_goods<>v_goods_value THEN
            SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT='Goods prices changed while booking; retry with a new quotation';
        END IF;

        SET v_invoice_no=CONCAT('INV',UPPER(SUBSTRING(REPLACE(UUID(),'-',''),1,17)));
        INSERT INTO billing_invoices(
            invoice_no,shipment_id,consumer_id,seller_id,sub_total,tax_amount,
            total_amount,paid_amount,status,issue_date,due_date
        ) VALUES (
            v_invoice_no,v_shipment_id,v_customer,v_seller,v_subtotal,v_tax,
            v_total,0,'UNPAID',CURDATE(),p_due_date
        );
        SET v_invoice_id=LAST_INSERT_ID();
        INSERT INTO invoice_line_items(
            invoice_id,item_type,description,quantity,unit_price,amount
        ) VALUES
            (v_invoice_id,'FREIGHT','Freight including purchased goods',1,v_freight,v_freight),
            (v_invoice_id,'HANDLING','Seller handling charge',1,v_handling,v_handling),
            (v_invoice_id,'TAX',CONCAT('GST ',CAST(v_gst_rate AS CHAR),'% on goods, freight and handling'),1,v_tax,v_tax),
            (v_invoice_id,'CUSTOMS','Duty not configured',1,0,0),
            (v_invoice_id,'INSURANCE','Insurance not configured',1,0,0);
        COMMIT;
        SET v_started_transaction=FALSE;
    END IF;

    -- Step 7: Show one consolidated booking or quotation result.
    SELECT p_mode AS booking_action,
           v_seller AS seller_id,v_container AS container_id,
           v_type AS container_type,v_rule_id AS rule_id,
           v_weight AS cargo_weight_kg,v_volume AS cargo_volume_cbm,
           v_goods_value AS goods_value,
           v_shipping_freight AS shipping_freight_only,
           v_gst_rate AS tax_rate_percent,
           v_freight AS freight_amount,v_handling AS handling_amount,
           v_tax AS tax_amount,v_total AS quotation_total,
           v_shipment_id AS shipment_id,v_shipment_no AS shipment_no,
           IF(p_mode='CONFIRM','BOOKED',NULL) AS shipment_status,
           v_invoice_id AS invoice_id,v_invoice_no AS invoice_no;
END$$

-- ----------------------------------------------------------------------------
-- Pricing rules and audit
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_pricing_rule
-- Group: Pricing rules and audit
-- Operation: CREATE / INSERT
-- Purpose: Insert pricing rule while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_pricing_rule(
    IN p_user_id INT,
    IN p_seller_id INT,
    IN p_origin_port_id INT,
    IN p_dest_port_id INT,
    IN p_container_type VARCHAR(10),
    IN p_base_rate DECIMAL(12,2),
    IN p_rate_per_kg DECIMAL(8,4),
    IN p_rate_per_cbm DECIMAL(8,2),
    IN p_season_multiplier DECIMAL(4,2),
    IN p_demand_multiplier DECIMAL(4,2),
    IN p_valid_from DATE,
    IN p_valid_to DATE
)
BEGIN
    DECLARE v_rule_id INT;
    DECLARE v_multiplier DECIMAL(4,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    -- Only the active Seller owning the company may configure this route.
    IF NOT EXISTS (
        SELECT 1 FROM users
        WHERE user_id=p_user_id AND role='SELLER'
          AND company_id=p_seller_id AND status='ACTIVE'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='FR3.6: only the owning active Seller can create pricing rules';
    END IF;
    -- SRS stores one combined multiplier pair in the pricing audit.
    SET v_multiplier=ROUND(COALESCE(p_season_multiplier,1.00)*COALESCE(p_demand_multiplier,1.00),2);
    IF v_multiplier<=0 OR v_multiplier>99.99 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='FR3.6: combined pricing multiplier outside audit precision';
    END IF;
    START TRANSACTION;
    INSERT INTO pricing_rules (
        seller_id,origin_port_id,dest_port_id,container_type,base_rate,
        rate_per_kg,rate_per_cbm,season_multiplier,demand_multiplier,
        valid_from,valid_to
    ) VALUES (
        p_seller_id,p_origin_port_id,p_dest_port_id,p_container_type,
        p_base_rate,COALESCE(p_rate_per_kg,0),COALESCE(p_rate_per_cbm,0),
        COALESCE(p_season_multiplier,1.00),COALESCE(p_demand_multiplier,1.00),
        p_valid_from,p_valid_to
    );
    SET v_rule_id=LAST_INSERT_ID();
    INSERT INTO pricing_audit (
        rule_id,old_rate,new_rate,old_multiplier,new_multiplier,changed_by
    ) VALUES (v_rule_id,NULL,p_base_rate,NULL,v_multiplier,p_user_id);
    COMMIT;
    SELECT v_rule_id AS rule_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_pricing_rule_field
-- Group: Pricing rules and audit
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update pricing rule field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_pricing_rule_field(
    IN p_user_id INT,IN p_record_id INT,
    IN p_field_name VARCHAR(64),IN p_new_value VARCHAR(255)
)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;
    DECLARE v_previous_actor INT DEFAULT NULL;
    DECLARE v_date DATE DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @pricing_actor_user_id=v_previous_actor;
        ROLLBACK;
        RESIGNAL;
    END;
    SELECT seller_id INTO v_owner FROM pricing_rules WHERE rule_id=p_record_id;
    IF v_owner IS NULL OR NOT EXISTS(SELECT 1 FROM users
        WHERE user_id=p_user_id AND role='SELLER' AND company_id=v_owner AND status='ACTIVE') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pricing rule missing or Seller unauthorized';
    END IF;
    SET v_previous_actor=@pricing_actor_user_id;
    START TRANSACTION;
    SET @pricing_actor_user_id=p_user_id;
    IF p_field_name='base_rate' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}([.][0-9]{1,2})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid base rate';
        END IF;
        UPDATE pricing_rules SET base_rate=CAST(p_new_value AS DECIMAL(12,2)) WHERE rule_id=p_record_id;
    ELSEIF p_field_name='rate_per_kg' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,4}([.][0-9]{1,4})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid per-kg rate';
        END IF;
        UPDATE pricing_rules SET rate_per_kg=CAST(p_new_value AS DECIMAL(8,4)) WHERE rule_id=p_record_id;
    ELSEIF p_field_name='rate_per_cbm' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,6}([.][0-9]{1,2})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid per-CBM rate';
        END IF;
        UPDATE pricing_rules SET rate_per_cbm=CAST(p_new_value AS DECIMAL(8,2)) WHERE rule_id=p_record_id;
    ELSEIF p_field_name IN ('season_multiplier','demand_multiplier') THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,2}([.][0-9]{1,2})?$'
           OR CAST(p_new_value AS DECIMAL(18,4))<=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid pricing multiplier';
        END IF;
        IF p_field_name='season_multiplier' THEN
            UPDATE pricing_rules SET season_multiplier=CAST(p_new_value AS DECIMAL(4,2)) WHERE rule_id=p_record_id;
        ELSE
            UPDATE pricing_rules SET demand_multiplier=CAST(p_new_value AS DECIMAL(4,2)) WHERE rule_id=p_record_id;
        END IF;
    ELSEIF p_field_name IN ('valid_from','valid_to') THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid pricing date';
        END IF;
        SET v_date=STR_TO_DATE(p_new_value,'%Y-%m-%d');
        IF v_date IS NULL OR DATE_FORMAT(v_date,'%Y-%m-%d')<>p_new_value THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid pricing date';
        END IF;
        IF p_field_name='valid_from' THEN
            UPDATE pricing_rules SET valid_from=v_date WHERE rule_id=p_record_id;
        ELSE
            UPDATE pricing_rules SET valid_to=v_date WHERE rule_id=p_record_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pricing attribute is not editable';
    END IF;
    COMMIT;
    SET @pricing_actor_user_id=v_previous_actor;
    SELECT * FROM pricing_rules WHERE rule_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_pricing_rule
-- Group: Pricing rules and audit
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove pricing rule while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_pricing_rule(IN p_user_id INT, IN p_rule_id INT)
BEGIN
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_previous_actor INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @pricing_actor_user_id = v_previous_actor;
        ROLLBACK;
        RESIGNAL;
    END;
    SELECT seller_id INTO v_seller FROM pricing_rules WHERE rule_id=p_rule_id;
    IF v_seller IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: pricing rule not found';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id=p_user_id
       AND role='SELLER' AND company_id=v_seller AND status='ACTIVE') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: only owning Seller may deactivate rule';
    END IF;
    SET v_previous_actor = @pricing_actor_user_id;
    START TRANSACTION;
    SET @pricing_actor_user_id = p_user_id;
    UPDATE pricing_rules SET is_active=FALSE WHERE rule_id=p_rule_id;
    COMMIT;
    SET @pricing_actor_user_id = v_previous_actor;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_pricing_audit
-- Group: Pricing rules and audit
-- Operation: SHOW / list records
-- Purpose: Display pricing audit while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_pricing_audit(IN p_rule_id INT)
BEGIN
    SELECT pa.*,
    u.full_name AS changed_by_name
    FROM pricing_audit pa LEFT JOIN users u ON u.user_id = pa.changed_by
    WHERE p_rule_id IS NULL OR pa.rule_id = p_rule_id
    ORDER BY pa.audit_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_pricing_rules
-- Group: Pricing rules and audit
-- Operation: SHOW / list records
-- Purpose: Display pricing rules while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_pricing_rules(IN p_seller_id INT)
BEGIN
    SELECT pr.*,
    op.port_name AS origin_port,
    dp.port_name AS dest_port
    FROM pricing_rules pr
    JOIN ports op ON op.port_id = pr.origin_port_id
    JOIN ports dp ON dp.port_id = pr.dest_port_id
    WHERE p_seller_id IS NULL OR pr.seller_id = p_seller_id
    ORDER BY pr.rule_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_pricing_audit
-- Group: Pricing rules and audit
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search pricing audit while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_pricing_audit(IN p_rule_id INT,
IN p_changed_by INT,
IN p_from_date DATE,
IN p_to_date DATE)
BEGIN
    SELECT pa.*,
    u.full_name AS changed_by_name
    FROM pricing_audit pa LEFT JOIN users u ON u.user_id = pa.changed_by
    WHERE (p_rule_id IS NULL OR pa.rule_id = p_rule_id)
    AND (p_changed_by IS NULL OR pa.changed_by = p_changed_by)
    AND (p_from_date IS NULL OR pa.changed_at >= p_from_date)
    AND (p_to_date IS NULL OR pa.changed_at < DATE_ADD(p_to_date, INTERVAL 1
    DAY))
    ORDER BY pa.changed_at DESC,
    pa.audit_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_pricing_rules
-- Group: Pricing rules and audit
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search pricing rules while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_pricing_rules(IN p_seller_id INT,
IN p_origin_port_id INT,
IN p_dest_port_id INT,
IN p_container_type VARCHAR(10),
IN p_is_active TINYINT)
BEGIN
    SELECT pr.*,
    op.port_name AS origin_port,
    dp.port_name AS dest_port
    FROM pricing_rules pr
    JOIN ports op ON op.port_id = pr.origin_port_id
    JOIN ports dp ON dp.port_id = pr.dest_port_id
    WHERE (p_seller_id IS NULL OR pr.seller_id = p_seller_id)
    AND (p_origin_port_id IS NULL OR pr.origin_port_id = p_origin_port_id)
    AND (p_dest_port_id IS NULL OR pr.dest_port_id = p_dest_port_id)
    AND (p_container_type IS NULL OR pr.container_type = p_container_type)
    AND (p_is_active IS NULL OR pr.is_active = p_is_active)
    ORDER BY pr.rule_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- Booking and allocation reports
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_container_allocation
-- Group: Booking and allocation reports
-- Operation: SHOW / list records
-- Purpose: List products reserved against a booked container, with ownership checks.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_container_allocation(IN p_user_id INT,IN p_container_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users
    WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT customer_id INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required';
    END IF;
    SELECT s.shipment_id,s.shipment_no,s.status,c.container_id,c.container_number,
           si.item_id,p.sku,p.product_name,si.quantity,si.weight_kg,si.volume_cbm,si.amount
    FROM shipment s JOIN containers c ON c.container_id=s.container_id
    JOIN shipment_items si ON si.shipment_id=s.shipment_id
    JOIN products p ON p.product_id=si.product_id
    WHERE c.container_id=p_container_id AND s.status<>'CANCELLED'
      AND (v_role='ADMIN' OR (v_role='SELLER' AND s.seller_id=v_company)
      OR (v_role='CONSUMER' AND s.consumer_id=v_customer))
    ORDER BY s.shipment_id,si.item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_booking_summary
-- Group: Booking and allocation reports
-- Operation: GET / detail report
-- Purpose: Fetch consolidated booking, container, invoice and item-value data.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_booking_summary(IN p_user_id INT,IN p_shipment_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company
    FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    IF v_role='CONSUMER' THEN
        SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    END IF;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR1.3: active user required';
    END IF;
    SELECT v.* FROM vw_booking_summary v
    WHERE (p_shipment_id IS NULL OR v.shipment_id=p_shipment_id)
      AND (v_role='ADMIN'
           OR (v_role='SELLER' AND v.seller_id=v_company)
           OR (v_role='CONSUMER' AND v.consumer_id=v_customer))
    ORDER BY v.shipment_id DESC;
END$$

-- ============================================================================
-- MODULE 4 — Products, Stock and Inventory Management — 16 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Products
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_product
-- Group: Products
-- Operation: CREATE / INSERT
-- Purpose: Insert product while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_product(
    IN p_sku VARCHAR(40),
    IN p_product_name VARCHAR(120),
    IN p_category VARCHAR(60),
    IN p_hs_code VARCHAR(12),
    IN p_unit VARCHAR(10),
    IN p_unit_weight_kg DECIMAL(8,3),
    IN p_unit_price DECIMAL(12,2),
    IN p_owner_company_id INT
)
BEGIN
    -- The SRS products table has no unit-volume column. CBM is provided
    -- per selected item in the booking request and stored in shipment_items.
    IF p_sku IS NULL OR TRIM(p_sku)='' OR p_product_name IS NULL
       OR TRIM(p_product_name)='' OR p_unit_weight_kg IS NULL
       OR p_unit_weight_kg<=0 OR p_unit_price IS NULL OR p_unit_price<0
       OR p_owner_company_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='FR4.1: product identity, positive weight, price and Seller required';
    END IF;
    INSERT INTO products (
        sku,product_name,category,hs_code,unit,unit_weight_kg,unit_price,owner_company_id
    ) VALUES (
        p_sku,p_product_name,p_category,p_hs_code,p_unit,
        p_unit_weight_kg,p_unit_price,p_owner_company_id
    );
    SELECT LAST_INSERT_ID() AS product_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_product_field
-- Group: Products
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update product field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_product_field(
    IN p_user_id INT,IN p_product_id INT,
    IN p_field_name VARCHAR(40),IN p_new_value VARCHAR(255)
)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;
    SELECT MAX(owner_company_id) INTO v_owner
    FROM products WHERE product_id=p_product_id;
    IF v_owner IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: product not found';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users
       WHERE user_id=p_user_id AND role='SELLER'
         AND status='ACTIVE' AND company_id=v_owner) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='FR1.3: only owning Seller may update product';
    END IF;
    -- A field whitelist prevents PK, owner and transaction-history changes.
    IF p_field_name IN ('sku','product_name')
       AND (p_new_value IS NULL OR TRIM(p_new_value)='') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: SKU/name cannot be empty';
    END IF;
    IF p_field_name='sku' THEN
        UPDATE products SET sku=p_new_value WHERE product_id=p_product_id;
    ELSEIF p_field_name='product_name' THEN
        UPDATE products SET product_name=p_new_value WHERE product_id=p_product_id;
    ELSEIF p_field_name='category' THEN
        UPDATE products SET category=p_new_value WHERE product_id=p_product_id;
    ELSEIF p_field_name='hs_code' THEN
        UPDATE products SET hs_code=p_new_value WHERE product_id=p_product_id;
    ELSEIF p_field_name='unit' THEN
        UPDATE products SET unit=p_new_value WHERE product_id=p_product_id;
    ELSEIF p_field_name IN ('unit_weight_kg','unit_price') THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]+([.][0-9]+)?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: numeric value required';
        END IF;
        IF p_field_name='unit_weight_kg' THEN
            IF p_new_value NOT REGEXP '^[0-9]{1,5}([.][0-9]{1,3})?$'
               OR CAST(p_new_value AS DECIMAL(18,5))<=0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: positive weight up to 3 decimals required';
            END IF;
            UPDATE products SET unit_weight_kg=CAST(p_new_value AS DECIMAL(8,3))
            WHERE product_id=p_product_id;
        ELSE
            IF p_new_value NOT REGEXP '^[0-9]{1,10}([.][0-9]{1,2})?$' THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: price supports max 2 decimal places';
            END IF;
            UPDATE products SET unit_price=CAST(p_new_value AS DECIMAL(12,2))
            WHERE product_id=p_product_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR4.1: product field not editable';
    END IF;
    SELECT product_id,sku,product_name,category,hs_code,unit,
           unit_weight_kg,unit_price,owner_company_id
    FROM products WHERE product_id=p_product_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_product
-- Group: Products
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove product while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_product(IN p_product_id INT)
BEGIN
    DELETE FROM products WHERE product_id = p_product_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_products
-- Group: Products
-- Operation: SHOW / list records
-- Purpose: Display products while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_products(IN p_owner_company_id INT)
BEGIN
    SELECT p.*,
    c.company_name AS seller_name
    FROM products p JOIN companies c ON c.company_id = p.owner_company_id
    WHERE p_owner_company_id IS NULL OR p.owner_company_id = p_owner_company_id
    ORDER BY p.product_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_products
-- Group: Products
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search products while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_products(IN p_keyword VARCHAR(100),
IN p_owner_company_id INT)
BEGIN
    SELECT p.*,
    c.company_name AS seller_name
    FROM products p JOIN companies c ON c.company_id = p.owner_company_id
    WHERE (p_keyword IS NULL OR p.sku LIKE CONCAT('%', p_keyword, '%')
    OR p.product_name LIKE CONCAT('%', p_keyword, '%')
    OR p.hs_code LIKE CONCAT('%', p_keyword, '%') OR p.category LIKE
    CONCAT('%', p_keyword, '%'))
    AND (p_owner_company_id IS NULL OR p.owner_company_id = p_owner_company_id)
    ORDER BY p.product_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- Stock
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_stock
-- Group: Stock
-- Operation: CREATE / INSERT
-- Purpose: Insert stock while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_stock(
IN p_product_id INT,
IN p_quantity INT
)
BEGIN
    DECLARE v_product_id INT DEFAULT NULL;
    DECLARE v_stock_id INT DEFAULT NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET v_product_id = NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @ledger_txn_type = NULL;
        SET @ledger_ref_type = NULL;
        SET @ledger_ref_id = NULL;
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR4.2: stock quantity must be a positive number';
    END IF;

    START TRANSACTION;

    -- Lock the product row so simultaneous uploads for the same product do not
    -- both decide that the general-stock row is missing.
    SELECT product_id
    INTO v_product_id
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_product_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR4.2: product does not exist';
    END IF;

    SELECT stock_id
    INTO v_stock_id
    FROM stock
    WHERE product_id = p_product_id
    AND shipment_id IS NULL
    AND container_id IS NULL
    LIMIT 1
    FOR UPDATE;

    SET @ledger_ref_type = 'UPLOAD';
    SET @ledger_ref_id = NULL;

    IF v_stock_id IS NULL THEN
        INSERT INTO stock (product_id, quantity)
        VALUES (p_product_id, p_quantity);
        SET v_stock_id = LAST_INSERT_ID();
    ELSE
        UPDATE stock
        SET quantity = quantity + p_quantity
        WHERE stock_id = v_stock_id;
    END IF;

    SET @ledger_txn_type = NULL;
    SET @ledger_ref_type = NULL;
    SET @ledger_ref_id = NULL;

    COMMIT;
    SELECT v_stock_id AS stock_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_stock_field
-- Group: Stock
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update stock field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_stock_field(
    IN p_user_id INT,IN p_stock_id INT,IN p_field_name VARCHAR(64),IN p_new_value VARCHAR(255)
)
BEGIN
    DECLARE v_owner INT DEFAULT NULL;
    DECLARE v_qty INT DEFAULT NULL;
    DECLARE v_damaged INT DEFAULT NULL;
    DECLARE v_shipment INT DEFAULT NULL;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_new INT DEFAULT NULL;
    DECLARE v_old_ledger_type VARCHAR(20) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @ledger_txn_type=v_old_ledger_type;
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    SELECT p.owner_company_id,s.quantity,s.damaged_qty,s.shipment_id,s.container_id
    INTO v_owner,v_qty,v_damaged,v_shipment,v_container
    FROM stock s JOIN products p ON p.product_id=s.product_id
    WHERE s.stock_id=p_stock_id FOR UPDATE;
    IF v_qty IS NULL OR NOT EXISTS(SELECT 1 FROM users WHERE user_id=p_user_id
       AND role='SELLER' AND status='ACTIVE' AND company_id=v_owner) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Stock not found or Seller unauthorized';
    END IF;
    IF v_shipment IS NOT NULL OR v_container IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Reserved stock cannot be changed manually';
    END IF;
    IF p_field_name IS NULL OR p_field_name NOT IN ('quantity','damaged_qty') OR p_new_value IS NULL
       OR p_new_value NOT REGEXP '^[0-9]{1,9}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only nonnegative stock quantities are editable';
    END IF;
    SET v_new=CAST(p_new_value AS UNSIGNED);
    SET v_old_ledger_type=@ledger_txn_type;
    SET @ledger_txn_type='ADJUST';
    IF p_field_name='quantity' THEN
        IF v_new<v_damaged THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantity below damaged stock';
        END IF;
        UPDATE stock SET quantity=v_new WHERE stock_id=p_stock_id;
    ELSE
        IF v_new>v_qty THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Damaged stock exceeds quantity';
        END IF;
        UPDATE stock SET damaged_qty=v_new WHERE stock_id=p_stock_id;
    END IF;
    SET @ledger_txn_type=v_old_ledger_type;
    COMMIT;
    SELECT * FROM stock WHERE stock_id=p_stock_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_stock
-- Group: Stock
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove stock while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_stock(
    IN p_user_id INT,
    IN p_stock_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_found BOOLEAN DEFAULT TRUE;
    DECLARE v_product INT;
    DECLARE v_quantity INT;
    DECLARE v_damaged_qty INT;
    DECLARE v_shipment INT;
    DECLARE v_container INT;
    DECLARE v_seller INT;
    DECLARE v_authorized INT DEFAULT 0;
    DECLARE v_ledger_count INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_user_id IS NULL OR p_stock_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock ID and actor user ID are required';
    END IF;

    START TRANSACTION;
    SELECT s.product_id, s.quantity, COALESCE(s.damaged_qty, 0),
           s.shipment_id, s.container_id, p.owner_company_id
      INTO v_product, v_quantity, v_damaged_qty, v_shipment, v_container, v_seller
      FROM stock s JOIN products p ON p.product_id = s.product_id
     WHERE s.stock_id = p_stock_id
     FOR UPDATE;

    IF NOT v_found THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock record not found';
    END IF;

    SELECT COUNT(*) INTO v_authorized
      FROM users
     WHERE user_id = p_user_id AND status = 'ACTIVE'
       AND role = 'SELLER' AND company_id = v_seller;
    IF v_authorized <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only the owning Seller can delete stock';
    END IF;

    IF v_shipment IS NOT NULL OR v_container IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete reserved shipment stock';
    END IF;
    IF v_quantity <> 0 OR v_damaged_qty <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reduce stock to zero before deletion';
    END IF;

    SELECT COUNT(*) INTO v_ledger_count
      FROM inventory_ledger WHERE stock_id = p_stock_id;
    IF v_ledger_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete stock with ledger history; preserve its audit record';
    END IF;

    DELETE FROM stock WHERE stock_id = p_stock_id;
    CALL sp_record_audit_action(
        p_user_id, 'DELETE', 'stock', p_stock_id,
        JSON_OBJECT('product_id', v_product, 'quantity', v_quantity), NULL, p_ip_address
    );
    COMMIT;
    SELECT p_stock_id AS deleted_stock_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_stock
-- Group: Stock
-- Operation: SHOW / list records
-- Purpose: Display stock while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_stock(IN p_owner_company_id INT)
BEGIN
    SELECT s.stock_id,
    p.product_id,
    p.sku,
    p.product_name,
    p.owner_company_id,
    s.shipment_id,
    sh.shipment_no,
    s.container_id,
    c.container_number,
    s.quantity,
    s.damaged_qty,
    s.quantity - s.damaged_qty AS usable_qty,
    s.last_updated
    FROM stock s
    JOIN products p ON p.product_id = s.product_id
    LEFT JOIN shipment sh ON sh.shipment_id = s.shipment_id
    LEFT JOIN containers c ON c.container_id = s.container_id
    WHERE p_owner_company_id IS NULL OR p.owner_company_id = p_owner_company_id
    ORDER BY s.stock_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_stock
-- Group: Stock
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search stock while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_stock(IN p_keyword VARCHAR(100),
IN p_owner_company_id INT,
IN p_shipment_id INT)
BEGIN
    SELECT s.stock_id,
    p.product_id,
    p.sku,
    p.product_name,
    p.owner_company_id,
    s.shipment_id,
    s.container_id,
    s.quantity,
    s.damaged_qty,
    s.quantity - s.damaged_qty AS usable_qty,
    s.last_updated
    FROM stock s JOIN products p ON p.product_id = s.product_id
    WHERE (p_keyword IS NULL OR p.sku LIKE CONCAT('%', p_keyword, '%') OR
    p.product_name LIKE CONCAT('%', p_keyword, '%'))
    AND (p_owner_company_id IS NULL OR p.owner_company_id = p_owner_company_id)
    AND (p_shipment_id IS NULL OR s.shipment_id = p_shipment_id)
    ORDER BY s.stock_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_shipment_stock_summary
-- Group: Stock
-- Operation: GET / detail report
-- Purpose: Return shipment stock summary while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_shipment_stock_summary(IN p_shipment_id INT)
BEGIN
    SELECT s.shipment_id,
    p.sku,
    p.product_name,
    s.quantity,
    p.unit_price,
    s.quantity * p.unit_price AS stock_value
    FROM stock s JOIN products p ON p.product_id = s.product_id
    WHERE s.shipment_id = p_shipment_id;
    SELECT s.shipment_id,
    COALESCE(SUM(s.quantity),
    0) AS total_quantity,
    COALESCE(SUM(s.quantity * p.unit_price),
    0) AS total_value
    FROM stock s JOIN products p ON p.product_id = s.product_id
    WHERE s.shipment_id = p_shipment_id
    GROUP BY s.shipment_id;
END$$

-- ----------------------------------------------------------------------------
-- Inventory ledger
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_inventory_ledger
-- Group: Inventory ledger
-- Operation: SHOW / list records
-- Purpose: Display inventory ledger while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_inventory_ledger(IN p_product_id INT)
BEGIN
    SELECT l.*,
    p.sku,
    p.product_name
    FROM inventory_ledger l JOIN products p ON p.product_id = l.product_id
    WHERE p_product_id IS NULL OR l.product_id = p_product_id
    ORDER BY l.ledger_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_inventory_ledger
-- Group: Inventory ledger
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search inventory ledger while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_inventory_ledger(IN p_product_id INT,
IN p_txn_type VARCHAR(15),
IN p_reference_type VARCHAR(30),
IN p_reference_id BIGINT)
BEGIN
    SELECT l.*,
    p.sku,
    p.product_name
    FROM inventory_ledger l JOIN products p ON p.product_id = l.product_id
    WHERE (p_product_id IS NULL OR l.product_id = p_product_id)
    AND (p_txn_type IS NULL OR l.txn_type = p_txn_type)
    AND (p_reference_type IS NULL OR l.reference_type = p_reference_type)
    AND (p_reference_id IS NULL OR l.reference_id = p_reference_id)
    ORDER BY l.ledger_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- Sales transactions
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_sales_transactions
-- Group: Sales transactions
-- Operation: SHOW / list records
-- Purpose: Display sales transactions while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_sales_transactions(IN p_user_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    -- Sales rows are created by booking; users can inspect only their own company records.
    SELECT st.* FROM sales_transactions st
      LEFT JOIN shipment sh ON sh.shipment_id=st.shipment_id
     JOIN products p ON p.product_id=st.product_id
     WHERE v_role='ADMIN' OR (v_role='SELLER' AND p.owner_company_id=v_company)
        OR (v_role='CONSUMER' AND st.customer_id=v_customer)
     ORDER BY st.sale_date DESC,st.sale_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_sales_transactions
-- Group: Sales transactions
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search sales transactions while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_sales_transactions(IN p_product_id INT,
IN p_customer_id INT,
IN p_from_date DATE,
IN p_to_date DATE)
BEGIN
    SELECT st.*,
    p.sku,
    p.product_name
    FROM sales_transactions st JOIN products p ON p.product_id = st.product_id
    WHERE (p_product_id IS NULL OR st.product_id = p_product_id)
    AND (p_customer_id IS NULL OR st.customer_id = p_customer_id)
    AND (p_from_date IS NULL OR st.sale_date >= p_from_date)
    AND (p_to_date IS NULL OR st.sale_date <= p_to_date)
    ORDER BY st.sale_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_sales_transactions_for_user
-- Group: Sales transactions
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search sales transactions for user while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_sales_transactions_for_user(
    IN p_user_id INT,IN p_product_id INT,IN p_customer_id INT,
    IN p_start_date DATE,IN p_end_date DATE)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    -- Detailed sales search with the same ownership restriction as SHOW.
    IF p_start_date IS NOT NULL AND p_end_date IS NOT NULL AND p_start_date>p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid sales date range';
    END IF;
    SELECT st.* FROM sales_transactions st LEFT JOIN shipment sh ON sh.shipment_id=st.shipment_id
     JOIN products p ON p.product_id=st.product_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND p.owner_company_id=v_company)
          OR (v_role='CONSUMER' AND st.customer_id=v_customer))
       AND (p_product_id IS NULL OR st.product_id=p_product_id)
       AND (p_customer_id IS NULL OR st.customer_id=p_customer_id)
       AND (p_start_date IS NULL OR st.sale_date>=p_start_date)
       AND (p_end_date IS NULL OR st.sale_date<=p_end_date)
     ORDER BY st.sale_date DESC,st.sale_id DESC;
END$$

-- ============================================================================
-- MODULE 5 — Billing, Invoices and Payments — 19 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Invoices
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_invoice
-- Group: Invoices
-- Operation: CREATE / INSERT
-- Purpose: Insert invoice while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_invoice(
    IN p_user_id INT,
    IN p_shipment_id INT,
    IN p_due_date DATE,
    IN p_freight DECIMAL(12,2),
    IN p_handling DECIMAL(12,2),
    IN p_customs DECIMAL(12,2),
    IN p_insurance DECIMAL(12,2),
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_found BOOLEAN DEFAULT TRUE;
    DECLARE v_seller INT;
    DECLARE v_consumer INT;
    DECLARE v_ship_status VARCHAR(20);
    DECLARE v_quote DECIMAL(12,2);
    DECLARE v_authorized INT DEFAULT 0;
    DECLARE v_existing INT DEFAULT 0;
    DECLARE v_sub_total DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_gst_rate DECIMAL(5,2) DEFAULT NULL;
    DECLARE v_total DECIMAL(12,2);
    DECLARE v_invoice_id INT;
    DECLARE v_invoice_no VARCHAR(20);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_due_date IS NULL OR p_due_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice due date must be today or later';
    END IF;
    IF p_freight IS NULL OR p_handling IS NULL OR p_customs IS NULL OR p_insurance IS NULL
       OR p_freight < 0 OR p_handling < 0 OR p_customs < 0 OR p_insurance < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All invoice charges must be nonnegative';
    END IF;

    START TRANSACTION;
    SELECT seller_id, consumer_id, status, quoted_price
      INTO v_seller, v_consumer, v_ship_status, v_quote
      FROM shipment WHERE shipment_id = p_shipment_id FOR UPDATE;
    IF NOT v_found THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment does not exist';
    END IF;

    SELECT COUNT(*) INTO v_authorized FROM users
     WHERE user_id = p_user_id AND role = 'SELLER'
       AND status = 'ACTIVE' AND company_id = v_seller;
    IF v_authorized <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only the responsible Seller can repair the invoice';
    END IF;
    IF v_ship_status = 'CANCELLED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot invoice a cancelled shipment';
    END IF;
    SELECT COUNT(*) INTO v_existing FROM billing_invoices WHERE shipment_id = p_shipment_id;
    IF v_existing > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment already has its automatically generated invoice';
    END IF;

    SET v_sub_total = p_freight + p_handling + p_customs + p_insurance;
    SET v_gst_rate = fn_get_booking_gst_rate();
    IF v_gst_rate IS NULL OR v_gst_rate < 0 OR v_gst_rate > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid database GST rate';
    END IF;
    SET v_tax = ROUND((p_freight + p_handling) * v_gst_rate / 100, 2);
    SET v_total = v_sub_total + v_tax;
    IF v_total <> v_quote THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice amounts must match the confirmed shipment quote';
    END IF;

    SET v_invoice_no = CONCAT('INV', UPPER(SUBSTRING(REPLACE(UUID(), '-', ''), 1, 17)));
    INSERT INTO billing_invoices (
        invoice_no, shipment_id, consumer_id, seller_id,
        sub_total, tax_amount, total_amount, paid_amount, status,
        issue_date, due_date
    ) VALUES (
        v_invoice_no, p_shipment_id, v_consumer, v_seller,
        v_sub_total, v_tax, v_total, 0, 'UNPAID', CURDATE(), p_due_date
    );
    SET v_invoice_id = LAST_INSERT_ID();

    INSERT INTO invoice_line_items (
        invoice_id, item_type, description, quantity, unit_price, amount
    ) VALUES
        (v_invoice_id, 'FREIGHT',   'Freight charge',         1, p_freight,   p_freight),
        (v_invoice_id, 'HANDLING',  'Handling charge',        1, p_handling,  p_handling),
        (v_invoice_id, 'CUSTOMS',   'Customs charge',         1, p_customs,   p_customs),
        (v_invoice_id, 'INSURANCE','Insurance charge',       1, p_insurance, p_insurance),
        (v_invoice_id, 'TAX', CONCAT('GST ',CAST(v_gst_rate AS CHAR),'% on goods, freight and handling'),1,v_tax,v_tax);

    CALL sp_record_audit_action(
        p_user_id, 'INSERT', 'billing_invoices', v_invoice_id,
        NULL, JSON_OBJECT('shipment_id', p_shipment_id, 'total_amount', v_total), p_ip_address
    );
    COMMIT;
    SELECT invoice_id, invoice_no, total_amount, status
      FROM billing_invoices WHERE invoice_id = v_invoice_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_invoice_field
-- Group: Invoices
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update invoice field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_invoice_field(
    IN p_user_id INT,IN p_invoice_id INT,IN p_field_name VARCHAR(64),
    IN p_new_value VARCHAR(255),IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_issue DATE DEFAULT NULL;
    DECLARE v_old DATE DEFAULT NULL;
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_status VARCHAR(10) DEFAULT NULL;
    DECLARE v_due DATE DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_field_name IS NULL OR p_field_name<>'due_date' OR p_new_value IS NULL OR
       p_new_value NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only a valid invoice due_date is editable';
    END IF;
    SET v_due=STR_TO_DATE(p_new_value,'%Y-%m-%d');
    IF v_due IS NULL OR DATE_FORMAT(v_due,'%Y-%m-%d')<>p_new_value THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid invoice due_date';
    END IF;
    START TRANSACTION;
    SELECT issue_date,due_date,seller_id,status INTO v_issue,v_old,v_seller,v_status
    FROM billing_invoices WHERE invoice_id=p_invoice_id FOR UPDATE;
    IF v_issue IS NULL OR v_status='PAID' OR v_due<v_issue THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invoice missing, paid or invalid due date';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id=p_user_id AND role='SELLER'
       AND status='ACTIVE' AND company_id=v_seller) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only the responsible Seller can edit invoice';
    END IF;
    UPDATE billing_invoices SET due_date=v_due WHERE invoice_id=p_invoice_id;
    CALL sp_record_audit_action(p_user_id,'UPDATE','billing_invoices',p_invoice_id,
         JSON_OBJECT('due_date',v_old),JSON_OBJECT('due_date',v_due),p_ip_address);
    COMMIT;
    SELECT invoice_id,invoice_no,issue_date,due_date,total_amount,status
    FROM billing_invoices WHERE invoice_id=p_invoice_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_invoice
-- Group: Invoices
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove invoice while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_invoice(
    IN p_user_id INT,
    IN p_invoice_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_found BOOLEAN DEFAULT TRUE;
    DECLARE v_seller INT;
    DECLARE v_shipment INT;
    DECLARE v_status VARCHAR(10);
    DECLARE v_paid DECIMAL(12,2);
    DECLARE v_total DECIMAL(12,2);
    DECLARE v_ship_status VARCHAR(20);
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_count INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SELECT i.seller_id, i.shipment_id, i.status, i.paid_amount,
           i.total_amount, s.status
      INTO v_seller, v_shipment, v_status, v_paid, v_total, v_ship_status
      FROM billing_invoices i JOIN shipment s ON s.shipment_id = i.shipment_id
     WHERE i.invoice_id = p_invoice_id FOR UPDATE;
    IF NOT v_found THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice does not exist';
    END IF;

    SELECT COUNT(*) INTO v_allowed FROM users
     WHERE user_id = p_user_id AND role = 'SELLER'
       AND status = 'ACTIVE' AND company_id = v_seller;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only the responsible Seller can delete the invoice';
    END IF;
    IF v_ship_status <> 'CANCELLED' OR v_status <> 'UNPAID' OR v_paid <> 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only an unpaid invoice of a cancelled shipment may be deleted';
    END IF;

    SELECT COUNT(*) INTO v_count FROM payments WHERE invoice_id = p_invoice_id;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete invoice with payment history';
    END IF;
    SELECT COUNT(*) INTO v_count FROM claims
     WHERE shipment_id = v_shipment;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete claim-linked invoice';
    END IF;
    SELECT COUNT(*) INTO v_count FROM profit_loss
     WHERE shipment_id = v_shipment;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete invoice with P&L history';
    END IF;

    DELETE FROM invoice_line_items WHERE invoice_id = p_invoice_id;
    DELETE FROM billing_invoices WHERE invoice_id = p_invoice_id;
    CALL sp_record_audit_action(
        p_user_id, 'DELETE', 'billing_invoices', p_invoice_id,
        JSON_OBJECT('shipment_id', v_shipment, 'total_amount', v_total), NULL, p_ip_address
    );
    COMMIT;
    SELECT p_invoice_id AS deleted_invoice_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_invoices
-- Group: Invoices
-- Operation: SHOW / list records
-- Purpose: Display invoices while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_invoices(IN p_user_id INT)
BEGIN
    CALL sp_search_invoices(p_user_id,
    NULL);
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_invoices
-- Group: Invoices
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search invoices while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_invoices(IN p_user_id INT,
IN p_status VARCHAR(10))
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,
    company_id INTO v_role,
    v_company FROM users WHERE user_id = p_user_id AND status = 'ACTIVE';
    SELECT customer_id INTO v_customer FROM customers WHERE user_id = p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.3: an active user is
        required';
    END IF;
    SELECT i.invoice_id,
    i.invoice_no,
    i.shipment_id,
    s.shipment_no,
    i.consumer_id,
    i.seller_id,
    i.sub_total,
    i.tax_amount,
    i.total_amount,
    i.paid_amount,
    i.total_amount - i.paid_amount AS balance,
    i.status,
    i.issue_date,
    i.due_date
    FROM billing_invoices i JOIN shipment s ON s.shipment_id = i.shipment_id
    WHERE (v_role = 'ADMIN' OR (v_role = 'SELLER' AND i.seller_id = v_company)
    OR (v_role = 'CONSUMER' AND i.consumer_id = v_customer))
    AND (p_status IS NULL OR i.status = p_status)
    ORDER BY i.invoice_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_generate_invoice_details
-- Group: Invoices
-- Operation: GET / detail report
-- Purpose: Execute generate invoice details using existing database business rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_generate_invoice_details(
    IN p_user_id INT,
    IN p_invoice_id INT
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;

    SELECT COUNT(*) INTO v_allowed
      FROM users u
      JOIN billing_invoices i ON i.invoice_id = p_invoice_id
      LEFT JOIN customers cu ON cu.customer_id = i.consumer_id
     WHERE u.user_id = p_user_id AND u.status = 'ACTIVE'
       AND (u.role = 'ADMIN'
        OR (u.role = 'SELLER' AND u.company_id = i.seller_id)
        OR (u.role = 'CONSUMER' AND cu.user_id = u.user_id));
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice not found or access denied';
    END IF;

    SELECT i.invoice_id, i.invoice_no, s.shipment_no,
           i.issue_date, i.due_date, i.consumer_id, i.seller_id,
           sc.company_name AS seller_name, cc.company_name AS consumer_name,
           li.item_id, li.item_type, li.description, li.quantity,
           li.unit_price, li.amount,
           i.sub_total, i.tax_amount, i.total_amount, i.paid_amount,
           i.total_amount - i.paid_amount AS balance, i.status
      FROM billing_invoices i
      JOIN shipment s ON s.shipment_id = i.shipment_id
      JOIN companies sc ON sc.company_id = i.seller_id
      JOIN customers cu ON cu.customer_id = i.consumer_id
      JOIN companies cc ON cc.company_id = cu.company_id
      LEFT JOIN invoice_line_items li ON li.invoice_id = i.invoice_id
     WHERE i.invoice_id = p_invoice_id
     ORDER BY li.item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_invoice_details
-- Group: Invoices
-- Operation: GET / detail report
-- Purpose: Return invoice details while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_invoice_details(IN p_invoice_id INT)
BEGIN
    SELECT i.*,
    i.total_amount - i.paid_amount AS balance,
    s.shipment_no,
    sc.company_name AS seller_company,
    cc.company_name AS consumer_company
    FROM billing_invoices i
    JOIN shipment s ON s.shipment_id = i.shipment_id
    JOIN companies sc ON sc.company_id = i.seller_id
    JOIN customers cu ON cu.customer_id = i.consumer_id
    JOIN companies cc ON cc.company_id = cu.company_id
    WHERE i.invoice_id = p_invoice_id;
    SELECT * FROM invoice_line_items WHERE invoice_id = p_invoice_id ORDER BY
    item_id;
    SELECT * FROM payments WHERE invoice_id = p_invoice_id ORDER BY payment_date,
    payment_id;
END$$

-- ----------------------------------------------------------------------------
-- Invoice line items
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_invoice_line_item
-- Group: Invoice line items
-- Operation: CREATE / INSERT
-- Purpose: Insert invoice line item while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_invoice_line_item(
    IN p_user_id INT,
    IN p_invoice_id INT,
    IN p_description VARCHAR(150),
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_item_id INT;
    IF p_description IS NULL OR TRIM(p_description) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A nonempty invoice note is required';
    END IF;
    SELECT COUNT(*) INTO v_allowed
      FROM billing_invoices i JOIN users u
        ON u.company_id = i.seller_id AND u.role = 'SELLER'
       AND u.status = 'ACTIVE' AND u.user_id = p_user_id
     WHERE i.invoice_id = p_invoice_id AND i.status = 'UNPAID'
       AND i.paid_amount = 0;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only the responsible Seller may add unpaid invoice notes';
    END IF;

    INSERT INTO invoice_line_items (invoice_id, item_type, description,
                                    quantity, unit_price, amount)
    VALUES (p_invoice_id, 'OTHER', p_description, 1, 0, 0);
    SET v_item_id = LAST_INSERT_ID();
    CALL sp_record_audit_action(
        p_user_id, 'INSERT', 'invoice_line_items', v_item_id,
        NULL, JSON_OBJECT('invoice_id', p_invoice_id, 'description', p_description), p_ip_address
    );
    SELECT v_item_id AS item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_invoice_line_item_field
-- Group: Invoice line items
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update invoice line item field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_invoice_line_item_field(
    IN p_user_id INT,IN p_item_id INT,IN p_field_name VARCHAR(64),
    IN p_new_value VARCHAR(255),IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_old VARCHAR(150) DEFAULT NULL;
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_field_name IS NULL OR p_field_name<>'description' OR p_new_value IS NULL OR TRIM(p_new_value)=''
       OR CHAR_LENGTH(p_new_value)>150 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only a valid line-item description can be edited';
    END IF;
    START TRANSACTION;
    SELECT MAX(li.description),COUNT(*) INTO v_old,v_allowed
    FROM invoice_line_items li JOIN billing_invoices i ON i.invoice_id=li.invoice_id
    JOIN users u ON u.user_id=p_user_id AND u.status='ACTIVE'
    WHERE li.item_id=p_item_id AND u.role='SELLER' AND u.company_id=i.seller_id
      AND i.status='UNPAID' AND i.paid_amount=0;
    IF v_allowed<>1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invoice item missing, paid or Seller unauthorized';
    END IF;
    UPDATE invoice_line_items SET description=p_new_value WHERE item_id=p_item_id;
    CALL sp_record_audit_action(p_user_id,'UPDATE','invoice_line_items',p_item_id,
         JSON_OBJECT('description',v_old),JSON_OBJECT('description',p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM invoice_line_items WHERE item_id=p_item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_invoice_line_item
-- Group: Invoice line items
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove invoice line item while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_invoice_line_item(
    IN p_user_id INT,
    IN p_item_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_invoice_id INT;
    SELECT COUNT(*), MAX(i.invoice_id)
      INTO v_allowed, v_invoice_id
      FROM invoice_line_items li JOIN billing_invoices i ON i.invoice_id = li.invoice_id
      JOIN users u ON u.user_id = p_user_id AND u.role = 'SELLER'
       AND u.status = 'ACTIVE' AND u.company_id = i.seller_id
     WHERE li.item_id = p_item_id AND li.item_type = 'OTHER' AND li.amount = 0
       AND i.status = 'UNPAID' AND i.paid_amount = 0;
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only an unpaid zero-value OTHER item may be deleted';
    END IF;
    DELETE FROM invoice_line_items WHERE item_id = p_item_id;
    CALL sp_record_audit_action(
        p_user_id, 'DELETE', 'invoice_line_items', p_item_id,
        JSON_OBJECT('invoice_id', v_invoice_id), NULL, p_ip_address
    );
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_invoice_line_items
-- Group: Invoice line items
-- Operation: SHOW / list records
-- Purpose: Display invoice line items while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_invoice_line_items(IN p_user_id INT,IN p_invoice_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    SELECT li.* FROM invoice_line_items li JOIN billing_invoices i ON i.invoice_id=li.invoice_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND i.seller_id=v_company)
       OR (v_role='CONSUMER' AND i.consumer_id=v_customer))
       AND (p_invoice_id IS NULL OR li.invoice_id=p_invoice_id)
     ORDER BY li.invoice_id,li.item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_invoice_line_items
-- Group: Invoice line items
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search invoice line items while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_invoice_line_items(
    IN p_user_id INT,IN p_invoice_id INT,IN p_item_type VARCHAR(15))
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    SELECT li.* FROM invoice_line_items li JOIN billing_invoices i ON i.invoice_id=li.invoice_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND i.seller_id=v_company)
       OR (v_role='CONSUMER' AND i.consumer_id=v_customer))
       AND (p_invoice_id IS NULL OR li.invoice_id=p_invoice_id)
       AND (p_item_type IS NULL OR li.item_type=p_item_type)
     ORDER BY li.invoice_id,li.item_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_invoice_line_items
-- Group: Invoice line items
-- Operation: GET / detail report
-- Purpose: Return invoice line items while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_invoice_line_items(IN p_invoice_id INT)
BEGIN
    SELECT * FROM invoice_line_items WHERE invoice_id = p_invoice_id ORDER BY
    item_id;
END$$

-- ----------------------------------------------------------------------------
-- Payments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_payment_field
-- Group: Payments
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update payment field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_payment_field(
    IN p_user_id INT,IN p_payment_id INT,IN p_field_name VARCHAR(64),
    IN p_new_value VARCHAR(255),IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_invoice INT DEFAULT NULL;
    DECLARE v_status VARCHAR(10) DEFAULT NULL;
    DECLARE v_old VARCHAR(255) DEFAULT NULL;
    DECLARE v_amount DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_date DATE DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT p.invoice_id,i.status INTO v_invoice,v_status
    FROM payments p JOIN billing_invoices i ON i.invoice_id=p.invoice_id
    WHERE p.payment_id=p_payment_id FOR UPDATE;
    IF v_invoice IS NULL OR v_status='PAID' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Payment missing or paid invoice protected';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users u JOIN customers c ON c.user_id=u.user_id
        JOIN billing_invoices i ON i.consumer_id=c.customer_id
        WHERE u.user_id=p_user_id AND u.role='CONSUMER' AND u.status='ACTIVE'
        AND i.invoice_id=v_invoice) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only the owning Consumer may edit payment';
    END IF;
    IF p_field_name='amount' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}([.][0-9]{1,2})?$'
           OR CAST(p_new_value AS DECIMAL(12,2))<=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid payment amount';
        END IF;
        SELECT CAST(amount AS CHAR) INTO v_old FROM payments WHERE payment_id=p_payment_id;
        SET v_amount=CAST(p_new_value AS DECIMAL(12,2));
        UPDATE payments SET amount=v_amount WHERE payment_id=p_payment_id;
    ELSEIF p_field_name='payment_mode' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('BANK','UPI','CHEQUE','CASH') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid payment mode';
        END IF;
        SELECT payment_mode INTO v_old FROM payments WHERE payment_id=p_payment_id;
        UPDATE payments SET payment_mode=p_new_value WHERE payment_id=p_payment_id;
    ELSEIF p_field_name='reference_no' THEN
        IF p_new_value IS NOT NULL AND CHAR_LENGTH(p_new_value)>50 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Payment reference too long';
        END IF;
        SELECT reference_no INTO v_old FROM payments WHERE payment_id=p_payment_id;
        UPDATE payments SET reference_no=p_new_value WHERE payment_id=p_payment_id;
    ELSEIF p_field_name='payment_date' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid payment date';
        END IF;
        SET v_date=STR_TO_DATE(p_new_value,'%Y-%m-%d');
        IF v_date IS NULL OR DATE_FORMAT(v_date,'%Y-%m-%d')<>p_new_value THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid payment date';
        END IF;
        SELECT CAST(payment_date AS CHAR) INTO v_old FROM payments WHERE payment_id=p_payment_id;
        UPDATE payments SET payment_date=v_date WHERE payment_id=p_payment_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Payment field not editable';
    END IF;
    CALL sp_record_audit_action(p_user_id,'UPDATE','payments',p_payment_id,
        JSON_OBJECT(p_field_name,v_old),JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM payments WHERE payment_id=p_payment_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_payment
-- Group: Payments
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove payment while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_payment(
    IN p_user_id INT,
    IN p_payment_id INT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_found BOOLEAN DEFAULT TRUE;
    DECLARE v_invoice INT;
    DECLARE v_status VARCHAR(10);
    DECLARE v_old_amount DECIMAL(12,2);
    DECLARE v_authorized INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = FALSE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SELECT pay.invoice_id, i.status, pay.amount
      INTO v_invoice, v_status, v_old_amount
      FROM payments pay JOIN billing_invoices i ON i.invoice_id = pay.invoice_id
     WHERE pay.payment_id = p_payment_id FOR UPDATE;
    IF NOT v_found THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment does not exist';
    END IF;

    SELECT COUNT(*) INTO v_authorized
      FROM billing_invoices i JOIN customers cu ON cu.customer_id = i.consumer_id
      JOIN users u ON u.user_id = cu.user_id
     WHERE i.invoice_id = v_invoice AND u.user_id = p_user_id
       AND u.role = 'CONSUMER' AND u.status = 'ACTIVE';
    IF v_authorized <> 1 OR v_status = 'PAID' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete paid invoice payments or another Consumer payment';
    END IF;

    DELETE FROM payments WHERE payment_id = p_payment_id;
    CALL sp_record_audit_action(
        p_user_id, 'DELETE', 'payments', p_payment_id,
        JSON_OBJECT('invoice_id', v_invoice, 'amount', v_old_amount), NULL, p_ip_address
    );
    COMMIT;
    SELECT i.invoice_id, i.total_amount, i.paid_amount, i.status
      FROM billing_invoices i WHERE i.invoice_id = v_invoice;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_payments
-- Group: Payments
-- Operation: SHOW / list records
-- Purpose: Display payments while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_payments(IN p_user_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    SELECT pay.*,i.invoice_no FROM payments pay JOIN billing_invoices i ON i.invoice_id=pay.invoice_id
     WHERE v_role='ADMIN' OR (v_role='SELLER' AND i.seller_id=v_company)
        OR (v_role='CONSUMER' AND i.consumer_id=v_customer)
     ORDER BY pay.payment_date DESC,pay.payment_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_payments
-- Group: Payments
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search payments while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_payments(
    IN p_user_id INT,IN p_invoice_id INT,IN p_reference_no VARCHAR(50),
    IN p_start_date DATE,IN p_end_date DATE)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    IF p_start_date IS NOT NULL AND p_end_date IS NOT NULL AND p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid payment date range';
    END IF;
    SELECT pay.*,i.invoice_no FROM payments pay JOIN billing_invoices i ON i.invoice_id=pay.invoice_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND i.seller_id=v_company)
        OR (v_role='CONSUMER' AND i.consumer_id=v_customer))
       AND (p_invoice_id IS NULL OR pay.invoice_id=p_invoice_id)
       AND (p_reference_no IS NULL OR pay.reference_no LIKE CONCAT('%',p_reference_no,'%'))
       AND (p_start_date IS NULL OR pay.payment_date >= p_start_date)
       AND (p_end_date IS NULL OR pay.payment_date <= p_end_date)
     ORDER BY pay.payment_date DESC,pay.payment_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_payment_history
-- Group: Payments
-- Operation: GET / detail report
-- Purpose: Return payment history while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_payment_history(IN p_invoice_id INT)
BEGIN
    SELECT p.*,
    u.full_name AS recorded_by_name
    FROM payments p LEFT JOIN users u ON u.user_id = p.recorded_by
    WHERE p.invoice_id = p_invoice_id
    ORDER BY p.payment_date DESC,
    p.payment_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_record_payment
-- Group: Payments
-- Operation: RECORD / financial or audit action
-- Purpose: Record payment while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_record_payment(IN p_invoice_id INT,
IN p_amount DECIMAL(12,2),
IN p_payment_mode VARCHAR(10),
IN p_reference_no VARCHAR(50),
IN p_payment_date DATE,
IN p_recorded_by INT)
BEGIN
    DECLARE v_invoice INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment amount must be
        greater than zero';
    END IF;
    IF p_payment_mode IS NULL OR p_payment_mode NOT IN ('BANK',
    'UPI',
    'CHEQUE',
    'CASH') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment mode must be
    BANK, UPI, CHEQUE or CASH';
    END IF;
    IF p_payment_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment date is
        required';
    END IF;
    START TRANSACTION;
    SELECT i.invoice_id INTO v_invoice
    FROM billing_invoices i
    JOIN customers cu ON cu.customer_id = i.consumer_id
    JOIN users u ON u.user_id = cu.user_id
    WHERE i.invoice_id = p_invoice_id AND u.user_id = p_recorded_by AND u.role =
    'CONSUMER' AND u.status = 'ACTIVE'
    FOR UPDATE;
    IF v_invoice IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: only the Consumer of
        this invoice can record a payment';
    END IF;
    INSERT INTO payments (invoice_id,
    amount,
    payment_mode,
    reference_no,
    payment_date,
    recorded_by)
    VALUES (p_invoice_id,
    p_amount,
    p_payment_mode,
    p_reference_no,
    p_payment_date,
    p_recorded_by);
    COMMIT;
    SELECT i.invoice_id,
    i.invoice_no,
    i.total_amount,
    i.paid_amount,
    i.total_amount - i.paid_amount AS balance,
    i.status
    FROM billing_invoices i WHERE i.invoice_id = p_invoice_id;
END$$

-- ============================================================================
-- MODULE 6 — Analytics, Forecasting and Profit & Loss — 21 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Dashboard and master analytics refresh
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_dashboard_kpis
-- Group: Dashboard and master analytics refresh
-- Operation: GET / detail report
-- Purpose: Return dashboard kpis while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_kpis(IN p_seller_id INT)
BEGIN
    -- FR6.1: Retain the five original KPIs; add six read-only indicators.
    -- Revenue follows the approved rule: fully PAID invoices only.
    SELECT
        (SELECT COUNT(*)
         FROM shipment s
         WHERE s.status NOT IN ('DELIVERED', 'CANCELLED')
           AND (p_seller_id IS NULL OR s.seller_id = p_seller_id)) AS active_shipments,
        (SELECT COUNT(*)
         FROM containers c
         WHERE c.status = 'AVAILABLE'
           AND (p_seller_id IS NULL OR c.seller_id = p_seller_id)) AS containers_available,
        (SELECT COALESCE(SUM(i.total_amount), 0)
         FROM billing_invoices i
         WHERE i.status = 'PAID'
           AND (p_seller_id IS NULL OR i.seller_id = p_seller_id)) AS revenue,
        (SELECT COUNT(*)
         FROM billing_invoices i
         WHERE i.status IN ('UNPAID', 'PARTIAL')
           AND (p_seller_id IS NULL OR i.seller_id = p_seller_id)) AS pending_invoices,
        (SELECT COUNT(*)
         FROM claims cl
         JOIN shipment s ON s.shipment_id = cl.shipment_id
         WHERE cl.status NOT IN ('REJECTED', 'SETTLED')
           AND (p_seller_id IS NULL OR s.seller_id = p_seller_id)) AS open_claims,
        -- Last 30 calendar days: count the FULL invoice in its final payment month/day,
        -- not just an instalment received during the window.
        (SELECT COALESCE(SUM(i.total_amount), 0)
         FROM billing_invoices i
         JOIN (SELECT invoice_id, MAX(payment_date) AS final_payment_date
               FROM payments GROUP BY invoice_id) fp ON fp.invoice_id = i.invoice_id
         WHERE i.status = 'PAID'
           AND fp.final_payment_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 29 DAY) AND CURDATE()
           AND (p_seller_id IS NULL OR i.seller_id = p_seller_id)) AS revenue_last_30_days,
        (SELECT COUNT(*)
         FROM containers c
         WHERE c.status = 'IN_TRANSIT'
           AND (p_seller_id IS NULL OR c.seller_id = p_seller_id)) AS containers_in_transit,
        -- Sum general (unreserved) stock by product, rather than checking individual rows.
        -- Products with no general-stock row count as zero available stock.
        (SELECT COUNT(*) FROM
            (SELECT p.product_id
             FROM products p
             LEFT JOIN stock sk ON sk.product_id = p.product_id
                 AND sk.shipment_id IS NULL
             WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id
             GROUP BY p.product_id
             HAVING COALESCE(SUM(GREATEST(sk.quantity - COALESCE(sk.damaged_qty, 0), 0)), 0) <= 10
            ) low_products) AS low_stock_products,
        (SELECT COUNT(DISTINCT st.customer_id)
         FROM sales_transactions st
         JOIN products p ON p.product_id = st.product_id
         WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id) AS customers_with_sales,
        (SELECT COUNT(*)
         FROM products p
         WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id) AS total_products,
        (SELECT COUNT(DISTINCT v.vessel_id)
         FROM vessels v
         WHERE v.status = 'ACTIVE'
           AND (p_seller_id IS NULL OR EXISTS
               (SELECT 1 FROM shipment s
                WHERE s.vessel_id = v.vessel_id AND s.seller_id = p_seller_id))) AS active_vessels;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_all_analytics
-- Group: Dashboard and master analytics refresh
-- Operation: Business logic / processing
-- Purpose: Refresh sales, product ABC, turnover and profitability caches explicitly.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_all_analytics(
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_year INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_start_date IS NULL OR p_end_date IS NULL
       OR p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.7: Invalid analytics date range';
    END IF;

    IF p_year IS NULL OR p_year < 2000 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.7: Invalid ABC classification year';
    END IF;

    START TRANSACTION;
        CALL sp_refresh_sales_trend(p_start_date, p_end_date);
        CALL sp_refresh_abc_classification(p_year);
        CALL sp_refresh_inventory_turnover(p_start_date, p_end_date);
        CALL sp_refresh_profitability(p_start_date, p_end_date);
    COMMIT;

    SELECT 'All cached analytics refreshed successfully' AS refresh_status;
END$$

-- ----------------------------------------------------------------------------
-- ABC classification
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_abc_classification
-- Group: ABC classification
-- Operation: GET / detail report
-- Purpose: Return abc classification while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_abc_classification(
    IN p_seller_id INT,
    IN p_abc_class CHAR(1)
)
BEGIN
    IF p_abc_class IS NOT NULL AND p_abc_class NOT IN ('A', 'B', 'C') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.3: ABC class must be A, B or C';
    END IF;

    SELECT a.*, p.sku, p.product_name
    FROM abc_classification_result a
    JOIN products p ON p.product_id = a.product_id
    WHERE (p_seller_id IS NULL OR p.owner_company_id = p_seller_id)
      AND (p_abc_class IS NULL OR a.abc_class = p_abc_class)
    ORDER BY a.annual_value DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_abc_summary
-- Group: ABC classification
-- Operation: GET / detail report
-- Purpose: Return abc summary while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_abc_summary(IN p_seller_id INT)
BEGIN
    SELECT
        a.abc_class,
        COUNT(*) AS product_count,
        COALESCE(SUM(a.annual_value), 0) AS class_value,
        ROUND(
            SUM(a.annual_value) * 100.00 /
            NULLIF(SUM(SUM(a.annual_value)) OVER (), 0),
            2
        ) AS value_share_pct
    FROM abc_classification_result a
    JOIN products p ON p.product_id = a.product_id
    WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id
    GROUP BY a.abc_class
    ORDER BY a.abc_class;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_abc_classification
-- Group: ABC classification
-- Operation: Business logic / processing
-- Purpose: Recalculate and cache abc classification while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_abc_classification(IN p_year INT)
BEGIN
    -- FR6.3: Product ABC Pareto classification, independently for each Seller.
    -- Keep the approved boundary rule: classify by cumulative share BEFORE
    -- adding the current product (A <70%, B <90%, otherwise C).
    IF p_year IS NULL OR p_year < 2000 OR p_year > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.3: valid reporting year required';
    END IF;
    DELETE FROM abc_classification_result WHERE result_id > 0;
    INSERT INTO abc_classification_result
        (product_id, annual_value, cumulative_pct, abc_class, calculated_on)
    SELECT ranked.product_id,
           ranked.annual_value,
           CASE WHEN ranked.seller_total = 0 THEN 0.00
                ELSE ROUND(ranked.cumulative_value * 100.0 / ranked.seller_total, 2)
           END AS cumulative_pct,
           CASE WHEN ranked.seller_total = 0 THEN 'C'
                WHEN (ranked.cumulative_value - ranked.annual_value) * 100.0 /
                     ranked.seller_total < 70.00 THEN 'A'
                WHEN (ranked.cumulative_value - ranked.annual_value) * 100.0 /
                     ranked.seller_total < 90.00 THEN 'B'
                ELSE 'C'
           END AS abc_class,
           CURDATE()
    FROM (
        SELECT totals.product_id, totals.owner_company_id, totals.annual_value,
               SUM(totals.annual_value) OVER (
                   PARTITION BY totals.owner_company_id
                   ORDER BY totals.annual_value DESC, totals.product_id
                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
               ) AS cumulative_value,
               SUM(totals.annual_value) OVER (
                   PARTITION BY totals.owner_company_id
               ) AS seller_total
        FROM (
            SELECT p.product_id, p.owner_company_id,
                   COALESCE(SUM(st.total_amount), 0.00) AS annual_value
            FROM products p
            LEFT JOIN sales_transactions st ON st.product_id = p.product_id
                 AND st.sale_date >= MAKEDATE(p_year, 1)
                 AND st.sale_date < MAKEDATE(p_year + 1, 1)
                 AND st.shipment_id IS NOT NULL
                 AND EXISTS (SELECT 1 FROM shipment s
                             WHERE s.shipment_id = st.shipment_id
                               AND s.status <> 'CANCELLED')
            GROUP BY p.product_id, p.owner_company_id
        ) totals
    ) ranked;
END$$

-- ----------------------------------------------------------------------------
-- Inventory turnover
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_inventory_turnover
-- Group: Inventory turnover
-- Operation: GET / detail report
-- Purpose: Return inventory turnover while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_inventory_turnover(IN p_seller_id INT)
BEGIN
    SELECT r.*,
    p.sku,
    p.product_name
    FROM inventory_turnover_result r JOIN products p ON p.product_id =
    r.product_id
    WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id
    ORDER BY r.period_end DESC,
    r.turnover_ratio DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_inventory_turnover
-- Group: Inventory turnover
-- Operation: Business logic / processing
-- Purpose: Recalculate and cache inventory turnover while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_inventory_turnover(
    IN p_period_start DATE,
    IN p_period_end DATE
)
BEGIN
    -- FR6.4: COGS = sold quantity * current product.unit_price (approved proxy).
    -- Inventory snapshots use the latest ledger balance PER GENERAL STOCK ROW
    -- as of the requested boundary; shipment-reserved stock is excluded.
    -- For a stock row without a historical ledger balance, current available
    -- stock is used ONLY when last_updated predates the snapshot boundary.
    IF p_period_start IS NULL OR p_period_end IS NULL
       OR p_period_end < p_period_start THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.4: a valid period is required';
    END IF;
    DELETE FROM inventory_turnover_result
    WHERE result_id > 0
      AND period_start = p_period_start AND period_end = p_period_end;
    INSERT INTO inventory_turnover_result
        (product_id, period_start, period_end, cogs, avg_inventory, turnover_ratio)
    SELECT calc.product_id, p_period_start, p_period_end,
           calc.cogs, calc.avg_inventory,
           CASE WHEN calc.avg_inventory = 0 THEN NULL
                ELSE LEAST(999999.99,
                           ROUND(calc.cogs / calc.avg_inventory, 2))
           END AS turnover_ratio
    FROM (
        SELECT p.product_id,
               ROUND(COALESCE(sold.quantity_sold, 0) * p.unit_price, 2) AS cogs,
               ROUND((COALESCE(open_stock.available_qty, 0) +
                      COALESCE(close_stock.available_qty, 0))
                      * p.unit_price / 2, 2) AS avg_inventory
        FROM products p
        LEFT JOIN (
            SELECT st.product_id, SUM(st.quantity) AS quantity_sold
            FROM sales_transactions st
            JOIN shipment s ON s.shipment_id = st.shipment_id
            WHERE s.status <> 'CANCELLED'
              AND st.sale_date >= p_period_start
              AND st.sale_date < DATE_ADD(p_period_end, INTERVAL 1 DAY)
            GROUP BY st.product_id
        ) sold ON sold.product_id = p.product_id
        LEFT JOIN (
            SELECT sk.product_id,
                   SUM(COALESCE(
                       (SELECT il.balance_after FROM inventory_ledger il
                        WHERE il.stock_id = sk.stock_id
                          AND il.txn_time < p_period_start
                        ORDER BY il.txn_time DESC, il.ledger_id DESC LIMIT 1),
                       CASE WHEN sk.last_updated < p_period_start
                            THEN GREATEST(0, sk.quantity - COALESCE(sk.damaged_qty, 0))
                            ELSE 0 END
                   )) AS available_qty
            FROM stock sk
            WHERE sk.shipment_id IS NULL
            GROUP BY sk.product_id
        ) open_stock ON open_stock.product_id = p.product_id
        LEFT JOIN (
            SELECT sk.product_id,
                   SUM(COALESCE(
                       (SELECT il.balance_after FROM inventory_ledger il
                        WHERE il.stock_id = sk.stock_id
                          AND il.txn_time < DATE_ADD(p_period_end, INTERVAL 1 DAY)
                        ORDER BY il.txn_time DESC, il.ledger_id DESC LIMIT 1),
                       CASE WHEN sk.last_updated < DATE_ADD(p_period_end, INTERVAL 1 DAY)
                            THEN GREATEST(0, sk.quantity - COALESCE(sk.damaged_qty, 0))
                            ELSE 0 END
                   )) AS available_qty
            FROM stock sk
            WHERE sk.shipment_id IS NULL
            GROUP BY sk.product_id
        ) close_stock ON close_stock.product_id = p.product_id
    ) calc;
END$$

-- ----------------------------------------------------------------------------
-- Product profitability
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_profitability
-- Group: Product profitability
-- Operation: GET / detail report
-- Purpose: Return profitability while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_profitability(IN p_seller_id INT)
BEGIN
    SELECT r.*,
    p.sku,
    p.product_name
    FROM profitability_result r JOIN products p ON p.product_id = r.product_id
    WHERE p_seller_id IS NULL OR p.owner_company_id = p_seller_id
    ORDER BY r.period_month DESC,
    r.margin_pct DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_profitability
-- Group: Product profitability
-- Operation: Business logic / processing
-- Purpose: Recalculate and cache profitability while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_profitability(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    DECLARE v_first_month DATE;
    DECLARE v_last_month DATE;
    -- FR6.5: Allocate fully paid invoice totals by each shipment item's
    -- value share. Recognize revenue in the FINAL PAYMENT month (not issue
    -- month or partial-payment month). Allocate freight, port and handling
    -- costs in their recorded P&L months; do not count claim losses twice.
    IF p_start_date IS NULL OR p_end_date IS NULL
       OR p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.5: a valid date range is required';
    END IF;
    SET v_first_month = DATE_SUB(p_start_date,
                       INTERVAL DAYOFMONTH(p_start_date) - 1 DAY);
    SET v_last_month = DATE_SUB(p_end_date,
                      INTERVAL DAYOFMONTH(p_end_date) - 1 DAY);
    DELETE FROM profitability_result
    WHERE result_id > 0
      AND period_month BETWEEN v_first_month AND v_last_month;
    INSERT INTO profitability_result
        (product_id, period_month, revenue, cost, margin_pct)
    SELECT monthly.product_id, monthly.period_month,
           ROUND(SUM(monthly.revenue), 2) AS revenue,
           ROUND(SUM(monthly.cost), 2) AS cost,
           CASE WHEN SUM(monthly.revenue) = 0 THEN NULL
                ELSE GREATEST(-9999.99, LEAST(9999.99,
                     ROUND((SUM(monthly.revenue) - SUM(monthly.cost)) * 100.0 /
                           SUM(monthly.revenue), 2)))
           END AS margin_pct
    FROM (
        -- Fully PAID invoice value is allocated once, in its last payment month.
        SELECT si.product_id,
               DATE_SUB(fp.final_payment_date,
                        INTERVAL DAYOFMONTH(fp.final_payment_date) - 1 DAY) AS period_month,
               bi.total_amount * si.amount / item_totals.total_item_amount AS revenue,
               0.00 AS cost
        FROM billing_invoices bi
        JOIN shipment s ON s.shipment_id = bi.shipment_id
        JOIN shipment_items si ON si.shipment_id = s.shipment_id
        JOIN (SELECT shipment_id, SUM(amount) AS total_item_amount
              FROM shipment_items GROUP BY shipment_id) item_totals
              ON item_totals.shipment_id = s.shipment_id
        JOIN (SELECT invoice_id, MAX(payment_date) AS final_payment_date
              FROM payments GROUP BY invoice_id) fp ON fp.invoice_id = bi.invoice_id
        WHERE bi.status = 'PAID'
          AND s.status <> 'CANCELLED'
          AND item_totals.total_item_amount > 0
          AND fp.final_payment_date >= v_first_month
          AND fp.final_payment_date < DATE_ADD(v_last_month, INTERVAL 1 MONTH)
        UNION ALL
        -- Freight/port/handling costs use the month of the latest P&L row
        -- for each shipment-month; claims remain in shipment-level P&L only.
        SELECT si.product_id, pl.period_month,
               0.00 AS revenue,
               (COALESCE(pl.freight_cost, 0) +
                COALESCE(pl.port_cost, 0) +
                COALESCE(pl.handling_cost, 0)) *
                si.amount / item_totals.total_item_amount AS cost
        FROM profit_loss pl
        JOIN (SELECT shipment_id, period_month, MAX(pl_id) AS latest_pl_id
              FROM profit_loss
              WHERE shipment_id IS NOT NULL
              GROUP BY shipment_id, period_month) latest
              ON latest.latest_pl_id = pl.pl_id
        JOIN shipment s ON s.shipment_id = pl.shipment_id
        JOIN shipment_items si ON si.shipment_id = s.shipment_id
        JOIN (SELECT shipment_id, SUM(amount) AS total_item_amount
              FROM shipment_items GROUP BY shipment_id) item_totals
              ON item_totals.shipment_id = s.shipment_id
        WHERE s.status <> 'CANCELLED'
          AND item_totals.total_item_amount > 0
          AND pl.period_month BETWEEN v_first_month AND v_last_month
    ) monthly
    GROUP BY monthly.product_id, monthly.period_month;
END$$

-- ----------------------------------------------------------------------------
-- Route sales trends
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_sales_trend
-- Group: Route sales trends
-- Operation: GET / detail report
-- Purpose: Return sales trend while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_sales_trend(IN p_start_date DATE,
IN p_end_date DATE,
IN p_origin_port_id INT,
IN p_dest_port_id INT)
BEGIN
    SELECT t.*,
    op.port_name AS origin_port,
    dp.port_name AS dest_port
    FROM sales_trend_result t
    LEFT JOIN ports op ON op.port_id = t.origin_port_id
    LEFT JOIN ports dp ON dp.port_id = t.dest_port_id
    WHERE (p_start_date IS NULL OR t.period_month >= DATE(DATE_SUB(p_start_date,
    INTERVAL DAYOFMONTH(p_start_date) - 1 DAY)))
    AND (p_end_date IS NULL OR t.period_month <= p_end_date)
    AND (p_origin_port_id IS NULL OR t.origin_port_id = p_origin_port_id)
    AND (p_dest_port_id IS NULL OR t.dest_port_id = p_dest_port_id)
    ORDER BY t.period_month,
    t.total_sales DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_sales_trend
-- Group: Route sales trends
-- Operation: Business logic / processing
-- Purpose: Recalculate and cache sales trend while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_sales_trend(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    DECLARE v_first_month DATE;
    DECLARE v_last_month DATE;
    DECLARE v_baseline_month DATE;
    -- FR6.2: Route trends use sales_transactions.sale_date, as approved.
    -- Rebuild the preceding month too, so the first requested month has an
    -- accurate growth baseline instead of relying on stale cached rows.
    IF p_start_date IS NULL OR p_end_date IS NULL
       OR p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.2: a valid date range is required';
    END IF;
    SET v_first_month = DATE_SUB(p_start_date,
                        INTERVAL DAYOFMONTH(p_start_date) - 1 DAY);
    SET v_last_month = DATE_SUB(p_end_date,
                       INTERVAL DAYOFMONTH(p_end_date) - 1 DAY);
    SET v_baseline_month = DATE_SUB(v_first_month, INTERVAL 1 MONTH);
    DELETE FROM sales_trend_result
    WHERE result_id > 0
      AND period_month BETWEEN v_baseline_month AND v_last_month;
    INSERT INTO sales_trend_result
        (period_month, origin_port_id, dest_port_id, total_sales, total_qty)
    SELECT DATE_SUB(st.sale_date, INTERVAL DAYOFMONTH(st.sale_date) - 1 DAY),
           s.origin_port_id, s.dest_port_id,
           SUM(st.total_amount), SUM(st.quantity)
    FROM sales_transactions st
    JOIN shipment s ON s.shipment_id = st.shipment_id
    WHERE s.status <> 'CANCELLED'
      AND st.sale_date >= v_baseline_month
      AND st.sale_date < DATE_ADD(v_last_month, INTERVAL 1 MONTH)
    GROUP BY 1, 2, 3;
    UPDATE sales_trend_result cur
    LEFT JOIN sales_trend_result prev
      ON prev.origin_port_id = cur.origin_port_id
     AND prev.dest_port_id = cur.dest_port_id
     AND prev.period_month = DATE_SUB(cur.period_month, INTERVAL 1 MONTH)
    SET cur.growth_pct =
        CASE WHEN prev.result_id IS NULL OR prev.total_sales = 0 THEN NULL
             ELSE GREATEST(-9999.99, LEAST(9999.99,
                  ROUND((cur.total_sales - prev.total_sales) * 100.0 /
                        prev.total_sales, 2)))
        END
    WHERE cur.result_id > 0
      AND cur.period_month BETWEEN v_first_month AND v_last_month;
END$$

-- ----------------------------------------------------------------------------
-- Demand forecasting and pricing link
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_insert_demand_forecast
-- Group: Demand forecasting and pricing link
-- Operation: CREATE / INSERT
-- Purpose: Insert demand forecast while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_insert_demand_forecast(IN p_origin_port_id INT,
IN p_dest_port_id INT,
IN p_container_type VARCHAR(10),
IN p_forecast_month DATE,
IN p_predicted_bookings INT,
IN p_confidence_pct DECIMAL(5,2),
IN p_suggested_multiplier DECIMAL(4,2))
BEGIN
    INSERT INTO demand_forecast (origin_port_id,
    dest_port_id,
    container_type,
    forecast_month,
    predicted_bookings,
    confidence_pct,
    suggested_multiplier)
    VALUES (p_origin_port_id,
    p_dest_port_id,
    p_container_type,
    p_forecast_month,
    p_predicted_bookings,
    p_confidence_pct,
    p_suggested_multiplier);
    SELECT LAST_INSERT_ID() AS forecast_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_demand_forecast_field
-- Group: Demand forecasting and pricing link
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update demand forecast field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_demand_forecast_field(
    IN p_user_id INT,
    IN p_record_id INT,
    IN p_field_name VARCHAR(64),
    IN p_new_value TEXT,
    IN p_ip_address VARCHAR(45)
)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_admin INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Confirm the target exists and the current actor may edit it.
    SELECT COUNT(*) INTO v_allowed FROM demand_forecast t JOIN users u ON u.user_id=p_user_id AND u.status='ACTIVE' WHERE t.forecast_id=p_record_id AND (u.role='ADMIN' OR (u.role='SELLER' AND EXISTS (SELECT 1 FROM pricing_rules r WHERE r.seller_id=u.company_id AND r.origin_port_id=t.origin_port_id AND r.dest_port_id=t.dest_port_id AND r.container_type=t.container_type)));
    IF v_allowed <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record missing or update not authorized';
    END IF;
    IF p_field_name IS NULL OR TRIM(p_field_name)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Choose one valid field to update';
    END IF;
    -- A forecast is a manually supplied suggestion, never an automatic pricing change.
    IF p_field_name='confidence_pct' AND p_new_value IS NOT NULL AND CAST(p_new_value AS DECIMAL(5,2)) > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Confidence percentage cannot exceed 100';
    END IF;

    -- 2. Update exactly one whitelisted SRS column; no dynamic SQL.
    START TRANSACTION;
    IF p_field_name = 'predicted_bookings' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid integer for predicted_bookings';
        END IF;
        UPDATE demand_forecast SET predicted_bookings = CAST(p_new_value AS UNSIGNED) WHERE forecast_id = p_record_id;
    ELSEIF p_field_name = 'confidence_pct' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,3}([.][0-9]{1,2})?$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for confidence_pct';
        END IF;
        UPDATE demand_forecast SET confidence_pct = CAST(p_new_value AS DECIMAL(5,2)) WHERE forecast_id = p_record_id;
    ELSEIF p_field_name = 'suggested_multiplier' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,2}([.][0-9]{1,2})?$' OR CAST(p_new_value AS DECIMAL(18,5)) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid decimal for suggested_multiplier';
        END IF;
        UPDATE demand_forecast SET suggested_multiplier = CAST(p_new_value AS DECIMAL(4,2)) WHERE forecast_id = p_record_id;
    ELSEIF p_field_name = 'forecast_month' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
           OR STR_TO_DATE(p_new_value, '%Y-%m-%d') IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid date for forecast_month';
        END IF;
        UPDATE demand_forecast SET forecast_month = STR_TO_DATE(p_new_value,'%Y-%m-%d') WHERE forecast_id = p_record_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Field is not allowed for specific update';
    END IF;

    -- 3. Record the edit and return the updated row.
    CALL sp_record_audit_action(p_user_id,'UPDATE','demand_forecast',p_record_id,
        NULL,JSON_OBJECT(p_field_name,p_new_value),p_ip_address);
    COMMIT;
    SELECT * FROM demand_forecast WHERE forecast_id=p_record_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_demand_forecast
-- Group: Demand forecasting and pricing link
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove demand forecast while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_demand_forecast(IN p_forecast_id INT)
BEGIN
    DELETE FROM demand_forecast WHERE forecast_id = p_forecast_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_demand_forecast
-- Group: Demand forecasting and pricing link
-- Operation: SHOW / list records
-- Purpose: Display demand forecast while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_demand_forecast()
BEGIN
    SELECT f.*,
    op.port_name AS origin_port,
    dp.port_name AS dest_port
    FROM demand_forecast f
    JOIN ports op ON op.port_id = f.origin_port_id
    JOIN ports dp ON dp.port_id = f.dest_port_id
    ORDER BY f.forecast_month DESC,
    f.forecast_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_demand_forecast
-- Group: Demand forecasting and pricing link
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search demand forecast while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_demand_forecast(IN p_origin_port_id INT,
IN p_dest_port_id INT,
IN p_container_type VARCHAR(10),
IN p_forecast_month DATE)
BEGIN
    SELECT f.*,
    op.port_name AS origin_port,
    dp.port_name AS dest_port
    FROM demand_forecast f
    JOIN ports op ON op.port_id = f.origin_port_id
    JOIN ports dp ON dp.port_id = f.dest_port_id
    WHERE (p_origin_port_id IS NULL OR f.origin_port_id = p_origin_port_id)
    AND (p_dest_port_id IS NULL OR f.dest_port_id = p_dest_port_id)
    AND (p_container_type IS NULL OR f.container_type = p_container_type)
    AND (p_forecast_month IS NULL OR f.forecast_month = p_forecast_month)
    ORDER BY f.forecast_month DESC,
    f.forecast_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_apply_forecast_pricing
-- Group: Demand forecasting and pricing link
-- Operation: Business logic / processing
-- Purpose: Apply previously saved manual demand forecast to pricing rules only on request.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_apply_forecast_pricing(
    IN p_user_id INT,
    IN p_forecast_id INT
)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company_id INT DEFAULT NULL;
    DECLARE v_origin INT DEFAULT NULL;
    DECLARE v_dest INT DEFAULT NULL;
    DECLARE v_container_type VARCHAR(10) DEFAULT NULL;
    DECLARE v_multiplier DECIMAL(4,2) DEFAULT NULL;
    DECLARE v_updated INT DEFAULT 0;
    DECLARE v_previous_actor INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @pricing_actor_user_id=v_previous_actor;
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT role, company_id
      INTO v_role, v_company_id
      FROM users
     WHERE user_id = p_user_id AND status = 'ACTIVE';

    IF v_role IS NULL OR v_role NOT IN ('ADMIN','SELLER') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.6: an active Admin or Seller is required';
    END IF;

    SELECT origin_port_id, dest_port_id, container_type, suggested_multiplier
      INTO v_origin, v_dest, v_container_type, v_multiplier
      FROM demand_forecast
     WHERE forecast_id = p_forecast_id;

    IF v_multiplier IS NULL OR v_multiplier <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR6.6: forecast must contain a positive suggested multiplier';
    END IF;

    START TRANSACTION;

    -- Use the existing AFTER UPDATE trigger so every changed rule receives
    -- exactly one pricing_audit row using the approved SRS columns.
    SET v_previous_actor=@pricing_actor_user_id;
    SET @pricing_actor_user_id=p_user_id;
    UPDATE pricing_rules
       SET demand_multiplier = v_multiplier
     WHERE origin_port_id = v_origin
       AND dest_port_id = v_dest
       AND container_type = v_container_type
       AND is_active = TRUE
       AND (v_role = 'ADMIN' OR seller_id = v_company_id);

    SET v_updated = ROW_COUNT();
    COMMIT;
    SET @pricing_actor_user_id=v_previous_actor;
    SELECT p_forecast_id AS forecast_id,
           v_multiplier AS applied_demand_multiplier,
           v_updated AS pricing_rules_updated;
END$$

-- ----------------------------------------------------------------------------
-- Profit and Loss
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_profit_loss
-- Group: Profit and Loss
-- Operation: GET / detail report
-- Purpose: Return profit loss while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_profit_loss(IN p_seller_id INT,
IN p_start_date DATE,
IN p_end_date DATE)
BEGIN
    SELECT pl.pl_id,
    pl.shipment_id,
    s.shipment_no,
    pl.seller_id,
    pl.period_month,
    pl.revenue,
    pl.freight_cost,
    pl.port_cost,
    pl.handling_cost,
    pl.claim_loss,
    pl.net_profit
    FROM profit_loss pl LEFT JOIN shipment s ON s.shipment_id = pl.shipment_id
    WHERE (p_seller_id IS NULL OR pl.seller_id = p_seller_id)
    AND (p_start_date IS NULL OR pl.period_month >= DATE(DATE_SUB(p_start_date,
    INTERVAL DAYOFMONTH(p_start_date) - 1 DAY)))
    AND (p_end_date IS NULL OR pl.period_month <= p_end_date)
    ORDER BY pl.period_month,
    pl.shipment_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_profit_loss_monthly
-- Group: Profit and Loss
-- Operation: GET / detail report
-- Purpose: Return profit loss monthly while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_profit_loss_monthly(IN p_seller_id INT,
IN p_start_date DATE,
IN p_end_date DATE)
BEGIN
    SELECT pl.period_month,
    SUM(pl.revenue) AS revenue,
    SUM(pl.freight_cost + pl.port_cost + pl.handling_cost) AS cost,
    SUM(pl.claim_loss) AS claim_loss,
    SUM(pl.net_profit) AS net_profit
    FROM profit_loss pl
    WHERE (p_seller_id IS NULL OR pl.seller_id = p_seller_id)
    AND (p_start_date IS NULL OR pl.period_month >= DATE(DATE_SUB(p_start_date,
    INTERVAL DAYOFMONTH(p_start_date) - 1 DAY)))
    AND (p_end_date IS NULL OR pl.period_month <= p_end_date)
    GROUP BY pl.period_month
    ORDER BY pl.period_month;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_calculate_profit_loss
-- Group: Profit and Loss
-- Operation: Business logic / processing
-- Purpose: Calculate current month P&L without writing or refreshing cache rows.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_calculate_profit_loss(IN p_shipment_id INT,IN p_period_month DATE)
BEGIN
    DECLARE v_month DATE;
    IF p_period_month IS NULL OR p_shipment_id IS NULL OR NOT EXISTS(
        SELECT 1 FROM shipment WHERE shipment_id=p_shipment_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Valid shipment and reporting month required';
    END IF;
    SET v_month=DATE_SUB(p_period_month,INTERVAL DAYOFMONTH(p_period_month)-1 DAY);
    SELECT s.shipment_id,s.seller_id,v_month AS period_month,
        COALESCE((SELECT SUM(i.total_amount) FROM billing_invoices i
          WHERE i.shipment_id=s.shipment_id AND i.status='PAID'
            AND (SELECT MAX(payment_date) FROM payments WHERE invoice_id=i.invoice_id)>=v_month
            AND (SELECT MAX(payment_date) FROM payments WHERE invoice_id=i.invoice_id)<DATE_ADD(v_month,INTERVAL 1 MONTH)),0) AS revenue,
        COALESCE(pl.freight_cost,0) AS freight_cost,
        COALESCE(pl.port_cost,0) AS port_cost,
        COALESCE(pl.handling_cost,0) AS handling_cost,
        COALESCE((SELECT SUM(c.approved_amount) FROM claims c WHERE c.shipment_id=s.shipment_id
          AND c.status='SETTLED' AND c.settled_at>=v_month
          AND c.settled_at<DATE_ADD(v_month,INTERVAL 1 MONTH)),0) AS claim_loss,
        (COALESCE((SELECT SUM(i.total_amount) FROM billing_invoices i
          WHERE i.shipment_id=s.shipment_id AND i.status='PAID'
            AND (SELECT MAX(payment_date) FROM payments WHERE invoice_id=i.invoice_id)>=v_month
            AND (SELECT MAX(payment_date) FROM payments WHERE invoice_id=i.invoice_id)<DATE_ADD(v_month,INTERVAL 1 MONTH)),0)
         -COALESCE(pl.freight_cost,0)-COALESCE(pl.port_cost,0)-COALESCE(pl.handling_cost,0)
         -COALESCE((SELECT SUM(c.approved_amount) FROM claims c WHERE c.shipment_id=s.shipment_id
            AND c.status='SETTLED' AND c.settled_at>=v_month
            AND c.settled_at<DATE_ADD(v_month,INTERVAL 1 MONTH)),0)) AS net_profit
    FROM shipment s
    LEFT JOIN profit_loss pl ON pl.pl_id=(SELECT MAX(p.pl_id) FROM profit_loss p
        WHERE p.shipment_id=s.shipment_id AND p.period_month=v_month)
    WHERE s.shipment_id=p_shipment_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_refresh_profit_loss
-- Group: Profit and Loss
-- Operation: Business logic / processing
-- Purpose: Recalculate P&L with paid-invoice month and settled claim losses.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_refresh_profit_loss(
    IN p_shipment_id INT,
    IN p_period_month DATE,
    IN p_freight_cost DECIMAL(14,2),
    IN p_port_cost DECIMAL(14,2),
    IN p_handling_cost DECIMAL(14,2)
)
BEGIN
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_month DATE;
    DECLARE v_invoice INT DEFAULT NULL;
    DECLARE v_inv_total DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_last_pay DATE DEFAULT NULL;
    DECLARE v_revenue DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_loss DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_pl INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_shipment_id IS NULL OR NOT EXISTS
       (SELECT 1 FROM shipment WHERE shipment_id = p_shipment_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR2.7: shipment does not exist';
    END IF;

    IF p_period_month IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR2.7: period month is required';
    END IF;

    IF COALESCE(p_freight_cost, 0) < 0
       OR COALESCE(p_port_cost, 0) < 0
       OR COALESCE(p_handling_cost, 0) < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR2.8: P&L costs cannot be negative';
    END IF;

    SET v_month = DATE_SUB(p_period_month,
                   INTERVAL DAYOFMONTH(p_period_month) - 1 DAY);

    START TRANSACTION;

    SELECT seller_id INTO v_seller
    FROM shipment
    WHERE shipment_id = p_shipment_id
    FOR UPDATE;

    -- SRS 7.10 specifies one invoice per shipment. Take a PAID invoice
    -- only; never infer paid revenue from the latest UNPAID invoice.
    SELECT MAX(invoice_id) INTO v_invoice
    FROM billing_invoices
    WHERE shipment_id = p_shipment_id
      AND status = 'PAID';

    IF v_invoice IS NOT NULL THEN
        SELECT total_amount INTO v_inv_total
        FROM billing_invoices
        WHERE invoice_id = v_invoice;

        SELECT MAX(payment_date) INTO v_last_pay
        FROM payments
        WHERE invoice_id = v_invoice;

        -- Approved assumption: recognize paid-invoice revenue exactly
        -- in the month of the invoice's last recorded payment.
        IF v_last_pay >= v_month
           AND v_last_pay < DATE_ADD(v_month, INTERVAL 1 MONTH) THEN
            SET v_revenue = COALESCE(v_inv_total, 0);
        END IF;
    END IF;

    -- Recompute the month-specific settled-claim total. This reconciles
    -- the FR7.6 claim-settlement trigger rather than adding it twice.
    SELECT COALESCE(SUM(approved_amount), 0) INTO v_loss
    FROM claims
    WHERE shipment_id = p_shipment_id
      AND status = 'SETTLED'
      AND settled_at >= v_month
      AND settled_at < DATE_ADD(v_month, INTERVAL 1 MONTH);

    SELECT MAX(pl_id) INTO v_pl
    FROM profit_loss
    WHERE shipment_id = p_shipment_id
      AND period_month = v_month;

    IF v_pl IS NULL THEN
        INSERT INTO profit_loss
            (shipment_id, seller_id, period_month, revenue,
             freight_cost, port_cost, handling_cost, claim_loss)
        VALUES
            (p_shipment_id, v_seller, v_month, v_revenue,
             COALESCE(p_freight_cost, 0), COALESCE(p_port_cost, 0),
             COALESCE(p_handling_cost, 0), v_loss);
        SET v_pl = LAST_INSERT_ID();
    ELSE
        UPDATE profit_loss
           SET revenue = v_revenue,
               freight_cost = COALESCE(p_freight_cost, 0),
               port_cost = COALESCE(p_port_cost, 0),
               handling_cost = COALESCE(p_handling_cost, 0),
               claim_loss = v_loss
         WHERE pl_id = v_pl;
    END IF;

    COMMIT;

    SELECT * FROM profit_loss WHERE pl_id = v_pl;
END$$

-- ============================================================================
-- MODULE 7 — Claims and Evidence Management — 16 procedure(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Claim processing
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_add_claim_comment
-- Group: Claim processing
-- Operation: CREATE / INSERT
-- Purpose: Store Consumer/Seller comments in claim_status_history with unchanged status.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_add_claim_comment(
    IN p_claim_id INT,
    IN p_user_id INT,
    IN p_comment VARCHAR(255)
)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company_id INT DEFAULT NULL;
    DECLARE v_customer_id INT DEFAULT NULL;
    DECLARE v_claim_consumer_id INT DEFAULT NULL;
    DECLARE v_claim_seller_id INT DEFAULT NULL;
    DECLARE v_claim_status VARCHAR(20) DEFAULT NULL;

    IF p_comment IS NULL OR TRIM(p_comment) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.7: comment cannot be empty';
    END IF;

    SELECT role, company_id
      INTO v_role, v_company_id
      FROM users
     WHERE user_id = p_user_id AND status = 'ACTIVE';

    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.7: an active user is required';
    END IF;

    SELECT customer_id
      INTO v_customer_id
      FROM customers
     WHERE user_id = p_user_id;

    SELECT cl.consumer_id, sh.seller_id, cl.status
      INTO v_claim_consumer_id, v_claim_seller_id, v_claim_status
      FROM claims cl
      JOIN shipment sh ON sh.shipment_id = cl.shipment_id
     WHERE cl.claim_id = p_claim_id;

    IF NOT (
        (v_role = 'CONSUMER' AND v_customer_id = v_claim_consumer_id)
        OR (v_role = 'SELLER' AND v_company_id = v_claim_seller_id)
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.7: only the claim Consumer or responsible Seller may comment';
    END IF;

    INSERT INTO claim_status_history (
        claim_id, old_status, new_status, changed_by, remarks
    )
    VALUES (
        p_claim_id, v_claim_status, v_claim_status, p_user_id, TRIM(p_comment)
    );

    SELECT LAST_INSERT_ID() AS history_id,
           p_claim_id AS claim_id,
           v_claim_status AS claim_status,
           TRIM(p_comment) AS comment;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_submit_claim
-- Group: Claim processing
-- Operation: CREATE / INSERT
-- Purpose: Submit claim while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_submit_claim(
    IN p_user_id INT,
    IN p_shipment_id INT,
    IN p_claim_type VARCHAR(10),
    IN p_description TEXT,
    IN p_claimed_amount DECIMAL(12,2),
    IN p_claim_window_days INT
)
BEGIN
    DECLARE v_customer_id INT DEFAULT NULL;
    DECLARE v_shipment_consumer_id INT DEFAULT NULL;
    DECLARE v_container_id INT DEFAULT NULL;
    DECLARE v_shipment_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_actual_arrival DATE DEFAULT NULL;
    DECLARE v_claim_id INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_claim_window_days IS NULL OR p_claim_window_days < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.3: claim window must be zero or a positive number of days';
    END IF;

    SELECT cu.customer_id
      INTO v_customer_id
      FROM customers cu
      JOIN users u ON u.user_id = cu.user_id
     WHERE u.user_id = p_user_id
       AND u.role = 'CONSUMER'
       AND u.status = 'ACTIVE';

    IF v_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.1: only an active Consumer can raise a claim';
    END IF;

    SELECT consumer_id, container_id, status, actual_arrival
      INTO v_shipment_consumer_id, v_container_id,
           v_shipment_status, v_actual_arrival
      FROM shipment
     WHERE shipment_id = p_shipment_id;

    IF v_shipment_consumer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.1: shipment does not exist';
    END IF;

    IF v_shipment_consumer_id <> v_customer_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.1: the shipment does not belong to this Consumer';
    END IF;

    IF v_shipment_status NOT IN ('ARRIVED', 'DELIVERED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.3: claims are allowed only for Arrived or Delivered shipments';
    END IF;

    -- A missing arrival date must never bypass the configurable claim window.
    IF v_actual_arrival IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.3: actual arrival date is required to validate the claim window';
    END IF;

    IF DATEDIFF(CURDATE(), v_actual_arrival) < 0
       OR DATEDIFF(CURDATE(), v_actual_arrival) > p_claim_window_days THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.3: the claim is outside the permitted claim window';
    END IF;

    IF p_claim_type IS NULL
       OR p_claim_type NOT IN ('LOSS', 'DAMAGE', 'DELAY', 'SHORTAGE')
       OR p_description IS NULL
       OR TRIM(p_description) = ''
       OR p_claimed_amount IS NULL
       OR p_claimed_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.1: valid claim type, description and positive claimed amount are required';
    END IF;

    START TRANSACTION;

    INSERT INTO claims (
        claim_no, shipment_id, container_id, consumer_id,
        claim_type, description, claimed_amount
    )
    VALUES (
        CONCAT('CLM', UPPER(SUBSTRING(REPLACE(UUID(), '-', ''), 1, 17))),
        p_shipment_id, v_container_id, v_customer_id,
        p_claim_type, TRIM(p_description), p_claimed_amount
    );

    SET v_claim_id = LAST_INSERT_ID();

    -- The INSERT trigger validates the claim only. This procedure writes
    -- the initial status-history row exactly once.
    INSERT INTO claim_status_history (
        claim_id, old_status, new_status, changed_by, remarks
    )
    VALUES (
        v_claim_id, NULL, 'SUBMITTED', p_user_id, 'Claim submitted'
    );

    COMMIT;

    SELECT claim_id, claim_no, status
      FROM claims
     WHERE claim_id = v_claim_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_claim_field
-- Group: Claim processing
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update claim field while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_claim_field(
    IN p_user_id INT,IN p_claim_id INT,IN p_field_name VARCHAR(64),IN p_new_value TEXT
)
BEGIN
    DECLARE v_shipment INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_number DECIMAL(12,2) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT shipment_id,status INTO v_shipment,v_status
    FROM claims WHERE claim_id=p_claim_id FOR UPDATE;
    IF v_shipment IS NULL OR v_status<>'SUBMITTED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only SUBMITTED claims can be edited';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM claims c JOIN customers cu ON cu.customer_id=c.consumer_id
       JOIN users u ON u.user_id=cu.user_id WHERE c.claim_id=p_claim_id
       AND u.user_id=p_user_id AND u.role='CONSUMER' AND u.status='ACTIVE') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only owning Consumer may update claim';
    END IF;
    IF p_field_name='claim_type' THEN
        IF p_new_value IS NULL OR p_new_value NOT IN ('LOSS','DAMAGE','DELAY','SHORTAGE') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid claim type';
        END IF;
        UPDATE claims SET claim_type=p_new_value WHERE claim_id=p_claim_id;
    ELSEIF p_field_name='description' THEN
        IF p_new_value IS NULL OR TRIM(p_new_value)='' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Claim description required';
        END IF;
        UPDATE claims SET description=TRIM(p_new_value) WHERE claim_id=p_claim_id;
    ELSEIF p_field_name='claimed_amount' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[0-9]{1,10}([.][0-9]{1,2})?$'
           OR CAST(p_new_value AS DECIMAL(12,2))<=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Positive claim amount required';
        END IF;
        SET v_number=CAST(p_new_value AS DECIMAL(12,2));
        UPDATE claims SET claimed_amount=v_number WHERE claim_id=p_claim_id;
    ELSEIF p_field_name='container_id' THEN
        IF p_new_value IS NULL OR p_new_value NOT REGEXP '^[1-9][0-9]*$'
           OR CHAR_LENGTH(p_new_value)>10 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Valid container ID required';
        END IF;
        SET v_container=CAST(p_new_value AS UNSIGNED);
        IF NOT EXISTS(SELECT 1 FROM shipment WHERE shipment_id=v_shipment
           AND container_id=v_container) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Claim container must match shipment';
        END IF;
        UPDATE claims SET container_id=v_container WHERE claim_id=p_claim_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Claim field not editable';
    END IF;
    COMMIT;
    SELECT claim_id,claim_no,claim_type,container_id,description,claimed_amount,status
    FROM claims WHERE claim_id=p_claim_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_claim
-- Group: Claim processing
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove claim while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_claim(IN p_claim_id INT,IN p_user_id INT)
BEGIN
    -- Faculty-approved rule: neither a withdrawal nor a deletion may erase
    -- evidence, claim status history, or financial claim records. The approved
    -- claims.status ENUM has no WITHDRAWN value. Do not invent one.
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Claim deletion disabled: SRS history must be preserved';
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_claims
-- Group: Claim processing
-- Operation: SHOW / list records
-- Purpose: Display claims while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_claims(IN p_user_id INT)
BEGIN
    CALL sp_search_claims(p_user_id,
    NULL);
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_claims
-- Group: Claim processing
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search claims while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_claims(IN p_user_id INT,
IN p_status VARCHAR(20))
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,
    company_id INTO v_role,
    v_company FROM users WHERE user_id = p_user_id AND status = 'ACTIVE';
    SELECT customer_id INTO v_customer FROM customers WHERE user_id = p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.3: an active user is
        required';
    END IF;
    SELECT cl.*,
    s.shipment_no
    FROM claims cl JOIN shipment s ON s.shipment_id = cl.shipment_id
    WHERE (v_role = 'ADMIN' OR (v_role = 'SELLER' AND s.seller_id = v_company)
    OR (v_role = 'CONSUMER' AND cl.consumer_id = v_customer))
    AND (p_status IS NULL OR cl.status = p_status)
    ORDER BY cl.raised_at DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_get_claim_details
-- Group: Claim processing
-- Operation: GET / detail report
-- Purpose: Return claim details while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_claim_details(IN p_claim_id INT,
IN p_user_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    DECLARE v_ok INT DEFAULT 0;
    SELECT role,
    company_id INTO v_role,
    v_company FROM users WHERE user_id = p_user_id AND status = 'ACTIVE';
    SELECT customer_id INTO v_customer FROM customers WHERE user_id = p_user_id;
    SELECT COUNT(*) INTO v_ok
    FROM claims cl JOIN shipment s ON s.shipment_id = cl.shipment_id
    WHERE cl.claim_id = p_claim_id
    AND (v_role = 'ADMIN' OR (v_role = 'SELLER' AND s.seller_id = v_company)
    OR (v_role = 'CONSUMER' AND cl.consumer_id = v_customer));
    IF v_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.7: you are not allowed to view this claim';
    END IF;
    SELECT cl.*,
    s.shipment_no FROM claims cl JOIN shipment s ON s.shipment_id =
    cl.shipment_id
    WHERE cl.claim_id = p_claim_id;
    SELECT * FROM claim_documents WHERE claim_id = p_claim_id ORDER BY uploaded_at
    DESC;
    SELECT h.*,
    u.full_name AS changed_by_name
    FROM claim_status_history h LEFT JOIN users u ON u.user_id = h.changed_by
    WHERE h.claim_id = p_claim_id ORDER BY h.changed_at,
    h.history_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_review_claim
-- Group: Claim processing
-- Operation: Other operation
-- Purpose: Review claim while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_review_claim(
    IN p_claim_id INT,
    IN p_user_id INT,
    IN p_decision VARCHAR(20),
    IN p_approved_amount DECIMAL(12,2),
    IN p_remarks VARCHAR(255)
)
BEGIN
    DECLARE v_company_id INT DEFAULT NULL;
    DECLARE v_shipment_seller_id INT DEFAULT NULL;
    DECLARE v_claimed_amount DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_old_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_new_amount DECIMAL(12,2) DEFAULT 0.00;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT company_id
      INTO v_company_id
      FROM users
     WHERE user_id = p_user_id
       AND role = 'SELLER'
       AND status = 'ACTIVE';

    IF v_company_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.4: an active Seller account is required to review a claim';
    END IF;

    IF p_decision IS NULL
       OR p_decision NOT IN ('UNDER_REVIEW', 'APPROVED', 'PARTIALLY_APPROVED', 'REJECTED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.4: decision must be UNDER_REVIEW, APPROVED, PARTIALLY_APPROVED or REJECTED';
    END IF;

    START TRANSACTION;

    SELECT cl.claimed_amount, sh.seller_id, cl.status
      INTO v_claimed_amount, v_shipment_seller_id, v_old_status
      FROM claims cl
      JOIN shipment sh ON sh.shipment_id = cl.shipment_id
     WHERE cl.claim_id = p_claim_id
     FOR UPDATE;

    IF v_old_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.4: claim does not exist';
    END IF;

    IF v_company_id <> v_shipment_seller_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.4: only the Seller responsible for this shipment may review the claim';
    END IF;

    IF p_decision = 'UNDER_REVIEW' THEN
        IF v_old_status <> 'SUBMITTED' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.4: only a SUBMITTED claim can be moved UNDER_REVIEW';
        END IF;
        SET v_new_amount = 0.00;
    ELSE
        IF v_old_status <> 'UNDER_REVIEW'
           AND NOT (p_decision = 'REJECTED' AND v_old_status = 'SUBMITTED') THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.4: the claim must be UNDER_REVIEW before approval or partial approval';
        END IF;

        IF p_remarks IS NULL OR TRIM(p_remarks) = '' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.4: a review reason is required';
        END IF;

        IF p_decision = 'APPROVED' THEN
            SET v_new_amount = v_claimed_amount;
        ELSEIF p_decision = 'PARTIALLY_APPROVED' THEN
            IF p_approved_amount IS NULL
               OR p_approved_amount <= 0
               OR p_approved_amount >= v_claimed_amount THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'FR7.4: partial approval must be greater than zero and less than the claimed amount';
            END IF;
            SET v_new_amount = p_approved_amount;
        ELSE
            SET v_new_amount = 0.00;
        END IF;
    END IF;

    UPDATE claims
       SET status = p_decision,
           approved_amount = v_new_amount,
           seller_remarks = p_remarks
     WHERE claim_id = p_claim_id;

    INSERT INTO claim_status_history (
        claim_id, old_status, new_status, changed_by, remarks
    )
    VALUES (
        p_claim_id, v_old_status, p_decision, p_user_id, p_remarks
    );

    COMMIT;

    SELECT claim_id, status, approved_amount, seller_remarks
      FROM claims
     WHERE claim_id = p_claim_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_settle_claim
-- Group: Claim processing
-- Operation: Other operation
-- Purpose: Seller-only settlement with stock adjustment and automatic P&L posting.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_settle_claim(
    IN p_claim_id INT,
    IN p_user_id INT,
    IN p_stock_id INT,
    IN p_quantity INT,
    IN p_remarks VARCHAR(255)
)
BEGIN
    DECLARE v_company_id INT DEFAULT NULL;
    DECLARE v_shipment_seller_id INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_claim_type VARCHAR(10) DEFAULT NULL;
    DECLARE v_shipment_id INT DEFAULT NULL;
    DECLARE v_stock_shipment_id INT DEFAULT NULL;
    DECLARE v_stock_quantity INT DEFAULT NULL;
    DECLARE v_damaged_quantity INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @ledger_txn_type = NULL;
        SET @ledger_ref_type = NULL;
        SET @ledger_ref_id = NULL;
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT company_id
      INTO v_company_id
      FROM users
     WHERE user_id = p_user_id
       AND role = 'SELLER'
       AND status = 'ACTIVE';

    IF v_company_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.6: an active Seller account is required to settle a claim';
    END IF;

    START TRANSACTION;

    SELECT cl.status, cl.claim_type, cl.shipment_id, sh.seller_id
      INTO v_status, v_claim_type, v_shipment_id, v_shipment_seller_id
      FROM claims cl
      JOIN shipment sh ON sh.shipment_id = cl.shipment_id
     WHERE cl.claim_id = p_claim_id
     FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.6: claim does not exist';
    END IF;

    IF v_company_id <> v_shipment_seller_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.6: only the Seller responsible for this shipment may settle the claim';
    END IF;

    IF v_status NOT IN ('APPROVED', 'PARTIALLY_APPROVED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR7.6: only an approved or partially approved claim can be settled';
    END IF;

    IF v_claim_type = 'DELAY' THEN
        IF p_stock_id IS NOT NULL OR COALESCE(p_quantity, 0) <> 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.6: a DELAY claim does not adjust inventory';
        END IF;
    ELSE
        IF p_stock_id IS NULL OR p_quantity IS NULL OR p_quantity <= 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.6: a stock row and positive affected quantity are required';
        END IF;

        SELECT shipment_id, quantity, damaged_qty
          INTO v_stock_shipment_id, v_stock_quantity, v_damaged_quantity
          FROM stock
         WHERE stock_id = p_stock_id
         FOR UPDATE;

        IF v_stock_shipment_id IS NULL OR v_stock_shipment_id <> v_shipment_id THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'FR7.6: selected stock row does not belong to the claim shipment';
        END IF;

        IF v_claim_type = 'DAMAGE' THEN
            IF p_quantity > (v_stock_quantity - COALESCE(v_damaged_quantity, 0)) THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'FR7.6: damaged quantity exceeds the available undamaged stock';
            END IF;

            SET @ledger_ref_type = 'CLAIM';
            SET @ledger_ref_id = p_claim_id;

            UPDATE stock
               SET damaged_qty = damaged_qty + p_quantity
             WHERE stock_id = p_stock_id;

            SET @ledger_ref_type = NULL;
            SET @ledger_ref_id = NULL;
        ELSE
            -- LOSS and SHORTAGE reduce the selected shipment-linked stock row.
            IF p_quantity > (v_stock_quantity - COALESCE(v_damaged_quantity, 0)) THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'FR7.6: lost quantity exceeds available undamaged stock';
            END IF;

            SET @ledger_txn_type = 'CLAIM_LOSS';
            SET @ledger_ref_type = 'CLAIM';
            SET @ledger_ref_id = p_claim_id;

            UPDATE stock
               SET quantity = quantity - p_quantity
             WHERE stock_id = p_stock_id;

            SET @ledger_txn_type = NULL;
            SET @ledger_ref_type = NULL;
            SET @ledger_ref_id = NULL;
        END IF;
    END IF;

    -- This status update fires the P&L trigger. net_profit is GENERATED and
    -- must not be assigned directly; claim_loss is the stored adjustment.
    UPDATE claims
       SET status = 'SETTLED',
           settled_at = NOW(),
           seller_remarks = COALESCE(p_remarks, seller_remarks)
     WHERE claim_id = p_claim_id;

    INSERT INTO claim_status_history (
        claim_id, old_status, new_status, changed_by, remarks
    )
    VALUES (
        p_claim_id, v_status, 'SETTLED', p_user_id,
        COALESCE(p_remarks, 'Claim settled')
    );

    COMMIT;

    SELECT claim_id, claim_no, status, approved_amount, settled_at
      FROM claims
     WHERE claim_id = p_claim_id;
END$$

-- ----------------------------------------------------------------------------
-- Claim documents
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_add_claim_document
-- Group: Claim documents
-- Operation: CREATE / INSERT
-- Purpose: Execute add claim document using existing database business rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_add_claim_document(IN p_claim_id INT,
IN p_user_id INT,
IN p_file_name VARCHAR(150),
IN p_file_path VARCHAR(255),
IN p_file_type VARCHAR(10))
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_claim_customer INT DEFAULT NULL;
    SELECT cl.status,
    cl.consumer_id INTO v_status,
    v_claim_customer
    FROM claims cl JOIN customers cu ON cu.customer_id = cl.consumer_id
    WHERE cl.claim_id = p_claim_id AND cu.user_id = p_user_id;
    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: you can only add
        evidence to your own claim';
    END IF;
    IF UPPER(p_file_type) NOT IN ('PDF',
    'JPG',
    'PNG') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: evidence must be a PDF,
    JPG or PNG file';
    END IF;
    INSERT INTO claim_documents (claim_id,
    file_name,
    file_path,
    file_type)
    VALUES (p_claim_id,
    p_file_name,
    p_file_path,
    UPPER(p_file_type));
    SELECT LAST_INSERT_ID() AS cdoc_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_update_claim_document
-- Group: Claim documents
-- Operation: Specific UPDATE / state change
-- Purpose: Validate and update claim document while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_update_claim_document(
    IN p_user_id INT,IN p_cdoc_id INT,IN p_field_name VARCHAR(64),IN p_new_value VARCHAR(255))
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    -- Only the submitting Consumer can correct metadata before review begins.
    SELECT COUNT(*) INTO v_allowed FROM claim_documents d
       JOIN claims cl ON cl.claim_id=d.claim_id
       JOIN customers cu ON cu.customer_id=cl.consumer_id
       JOIN users u ON u.user_id=cu.user_id
     WHERE d.cdoc_id=p_cdoc_id AND u.user_id=p_user_id AND u.role='CONSUMER'
       AND u.status='ACTIVE' AND cl.status='SUBMITTED';
    IF v_allowed<>1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Evidence not editable by this user';
    END IF;
    IF p_new_value IS NULL OR TRIM(p_new_value)='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Evidence value cannot be blank';
    END IF;
    IF p_field_name='file_name' THEN
        IF CHAR_LENGTH(p_new_value)>150 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='File name exceeds 150 characters';
        END IF;
        UPDATE claim_documents SET file_name=p_new_value WHERE cdoc_id=p_cdoc_id;
    ELSEIF p_field_name='file_path' THEN
        IF CHAR_LENGTH(p_new_value)>255 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='File path exceeds 255 characters';
        END IF;
        UPDATE claim_documents SET file_path=p_new_value WHERE cdoc_id=p_cdoc_id;
    ELSEIF p_field_name='file_type' THEN
        IF UPPER(p_new_value) NOT IN ('PDF','JPG','PNG') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Evidence must be PDF, JPG or PNG';
        END IF;
        UPDATE claim_documents SET file_type=UPPER(p_new_value) WHERE cdoc_id=p_cdoc_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Evidence field not editable';
    END IF;
    SELECT * FROM claim_documents WHERE cdoc_id=p_cdoc_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_delete_claim_document
-- Group: Claim documents
-- Operation: DELETE / controlled correction
-- Purpose: Safely remove claim document while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_delete_claim_document(IN p_user_id INT,IN p_cdoc_id INT)
BEGIN
    DECLARE v_allowed INT DEFAULT 0;
    DECLARE v_claim INT DEFAULT NULL;
    DECLARE v_name VARCHAR(150) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT claim_id,file_name INTO v_claim,v_name
    FROM claim_documents WHERE cdoc_id=p_cdoc_id FOR UPDATE;
    SELECT COUNT(*) INTO v_allowed FROM claims c JOIN customers cu ON cu.customer_id=c.consumer_id
    JOIN users u ON u.user_id=cu.user_id WHERE c.claim_id=v_claim
      AND u.user_id=p_user_id AND u.role='CONSUMER' AND u.status='ACTIVE'
      AND c.status='SUBMITTED';
    IF v_claim IS NULL OR v_allowed<>1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Only submitting Consumer can remove unreviewed evidence';
    END IF;
    DELETE FROM claim_documents WHERE cdoc_id=p_cdoc_id;
    CALL sp_record_audit_action(p_user_id,'DELETE','claim_documents',p_cdoc_id,
         JSON_OBJECT('claim_id',v_claim,'file_name',v_name),NULL,NULL);
    COMMIT;
    SELECT p_cdoc_id AS deleted_document_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_claim_documents
-- Group: Claim documents
-- Operation: SHOW / list records
-- Purpose: Display claim documents while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_claim_documents(IN p_user_id INT,IN p_claim_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    SELECT cd.* FROM claim_documents cd JOIN claims cl ON cl.claim_id=cd.claim_id
      JOIN shipment sh ON sh.shipment_id=cl.shipment_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND sh.seller_id=v_company)
        OR (v_role='CONSUMER' AND cl.consumer_id=v_customer))
       AND (p_claim_id IS NULL OR cd.claim_id=p_claim_id)
     ORDER BY cd.uploaded_at DESC,cd.cdoc_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_claim_documents
-- Group: Claim documents
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search claim documents while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_claim_documents(
    IN p_user_id INT,IN p_claim_id INT,IN p_file_type VARCHAR(10),IN p_filename VARCHAR(150))
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    SELECT cd.* FROM claim_documents cd JOIN claims cl ON cl.claim_id=cd.claim_id
      JOIN shipment sh ON sh.shipment_id=cl.shipment_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND sh.seller_id=v_company)
        OR (v_role='CONSUMER' AND cl.consumer_id=v_customer))
       AND (p_claim_id IS NULL OR cd.claim_id=p_claim_id)
       AND (p_file_type IS NULL OR cd.file_type=UPPER(p_file_type))
       AND (p_filename IS NULL OR cd.file_name LIKE CONCAT('%',p_filename,'%'))
     ORDER BY cd.uploaded_at DESC,cd.cdoc_id DESC;
END$$

-- ----------------------------------------------------------------------------
-- Claim history and comments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_show_claim_status_history
-- Group: Claim history and comments
-- Operation: SHOW / list records
-- Purpose: Display claim status history while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_show_claim_status_history(IN p_user_id INT,IN p_claim_id INT)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    -- History is read-only, including comment entries having identical old/new statuses.
    SELECT h.* FROM claim_status_history h JOIN claims cl ON cl.claim_id=h.claim_id
      JOIN shipment sh ON sh.shipment_id=cl.shipment_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND sh.seller_id=v_company)
        OR (v_role='CONSUMER' AND cl.consumer_id=v_customer))
       AND (p_claim_id IS NULL OR h.claim_id=p_claim_id)
     ORDER BY h.changed_at,h.history_id;
END$$

-- ----------------------------------------------------------------------------
-- PROCEDURE: sp_search_claim_status_history
-- Group: Claim history and comments
-- Operation: SEARCH / filtered retrieval
-- Purpose: Filter/search claim status history while preserving SRS and authorization rules.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_search_claim_status_history(
    IN p_user_id INT,IN p_claim_id INT,IN p_new_status VARCHAR(20),
    IN p_start_date DATE,IN p_end_date DATE)
BEGIN
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_customer INT DEFAULT NULL;
    SELECT role,company_id INTO v_role,v_company FROM users WHERE user_id=p_user_id AND status='ACTIVE';
    SELECT MAX(customer_id) INTO v_customer FROM customers WHERE user_id=p_user_id;
    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active account required to view records';
    END IF;
    IF p_start_date IS NOT NULL AND p_end_date IS NOT NULL AND p_start_date>p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid claim history date range';
    END IF;
    SELECT h.* FROM claim_status_history h JOIN claims cl ON cl.claim_id=h.claim_id
      JOIN shipment sh ON sh.shipment_id=cl.shipment_id
     WHERE (v_role='ADMIN' OR (v_role='SELLER' AND sh.seller_id=v_company)
        OR (v_role='CONSUMER' AND cl.consumer_id=v_customer))
       AND (p_claim_id IS NULL OR h.claim_id=p_claim_id)
       AND (p_new_status IS NULL OR h.new_status=p_new_status)
       AND (p_start_date IS NULL OR DATE(h.changed_at)>=p_start_date)
       AND (p_end_date IS NULL OR DATE(h.changed_at)<=p_end_date)
     ORDER BY h.changed_at,h.history_id;
END$$

DELIMITER ;

-- ============================================================================
-- SECTION 03 — TRIGGERS AND VALIDATIONS
-- ============================================================================
DELIMITER $$

-- ============================================================================
-- MODULE 1 — User and Access Management — 16 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Companies
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_company_before_insert
-- Group: Companies
-- Event: BEFORE INSERT on companies
-- Purpose: Reject invalid companies values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_company_before_insert
BEFORE INSERT ON companies
FOR EACH ROW
BEGIN
    -- Company identity fields must be usable; email/phone are NOT company columns.
    IF NEW.company_name IS NULL OR TRIM(NEW.company_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: company name is required';
    END IF;
    IF NEW.gst_number IS NOT NULL AND TRIM(NEW.gst_number) <> ''
       AND NEW.gst_number NOT REGEXP '^[0-9A-Z]{15}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: GST number must have 15 uppercase letters/digits';
    END IF;
    IF NEW.country IS NOT NULL AND TRIM(NEW.country) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: country cannot be empty when provided';
    END IF;
    -- Reference lookup: reject invented country names without new SRS columns.

    -- Validate country name without a separate lookup table.
    IF NEW.country IS NOT NULL THEN
        CALL sp_assert_country_name(NEW.country);
    END IF;
    -- GSTIN follows the Indian 15-character state/PAN/entity/check format.
    IF NEW.gst_number IS NOT NULL AND TRIM(NEW.gst_number) <> '' AND (
       NEW.gst_number NOT REGEXP '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z]Z[0-9A-Z]$'
       OR (CAST(SUBSTRING(NEW.gst_number,1,2) AS UNSIGNED) NOT BETWEEN 1 AND 38
           AND SUBSTRING(NEW.gst_number,1,2) NOT IN ('97','99'))
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: invalid GSTIN structure';
    END IF;
    -- IEC may use a 10-digit legacy code or a 10-character PAN-style code.
    IF NEW.iec_code IS NOT NULL AND (TRIM(NEW.iec_code) = '' OR (
       NEW.iec_code NOT REGEXP '^[0-9]{10}$' AND
       NEW.iec_code NOT REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$'
    )) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: IEC must be 10 digits or PAN format';
    END IF;
    IF NEW.city IS NOT NULL AND TRIM(NEW.city) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: city cannot be empty if provided';
    END IF;
    IF NEW.address IS NOT NULL AND TRIM(NEW.address) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: address cannot be empty if provided';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_company_before_update
-- Group: Companies
-- Event: BEFORE UPDATE on companies
-- Purpose: Reject invalid companies values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_company_before_update
BEFORE UPDATE ON companies
FOR EACH ROW
BEGIN
    -- Keep company details valid after a targeted UPDATE.
    IF NEW.company_name IS NULL OR TRIM(NEW.company_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: company name is required';
    END IF;
    IF NEW.gst_number IS NOT NULL AND TRIM(NEW.gst_number) <> ''
       AND NEW.gst_number NOT REGEXP '^[0-9A-Z]{15}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: GST number must have 15 uppercase letters/digits';
    END IF;
    IF NEW.country IS NOT NULL AND TRIM(NEW.country) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: country cannot be empty when provided';
    END IF;
    -- Changing company type would invalidate the role of assigned users.
    IF NOT (NEW.company_type <=> OLD.company_type)
       AND EXISTS (SELECT 1 FROM users WHERE company_id = OLD.company_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: cannot change company type while users are assigned';
    END IF;
    -- Reference lookup: reject invented country names without new SRS columns.

    -- Validate country name without a separate lookup table.
    IF NEW.country IS NOT NULL THEN
        CALL sp_assert_country_name(NEW.country);
    END IF;
    -- GSTIN follows the Indian 15-character state/PAN/entity/check format.
    IF NEW.gst_number IS NOT NULL AND TRIM(NEW.gst_number) <> '' AND (
       NEW.gst_number NOT REGEXP '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z]Z[0-9A-Z]$'
       OR (CAST(SUBSTRING(NEW.gst_number,1,2) AS UNSIGNED) NOT BETWEEN 1 AND 38
           AND SUBSTRING(NEW.gst_number,1,2) NOT IN ('97','99'))
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: invalid GSTIN structure';
    END IF;
    -- IEC may use a 10-digit legacy code or a 10-character PAN-style code.
    IF NEW.iec_code IS NOT NULL AND (TRIM(NEW.iec_code) = '' OR (
       NEW.iec_code NOT REGEXP '^[0-9]{10}$' AND
       NEW.iec_code NOT REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$'
    )) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: IEC must be 10 digits or PAN format';
    END IF;
    IF NEW.city IS NOT NULL AND TRIM(NEW.city) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: city cannot be empty if provided';
    END IF;
    IF NEW.address IS NOT NULL AND TRIM(NEW.address) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: address cannot be empty if provided';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Login and user accounts
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_user_before_insert
-- Group: Login and user accounts
-- Event: BEFORE INSERT on users
-- Purpose: Reject invalid users values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_user_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    -- Required user identity and credential fields.
    IF NEW.full_name IS NULL OR TRIM(NEW.full_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: user full name is required';
    END IF;
    IF NEW.email IS NULL OR TRIM(NEW.email) = ''
       OR NEW.email NOT REGEXP '^[^@[:space:]]+@[^@[:space:]]+[.][^@[:space:]]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: valid user email is required';
    END IF;
    IF NEW.password_hash IS NULL OR TRIM(NEW.password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: password hash is required';
    END IF;
    IF NEW.phone IS NOT NULL AND TRIM(NEW.phone) <> ''
       AND NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: phone must contain exactly 10 digits';
    END IF;
    IF NEW.failed_attempts IS NOT NULL AND NEW.failed_attempts < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: failed attempts cannot be negative';
    END IF;
    -- Admin has no company; Seller/Consumer must match their company type.
    CALL sp_internal_check_user_company(NEW.role, NEW.company_id);
    -- For this project, optional phone numbers must be exactly 10 digits.
    IF NEW.phone IS NOT NULL AND NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: phone must contain exactly 10 digits';
    END IF;
    IF NEW.email NOT REGEXP '^[A-Za-z0-9_+%-]+([.][A-Za-z0-9_+%-]+)*@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)+$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: enter a valid email with domain';
    END IF;
    -- Stored passwords must look like a hash, not plaintext; hashing happens in the application.
    IF CHAR_LENGTH(NEW.password_hash) < 40 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: password_hash must be a securely hashed value';
    END IF;
    IF NEW.full_name NOT REGEXP '[[:alpha:]]' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: user name must contain letters';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_user_before_update
-- Group: Login and user accounts
-- Event: BEFORE UPDATE on users
-- Purpose: Reject invalid users values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_user_before_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Revalidate all protected user fields after an UPDATE.
    IF NEW.full_name IS NULL OR TRIM(NEW.full_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: user full name is required';
    END IF;
    IF NEW.email IS NULL OR TRIM(NEW.email) = ''
       OR NEW.email NOT REGEXP '^[^@[:space:]]+@[^@[:space:]]+[.][^@[:space:]]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: valid user email is required';
    END IF;
    IF NEW.password_hash IS NULL OR TRIM(NEW.password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: password hash is required';
    END IF;
    IF NEW.phone IS NOT NULL AND TRIM(NEW.phone) <> ''
       AND NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: phone must contain exactly 10 digits';
    END IF;
    IF NEW.failed_attempts IS NOT NULL AND NEW.failed_attempts < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: failed attempts cannot be negative';
    END IF;
    -- Admin has no company; Seller/Consumer must match their company type.
    CALL sp_internal_check_user_company(NEW.role, NEW.company_id);
    -- For this project, optional phone numbers must be exactly 10 digits.
    IF NEW.phone IS NOT NULL AND NEW.phone NOT REGEXP '^[0-9]{10}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: phone must contain exactly 10 digits';
    END IF;
    IF NEW.email NOT REGEXP '^[A-Za-z0-9_+%-]+([.][A-Za-z0-9_+%-]+)*@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)+$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: enter a valid email with domain';
    END IF;
    -- Stored passwords must look like a hash, not plaintext; hashing happens in the application.
    IF CHAR_LENGTH(NEW.password_hash) < 40 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.2: password_hash must be a securely hashed value';
    END IF;
    IF NEW.full_name NOT REGEXP '[[:alpha:]]' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: user name must contain letters';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Consumers and customers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_customer_before_insert
-- Group: Consumers and customers
-- Event: BEFORE INSERT on customers
-- Purpose: Reject invalid customers values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_customer_before_insert
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    DECLARE v_role    VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    SELECT role, company_id
    INTO v_role, v_company
    FROM users
    WHERE user_id = NEW.user_id;
    IF v_role IS NULL OR v_role <> 'CONSUMER' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer must be linked to a Consumer user
        (FR1.1)';
    END IF;
    IF NOT (v_company <=> NEW.company_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer company must match the user company
        (FR1.1)';
    END IF;
    IF NEW.credit_limit IS NOT NULL AND NEW.credit_limit < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: customer credit limit cannot be negative';
    END IF;
    IF NEW.contact_person IS NOT NULL AND TRIM(NEW.contact_person) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: contact person cannot be blank';
    END IF;
    IF NEW.billing_address IS NOT NULL AND TRIM(NEW.billing_address) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: billing address cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_customer_before_update
-- Group: Consumers and customers
-- Event: BEFORE UPDATE on customers
-- Purpose: Reject invalid customers values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_customer_before_update
BEFORE UPDATE ON customers
FOR EACH ROW
BEGIN
    DECLARE v_role    VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    SELECT role, company_id
    INTO v_role, v_company
    FROM users
    WHERE user_id = NEW.user_id;
    IF v_role IS NULL OR v_role <> 'CONSUMER' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer must be linked to a Consumer user
        (FR1.1)';
    END IF;
    IF NOT (v_company <=> NEW.company_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer company must match the user company
        (FR1.1)';
    END IF;
    IF NEW.credit_limit IS NOT NULL AND NEW.credit_limit < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: customer credit limit cannot be negative';
    END IF;
    IF NEW.contact_person IS NOT NULL AND TRIM(NEW.contact_person) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: contact person cannot be blank';
    END IF;
    IF NEW.billing_address IS NOT NULL AND TRIM(NEW.billing_address) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.1: billing address cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Ports
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_port_coordinates_before_insert
-- Group: Ports
-- Event: BEFORE INSERT on ports
-- Purpose: Reject invalid ports values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_port_coordinates_before_insert
BEFORE INSERT ON ports
FOR EACH ROW
BEGIN
    IF NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR1.6: latitude must be between -90 and 90';
    END IF;
    IF NEW.longitude IS NOT NULL AND (NEW.longitude < -180 OR NEW.longitude > 180) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR1.6: longitude must be between -180 and 180';
    END IF;
    IF (NEW.latitude IS NULL AND NEW.longitude IS NOT NULL)
       OR (NEW.latitude IS NOT NULL AND NEW.longitude IS NULL) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: latitude and longitude must be provided together';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_port_before_insert
-- Group: Ports
-- Event: BEFORE INSERT on ports
-- Purpose: Reject invalid ports values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_port_before_insert
BEFORE INSERT ON ports
FOR EACH ROW
BEGIN
    IF NEW.port_code IS NULL OR TRIM(NEW.port_code) = ''
    OR NEW.port_name IS NULL OR TRIM(NEW.port_name) = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR1.6: port code and port name are required';
    END IF;
    -- Port codes are uppercase alphanumeric identifiers, not free text.
    IF NEW.port_code NOT REGEXP '^[A-Z0-9]{3,10}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: port code must be 3-10 uppercase letters/digits';
    END IF;

    -- Validate country name without a separate lookup table.
    IF NEW.country IS NOT NULL THEN
        CALL sp_assert_country_name(NEW.country);
    END IF;
    IF NEW.city IS NOT NULL AND TRIM(NEW.city) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: port city cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_port_coordinates_before_update
-- Group: Ports
-- Event: BEFORE UPDATE on ports
-- Purpose: Reject invalid ports values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_port_coordinates_before_update
BEFORE UPDATE ON ports
FOR EACH ROW
BEGIN
    IF NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR1.6: latitude must be between -90 and 90';
    END IF;
    IF NEW.longitude IS NOT NULL AND (NEW.longitude < -180 OR NEW.longitude > 180) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FR1.6: longitude must be between -180 and 180';
    END IF;
    IF (NEW.latitude IS NULL AND NEW.longitude IS NOT NULL)
       OR (NEW.latitude IS NOT NULL AND NEW.longitude IS NULL) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: latitude and longitude must be provided together';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_port_before_update
-- Group: Ports
-- Event: BEFORE UPDATE on ports
-- Purpose: Reject invalid ports values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_port_before_update
BEFORE UPDATE ON ports
FOR EACH ROW
BEGIN
    IF NEW.port_code IS NULL OR TRIM(NEW.port_code) = ''
    OR NEW.port_name IS NULL OR TRIM(NEW.port_name) = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR1.6: port code and port name are required';
    END IF;
    -- Port codes are uppercase alphanumeric identifiers, not free text.
    IF NEW.port_code NOT REGEXP '^[A-Z0-9]{3,10}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: port code must be 3-10 uppercase letters/digits';
    END IF;

    -- Validate country name without a separate lookup table.
    IF NEW.country IS NOT NULL THEN
        CALL sp_assert_country_name(NEW.country);
    END IF;
    IF NEW.city IS NOT NULL AND TRIM(NEW.city) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.6: port city cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Vessels
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_vessel_before_insert
-- Group: Vessels
-- Event: BEFORE INSERT on vessels
-- Purpose: Reject invalid vessels values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_vessel_before_insert
BEFORE INSERT ON vessels
FOR EACH ROW
BEGIN
    IF NEW.vessel_name IS NULL OR TRIM(NEW.vessel_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR1.7: vessel name is required';
    END IF;
    IF NEW.capacity_teu IS NOT NULL AND NEW.capacity_teu <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: vessel TEU capacity must be positive';
    END IF;
    -- Maritime IMO: seven digits; final digit is weighted check digit.
    IF NEW.imo_number IS NOT NULL THEN
       IF NEW.imo_number NOT REGEXP '^[0-9]{7}$' THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: IMO must contain seven digits';
       END IF;
       IF MOD(CAST(SUBSTRING(NEW.imo_number,1,1) AS UNSIGNED)*7
            + CAST(SUBSTRING(NEW.imo_number,2,1) AS UNSIGNED)*6
            + CAST(SUBSTRING(NEW.imo_number,3,1) AS UNSIGNED)*5
            + CAST(SUBSTRING(NEW.imo_number,4,1) AS UNSIGNED)*4
            + CAST(SUBSTRING(NEW.imo_number,5,1) AS UNSIGNED)*3
            + CAST(SUBSTRING(NEW.imo_number,6,1) AS UNSIGNED)*2, 10)
            <> CAST(SUBSTRING(NEW.imo_number,7,1) AS UNSIGNED) THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: IMO check digit is invalid';
       END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_vessel_before_update
-- Group: Vessels
-- Event: BEFORE UPDATE on vessels
-- Purpose: Reject invalid vessels values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_vessel_before_update
BEFORE UPDATE ON vessels
FOR EACH ROW
BEGIN
    IF NEW.vessel_name IS NULL OR TRIM(NEW.vessel_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR1.7: vessel name is required';
    END IF;
    IF NEW.capacity_teu IS NOT NULL AND NEW.capacity_teu <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: vessel TEU capacity must be positive';
    END IF;
    -- Maritime IMO: seven digits; final digit is weighted check digit.
    IF NEW.imo_number IS NOT NULL THEN
       IF NEW.imo_number NOT REGEXP '^[0-9]{7}$' THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: IMO must contain seven digits';
       END IF;
       IF MOD(CAST(SUBSTRING(NEW.imo_number,1,1) AS UNSIGNED)*7
            + CAST(SUBSTRING(NEW.imo_number,2,1) AS UNSIGNED)*6
            + CAST(SUBSTRING(NEW.imo_number,3,1) AS UNSIGNED)*5
            + CAST(SUBSTRING(NEW.imo_number,4,1) AS UNSIGNED)*4
            + CAST(SUBSTRING(NEW.imo_number,5,1) AS UNSIGNED)*3
            + CAST(SUBSTRING(NEW.imo_number,6,1) AS UNSIGNED)*2, 10)
            <> CAST(SUBSTRING(NEW.imo_number,7,1) AS UNSIGNED) THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: IMO check digit is invalid';
       END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Audit logs
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_audit_before_insert
-- Group: Audit logs
-- Event: BEFORE INSERT on audit_log
-- Purpose: Check audit_log input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_audit_before_insert
BEFORE INSERT ON audit_log
FOR EACH ROW
BEGIN
    IF NEW.action IS NULL OR TRIM(NEW.action) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.5: audit action must not be blank';
    END IF;
    IF NEW.ip_address IS NOT NULL AND TRIM(NEW.ip_address) <> '' AND
       NOT (IS_IPV4(NEW.ip_address) OR IS_IPV6(NEW.ip_address)) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.5: audit IP must be valid IPv4 or IPv6';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_audit_before_update
-- Group: Audit logs
-- Event: BEFORE UPDATE on audit_log
-- Purpose: Check audit_log input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_audit_before_update
BEFORE UPDATE ON audit_log
FOR EACH ROW
BEGIN
    IF NEW.action IS NULL OR TRIM(NEW.action) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.5: audit action must not be blank';
    END IF;
    IF NEW.ip_address IS NOT NULL AND TRIM(NEW.ip_address) <> '' AND
       NOT (IS_IPV4(NEW.ip_address) OR IS_IPV6(NEW.ip_address)) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.5: audit IP must be valid IPv4 or IPv6';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_audit_log_update
-- Group: Audit logs
-- Event: BEFORE UPDATE on audit_log
-- Purpose: Check audit_log input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_audit_log_update
BEFORE UPDATE ON audit_log
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical audit records cannot be updated';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_audit_log_delete
-- Group: Audit logs
-- Event: BEFORE DELETE on audit_log
-- Purpose: Check audit_log input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_audit_log_delete
BEFORE DELETE ON audit_log
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical audit records cannot be deleted';
END$$

-- ============================================================================
-- MODULE 2 — Shipment and Container Movement Tracking — 9 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Shipments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_shipment_before_insert
-- Group: Shipments
-- Event: BEFORE INSERT on shipment
-- Purpose: Reject invalid shipment values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_shipment_before_insert
BEFORE INSERT ON shipment
FOR EACH ROW
BEGIN
    DECLARE v_cont_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_port INT DEFAULT NULL;
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_max_weight DECIMAL(10,2) DEFAULT NULL;
    DECLARE v_max_volume DECIMAL(8,2) DEFAULT NULL;
    DECLARE v_vessel_status VARCHAR(15) DEFAULT NULL;

    SELECT status, current_port_id, seller_id, max_weight_kg, max_volume_cbm
      INTO v_cont_status, v_port, v_seller, v_max_weight, v_max_volume
      FROM containers WHERE container_id = NEW.container_id;

    IF NEW.status IS NULL OR NEW.status <> 'BOOKED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.1: new shipment status must be BOOKED';
    END IF;
    IF NEW.origin_port_id = NEW.dest_port_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.2: origin and destination must differ';
    END IF;
    IF v_cont_status IS NULL OR v_cont_status <> 'AVAILABLE'
       OR v_port IS NULL OR v_port <> NEW.origin_port_id
       OR v_seller IS NULL OR v_seller <> NEW.seller_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.3: container unavailable, wrong port or wrong seller';
    END IF;
    IF NEW.cargo_weight_kg IS NULL OR NEW.cargo_weight_kg <= 0
       OR NEW.cargo_volume_cbm IS NULL OR NEW.cargo_volume_cbm <= 0
       OR NEW.cargo_weight_kg > v_max_weight
       OR NEW.cargo_volume_cbm > v_max_volume THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.4: invalid kg/CBM or container capacity exceeded';
    END IF;
    IF NEW.quoted_price IS NULL OR NEW.quoted_price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.5: quotation must not be negative';
    END IF;
    IF NEW.etd IS NOT NULL AND NEW.eta IS NOT NULL AND NEW.eta < NEW.etd THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.1: ETA cannot precede ETD';
    END IF;
    IF NEW.vessel_id IS NOT NULL THEN
        SELECT MAX(status) INTO v_vessel_status
        FROM vessels WHERE vessel_id = NEW.vessel_id;
        IF v_vessel_status IS NULL OR v_vessel_status <> 'ACTIVE' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR1.7: shipment vessel must be ACTIVE';
        END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_shipment_before_update
-- Group: Shipments
-- Event: BEFORE UPDATE on shipment
-- Purpose: Check shipment input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_shipment_before_update
BEFORE UPDATE ON shipment
FOR EACH ROW
BEGIN
    IF NEW.seller_id <> OLD.seller_id OR NEW.consumer_id <> OLD.consumer_id
       OR NEW.container_id <> OLD.container_id
       OR NEW.origin_port_id <> OLD.origin_port_id OR NEW.dest_port_id <> OLD.dest_port_id
       OR NOT (NEW.quoted_price <=> OLD.quoted_price)
       OR NOT (NEW.cargo_weight_kg <=> OLD.cargo_weight_kg)
       OR NOT (NEW.cargo_volume_cbm <=> OLD.cargo_volume_cbm) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.8: booked shipment identity and totals cannot change';
    END IF;
    IF NEW.etd IS NOT NULL AND NEW.eta IS NOT NULL AND NEW.eta < NEW.etd THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.1: ETA cannot precede ETD';
    END IF;
    IF NEW.status IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.2: shipment status cannot be NULL';
    END IF;
    IF NEW.status <> OLD.status
       AND NOT (@movement_correction_shipment_id <=> NEW.shipment_id) AND NOT (
         (OLD.status='BOOKED' AND NEW.status IN ('LOADED','CANCELLED'))
      OR (OLD.status='LOADED' AND NEW.status IN ('DEPARTED','CANCELLED'))
      OR (OLD.status='DEPARTED' AND NEW.status='IN_TRANSIT')
      OR (OLD.status='IN_TRANSIT' AND NEW.status='ARRIVED')
      OR (OLD.status='ARRIVED' AND NEW.status='CUSTOMS_CLEARED')
      OR (OLD.status='CUSTOMS_CLEARED' AND NEW.status='DELIVERED')
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.2: invalid shipment status transition';
    END IF;
    IF NEW.status <> OLD.status
       AND NOT (@movement_correction_shipment_id <=> NEW.shipment_id) AND NOT EXISTS (
      SELECT 1 FROM container_movements cm WHERE cm.shipment_id=NEW.shipment_id
        AND cm.status=NEW.status
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.3: record a movement event to change shipment status';
    END IF;
    IF OLD.status IN ('DELIVERED','CANCELLED') AND (
       NOT (NEW.vessel_id <=> OLD.vessel_id)
       OR NOT (NEW.etd <=> OLD.etd)
       OR NOT (NEW.eta <=> OLD.eta)
       OR NOT (NEW.cargo_description <=> OLD.cargo_description)
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.1: closed shipment metadata cannot be edited';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Shipment items
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_shipment_items_before_insert
-- Group: Shipment items
-- Event: BEFORE INSERT on shipment_items
-- Purpose: Check shipment_items input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_shipment_items_before_insert
BEFORE INSERT ON shipment_items
FOR EACH ROW
BEGIN
    IF NEW.quantity IS NULL OR NEW.quantity <= 0 OR NEW.unit_price IS NULL OR NEW.unit_price < 0
       OR NEW.amount IS NULL OR NEW.amount <> ROUND(NEW.quantity * NEW.unit_price, 2) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.4: invalid item quantity, price or extended amount';
    END IF;
    IF NEW.weight_kg IS NULL OR NEW.weight_kg <= 0 OR NEW.volume_cbm IS NULL OR NEW.volume_cbm <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.4: item weight and CBM must be positive';
    END IF;
    IF NOT EXISTS (
       SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
       WHERE sh.shipment_id = NEW.shipment_id AND sh.seller_id = p.owner_company_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.2: shipment item must belong to its Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_shipment_items_before_update
-- Group: Shipment items
-- Event: BEFORE UPDATE on shipment_items
-- Purpose: Check shipment_items input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_shipment_items_before_update
BEFORE UPDATE ON shipment_items
FOR EACH ROW
BEGIN
    IF NEW.quantity IS NULL OR NEW.quantity <= 0 OR NEW.unit_price IS NULL OR NEW.unit_price < 0
       OR NEW.amount IS NULL OR NEW.amount <> ROUND(NEW.quantity * NEW.unit_price, 2) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.4: invalid item quantity, price or extended amount';
    END IF;
    IF NEW.weight_kg IS NULL OR NEW.weight_kg <= 0 OR NEW.volume_cbm IS NULL OR NEW.volume_cbm <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.4: item weight and CBM must be positive';
    END IF;
    IF NOT EXISTS (
       SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
       WHERE sh.shipment_id = NEW.shipment_id AND sh.seller_id = p.owner_company_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.2: shipment item must belong to its Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_shipment_item_delete
-- Group: Shipment items
-- Event: BEFORE DELETE on shipment_items
-- Purpose: Check shipment_items input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_shipment_item_delete
BEFORE DELETE ON shipment_items
FOR EACH ROW
BEGIN
    -- Only the controlled cancelled-shipment correction may delete a booked item.
    IF @shipment_item_delete_id IS NULL OR @shipment_item_delete_id<>OLD.item_id
       OR NOT EXISTS(SELECT 1 FROM shipment s WHERE s.shipment_id=OLD.shipment_id
                      AND s.status='CANCELLED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Use sp_delete_shipment_item after cancellation';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Movement tracking
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_container_movement_before_insert
-- Group: Movement tracking
-- Event: BEFORE INSERT on container_movements
-- Purpose: Check Seller/Admin authorization and the permitted status sequence.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_container_movement_before_insert
BEFORE INSERT ON container_movements
FOR EACH ROW
BEGIN
    DECLARE v_seller INT DEFAULT NULL;
    DECLARE v_consumer_user INT DEFAULT NULL;
    DECLARE v_container INT DEFAULT NULL;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_next VARCHAR(20) DEFAULT NULL;
    DECLARE v_role VARCHAR(10) DEFAULT NULL;
    DECLARE v_company INT DEFAULT NULL;
    DECLARE v_user_status VARCHAR(10) DEFAULT NULL;

    SELECT s.seller_id, s.container_id, s.status, cu.user_id
    INTO v_seller, v_container, v_status, v_consumer_user
    FROM shipment s
    JOIN customers cu ON cu.customer_id = s.consumer_id
    WHERE s.shipment_id = NEW.shipment_id;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='FR2.3: shipment does not exist';
    END IF;
    IF NEW.container_id <> v_container THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='FR2.3: movement container does not match shipment';
    END IF;

    IF NEW.status='BOOKED' THEN
        IF EXISTS (
            SELECT 1 FROM container_movements
            WHERE shipment_id=NEW.shipment_id
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT='FR2.2: BOOKED movement already exists';
        END IF;
    ELSE
        SELECT role,company_id,status
        INTO v_role,v_company,v_user_status
        FROM users WHERE user_id=NEW.updated_by;

        IF v_role IS NULL OR v_user_status <> 'ACTIVE' OR NOT (
             v_role='ADMIN'
             OR (v_role='SELLER' AND v_company=v_seller)
             OR (v_role='CONSUMER' AND NEW.updated_by=v_consumer_user
                 AND v_status='BOOKED' AND NEW.status='CANCELLED')
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT='FR2.2: only Seller/Admin or booked Consumer cancellation allowed';
        END IF;

        SET v_next = CASE v_status
          WHEN 'BOOKED' THEN 'LOADED'
          WHEN 'LOADED' THEN 'DEPARTED'
          WHEN 'DEPARTED' THEN 'IN_TRANSIT'
          WHEN 'IN_TRANSIT' THEN 'ARRIVED'
          WHEN 'ARRIVED' THEN 'CUSTOMS_CLEARED'
          WHEN 'CUSTOMS_CLEARED' THEN 'DELIVERED'
          ELSE NULL END;

        IF NEW.status='CANCELLED' THEN
            IF v_status NOT IN ('BOOKED','LOADED') THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT='FR2.2: cancellation allowed only before departure';
            END IF;
        ELSEIF v_next IS NULL OR NEW.status<>v_next THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT='FR2.2: invalid movement status sequence';
        END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_container_movement_update
-- Group: Movement tracking
-- Event: BEFORE UPDATE on container_movements
-- Purpose: Keep historical container_movements records append-only.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_container_movement_update
BEFORE UPDATE ON container_movements
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR2.3: movement events cannot be edited; insert a new
    event';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_container_movement_delete
-- Group: Movement tracking
-- Event: BEFORE DELETE on container_movements
-- Purpose: Keep historical container_movements records append-only.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_container_movement_delete
BEFORE DELETE ON container_movements
FOR EACH ROW
BEGIN
    -- Physical movement deletion is permitted only by the correction procedure.
    IF @movement_delete_id IS NULL OR @movement_delete_id<>OLD.movement_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Use sp_delete_container_movement for latest-event corrections';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_sync_shipment_and_container_after_movement_insert
-- Group: Movement tracking
-- Event: AFTER INSERT on container_movements
-- Purpose: Synchronize shipment/container state when a validated movement event is added.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_sync_shipment_and_container_after_movement_insert
AFTER INSERT ON container_movements
FOR EACH ROW
BEGIN
    IF NEW.status <> 'BOOKED' THEN
        UPDATE shipment
        SET status         = NEW.status,
        actual_arrival = IF(NEW.status = 'ARRIVED',
        DATE(NEW.event_time),
        actual_arrival)
        WHERE shipment_id = NEW.shipment_id;
    END IF;
    IF NEW.status IN ('DEPARTED', 'IN_TRANSIT') THEN
        UPDATE containers
        SET status          = 'IN_TRANSIT',
        current_port_id = COALESCE(NEW.port_id, current_port_id)
        WHERE container_id = NEW.container_id;
    ELSEIF NEW.status = 'DELIVERED' THEN
        UPDATE containers
        SET status          = 'AVAILABLE',
        current_port_id = COALESCE(NEW.port_id,
        (SELECT dest_port_id
        FROM shipment
        WHERE shipment_id = NEW.shipment_id))
        WHERE container_id = NEW.container_id;
    ELSEIF NEW.status = 'CANCELLED' THEN
        UPDATE containers
        SET status = 'AVAILABLE'
        WHERE container_id = NEW.container_id;
    ELSEIF NEW.port_id IS NOT NULL THEN
        UPDATE containers
        SET current_port_id = NEW.port_id
        WHERE container_id = NEW.container_id;
    END IF;
END$$

-- ============================================================================
-- MODULE 3 — Container Allocation, Booking and Pricing — 7 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Containers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_container_before_insert
-- Group: Containers
-- Event: BEFORE INSERT on containers
-- Purpose: Reject invalid containers values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_container_before_insert
BEFORE INSERT ON containers
FOR EACH ROW
BEGIN
    DECLARE v_company_type ENUM('CONSUMER','SELLER') DEFAULT NULL;
    SELECT company_type
    INTO v_company_type
    FROM companies
    WHERE company_id = NEW.seller_id;
    IF v_company_type IS NULL OR v_company_type <> 'SELLER' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR3.1: container must belong to a Seller company';
    END IF;
    IF NEW.size_ft IS NOT NULL AND NEW.size_ft NOT IN (20, 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR3.1: container size must be 20 or 40 feet';
    END IF;
    IF NEW.max_weight_kg IS NULL OR NEW.max_weight_kg <= 0
    OR NEW.max_volume_cbm IS NULL OR NEW.max_volume_cbm <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR3.1: container weight and volume capacities must
    be positive';
    END IF;
    IF NEW.container_number IS NULL OR NEW.container_number NOT REGEXP '^[A-Z0-9-]{5,15}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: invalid container number format';
    END IF;
    IF NEW.size_ft IS NULL OR NEW.size_ft NOT IN (20,40) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: container size must be 20 or 40';
    END IF;
    IF NEW.status IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: container status is required';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_container_before_update
-- Group: Containers
-- Event: BEFORE UPDATE on containers
-- Purpose: Reject invalid containers values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_container_before_update
BEFORE UPDATE ON containers
FOR EACH ROW
BEGIN
    DECLARE v_company_type ENUM('CONSUMER','SELLER') DEFAULT NULL;
    SELECT company_type
    INTO v_company_type
    FROM companies
    WHERE company_id = NEW.seller_id;
    IF v_company_type IS NULL OR v_company_type <> 'SELLER' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR3.1: container must belong to a Seller company';
    END IF;
    IF NEW.size_ft IS NOT NULL AND NEW.size_ft NOT IN (20, 40) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR3.1: container size must be 20 or 40 feet';
    END IF;
    IF NEW.max_weight_kg IS NULL OR NEW.max_weight_kg <= 0
    OR NEW.max_volume_cbm IS NULL OR NEW.max_volume_cbm <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR3.1: container weight and volume capacities must
    be positive';
    END IF;
    IF NEW.container_number IS NULL OR NEW.container_number NOT REGEXP '^[A-Z0-9-]{5,15}$' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: invalid container number format';
    END IF;
    IF NEW.size_ft IS NULL OR NEW.size_ft NOT IN (20,40) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: container size must be 20 or 40';
    END IF;
    IF NEW.status IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.1: container status is required';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Pricing rules and audit
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_pricing_before_insert
-- Group: Pricing rules and audit
-- Event: BEFORE INSERT on pricing_rules
-- Purpose: Reject invalid pricing_rules values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_pricing_before_insert
BEFORE INSERT ON pricing_rules
FOR EACH ROW
BEGIN
    IF NEW.origin_port_id = NEW.dest_port_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.5: price route must have distinct ports';
    END IF;
    IF NEW.base_rate IS NULL OR NEW.base_rate < 0
       OR COALESCE(NEW.rate_per_kg,0) < 0
       OR COALESCE(NEW.rate_per_cbm,0) < 0
       OR COALESCE(NEW.season_multiplier,1) <= 0
       OR COALESCE(NEW.demand_multiplier,1) <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.5: rates, charges or multipliers invalid';
    END IF;
    IF ROUND(COALESCE(NEW.season_multiplier,1) * COALESCE(NEW.demand_multiplier,1), 2) > 99.99 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: multiplier audit DECIMAL(4,2) overflow';
    END IF;
    IF NEW.valid_from IS NOT NULL AND NEW.valid_to IS NOT NULL
       AND NEW.valid_to < NEW.valid_from THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: invalid pricing validity dates';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM companies WHERE company_id = NEW.seller_id AND company_type = 'SELLER') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: rule must belong to Seller';
    END IF;
    IF NEW.is_active IS NULL OR NEW.is_active NOT IN (0,1) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: active flag must be 0 or 1';
    END IF;
    IF NEW.is_active = 1 AND EXISTS (
       SELECT 1 FROM pricing_rules pr
       WHERE pr.rule_id <> COALESCE(NEW.rule_id, -1)
         AND pr.seller_id = NEW.seller_id
         AND pr.origin_port_id = NEW.origin_port_id
         AND pr.dest_port_id = NEW.dest_port_id
         AND pr.container_type = NEW.container_type
         AND pr.is_active = 1
         AND (NEW.valid_to IS NULL OR pr.valid_from IS NULL OR NEW.valid_to >= pr.valid_from)
         AND (NEW.valid_from IS NULL OR pr.valid_to IS NULL OR NEW.valid_from <= pr.valid_to)
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: active pricing rules cannot overlap dates';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_pricing_before_update
-- Group: Pricing rules and audit
-- Event: BEFORE UPDATE on pricing_rules
-- Purpose: Reject invalid pricing_rules values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_pricing_before_update
BEFORE UPDATE ON pricing_rules
FOR EACH ROW
BEGIN
    IF NEW.seller_id <> OLD.seller_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: pricing rule owner cannot change';
    END IF;
    IF NEW.origin_port_id = NEW.dest_port_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.5: price route must have distinct ports';
    END IF;
    IF NEW.base_rate IS NULL OR NEW.base_rate < 0
       OR COALESCE(NEW.rate_per_kg,0) < 0
       OR COALESCE(NEW.rate_per_cbm,0) < 0
       OR COALESCE(NEW.season_multiplier,1) <= 0
       OR COALESCE(NEW.demand_multiplier,1) <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.5: rates, charges or multipliers invalid';
    END IF;
    IF ROUND(COALESCE(NEW.season_multiplier,1) * COALESCE(NEW.demand_multiplier,1), 2) > 99.99 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: multiplier audit DECIMAL(4,2) overflow';
    END IF;
    IF NEW.valid_from IS NOT NULL AND NEW.valid_to IS NOT NULL
       AND NEW.valid_to < NEW.valid_from THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: invalid pricing validity dates';
    END IF;
    IF NEW.is_active IS NULL OR NEW.is_active NOT IN (0,1) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: active flag must be 0 or 1';
    END IF;
    IF NEW.is_active = 1 AND EXISTS (
       SELECT 1 FROM pricing_rules pr
       WHERE pr.rule_id <> COALESCE(NEW.rule_id, -1)
         AND pr.seller_id = NEW.seller_id
         AND pr.origin_port_id = NEW.origin_port_id
         AND pr.dest_port_id = NEW.dest_port_id
         AND pr.container_type = NEW.container_type
         AND pr.is_active = 1
         AND (NEW.valid_to IS NULL OR pr.valid_from IS NULL OR NEW.valid_to >= pr.valid_from)
         AND (NEW.valid_from IS NULL OR pr.valid_to IS NULL OR NEW.valid_from <= pr.valid_to)
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR3.6: active pricing rules cannot overlap dates';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_pricing_audit_update
-- Group: Pricing rules and audit
-- Event: BEFORE UPDATE on pricing_audit
-- Purpose: Check pricing_audit input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_pricing_audit_update
BEFORE UPDATE ON pricing_audit
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical pricing-change history cannot be updated';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_pricing_audit_delete
-- Group: Pricing rules and audit
-- Event: BEFORE DELETE on pricing_audit
-- Purpose: Check pricing_audit input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_pricing_audit_delete
BEFORE DELETE ON pricing_audit
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical pricing-change history cannot be deleted';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_audit_pricing_after_update
-- Group: Pricing rules and audit
-- Event: AFTER UPDATE on pricing_rules
-- Purpose: Record previous/current pricing values when a Seller changes pricing rules.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_audit_pricing_after_update
AFTER UPDATE ON pricing_rules
FOR EACH ROW
BEGIN
    -- The SRS pricing_audit table has only old/new rate and multiplier pairs.
    -- @pricing_actor_user_id is set by authorized pricing/forecast procedures.
    IF NOT (OLD.base_rate <=> NEW.base_rate)
       OR NOT (OLD.rate_per_kg <=> NEW.rate_per_kg)
       OR NOT (OLD.rate_per_cbm <=> NEW.rate_per_cbm)
       OR NOT (OLD.season_multiplier <=> NEW.season_multiplier)
       OR NOT (OLD.demand_multiplier <=> NEW.demand_multiplier)
       OR NOT (OLD.is_active <=> NEW.is_active)
       OR NOT (OLD.valid_from <=> NEW.valid_from)
       OR NOT (OLD.valid_to <=> NEW.valid_to)
       OR NOT (OLD.origin_port_id <=> NEW.origin_port_id)
       OR NOT (OLD.dest_port_id <=> NEW.dest_port_id)
       OR NOT (OLD.container_type <=> NEW.container_type) THEN
        INSERT INTO pricing_audit (
            rule_id,old_rate,new_rate,old_multiplier,new_multiplier,changed_by
        ) VALUES (
            NEW.rule_id,OLD.base_rate,NEW.base_rate,
            ROUND(COALESCE(OLD.season_multiplier,1)*COALESCE(OLD.demand_multiplier,1),2),
            ROUND(COALESCE(NEW.season_multiplier,1)*COALESCE(NEW.demand_multiplier,1),2),
            @pricing_actor_user_id
        );
    END IF;
END$$

-- ============================================================================
-- MODULE 4 — Products, Stock and Inventory Management — 11 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Products
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_product_before_insert
-- Group: Products
-- Event: BEFORE INSERT on products
-- Purpose: Reject invalid products values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_product_before_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.sku IS NULL OR TRIM(NEW.sku) = ''
    OR NEW.product_name IS NULL OR TRIM(NEW.product_name) = ''
    OR NEW.unit_weight_kg IS NULL OR NEW.unit_weight_kg <= 0
    OR NEW.unit_price < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.1/FR4.2: product fields, positive weight and unit price are required';
    END IF;
    IF NEW.unit_price IS NULL OR NEW.unit_price < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: unit price must be zero or positive';
    END IF;
    IF NEW.hs_code IS NOT NULL AND (TRIM(NEW.hs_code) = '' OR
       NEW.hs_code NOT REGEXP '^[0-9]{6}([0-9]{2})?([0-9]{2})?([0-9]{2})?$') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: HS code must contain 6, 8, 10 or 12 digits';
    END IF;
    IF NEW.unit IS NOT NULL AND TRIM(NEW.unit) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: product unit cannot be blank';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM companies
                   WHERE company_id = NEW.owner_company_id AND company_type = 'SELLER') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: products must belong to a Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_product_before_update
-- Group: Products
-- Event: BEFORE UPDATE on products
-- Purpose: Reject invalid products values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_product_before_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.sku IS NULL OR TRIM(NEW.sku) = ''
    OR NEW.product_name IS NULL OR TRIM(NEW.product_name) = ''
    OR NEW.unit_weight_kg IS NULL OR NEW.unit_weight_kg <= 0
    OR NEW.unit_price < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.1/FR4.2: product fields, positive weight and unit price are required';
    END IF;
    IF NEW.unit_price IS NULL OR NEW.unit_price < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: unit price must be zero or positive';
    END IF;
    IF NEW.hs_code IS NOT NULL AND (TRIM(NEW.hs_code) = '' OR
       NEW.hs_code NOT REGEXP '^[0-9]{6}([0-9]{2})?([0-9]{2})?([0-9]{2})?$') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: HS code must contain 6, 8, 10 or 12 digits';
    END IF;
    IF NEW.unit IS NOT NULL AND TRIM(NEW.unit) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: product unit cannot be blank';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM companies
                   WHERE company_id = NEW.owner_company_id AND company_type = 'SELLER') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.1: products must belong to a Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Stock
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_stock_before_insert
-- Group: Stock
-- Event: BEFORE INSERT on stock
-- Purpose: Reject invalid stock values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_stock_before_insert
BEFORE INSERT ON stock
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 OR NEW.damaged_qty < 0 OR NEW.damaged_qty > NEW.quantity
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.6/FR4.7: invalid stock quantity';
    END IF;
    IF NEW.quantity IS NULL OR NEW.damaged_qty IS NULL
       OR NEW.quantity < 0 OR NEW.damaged_qty < 0 OR NEW.damaged_qty > NEW.quantity THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.6: stock and damaged quantities are invalid';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND (
       NEW.container_id IS NULL OR NOT EXISTS (
          SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
          WHERE sh.shipment_id = NEW.shipment_id AND sh.container_id = NEW.container_id
            AND sh.seller_id = p.owner_company_id
       )) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.3: booked stock must match shipment, container and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_stock_before_update
-- Group: Stock
-- Event: BEFORE UPDATE on stock
-- Purpose: Reject invalid stock values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_stock_before_update
BEFORE UPDATE ON stock
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 OR NEW.damaged_qty < 0 OR NEW.damaged_qty > NEW.quantity
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.6/FR4.7: invalid stock quantity';
    END IF;
    IF NEW.quantity IS NULL OR NEW.damaged_qty IS NULL
       OR NEW.quantity < 0 OR NEW.damaged_qty < 0 OR NEW.damaged_qty > NEW.quantity THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.6: stock and damaged quantities are invalid';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND (
       NEW.container_id IS NULL OR NOT EXISTS (
          SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
          WHERE sh.shipment_id = NEW.shipment_id AND sh.container_id = NEW.container_id
            AND sh.seller_id = p.owner_company_id
       )) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR4.3: booked stock must match shipment, container and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Inventory ledger
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_inventory_ledger_update
-- Group: Inventory ledger
-- Event: BEFORE UPDATE on inventory_ledger
-- Purpose: Keep historical inventory_ledger records append-only.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_inventory_ledger_update
BEFORE UPDATE ON inventory_ledger
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.5: inventory ledger entries cannot be edited';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_inventory_ledger_delete
-- Group: Inventory ledger
-- Event: BEFORE DELETE on inventory_ledger
-- Purpose: Keep historical inventory_ledger records append-only.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_inventory_ledger_delete
BEFORE DELETE ON inventory_ledger
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR4.5: inventory ledger entries cannot be deleted';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_record_inventory_ledger_after_stock_insert
-- Group: Inventory ledger
-- Event: AFTER INSERT on stock
-- Purpose: Record stock additions automatically in the immutable inventory ledger.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_record_inventory_ledger_after_stock_insert
AFTER INSERT ON stock
FOR EACH ROW
BEGIN
    IF NEW.quantity > 0 THEN
        INSERT INTO inventory_ledger (
        stock_id,
        product_id,
        txn_type,
        quantity,
        balance_after,
        reference_type,
        reference_id
        )
        VALUES (
        NEW.stock_id,
        NEW.product_id,
        'IN',
        NEW.quantity,
        NEW.quantity,
        COALESCE(@ledger_ref_type, IF(NEW.shipment_id IS NULL, 'UPLOAD',
        'SHIPMENT')),
        COALESCE(@ledger_ref_id, NEW.shipment_id)
        );
    END IF;
    IF NEW.damaged_qty > 0 THEN
        INSERT INTO inventory_ledger (
        stock_id,
        product_id,
        txn_type,
        quantity,
        balance_after,
        reference_type,
        reference_id
        )
        VALUES (
        NEW.stock_id,
        NEW.product_id,
        'DAMAGE',
        NEW.damaged_qty,
        NEW.quantity,
        COALESCE(@ledger_ref_type, IF(NEW.shipment_id IS NULL, 'UPLOAD',
        'SHIPMENT')),
        COALESCE(@ledger_ref_id, NEW.shipment_id)
        );
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_record_inventory_ledger_after_stock_update
-- Group: Inventory ledger
-- Event: AFTER UPDATE on stock
-- Purpose: Record stock increases, decreases and damage adjustments in inventory ledger.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_record_inventory_ledger_after_stock_update
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
    IF NEW.quantity <> OLD.quantity THEN
        INSERT INTO inventory_ledger (
        stock_id,
        product_id,
        txn_type,
        quantity,
        balance_after,
        reference_type,
        reference_id
        )
        VALUES (
        NEW.stock_id,
        NEW.product_id,
        COALESCE(@ledger_txn_type, IF(NEW.quantity > OLD.quantity, 'IN',
        'OUT')),
        ABS(NEW.quantity - OLD.quantity),
        NEW.quantity,
        COALESCE(@ledger_ref_type, IF(NEW.shipment_id IS NULL, NULL,
        'SHIPMENT')),
        COALESCE(@ledger_ref_id, NEW.shipment_id)
        );
    END IF;
    IF NEW.damaged_qty <> OLD.damaged_qty THEN
        INSERT INTO inventory_ledger (
        stock_id,
        product_id,
        txn_type,
        quantity,
        balance_after,
        reference_type,
        reference_id
        )
        VALUES (
        NEW.stock_id,
        NEW.product_id,
        IF(NEW.damaged_qty > OLD.damaged_qty, 'DAMAGE', 'ADJUST'),
        ABS(NEW.damaged_qty - OLD.damaged_qty),
        NEW.quantity,
        COALESCE(@ledger_ref_type, IF(NEW.shipment_id IS NULL, NULL,
        'SHIPMENT')),
        COALESCE(@ledger_ref_id, NEW.shipment_id)
        );
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Sales transactions
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_sales_before_insert
-- Group: Sales transactions
-- Event: BEFORE INSERT on sales_transactions
-- Purpose: Check sales_transactions input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_sales_before_insert
BEFORE INSERT ON sales_transactions
FOR EACH ROW
BEGIN
    IF NEW.quantity IS NULL OR NEW.quantity <= 0 OR NEW.unit_price IS NULL OR NEW.unit_price < 0
       OR NEW.total_amount IS NULL OR NEW.total_amount <> ROUND(NEW.quantity * NEW.unit_price, 2)
       OR NEW.sale_date IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: invalid sale quantity, price, amount or date';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND NOT EXISTS (
       SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
       WHERE sh.shipment_id = NEW.shipment_id AND sh.consumer_id = NEW.customer_id
         AND sh.seller_id = p.owner_company_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sale must match shipment buyer and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_sales_before_update
-- Group: Sales transactions
-- Event: BEFORE UPDATE on sales_transactions
-- Purpose: Check sales_transactions input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_sales_before_update
BEFORE UPDATE ON sales_transactions
FOR EACH ROW
BEGIN
    IF NEW.quantity IS NULL OR NEW.quantity <= 0 OR NEW.unit_price IS NULL OR NEW.unit_price < 0
       OR NEW.total_amount IS NULL OR NEW.total_amount <> ROUND(NEW.quantity * NEW.unit_price, 2)
       OR NEW.sale_date IS NULL THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: invalid sale quantity, price, amount or date';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND NOT EXISTS (
       SELECT 1 FROM shipment sh JOIN products p ON p.product_id = NEW.product_id
       WHERE sh.shipment_id = NEW.shipment_id AND sh.consumer_id = NEW.customer_id
         AND sh.seller_id = p.owner_company_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sale must match shipment buyer and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_sales_transaction_delete
-- Group: Sales transactions
-- Event: BEFORE DELETE on sales_transactions
-- Purpose: Check sales_transactions input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_sales_transaction_delete
BEFORE DELETE ON sales_transactions
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: booked sales history cannot be deleted';
END$$

-- ============================================================================
-- MODULE 5 — Billing, Invoices and Payments — 11 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Invoices
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_invoice_before_insert
-- Group: Invoices
-- Event: BEFORE INSERT on billing_invoices
-- Purpose: Check billing_invoices input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_invoice_before_insert
BEFORE INSERT ON billing_invoices
FOR EACH ROW
BEGIN
    IF NEW.issue_date IS NULL OR NEW.due_date IS NULL OR NEW.due_date < NEW.issue_date THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: due date cannot precede issue date';
    END IF;
    IF NEW.sub_total IS NULL OR NEW.sub_total < 0 OR NEW.tax_amount IS NULL OR NEW.tax_amount < 0
       OR NEW.total_amount IS NULL OR NEW.total_amount <> NEW.sub_total + NEW.tax_amount
       OR NEW.paid_amount IS NULL OR NEW.paid_amount < 0 OR NEW.paid_amount > NEW.total_amount THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice totals and paid amount inconsistent';
    END IF;
    IF NEW.status IS NULL OR NEW.status <> CASE
       WHEN NEW.total_amount > 0 AND NEW.paid_amount = NEW.total_amount THEN 'PAID'
       WHEN NEW.paid_amount > 0 THEN 'PARTIAL'
       ELSE 'UNPAID' END THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.4: invoice status does not match paid amount';
    END IF;
    IF NOT EXISTS (
       SELECT 1 FROM shipment sh WHERE sh.shipment_id = NEW.shipment_id
         AND sh.consumer_id = NEW.consumer_id AND sh.seller_id = NEW.seller_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice must match shipment buyer and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_invoice_before_update
-- Group: Invoices
-- Event: BEFORE UPDATE on billing_invoices
-- Purpose: Check billing_invoices input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_invoice_before_update
BEFORE UPDATE ON billing_invoices
FOR EACH ROW
BEGIN
    IF NEW.issue_date IS NULL OR NEW.due_date IS NULL OR NEW.due_date < NEW.issue_date THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: due date cannot precede issue date';
    END IF;
    IF NEW.sub_total IS NULL OR NEW.sub_total < 0 OR NEW.tax_amount IS NULL OR NEW.tax_amount < 0
       OR NEW.total_amount IS NULL OR NEW.total_amount <> NEW.sub_total + NEW.tax_amount
       OR NEW.paid_amount IS NULL OR NEW.paid_amount < 0 OR NEW.paid_amount > NEW.total_amount THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice totals and paid amount inconsistent';
    END IF;
    IF NEW.status IS NULL OR NEW.status <> CASE
       WHEN NEW.total_amount > 0 AND NEW.paid_amount = NEW.total_amount THEN 'PAID'
       WHEN NEW.paid_amount > 0 THEN 'PARTIAL'
       ELSE 'UNPAID' END THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.4: invoice status does not match paid amount';
    END IF;
    IF NOT EXISTS (
       SELECT 1 FROM shipment sh WHERE sh.shipment_id = NEW.shipment_id
         AND sh.consumer_id = NEW.consumer_id AND sh.seller_id = NEW.seller_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice must match shipment buyer and Seller';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Invoice line items
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_invoice_item_before_insert
-- Group: Invoice line items
-- Event: BEFORE INSERT on invoice_line_items
-- Purpose: Check invoice_line_items input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_invoice_item_before_insert
BEFORE INSERT ON invoice_line_items
FOR EACH ROW
BEGIN
    IF NEW.item_type IS NULL OR NEW.quantity IS NULL OR NEW.quantity <= 0
       OR NEW.unit_price IS NULL OR NEW.unit_price < 0 OR NEW.amount IS NULL
       OR NEW.amount <> ROUND(NEW.quantity * NEW.unit_price, 2) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invalid invoice line type, quantity, price or amount';
    END IF;
    IF NEW.description IS NOT NULL AND TRIM(NEW.description) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice item description cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_invoice_item_before_update
-- Group: Invoice line items
-- Event: BEFORE UPDATE on invoice_line_items
-- Purpose: Check invoice_line_items input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_invoice_item_before_update
BEFORE UPDATE ON invoice_line_items
FOR EACH ROW
BEGIN
    IF NEW.item_type IS NULL OR NEW.quantity IS NULL OR NEW.quantity <= 0
       OR NEW.unit_price IS NULL OR NEW.unit_price < 0 OR NEW.amount IS NULL
       OR NEW.amount <> ROUND(NEW.quantity * NEW.unit_price, 2) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invalid invoice line type, quantity, price or amount';
    END IF;
    IF NEW.description IS NOT NULL AND TRIM(NEW.description) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.1: invoice item description cannot be blank';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Payments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_payment_before_insert
-- Group: Payments
-- Event: BEFORE INSERT on payments
-- Purpose: Reject invalid payments values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_payment_before_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    IF NEW.amount IS NULL OR NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR5.3: payment amount must be greater than zero';
    END IF;
    IF NEW.payment_mode IS NULL OR NEW.payment_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR5.3: payment mode and payment date are
        required';
    END IF;
    IF NEW.reference_no IS NOT NULL AND TRIM(NEW.reference_no) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment reference cannot be blank';
    END IF;
    IF NEW.payment_mode IN ('BANK','UPI','CHEQUE') AND
       (NEW.reference_no IS NULL OR TRIM(NEW.reference_no) = '') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: noncash payments require reference number';
    END IF;
    IF NEW.payment_date > CURDATE() THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment date cannot be in the future';
    END IF;
    IF EXISTS (
       SELECT 1 FROM billing_invoices bi WHERE bi.invoice_id = NEW.invoice_id
         AND NEW.payment_date < bi.issue_date
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment date cannot precede invoice issue date';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_payment_balance_before_insert
-- Group: Payments
-- Event: BEFORE INSERT on payments
-- Purpose: Reject invalid payments values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_payment_balance_before_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_paid DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_status VARCHAR(10) DEFAULT NULL;
    SELECT total_amount, paid_amount, status INTO v_total, v_paid, v_status
      FROM billing_invoices WHERE invoice_id = NEW.invoice_id;
    IF v_total IS NULL OR v_status = 'PAID' OR NEW.amount > v_total - v_paid THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid payment: invoice missing, paid, or amount exceeds balance';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_block_cancelled_shipment_payment_before_insert
-- Purpose: Reject new payments for a shipment already CANCELLED.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_block_cancelled_shipment_payment_before_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM billing_invoices bi
        JOIN shipment s ON s.shipment_id = bi.shipment_id
        WHERE bi.invoice_id = NEW.invoice_id AND s.status = 'CANCELLED'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='FR5.3: payments cannot be recorded for cancelled shipments';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_payment_before_update
-- Group: Payments
-- Event: BEFORE UPDATE on payments
-- Purpose: Reject invalid payments values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_payment_before_update
BEFORE UPDATE ON payments
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_paid DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_status VARCHAR(10) DEFAULT NULL;
    IF NEW.invoice_id <> OLD.invoice_id OR NOT (NEW.recorded_by <=> OLD.recorded_by) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invoice and recording user cannot be reassigned';
    END IF;
    IF NEW.amount IS NULL OR NEW.amount <= 0
       OR NEW.payment_mode IS NULL OR NEW.payment_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment requires positive amount, mode and date';
    END IF;
    SELECT total_amount, paid_amount, status INTO v_total, v_paid, v_status
      FROM billing_invoices WHERE invoice_id = OLD.invoice_id;
    IF v_status = 'PAID' OR v_total IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Paid invoice payments cannot be changed';
    END IF;
    IF v_paid - OLD.amount + NEW.amount > v_total THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated payment exceeds remaining invoice value';
    END IF;
    IF NEW.reference_no IS NOT NULL AND TRIM(NEW.reference_no) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment reference cannot be blank';
    END IF;
    IF NEW.payment_mode IN ('BANK','UPI','CHEQUE') AND
       (NEW.reference_no IS NULL OR TRIM(NEW.reference_no) = '') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: noncash payments require reference number';
    END IF;
    IF NEW.payment_date > CURDATE() THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment date cannot be in the future';
    END IF;
    IF EXISTS (
       SELECT 1 FROM billing_invoices bi WHERE bi.invoice_id = NEW.invoice_id
         AND NEW.payment_date < bi.issue_date
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR5.3: payment date cannot precede invoice issue date';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_payment_before_delete
-- Group: Payments
-- Event: BEFORE DELETE on payments
-- Purpose: Reject invalid payments values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_payment_before_delete
BEFORE DELETE ON payments
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(10);
    SELECT status INTO v_status FROM billing_invoices WHERE invoice_id = OLD.invoice_id;
    IF v_status = 'PAID' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A payment on a paid invoice cannot be deleted';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_update_invoice_status_after_payment_insert
-- Group: Payments
-- Event: AFTER INSERT on payments
-- Purpose: Add the recorded payment to the invoice total and recalculate its status.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_update_invoice_status_after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    UPDATE billing_invoices
    SET status = CASE
    WHEN paid_amount + NEW.amount >= total_amount THEN 'PAID'
    WHEN paid_amount + NEW.amount > 0 THEN 'PARTIAL'
    ELSE 'UNPAID'
    END,
    paid_amount = paid_amount + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_update_invoice_status_after_payment_update
-- Group: Payments
-- Event: AFTER UPDATE on payments
-- Purpose: Recalculate invoice paid amount/status after a permitted payment correction.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_update_invoice_status_after_payment_update
AFTER UPDATE ON payments
FOR EACH ROW
BEGIN
    UPDATE billing_invoices
       SET status = CASE
                    WHEN paid_amount - OLD.amount + NEW.amount >= total_amount THEN 'PAID'
                    WHEN paid_amount - OLD.amount + NEW.amount > 0 THEN 'PARTIAL'
                    ELSE 'UNPAID' END,
           paid_amount = paid_amount - OLD.amount + NEW.amount
     WHERE invoice_id = NEW.invoice_id;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_update_invoice_status_after_payment_delete
-- Group: Payments
-- Event: AFTER DELETE on payments
-- Purpose: Recalculate invoice paid amount/status after a permitted payment deletion.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_update_invoice_status_after_payment_delete
AFTER DELETE ON payments
FOR EACH ROW
BEGIN
    UPDATE billing_invoices
       SET status = CASE
                    WHEN paid_amount - OLD.amount >= total_amount THEN 'PAID'
                    WHEN paid_amount - OLD.amount > 0 THEN 'PARTIAL'
                    ELSE 'UNPAID' END,
           paid_amount = paid_amount - OLD.amount
     WHERE invoice_id = OLD.invoice_id;
END$$

-- ============================================================================
-- MODULE 6 — Analytics, Forecasting and Profit & Loss — 12 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- ABC classification
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_abc_before_insert
-- Group: ABC classification
-- Event: BEFORE INSERT on abc_classification_result
-- Purpose: Check abc_classification_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_abc_before_insert
BEFORE INSERT ON abc_classification_result
FOR EACH ROW
BEGIN
    IF NEW.abc_class IS NOT NULL AND NEW.abc_class NOT IN ('A','B','C') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: classification must be A, B or C';
    END IF;
    IF NEW.annual_value IS NOT NULL AND NEW.annual_value < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: annual value cannot be negative';
    END IF;
    IF NEW.cumulative_pct IS NOT NULL AND (NEW.cumulative_pct < 0 OR NEW.cumulative_pct > 100) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: cumulative share must be 0-100';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_abc_before_update
-- Group: ABC classification
-- Event: BEFORE UPDATE on abc_classification_result
-- Purpose: Check abc_classification_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_abc_before_update
BEFORE UPDATE ON abc_classification_result
FOR EACH ROW
BEGIN
    IF NEW.abc_class IS NOT NULL AND NEW.abc_class NOT IN ('A','B','C') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: classification must be A, B or C';
    END IF;
    IF NEW.annual_value IS NOT NULL AND NEW.annual_value < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: annual value cannot be negative';
    END IF;
    IF NEW.cumulative_pct IS NOT NULL AND (NEW.cumulative_pct < 0 OR NEW.cumulative_pct > 100) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.3: cumulative share must be 0-100';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Inventory turnover
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_turnover_before_insert
-- Group: Inventory turnover
-- Event: BEFORE INSERT on inventory_turnover_result
-- Purpose: Check inventory_turnover_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_turnover_before_insert
BEFORE INSERT ON inventory_turnover_result
FOR EACH ROW
BEGIN
    IF NEW.period_start IS NOT NULL AND NEW.period_end IS NOT NULL AND NEW.period_end < NEW.period_start THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.4: inventory period end cannot precede start';
    END IF;
    IF COALESCE(NEW.cogs,0) < 0 OR COALESCE(NEW.avg_inventory,0) < 0
       OR (NEW.avg_inventory = 0 AND NEW.turnover_ratio IS NOT NULL) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.4: invalid COGS, inventory or zero denominator';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_turnover_before_update
-- Group: Inventory turnover
-- Event: BEFORE UPDATE on inventory_turnover_result
-- Purpose: Check inventory_turnover_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_turnover_before_update
BEFORE UPDATE ON inventory_turnover_result
FOR EACH ROW
BEGIN
    IF NEW.period_start IS NOT NULL AND NEW.period_end IS NOT NULL AND NEW.period_end < NEW.period_start THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.4: inventory period end cannot precede start';
    END IF;
    IF COALESCE(NEW.cogs,0) < 0 OR COALESCE(NEW.avg_inventory,0) < 0
       OR (NEW.avg_inventory = 0 AND NEW.turnover_ratio IS NOT NULL) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.4: invalid COGS, inventory or zero denominator';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Product profitability
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_profitability_before_insert
-- Group: Product profitability
-- Event: BEFORE INSERT on profitability_result
-- Purpose: Check profitability_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_profitability_before_insert
BEFORE INSERT ON profitability_result
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NOT NULL AND DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.5: profitability month must begin on first day';
    END IF;
    IF COALESCE(NEW.revenue,0) < 0 OR COALESCE(NEW.cost,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.5: product revenue and cost cannot be negative';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_profitability_before_update
-- Group: Product profitability
-- Event: BEFORE UPDATE on profitability_result
-- Purpose: Check profitability_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_profitability_before_update
BEFORE UPDATE ON profitability_result
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NOT NULL AND DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.5: profitability month must begin on first day';
    END IF;
    IF COALESCE(NEW.revenue,0) < 0 OR COALESCE(NEW.cost,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.5: product revenue and cost cannot be negative';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Route sales trends
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_sales_trend_before_insert
-- Group: Route sales trends
-- Event: BEFORE INSERT on sales_trend_result
-- Purpose: Check sales_trend_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_sales_trend_before_insert
BEFORE INSERT ON sales_trend_result
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NULL OR DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales trend month must start on first day';
    END IF;
    IF NEW.origin_port_id IS NOT NULL AND NEW.dest_port_id IS NOT NULL
       AND NEW.origin_port_id = NEW.dest_port_id THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales trend route ports must differ';
    END IF;
    IF COALESCE(NEW.total_sales,0) < 0 OR COALESCE(NEW.total_qty,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales and quantity cannot be negative';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_sales_trend_before_update
-- Group: Route sales trends
-- Event: BEFORE UPDATE on sales_trend_result
-- Purpose: Check sales_trend_result input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_sales_trend_before_update
BEFORE UPDATE ON sales_trend_result
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NULL OR DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales trend month must start on first day';
    END IF;
    IF NEW.origin_port_id IS NOT NULL AND NEW.dest_port_id IS NOT NULL
       AND NEW.origin_port_id = NEW.dest_port_id THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales trend route ports must differ';
    END IF;
    IF COALESCE(NEW.total_sales,0) < 0 OR COALESCE(NEW.total_qty,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.2: sales and quantity cannot be negative';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Demand forecasting and pricing link
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_demand_forecast_before_insert
-- Group: Demand forecasting and pricing link
-- Event: BEFORE INSERT on demand_forecast
-- Purpose: Check demand_forecast input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_demand_forecast_before_insert
BEFORE INSERT ON demand_forecast
FOR EACH ROW
BEGIN
    IF NEW.origin_port_id = NEW.dest_port_id THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: forecast route must contain two different ports';
    END IF;
    IF NEW.forecast_month IS NULL OR DAYOFMONTH(NEW.forecast_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: forecast month must be first of month';
    END IF;
    IF NEW.predicted_bookings IS NOT NULL AND NEW.predicted_bookings < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: predicted bookings cannot be negative';
    END IF;
    IF NEW.confidence_pct IS NOT NULL AND (NEW.confidence_pct < 0 OR NEW.confidence_pct > 100) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: confidence percentage must be 0-100';
    END IF;
    IF NEW.suggested_multiplier IS NOT NULL AND NEW.suggested_multiplier <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: suggested multiplier must be positive';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_demand_forecast_before_update
-- Group: Demand forecasting and pricing link
-- Event: BEFORE UPDATE on demand_forecast
-- Purpose: Check demand_forecast input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_demand_forecast_before_update
BEFORE UPDATE ON demand_forecast
FOR EACH ROW
BEGIN
    IF NEW.origin_port_id = NEW.dest_port_id THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: forecast route must contain two different ports';
    END IF;
    IF NEW.forecast_month IS NULL OR DAYOFMONTH(NEW.forecast_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: forecast month must be first of month';
    END IF;
    IF NEW.predicted_bookings IS NOT NULL AND NEW.predicted_bookings < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: predicted bookings cannot be negative';
    END IF;
    IF NEW.confidence_pct IS NOT NULL AND (NEW.confidence_pct < 0 OR NEW.confidence_pct > 100) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: confidence percentage must be 0-100';
    END IF;
    IF NEW.suggested_multiplier IS NOT NULL AND NEW.suggested_multiplier <= 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR6.6: suggested multiplier must be positive';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Profit and Loss
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_profit_loss_before_insert
-- Group: Profit and Loss
-- Event: BEFORE INSERT on profit_loss
-- Purpose: Check profit_loss input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_profit_loss_before_insert
BEFORE INSERT ON profit_loss
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NULL OR DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.7: P&L period must start on first of month';
    END IF;
    IF COALESCE(NEW.revenue,0) < 0 OR COALESCE(NEW.freight_cost,0) < 0
       OR COALESCE(NEW.port_cost,0) < 0 OR COALESCE(NEW.handling_cost,0) < 0
       OR COALESCE(NEW.claim_loss,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.8: revenue, costs and claims cannot be negative';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND NOT EXISTS (
       SELECT 1 FROM shipment sh WHERE sh.shipment_id=NEW.shipment_id AND sh.seller_id=NEW.seller_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.8: P&L Seller must own shipment';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_profit_loss_before_update
-- Group: Profit and Loss
-- Event: BEFORE UPDATE on profit_loss
-- Purpose: Check profit_loss input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_profit_loss_before_update
BEFORE UPDATE ON profit_loss
FOR EACH ROW
BEGIN
    IF NEW.period_month IS NULL OR DAYOFMONTH(NEW.period_month) <> 1 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.7: P&L period must start on first of month';
    END IF;
    IF COALESCE(NEW.revenue,0) < 0 OR COALESCE(NEW.freight_cost,0) < 0
       OR COALESCE(NEW.port_cost,0) < 0 OR COALESCE(NEW.handling_cost,0) < 0
       OR COALESCE(NEW.claim_loss,0) < 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.8: revenue, costs and claims cannot be negative';
    END IF;
    IF NEW.shipment_id IS NOT NULL AND NOT EXISTS (
       SELECT 1 FROM shipment sh WHERE sh.shipment_id=NEW.shipment_id AND sh.seller_id=NEW.seller_id
    ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR2.8: P&L Seller must own shipment';
    END IF;
END$$

-- ============================================================================
-- MODULE 7 — Claims and Evidence Management — 7 trigger(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Claim processing
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_claim_before_insert
-- Group: Claim processing
-- Event: BEFORE INSERT on claims
-- Purpose: Reject invalid claims values and inconsistent relationships.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_claim_before_insert
BEFORE INSERT ON claims
FOR EACH ROW
BEGIN
    DECLARE v_shipment_status    VARCHAR(20) DEFAULT NULL;
    DECLARE v_shipment_consumer  INT DEFAULT NULL;
    DECLARE v_shipment_container INT DEFAULT NULL;
    SELECT status,
    consumer_id,
    container_id
    INTO v_shipment_status,
    v_shipment_consumer,
    v_shipment_container
    FROM shipment
    WHERE shipment_id = NEW.shipment_id;
    IF v_shipment_status IS NULL
    OR v_shipment_status NOT IN ('ARRIVED', 'DELIVERED') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR7.3: claims are allowed only for Arrived or
    Delivered shipments';
    END IF;
    IF NEW.consumer_id <> v_shipment_consumer THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR7.1: claim Consumer must own the shipment';
    END IF;
    IF NEW.container_id IS NOT NULL
    AND NEW.container_id <> v_shipment_container THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR7.1: claim container must match the shipment
    container';
    END IF;
    IF NEW.claimed_amount IS NULL OR NEW.claimed_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR7.1: claimed amount must be greater than zero';
    END IF;
    IF NEW.description IS NULL OR TRIM(NEW.description) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.1: claim description is required';
    END IF;
    IF NEW.claimed_amount IS NULL OR NEW.claimed_amount <= 0
       OR NEW.approved_amount IS NULL OR NEW.approved_amount < 0
       OR NEW.approved_amount > NEW.claimed_amount THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.4: claim amounts must be valid and approved <= claimed';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_validate_claim_before_update
-- Group: Claim processing
-- Event: BEFORE UPDATE on claims
-- Purpose: Protect claim review/settlement transitions and approved amounts.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_validate_claim_before_update
BEFORE UPDATE ON claims
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status THEN
        IF NOT ((OLD.status = 'SUBMITTED' AND NEW.status IN ('UNDER_REVIEW', 'REJECTED'))
        OR (OLD.status = 'UNDER_REVIEW'
        AND NEW.status IN ('APPROVED', 'PARTIALLY_APPROVED', 'REJECTED'))
        OR (OLD.status IN ('APPROVED', 'PARTIALLY_APPROVED')
        AND NEW.status = 'SETTLED')) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR7.5: invalid claim status change';
    END IF;
    END IF;
    IF NEW.status = 'SETTLED' AND NEW.settled_at IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR7.6: settled claims must have a settlement date';
    END IF;
    IF NEW.status = 'APPROVED' AND NEW.approved_amount <> NEW.claimed_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FR7.4: approved amount must equal the claimed
        amount';
    END IF;
    IF NEW.status = 'PARTIALLY_APPROVED'
    AND (NEW.approved_amount <= 0 OR NEW.approved_amount >= NEW.claimed_amount)
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'FR7.4: partial amount must be above 0 and below
    the claimed amount';
    END IF;
    IF NEW.description IS NULL OR TRIM(NEW.description) = '' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.1: claim description is required';
    END IF;
    IF NEW.claimed_amount IS NULL OR NEW.claimed_amount <= 0
       OR NEW.approved_amount IS NULL OR NEW.approved_amount < 0
       OR NEW.approved_amount > NEW.claimed_amount THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.4: claim amounts must be valid and approved <= claimed';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_update_profit_loss_after_claim_update
-- Group: Claim processing
-- Event: AFTER UPDATE on claims
-- Purpose: Post newly settled claim losses to the correct shipment and month.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_update_profit_loss_after_claim_update
AFTER UPDATE ON claims
FOR EACH ROW
BEGIN
    DECLARE v_month DATE;
    DECLARE v_pl    INT DEFAULT NULL;
    IF NEW.status = 'SETTLED' AND OLD.status <> 'SETTLED' THEN
        SET v_month = DATE_SUB(DATE(NEW.settled_at),
        INTERVAL DAYOFMONTH(NEW.settled_at) - 1 DAY);
        SELECT MAX(pl_id)
        INTO v_pl
        FROM profit_loss
        WHERE shipment_id = NEW.shipment_id
        AND period_month = v_month;
        IF v_pl IS NULL THEN
            INSERT INTO profit_loss (
            shipment_id,
            seller_id,
            period_month,
            claim_loss
            )
            SELECT NEW.shipment_id,
            s.seller_id,
            v_month,
            NEW.approved_amount
            FROM shipment s
            WHERE s.shipment_id = NEW.shipment_id;
        ELSE
            UPDATE profit_loss
            SET claim_loss = claim_loss + NEW.approved_amount
            WHERE pl_id = v_pl;
        END IF;
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Claim documents
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_claim_document_before_insert
-- Group: Claim documents
-- Event: BEFORE INSERT on claim_documents
-- Purpose: Check claim_documents input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_claim_document_before_insert
BEFORE INSERT ON claim_documents
FOR EACH ROW
BEGIN
    IF NEW.file_name IS NULL OR TRIM(NEW.file_name) = ''
       OR NEW.file_path IS NULL OR TRIM(NEW.file_path) = ''
       OR NEW.file_type IS NULL OR UPPER(NEW.file_type) NOT IN ('PDF','JPG','PNG') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: evidence requires name, path and PDF/JPG/PNG type';
    END IF;
    IF NEW.file_name LIKE '%..%' OR NEW.file_path LIKE '%..%' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: relative path traversal is forbidden';
    END IF;
    IF UPPER(SUBSTRING_INDEX(NEW.file_name, '.', -1)) <> UPPER(NEW.file_type) AND NOT
       (UPPER(NEW.file_type) = 'JPG' AND UPPER(SUBSTRING_INDEX(NEW.file_name, '.', -1)) = 'JPEG') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: evidence extension must match file type';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_check_claim_document_before_update
-- Group: Claim documents
-- Event: BEFORE UPDATE on claim_documents
-- Purpose: Check claim_documents input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_check_claim_document_before_update
BEFORE UPDATE ON claim_documents
FOR EACH ROW
BEGIN
    IF NEW.file_name IS NULL OR TRIM(NEW.file_name) = ''
       OR NEW.file_path IS NULL OR TRIM(NEW.file_path) = ''
       OR NEW.file_type IS NULL OR UPPER(NEW.file_type) NOT IN ('PDF','JPG','PNG') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: evidence requires name, path and PDF/JPG/PNG type';
    END IF;
    IF NEW.file_name LIKE '%..%' OR NEW.file_path LIKE '%..%' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: relative path traversal is forbidden';
    END IF;
    IF UPPER(SUBSTRING_INDEX(NEW.file_name, '.', -1)) <> UPPER(NEW.file_type) AND NOT
       (UPPER(NEW.file_type) = 'JPG' AND UPPER(SUBSTRING_INDEX(NEW.file_name, '.', -1)) = 'JPEG') THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FR7.2: evidence extension must match file type';
    END IF;
END$$

-- ----------------------------------------------------------------------------
-- Claim history and comments
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_claim_status_history_update
-- Group: Claim history and comments
-- Event: BEFORE UPDATE on claim_status_history
-- Purpose: Check claim_status_history input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_claim_status_history_update
BEFORE UPDATE ON claim_status_history
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical claim decision/comment history cannot be updated';
END$$

-- ----------------------------------------------------------------------------
-- TRIGGER: trg_prevent_claim_status_history_delete
-- Group: Claim history and comments
-- Event: BEFORE DELETE on claim_status_history
-- Purpose: Check claim_status_history input, references and allowed business values.
-- ----------------------------------------------------------------------------
CREATE TRIGGER trg_prevent_claim_status_history_delete
BEFORE DELETE ON claim_status_history
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Historical claim decision/comment history cannot be deleted';
END$$

DELIMITER ;

-- ============================================================================
-- SECTION 04 — SQL FUNCTIONS
-- ============================================================================
DELIMITER $$

-- ============================================================================
-- MODULE 1 — User and Access Management — 1 function(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Login and user accounts
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- FUNCTION: fn_password_digest
-- Group: Login and user accounts
-- Purpose: Salted iterated SHA-256 digest for SQL-only XAMPP demonstration.
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_password_digest(p_password VARCHAR(255),p_salt VARCHAR(32))
RETURNS CHAR(64)
DETERMINISTIC NO SQL
BEGIN
    DECLARE v_hash CHAR(64);
    DECLARE v_round INT DEFAULT 1;
    SET v_hash=SHA2(CONCAT(p_salt,':',p_password),256);
    WHILE v_round<10000 DO
        SET v_hash=SHA2(CONCAT(v_hash,':',p_salt),256);
        SET v_round=v_round+1;
    END WHILE;
    RETURN v_hash;
END$$

-- ============================================================================
-- MODULE 3 — Container Allocation, Booking and Pricing — 2 function(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Containers
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- FUNCTION: fn_get_shipment_items_total
-- Group: Containers
-- Purpose: Calculate goods amount for an existing shipment.
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_get_shipment_items_total(
    p_shipment_id INT
)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(14,2) DEFAULT 0;

    SELECT COALESCE(SUM(amount), 0)
    INTO v_total
    FROM shipment_items
    WHERE shipment_id = p_shipment_id;

    RETURN v_total;
END$$

-- ----------------------------------------------------------------------------
-- Pricing rules and audit
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- FUNCTION: fn_get_pricing_handling_charge
-- Group: Pricing rules and audit
-- Purpose: Derive the fixed handling component from the existing base rate.
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_get_pricing_handling_charge(p_rule_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_handling DECIMAL(12,2) DEFAULT 0.00;
    -- Under the fixed SRS schema, the editable route base rate is the
    -- handling/fixed-charge component of the approved total price formula.
    -- The weight and CBM components remain in the invoice FREIGHT line.
    SELECT COALESCE(MAX(ROUND(base_rate*season_multiplier*demand_multiplier,2)),0)
    INTO v_handling
    FROM pricing_rules
    WHERE rule_id=p_rule_id;
    RETURN v_handling;
END$$

-- ============================================================================
-- MODULE 5 — Billing, Invoices and Payments — 1 function(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Invoices
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- FUNCTION: fn_get_invoice_balance
-- Group: Invoices
-- Purpose: Calculate outstanding balance on a recorded invoice.
-- ----------------------------------------------------------------------------
CREATE FUNCTION fn_get_invoice_balance(
    p_invoice_id INT
)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_balance DECIMAL(14,2) DEFAULT NULL;

    SELECT total_amount - paid_amount
    INTO v_balance
    FROM billing_invoices
    WHERE invoice_id = p_invoice_id;

    RETURN v_balance;
END$$

DELIMITER ;

-- ============================================================================
-- SECTION 05 — REPORTING VIEWS
-- ============================================================================
-- ============================================================================
-- MODULE 2 — Shipment and Container Movement Tracking — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Movement tracking
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_shipment_tracking
-- Group: Movement tracking
-- Purpose: Join each shipment to its origin/destination and event timeline.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_shipment_tracking AS
SELECT s.shipment_id,s.shipment_no,s.consumer_id,s.seller_id,
       c.container_number,c.container_type,s.status AS shipment_status,
       op.port_name AS origin_port,dp.port_name AS destination_port,
       s.etd,s.eta,s.actual_arrival,
       CASE
           WHEN s.status = 'CANCELLED' OR s.eta IS NULL THEN 0
           WHEN s.actual_arrival IS NOT NULL THEN IF(s.actual_arrival > s.eta, 1, 0)
           WHEN s.status = 'DELIVERED' THEN 0
           ELSE IF(s.eta < CURDATE(), 1, 0)
       END AS is_delayed,
       cm.movement_id,cm.status AS movement_status,cm.event_time,
       cm.location_text,ep.port_name AS event_port,cm.remarks
FROM shipment s JOIN containers c ON c.container_id=s.container_id
JOIN ports op ON op.port_id=s.origin_port_id
JOIN ports dp ON dp.port_id=s.dest_port_id
LEFT JOIN container_movements cm ON cm.shipment_id=s.shipment_id
LEFT JOIN ports ep ON ep.port_id=cm.port_id;

-- ============================================================================
-- MODULE 3 — Container Allocation, Booking and Pricing — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Booking and allocation reports
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_booking_summary
-- Group: Booking and allocation reports
-- Purpose: Join shipment, container, invoice and goods value for one booking.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_booking_summary AS
SELECT s.shipment_id,s.shipment_no,s.consumer_id,s.seller_id,s.container_id,
       c.container_number,c.container_type,s.origin_port_id,s.dest_port_id,
       s.cargo_weight_kg,s.cargo_volume_cbm,s.quoted_price,s.status AS shipment_status,
       s.etd,s.eta,s.actual_arrival,
       i.invoice_id,i.invoice_no,i.sub_total,i.tax_amount,i.total_amount,
       i.paid_amount,i.status AS invoice_status,
       COALESCE((SELECT SUM(si.amount) FROM shipment_items si
           WHERE si.shipment_id=s.shipment_id),0) AS goods_value,
       COALESCE((SELECT SUM(si.quantity) FROM shipment_items si
           WHERE si.shipment_id=s.shipment_id),0) AS booked_units
FROM shipment s JOIN containers c ON c.container_id=s.container_id
LEFT JOIN billing_invoices i ON i.shipment_id=s.shipment_id;

-- ============================================================================
-- MODULE 4 — Products, Stock and Inventory Management — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Stock
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_stock_summary
-- Group: Stock
-- Purpose: Aggregate general and booked stock by product and Seller.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_stock_summary AS
SELECT p.product_id,p.sku,p.product_name,p.category,p.owner_company_id,
       c.company_name AS owner_company,
       COALESCE(SUM(st.quantity),0) AS total_quantity,
       COALESCE(SUM(CASE WHEN st.shipment_id IS NULL AND st.container_id IS NULL THEN st.quantity ELSE 0 END),0) AS general_quantity,
       COALESCE(SUM(CASE WHEN st.shipment_id IS NOT NULL OR st.container_id IS NOT NULL THEN st.quantity ELSE 0 END),0) AS reserved_quantity,
       COALESCE(SUM(st.damaged_qty),0) AS damaged_quantity,
       COALESCE(SUM(st.quantity-st.damaged_qty),0) AS undamaged_quantity,
       COALESCE(SUM(CASE WHEN st.shipment_id IS NULL AND st.container_id IS NULL THEN st.quantity-st.damaged_qty ELSE 0 END),0) AS available_quantity,
       COUNT(st.stock_id) AS stock_record_count
FROM products p JOIN companies c ON c.company_id=p.owner_company_id
LEFT JOIN stock st ON st.product_id=p.product_id
GROUP BY p.product_id,p.sku,p.product_name,p.category,p.owner_company_id,c.company_name;

-- ============================================================================
-- MODULE 5 — Billing, Invoices and Payments — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Invoices
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_invoice_summary
-- Group: Invoices
-- Purpose: Show invoice totals, paid balance, buyer and Seller.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_invoice_summary AS
SELECT bi.invoice_id,bi.invoice_no,bi.shipment_id,s.shipment_no,bi.consumer_id,
       cc.company_name AS consumer_company,bi.seller_id,sc.company_name AS seller_company,
       bi.sub_total,bi.tax_amount,bi.total_amount,bi.paid_amount,
       fn_get_invoice_balance(bi.invoice_id) AS outstanding_balance,
       bi.status,bi.issue_date,bi.due_date,
       (bi.due_date<CURDATE() AND bi.status<>'PAID') AS is_overdue,
       (SELECT COUNT(*) FROM payments py WHERE py.invoice_id=bi.invoice_id) AS payment_count
FROM billing_invoices bi JOIN shipment s ON s.shipment_id=bi.shipment_id
JOIN customers cu ON cu.customer_id=bi.consumer_id
JOIN companies cc ON cc.company_id=cu.company_id
JOIN companies sc ON sc.company_id=bi.seller_id;

-- ============================================================================
-- MODULE 6 — Analytics, Forecasting and Profit & Loss — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Profit and Loss
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_profit_loss_summary
-- Group: Profit and Loss
-- Purpose: Show P&L for each Seller and shipment/month.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_profit_loss_summary AS
SELECT pl.pl_id,pl.shipment_id,s.shipment_no,pl.seller_id,
       c.company_name AS seller_name,pl.period_month,pl.revenue,
       pl.freight_cost,pl.port_cost,pl.handling_cost,
       (COALESCE(pl.freight_cost,0)+COALESCE(pl.port_cost,0)+COALESCE(pl.handling_cost,0)) AS operating_cost,
       pl.claim_loss,pl.net_profit,
       CASE WHEN pl.revenue>0 THEN ROUND(pl.net_profit/pl.revenue*100,2) ELSE NULL END AS profit_margin_pct
FROM profit_loss pl JOIN companies c ON c.company_id=pl.seller_id
LEFT JOIN shipment s ON s.shipment_id=pl.shipment_id;

-- ============================================================================
-- MODULE 7 — Claims and Evidence Management — 1 view(s)
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Claim processing
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- VIEW: vw_claim_summary
-- Group: Claim processing
-- Purpose: Combine claim, shipment and evidence-document counts.
-- ----------------------------------------------------------------------------
CREATE VIEW vw_claim_summary AS
SELECT cl.claim_id,cl.claim_no,cl.shipment_id,s.shipment_no,cl.container_id,
       cl.consumer_id,s.seller_id,cc.company_name AS consumer_company,
       sc.company_name AS seller_company,cl.claim_type,cl.description,
       cl.claimed_amount,cl.approved_amount,cl.status,cl.seller_remarks,
       cl.raised_at,cl.settled_at,
       (SELECT COUNT(*) FROM claim_documents d WHERE d.claim_id=cl.claim_id) AS document_count,
       (SELECT COUNT(*) FROM claim_status_history h WHERE h.claim_id=cl.claim_id) AS history_count
FROM claims cl JOIN shipment s ON s.shipment_id=cl.shipment_id
JOIN customers cu ON cu.customer_id=cl.consumer_id
JOIN companies cc ON cc.company_id=cu.company_id
JOIN companies sc ON sc.company_id=s.seller_id;

-- ============================================================================
-- END OF SCRIPT — N LOGISTIC DATABASE
-- ============================================================================
-- =============================================================================


