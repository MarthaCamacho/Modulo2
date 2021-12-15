public class InventoryBatch Implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    //global public with sharing class InventoryBatch implements Database.Batchable<sObject>{
    
        public Database.QueryLocator start(Database.BatchableContext BC) {
            
            //Buscar los objetos existentes en tabnla inventarios.     
            String query = 'SELECT id, Name, CodigoProd__c, Cantidad_dis__c, Cantidad_apart__c FROM Inventario__c';
            
            System.debug(' Inicializacion del batch. SQL: ' + query);
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<Inventario__c> invOld) { 
            
            System.debug(' Ejecución del batch....');
            
            List<Inventario__c> invNew = InventoryQuery.getExternalInventary();
            List<Inventario__c> invUpd = new List<Inventario__c>();
            
            // Procesar cada batch de registros (200 por defecto)
            for(Inventario__c a : invOld) {
                for (Inventario__c b : invNew ){
                    if (a.CodigoProd__c == b.CodigoProd__c){
                        Inventario__c invTmp = new Inventario__c();
                        invTmp.id = a.id;
                        invTmp.Name = a.Name;
                        invTmp.Cantidad_dis__c = b.Cantidad_dis__c;
                        invTmp.Cantidad_apart__c = b.Cantidad_apart__c;
                        Mensajeria.EnviarCorreoSimple('my.camacho.o@gmail.com',   'Producto: ' + a.CodigoProd__c + ' Disp old: ' + a.Cantidad_dis__c +
                        ' Disp new: ' + b.Cantidad_dis__c, 'hiuhuihui '+ Datetime.now());
                        System.debug(' Producto: ' + a.CodigoProd__c + ' Disp old: ' + a.Cantidad_dis__c +
                        ' Disp new: ' + b.Cantidad_dis__c + ' Bloq old: ' + b.Cantidad_apart__c + ' Bloq old: ' + a.Cantidad_apart__c );
                        invUpd.add(invTmp);
                    }
                }           
            }
    
            try {
                // Actualiar la lista de candidatos
                update invUpd;
                System.debug(invUpd);         
            } catch(Exception e) {
                System.debug(e);
            }         
        }
    
        public void finish(Database.BatchableContext BC) {
            System.debug(' Finaliza llamado del batch....');
            Mensajeria.EnviarCorreoSimple('my.camacho.o@gmail.com', 'InventoryBatch Ejecutado', 'El InventoryBatch ha sido ejecutado finalmente en: '+ Datetime.now());
        }
    }