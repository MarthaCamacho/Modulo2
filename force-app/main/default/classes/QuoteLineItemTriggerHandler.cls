public class QuoteLineItemTriggerHandler implements ITriggerHandler{
    
    private static void handleTypeDelete(List<QuoteLineItem> newQuoteLineItem){ 
        Decimal disp = 0;
        Decimal nodisp = 0;
        //Inventory__c objInv = new Inventory__c();
        //String vProdCode = '';
        System.debug(' Trigger Delete');
        try {
            for (QuoteLineItem oQuote : newQuoteLineItem) {
                //Obtener nombre de Presupuesto
                Quote objQuote = [ SELECT Name FROM quote WHERE Id = :oQuote.QuoteId ];
                Product2 vProdCode = [ SELECT ProductCode FROM Product2 WHERE id = :oQuote.Product2Id ];
                Inventario__c objInventory = [ SELECT name, CodigoProd__c, Cantidad_dis__c, Cantidad_apart__c //,Quote_Name__c 
                                              FROM Inventario__c WHERE CodigoProd__c = :vProdCode.ProductCode ];
                                              //AND Quote_Name__c = :objQuote.name ];
                System.debug(' Presupuesto: ' + objQuote.Name + ' Producto: ' + vProdCode.ProductCode + '-' + objInventory.name );
                
                // Condicional para manejar el tema de disponibilidad.  
                nodisp = objInventory.Cantidad_apart__c - oQuote.Quantity; 
                disp = objInventory.Cantidad_dis__c + oQuote.Quantity;
                objInventory.Cantidad_dis__c = disp;
                objInventory.Cantidad_apart__c = nodisp;
                System.debug(' Cantidad eliminada: ' + oQuote.Quantity + ' nodisp ' + nodisp + ' disp ' + disp + ' oQuote.Quantity ' + oQuote.Quantity);
                update objInventory;                
            }
            
        } catch (Exception ex) {
            System.debug(' Error in QuoteLineItemTriggerHelper.cls: ' + ex);
            //oQuote.addError(' Records dont saved. Details Error: ' + ex );
        }      
        
    }

    private static void handleTypeInsert(List<QuoteLineItem> newQuoteLineItem){
        Decimal disp = 0;
        Decimal nodisp = 0;
        
        try {
            for(QuoteLineItem oQuote : newQuoteLineItem){
                Product2 objProduct = [ SELECT ProductCode FROM Product2 WHERE id =: oQuote.Product2Id];
                Inventario__c objInventory = [ SELECT Name, CodigoProd__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario__c WHERE CodigoProd__c =: objProduct.ProductCode];
                //Validar Disponibilidad
                nodisp = objInventory.Cantidad_apart__c + oQuote.Quantity;
                disp = objInventory.Cantidad_dis__c;

                if(disp >= oQuote.Quantity){
                    disp = objInventory.Cantidad_dis__c - oQuote.Quantity;
                    objInventory.Cantidad_dis__c = disp;
                    objInventory.Cantidad_apart__c = nodisp;
                    update objInventory;
                }else{
                    oQuote.addError(' The Product ' + objInventory.name + ' does not have the requested quantity. Quantity available: ' + objInventory.Cantidad_dis__c);
                }
            }
        }
        catch(Exception e) {
            System.debug(' Error in QuoteLineItemTriggerHelper.cls: ' + e);
        }          
    }

    private static void handleTypeUpdate(List<QuoteLineItem> newQuoteLineItem){ 
        Decimal disp = 0;
        Decimal nodisp = 0;

        try {
            for (QuoteLineItem oQuote : newQuoteLineItem) {
                //Obtener nombre de Presupuesto
                Quote objQuote = [ SELECT Name FROM quote WHERE Id = :oQuote.QuoteId ];
                QuoteLineItem objQuoteLine = [ SELECT Product2Id, Quantity  FROM QuoteLineItem WHERE QuoteId = :oQuote.QuoteId AND LineNumber = :oQuote.LineNumber];
                Product2 vProdCode = [ SELECT ProductCode FROM Product2 WHERE id = :objQuoteLine.Product2Id ];
                Inventario__c objInventory = [ SELECT name, CodigoProd__c, Cantidad_dis__c, Cantidad_apart__c
                                              FROM Inventario__c WHERE CodigoProd__c = :vProdCode.ProductCode ];
                // Condicional para manejar el tema de disponibilidad.
                if( oQuote.Quantity > objQuoteLine.Quantity){
                    nodisp = ( oQuote.Quantity - objQuoteLine.Quantity ) + objInventory.Cantidad_apart__c;
                    disp = objInventory.Cantidad_dis__c - ( oQuote.Quantity - objQuoteLine.Quantity );
                }else if (oQuote.Quantity < objQuoteLine.Quantity){
                    nodisp = objInventory.Cantidad_apart__c - (objQuoteLine.Quantity - oQuote.Quantity);
                    disp = objInventory.Cantidad_dis__c + (objQuoteLine.Quantity - oQuote.Quantity);
                }else{
                    nodisp = objInventory.Cantidad_apart__c;
                    disp = objInventory.Cantidad_dis__c;                    
                }
                    
                //System.debug(' Quantity Available: ' + objInventory.Quantity_Available__c + ' Quantity requested: ' + oQuote.Quantity + ' Value disp: ' + disp);
                if (disp >= 0 ) {
                    objInventory.Cantidad_dis__c = disp;
                    objInventory.Cantidad_apart__c = nodisp;
                    update objInventory;
                }
                else {
                    oQuote.addError(' The Product ' + objInventory.name + ' does not have the requested quantity. Quantity available: ' + objInventory.Cantidad_dis__c);
                }                
            }
            
        } catch (Exception ex) {
            System.debug(' Error in QuoteLineItemTriggerHelper.cls: ' + ex);
            //oQuote.addError(' Records dont saved. Details Error: ' + ex );
        }      
        
    }


    public void beforeInsert(List<sObject> newList){
        List<QuoteLineItem> listQuote = new List<QuoteLineItem>();
        for(sobject obj : newList){
            listQuote.add((QuoteLineItem)obj);
        }
        handleTypeInsert(listQuote);
    }    

    public void afterInsert(List<sObject> newList, Map<Id, sObject> newMap){ }   
     
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap){
        List<QuoteLineItem> listQuote = new List<QuoteLineItem>();
        for(sobject obj : newList){ 
            listQuote.add((QuoteLineItem)obj);
        }
        handleTypeUpdate(listQuote);
    }    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap){}    
    
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap){
        List<QuoteLineItem> lstQuote = new List<QuoteLineItem>();
        for(sobject obj : oldList){
            lstQuote.add((QuoteLineItem)obj);
        }
        handleTypeDelete(lstQuote);
    }
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap){}    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap){}    

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
}
