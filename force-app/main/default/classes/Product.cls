public class Product implements Comparable {
    
    public String name;
    public Integer price;
    public Integer stockLevel;

    public int compareTo(Object o){
        Product p = (Product) o; // Downcast to Product
        Integer priceComparision = price.compareTo(p.price);

        if(priceComparision != 0){
            return priceComparision; // No need to reverse for ascending order
        }

        Integer stockLevelComparision = stockLevel.compareTo(p.stockLevel);
        if(stockLevelComparision != 0){
            return stockLevelComparision; // No need to reverse for ascending order
        }

        return name.compareTo(p.name); // No need to reverse for ascending order
    }
}