<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.oceanview.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations - Ocean View Resort</title>
    <style>
        <%@ include file="/WEB-INF/views/styles/common.css" %>

        .table-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box {
            display: flex;
            gap: 10px;
        }

        .search-box input {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            min-width: 300px;
        }

        .search-box input:focus {
            outline: none;
            border-color: #667eea;
        }

        .search-box button {
            padding: 10px 20px;
            background-color: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            white-space: nowrap;
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

        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-small {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 0.85em;
            font-weight: 600;
        }

        .btn-view {
            background-color: #667eea;
            color: white;
        }

        .btn-edit {
            background-color: #10b981;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-small:hover {
            opacity: 0.9;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
        }

        .empty-state p {
            margin-bottom: 25px;
        }

        @media (max-width: 768px) {
            table {
                font-size: 0.9em;
            }

            .search-box input {
                min-width: 200px;
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
                <h1>Reservations</h1>
                <p>Manage all hotel reservations</p>
            </div>

            <% if (request.getParameter("success") != null) {
                String success = request.getParameter("success");
                String message = "";
                if ("added".equals(success)) message = "Reservation created successfully!";
                else if ("updated".equals(success)) message = "Reservation updated successfully!";
                else if ("deleted".equals(success)) message = "Reservation deleted successfully!";
                else if ("statusUpdated".equals(success)) message = "Status updated successfully!";
            %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <div class="table-container">
                <div class="table-header">
                    <h2>All Reservations</h2>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <form method="get" action="<%= request.getContextPath() %>/reservation" class="search-box">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="query" placeholder="Search by guest name..."
                                   value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>">
                            <button type="submit">🔍 Search</button>
                        </form>
                        <a href="<%= request.getContextPath() %>/reservation?action=new" class="btn-primary">
                            + New Reservation
                        </a>
                    </div>
                </div>

                <%
                    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                    if (reservations != null && !reservations.isEmpty()) {
                %>
                    <table>
                        <thead>
                            <tr>
                                <th>Reservation #</th>
                                <th>Guest Name</th>
                                <th>Contact</th>
                                <th>Room Type</th>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reservation res : reservations) { %>
                                <tr>
                                    <td><strong><%= res.getReservationNumber() %></strong></td>
                                    <td><%= res.getGuestName() %></td>
                                    <td><%= res.getContactNumber() %></td>
                                    <td><%= res.getRoomType() %></td>
                                    <td><%= res.getFormattedCheckInDate() %></td>
                                    <td><%= res.getFormattedCheckOutDate() %></td>
                                    <td>LKR <%= String.format("%,.2f", res.getTotalAmount()) %></td>
                                    <td>
                                        <span class="status-badge status-<%= res.getStatus().toLowerCase().replace("_", "-") %>">
                                            <%= res.getStatus().replace("_", " ") %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="<%= request.getContextPath() %>/reservation?action=view&id=<%= res.getReservationNumber() %>"
                                               class="btn-small btn-view">View</a>
                                            <a href="<%= request.getContextPath() %>/reservation?action=edit&id=<%= res.getReservationNumber() %>"
                                               class="btn-small btn-edit">Edit</a>
                                            <a href="<%= request.getContextPath() %>/reservation?action=delete&id=<%= res.getReservationNumber() %>"
                                               class="btn-small btn-delete"
                                               onclick="return confirm('Are you sure you want to delete this reservation?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <h3>📋 No Reservations Found</h3>
                        <% if (request.getAttribute("searchQuery") != null) { %>
                            <p>No reservations match your search criteria.</p>
                            <a href="<%= request.getContextPath() %>/reservation" class="btn-primary">View All Reservations</a>
                        <% } else { %>
                            <p>Get started by creating your first reservation.</p>
                            <a href="<%= request.getContextPath() %>/reservation?action=new" class="btn-primary">
                                Create New Reservation
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>