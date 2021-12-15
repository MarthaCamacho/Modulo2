public class InventoryRest {

    public Integer statusCode;
    public Body body;

    public class Body {
        public List<Inventory> Inventory;
    }

    public class Inventory {
        public String name;
        public String ProductID;
        public Integer Quan;
        public Integer BlockedQuan;
    }

    public static InventoryRest parse(String json) {
        return (InventoryRest) System.JSON.deserialize(json, InventoryRest.class);
    }
}