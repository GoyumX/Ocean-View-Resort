<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("edit") != null ? "Edit" : "New" %> Reservation - Ocean View Resort</title>
    <style>
        <%@ include file="/WEB-INF/views/styles/common.css" %>

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .form-group input[readonly] {
            background-color: #f8f9fa;
            cursor: not-allowed;
        }

        .room-rates {
            background-color: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }

        .room-rates h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1em;
        }

        .room-rates ul {
            list-style: none;
            color: #666;
        }

        .room-rates li {
            padding: 5px 0;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
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
                <h1><%= request.getAttribute("edit") != null ? "Edit" : "New" %> Reservation</h1>
                <p>Fill in the details below to <%= request.getAttribute("edit") != null ? "update" : "create" %> a reservation</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <%
                Reservation reservation = (Reservation) request.getAttribute("reservation");
                boolean isEdit = request.getAttribute("edit") != null;
                String formAction = isEdit ? "update" : "add";
                String reservationNumber = isEdit ? reservation.getReservationNumber() :
                                          (String) request.getAttribute("reservationNumber");
            %>

            <div class="form-container">
                <form method="post" action="<%= request.getContextPath() %>/reservation">
                    <input type="hidden" name="action" value="<%= formAction %>">

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="reservationNumber">Reservation Number</label>
                            <input type="text" id="reservationNumber" name="reservationNumber"
                                   value="<%= reservationNumber %>" readonly>
                        </div>

                        <div class="form-group">
                            <label for="guestName">Guest Name <span class="required">*</span></label>
                            <input type="text" id="guestName" name="guestName"
                                   value="<%= isEdit ? reservation.getGuestName() :
                                           (request.getAttribute("guestName") != null ? request.getAttribute("guestName") : "") %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="contactNumber">Contact Number <span class="required">*</span></label>
                            <input type="tel" id="contactNumber" name="contactNumber"
                                   value="<%= isEdit ? reservation.getContactNumber() :
                                           (request.getAttribute("contactNumber") != null ? request.getAttribute("contactNumber") : "") %>"
                                   pattern="[0-9]{10}" placeholder="0771234567" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email"
                                   value="<%= isEdit && reservation.getEmail() != null ? reservation.getEmail() :
                                           (request.getAttribute("email") != null ? request.getAttribute("email") : "") %>">
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Address <span class="required">*</span></label>
                            <textarea id="address" name="address" required><%= isEdit ? reservation.getAddress() :
                                      (request.getAttribute("address") != null ? request.getAttribute("address") : "") %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="roomType">Room Type <span class="required">*</span></label>
                            <select id="roomType" name="roomType" required>
                                <option value="">Select Room Type</option>
                                <option value="SINGLE" <%= (isEdit && "SINGLE".equals(reservation.getRoomType())) ||
                                                           "SINGLE".equals(request.getAttribute("roomType")) ? "selected" : "" %>>
                                    Single Room
                                </option>
                                <option value="DOUBLE" <%= (isEdit && "DOUBLE".equals(reservation.getRoomType())) ||
                                                           "DOUBLE".equals(request.getAttribute("roomType")) ? "selected" : "" %>>
                                    Double Room
                                </option>
                                <option value="DELUXE" <%= (isEdit && "DELUXE".equals(reservation.getRoomType())) ||
                                                           "DELUXE".equals(request.getAttribute("roomType")) ? "selected" : "" %>>
                                    Deluxe Room
                                </option>
                                <option value="SUITE" <%= (isEdit && "SUITE".equals(reservation.getRoomType())) ||
                                                          "SUITE".equals(request.getAttribute("roomType")) ? "selected" : "" %>>
                                    Suite
                                </option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="numberOfGuests">Number of Guests <span class="required">*</span></label>
                            <input type="number" id="numberOfGuests" name="numberOfGuests" min="1" max="10"
                                   value="<%= isEdit ? reservation.getNumberOfGuests() :
                                           (request.getAttribute("numberOfGuests") != null ? request.getAttribute("numberOfGuests") : "1") %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="checkInDate">Check-In Date <span class="required">*</span></label>
                            <input type="date" id="checkInDate" name="checkInDate"
                                   value="<%= isEdit ? reservation.getFormattedCheckInDate() :
                                           (request.getAttribute("checkInDate") != null ? request.getAttribute("checkInDate") : "") %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="checkOutDate">Check-Out Date <span class="required">*</span></label>
                            <input type="date" id="checkOutDate" name="checkOutDate"
                                   value="<%= isEdit ? reservation.getFormattedCheckOutDate() :
                                           (request.getAttribute("checkOutDate") != null ? request.getAttribute("checkOutDate") : "") %>"
                                   required>
                        </div>

                        <div class="form-group full-width">
                            <div class="room-rates">
                                <h4>💰 Room Rates (per night):</h4>
                                <ul>
                                    <li><strong>Single Room:</strong> LKR 5,000.00</li>
                                    <li><strong>Double Room:</strong> LKR 8,000.00</li>
                                    <li><strong>Deluxe Room:</strong> LKR 12,000.00</li>
                                    <li><strong>Suite:</strong> LKR 20,000.00</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">
                            <%= isEdit ? "Update Reservation" : "Create Reservation" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/reservation" class="btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('checkInDate').setAttribute('min', today);

        // Update check-out minimum date when check-in changes
        document.getElementById('checkInDate').addEventListener('change', function() {
            const checkInDate = this.value;
            const checkOutInput = document.getElementById('checkOutDate');
            checkOutInput.setAttribute('min', checkInDate);

            // If check-out is before new check-in, reset it
            if (checkOutInput.value && checkOutInput.value <= checkInDate) {
                checkOutInput.value = '';
            }
        });
    </script>
</body>
</html>