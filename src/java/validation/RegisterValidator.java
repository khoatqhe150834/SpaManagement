package validation;

import dao.CustomerDAO;

public class RegisterValidator {
    private final CustomerDAO customerDAO;

    public RegisterValidator(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public boolean isEmailDuplicate(String email) {
        return customerDAO.isExistsByEmail(email);
    }

    public boolean isPhoneDuplicate(String phone) {
        return customerDAO.isExistsByPhone(phone);
    }
}