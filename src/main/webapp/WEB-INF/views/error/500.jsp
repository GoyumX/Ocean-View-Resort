<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
        }
        h1 {
            font-size: 6em;
            margin: 0;
            color: #dc3545;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        p {
            color: #666;
            margin-bottom: 30px;
        }
        .btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
        }
        .error-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            margin-bottom: 20px;
            font-family: monospace;
            font-size: 0.9em;
            color: #dc3545;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <h2>Internal Server Error</h2>
        <p>Something went wrong on our end. Please try again later or contact support.</p>

        <% if (request.getAttribute("javax.servlet.error.exception") != null) { %>
            <div class="error-details">
                <%= request.getAttribute("javax.servlet.error.exception") %>
            </div>
        <% } %>

        <a href="<%= request.getContextPath() %>/dashboard" class="btn">Go to Dashboard</a>
    </div>
</body>
</html>