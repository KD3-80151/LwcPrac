public with sharing class OrderLineItemBfs {
    
    public static void updateCountValues(List<OrderLineItem> newOLI){
        if (newOLI == null && newOLI.sisEmpty()) return;
         
        set<Id> setWhichNeedtotraverse = new set<Id>();
        for(OrderLineItem getOlIs : newOLI){
            if (newOLI != oldMapData.get(getOlIs.Id)) {
                
            }
        }

    }
}