package dao;

import java.util.List;
import java.util.Optional;

/**
 * A simplified base Data Access Object (DAO) interface for essential CRUD operations.
 *
 * @param <T>  The domain type the DAO manages.
 * @param <ID> The type of the id of the domain type the DAO manages.
 */
public interface BaseDAO<T, ID> {

    // --- Create / Update ---

    /**
     * Saves a given entity. Use this for creating a new entity
     * or updating an existing one.
     *
     * @param entity must not be {@literal null}.
     * @return the saved entity; will never be {@literal null}.
     * @param <S> the type of the entity
     */
    <S extends T> S save(S entity);

    // --- Read ---

    /**
     * Retrieves an entity by its id.
     *
     * @param id must not be {@literal null}.
     * @return the entity with the given id or {@link Optional#empty()} if none found.
     */
    Optional<T> findById(ID id);

    /**
     * Returns all instances of the type.
     *
     * @return all entities; an empty list if none are found.
     */
    List<T> findAll();

    /**
     * Returns whether an entity with the given id exists.
     *
     * @param id must not be {@literal null}.
     * @return {@literal true} if an entity with the given id exists, {@literal false} otherwise.
     */
    boolean existsById(ID id); // Useful to check before an update or if you just need existence status

    // --- Delete ---

    /**
     * Deletes the entity with the given id.
     *
     * @param id must not be {@literal null}.
     */
    void deleteById(ID id);
    
     <S extends T> S update(S entity);

    /**
     * Deletes a given entity.
     *
     * @param entity must not be {@literal null}.
     */
    void delete(T entity); // Useful if you already have the entity object

}