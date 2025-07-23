package util;

import model.CustomerTier;

public class CustomerPrivilegeUtil {
    public static boolean canGetBirthdayGift(CustomerTier tier) {
        return tier == CustomerTier.KIMCUONG;
    }
    public static boolean canGet10PercentDiscount(CustomerTier tier) {
        return tier == CustomerTier.VANG || tier == CustomerTier.KIMCUONG;
    }
    public static boolean canGet5PercentDiscount(CustomerTier tier) {
        return tier == CustomerTier.BAC || canGet10PercentDiscount(tier);
    }
    public static boolean hasPriorityBooking(CustomerTier tier) {
        return tier == CustomerTier.VANG || tier == CustomerTier.KIMCUONG;
    }
    // Thêm các quyền khác nếu cần
} 