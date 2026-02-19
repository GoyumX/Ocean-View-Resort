package com.oceanview.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class Reservation implements Serializable {
    private static final long serialVersionUID = 1L;

    private String reservationNumber;
    private String guestName;
    private String address;
    private String contactNumber;
    private String roomType;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private String email;
    private int numberOfGuests;
    private double totalAmount;
    private String status; // CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED States

    // Room Details sets Lankaweee
    public static final double SINGLE_ROOM_RATE = 5000.00;
    public static final double DOUBLE_ROOM_RATE = 8000.00;
    public static final double DELUXE_ROOM_RATE = 12000.00;
    public static final double SUITE_ROOM_RATE = 20000.00;

    // Constructor
    public Reservation() {
        this.status = "CONFIRMED";
    }

    // Parameterized constructor
    public Reservation(String reservationNumber, String guestName, String address,
                       String contactNumber, String roomType, LocalDate checkInDate,
                       LocalDate checkOutDate, String email, int numberOfGuests) {
        this.reservationNumber = reservationNumber;
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.roomType = roomType;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.email = email;
        this.numberOfGuests = numberOfGuests;
        this.status = "CONFIRMED";
        this.totalAmount = calculateTotalAmount();
    }

    // Calculate total amount based on room type and duration
    public double calculateTotalAmount() {
        long nights = ChronoUnit.DAYS.between(checkInDate, checkOutDate);
        double ratePerNight = getRoomRate(roomType);
        return nights * ratePerNight;
    }

    // Get room rate based on room type
    public static double getRoomRate(String roomType) {
        switch (roomType.toUpperCase()) {
            case "SINGLE":
                return SINGLE_ROOM_RATE;
            case "DOUBLE":
                return DOUBLE_ROOM_RATE;
            case "DELUXE":
                return DELUXE_ROOM_RATE;
            case "SUITE":
                return SUITE_ROOM_RATE;
            default:
                return SINGLE_ROOM_RATE;
        }
    }

    public long getNumberOfNights() {
        return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }

    // Getters and Setters
    public String getReservationNumber() {
        return reservationNumber;
    }

    public void setReservationNumber(String reservationNumber) {
        this.reservationNumber = reservationNumber;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Inorder to get the dates to save and track
    public String getFormattedCheckInDate() {
        return checkInDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getFormattedCheckOutDate() {
        return checkOutDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "reservationNumber='" + reservationNumber + '\'' +
                ", guestName='" + guestName + '\'' +
                ", roomType='" + roomType + '\'' +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", status='" + status + '\'' +
                '}';
    }
}