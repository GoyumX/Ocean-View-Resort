package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DatabaseConfig;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class ReservationDAO {

    public synchronized String generateReservationNumber() {
        String sql = "SELECT reservation_number FROM reservations " +
                "WHERE reservation_number LIKE 'OVR%' " +
                "ORDER BY id DESC LIMIT 1";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                String lastNumber = rs.getString("reservation_number");
                int number = Integer.parseInt(lastNumber.substring(3)) + 1;
                return String.format("OVR%04d", number);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "OVR0001"; // First reservation
    }

    public boolean addReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations " +
                "(reservation_number, guest_name, address, contact_number, room_type, " +
                "check_in_date, check_out_date, email, number_of_guests, total_amount, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getReservationNumber());
            pstmt.setString(2, reservation.getGuestName());
            pstmt.setString(3, reservation.getAddress());
            pstmt.setString(4, reservation.getContactNumber());
            pstmt.setString(5, reservation.getRoomType());
            pstmt.setDate(6, Date.valueOf(reservation.getCheckInDate()));
            pstmt.setDate(7, Date.valueOf(reservation.getCheckOutDate()));
            pstmt.setString(8, reservation.getEmail());
            pstmt.setInt(9, reservation.getNumberOfGuests());
            pstmt.setDouble(10, reservation.getTotalAmount());
            pstmt.setString(11, reservation.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    //Get reservation by reservation number
    public Reservation getReservation(String reservationNumber) {
        String sql = "SELECT * FROM reservations WHERE reservation_number = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservationNumber);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractReservationFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

     //Get all reservations
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY created_at DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reservations.add(extractReservationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reservations;
    }

    // Update reservation
    public boolean updateReservation(Reservation reservation) {
        String sql = "UPDATE reservations SET " +
                "guest_name = ?, address = ?, contact_number = ?, room_type = ?, " +
                "check_in_date = ?, check_out_date = ?, email = ?, number_of_guests = ?, " +
                "total_amount = ?, status = ? " +
                "WHERE reservation_number = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getGuestName());
            pstmt.setString(2, reservation.getAddress());
            pstmt.setString(3, reservation.getContactNumber());
            pstmt.setString(4, reservation.getRoomType());
            pstmt.setDate(5, Date.valueOf(reservation.getCheckInDate()));
            pstmt.setDate(6, Date.valueOf(reservation.getCheckOutDate()));
            pstmt.setString(7, reservation.getEmail());
            pstmt.setInt(8, reservation.getNumberOfGuests());
            pstmt.setDouble(9, reservation.getTotalAmount());
            pstmt.setString(10, reservation.getStatus());
            pstmt.setString(11, reservation.getReservationNumber());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

     //Delete reservation

    public boolean deleteReservation(String reservationNumber) {
        String sql = "DELETE FROM reservations WHERE reservation_number = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservationNumber);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search reservations by guest name

    public List<Reservation> searchByGuestName(String guestName) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE guest_name LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + guestName + "%");

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reservations;
    }

    // Get reservations by date range

    public List<Reservation> getReservationsByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations " +
                "WHERE check_in_date >= ? AND check_out_date <= ? " +
                "ORDER BY check_in_date";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, Date.valueOf(startDate));
            pstmt.setDate(2, Date.valueOf(endDate));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservationFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reservations;
    }

    //Get active reservations
    public List<Reservation> getActiveReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations " +
                "WHERE status IN ('CONFIRMED', 'CHECKED_IN') " +
                "AND check_out_date >= CURDATE() " +
                "ORDER BY check_in_date";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reservations.add(extractReservationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reservations;
    }

    //Get statistics for dashboard
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();

        try (Connection conn = DatabaseConfig.getConnection()) {

            // Total reservations
            String sql1 = "SELECT COUNT(*) as total FROM reservations";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql1)) {
                if (rs.next()) {
                    stats.put("totalReservations", rs.getInt("total"));
                }
            }

            // Active reservations
            String sql2 = "SELECT COUNT(*) as active FROM reservations WHERE status = 'CHECKED_IN'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql2)) {
                if (rs.next()) {
                    stats.put("activeReservations", rs.getInt("active"));
                }
            }

            // Confirmed reservations
            String sql3 = "SELECT COUNT(*) as confirmed FROM reservations WHERE status = 'CONFIRMED'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql3)) {
                if (rs.next()) {
                    stats.put("confirmedReservations", rs.getInt("confirmed"));
                }
            }

            // Checked out reservations
            String sql4 = "SELECT COUNT(*) as checkedOut FROM reservations WHERE status = 'CHECKED_OUT'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql4)) {
                if (rs.next()) {
                    stats.put("checkedOutReservations", rs.getInt("checkedOut"));
                }
            }

            // Cancelled reservations
            String sql5 = "SELECT COUNT(*) as cancelled FROM reservations WHERE status = 'CANCELLED'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql5)) {
                if (rs.next()) {
                    stats.put("cancelledReservations", rs.getInt("cancelled"));
                }
            }

            // Total revenue
            String sql6 = "SELECT SUM(total_amount) as revenue FROM reservations WHERE status = 'CHECKED_OUT'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql6)) {
                if (rs.next()) {
                    double revenue = rs.getDouble("revenue");
                    stats.put("totalRevenue", revenue);
                } else {
                    stats.put("totalRevenue", 0.0);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            stats.put("totalReservations", 0);
            stats.put("activeReservations", 0);
            stats.put("confirmedReservations", 0);
            stats.put("checkedOutReservations", 0);
            stats.put("cancelledReservations", 0);
            stats.put("totalRevenue", 0.0);
        }

        return stats;
    }

    //Extract Reservation object from ResultSet
    private Reservation extractReservationFromResultSet(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationNumber(rs.getString("reservation_number"));
        reservation.setGuestName(rs.getString("guest_name"));
        reservation.setAddress(rs.getString("address"));
        reservation.setContactNumber(rs.getString("contact_number"));
        reservation.setRoomType(rs.getString("room_type"));
        reservation.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        reservation.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        reservation.setEmail(rs.getString("email"));
        reservation.setNumberOfGuests(rs.getInt("number_of_guests"));
        reservation.setTotalAmount(rs.getDouble("total_amount"));
        reservation.setStatus(rs.getString("status"));
        return reservation;
    }
}