public class Mensajeria {
    public static void EnviarCorreoSimple(string destinatario, string titulo, string texto ){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {destinatario};                 
        mail.setToAddresses(toAddresses);
        mail.setSubject(titulo);
        mail.setPlainTextBody(texto);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    @invocableMethod (label='Enviar un correo')
    public static void EnviarCorreoAction(List<EmailWrapper> contenidos){
        for(EmailWrapper email : contenidos){
            EnviarCorreoSimple(email.destinatario, email.titulo, email.texto);
        }
    }
    
    public class EmailWrapper {
        @InvocableVariable(label='destinatario' required=true)
        public String destinatario;
        @InvocableVariable(label='titulo' required=true)
        public String titulo;
        @InvocableVariable(label='texto' required = true)
        public String texto;
    }
}