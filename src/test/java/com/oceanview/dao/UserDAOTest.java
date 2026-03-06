package com.oceanview.dao;

import com.oceanview.model.User;
import org.junit.Before;
import org.junit.Test;
import org.junit.After;

import static org.junit.Assert.*;

/**
 * Unit tests for UserDAO
 */
public class UserDAOTest {

    private UserDAO userDAO;
    private User testUser;

    @Before
    public void setUp() {
        userDAO = new UserDAO();

        testUser = new User(
                "testuser",
                "testpass",
                "Test User",
                "STAFF",
                "test@oceanview.com"
        );
    }

    @After
    public void tearDown() {
        // Clean up test user
        if (testUser != null) {
            userDAO.deleteUser("testuser");
        }
    }

    @Test
    public void testAddUser() {
        boolean result = userDAO.addUser(testUser);
        assertTrue("User should be added successfully", result);
    }

    @Test
    public void testAuthenticate() {
        // Add user first
        userDAO.addUser(testUser);

        // Test authentication
        User authenticated = userDAO.authenticate("testuser", "testpass");

        assertNotNull("Authentication should succeed", authenticated);
        assertEquals("Usernames should match", "testuser", authenticated.getUsername());
    }

    @Test
    public void testAuthenticateWrongPassword() {
        userDAO.addUser(testUser);

        User authenticated = userDAO.authenticate("testuser", "wrongpass");

        assertNull("Authentication should fail with wrong password", authenticated);
    }

    @Test
    public void testGetUserByUsername() {
        userDAO.addUser(testUser);

        User retrieved = userDAO.getUserByUsername("testuser");

        assertNotNull("User should be retrieved", retrieved);
        assertEquals("Full names should match", "Test User", retrieved.getFullName());
    }

    @Test
    public void testUpdateUser() {
        userDAO.addUser(testUser);

        testUser.setFullName("Updated Name");
        testUser.setEmail("updated@oceanview.com");

        boolean result = userDAO.updateUser(testUser);

        assertTrue("User should be updated", result);

        User updated = userDAO.getUserByUsername("testuser");
        assertEquals("Full name should be updated", "Updated Name", updated.getFullName());
        assertEquals("Email should be updated", "updated@oceanview.com", updated.getEmail());
    }

    @Test
    public void testDeleteUser() {
        userDAO.addUser(testUser);

        boolean result = userDAO.deleteUser("testuser");

        assertTrue("User should be deleted", result);

        User deleted = userDAO.getUserByUsername("testuser");
        assertNull("Deleted user should not be found", deleted);
    }

    @Test
    public void testChangePassword() {
        userDAO.addUser(testUser);

        boolean result = userDAO.changePassword("testuser", "testpass", "newpass");

        assertTrue("Password should be changed", result);

        // Verify old password doesn't work
        User oldAuth = userDAO.authenticate("testuser", "testpass");
        assertNull("Old password should not work", oldAuth);

        // Verify new password works
        User newAuth = userDAO.authenticate("testuser", "newpass");
        assertNotNull("New password should work", newAuth);
    }
}