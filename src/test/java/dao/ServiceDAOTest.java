package dao;

import java.util.List;
import model.Service;
import org.junit.jupiter.api.AfterAll;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

//@Disabled("Disabling all tests in this class because they require a database connection")
public class ServiceDAOTest {

  private static ServiceDAO serviceDAO;

  @BeforeAll
  public static void setUpClass() {
    System.out.println("Initializing database connection for tests...");
    db.DataSource.initialize();
    serviceDAO = new ServiceDAO();
  }

  @AfterAll
  public static void tearDownClass() {
    System.out.println("Closing database connection for tests...");
    db.DataSource.close();
  }

  @BeforeEach
  public void setUp() {
    // No longer need to create a new DAO for each test,
    // as it's now a static field initialized once.
  }

  private void printResults(String testName, List<Service> services) {
    System.out.println("--- " + testName + " ---");
    if (services.isEmpty()) {
      System.out.println("No services found.");
    } else {
      services.forEach(System.out::println);
    }
    System.out.println();
  }

  @Test
  public void testGetServicesWithAllCriteria() {
    System.out.println(
        "Testing with all criteria: category='Facial', query='chăm sóc da', minPrice=500000, maxPrice=1500000, order='price_asc'");
    List<Service> result = serviceDAO.getServicesByCriteria("Facial", "chăm sóc da", 500000, 1500000, 1, 10,
        "price_asc");
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithAllCriteria", result);
  }

  @Test
  public void testGetServicesWithOnlyCategory() {
    System.out.println("Testing with only category: 'Body'");
    List<Service> result = serviceDAO.getServicesByCriteria("Body", null, null, null, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithOnlyCategory", result);
  }

  @Test
  public void testGetServicesWithOnlySearchQuery() {
    System.out.println("Testing with only search query: 'massage'");
    List<Service> result = serviceDAO.getServicesByCriteria(null, "massage", null, null, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithOnlySearchQuery", result);
  }

  @Test
  public void testGetServicesWithOnlyPriceRange() {
    System.out.println("Testing with only price range: minPrice=1000000, maxPrice=2000000");
    List<Service> result = serviceDAO.getServicesByCriteria(null, null, 1000000, 2000000, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithOnlyPriceRange", result);
  }

  @Test
  public void testGetServicesWithCategoryAndPrice() {
    System.out.println("Testing with category='Makeup' and price range: minPrice=300000, maxPrice=800000");
    List<Service> result = serviceDAO.getServicesByCriteria("Makeup", null, 300000, 800000, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithCategoryAndPrice", result);
  }

 

  @Test
  public void testGetServicesWithEmptySearchQuery() {
    System.out.println("Testing with an empty search query: ''");
    List<Service> result = serviceDAO.getServicesByCriteria(null, "", null, null, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithEmptySearchQuery", result);
  }

  @Test
  public void testGetServicesWithInvalidPriceRange() {
    System.out.println("Testing with an invalid price range: minPrice=2000000, maxPrice=1000000");
    List<Service> result = serviceDAO.getServicesByCriteria(null, null, 2000000, 1000000, 1, 10, null);

    assertNotNull(result, "Result should not be null");
    assertTrue(result.isEmpty(), "Result should be empty for an invalid price range");
    printResults("testGetServicesWithInvalidPriceRange", result);
  }

  

  @Test
  public void testGetServicesOrderByPriceDesc() {
    System.out.println("Testing with ordering by price descending");
    List<Service> result = serviceDAO.getServicesByCriteria(null, null, null, null, 1, 10, "price_desc");
    assertNotNull(result, "Result should not be null");
    // Optional: Add assertion to check if prices are actually in descending order
    printResults("testGetServicesOrderByPriceDesc", result);
  }

  @Test
  public void testGetServicesWithBoundaryPrice() {
    System.out.println("Testing with boundary price: minPrice=0, maxPrice=500000");
    List<Service> result = serviceDAO.getServicesByCriteria(null, null, 0, 500000, 1, 10, null);
    assertNotNull(result, "Result should not be null");
    printResults("testGetServicesWithBoundaryPrice", result);
  }
}