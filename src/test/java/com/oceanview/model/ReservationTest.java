package com.oceanview.model;

import org.junit.Before;
import org.junit.Test;

import java.time.LocalDate;

import static org.junit.Assert.*;

/**
 * Unit tests for Reservation model
 */
public class ReservationTest {

    private Reservation reservation;

    @Before
    public void setUp() {
        reservation = new Reservation(
                "OVR0001",
                "John Doe",
                "123 Main St",
                "0771234567",
                "DOUBLE",
                LocalDate.of(2024, 3, 1),
                LocalDate.of(2024, 3, 3),
                "john@email.com",
                2
        );
    }

    @Test
    public void testCalculateTotalAmount() {
        double total = reservation.calculateTotalAmount();

        // DOUBLE room is 8000 per night, 2 nights = 16000
        assertEquals("Total should be 16000", 16000.0, total, 0.01);
    }

    @Test
    public void testGetNumberOfNights() {
        long nights = reservation.getNumberOfNights();

        assertEquals("Should be 2 nights", 2, nights);
    }

    @Test
    public void testGetRoomRate() {
        assertEquals("SINGLE rate should be 5000",
                5000.0, Reservation.getRoomRate("SINGLE"), 0.01);
        assertEquals("DOUBLE rate should be 8000",
                8000.0, Reservation.getRoomRate("DOUBLE"), 0.01);
        assertEquals("DELUXE rate should be 12000",
                12000.0, Reservation.getRoomRate("DELUXE"), 0.01);
        assertEquals("SUITE rate should be 20000",
                20000.0, Reservation.getRoomRate("SUITE"), 0.01);
    }

    @Test
    public void testSingleRoomCalculation() {
        reservation.setRoomType("SINGLE");
        double total = reservation.calculateTotalAmount();

        // SINGLE room is 5000 per night, 2 nights = 10000
        assertEquals("Total should be 10000", 10000.0, total, 0.01);
    }

    @Test
    public void testSuiteRoomCalculation() {
        reservation.setRoomType("SUITE");
        reservation.setCheckInDate(LocalDate.of(2024, 3, 1));
        reservation.setCheckOutDate(LocalDate.of(2024, 3, 6));

        double total = reservation.calculateTotalAmount();

        // SUITE room is 20000 per night, 5 nights = 100000
        assertEquals("Total should be 100000", 100000.0, total, 0.01);
    }

    @Test
    public void testFormattedDates() {
        String checkIn = reservation.getFormattedCheckInDate();
        String checkOut = reservation.getFormattedCheckOutDate();

        assertEquals("Check-in should be 2024-03-01", "2024-03-01", checkIn);
        assertEquals("Check-out should be 2024-03-03", "2024-03-03", checkOut);
    }

    @Test
    public void testDefaultStatus() {
        Reservation newRes = new Reservation();
        assertEquals("Default status should be CONFIRMED",
                "CONFIRMED", newRes.getStatus());
    }
}