<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px 30px;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .header-left {
        display: flex;
        align-items: center;
    }

    .header-left h1 {
        font-size: 1.5em;
        font-weight: 600;
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .user-avatar {
        width: 35px;
        height: 35px;
        background-color: rgba(255,255,255,0.3);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }

    .logout-btn {
        padding: 8px 20px;
        background-color: rgba(255,255,255,0.2);
        color: white;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 6px;
        cursor: pointer;
        text-decoration: none;
        font-weight: 600;
        transition: background-color 0.3s;
    }

    .logout-btn:hover {
        background-color: rgba(255,255,255,0.3);
    }

    body {
        padding-top: 70px;
    }
</style>

<div class="header">
    <div class="header-left">
        <h1>🏖️ Ocean View Resort</h1>
    </div>
    <div class="header-right">
        <div class="user-info">
            <div class="user-avatar">
                <%= session.getAttribute("fullName").toString().substring(0, 1).toUpperCase() %>
            </div>
            <div>
                <div style="font-weight: 600;"><%= session.getAttribute("fullName") %></div>
                <div style="font-size: 0.85em; opacity: 0.8;"><%= session.getAttribute("role") %></div>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
    </div>
</div>