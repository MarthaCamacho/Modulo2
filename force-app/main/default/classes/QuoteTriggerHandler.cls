public class QuoteTriggerHandler implements ITriggerHandler {
   
    //Validacion de estatus segun la cantidad de productos que tenga la cotizacion
    private void handleTypeValidation(List<Quote> newQuotes, string triggerStatus){
        integer unitProduct = 0;
        for(Quote nQuote : newQuotes){
            if(nQuote.status == 'Approved'){
                unitProduct = [SELECT COUNT () FROM QuoteLineItem WHERE QuoteId =: nQuote.id];
                if(unitProduct == 0){
                    nQuote.addError('The Quote '+ nQuote.name + ' dont have products. Cannot ' +triggerStatus+ ' with status ' + nQuote.Status);
                }
            }
        }
    }

    public void beforeInsert(List<sObject> newList){
        List<Quote> listQuote = new List<Quote>();
        for(sObject obj : newList){
            listQuote.add((Quote)obj);
        }
        handleTypeValidation(listQuote, 'insert');
    }    
    
    public void afterInsert(List<sObject> newList, Map<Id, sObject> newMap){}

    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap){
        List<Quote> listQuote = new List<Quote>();
        for(sObject obj : newList){
            listQuote.add((Quote)obj);
        }
        handleTypeValidation(listQuote, 'update');
    }    

    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap){}   
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap){}
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap){}    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap){}

    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
}
