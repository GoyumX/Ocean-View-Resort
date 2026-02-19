<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.*, java.time.*, java.time.format.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill - Ocean View Resort</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .bill-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .bill-header {
            text-align: center;
            border-bottom: 3px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .bill-header h1 {
            color: #667eea;
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .bill-header .tagline {
            color: #666;
            font-size: 1.1em;
            margin-bottom: 5px;
        }

        .bill-header .contact {
            color: #999;
            font-size: 0.9em;
        }

        .bill-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.2em;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 8px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
        }

        .info-label {
            color: #666;
            font-weight: 600;
        }

        .info-value {
            color: #333;
        }

        .charges-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .charges-table th,
        .charges-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .charges-table th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
        }

        .charges-table td {
            color: #666;
        }

        .charges-table .amount {
            text-align: right;
            font-weight: 600;
        }

        .total-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .total-row:last-child {
            border-bottom: none;
            font-size: 1.5em;
            font-weight: bold;
            padding-top: 15px;
        }

        .footer-note {
            text-align: center;
            color: #666;
            font-size: 0.95em;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            font-size: 1em;
        }

        .btn-print {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
        }

        @media print {
            body {
                background: white;
                padding: 0;
            }

            .bill-container {
                box-shadow: none;
                padding: 20px;
            }

            .action-buttons {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .bill-container {
                padding: 20px;
            }

            .bill-info {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <%
        Reservation reservation = (Reservation) request.getAttribute("reservation");
        if (reservation != null) {
            String currentDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a"));
    %>

    <div class="bill-container">
        <div class="bill-header">
            <h1>🏖️ Ocean View Resort</h1>
            <div class="tagline">Galle, Sri Lanka - Your Beachside Paradise</div>
            <div class="contact">📞 +94 91 222 3456 | 📧 info@oceanviewresort.lk | 🌐 www.oceanviewresort.lk</div>
        </div>

        <h2 style="text-align: center; color: #333; margin-bottom: 30px;">GUEST BILL</h2>

        <div class="bill-info">
            <div class="info-section">
                <h3>Guest Details</h3>
                <div class="info-row">
                    <span class="info-label">Name:</span>
                    <span class="info-value"><%= reservation.getGuestName() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Contact:</span>
                    <span class="info-value"><%= reservation.getContactNumber() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value">
                        <%= reservation.getEmail() != null && !reservation.getEmail().isEmpty()
                            ? reservation.getEmail() : "N/A" %>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Guests:</span>
                    <span class="info-value"><%= reservation.getNumberOfGuests() %></span>
                </div>
            </div>

            <div class="info-section">
                <h3>Reservation Details</h3>
                <div class="info-row">
                    <span class="info-label">Reservation #:</span>
                    <span class="info-value"><%= reservation.getReservationNumber() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Room Type:</span>
                    <span class="info-value"><%= reservation.getRoomType() %> Room</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Check-In:</span>
                    <span class="info-value"><%= reservation.getFormattedCheckInDate() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Check-Out:</span>
                    <span class="info-value"><%= reservation.getFormattedCheckOutDate() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Bill Date:</span>
                    <span class="info-value"><%= currentDate %></span>
                </div>
            </div>
        </div>

        <table class="charges-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="text-align: center;">Quantity</th>
                    <th style="text-align: right;">Rate (LKR)</th>
                    <th style="text-align: right;">Amount (LKR)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= reservation.getRoomType() %> Room Accommodation</td>
                    <td style="text-align: center;"><%= reservation.getNumberOfNights() %> <%= reservation.getNumberOfNights() > 1 ? "nights" : "night" %></td>
                    <td class="amount"><%= String.format("%,.2f", Reservation.getRoomRate(reservation.getRoomType())) %></td>
                    <td class="amount"><%= String.format("%,.2f", reservation.getTotalAmount()) %></td>
                </tr>
            </tbody>
        </table>

        <div class="total-section">
            <div class="total-row">
                <span>Subtotal:</span>
                <span>LKR <%= String.format("%,.2f", reservation.getTotalAmount()) %></span>
            </div>
            <div class="total-row">
                <span>Tax (0%):</span>
                <span>LKR 0.00</span>
            </div>
            <div class="total-row">
                <span>Service Charge (0%):</span>
                <span>LKR 0.00</span>
            </div>
            <div class="total-row">
                <span>GRAND TOTAL:</span>
                <span>LKR <%= String.format("%,.2f", reservation.getTotalAmount()) %></span>
            </div>
        </div>

        <div class="footer-note">
            <p><strong>Thank you for choosing Ocean View Resort!</strong></p>
            <p>We hope you enjoyed your stay with us. Please visit us again soon.</p>
            <p style="margin-top: 10px; font-size: 0.85em;">
                This is a computer-generated bill and does not require a signature.
            </p>
        </div>

        <div class="action-buttons">
            <button onclick="window.print()" class="btn btn-print">🖨️ Print Bill</button>
            <a href="<%= request.getContextPath() %>/reservation?action=view&id=<%= reservation.getReservationNumber() %>"
               class="btn btn-back">← Back to Reservation</a>
        </div>
    </div>

    <% } else { %>
        <div class="bill-container">
            <div style="text-align: center; padding: 40px; color: #dc3545;">
                <h2>Error: Reservation not found</h2>
                <p style="margin-top: 20px;">
                    <a href="<%= request.getContextPath() %>/reservation" class="btn btn-back">← Back to Reservations</a>
                </p>
            </div>
        </div>
    <% } %>
</body>
</html>