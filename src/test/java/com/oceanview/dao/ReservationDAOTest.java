package com.oceanview.dao;

import com.oceanview.model.Reservation;
import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import java.time.LocalDate;
import java.util.List;

import static org.junit.Assert.*;

/**
 * Unit tests for ReservationDAO
 */
public class ReservationDAOTest {

    private ReservationDAO reservationDAO;
    private Reservation testReservation;

    @Before
    public void setUp() {
        // This runs before each test
        reservationDAO = new ReservationDAO();

        // Create a test reservation
        testReservation = new Reservation(
                "OVR9999",
                "Test Guest",
                "123 Test Street",
                "0771234567",
                "DOUBLE",
                LocalDate.now().plusDays(1),
                LocalDate.now().plusDays(3),
                "test@email.com",
                2
        );
    }

    @After
    public void tearDown() {
        // Clean up after each test
        if (testReservation != null) {
            reservationDAO.deleteReservation("OVR9999");
        }
    }

    @Test
    public void testGenerateReservationNumber() {
        String reservationNumber = reservationDAO.generateReservationNumber();

        assertNotNull("Reservation number should not be null", reservationNumber);
        assertTrue("Reservation number should start with OVR",
                reservationNumber.startsWith("OVR"));
        assertEquals("Reservation number should be 7 characters",
                7, reservationNumber.length());
    }

    @Test
    public void testAddReservation() {
        boolean result = reservationDAO.addReservation(testReservation);

        assertTrue("Reservation should be added successfully", result);
    }

    @Test
    public void testGetReservation() {
        // First add the reservation
        reservationDAO.addReservation(testReservation);

        // Then retrieve it
        Reservation retrieved = reservationDAO.getReservation("OVR9999");

        assertNotNull("Retrieved reservation should not be null", retrieved);
        assertEquals("Guest names should match",
                "Test Guest", retrieved.getGuestName());
        assertEquals("Room types should match",
                "DOUBLE", retrieved.getRoomType());
    }

    @Test
    public void testUpdateReservation() {
        // Add reservation
        reservationDAO.addReservation(testReservation);

        // Modify it
        testReservation.setGuestName("Updated Guest");
        testReservation.setRoomType("SUITE");

        // Update
        boolean result = reservationDAO.updateReservation(testReservation);

        assertTrue("Reservation should be updated successfully", result);

        // Verify
        Reservation updated = reservationDAO.getReservation("OVR9999");
        assertEquals("Guest name should be updated",
                "Updated Guest", updated.getGuestName());
        assertEquals("Room type should be updated",
                "SUITE", updated.getRoomType());
    }

    @Test
    public void testDeleteReservation() {
        // Add reservation
        reservationDAO.addReservation(testReservation);

        // Delete it
        boolean result = reservationDAO.deleteReservation("OVR9999");

        assertTrue("Reservation should be deleted successfully", result);

        // Verify it's gone
        Reservation deleted = reservationDAO.getReservation("OVR9999");
        assertNull("Deleted reservation should not be found", deleted);
    }

    @Test
    public void testSearchByGuestName() {
        // Add test reservation
        reservationDAO.addReservation(testReservation);

        // Search for it
        List<Reservation> results = reservationDAO.searchByGuestName("Test");

        assertNotNull("Search results should not be null", results);
        assertTrue("Should find at least one result", results.size() > 0);

        // Verify the result contains our test reservation
        boolean found = false;
        for (Reservation r : results) {
            if ("OVR9999".equals(r.getReservationNumber())) {
                found = true;
                break;
            }
        }
        assertTrue("Should find the test reservation", found);
    }

    @Test
    public void testGetAllReservations() {
        // Add test reservation
        reservationDAO.addReservation(testReservation);

        // Get all
        List<Reservation> all = reservationDAO.getAllReservations();

        assertNotNull("Reservation list should not be null", all);
        assertTrue("Should have at least one reservation", all.size() > 0);
    }


}