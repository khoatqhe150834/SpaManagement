package model;

public enum CustomerTier {
    DONG("Đồng", 0),
    BAC("Bạc", 500),
    VANG("Vàng", 1000),
    KIMCUONG("Kim Cương", 1500);

    private final String label;
    private final int minPoints;

    CustomerTier(String label, int minPoints) {
        this.label = label;
        this.minPoints = minPoints;
    }

    public String getLabel() {
        return label;
    }

    public int getMinPoints() {
        return minPoints;
    }

    public static CustomerTier fromPoints(int points) {
        if (points >= KIMCUONG.minPoints) return KIMCUONG;
        if (points >= VANG.minPoints) return VANG;
        if (points >= BAC.minPoints) return BAC;
        return DONG;
    }
} 