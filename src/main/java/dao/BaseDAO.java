package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Base interface for Data Access Objects
 * 
 * @param <T>  The entity type this DAO handles
 * @param <ID> The type of the entity's primary key
 */
public interface BaseDAO<T, ID> {
    /**
     * Gets a connection from the connection pool
     * 
     * @return A database connection from the pool
     * @throws SQLException if connection cannot be obtained
     */
    default Connection getConnection() throws SQLException {
        return db.DBContext.getConnection();
    }

    /**
     * Closes database resources safely
     * 
     * @param resultSet  The ResultSet to close
     * @param statement  The PreparedStatement to close
     * @param connection The Connection to return to the pool
     */
    default void closeResources(ResultSet resultSet, PreparedStatement statement, Connection connection) {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
            }
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
            if (connection != null && !connection.isClosed()) {
                connection.close(); // Returns the connection to the pool
            }
        } catch (SQLException e) {
            System.err.println("Error closing resources in BaseDAO: " + e.getMessage());
        }
    }

    // Core CRUD operations
    Optional<T> findById(ID id) throws SQLException;

    List<T> findAll() throws SQLException;

    <S extends T> S save(S entity) throws SQLException;

    <S extends T> S update(S entity) throws SQLException;

    void deleteById(ID id) throws SQLException;

    void delete(T entity) throws SQLException;

    boolean existsById(ID id) throws SQLException;

    // Pagination support
    default List<T> findAll(int page, int pageSize) throws SQLException {
        throw new UnsupportedOperationException("Pagination not implemented");
    }

    // Common utility methods
    default int count() throws SQLException {
        throw new UnsupportedOperationException("Count not implemented");
    }
}