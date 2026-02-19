<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.oceanview.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <style>
        <%@ include file="/WEB-INF/views/styles/common.css" %>

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }

        .stat-card h3 {
            color: #666;
            font-size: 0.9em;
            font-weight: 600;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .stat-value {
            font-size: 2.5em;
            font-weight: bold;
            color: #333;
        }

        .stat-card.revenue {
            border-left-color: #10b981;
        }

        .stat-card.active {
            border-left-color: #f59e0b;
        }

        .stat-card.confirmed {
            border-left-color: #3b82f6;
        }

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
        }

        .table-header h2 {
            color: #333;
            font-size: 1.5em;
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

        .btn-view {
            padding: 6px 15px;
            background-color: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9em;
        }

        .btn-view:hover {
            background-color: #5568d3;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .empty-state p {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="main-container">
        <%@ include file="/WEB-INF/views/includes/sidebar.jsp" %>

        <div class="content">
            <div class="page-header">
                <h1>Dashboard</h1>
                <p>Welcome, <%= session.getAttribute("fullName") %>!</p>
            </div>

            <%
                Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
                int totalReservations = (Integer) stats.get("totalReservations");
                int activeReservations = (Integer) stats.get("activeReservations");
                int confirmedReservations = (Integer) stats.get("confirmedReservations");
                int checkedOutReservations = (Integer) stats.get("checkedOutReservations");
                double totalRevenue = (Double) stats.get("totalRevenue");
            %>

            <div class="stats-container">
                <div class="stat-card">
                    <h3>Total Reservations</h3>
                    <div class="stat-value"><%= totalReservations %></div>
                </div>

                <div class="stat-card active">
                    <h3>Active Reservations</h3>
                    <div class="stat-value"><%= activeReservations %></div>
                </div>

                <div class="stat-card confirmed">
                    <h3>Confirmed</h3>
                    <div class="stat-value"><%= confirmedReservations %></div>
                </div>

                <div class="stat-card revenue">
                    <h3>Total Revenue</h3>
                    <div class="stat-value">LKR <%= String.format("%,.2f", totalRevenue) %></div>
                </div>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <h2>Active Reservations</h2>
                    <a href="<%= request.getContextPath() %>/reservation?action=new" class="btn-primary">
                        + New Reservation
                    </a>
                </div>

                <%
                    List<Reservation> activeResList = (List<Reservation>) request.getAttribute("activeReservations");
                    if (activeResList != null && !activeResList.isEmpty()) {
                %>
                    <table>
                        <thead>
                            <tr>
                                <th>Reservation #</th>
                                <th>Guest Name</th>
                                <th>Room Type</th>
                                <th>Check-In</th>
                                <th>Check-Out</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reservation res : activeResList) { %>
                                <tr>
                                    <td><%= res.getReservationNumber() %></td>
                                    <td><%= res.getGuestName() %></td>
                                    <td><%= res.getRoomType() %></td>
                                    <td><%= res.getFormattedCheckInDate() %></td>
                                    <td><%= res.getFormattedCheckOutDate() %></td>
                                    <td>
                                        <span class="status-badge status-<%= res.getStatus().toLowerCase().replace("_", "-") %>">
                                            <%= res.getStatus().replace("_", " ") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/reservation?action=view&id=<%= res.getReservationNumber() %>"
                                           class="btn-view">View</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <p>No active reservations at the moment.</p>
                        <a href="<%= request.getContextPath() %>/reservation?action=new" class="btn-primary">
                            Create New Reservation
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>