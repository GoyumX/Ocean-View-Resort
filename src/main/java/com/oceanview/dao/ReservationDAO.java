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

}