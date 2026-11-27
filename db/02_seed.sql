
-- N-LOGISTIC v20.28: CORRECTED FULL 7-MODULE TEST DATA - EXACTLY 3 USER ACCOUNTS
-- =============================================================================

-- BASED ON: N-LOGISTIC v20.28 database (28 SRS tables, DB-controlled GST).
-- This is the SEED DATA companion to N_LOGISTIC_v20.28_Full_Database_18Percent_GST.sql
-- OR the v20.28 existing database patch applied to the approved, empty schema.
-- The current database function fn_get_booking_gst_rate() returns 18%.
-- This script NEVER embeds a second GST rate; totals derive from the DB function.
-- DATA ONLY: does NOT CREATE/ALTER/DROP any approved tables, triggers, views or functions.
-- Target: n_logistic_test_db; intended ONLY for a fresh empty copy of that test schema.
-- Requires v20.28 schema procedures/triggers/functions to be installed before seeding.
-- Database v20.28 calculates goods-inclusive Freight and GST atomically at booking.
-- All new invoice and payment values come from those database-generated totals.
-- Run ONCE via mysql client with --abort-source-on-error. Do not use --force.
-- Exactly THREE accounts: admin@gmail.com, seller@gmail.com, user@gmail.com.
-- Deliberate NULLs remain for legitimate workflows (not-yet-arrived shipments,
-- Admin company_id, unpaid invoices, un-settled claims, etc.). SQL cannot fill
-- UI inputs, validation/error pages, or create valid evidence files on its own.
-- Evidence files are provided separately; copy them into Tomcat private uploadDir.
SET NAMES utf8mb4;
USE n_logistic_test_db;
SET SQL_SAFE_UPDATES=0;
SET @qa_real_today = CURDATE();

-- ===============================================
-- QA PRE-FLIGHT: SCHEMA IS COMPLETE BEFORE SEED
-- ===============================================
DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_qa_schema_ready$$
CREATE PROCEDURE __nlog_qa_schema_ready()
BEGIN
 IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='n_logistic_test_db' AND table_type='BASE TABLE')<>28
  OR (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='n_logistic_test_db' AND routine_type='PROCEDURE')<134
  OR (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='n_logistic_test_db' AND routine_type='FUNCTION')<5
  OR (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='n_logistic_test_db' AND routine_name='fn_get_booking_gst_rate' AND routine_type='FUNCTION')<>1
  OR (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='n_logistic_test_db')<73
  OR (SELECT COUNT(*) FROM information_schema.views WHERE table_schema='n_logistic_test_db')<6
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='STOP: full schema routines/triggers/views not installed; check original schema import errors';
 END IF;
END$$
DELIMITER ;
CALL __nlog_qa_schema_ready();
DROP PROCEDURE __nlog_qa_schema_ready;

-- Read the GST policy from the DATABASE, rather than duplicating it in test data.
-- 18% is the default in v20.28; a future database rate change is picked up here.
SET @qa_gst_rate = fn_get_booking_gst_rate();
SELECT @qa_gst_rate AS database_gst_percent_for_qa_seed;


-- Guard: stop before any inserts if previous QA records still exist.
DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_test_seed_require_empty$$
CREATE PROCEDURE __nlog_test_seed_require_empty()
BEGIN
    IF (SELECT COUNT(*) FROM users) <> 0
       OR (SELECT COUNT(*) FROM companies) <> 0
       OR (SELECT COUNT(*) FROM shipment) <> 0
       OR (SELECT COUNT(*) FROM billing_invoices) <> 0
       OR (SELECT COUNT(*) FROM claims) <> 0
       OR (SELECT COUNT(*) FROM ports) <> 0
       OR (SELECT COUNT(*) FROM products) <> 0
       OR (SELECT COUNT(*) FROM payments) <> 0 THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
         'QA SEED STOPPED: database has old records. Restore a fresh EMPTY test schema; do not import over previous test data.';
    END IF;
END$$
DELIMITER ;
CALL __nlog_test_seed_require_empty();
DROP PROCEDURE __nlog_test_seed_require_empty;


-- =============================================================================
-- MODULE 1 - 4 COMPANIES, EXACTLY THREE AUTHENTICATED USERS, CUSTOMER & AUDIT
-- =============================================================================

INSERT INTO companies (company_name,company_type,gst_number,iec_code,address,city,country) VALUES
('NLOG Ocean Exporters Private Limited','SELLER','27ABCDE1234F1Z5','ABCDE1234F','Logistics Tower, Nhava Sheva Road','Mumbai','India'),
('NLOG Global Importers Private Limited','CONSUMER','27FGHIJ5678K1Z8','FGHIJ5678K','12 Marine Lines, Fort','Mumbai','India'),
('Bluewater Export Corporation','SELLER','33KLMNO4321P1Z3','KLMNO4321P','Industrial Estate, Harbour Road','Chennai','India'),
('Sapphire Retail Distribution','CONSUMER','07PQRST9876U1Z7','PQRST9876U','Business Park, Connaught Place','New Delhi','India');

SET @seller_co=(SELECT company_id FROM companies WHERE company_name='NLOG Ocean Exporters Private Limited');

SET @consumer_co=(SELECT company_id FROM companies WHERE company_name='NLOG Global Importers Private Limited');

-- IMPORTANT: sp_insert_user receives PLAINTEXT and stores a salted digest.
-- ADMIN email admin@gmail.com | password Admin@2026QA!
-- SELLER email seller@gmail.com | password Seller@2026QA!
-- CONSUMER email user@gmail.com | password User@2026QA!
CALL sp_insert_user('ADMIN',NULL,'NLOG QA Administrator','admin@gmail.com','Admin@2026QA!','9820011001');
CALL sp_insert_user('SELLER',@seller_co,'Rohan Shah - Export Manager','seller@gmail.com','Seller@2026QA!','9820011002');
CALL sp_insert_user('CONSUMER',@consumer_co,'Aarav Mehta - Buyer','user@gmail.com','User@2026QA!','9820011003');
SET @admin_id=(SELECT user_id FROM users WHERE email='admin@gmail.com');
SET @seller_id=(SELECT user_id FROM users WHERE email='seller@gmail.com');
SET @consumer_id=(SELECT user_id FROM users WHERE email='user@gmail.com');
CALL sp_insert_customer(@consumer_id,@consumer_co,'Aarav Mehta','Accounts Department, 12 Marine Lines, Fort, Mumbai, India',5000000.00);
SET @customer_id=(SELECT customer_id FROM customers WHERE user_id=@consumer_id);
UPDATE users SET last_login=DATE_SUB(@qa_real_today,INTERVAL 1 DAY), failed_attempts=0 WHERE user_id IN (@admin_id,@seller_id,@consumer_id);
CALL sp_record_audit_action(@admin_id,'INSERT','companies',@seller_co,NULL,JSON_OBJECT('company_name','NLOG Ocean Exporters Private Limited'),'127.0.0.1');
CALL sp_record_audit_action(@admin_id,'INSERT','companies',@consumer_co,NULL,JSON_OBJECT('company_name','NLOG Global Importers Private Limited'),'127.0.0.1');
CALL sp_record_audit_action(@admin_id,'INSERT','users',@seller_id,NULL,JSON_OBJECT('role','SELLER','email','seller@gmail.com'),'127.0.0.1');
CALL sp_record_audit_action(@admin_id,'INSERT','users',@consumer_id,NULL,JSON_OBJECT('role','CONSUMER','email','user@gmail.com'),'127.0.0.1');
CALL sp_record_audit_action(@consumer_id,'UPDATE','customers',@customer_id,JSON_OBJECT('credit_limit',0),JSON_OBJECT('credit_limit',5000000),'127.0.0.1');


-- =============================================================================
-- MODULE 1/2 - REFERENCE PORTS WITH COMPLETE COORDINATES
-- =============================================================================

INSERT INTO ports(port_code,port_name,city,country,latitude,longitude) VALUES
('INBOM','Mumbai Port','Mumbai','India',18.9472,72.8494),
('INNSA','Jawaharlal Nehru Port','Navi Mumbai','India',18.9494,72.9492),
('INMAA','Chennai Port','Chennai','India',13.0843,80.2909),
('SGSIN','Port of Singapore','Singapore','Singapore',1.2644,103.8405),
('AEJEA','Jebel Ali Port','Dubai','United Arab Emirates',24.9924,55.0545),
('NLRTM','Port of Rotterdam','Rotterdam','Netherlands',51.9475,4.1356),
('USLAX','Port of Los Angeles','Los Angeles','United States',33.7292,-118.262),
('DEHAM','Port of Hamburg','Hamburg','Germany',53.5333,9.9833);

SET @p_INBOM=(SELECT port_id FROM ports WHERE port_code='INBOM');

SET @p_INNSA=(SELECT port_id FROM ports WHERE port_code='INNSA');

SET @p_INMAA=(SELECT port_id FROM ports WHERE port_code='INMAA');

SET @p_SGSIN=(SELECT port_id FROM ports WHERE port_code='SGSIN');

SET @p_AEJEA=(SELECT port_id FROM ports WHERE port_code='AEJEA');

SET @p_NLRTM=(SELECT port_id FROM ports WHERE port_code='NLRTM');

SET @p_USLAX=(SELECT port_id FROM ports WHERE port_code='USLAX');

SET @p_DEHAM=(SELECT port_id FROM ports WHERE port_code='DEHAM');


-- =============================================================================
-- MODULE 1/2 - VESSELS (VALID SEVEN-DIGIT IMO CHECK DIGITS)
-- =============================================================================

INSERT INTO vessels(vessel_name,imo_number,owner_company_id,capacity_teu,status) VALUES
('NLOG Ocean Pioneer','8712049',@seller_co,2400,'ACTIVE'),
('NLOG Amber Voyager','8712051',@seller_co,3100,'ACTIVE'),
('NLOG Meridian Star','8712063',@seller_co,1800,'ACTIVE'),
('NLOG Cargo Horizon','8712075',@seller_co,4250,'ACTIVE'),
('NLOG Sea Breeze','8712087',@seller_co,2000,'MAINTENANCE'),
('NLOG Eastern Trade','8712099',@seller_co,3500,'ACTIVE');

SET @v1=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Ocean Pioneer');

SET @v2=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Amber Voyager');

SET @v3=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Meridian Star');

SET @v4=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Cargo Horizon');

SET @v5=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Sea Breeze');

SET @v6=(SELECT vessel_id FROM vessels WHERE vessel_name='NLOG Eastern Trade');


-- =============================================================================
-- MODULE 4 - TWELVE SELLER PRODUCTS (WITH SKU, HS, PRICE AND WEIGHT)
-- =============================================================================

INSERT INTO products (sku,product_name,category,hs_code,unit,unit_weight_kg,unit_price,owner_company_id) VALUES
('NLG-PMP-001','Industrial Water Pumps','Industrial Machinery','841370','PCS',14.000,14500.00,@seller_co),
('NLG-TEX-002','Premium Cotton Fabric Rolls','Textiles','520829','ROLL',4.500,2350.00,@seller_co),
('NLG-AUT-003','Vehicle Engine Parts Kit','Automotive','840999','KIT',9.000,6500.00,@seller_co),
('NLG-SOL-004','Solar Photovoltaic Panel','Renewables','854143','PCS',12.000,9200.00,@seller_co),
('NLG-SWT-005','Electrical Switchgear','Electronics','853710','PCS',3.000,4200.00,@seller_co),
('NLG-RIC-006','Premium Basmati Rice Bag','Agriculture','100630','BAG',15.000,1100.00,@seller_co),
('NLG-PHA-007','Refrigerated Pharmaceutical Pack','Healthcare','300490','BOX',1.200,3800.00,@seller_co),
('NLG-FOD-008','Sealed Snack Cartons','Food','190590','BOX',0.500,400.00,@seller_co),
('NLG-BAT-009','Industrial Battery Modules','Electronics','850760','PCS',2.200,2800.00,@seller_co),
('NLG-CER-010','Ceramic Tile Cartons','Construction','690721','BOX',3.800,950.00,@seller_co),
('NLG-PAL-011','Reinforced Wooden Pallet','Packaging','441520','PCS',18.000,1250.00,@seller_co),
('NLG-FIL-012','Precision Spare Filters','Industrial','842199','PCS',0.750,650.00,@seller_co);

SET @prod01=(SELECT product_id FROM products WHERE sku='NLG-PMP-001');

SET @prod02=(SELECT product_id FROM products WHERE sku='NLG-TEX-002');

SET @prod03=(SELECT product_id FROM products WHERE sku='NLG-AUT-003');

SET @prod04=(SELECT product_id FROM products WHERE sku='NLG-SOL-004');

SET @prod05=(SELECT product_id FROM products WHERE sku='NLG-SWT-005');

SET @prod06=(SELECT product_id FROM products WHERE sku='NLG-RIC-006');

SET @prod07=(SELECT product_id FROM products WHERE sku='NLG-PHA-007');

SET @prod08=(SELECT product_id FROM products WHERE sku='NLG-FOD-008');

SET @prod09=(SELECT product_id FROM products WHERE sku='NLG-BAT-009');

SET @prod10=(SELECT product_id FROM products WHERE sku='NLG-CER-010');

SET @prod11=(SELECT product_id FROM products WHERE sku='NLG-PAL-011');

SET @prod12=(SELECT product_id FROM products WHERE sku='NLG-FIL-012');


-- =============================================================================
-- MODULE 4 - GENERAL STOCK, DAMAGED STOCK, IMMUTABLE LEDGER
-- =============================================================================

-- Product 01: in stock

CALL sp_insert_stock(@prod01,500);

-- Product 02: in stock

CALL sp_insert_stock(@prod02,630);

-- Product 03: in stock

CALL sp_insert_stock(@prod03,390);

-- Product 04: in stock

CALL sp_insert_stock(@prod04,350);

-- Product 05: in stock

CALL sp_insert_stock(@prod05,580);

-- Product 06: in stock

CALL sp_insert_stock(@prod06,760);

-- Product 07: in stock

CALL sp_insert_stock(@prod07,340);

-- Product 08: in stock

CALL sp_insert_stock(@prod08,880);

-- Product 09: in stock

CALL sp_insert_stock(@prod09,480);

-- Product 10: in stock

CALL sp_insert_stock(@prod10,620);

-- Product 11: low stock

CALL sp_insert_stock(@prod11,9);

-- Product 12: out of stock

INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty) VALUES(@prod12,NULL,NULL,0,0);

SET @qa_edit_stock=(SELECT MIN(stock_id) FROM stock WHERE product_id=@prod02 AND shipment_id IS NULL);
CALL sp_update_stock_field(@seller_id,@qa_edit_stock,'damaged_qty','8');

SET @qa_edit_stock=(SELECT MIN(stock_id) FROM stock WHERE product_id=@prod04 AND shipment_id IS NULL);
CALL sp_update_stock_field(@seller_id,@qa_edit_stock,'damaged_qty','3');

SET @qa_edit_stock=(SELECT MIN(stock_id) FROM stock WHERE product_id=@prod06 AND shipment_id IS NULL);
CALL sp_update_stock_field(@seller_id,@qa_edit_stock,'damaged_qty','12');

SET @qa_edit_stock=(SELECT MIN(stock_id) FROM stock WHERE product_id=@prod09 AND shipment_id IS NULL);
CALL sp_update_stock_field(@seller_id,@qa_edit_stock,'damaged_qty','6');

SET @qa_edit_stock=(SELECT MIN(stock_id) FROM stock WHERE product_id=@prod11 AND shipment_id IS NULL);
CALL sp_update_stock_field(@seller_id,@qa_edit_stock,'damaged_qty','1');


-- =============================================================================
-- MODULE 3 - 41 CONTAINERS: DRY, REEFER, OPEN_TOP, TANK AND DIFFERENT LOCATIONS
-- =============================================================================

INSERT INTO containers(container_number,seller_id,container_type,size_ft,max_weight_kg,max_volume_cbm,current_port_id,status) VALUES
('QABOM00001',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00002',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00003',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00004',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00005',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00006',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00007',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00008',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00009',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00010',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00011',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00012',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00013',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00014',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOM00015',@seller_co,'DRY',20,24000.00,33.00,@p_INBOM,'AVAILABLE'),
('QABOMF40',@seller_co,'REEFER',40,29000.00,62.00,@p_INBOM,'AVAILABLE'),
('QABOMO40',@seller_co,'OPEN_TOP',40,30000.00,67.00,@p_INBOM,'AVAILABLE'),
('QANSA00001',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00002',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00003',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00004',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00005',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00006',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00007',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00008',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00009',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSA00010',@seller_co,'DRY',20,24000.00,33.00,@p_INNSA,'AVAILABLE'),
('QANSAF40',@seller_co,'REEFER',40,29000.00,62.00,@p_INNSA,'AVAILABLE'),
('QANSAO40',@seller_co,'OPEN_TOP',40,30000.00,67.00,@p_INNSA,'AVAILABLE'),
('QAMAA00001',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAA00002',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAA00003',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAA00004',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAA00005',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAA00006',@seller_co,'DRY',20,24000.00,33.00,@p_INMAA,'AVAILABLE'),
('QAMAAF40',@seller_co,'REEFER',40,29000.00,62.00,@p_INMAA,'AVAILABLE'),
('QAMAAO40',@seller_co,'OPEN_TOP',40,30000.00,67.00,@p_INMAA,'AVAILABLE'),
('QABOM40DRY',@seller_co,'DRY',40,30000.00,67.00,@p_INBOM,'AVAILABLE'),
('QANSA40DRY',@seller_co,'DRY',40,30000.00,67.00,@p_INNSA,'AVAILABLE'),
('QAMAA40DRY',@seller_co,'DRY',40,30000.00,67.00,@p_INMAA,'AVAILABLE'),
('QABOMTANK40',@seller_co,'TANK',40,29000.00,60.00,@p_INBOM,'AVAILABLE');


-- =============================================================================
-- MODULE 3 - VALID PRICING RULES, AUTOMATIC PRICE AUDIT
-- =============================================================================

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INBOM,@p_SGSIN,'DRY',11500.00,4.0000,105.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INBOM,@p_SGSIN,'REEFER',16900.00,6.0000,135.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INBOM,@p_SGSIN,'OPEN_TOP',20500.00,6.0000,145.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INBOM,@p_USLAX,'DRY',24500.00,8.0000,170.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INNSA,@p_NLRTM,'DRY',18000.00,7.0000,140.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INNSA,@p_NLRTM,'REEFER',25500.00,8.0000,160.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INNSA,@p_NLRTM,'OPEN_TOP',29000.00,7.0000,165.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INMAA,@p_AEJEA,'DRY',9800.00,3.0000,85.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INMAA,@p_AEJEA,'REEFER',15500.00,4.0000,100.00,1.00,1.00,'2024-01-01','2035-12-31');

CALL sp_insert_pricing_rule(@seller_id,@seller_co,@p_INBOM,@p_AEJEA,'TANK',20000.00,6.0000,190.00,1.00,1.00,'2024-01-01','2035-12-31');

SET @rule_bomsin=(SELECT rule_id FROM pricing_rules WHERE origin_port_id=@p_INBOM AND dest_port_id=@p_SGSIN AND container_type='DRY' AND seller_id=@seller_co);

CALL sp_update_pricing_rule_field(@seller_id,@rule_bomsin,'base_rate','11900.00');

CALL sp_update_pricing_rule_field(@seller_id,@rule_bomsin,'demand_multiplier','1.05');


-- =============================================================================
-- MODULE 3 - CONFIRMED BOOKINGS; LINKED SHIPMENT / ITEMS / SALES / INVOICES
-- =============================================================================

-- Booking SP automatically handles quantity limits, container allocation, stock
-- reservations, ledger events, sales transactions, and an invoice per shipment.
-- SET TIMESTAMP backdates the QA session clock for this booking only so the
-- automatically-created BOOKED movement and invoice issue date are realistic.
-- SET TIMESTAMP=0 restores the real clock immediately afterward. Requires
-- standard MySQL/MariaDB session timestamp support; never change server time.


-- BOOKING 01: INBOM to SGSIN, DELIVERED, PAID, product 1

SET @bd01=DATE_SUB(@qa_real_today,INTERVAL 125 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd01,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd01,JSON_ARRAY(JSON_OBJECT('product_id',@prod01,'quantity',8,'unit_cbm',0.180)),DATE_ADD(@bd01,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship01=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v2,eta=DATE_SUB(@qa_real_today,INTERVAL 112 DAY) WHERE shipment_id=@ship01;

CALL sp_insert_container_movement(@ship01,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd01,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship01,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd01,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship01,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd01,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship01,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 112 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship01,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 112 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship01,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 112 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 02: INNSA to NLRTM, DELIVERED, PAID, product 2

SET @bd02=DATE_SUB(@qa_real_today,INTERVAL 110 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd02,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd02,JSON_ARRAY(JSON_OBJECT('product_id',@prod02,'quantity',12,'unit_cbm',0.190)),DATE_ADD(@bd02,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship02=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v3,eta=DATE_SUB(@qa_real_today,INTERVAL 96 DAY) WHERE shipment_id=@ship02;

CALL sp_insert_container_movement(@ship02,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd02,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship02,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd02,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship02,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd02,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship02,'ARRIVED',@p_NLRTM,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 96 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship02,'CUSTOMS_CLEARED',@p_NLRTM,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 96 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship02,'DELIVERED',@p_NLRTM,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 96 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 03: INBOM to SGSIN, DELIVERED, PAID, product 3

SET @bd03=DATE_SUB(@qa_real_today,INTERVAL 95 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd03,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd03,JSON_ARRAY(JSON_OBJECT('product_id',@prod03,'quantity',7,'unit_cbm',0.160)),DATE_ADD(@bd03,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship03=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v4,eta=DATE_SUB(@qa_real_today,INTERVAL 81 DAY) WHERE shipment_id=@ship03;

CALL sp_insert_container_movement(@ship03,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd03,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship03,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd03,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship03,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd03,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship03,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 81 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship03,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 81 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship03,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 81 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 04: INNSA to NLRTM, DELIVERED, PAID, product 4

SET @bd04=DATE_SUB(@qa_real_today,INTERVAL 80 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd04,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd04,JSON_ARRAY(JSON_OBJECT('product_id',@prod04,'quantity',6,'unit_cbm',0.250)),DATE_ADD(@bd04,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship04=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v1,eta=DATE_SUB(@qa_real_today,INTERVAL 66 DAY) WHERE shipment_id=@ship04;

CALL sp_insert_container_movement(@ship04,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd04,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship04,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd04,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship04,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd04,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship04,'ARRIVED',@p_NLRTM,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 66 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship04,'CUSTOMS_CLEARED',@p_NLRTM,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 66 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship04,'DELIVERED',@p_NLRTM,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 66 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 05: INBOM to SGSIN, DELIVERED, PAID, product 5

SET @bd05=DATE_SUB(@qa_real_today,INTERVAL 70 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd05,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd05,JSON_ARRAY(JSON_OBJECT('product_id',@prod05,'quantity',10,'unit_cbm',0.120)),DATE_ADD(@bd05,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship05=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v2,eta=DATE_SUB(@qa_real_today,INTERVAL 55 DAY) WHERE shipment_id=@ship05;

CALL sp_insert_container_movement(@ship05,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd05,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship05,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd05,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship05,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd05,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship05,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 55 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship05,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 55 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship05,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 55 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 06: INNSA to NLRTM, DELIVERED, PAID, product 6

SET @bd06=DATE_SUB(@qa_real_today,INTERVAL 55 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd06,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd06,JSON_ARRAY(JSON_OBJECT('product_id',@prod06,'quantity',9,'unit_cbm',0.260)),DATE_ADD(@bd06,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship06=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v3,eta=DATE_SUB(@qa_real_today,INTERVAL 41 DAY) WHERE shipment_id=@ship06;

CALL sp_insert_container_movement(@ship06,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd06,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship06,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd06,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship06,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd06,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship06,'ARRIVED',@p_NLRTM,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 41 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship06,'CUSTOMS_CLEARED',@p_NLRTM,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 41 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship06,'DELIVERED',@p_NLRTM,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 41 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 07: INBOM to SGSIN, DELIVERED, PAID, product 7

SET @bd07=DATE_SUB(@qa_real_today,INTERVAL 48 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd07,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd07,JSON_ARRAY(JSON_OBJECT('product_id',@prod07,'quantity',11,'unit_cbm',0.090)),DATE_ADD(@bd07,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship07=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v4,eta=DATE_SUB(@qa_real_today,INTERVAL 33 DAY) WHERE shipment_id=@ship07;

CALL sp_insert_container_movement(@ship07,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd07,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship07,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd07,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship07,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd07,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship07,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 33 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship07,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 33 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship07,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 33 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 08: INBOM to SGSIN, DELIVERED, PAID, product 8

SET @bd08=DATE_SUB(@qa_real_today,INTERVAL 40 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd08,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd08,JSON_ARRAY(JSON_OBJECT('product_id',@prod08,'quantity',18,'unit_cbm',0.060)),DATE_ADD(@bd08,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship08=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v1,eta=DATE_SUB(@qa_real_today,INTERVAL 26 DAY) WHERE shipment_id=@ship08;

CALL sp_insert_container_movement(@ship08,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd08,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship08,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd08,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship08,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd08,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship08,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 26 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship08,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 26 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship08,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 26 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 09: INNSA to NLRTM, ARRIVED, PARTIAL, product 9

SET @bd09=DATE_SUB(@qa_real_today,INTERVAL 32 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd09,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd09,JSON_ARRAY(JSON_OBJECT('product_id',@prod09,'quantity',8,'unit_cbm',0.130)),DATE_ADD(@bd09,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship09=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v2,eta=DATE_SUB(@qa_real_today,INTERVAL 17 DAY) WHERE shipment_id=@ship09;

CALL sp_insert_container_movement(@ship09,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd09,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship09,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd09,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship09,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd09,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship09,'ARRIVED',@p_NLRTM,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 17 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);


-- BOOKING 10: INBOM to SGSIN, DELIVERED, PAID, product 10

SET @bd10=DATE_SUB(@qa_real_today,INTERVAL 29 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd10,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd10,JSON_ARRAY(JSON_OBJECT('product_id',@prod10,'quantity',20,'unit_cbm',0.140)),DATE_ADD(@bd10,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship10=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v3,eta=DATE_SUB(@qa_real_today,INTERVAL 14 DAY) WHERE shipment_id=@ship10;

CALL sp_insert_container_movement(@ship10,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd10,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship10,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd10,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship10,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd10,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship10,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 14 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship10,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 14 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship10,'DELIVERED',@p_SGSIN,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 14 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 11: INBOM to SGSIN, ARRIVED, PARTIAL, product 1

SET @bd11=DATE_SUB(@qa_real_today,INTERVAL 26 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd11,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd11,JSON_ARRAY(JSON_OBJECT('product_id',@prod01,'quantity',5,'unit_cbm',0.180)),DATE_ADD(@bd11,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship11=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v4,eta=DATE_SUB(@qa_real_today,INTERVAL 12 DAY) WHERE shipment_id=@ship11;

CALL sp_insert_container_movement(@ship11,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd11,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship11,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd11,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship11,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd11,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship11,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 12 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);


-- BOOKING 12: INNSA to NLRTM, DELIVERED, PAID, product 2

SET @bd12=DATE_SUB(@qa_real_today,INTERVAL 24 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd12,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd12,JSON_ARRAY(JSON_OBJECT('product_id',@prod02,'quantity',16,'unit_cbm',0.190)),DATE_ADD(@bd12,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship12=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v1,eta=DATE_SUB(@qa_real_today,INTERVAL 9 DAY) WHERE shipment_id=@ship12;

CALL sp_insert_container_movement(@ship12,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd12,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship12,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd12,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship12,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd12,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship12,'ARRIVED',@p_NLRTM,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 9 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship12,'CUSTOMS_CLEARED',@p_NLRTM,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 9 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship12,'DELIVERED',@p_NLRTM,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 9 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 13: INBOM to SGSIN, ARRIVED, PAID, product 3

SET @bd13=DATE_SUB(@qa_real_today,INTERVAL 22 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd13,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd13,JSON_ARRAY(JSON_OBJECT('product_id',@prod03,'quantity',12,'unit_cbm',0.160)),DATE_ADD(@bd13,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship13=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v2,eta=DATE_SUB(@qa_real_today,INTERVAL 7 DAY) WHERE shipment_id=@ship13;

CALL sp_insert_container_movement(@ship13,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd13,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship13,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd13,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship13,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd13,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship13,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 7 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);


-- BOOKING 14: INMAA to AEJEA, DELIVERED, UNPAID, product 4

SET @bd14=DATE_SUB(@qa_real_today,INTERVAL 20 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd14,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INMAA,@p_AEJEA,@bd14,JSON_ARRAY(JSON_OBJECT('product_id',@prod04,'quantity',10,'unit_cbm',0.250)),DATE_ADD(@bd14,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship14=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v3,eta=DATE_SUB(@qa_real_today,INTERVAL 5 DAY) WHERE shipment_id=@ship14;

CALL sp_insert_container_movement(@ship14,'LOADED',@p_INMAA,'Loaded at origin terminal',DATE_ADD(@bd14,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship14,'DEPARTED',@p_INMAA,'Vessel departed origin port',DATE_ADD(@bd14,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship14,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd14,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship14,'ARRIVED',@p_AEJEA,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 5 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship14,'CUSTOMS_CLEARED',@p_AEJEA,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 5 DAY),'16:00:00'),'Customs processing complete',@seller_id);

CALL sp_insert_container_movement(@ship14,'DELIVERED',@p_AEJEA,'Delivered to final consignee',TIMESTAMP(DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL 5 DAY),INTERVAL 1 DAY),'11:00:00'),'Proof of delivery recorded',@seller_id);


-- BOOKING 15: INBOM to SGSIN, CUSTOMS_CLEARED, UNPAID, product 5

SET @bd15=DATE_SUB(@qa_real_today,INTERVAL 17 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd15,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd15,JSON_ARRAY(JSON_OBJECT('product_id',@prod05,'quantity',13,'unit_cbm',0.120)),DATE_ADD(@bd15,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship15=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v4,eta=DATE_SUB(@qa_real_today,INTERVAL 3 DAY) WHERE shipment_id=@ship15;

CALL sp_insert_container_movement(@ship15,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd15,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship15,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd15,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship15,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd15,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);

CALL sp_insert_container_movement(@ship15,'ARRIVED',@p_SGSIN,'Arrived at destination port',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 3 DAY),'08:00:00'),'Container received at destination terminal',@seller_id);

CALL sp_insert_container_movement(@ship15,'CUSTOMS_CLEARED',@p_SGSIN,'Destination customs clearance',TIMESTAMP(DATE_SUB(@qa_real_today,INTERVAL 3 DAY),'16:00:00'),'Customs processing complete',@seller_id);


-- BOOKING 16: INNSA to NLRTM, IN_TRANSIT, UNPAID, product 6

SET @bd16=DATE_SUB(@qa_real_today,INTERVAL 14 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd16,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd16,JSON_ARRAY(JSON_OBJECT('product_id',@prod06,'quantity',17,'unit_cbm',0.260)),DATE_ADD(@bd16,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship16=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v1,eta=DATE_ADD(@bd16,INTERVAL 19 DAY) WHERE shipment_id=@ship16;

CALL sp_insert_container_movement(@ship16,'LOADED',@p_INNSA,'Loaded at origin terminal',DATE_ADD(@bd16,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship16,'DEPARTED',@p_INNSA,'Vessel departed origin port',DATE_ADD(@bd16,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);

CALL sp_insert_container_movement(@ship16,'IN_TRANSIT',NULL,'At sea - international transit',DATE_ADD(@bd16,INTERVAL 5 DAY),'Ocean route in progress; manual tracking update',@seller_id);


-- BOOKING 17: INBOM to SGSIN, DEPARTED, UNPAID, product 7

SET @bd17=DATE_SUB(@qa_real_today,INTERVAL 11 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd17,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd17,JSON_ARRAY(JSON_OBJECT('product_id',@prod07,'quantity',24,'unit_cbm',0.090)),DATE_ADD(@bd17,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship17=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v2,eta=DATE_ADD(@bd17,INTERVAL 19 DAY) WHERE shipment_id=@ship17;

CALL sp_insert_container_movement(@ship17,'LOADED',@p_INBOM,'Loaded at origin terminal',DATE_ADD(@bd17,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);

CALL sp_insert_container_movement(@ship17,'DEPARTED',@p_INBOM,'Vessel departed origin port',DATE_ADD(@bd17,INTERVAL 3 DAY),'Ocean departure recorded',@seller_id);


-- BOOKING 18: INMAA to AEJEA, LOADED, UNPAID, product 8

SET @bd18=DATE_SUB(@qa_real_today,INTERVAL 9 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd18,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INMAA,@p_AEJEA,@bd18,JSON_ARRAY(JSON_OBJECT('product_id',@prod08,'quantity',25,'unit_cbm',0.060)),DATE_ADD(@bd18,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship18=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v3,eta=DATE_ADD(@bd18,INTERVAL 19 DAY) WHERE shipment_id=@ship18;

CALL sp_insert_container_movement(@ship18,'LOADED',@p_INMAA,'Loaded at origin terminal',DATE_ADD(@bd18,INTERVAL 1 DAY),'Cargo loaded and verified by Seller',@seller_id);


-- BOOKING 19: INBOM to SGSIN, BOOKED, UNPAID, product 9

SET @bd19=DATE_SUB(@qa_real_today,INTERVAL 6 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd19,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INBOM,@p_SGSIN,@bd19,JSON_ARRAY(JSON_OBJECT('product_id',@prod09,'quantity',28,'unit_cbm',0.130)),DATE_ADD(@bd19,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship19=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v4,eta=DATE_ADD(@bd19,INTERVAL 19 DAY) WHERE shipment_id=@ship19;


-- BOOKING 20: INNSA to NLRTM, CANCELLED, UNPAID, product 10

-- Capture pre-booking general stock for an immediate cancellation reversal check.
SET @qa_cancel20_general_before=(SELECT COALESCE(SUM(quantity),0) FROM stock
    WHERE product_id=@prod10 AND shipment_id IS NULL AND container_id IS NULL);
SET @bd20=DATE_SUB(@qa_real_today,INTERVAL 3 DAY);

SET TIMESTAMP = UNIX_TIMESTAMP(CONCAT(@bd20,' 09:00:00'));

CALL sp_confirm_booking(@consumer_id,@p_INNSA,@p_NLRTM,@bd20,JSON_ARRAY(JSON_OBJECT('product_id',@prod10,'quantity',32,'unit_cbm',0.140)),DATE_ADD(@bd20,INTERVAL 30 DAY));

SET TIMESTAMP=0;

SET @ship20=(SELECT MAX(shipment_id) FROM shipment);

UPDATE shipment SET vessel_id=@v1,eta=DATE_ADD(@bd20,INTERVAL 19 DAY) WHERE shipment_id=@ship20;

-- Use the approved cancellation procedure, not an isolated movement insert:
-- it records CANCELLED, releases the allocated container, returns reserved goods
-- to general stock and preserves invoice/history (no payment is recorded).
CALL sp_delete_shipment(@consumer_id,@ship20,'Consumer cancelled before departure; return stock and keep audit trail');

-- Check the return to stock and AVAILABLE state IMMEDIATELY after cancellation,
-- before another perfectly valid booking may reuse this released container.
DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_qa_check_cancel_release$$
CREATE PROCEDURE __nlog_qa_check_cancel_release()
BEGIN
  IF (SELECT status FROM shipment WHERE shipment_id=@ship20)<>'CANCELLED'
     OR EXISTS(SELECT 1 FROM stock WHERE shipment_id=@ship20 AND quantity<>0)
     OR (SELECT status FROM containers WHERE container_id=(SELECT container_id FROM shipment WHERE shipment_id=@ship20))<>'AVAILABLE'
     OR (SELECT COALESCE(SUM(quantity),0) FROM stock WHERE product_id=@prod10
           AND shipment_id IS NULL AND container_id IS NULL)<>@qa_cancel20_general_before
     OR EXISTS(SELECT 1 FROM payments p JOIN billing_invoices i ON i.invoice_id=p.invoice_id
           WHERE i.shipment_id=@ship20)
  THEN SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT='QA CANCELLATION: immediate release/stock restoration failed';
  END IF;
END$$
DELIMITER ;
CALL __nlog_qa_check_cancel_release();
DROP PROCEDURE __nlog_qa_check_cancel_release;



-- =============================================================================
-- QA ASSERT: all 20 procedure-booked shipments and their DB-driven invoices
-- must exist. Their goods, freight, GST and full payable amounts are generated
-- by v20.28 sp_process_booking (not manually patched afterward).
DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_test_seed_check_bookings$$
CREATE PROCEDURE __nlog_test_seed_check_bookings()
BEGIN
 IF (SELECT COUNT(*) FROM shipment)<>20 OR (SELECT COUNT(*) FROM billing_invoices)<>20
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='QA IMPORT FAILED: 20 bookings / 20 invoices not created. Stop here and report first SQL error';
 END IF;
END$$
DELIMITER ;
CALL __nlog_test_seed_check_bookings();
DROP PROCEDURE __nlog_test_seed_check_bookings;

-- MODULE 2/5 - TWO EXTRA QA SHIPMENTS: ONE MANUALLY BILLED, ONE INVOICE-ELIGIBLE
-- =============================================================================

-- These two validated QA shipments begin without invoices. The first
-- gets an invoice with goods-inclusive FREIGHT, HANDLING, CUSTOMS, INSURANCE
-- and GST from the current database function. The shipment's quoted_price
-- must match exactly (required by v20.28 sp_insert_invoice).
-- The second remains invoice-eligible, so Seller Create Invoice can be tested
-- with a complete quote rather than an obsolete shipping-only figure.

-- Invoice 1: 3 switchgear items + 7,500 shipping + 1,200 handling,
-- 350 customs and 200 insurance. GST applies to (goods+shipping+handling),
-- NOT customs/insurance under the current DB's demonstration tax policy.
SET @manual1_goods=(SELECT ROUND(3*unit_price,2) FROM products WHERE product_id=@prod05);
SET @manual1_shipping=7500.00;
SET @manual1_freight=ROUND(@manual1_goods+@manual1_shipping,2);
SET @manual1_handling=1200.00;
SET @manual1_customs=350.00;
SET @manual1_insurance=200.00;
SET @manual1_subtotal=ROUND(@manual1_freight+@manual1_handling+@manual1_customs+@manual1_insurance,2);
SET @manual1_tax=ROUND((@manual1_freight+@manual1_handling)*fn_get_booking_gst_rate()/100,2);
SET @manual1_total=ROUND(@manual1_subtotal+@manual1_tax,2);

SET @manual_container1=(SELECT MIN(container_id) FROM containers WHERE seller_id=@seller_co AND current_port_id=@p_INBOM AND status='AVAILABLE' AND container_type='DRY');

INSERT INTO shipment (shipment_no,consumer_id,seller_id,container_id,vessel_id,origin_port_id,dest_port_id,cargo_description,cargo_weight_kg,cargo_volume_cbm,quoted_price,status,etd,eta) SELECT 'NLG-QA-UNBILLED-01',@customer_id,@seller_co,@manual_container1,@v1,@p_INBOM,@p_SGSIN,CONCAT(product_name,' x3'),ROUND(3*unit_weight_kg,2),ROUND(3*0.120,2),@manual1_total,'BOOKED',DATE_SUB(@qa_real_today,INTERVAL 1 DAY),DATE_ADD(@qa_real_today,INTERVAL 15 DAY) FROM products WHERE product_id=@prod05;

SET @extra_ship1=(SELECT shipment_id FROM shipment WHERE shipment_no='NLG-QA-UNBILLED-01');

SET @qa_event_container=(SELECT container_id FROM shipment WHERE shipment_id=@extra_ship1);
INSERT INTO container_movements(shipment_id,container_id,status,port_id,location_text,event_time,remarks,updated_by) VALUES(@extra_ship1,@qa_event_container,'BOOKED',@p_INBOM,'Booking confirmed at origin',DATE_SUB(NOW(),INTERVAL 1 DAY),'QA test shipment reserved for manual invoice workflow',@consumer_id);

UPDATE containers SET status='ALLOCATED' WHERE container_id=@manual_container1;

SET @ledger_ref_type='SHIPMENT'; SET @ledger_ref_id=@extra_ship1;

UPDATE stock SET quantity=quantity-3 WHERE product_id=@prod05 AND shipment_id IS NULL AND container_id IS NULL;

INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty) VALUES(@prod05,@extra_ship1,@manual_container1,3,0);

SET @ledger_ref_type=NULL; SET @ledger_ref_id=NULL;

INSERT INTO shipment_items(shipment_id,product_id,quantity,unit_price,weight_kg,volume_cbm,amount) SELECT @extra_ship1,product_id,3,unit_price,ROUND(3*unit_weight_kg,2),ROUND(3*0.120,2),ROUND(3*unit_price,2) FROM products WHERE product_id=@prod05;

INSERT INTO sales_transactions(product_id,customer_id,shipment_id,quantity,unit_price,total_amount,sale_date) SELECT product_id,@customer_id,@extra_ship1,3,unit_price,ROUND(3*unit_price,2),DATE_SUB(@qa_real_today,INTERVAL 1 DAY) FROM products WHERE product_id=@prod05;

-- Invoice 2 is intentionally not created. Its confirmed quote is nevertheless
-- 2 engine-parts kits + 7,850 shipping, with 0 extra handling/customs/insurance.
-- The Seller can enter @manual2_freight and zeros for other charges later.
SET @manual2_goods=(SELECT ROUND(2*unit_price,2) FROM products WHERE product_id=@prod03);
SET @manual2_shipping=7850.00;
SET @manual2_freight=ROUND(@manual2_goods+@manual2_shipping,2);
SET @manual2_total=ROUND(@manual2_freight + ROUND(@manual2_freight*fn_get_booking_gst_rate()/100,2),2);

-- Keep the cancelled booking's container idle for the final QA snapshot.
-- Reusing it would be valid, but would make an unconditional AVAILABLE assertion false.
SET @manual_container2=(SELECT MIN(container_id) FROM containers
    WHERE seller_id=@seller_co AND current_port_id=@p_INNSA
      AND status='AVAILABLE' AND container_type='DRY'
      AND container_id<>(SELECT container_id FROM shipment WHERE shipment_id=@ship20));

INSERT INTO shipment (shipment_no,consumer_id,seller_id,container_id,vessel_id,origin_port_id,dest_port_id,cargo_description,cargo_weight_kg,cargo_volume_cbm,quoted_price,status,etd,eta) SELECT 'NLG-QA-UNBILLED-02',@customer_id,@seller_co,@manual_container2,@v1,@p_INNSA,@p_NLRTM,CONCAT(product_name,' x2'),ROUND(2*unit_weight_kg,2),ROUND(2*0.160,2),@manual2_total,'BOOKED',DATE_SUB(@qa_real_today,INTERVAL 2 DAY),DATE_ADD(@qa_real_today,INTERVAL 15 DAY) FROM products WHERE product_id=@prod03;

SET @extra_ship2=(SELECT shipment_id FROM shipment WHERE shipment_no='NLG-QA-UNBILLED-02');

SET @qa_event_container=(SELECT container_id FROM shipment WHERE shipment_id=@extra_ship2);
INSERT INTO container_movements(shipment_id,container_id,status,port_id,location_text,event_time,remarks,updated_by) VALUES(@extra_ship2,@qa_event_container,'BOOKED',@p_INNSA,'Booking confirmed at origin',DATE_SUB(NOW(),INTERVAL 2 DAY),'QA test shipment reserved for manual invoice workflow',@consumer_id);

UPDATE containers SET status='ALLOCATED' WHERE container_id=@manual_container2;

SET @ledger_ref_type='SHIPMENT'; SET @ledger_ref_id=@extra_ship2;

UPDATE stock SET quantity=quantity-2 WHERE product_id=@prod03 AND shipment_id IS NULL AND container_id IS NULL;

INSERT INTO stock(product_id,shipment_id,container_id,quantity,damaged_qty) VALUES(@prod03,@extra_ship2,@manual_container2,2,0);

SET @ledger_ref_type=NULL; SET @ledger_ref_id=NULL;

INSERT INTO shipment_items(shipment_id,product_id,quantity,unit_price,weight_kg,volume_cbm,amount) SELECT @extra_ship2,product_id,2,unit_price,ROUND(2*unit_weight_kg,2),ROUND(2*0.160,2),ROUND(2*unit_price,2) FROM products WHERE product_id=@prod03;

INSERT INTO sales_transactions(product_id,customer_id,shipment_id,quantity,unit_price,total_amount,sale_date) SELECT product_id,@customer_id,@extra_ship2,2,unit_price,ROUND(2*unit_price,2),DATE_SUB(@qa_real_today,INTERVAL 2 DAY) FROM products WHERE product_id=@prod03;

CALL sp_insert_invoice(@seller_id,@extra_ship1,DATE_ADD(@qa_real_today,INTERVAL 21 DAY),@manual1_freight,@manual1_handling,@manual1_customs,@manual1_insurance,'127.0.0.1');


-- =============================================================================
-- MODULE 5 - REAL RECORDED PAYMENTS; UNPAID, PARTIAL AND PAID INVOICES
-- =============================================================================

-- Only the owning Consumer records payments; payment triggers synchronize
-- invoice paid_amount/status. Payment dates are >= invoice issue dates and
-- <= the real current date. Never set invoice paid_amount directly.

SET @inv01=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship01);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv01);
CALL sp_record_payment(@inv01,ROUND(@qa_payment_amount_base*0.42,2),'BANK','QA-BANK-2026-001-A',DATE_SUB(@qa_real_today,INTERVAL 113 DAY),@consumer_id);

SET @qa_payment_amount_base=(SELECT total_amount-paid_amount FROM billing_invoices WHERE invoice_id=@inv01);
CALL sp_record_payment(@inv01,@qa_payment_amount_base,'UPI','QA-UPI-2026-001-B',DATE_SUB(@qa_real_today,INTERVAL 111 DAY),@consumer_id);

SET @inv02=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship02);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv02);
CALL sp_record_payment(@inv02,@qa_payment_amount_base,'CHEQUE','QA-REF-2026-002',DATE_SUB(@qa_real_today,INTERVAL 98 DAY),@consumer_id);

SET @inv03=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship03);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv03);
CALL sp_record_payment(@inv03,@qa_payment_amount_base,'BANK','QA-REF-2026-003',DATE_SUB(@qa_real_today,INTERVAL 83 DAY),@consumer_id);

SET @inv04=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship04);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv04);
CALL sp_record_payment(@inv04,ROUND(@qa_payment_amount_base*0.42,2),'BANK','QA-BANK-2026-004-A',DATE_SUB(@qa_real_today,INTERVAL 68 DAY),@consumer_id);

SET @qa_payment_amount_base=(SELECT total_amount-paid_amount FROM billing_invoices WHERE invoice_id=@inv04);
CALL sp_record_payment(@inv04,@qa_payment_amount_base,'UPI','QA-UPI-2026-004-B',DATE_SUB(@qa_real_today,INTERVAL 66 DAY),@consumer_id);

SET @inv05=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship05);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv05);
CALL sp_record_payment(@inv05,@qa_payment_amount_base,'CHEQUE','QA-REF-2026-005',DATE_SUB(@qa_real_today,INTERVAL 58 DAY),@consumer_id);

SET @inv06=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship06);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv06);
CALL sp_record_payment(@inv06,@qa_payment_amount_base,'BANK','QA-REF-2026-006',DATE_SUB(@qa_real_today,INTERVAL 43 DAY),@consumer_id);

SET @inv07=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship07);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv07);
CALL sp_record_payment(@inv07,@qa_payment_amount_base,'UPI','QA-REF-2026-007',DATE_SUB(@qa_real_today,INTERVAL 36 DAY),@consumer_id);

SET @inv08=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship08);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv08);
CALL sp_record_payment(@inv08,ROUND(@qa_payment_amount_base*0.42,2),'BANK','QA-BANK-2026-008-A',DATE_SUB(@qa_real_today,INTERVAL 28 DAY),@consumer_id);

SET @qa_payment_amount_base=(SELECT total_amount-paid_amount FROM billing_invoices WHERE invoice_id=@inv08);
CALL sp_record_payment(@inv08,@qa_payment_amount_base,'UPI','QA-UPI-2026-008-B',DATE_SUB(@qa_real_today,INTERVAL 26 DAY),@consumer_id);

SET @inv09=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship09);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv09);
CALL sp_record_payment(@inv09,ROUND(@qa_payment_amount_base*0.35,2),'BANK','QA-REF-2026-009',DATE_SUB(@qa_real_today,INTERVAL 20 DAY),@consumer_id);

SET @inv10=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship10);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv10);
CALL sp_record_payment(@inv10,@qa_payment_amount_base,'UPI','QA-REF-2026-010',DATE_SUB(@qa_real_today,INTERVAL 17 DAY),@consumer_id);

SET @inv11=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship11);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv11);
CALL sp_record_payment(@inv11,ROUND(@qa_payment_amount_base*0.35,2),'CHEQUE','QA-REF-2026-011',DATE_SUB(@qa_real_today,INTERVAL 14 DAY),@consumer_id);

SET @inv12=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship12);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv12);
CALL sp_record_payment(@inv12,ROUND(@qa_payment_amount_base*0.42,2),'BANK','QA-BANK-2026-012-A',DATE_SUB(@qa_real_today,INTERVAL 12 DAY),@consumer_id);

SET @qa_payment_amount_base=(SELECT total_amount-paid_amount FROM billing_invoices WHERE invoice_id=@inv12);
CALL sp_record_payment(@inv12,@qa_payment_amount_base,'UPI','QA-UPI-2026-012-B',DATE_SUB(@qa_real_today,INTERVAL 10 DAY),@consumer_id);

SET @inv13=(SELECT invoice_id FROM billing_invoices WHERE shipment_id=@ship13);

SET @qa_payment_amount_base=(SELECT total_amount FROM billing_invoices WHERE invoice_id=@inv13);
CALL sp_record_payment(@inv13,@qa_payment_amount_base,'UPI','QA-REF-2026-013',DATE_SUB(@qa_real_today,INTERVAL 10 DAY),@consumer_id);


-- =============================================================================
-- MODULE 7 - SEVEN CLAIMS WITH ALL REVIEW/SETTLEMENT STATES
-- =============================================================================


-- CLAIM 1: shipment 8, final target SUBMITTED

CALL sp_submit_claim(@consumer_id,@ship08,'DAMAGE','Cartons dented during unloading; exterior packaging damaged.',7800.00,30);

SET @claim1=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim1,@consumer_id,'QA-Evidence-Claim-01.png','2518ce76c6f85c5f7acd3b9fa293217f.png','PNG');


-- CLAIM 2: shipment 9, final target UNDER_REVIEW

CALL sp_submit_claim(@consumer_id,@ship09,'DELAY','Cargo arrived beyond the estimated delivery commitment.',4200.00,30);

SET @claim2=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim2,@consumer_id,'QA-Evidence-Claim-02.png','157616bfe18476cfdac3a0920c38e5c8.png','PNG');

CALL sp_review_claim(@claim2,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');


-- CLAIM 3: shipment 10, final target APPROVED

CALL sp_submit_claim(@consumer_id,@ship10,'LOSS','One pallet of ceramic tile cartons was missing at receiving.',6200.00,30);

SET @claim3=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim3,@consumer_id,'QA-Evidence-Claim-03.png','ed2bd7109529c610b9ee51f86f7c1c34.png','PNG');

CALL sp_review_claim(@claim3,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');

CALL sp_review_claim(@claim3,@seller_id,'APPROVED',NULL,'Claim amount verified and approved');

CALL sp_add_claim_comment(@claim3,@consumer_id,'QA follow-up: shipment documents and photos have been reviewed.');


-- CLAIM 4: shipment 11, final target PARTIALLY_APPROVED

CALL sp_submit_claim(@consumer_id,@ship11,'SHORTAGE','Short-shipped quantity observed during destination count.',2900.00,30);

SET @claim4=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim4,@consumer_id,'QA-Evidence-Claim-04.png','88ce35e7b0ce2ebc9091799cce2eca30.png','PNG');

CALL sp_review_claim(@claim4,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');

CALL sp_review_claim(@claim4,@seller_id,'PARTIALLY_APPROVED',1550.00,'Only the documented shortfall is accepted');


-- CLAIM 5: shipment 12, final target REJECTED

CALL sp_submit_claim(@consumer_id,@ship12,'DAMAGE','Several cotton rolls showed water staining on arrival.',5100.00,30);

SET @claim5=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim5,@consumer_id,'QA-Evidence-Claim-05.png','068eb679f16e45b8d981bb14af2b3c79.png','PNG');

CALL sp_review_claim(@claim5,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');

CALL sp_review_claim(@claim5,@seller_id,'REJECTED',0.00,'Evidence does not meet the damage threshold');


-- CLAIM 6: shipment 13, final target SETTLED

CALL sp_submit_claim(@consumer_id,@ship13,'DAMAGE','One vehicle parts kit arrived with bent metal packaging.',3600.00,30);

SET @claim6=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim6,@consumer_id,'QA-Evidence-Claim-06.png','30c0516f069948c07d7879b43828e344.png','PNG');

CALL sp_review_claim(@claim6,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');

CALL sp_review_claim(@claim6,@seller_id,'APPROVED',NULL,'Evidence verified; settlement authorized');

SET @claim_stock=(SELECT MIN(stock_id) FROM stock WHERE shipment_id=@ship13 AND quantity-damaged_qty>=1);

CALL sp_settle_claim(@claim6,@seller_id,@claim_stock,1,'Approved damage settlement completed; affected stock marked damaged');

CALL sp_add_claim_comment(@claim6,@consumer_id,'QA follow-up: shipment documents and photos have been reviewed.');


-- CLAIM 7: shipment 14, final target UNDER_REVIEW

CALL sp_submit_claim(@consumer_id,@ship14,'SHORTAGE','Pallet count differed from original shipping documents.',4700.00,30);

SET @claim7=(SELECT MAX(claim_id) FROM claims);

CALL sp_add_claim_document(@claim7,@consumer_id,'QA-Evidence-Claim-07.png','b72d69d3cc597fec0a4535eb2701c915.png','PNG');

CALL sp_review_claim(@claim7,@seller_id,'UNDER_REVIEW',0.00,'Evidence received; investigation opened');


-- =============================================================================
-- MODULE 2/6 - SHIPMENT P&L; SALES / ABC / TURNOVER / PROFITABILITY
-- =============================================================================

-- Revenue is recognized only for fully PAID invoices in their FINAL payment
-- month. P&L cost entries are shipment-wise and month-wise; claim settlement
-- postings are reconciled by sp_refresh_profit_loss (not added twice).
-- These are the actual installed calculation routines, NOT made-up chart rows.

CALL sp_refresh_profit_loss(@ship01,DATE_SUB(@bd01,INTERVAL DAYOFMONTH(@bd01)-1 DAY),631.00,250.00,180.00);

SET @finalpaymonth01=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv01);

CALL sp_refresh_profit_loss(@ship01,@finalpaymonth01,IF(@finalpaymonth01=DATE_SUB(@bd01,INTERVAL DAYOFMONTH(@bd01)-1 DAY),631.00,0.00),IF(@finalpaymonth01=DATE_SUB(@bd01,INTERVAL DAYOFMONTH(@bd01)-1 DAY),250.00,0.00),IF(@finalpaymonth01=DATE_SUB(@bd01,INTERVAL DAYOFMONTH(@bd01)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship02,DATE_SUB(@bd02,INTERVAL DAYOFMONTH(@bd02)-1 DAY),662.00,250.00,180.00);

SET @finalpaymonth02=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv02);

CALL sp_refresh_profit_loss(@ship02,@finalpaymonth02,IF(@finalpaymonth02=DATE_SUB(@bd02,INTERVAL DAYOFMONTH(@bd02)-1 DAY),662.00,0.00),IF(@finalpaymonth02=DATE_SUB(@bd02,INTERVAL DAYOFMONTH(@bd02)-1 DAY),250.00,0.00),IF(@finalpaymonth02=DATE_SUB(@bd02,INTERVAL DAYOFMONTH(@bd02)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship03,DATE_SUB(@bd03,INTERVAL DAYOFMONTH(@bd03)-1 DAY),693.00,250.00,180.00);

SET @finalpaymonth03=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv03);

CALL sp_refresh_profit_loss(@ship03,@finalpaymonth03,IF(@finalpaymonth03=DATE_SUB(@bd03,INTERVAL DAYOFMONTH(@bd03)-1 DAY),693.00,0.00),IF(@finalpaymonth03=DATE_SUB(@bd03,INTERVAL DAYOFMONTH(@bd03)-1 DAY),250.00,0.00),IF(@finalpaymonth03=DATE_SUB(@bd03,INTERVAL DAYOFMONTH(@bd03)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship04,DATE_SUB(@bd04,INTERVAL DAYOFMONTH(@bd04)-1 DAY),724.00,250.00,180.00);

SET @finalpaymonth04=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv04);

CALL sp_refresh_profit_loss(@ship04,@finalpaymonth04,IF(@finalpaymonth04=DATE_SUB(@bd04,INTERVAL DAYOFMONTH(@bd04)-1 DAY),724.00,0.00),IF(@finalpaymonth04=DATE_SUB(@bd04,INTERVAL DAYOFMONTH(@bd04)-1 DAY),250.00,0.00),IF(@finalpaymonth04=DATE_SUB(@bd04,INTERVAL DAYOFMONTH(@bd04)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship05,DATE_SUB(@bd05,INTERVAL DAYOFMONTH(@bd05)-1 DAY),755.00,250.00,180.00);

SET @finalpaymonth05=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv05);

CALL sp_refresh_profit_loss(@ship05,@finalpaymonth05,IF(@finalpaymonth05=DATE_SUB(@bd05,INTERVAL DAYOFMONTH(@bd05)-1 DAY),755.00,0.00),IF(@finalpaymonth05=DATE_SUB(@bd05,INTERVAL DAYOFMONTH(@bd05)-1 DAY),250.00,0.00),IF(@finalpaymonth05=DATE_SUB(@bd05,INTERVAL DAYOFMONTH(@bd05)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship06,DATE_SUB(@bd06,INTERVAL DAYOFMONTH(@bd06)-1 DAY),786.00,250.00,180.00);

SET @finalpaymonth06=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv06);

CALL sp_refresh_profit_loss(@ship06,@finalpaymonth06,IF(@finalpaymonth06=DATE_SUB(@bd06,INTERVAL DAYOFMONTH(@bd06)-1 DAY),786.00,0.00),IF(@finalpaymonth06=DATE_SUB(@bd06,INTERVAL DAYOFMONTH(@bd06)-1 DAY),250.00,0.00),IF(@finalpaymonth06=DATE_SUB(@bd06,INTERVAL DAYOFMONTH(@bd06)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship07,DATE_SUB(@bd07,INTERVAL DAYOFMONTH(@bd07)-1 DAY),817.00,250.00,180.00);

SET @finalpaymonth07=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv07);

CALL sp_refresh_profit_loss(@ship07,@finalpaymonth07,IF(@finalpaymonth07=DATE_SUB(@bd07,INTERVAL DAYOFMONTH(@bd07)-1 DAY),817.00,0.00),IF(@finalpaymonth07=DATE_SUB(@bd07,INTERVAL DAYOFMONTH(@bd07)-1 DAY),250.00,0.00),IF(@finalpaymonth07=DATE_SUB(@bd07,INTERVAL DAYOFMONTH(@bd07)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship08,DATE_SUB(@bd08,INTERVAL DAYOFMONTH(@bd08)-1 DAY),848.00,250.00,180.00);

SET @finalpaymonth08=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv08);

CALL sp_refresh_profit_loss(@ship08,@finalpaymonth08,IF(@finalpaymonth08=DATE_SUB(@bd08,INTERVAL DAYOFMONTH(@bd08)-1 DAY),848.00,0.00),IF(@finalpaymonth08=DATE_SUB(@bd08,INTERVAL DAYOFMONTH(@bd08)-1 DAY),250.00,0.00),IF(@finalpaymonth08=DATE_SUB(@bd08,INTERVAL DAYOFMONTH(@bd08)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship09,DATE_SUB(@bd09,INTERVAL DAYOFMONTH(@bd09)-1 DAY),879.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship10,DATE_SUB(@bd10,INTERVAL DAYOFMONTH(@bd10)-1 DAY),910.00,250.00,180.00);

SET @finalpaymonth10=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv10);

CALL sp_refresh_profit_loss(@ship10,@finalpaymonth10,IF(@finalpaymonth10=DATE_SUB(@bd10,INTERVAL DAYOFMONTH(@bd10)-1 DAY),910.00,0.00),IF(@finalpaymonth10=DATE_SUB(@bd10,INTERVAL DAYOFMONTH(@bd10)-1 DAY),250.00,0.00),IF(@finalpaymonth10=DATE_SUB(@bd10,INTERVAL DAYOFMONTH(@bd10)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship11,DATE_SUB(@bd11,INTERVAL DAYOFMONTH(@bd11)-1 DAY),941.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship12,DATE_SUB(@bd12,INTERVAL DAYOFMONTH(@bd12)-1 DAY),972.00,250.00,180.00);

SET @finalpaymonth12=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv12);

CALL sp_refresh_profit_loss(@ship12,@finalpaymonth12,IF(@finalpaymonth12=DATE_SUB(@bd12,INTERVAL DAYOFMONTH(@bd12)-1 DAY),972.00,0.00),IF(@finalpaymonth12=DATE_SUB(@bd12,INTERVAL DAYOFMONTH(@bd12)-1 DAY),250.00,0.00),IF(@finalpaymonth12=DATE_SUB(@bd12,INTERVAL DAYOFMONTH(@bd12)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship13,DATE_SUB(@bd13,INTERVAL DAYOFMONTH(@bd13)-1 DAY),1003.00,250.00,180.00);

SET @finalpaymonth13=(SELECT DATE_SUB(MAX(payment_date),INTERVAL DAYOFMONTH(MAX(payment_date))-1 DAY) FROM payments WHERE invoice_id=@inv13);

CALL sp_refresh_profit_loss(@ship13,@finalpaymonth13,IF(@finalpaymonth13=DATE_SUB(@bd13,INTERVAL DAYOFMONTH(@bd13)-1 DAY),1003.00,0.00),IF(@finalpaymonth13=DATE_SUB(@bd13,INTERVAL DAYOFMONTH(@bd13)-1 DAY),250.00,0.00),IF(@finalpaymonth13=DATE_SUB(@bd13,INTERVAL DAYOFMONTH(@bd13)-1 DAY),180.00,0.00));

CALL sp_refresh_profit_loss(@ship14,DATE_SUB(@bd14,INTERVAL DAYOFMONTH(@bd14)-1 DAY),1034.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship15,DATE_SUB(@bd15,INTERVAL DAYOFMONTH(@bd15)-1 DAY),1065.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship16,DATE_SUB(@bd16,INTERVAL DAYOFMONTH(@bd16)-1 DAY),1096.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship17,DATE_SUB(@bd17,INTERVAL DAYOFMONTH(@bd17)-1 DAY),1127.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship18,DATE_SUB(@bd18,INTERVAL DAYOFMONTH(@bd18)-1 DAY),1158.00,250.00,180.00);

CALL sp_refresh_profit_loss(@ship19,DATE_SUB(@bd19,INTERVAL DAYOFMONTH(@bd19)-1 DAY),1189.00,250.00,180.00);

CALL sp_refresh_profit_loss(@extra_ship1,DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),750.00,170.00,90.00);

CALL sp_refresh_profit_loss(@extra_ship2,DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),750.00,170.00,90.00);

CALL sp_refresh_all_analytics(DATE_SUB(@qa_real_today,INTERVAL 180 DAY),@qa_real_today,YEAR(@qa_real_today));


-- =============================================================================
-- MODULE 6 - DEMAND FORECAST RECORDS
-- =============================================================================

CALL sp_insert_demand_forecast(@p_INBOM,@p_SGSIN,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 1 MONTH),27,89.50,1.12);

CALL sp_insert_demand_forecast(@p_INNSA,@p_NLRTM,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 1 MONTH),19,87.75,1.08);

CALL sp_insert_demand_forecast(@p_INMAA,@p_AEJEA,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 1 MONTH),14,86.10,1.05);

CALL sp_insert_demand_forecast(@p_INBOM,@p_SGSIN,'REEFER',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 1 MONTH),9,81.30,1.02);

CALL sp_insert_demand_forecast(@p_INBOM,@p_SGSIN,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 2 MONTH),31,88.40,1.16);

CALL sp_insert_demand_forecast(@p_INNSA,@p_NLRTM,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 2 MONTH),22,85.50,1.10);

CALL sp_insert_demand_forecast(@p_INMAA,@p_AEJEA,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 2 MONTH),17,84.00,1.07);

CALL sp_insert_demand_forecast(@p_INBOM,@p_USLAX,'DRY',DATE_ADD(DATE_SUB(@qa_real_today,INTERVAL DAYOFMONTH(@qa_real_today)-1 DAY),INTERVAL 2 MONTH),12,79.20,1.04);


-- =============================================================================
-- AUDIT TRAIL - ADD TRACKABLE ACTIONS FOR ADMIN SCREEN
-- =============================================================================

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship01,NULL,JSON_OBJECT('shipment_id',@ship01,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship04,NULL,JSON_OBJECT('shipment_id',@ship04,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship08,NULL,JSON_OBJECT('shipment_id',@ship08,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship12,NULL,JSON_OBJECT('shipment_id',@ship12,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship16,NULL,JSON_OBJECT('shipment_id',@ship16,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','shipment',@ship20,NULL,JSON_OBJECT('shipment_id',@ship20,'event','booking confirmed'),'127.0.0.1');

CALL sp_record_audit_action(@seller_id,'UPDATE','shipment',@ship01,JSON_OBJECT('status','BOOKED'),JSON_OBJECT('event','movement history recorded'),'127.0.0.1');

CALL sp_record_audit_action(@seller_id,'UPDATE','shipment',@ship08,JSON_OBJECT('status','BOOKED'),JSON_OBJECT('event','movement history recorded'),'127.0.0.1');

CALL sp_record_audit_action(@seller_id,'UPDATE','shipment',@ship12,JSON_OBJECT('status','BOOKED'),JSON_OBJECT('event','movement history recorded'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim1,NULL,JSON_OBJECT('claim_id',@claim1,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim2,NULL,JSON_OBJECT('claim_id',@claim2,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim3,NULL,JSON_OBJECT('claim_id',@claim3,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim4,NULL,JSON_OBJECT('claim_id',@claim4,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim5,NULL,JSON_OBJECT('claim_id',@claim5,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim6,NULL,JSON_OBJECT('claim_id',@claim6,'action','claim submitted'),'127.0.0.1');

CALL sp_record_audit_action(@consumer_id,'INSERT','claims',@claim7,NULL,JSON_OBJECT('claim_id',@claim7,'action','claim submitted'),'127.0.0.1');


-- =============================================================================
-- FINAL VERIFICATION: ALL 28 TABLES, EXACTLY 3 USERS, LINK CONSISTENCY
-- =============================================================================

SELECT 'companies' AS table_name, COUNT(*) AS records FROM companies
UNION ALL SELECT 'users',COUNT(*) FROM users
UNION ALL SELECT 'customers',COUNT(*) FROM customers
UNION ALL SELECT 'audit_log',COUNT(*) FROM audit_log
UNION ALL SELECT 'ports',COUNT(*) FROM ports
UNION ALL SELECT 'vessels',COUNT(*) FROM vessels
UNION ALL SELECT 'containers',COUNT(*) FROM containers
UNION ALL SELECT 'shipment',COUNT(*) FROM shipment
UNION ALL SELECT 'container_movements',COUNT(*) FROM container_movements
UNION ALL SELECT 'products',COUNT(*) FROM products
UNION ALL SELECT 'shipment_items',COUNT(*) FROM shipment_items
UNION ALL SELECT 'stock',COUNT(*) FROM stock
UNION ALL SELECT 'inventory_ledger',COUNT(*) FROM inventory_ledger
UNION ALL SELECT 'sales_transactions',COUNT(*) FROM sales_transactions
UNION ALL SELECT 'pricing_rules',COUNT(*) FROM pricing_rules
UNION ALL SELECT 'pricing_audit',COUNT(*) FROM pricing_audit
UNION ALL SELECT 'demand_forecast',COUNT(*) FROM demand_forecast
UNION ALL SELECT 'billing_invoices',COUNT(*) FROM billing_invoices
UNION ALL SELECT 'invoice_line_items',COUNT(*) FROM invoice_line_items
UNION ALL SELECT 'payments',COUNT(*) FROM payments
UNION ALL SELECT 'claims',COUNT(*) FROM claims
UNION ALL SELECT 'claim_documents',COUNT(*) FROM claim_documents
UNION ALL SELECT 'claim_status_history',COUNT(*) FROM claim_status_history
UNION ALL SELECT 'profit_loss',COUNT(*) FROM profit_loss
UNION ALL SELECT 'abc_classification_result',COUNT(*) FROM abc_classification_result
UNION ALL SELECT 'inventory_turnover_result',COUNT(*) FROM inventory_turnover_result
UNION ALL SELECT 'profitability_result',COUNT(*) FROM profitability_result
UNION ALL SELECT 'sales_trend_result',COUNT(*) FROM sales_trend_result;

SELECT user_id,role,full_name,email,company_id,status,last_login FROM users ORDER BY user_id;

SELECT status,COUNT(*) AS shipments FROM shipment GROUP BY status ORDER BY status;

SELECT status,COUNT(*) AS invoices,SUM(total_amount) AS invoice_total,SUM(paid_amount) AS paid_total FROM billing_invoices GROUP BY status ORDER BY status;

SELECT status,COUNT(*) AS claims FROM claims GROUP BY status ORDER BY status;

SELECT COUNT(*) AS user_accounts_should_be_3 FROM users;

SELECT COUNT(*) AS shipments_should_be_22 FROM shipment;

SELECT COUNT(*) AS invoices_should_be_21 FROM billing_invoices;

SELECT COUNT(*) AS claims_should_be_7 FROM claims;

SELECT COUNT(*) AS real_evidence_files_expected_7 FROM claim_documents;

-- Check for missing expected foreign-key relationships (all should be ZERO):
SELECT COUNT(*) AS orphan_invoices FROM billing_invoices bi LEFT JOIN shipment s ON s.shipment_id=bi.shipment_id WHERE s.shipment_id IS NULL;
SELECT COUNT(*) AS orphan_claims FROM claims c LEFT JOIN shipment s ON s.shipment_id=c.shipment_id WHERE s.shipment_id IS NULL;
SELECT COUNT(*) AS invalid_stock FROM stock WHERE quantity<0 OR damaged_qty>quantity;
SELECT COUNT(*) AS invalid_paid_invoices FROM billing_invoices WHERE paid_amount>total_amount OR (status='PAID' AND paid_amount<>total_amount);

-- ====================================================
-- v20.28 FINANCIAL CONSISTENCY CHECKS (READ-ONLY)
-- ====================================================
-- 1. Quoted price = invoice total for all 21 invoiced shipments.
-- 2. Invoice subtotal + GST = invoice total.
-- 3. FREIGHT is not less than the booked goods value (goods + shipping);
--    HANDLING and TAX remain separate lines. This catches missing goods value,
--    but cannot alone prove goods aren't double-counted.
-- 4. The stored GST line/header uses the CURRENT DATABASE GST function.
-- 5. Payment totals/status reconcile with the invoice total.
-- 6. Cancelled shipment 20 has no reserved stock/payment; any later reuse is valid.
-- All checks operate on the seed data only and add no database columns/tables.
SELECT fn_get_booking_gst_rate() AS effective_gst_percent,
       COUNT(*) AS invoice_count,
       SUM(i.total_amount) AS seeded_invoice_total,
       SUM(i.paid_amount) AS seeded_paid_total
FROM billing_invoices i;

DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_qa_verify_v2028_billing$$
CREATE PROCEDURE __nlog_qa_verify_v2028_billing()
BEGIN
  IF fn_get_booking_gst_rate() IS NULL
     OR fn_get_booking_gst_rate()<0 OR fn_get_booking_gst_rate()>100 THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='QA GST: invalid GST rate in database function';
  END IF;

  IF EXISTS(
    SELECT 1 FROM billing_invoices i
    JOIN shipment s ON s.shipment_id=i.shipment_id
    WHERE i.total_amount<>s.quoted_price
       OR i.total_amount<>ROUND(i.sub_total+i.tax_amount,2)
  ) THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA BILLING: invoice total differs from quote or subtotal plus GST';
  END IF;

  IF EXISTS(
    SELECT 1 FROM billing_invoices i
    JOIN (
      SELECT invoice_id,
             ROUND(SUM(CASE WHEN item_type<>'TAX' THEN amount ELSE 0 END),2) AS line_subtotal,
             ROUND(SUM(CASE WHEN item_type='TAX' THEN amount ELSE 0 END),2) AS line_tax,
             ROUND(SUM(amount),2) AS line_total,
             ROUND(SUM(CASE WHEN item_type IN ('FREIGHT','HANDLING') THEN amount ELSE 0 END),2) AS gst_base,
             SUM(item_type='FREIGHT') AS freight_lines
      FROM invoice_line_items GROUP BY invoice_id
    ) l ON l.invoice_id=i.invoice_id
    WHERE l.line_subtotal<>i.sub_total
       OR l.line_tax<>i.tax_amount
       OR l.line_total<>i.total_amount
       OR l.freight_lines<>1
       OR i.tax_amount<>ROUND(l.gst_base*fn_get_booking_gst_rate()/100,2)
  ) THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA BILLING: invoice line items/GST do not reconcile';
  END IF;

  IF EXISTS(
    SELECT 1 FROM billing_invoices i
    JOIN (
      SELECT invoice_id, SUM(amount) AS invoiced_freight
      FROM invoice_line_items WHERE item_type='FREIGHT'
      GROUP BY invoice_id
    ) f ON f.invoice_id=i.invoice_id
    JOIN (
      SELECT shipment_id, ROUND(SUM(amount),2) AS goods_amount
      FROM shipment_items GROUP BY shipment_id
    ) g ON g.shipment_id=i.shipment_id
    WHERE f.invoiced_freight < g.goods_amount
  ) THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA BILLING: freight does not include purchased goods';
  END IF;

  IF EXISTS(
    SELECT 1 FROM billing_invoices i
    LEFT JOIN (
      SELECT invoice_id, ROUND(SUM(amount),2) AS pay_total
      FROM payments GROUP BY invoice_id
    ) p ON p.invoice_id=i.invoice_id
    WHERE i.paid_amount<>COALESCE(p.pay_total,0)
       OR i.status<>CASE
           WHEN i.total_amount>0 AND i.paid_amount=i.total_amount THEN 'PAID'
           WHEN i.paid_amount>0 THEN 'PARTIAL'
           ELSE 'UNPAID' END
  ) THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA PAYMENTS: paid/status is not consistent with payments';
  END IF;

  -- An immediately released container may be legitimately reallocated later.
  -- Check cancellation history/stock/payment and current lifecycle consistency.
  IF @ship20 IS NULL
    OR EXISTS (SELECT 1 FROM stock WHERE shipment_id=@ship20 AND quantity<>0)
    OR EXISTS(SELECT 1 FROM payments p JOIN billing_invoices i ON i.invoice_id=p.invoice_id
              WHERE i.shipment_id=@ship20)
    OR (SELECT status FROM shipment WHERE shipment_id=@ship20)<>'CANCELLED'
    OR NOT EXISTS(SELECT 1 FROM container_movements WHERE shipment_id=@ship20 AND status='CANCELLED')
    OR EXISTS(
       SELECT 1 FROM shipment sc JOIN containers c ON c.container_id=sc.container_id
       WHERE sc.shipment_id=@ship20 AND (
          (c.status='AVAILABLE' AND EXISTS(
             SELECT 1 FROM shipment active
             WHERE active.container_id=sc.container_id AND active.shipment_id<>sc.shipment_id
               AND active.status NOT IN ('DELIVERED','CANCELLED')))
          OR (c.status<>'AVAILABLE' AND NOT EXISTS(
             SELECT 1 FROM shipment active
             WHERE active.container_id=sc.container_id AND active.shipment_id<>sc.shipment_id
               AND active.status NOT IN ('DELIVERED','CANCELLED')))
          OR (SELECT COUNT(*) FROM shipment active
              WHERE active.container_id=sc.container_id AND active.shipment_id<>sc.shipment_id
                AND active.status NOT IN ('DELIVERED','CANCELLED'))>1
       ))
  THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA CANCELLATION: stock/payment/history or container lifecycle mismatch';
  END IF;

  IF (SELECT COUNT(*) FROM billing_invoices WHERE shipment_id=@extra_ship1)<>1
     OR (SELECT COUNT(*) FROM billing_invoices WHERE shipment_id=@extra_ship2)<>0
  THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT='QA MANUAL INVOICES: one invoiced and one invoice-eligible shipment required';
  END IF;
END$$
DELIMITER ;
CALL __nlog_qa_verify_v2028_billing();
DROP PROCEDURE __nlog_qa_verify_v2028_billing;

-- ====================================================
-- QA COMPLETION ASSERTIONS: FAIL, DON'T SILENTLY PASS
-- ====================================================
DELIMITER $$
DROP PROCEDURE IF EXISTS __nlog_qa_require_full$$
CREATE PROCEDURE __nlog_qa_require_full()
BEGIN
 IF (SELECT COUNT(*) FROM users)<>3
  OR (SELECT COUNT(*) FROM companies)<>4
  OR (SELECT COUNT(*) FROM shipment)<>22
  OR (SELECT COUNT(*) FROM billing_invoices)<>21
  OR (SELECT COUNT(*) FROM payments)<14
  OR (SELECT COUNT(*) FROM claims)<>7
  OR (SELECT COUNT(*) FROM claim_documents)<>7
  OR (SELECT COUNT(*) FROM container_movements)<40
  OR (SELECT COUNT(*) FROM inventory_ledger)<12
  OR (SELECT COUNT(*) FROM sales_transactions)<20
  OR (SELECT COUNT(*) FROM pricing_audit)<10
  OR (SELECT COUNT(*) FROM sales_trend_result)=0
  OR (SELECT COUNT(*) FROM abc_classification_result)=0
  OR (SELECT COUNT(*) FROM inventory_turnover_result)=0
  OR (SELECT COUNT(*) FROM profitability_result)=0
  OR (SELECT COUNT(*) FROM profit_loss)=0
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='QA import INCOMPLETE: inspect table counts above and FIRST SQL error. Do not claim full seed';
 END IF;
END$$
DELIMITER ;
CALL __nlog_qa_require_full();
DROP PROCEDURE __nlog_qa_require_full;

SELECT 'N-LOGISTIC v20.28 | 3-ACCOUNT GST DB-DRIVEN SEED COMPLETED - verify counts above' AS completion_message;
SET TIMESTAMP=0;
SET SQL_SAFE_UPDATES=1;