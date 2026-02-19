<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details - Ocean View Resort</title>
    <style>
        <%@ include file="/WEB-INF/views/styles/common.css" %>

        .detail-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 900px;
        }

        .detail-header {
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 20px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-header h2 {
            color: #333;
            font-size: 1.8em;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .detail-item {
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .detail-item.full-width {
            grid-column: 1 / -1;
        }

        .detail-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }

        .detail-value {
            color: #333;
            font-size: 1.1em;
        }

        .status-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .status-section h3 {
            margin-bottom: 15px;
        }

        .status-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .status-btn {
            padding: 8px 16px;
            background-color: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s;
        }

        .status-btn:hover {
            background-color: rgba(255,255,255,0.3);
        }

        .status-btn.active {
            background-color: white;
            color: #667eea;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .summary-box {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .summary-item:last-child {
            border-bottom: none;
            font-size: 1.3em;
            font-weight: bold;
            padding-top: 15px;
        }

        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 1.1em;
            font-weight: 600;
        }

        .status-confirmed {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .status-checked-in {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status-checked-out {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }

        @media (max-width: 768px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }

            .detail-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="main-container">
        <%@ include file="/WEB-INF/views/includes/sidebar.jsp" %>

        <div class="content">
            <div class="page-header">
                <h1>Reservation Details</h1>
                <p>Complete information about the reservation</p>
            </div>

            <% if (request.getParameter("success") != null) {
                String success = request.getParameter("success");
                String message = "";
                if ("added".equals(success)) message = "Reservation created successfully!";
                else if ("updated".equals(success)) message = "Reservation updated successfully!";
                else if ("statusUpdated".equals(success)) message = "Status updated successfully!";
            %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
            <% } %>

            <%
                Reservation reservation = (Reservation) request.getAttribute("reservation");
                if (reservation != null) {
            %>

            <div class="detail-container">
                <div class="detail-header">
                    <h2>Reservation #<%= reservation.getReservationNumber() %></h2>
                    <span class="status-badge status-<%= reservation.getStatus().toLowerCase().replace("_", "-") %>">
                        <%= reservation.getStatus().replace("_", " ") %>
                    </span>
                </div>

                <div class="status-section">
                    <h3>Update Reservation Status</h3>
                    <form method="post" action="<%= request.getContextPath() %>/reservation" style="display: inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="reservationNumber" value="<%= reservation.getReservationNumber() %>">
                        <div class="status-buttons">
                            <button type="submit" name="status" value="CONFIRMED"
                                    class="status-btn <%= "CONFIRMED".equals(reservation.getStatus()) ? "active" : "" %>">
                                Confirmed
                            </button>
                            <button type="submit" name="status" value="CHECKED_IN"
                                    class="status-btn <%= "CHECKED_IN".equals(reservation.getStatus()) ? "active" : "" %>">
                                Checked In
                            </button>
                            <button type="submit" name="status" value="CHECKED_OUT"
                                    class="status-btn <%= "CHECKED_OUT".equals(reservation.getStatus()) ? "active" : "" %>">
                                Checked Out
                            </button>
                            <button type="submit" name="status" value="CANCELLED"
                                    class="status-btn <%= "CANCELLED".equals(reservation.getStatus()) ? "active" : "" %>"
                                    onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                Cancelled
                            </button>
                        </div>
                    </form>
                </div>

                <h3 style="margin-bottom: 20px; color: #333;">Guest Information</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Guest Name</div>
                        <div class="detail-value"><%= reservation.getGuestName() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Contact Number</div>
                        <div class="detail-value"><%= reservation.getContactNumber() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Email</div>
                        <div class="detail-value">
                            <%= reservation.getEmail() != null && !reservation.getEmail().isEmpty()
                                ? reservation.getEmail() : "Not provided" %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Number of Guests</div>
                        <div class="detail-value"><%= reservation.getNumberOfGuests() %> <%= reservation.getNumberOfGuests() > 1 ? "guests" : "guest" %></div>
                    </div>

                    <div class="detail-item full-width">
                        <div class="detail-label">Address</div>
                        <div class="detail-value"><%= reservation.getAddress() %></div>
                    </div>
                </div>

                <h3 style="margin-bottom: 20px; color: #333;">Booking Information</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Room Type</div>
                        <div class="detail-value"><%= reservation.getRoomType() %> Room</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Rate per Night</div>
                        <div class="detail-value">LKR <%= String.format("%,.2f", Reservation.getRoomRate(reservation.getRoomType())) %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Check-In Date</div>
                        <div class="detail-value"><%= reservation.getFormattedCheckInDate() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Check-Out Date</div>
                        <div class="detail-value"><%= reservation.getFormattedCheckOutDate() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Number of Nights</div>
                        <div class="detail-value"><%= reservation.getNumberOfNights() %> <%= reservation.getNumberOfNights() > 1 ? "nights" : "night" %></div>
                    </div>
                </div>

                <div class="summary-box">
                    <h3 style="margin-bottom: 15px;">Payment Summary</h3>
                    <div class="summary-item">
                        <span>Room Rate (per night):</span>
                        <span>LKR <%= String.format("%,.2f", Reservation.getRoomRate(reservation.getRoomType())) %></span>
                    </div>
                    <div class="summary-item">
                        <span>Number of Nights:</span>
                        <span><%= reservation.getNumberOfNights() %></span>
                    </div>
                    <div class="summary-item">
                        <span>Total Amount:</span>
                        <span>LKR <%= String.format("%,.2f", reservation.getTotalAmount()) %></span>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="<%= request.getContextPath() %>/reservation?action=bill&id=<%= reservation.getReservationNumber() %>"
                       class="btn-primary">
                        📄 Generate Bill
                    </a>
                    <a href="<%= request.getContextPath() %>/reservation?action=edit&id=<%= reservation.getReservationNumber() %>"
                       class="btn-primary">
                        ✏️ Edit Reservation
                    </a>
                    <a href="<%= request.getContextPath() %>/reservation" class="btn-secondary">
                        ← Back to List
                    </a>
                    <a href="<%= request.getContextPath() %>/reservation?action=delete&id=<%= reservation.getReservationNumber() %>"
                       class="btn-danger"
                       onclick="return confirm('Are you sure you want to delete this reservation?')">
                        🗑️ Delete
                    </a>
                </div>
            </div>

            <% } else { %>
                <div class="alert alert-error">
                    Reservation not found.
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>