global class ScheduleInventoryBatch implements Schedulable{
    
    /// Para programarlo desde la consola.
    //ScheduleInventoryBatch sib = new ScheduleInventoryBatch();
    //string sch = '0 0 19 1/1 * ? *';
    //string jobID = system.schedule('Inventory Job',sch,sib);

    global void execute (SchedulableContext sc) {
        InventoryBatch bacth = new InventoryBatch();
        id batchID = Database.executeBatch(bacth); 

    }
    
}
