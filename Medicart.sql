
-- =====================================================
-- MEDICART ONLINE PHARMACY SYSTEM
-- SPRINT 1 : DATABASE IMPLEMENTATION
-- MYSQL 8.4
-- =====================================================

-- 1. CREATE DATABASE

drop database if exists medicartdb;

create database medicartdb;

use medicartdb;


-- =====================================================
-- 2. CREATE TABLES
-- =====================================================

-- TABLE 1: WAREHOUS

create table warehous (
    warehouseid int auto_increment primary key,
    warehousename varchar(100) not null,
    city varchar(50) not null
);


-- TABLE 2: CUSTOMER

create table customer (
    customerid int auto_increment primary key,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    email varchar(100) unique,
    address varchar(200)
);


-- TABLE 3: MEDICINE

create table medicine (
    medicineid int auto_increment primary key,
    name varchar(100) not null,
    requiresprescription boolean default false,
    price decimal(10,2),
    expirydate date,
    warehouseid int,
    constraint chk_medicine_price check (price >= 0)
);


-- TABLE 4: STOCK

create table stock (
    stockid int auto_increment primary key,
    medicineid int not null,
    warehouseid int not null,
    quantityavailable int,
    constraint fk_stock_medicine
        foreign key (medicineid)
        references medicine(medicineid),
    constraint fk_stock_warehouse
        foreign key (warehouseid)
        references warehous(warehouseid),
    constraint chk_stock_quantity
        check (quantityavailable >= 0)
);


-- TABLE 5: PRESCRIPTION

create table prescription (
    prescriptionid int auto_increment primary key,
    customerid int not null,
    documentpath varchar(200),
    verifiedby int,
    verifiedon date,
    status varchar(20) default 'Pending',
    constraint fk_prescription_customer
        foreign key (customerid)
        references customer(customerid)
);


-- TABLE 6: ORDER

create table `order` (
    orderid int auto_increment primary key,
    customerid int not null,
    orderdate timestamp default current_timestamp,
    prescriptionid int,
    status varchar(20) default 'Placed',
    totalamount decimal(10,2),
    constraint fk_order_customer
        foreign key (customerid)
        references customer(customerid),
    constraint fk_order_prescription
        foreign key (prescriptionid)
        references prescription(prescriptionid)
);


-- =====================================================
-- 3. INSERT SAMPLE DATA
-- =====================================================

-- INSERT 10 WAREHOUSES

insert into warehous (warehousename, city) values
('north hub', 'chennai'),
('central hub', 'bengaluru'),
('south hub', 'hyderabad'),
('east hub', 'kolkata'),
('west hub', 'mumbai'),
('pune hub', 'pune'),
('coimbatore hub', 'coimbatore'),
('madurai hub', 'madurai'),
('delhi hub', 'delhi'),
('kochi hub', 'kochi');


-- INSERT 10 CUSTOMERS

insert into customer (firstname, lastname, email, address) values
('aarav', 'sharma', 'aarav1@example.com', '12 lake road'),
('diya', 'rao', 'diya2@example.com', '14 park street'),
('ishaan', 'patel', 'ishaan3@example.com', '18 green avenue'),
('meera', 'iyer', 'meera4@example.com', '20 temple road'),
('kabir', 'das', 'kabir5@example.com', '22 river lane'),
('ananya', 'nair', 'ananya6@example.com', '24 hill view'),
('vihaan', 'singh', 'vihaan7@example.com', '26 market road'),
('sara', 'khan', 'sara8@example.com', '28 garden street'),
('arjun', 'reddy', 'arjun9@example.com', '30 sunrise road'),
('nila', 'krishnan', 'nila10@example.com', '32 main road');


-- INSERT 20 MEDICINES

insert into medicine
(name, requiresprescription, price, expirydate, warehouseid)
values
('paracetamol 500mg', false, 25.00, '2028-12-31', 1),
('cetirizine 10mg', false, 32.50, '2028-11-30', 2),
('vitamin c', false, 90.00, '2029-01-31', 3),
('amoxicillin 500mg', true, 120.00, '2028-10-31', 4),
('metformin 500mg', true, 65.00, '2028-09-30', 5),
('atorvastatin 10mg', true, 145.00, '2028-08-31', 6),
('ors sachet', false, 18.00, '2028-12-31', 7),
('omeprazole 20mg', true, 75.00, '2028-07-31', 8),
('bandage roll', false, 40.00, '2029-06-30', 9),
('cough syrup', false, 85.00, '2028-06-30', 10),
('ibuprofen 200mg', false, 38.00, '2028-10-31', 1),
('insulin pen', true, 550.00, '2028-09-30', 2),
('eye drops', false, 60.00, '2028-12-31', 3),
('azithromycin 250mg', true, 95.00, '2028-11-30', 4),
('antacid tablets', false, 28.00, '2029-01-31', 5),
('nasal spray', false, 110.00, '2028-08-31', 6),
('losartan 50mg', true, 130.00, '2028-10-31', 7),
('calcium tablets', false, 80.00, '2029-02-28', 8),
('dolo gel', false, 70.00, '2028-12-31', 9),
('antiseptic liquid', false, 55.00, '2029-03-31', 10);


-- INSERT 200 STOCK RECORDS
-- 20 MEDICINES X 10 WAREHOUSES = 200 RECORDS

insert into stock
(medicineid, warehouseid, quantityavailable)
select
    m.medicineid,
    w.warehouseid,
    50 + mod(m.medicineid * 7 + w.warehouseid * 3, 100)
from medicine m
cross join warehous w;


-- INSERT 10 PRESCRIPTIONS

insert into prescription
(customerid, documentpath, verifiedby, verifiedon, status)
values
(1, '/prescriptions/p001.pdf', 101, '2026-11-01', 'Approved'),
(2, '/prescriptions/p002.pdf', null, null, 'Pending'),
(3, '/prescriptions/p003.pdf', 102, '2026-11-02', 'Approved'),
(4, '/prescriptions/p004.pdf', null, null, 'Pending'),
(5, '/prescriptions/p005.pdf', 103, '2026-11-03', 'Rejected'),
(6, '/prescriptions/p006.pdf', null, null, 'Pending'),
(7, '/prescriptions/p007.pdf', 104, '2026-11-04', 'Approved'),
(8, '/prescriptions/p008.pdf', null, null, 'Pending'),
(9, '/prescriptions/p009.pdf', 105, '2026-11-05', 'Approved'),
(10, '/prescriptions/p010.pdf', null, null, 'Pending');


-- INSERT 10 ORDERS

insert into `order`
(customerid, orderdate, prescriptionid, status, totalamount)
values
(1, '2026-11-10 10:00:00', 1, 'Confirmed', 50.00),
(2, '2026-11-10 11:00:00', 2, 'Placed', 120.00),
(3, '2026-11-11 12:00:00', 3, 'Confirmed', 130.00),
(4, '2026-11-11 13:00:00', 4, 'Placed', 75.00),
(5, '2026-11-12 14:00:00', 5, 'Cancelled', 65.00),
(6, '2026-11-12 15:00:00', 6, 'Placed', 550.00),
(7, '2026-11-13 10:00:00', 7, 'Confirmed', 145.00),
(8, '2026-11-13 11:00:00', 8, 'Placed', 190.00),
(9, '2026-11-14 12:00:00', 9, 'Confirmed', 130.00),
(10, '2026-11-14 13:00:00', 10, 'Placed', 120.00);


-- =====================================================
-- 4. CONSTRAINT TESTING
-- =====================================================

-- A. UNIQUE CONSTRAINT

-- VALID: INSERT A CUSTOMER WITH A NEW EMAIL

insert into customer
(firstname, lastname, email, address)
values
('test', 'customer', 'test@example.com', 'test address');

-- INVALID: DUPLICATE EMAIL
-- EXPECTED RESULT: UNIQUE CONSTRAINT ERROR

insert into customer
(firstname, lastname, email, address)
values
('duplicate', 'customer', 'test@example.com', 'test address');


-- B. CHECK CONSTRAINT

-- VALID: POSITIVE MEDICINE PRICE

insert into medicine
(name, requiresprescription, price, expirydate, warehouseid)
values
('test valid medicine', false, 100.00, '2029-12-31', 1);

-- INVALID: NEGATIVE MEDICINE PRICE
-- EXPECTED RESULT: CHECK CONSTRAINT ERROR

insert into medicine
(name, requiresprescription, price, expirydate, warehouseid)
values
('test invalid medicine', false, -100.00, '2029-12-31', 1);


-- C. DEFAULT CONSTRAINT

-- VALID: OMIT requiresprescription
-- DEFAULT VALUE SHOULD BE FALSE

insert into medicine
(name, price, expirydate, warehouseid)
values
('default test medicine', 50.00, '2029-12-31', 1);

select medicineid, name, requiresprescription
from medicine
where name = 'default test medicine';

-- EXPLICIT VALUE OVERRIDES THE DEFAULT

insert into medicine
(name, requiresprescription, price, expirydate, warehouseid)
values
('default override medicine', true, 75.00, '2029-12-31', 1);

select medicineid, name, requiresprescription
from medicine
where name in
('default test medicine', 'default override medicine');


-- D. FOREIGN KEY CONSTRAINT

-- VALID: EXISTING MEDICINE AND WAREHOUSE IDS

insert into stock
(medicineid, warehouseid, quantityavailable)
values
(1, 1, 100);

-- INVALID: NON-EXISTING MEDICINE ID
-- EXPECTED RESULT: FOREIGN KEY CONSTRAINT ERROR

insert into stock
(medicineid, warehouseid, quantityavailable)
values
(9999, 1, 100);

-- INVALID: NON-EXISTING WAREHOUSE ID
-- EXPECTED RESULT: FOREIGN KEY CONSTRAINT ERROR

insert into stock
(medicineid, warehouseid, quantityavailable)
values
(1, 9999, 100);

-- INVALID: NON-EXISTING CUSTOMER ID
-- EXPECTED RESULT: FOREIGN KEY CONSTRAINT ERROR

insert into prescription
(customerid, documentpath, status)
values
(9999, '/prescriptions/invalid.pdf', 'Pending');


-- =====================================================
-- 5. VERIFY ALL TABLES
-- =====================================================

select * from customer;

select * from medicine;

select * from warehous;

select * from stock;

select * from prescription;

select * from `order`;


-- =====================================================
-- 6. VERIFY RECORD COUNTS
-- =====================================================

select 'customer' as table_name, count(*) as total_records
from customer

union all

select 'medicine', count(*)
from medicine

union all

select 'warehous', count(*)
from warehous

union all

select 'stock', count(*)
from stock

union all

select 'prescription', count(*)
from prescription

union all

select '`order`', count(*)
from `order`;


-- =====================================================
-- 7. VERIFY TABLE STRUCTURE
-- =====================================================

show tables;

describe customer;

describe medicine;

describe warehous;

describe stock;

describe prescription;

describe `order`;


-- =====================================================
-- END OF SPRINT 1
-- =====================================================
