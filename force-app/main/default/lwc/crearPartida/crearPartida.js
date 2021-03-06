import { LightningElement, api } from 'lwc';
import SearchProduct from '@salesforce/apex/CrearPartidaController.SearchProduct';
import SaveProduct from '@salesforce/apex/CrearPartidaController.Save';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Nombre Producto', fieldName: 'productName' },
    { label: 'Precio de Lista', fieldName: 'unitPrice', type: 'currency'  },
    { label: 'Cantidad', fieldName: 'quantity', editable: true},
    { label: 'Disponible', fieldName: 'available'},
];

export default class CrearPartida extends LightningElement {
    isModalOpen = false;
    showGrid = false;
    search = '';
    data = [];
    columns = columns;
    @api recordId;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    handleSearchText(event){
        this.search = event.detail.value;
        console.log('este es el texto-->'+this.search);
    }
    handleSearch(event){
        //voy a llamar al controlador apex 
        //y enviarle el texto de búsqueda para que retorne los datos
        SearchProduct({ searchText: this.search })
            .then((result) => {
                console.log('este es el resultado-->'+JSON.stringify(result));
                this.data = result;
                this.showGrid = true;
            })
            .catch((error) => {
                console.log('este es el error-->'+error);
                this.showToast('Error en la búsqueda', error.body.message, 'error');
            });
    }
    clean(event){
        this.data = [];
        this.search = '';
        this.showGrid = false;
    }
    cellchange(event){
        var temp = JSON.parse(JSON.stringify(this.data));
        temp[0].quantity = event.detail.draftValues[0].quantity;
        this.data = JSON.parse(JSON.stringify(temp));
        console.log('así quedo data-->'+JSON.stringify(this.data));
    }
    save(event){
        //Solo debe permitir capturar un valor numérico y entero.
        // -- comparar el quantity sea número y que sea mayor cero
        //Es un campo obligatorio, no puede estar vacío o con valor igual a 0.
        // -- no este null o undefined
        //Debe ser menor o igual al valor de la columna de cantidad disponible.
        //-- comparar el quantity con available
        var temp = JSON.parse(JSON.stringify(this.data));
        temp[0].quoteId = this.recordId;
        this.data = JSON.parse(JSON.stringify(temp));
        SaveProduct({ partida: this.data[0] })
            .then((result) => {
                console.log('este es el resultado-->'+JSON.stringify(result));                
                this.showToast('La partida se guardo éxitosamente','', 'sucess');
            })
            .catch((error) => {
                console.log('este es el error-->'+JSON.stringify(error));
            });
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}