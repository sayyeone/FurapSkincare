package com.furapskin.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Core JDBC Connection Engine for FurapSkin.
 * Routes traffic to the internal Docker network database container.
 */
public class DatabaseConnection {

    // Internal Docker network routing
    private static final String URL = "jdbc:mysql://furapskin-db:3306/furapskin_v2";
    // Default credentials for development container
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    static {
        try {
            // Explicitly load the MySQL JDBC driver for Tomcat 10 lifecycle
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("CRITICAL: Failed to load MySQL JDBC Driver", e);
        }
    }

    /**
     * Thread-safe factory method to supply Database Connections.
     * @return java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
