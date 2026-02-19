package com.oceanview.servlet;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;

    @Override
    public void init() throws ServletException {
        String dataDirectory = getServletContext().getRealPath("/WEB-INF/data");
        if (dataDirectory == null) {

            // Fallback
            dataDirectory = System.getProperty("java.io.tmpdir");
            System.err.println("Warning: Could not get real path for /WEB-INF/data. Using temp directory: " + dataDirectory);
        }
        reservationDAO = new ReservationDAO(dataDirectory);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        } // auth check !! before for security

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewReservationForm(request, response);
                break;
            case "view":
                viewReservation(request, response);
                break;
            case "edit":
                showEditReservationForm(request, response);
                break;
            case "delete":
                deleteReservation(request, response);
                break;
            case "search":
                searchReservations(request, response);
                break;
            case "bill":
                generateBill(request, response);
                break;
            default:
                listReservations(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addReservation(request, response);
        } else if ("update".equals(action)) {
            updateReservation(request, response);
        } else if ("updateStatus".equals(action)) {
            updateReservationStatus(request, response);
        }
    }

    // Show new reservation
    private void showNewReservationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Generate new reservation number
        String reservationNumber = reservationDAO.generateReservationNumber();
        request.setAttribute("reservationNumber", reservationNumber);
        request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
    }

    // Add new reservation
    private void addReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String reservationNumber = request.getParameter("reservationNumber");
            String guestName = request.getParameter("guestName");
            String address = request.getParameter("address");
            String contactNumber = request.getParameter("contactNumber");
            String email = request.getParameter("email");
            String roomType = request.getParameter("roomType");
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));

            // Parse dates Have to be in a specific structure
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate checkInDate = LocalDate.parse(checkInDateStr, formatter);
            LocalDate checkOutDate = LocalDate.parse(checkOutDateStr, formatter);

            // Validate
            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                request.setAttribute("error", "Check-out date must be after check-in date");
                request.setAttribute("reservationNumber", reservationNumber);
                fillFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
                return;
            }

            // Create
            Reservation reservation = new Reservation(
                    reservationNumber, guestName, address, contactNumber,
                    roomType, checkInDate, checkOutDate, email, numberOfGuests
            );

            // Save
            if (reservationDAO.addReservation(reservation)) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationNumber + "&success=added");
            } else {
                request.setAttribute("error", "Failed to add reservation");
                request.setAttribute("reservationNumber", reservationNumber);
                fillFormData(request);
                request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            fillFormData(request);
            request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
        }
    }
    private void viewReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNumber = request.getParameter("id");
        Reservation reservation = reservationDAO.getReservation(reservationNumber);

        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/reservation-detail.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Reservation not found");
            listReservations(request, response);
        }
    }

    // Show edit reservation
    private void showEditReservationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNumber = request.getParameter("id");
        Reservation reservation = reservationDAO.getReservation(reservationNumber);

        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            request.setAttribute("edit", true);
            request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Reservation not found");
            listReservations(request, response);
        }
    }

    // Update
    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String reservationNumber = request.getParameter("reservationNumber");
            Reservation reservation = reservationDAO.getReservation(reservationNumber);

            if (reservation != null) {
                // Update fields
                reservation.setGuestName(request.getParameter("guestName"));
                reservation.setAddress(request.getParameter("address"));
                reservation.setContactNumber(request.getParameter("contactNumber"));
                reservation.setEmail(request.getParameter("email"));
                reservation.setRoomType(request.getParameter("roomType"));
                reservation.setNumberOfGuests(Integer.parseInt(request.getParameter("numberOfGuests")));

                // Parse and validate dates
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"), formatter);
                LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"), formatter);

                if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                    request.setAttribute("error", "Check-out date must be after check-in date");
                    request.setAttribute("reservation", reservation);
                    request.setAttribute("edit", true);
                    request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
                    return;
                }

                reservation.setCheckInDate(checkInDate);
                reservation.setCheckOutDate(checkOutDate);
                reservation.setTotalAmount(reservation.calculateTotalAmount());

                if (reservationDAO.updateReservation(reservation)) {
                    response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationNumber + "&success=updated");
                } else {
                    request.setAttribute("error", "Failed to update reservation");
                    request.setAttribute("reservation", reservation);
                    request.setAttribute("edit", true);
                    request.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Reservation not found");
                listReservations(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            listReservations(request, response);
        }
    }

    // Delete reservation
    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNumber = request.getParameter("id");

        if (reservationDAO.deleteReservation(reservationNumber)) {
            response.sendRedirect(request.getContextPath() + "/reservation?success=deleted");
        } else {
            request.setAttribute("error", "Failed to delete reservation");
            listReservations(request, response);
        }
    }

    // List all reservations
    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Reservation> reservations = reservationDAO.getAllReservations();
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("/WEB-INF/views/reservation-list.jsp").forward(request, response);
    }

    // Search reservations
    private void searchReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchQuery = request.getParameter("query");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            List<Reservation> results = reservationDAO.searchByGuestName(searchQuery);
            request.setAttribute("reservations", results);
            request.setAttribute("searchQuery", searchQuery);
        } else {
            List<Reservation> reservations = reservationDAO.getAllReservations();
            request.setAttribute("reservations", reservations);
        }

        request.getRequestDispatcher("/WEB-INF/views/reservation-list.jsp").forward(request, response);
    }

    // Generate bill
    private void generateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNumber = request.getParameter("id");
        Reservation reservation = reservationDAO.getReservation(reservationNumber);

        if (reservation != null) {
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/WEB-INF/views/bill.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Reservation not found");
            listReservations(request, response);
        }
    }

    // Update reservation status
    private void updateReservationStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationNumber = request.getParameter("reservationNumber");
        String status = request.getParameter("status");

        Reservation reservation = reservationDAO.getReservation(reservationNumber);
        if (reservation != null) {
            reservation.setStatus(status);
            if (reservationDAO.updateReservation(reservation)) {
                response.sendRedirect(request.getContextPath() + "/reservation?action=view&id=" + reservationNumber + "&success=statusUpdated");
            } else {
                request.setAttribute("error", "Failed to update status");
                viewReservation(request, response);
            }
        } else {
            request.setAttribute("error", "Reservation not found");
            listReservations(request, response);
        }
    }

    // a Method to fill data from a req
    private void fillFormData(HttpServletRequest request) {
        request.setAttribute("guestName", request.getParameter("guestName"));
        request.setAttribute("address", request.getParameter("address"));
        request.setAttribute("contactNumber", request.getParameter("contactNumber"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("roomType", request.getParameter("roomType"));
        request.setAttribute("checkInDate", request.getParameter("checkInDate"));
        request.setAttribute("checkOutDate", request.getParameter("checkOutDate"));
        request.setAttribute("numberOfGuests", request.getParameter("numberOfGuests"));
    }
}