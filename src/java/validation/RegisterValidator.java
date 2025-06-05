package validation;

import dao.AccountDAO;

public class RegisterValidator {
    private final AccountDAO accountDAO;

    public RegisterValidator() {
        this.accountDAO = new AccountDAO();
    }

    public boolean isEmailDuplicate(String email) {
        return accountDAO.isEmailTakenInSystem(email);
    }

    public boolean isPhoneDuplicate(String phone) {
        return accountDAO.isPhoneTakenInSystem(phone);
    }
}