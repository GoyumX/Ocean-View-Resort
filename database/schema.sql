-- Ocean View Resort - Database Schema
-- MySQL 8.0+
-- Run this script to set up the database before starting the application

-- Create database
CREATE DATABASE IF NOT EXISTS oceanview_resort;
USE oceanview_resort;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'STAFF',
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reservations table
CREATE TABLE IF NOT EXISTS reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    room_type VARCHAR(20) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    email VARCHAR(100),
    number_of_guests INT NOT NULL DEFAULT 1,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_reservation_number (reservation_number),
    INDEX idx_guest_name (guest_name),
    INDEX idx_status (status),
    INDEX idx_check_dates (check_in_date, check_out_date)
);

-- Insert default users for testing
INSERT INTO users (username, password, full_name, role, email) VALUES
    ('admin', 'admin123', 'System Administrator', 'ADMIN', 'admin@oceanview.com'),
    ('manager', 'manager123', 'Hotel Manager', 'ADMIN', 'manager@oceanview.com'),
    ('staff', 'staff123', 'Front Desk Staff', 'STAFF', 'staff@oceanview.com')
ON DUPLICATE KEY UPDATE username = username;
