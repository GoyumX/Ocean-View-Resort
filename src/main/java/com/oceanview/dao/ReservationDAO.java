package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReservationDAO {
    private static final String DATA_FILE = "reservations.txt";
    private static final String DELIMITER = "\\|";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private final String dataFilePath;
    private static final Logger LOGGER = Logger.getLogger(ReservationDAO.class.getName());


    public ReservationDAO(String dataDirectory) {
        this.dataFilePath = dataDirectory + File.separator + DATA_FILE;
        initializeDataFile();
    }

    // Initialize data file if it doesn't exist
    private void initializeDataFile() {
        File file = new File(dataFilePath);
        File parentDir = file.getParentFile();

        if (parentDir != null && !parentDir.exists()) {
            if (!parentDir.mkdirs()) {
                LOGGER.warning("Failed to create directory: " + parentDir.getAbsolutePath());
            }
        }

        if (!file.exists()) {
            try {
                if (!file.createNewFile()) {
                    LOGGER.warning("Failed to create file: " + file.getAbsolutePath());
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error creating data file", e);
            }
        }
    }

    public synchronized String generateReservationNumber() {
        String prefix = "OVR";
        int maxNumber = 0;

        List<Reservation> reservations = getAllReservations();
        for (Reservation res : reservations) {
            String resNum = res.getReservationNumber();
            if (resNum.startsWith(prefix)) {
                try {
                    int num = Integer.parseInt(resNum.substring(prefix.length()));
                    if (num > maxNumber) {
                        maxNumber = num;
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid numbers
                }
            }
        }

        return String.format("%s%04d", prefix, maxNumber + 1);
    }

    // Add new reservation
    public boolean addReservation(Reservation reservation) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath, true))) {
            String line = reservationToString(reservation);
            writer.write(line);
            writer.newLine();
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error adding reservation", e);
            return false;
        }
    }

    // Get reservation by reservation number
    public Reservation getReservation(String reservationNumber) {
        List<Reservation> reservations = getAllReservations();
        for (Reservation res : reservations) {
            if (res.getReservationNumber().equalsIgnoreCase(reservationNumber)) {
                return res;
            }
        }
        return null;
    }

    // Get all reservations
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(dataFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Reservation reservation = stringToReservation(line);
                    if (reservation != null) {
                        reservations.add(reservation);
                    }
                }
            }
        } catch (FileNotFoundException e) {
            // File doesn't exist yet, return empty list
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading reservations", e);
        }

        return reservations;
    }

    // Update reservation
    public boolean updateReservation(Reservation updatedReservation) {
        List<Reservation> reservations = getAllReservations();
        boolean found = false;

        for (int i = 0; i < reservations.size(); i++) {
            if (reservations.get(i).getReservationNumber()
                    .equalsIgnoreCase(updatedReservation.getReservationNumber())) {
                reservations.set(i, updatedReservation);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllReservations(reservations);
        }
        return false;
    }

    // Delete reservation
    public boolean deleteReservation(String reservationNumber) {
        List<Reservation> reservations = getAllReservations();
        boolean removed = reservations.removeIf(res ->
                res.getReservationNumber().equalsIgnoreCase(reservationNumber));

        if (removed) {
            return saveAllReservations(reservations);
        }
        return false;
    }

    // Search reservations by guest name
    public List<Reservation> searchByGuestName(String guestName) {
        List<Reservation> results = new ArrayList<>();
        List<Reservation> allReservations = getAllReservations();

        for (Reservation res : allReservations) {
            if (res.getGuestName().toLowerCase().contains(guestName.toLowerCase())) {
                results.add(res);
            }
        }

        return results;
    }

    // Get active reservations (checked dayyyy)
    public List<Reservation> getActiveReservations() {
        List<Reservation> results = new ArrayList<>();
        List<Reservation> allReservations = getAllReservations();
        LocalDate today = LocalDate.now();

        for (Reservation res : allReservations) {
            if (res.getStatus().equals("CHECKED_IN") ||
                    (res.getStatus().equals("CONFIRMED") &&
                            !res.getCheckInDate().isAfter(today) &&
                            !res.getCheckOutDate().isBefore(today))) {
                results.add(res);
            }
        }

        return results;
    }

    private String reservationToString(Reservation res) {
        return String.join("|",
                res.getReservationNumber(),
                res.getGuestName(),
                res.getAddress(),
                res.getContactNumber(),
                res.getRoomType(),
                res.getCheckInDate().format(DATE_FORMATTER),
                res.getCheckOutDate().format(DATE_FORMATTER),
                res.getEmail() != null ? res.getEmail() : "",
                String.valueOf(res.getNumberOfGuests()),
                String.valueOf(res.getTotalAmount()),
                res.getStatus()
        );
    }

    private Reservation stringToReservation(String line) {
        try {
            String[] parts = line.split(DELIMITER);
            if (parts.length >= 11) {
                Reservation res = new Reservation();
                res.setReservationNumber(parts[0]);
                res.setGuestName(parts[1]);
                res.setAddress(parts[2]);
                res.setContactNumber(parts[3]);
                res.setRoomType(parts[4]);
                res.setCheckInDate(LocalDate.parse(parts[5], DATE_FORMATTER));
                res.setCheckOutDate(LocalDate.parse(parts[6], DATE_FORMATTER));
                res.setEmail(parts[7].isEmpty() ? null : parts[7]);
                res.setNumberOfGuests(Integer.parseInt(parts[8]));
                res.setTotalAmount(Double.parseDouble(parts[9]));
                res.setStatus(parts[10]);
                return res;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error parsing reservation from string", e);
        }
        return null;
    }

    private boolean saveAllReservations(List<Reservation> reservations) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
            for (Reservation res : reservations) {
                writer.write(reservationToString(res));
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving all reservations", e);
            return false;
        }
    }

    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        List<Reservation> allReservations = getAllReservations();

        int totalReservations = allReservations.size();
        int activeReservations = 0;
        int confirmedReservations = 0;
        int checkedOutReservations = 0;
        int cancelledReservations = 0;
        double totalRevenue = 0;

        for (Reservation res : allReservations) {
            switch (res.getStatus()) {
                case "CHECKED_IN":
                    activeReservations++;
                    break;
                case "CONFIRMED":
                    confirmedReservations++;
                    break;
                case "CHECKED_OUT":
                    checkedOutReservations++;
                    totalRevenue += res.getTotalAmount();
                    break;
                case "CANCELLED":
                    cancelledReservations++;
                    break;
            }
        }

        stats.put("totalReservations", totalReservations);
        stats.put("activeReservations", activeReservations);
        stats.put("confirmedReservations", confirmedReservations);
        stats.put("checkedOutReservations", checkedOutReservations);
        stats.put("cancelledReservations", cancelledReservations);
        stats.put("totalRevenue", totalRevenue);

        return stats;
    }
}