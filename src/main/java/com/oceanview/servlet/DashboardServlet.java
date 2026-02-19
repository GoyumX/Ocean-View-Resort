package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class DashboardServlet extends HttpServlet {
    private ReservationDAO reservationDAO;

    @Override
    public void init() throws ServletException {
        String dataDirectory = getServletContext().getRealPath("/WEB-INF/data");
        reservationDAO = new ReservationDAO(dataDirectory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get statistics
        Map<String, Object> stats = reservationDAO.getStatistics();
        request.setAttribute("stats", stats);

        // Get active reservations
        List<Reservation> activeReservations = reservationDAO.getActiveReservations();
        request.setAttribute("activeReservations", activeReservations);

        // Forward to dashboard page
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}