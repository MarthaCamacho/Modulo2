trigger QuoteTrigger on Quote (before insert, before update) {
    // Este trigger debe encontrarse en los Metadatos customizados.
    TriggerDispatcher.run(new QuoteTriggerHandler(),'QuoteTrigger');
}