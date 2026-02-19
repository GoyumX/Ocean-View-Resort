<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Ocean View Resort</title>
    <style>
        <%@ include file="/WEB-INF/views/styles/common.css" %>

        .help-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 1000px;
        }

        .help-section {
            margin-bottom: 40px;
        }

        .help-section h2 {
            color: #667eea;
            font-size: 1.8em;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .help-section h3 {
            color: #333;
            font-size: 1.3em;
            margin-top: 25px;
            margin-bottom: 15px;
        }

        .help-section p {
            color: #666;
            line-height: 1.8;
            margin-bottom: 15px;
        }

        .help-section ul,
        .help-section ol {
            color: #666;
            line-height: 1.8;
            margin-left: 25px;
            margin-bottom: 15px;
        }

        .help-section li {
            margin-bottom: 10px;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .feature-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
        }

        .feature-card .icon {
            font-size: 3em;
            margin-bottom: 15px;
        }

        .feature-card h4 {
            font-size: 1.2em;
            margin-bottom: 10px;
        }

        .feature-card p {
            font-size: 0.95em;
            color: rgba(255,255,255,0.9);
        }

        .info-box {
            background-color: #f0f7ff;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
        }

        .info-box strong {
            color: #667eea;
        }

        .warning-box {
            background-color: #fff4e6;
            border-left: 4px solid #f59e0b;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
        }

        .warning-box strong {
            color: #f59e0b;
        }

        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="main-container">
        <%@ include file="/WEB-INF/views/includes/sidebar.jsp" %>

        <div class="content">
            <div class="page-header">
                <h1>Help & Documentation</h1>
                <p>Complete guide to using the Ocean View Resort Reservation System</p>
            </div>

            <div class="help-container">
                <!-- Introduction -->
                <div class="help-section">
                    <h2>📖 Introduction</h2>
                    <p>
                        Welcome to the Ocean View Resort Reservation Management System. This application is designed
                        to streamline the hotel booking process, manage guest information, and handle reservations
                        efficiently. This guide will help you navigate through all the features of the system.
                    </p>
                </div>

                <!-- Getting Started -->
                <div class="help-section">
                    <h2>🚀 Getting Started</h2>

                    <h3>1. Login to the System</h3>
                    <p>To access the system, you need to login with your credentials:</p>
                    <div class="info-box">
                        <strong>Default Login Credentials:</strong><br>
                        • Admin: username = <code>admin</code>, password = <code>admin123</code><br>
                        • Manager: username = <code>manager</code>, password = <code>manager123</code><br>
                        • Staff: username = <code>staff</code>, password = <code>staff123</code>
                    </div>

                    <ol>
                        <li>Enter your username in the Username field</li>
                        <li>Enter your password in the Password field</li>
                        <li>Click the <strong>Login</strong> button</li>
                        <li>You will be redirected to the Dashboard upon successful login</li>
                    </ol>
                </div>

                <!-- Main Features -->
                <div class="help-section">
                    <h2>✨ Main Features</h2>

                    <div class="feature-grid">
                        <div class="feature-card">
                            <div class="icon">📊</div>
                            <h4>Dashboard</h4>
                            <p>View statistics and active reservations at a glance</p>
                        </div>

                        <div class="feature-card">
                            <div class="icon">➕</div>
                            <h4>Add Reservation</h4>
                            <p>Create new guest bookings with complete details</p>
                        </div>

                        <div class="feature-card">
                            <div class="icon">📋</div>
                            <h4>View Reservations</h4>
                            <p>Browse and search all reservations in the system</p>
                        </div>

                        <div class="feature-card">
                            <div class="icon">💰</div>
                            <h4>Generate Bills</h4>
                            <p>Calculate and print guest bills automatically</p>
                        </div>
                    </div>
                </div>

                <!-- Creating a Reservation -->
                <div class="help-section">
                    <h2>➕ Creating a New Reservation</h2>

                    <h3>Step-by-Step Guide:</h3>
                    <ol>
                        <li>Click on <strong>"New Reservation"</strong> from the sidebar or dashboard</li>
                        <li>The system will automatically generate a unique Reservation Number</li>
                        <li>Fill in the following required information:
                            <ul>
                                <li><strong>Guest Name:</strong> Full name of the guest</li>
                                <li><strong>Contact Number:</strong> 10-digit phone number (e.g., 0771234567)</li>
                                <li><strong>Address:</strong> Complete address of the guest</li>
                                <li><strong>Email:</strong> Optional email address</li>
                                <li><strong>Room Type:</strong> Select from Single, Double, Deluxe, or Suite</li>
                                <li><strong>Number of Guests:</strong> Total number of guests (1-10)</li>
                                <li><strong>Check-In Date:</strong> Date of arrival</li>
                                <li><strong>Check-Out Date:</strong> Date of departure</li>
                            </ul>
                        </li>
                        <li>Review the room rates displayed on the form</li>
                        <li>Click <strong>"Create Reservation"</strong> to save</li>
                        <li>The system will calculate the total amount automatically</li>
                    </ol>

                    <div class="info-box">
                        <strong>Room Rates (per night):</strong><br>
                        • Single Room: LKR 5,000.00<br>
                        • Double Room: LKR 8,000.00<br>
                        • Deluxe Room: LKR 12,000.00<br>
                        • Suite: LKR 20,000.00
                    </div>
                </div>

                <!-- Managing Reservations -->
                <div class="help-section">
                    <h2>📋 Managing Reservations</h2>

                    <h3>Viewing All Reservations</h3>
                    <p>Click on <strong>"Reservations"</strong> in the sidebar to see a complete list of all reservations with:</p>
                    <ul>
                        <li>Reservation number and guest details</li>
                        <li>Room type and dates</li>
                        <li>Total amount</li>
                        <li>Current status</li>
                        <li>Action buttons (View, Edit, Delete)</li>
                    </ul>

                    <h3>Searching for Reservations</h3>
                    <ol>
                        <li>Go to the Reservations page</li>
                        <li>Enter the guest name in the search box</li>
                        <li>Click <strong>"Search"</strong></li>
                        <li>Results will be filtered based on your search</li>
                    </ol>

                    <h3>Viewing Reservation Details</h3>
                    <ol>
                        <li>Click the <strong>"View"</strong> button next to any reservation</li>
                        <li>You will see complete details including:
                            <ul>
                                <li>Guest information</li>
                                <li>Booking information</li>
                                <li>Payment summary</li>
                                <li>Current status</li>
                            </ul>
                        </li>
                    </ol>

                    <h3>Editing a Reservation</h3>
                    <ol>
                        <li>Click the <strong>"Edit"</strong> button next to a reservation</li>
                        <li>Modify the required fields</li>
                        <li>Click <strong>"Update Reservation"</strong> to save changes</li>
                        <li>The total amount will be recalculated automatically</li>
                    </ol>

                    <h3>Deleting a Reservation</h3>
                    <ol>
                        <li>Click the <strong>"Delete"</strong> button next to a reservation</li>
                        <li>Confirm the deletion when prompted</li>
                        <li>The reservation will be permanently removed</li>
                    </ol>

                    <div class="warning-box">
                        <strong>⚠️ Warning:</strong> Deleting a reservation is permanent and cannot be undone.
                        Consider changing the status to "Cancelled" instead if you want to keep records.
                    </div>
                </div>

                <!-- Reservation Status -->
                <div class="help-section">
                    <h2>🔄 Managing Reservation Status</h2>

                    <p>Each reservation can have one of the following statuses:</p>

                    <ul>
                        <li><strong>CONFIRMED:</strong> Initial status when a reservation is created</li>
                        <li><strong>CHECKED IN:</strong> Guest has arrived and checked into the room</li>
                        <li><strong>CHECKED OUT:</strong> Guest has completed their stay and left</li>
                        <li><strong>CANCELLED:</strong> Reservation has been cancelled</li>
                    </ul>

                    <h3>To Update Status:</h3>
                    <ol>
                        <li>Open the reservation details page</li>
                        <li>In the status section, click on the appropriate status button</li>
                        <li>The status will be updated immediately</li>
                    </ol>
                </div>
                <div class="help-section">
                    <h2>💰 Generating and Printing Bills</h2>

                    <h3>To Generate a Bill:</h3>
                    <ol>
                        <li>Open the reservation details page</li>
                        <li>Click the <strong>"Generate Bill"</strong> button</li>
                        <li>The bill will display:
                            <ul>
                                <li>Guest details</li>
                                <li>Reservation information</li>
                                <li>Itemized charges</li>
                                <li>Total amount payable</li>
                            </ul>
                        </li>
                        <li>Click the <strong>"Print Bill"</strong> button to print or save as PDF</li>
                    </ol>

                    <div class="info-box">
                        <strong>💡 Tip:</strong> The bill includes all relevant information needed for
                        payment processing and record keeping. You can print it directly or save it as a PDF
                        using your browser's print function.
                    </div>
                </div>

                <!-- Dashboard -->
                <div class="help-section">
                    <h2>📊 Understanding the Dashboard</h2>

                    <p>The dashboard provides a quick overview of your hotel operations:</p>

                    <ul>
                        <li><strong>Total Reservations:</strong> All-time count of reservations in the system</li>
                        <li><strong>Active Reservations:</strong> Currently checked-in guests</li>
                        <li><strong>Confirmed:</strong> Upcoming bookings that are confirmed</li>
                        <li><strong>Total Revenue:</strong> Sum of all checked-out reservation amounts</li>
                    </ul>

                    <p>The active reservations table shows guests who are currently staying at the hotel or
                    have confirmed bookings, allowing you to quickly access their information.</p>
                </div>

                <!-- Troubleshooting -->
                <div class="help-section">
                    <h2>🔧 Troubleshooting</h2>

                    <h3>Cannot Login</h3>
                    <ul>
                        <li>Verify you're using the correct username and password</li>
                        <li>Check that CAPS LOCK is not enabled</li>
                        <li>Contact your system administrator if you've forgotten your password</li>
                    </ul>

                    <h3>Date Validation Errors</h3>
                    <ul>
                        <li>Ensure check-out date is after check-in date</li>
                        <li>Check-in date cannot be in the past</li>
                        <li>Use the date picker to select dates properly</li>
                    </ul>

                    <h3>Cannot Find a Reservation</h3>
                    <ul>
                        <li>Double-check the reservation number or guest name</li>
                        <li>Use the search function with partial names</li>
                        <li>Verify the reservation hasn't been deleted</li>
                    </ul>
                </div>

                <!-- Best Practices -->
                <div class="help-section">
                    <h2>✅ Best Practices</h2>

                    <ol>
                        <li><strong>Always verify guest information</strong> before creating a reservation</li>
                        <li><strong>Update reservation status</strong> promptly (especially check-ins and check-outs)</li>
                        <li><strong>Use the search function</strong> to quickly find reservations</li>
                        <li><strong>Generate bills</strong> before guests check out</li>
                        <li><strong>Review the dashboard regularly</strong> to monitor hotel operations</li>
                        <li><strong>Keep contact information updated</strong> for better guest communication</li>
                        <li><strong>Use "Cancelled" status</strong> instead of deleting to maintain records</li>
                        <li><strong>Log out</strong> when finished to maintain security</li>
                    </ol>
                </div>

                <!-- Support -->
                <div class="help-section">
                    <h2>📞 Support</h2>

                    <p>If you need additional help or encounter any issues:</p>

                    <div class="info-box">
                        <strong>Contact Information:</strong><br>
                        📧 Email: support@oceanviewresort.lk<br>
                        📞 Phone: +94 91 222 3456<br>
                        ⏰ Support Hours: 24/7
                    </div>

                    <p>For technical support or feature requests, please contact the system administrator.</p>
                </div>
            </div>
        </div>
    </div>
    </body>
    </html>
