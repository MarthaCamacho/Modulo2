trigger QuoteLineItemTrigger on QuoteLineItem (before insert, before update, before delete) {
    // Este trigger debe encontrarse en los Metadatos customizados.
    TriggerDispatcher.run(new QuoteLineItemTriggerHandler(),'QuoteLineItemTrigger');
}