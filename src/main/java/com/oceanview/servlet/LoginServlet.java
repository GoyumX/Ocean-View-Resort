package com.oceanview.servlet;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        String dataDirectory = getServletContext().getRealPath("/WEB-INF/data");
        if (dataDirectory == null) {
            dataDirectory = System.getProperty("java.io.tmpdir") + java.io.File.separator + "OceanViewResort_data";
        }
        userDAO = new UserDAO(dataDirectory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username != null) username = username.trim();
        if (password != null) password = password.trim();

        // Validate input (If some things may be empty)
        if (username == null || username.isEmpty() ||
                password == null || password.isEmpty()) {
            request.setAttribute("error", "Please enter both username and password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = userDAO.authenticate(username, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}