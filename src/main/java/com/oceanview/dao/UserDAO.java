package com.oceanview.dao;

import com.oceanview.model.User;
import java.io.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final String DATA_FILE = "users.txt";
    private static final String DELIMITER = "\\|";
    private final String dataFilePath;
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // Replace later for a proper database
    public UserDAO(String dataDirectory) {
        this.dataFilePath = dataDirectory + File.separator + DATA_FILE;
        initializeDataFile();
    }

    // Initialize data file with the admin locca
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
                if (file.createNewFile()) {
                    // Create default admin
                    createDefaultUsers();
                } else {
                    LOGGER.warning("Failed to create file: " + file.getAbsolutePath());
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error creating data file", e);
            }
        } else if (file.length() == 0) {
            createDefaultUsers();
        }
    }

    // Create  admin if its empty
    // other wise no one can log in nehhhhhhhh
    private void createDefaultUsers() {
        List<User> defaultUsers = new ArrayList<>();
        defaultUsers.add(new User("admin", "admin123", "System Administrator", "ADMIN", "admin@oceanview.com"));
        for (User user : defaultUsers) {
            addUser(user);
        }
    }

    // Authenticate user details
    public User authenticate(String username, String password) {
        List<User> users = getAllUsers();
        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }

    // Add new user
    public boolean addUser(User user) {
        // Check if username already exists
        if (getUserByUsername(user.getUsername()) != null) {
            return false;
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath, true))) {
            String line = userToString(user);
            writer.write(line);
            writer.newLine();
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error adding user", e);
            return false;
        }
    }

    // Get user by username
    public User getUserByUsername(String username) {
        List<User> users = getAllUsers();
        for (User user : users) {
            if (user.getUsername().equalsIgnoreCase(username)) {
                return user;
            }
        }
        return null;
    }

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(dataFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    User user = stringToUser(line);
                    if (user != null) {
                        users.add(user);
                    }
                }
            }
        } catch (FileNotFoundException e) {
            // File doesn't exist yet, return empty list
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading users", e);
        }

        return users;
    }

    // Update user
    public boolean updateUser(User updatedUser) {
        List<User> users = getAllUsers();
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUsername().equalsIgnoreCase(updatedUser.getUsername())) {
                users.set(i, updatedUser);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllUsers(users);
        }
        return false;
    }

    // Delete user
    public boolean deleteUser(String username) {
        List<User> users = getAllUsers();
        boolean removed = users.removeIf(user ->
                user.getUsername().equalsIgnoreCase(username));

        if (removed) {
            return saveAllUsers(users);
        }
        return false;
    }

    // Change password
    public boolean changePassword(String username, String oldPassword, String newPassword) {
        User user = authenticate(username, oldPassword);
        if (user != null) {
            user.setPassword(newPassword);
            return updateUser(user);
        }
        return false;
    }

    // Convert User object to string for file storage
    private String userToString(User user) {
        return String.join("|",
                user.getUsername(),
                user.getPassword(),
                user.getFullName(),
                user.getRole(),
                user.getEmail() != null ? user.getEmail() : ""
        );
    }

    // Convert string to User object
    private User stringToUser(String line) {
        try {
            line = line.trim();
            if (line.isEmpty()) return null;
            // Remove BOM if present (can appear when file is UTF-8 saved by some editors)
            if (line.startsWith("\uFEFF")) line = line.substring(1);
            String[] parts = line.split(DELIMITER);
            if (parts.length >= 5) {
                User user = new User();
                user.setUsername(parts[0].trim());
                user.setPassword(parts[1].trim());
                user.setFullName(parts[2].trim());
                user.setRole(parts[3].trim());
                user.setEmail(parts[4].trim().isEmpty() ? null : parts[4].trim());
                return user;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error parsing user from string", e);
        }
        return null;
    }

    // Save all users to file
    private boolean saveAllUsers(List<User> users) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(dataFilePath))) {
            for (User user : users) {
                writer.write(userToString(user));
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving all users", e);
            return false;
        }
    }
}