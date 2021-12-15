public class InventoryQuery {
    public static List<Inventario__c> getExternalInventary(){
        //Lista del valor a retornar
        List<Inventario__c> retorno = new List<Inventario__c>();

        // Se instancia con un controlador vacio
        Http http = new Http();
        HttpRequest solicitud = new HttpRequest();

        //URL y metodo a consultar
        solicitud.setEndpoint('https://64bjp0q5wg.execute-api.us-east-2.amazonaws.com/Implement/');
        solicitud.setMethod('GET');

        // Respuesta del servicio
        HttpResponse respuesta = http.send(solicitud);

        if(respuesta.getStatusCode() == 200){
            InventoryRest inventwrapper = InventoryRest.parse(respuesta.getBody());

             //Recorrido del json para tomar valores
             for (InventoryRest.Inventory item : inventwrapper.body.Inventory) {
                Inventario__c objInv = new Inventario__c();
                objInv.CodigoProd__c = item.ProductID;
                objInv.Cantidad_dis__c = item.Quan;
                objInv.Cantidad_apart__c = item.BlockedQuan;
                System.debug(' Product:  ' + item.ProductID + ' - ' + item.name + ' Available ' + objInv.Cantidad_dis__c + ' Blocked ' );
                retorno.add(objInv);       
            }
        }
        // Para que no falle (asegurar retorno)
        System.debug(' Fin InventoryRestQuery retorno:  ' + retorno);  
        return retorno;
    }
}
