<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .sidebar {
        width: 260px;
        background-color: white;
        height: 100vh;
        position: fixed;
        top: 70px;
        left: 0;
        box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        padding: 20px 0;
        z-index: 900;
    }

    .nav-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .nav-item {
        margin-bottom: 5px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 15px 30px;
        color: #666;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s;
        border-left: 4px solid transparent;
    }

    .nav-link:hover, .nav-link.active {
        background-color: #f8f9fa;
        color: #667eea;
        border-left-color: #667eea;
    }

    .nav-icon {
        margin-right: 15px;
        font-size: 1.2em;
        width: 25px;
        text-align: center;
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s;
        }

        .sidebar.active {
            transform: translateX(0);
        }
    }
</style>

<%
    String currentPath = request.getServletPath();
    String action = request.getParameter("action");
%>

<div class="sidebar">
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/dashboard"
               class="nav-link <%= currentPath.contains("dashboard") ? "active" : "" %>">
                <span class="nav-icon">📊</span>
                Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/reservation"
               class="nav-link <%= currentPath.contains("reservation") && (action == null || action.equals("list") || action.equals("search")) ? "active" : "" %>">
                <span class="nav-icon">📅</span>
                Reservations
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/reservation?action=new"
               class="nav-link <%= "new".equals(action) ? "active" : "" %>">
                <span class="nav-icon">➕</span>
                New Reservation
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/help"
               class="nav-link <%= currentPath.contains("help") ? "active" : "" %>">
                <span class="nav-icon">❓</span>
                Help & Support
            </a>
        </li>
    </ul>
</div>