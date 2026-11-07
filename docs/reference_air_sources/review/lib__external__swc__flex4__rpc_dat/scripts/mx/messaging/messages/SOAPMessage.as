package mx.messaging.messages
{
   [RemoteClass(alias="flex.messaging.messages.SOAPMessage")]
   public class SOAPMessage extends HTTPRequestMessage
   {
      
      public static const SOAP_ACTION_HEADER:String = "SOAPAction";
      
      public function SOAPMessage()
      {
         super();
         method = "POST";
         contentType = CONTENT_TYPE_SOAP_XML;
      }
      
      public function getSOAPAction() : String
      {
         return httpHeaders != null ? httpHeaders[SOAP_ACTION_HEADER] : null;
      }
      
      public function setSOAPAction(value:String) : void
      {
         var str:String = null;
         if(value != null)
         {
            if(value.indexOf("\"") < 0)
            {
               str = "\"";
               str += value;
               str += "\"";
               value = str.toString();
            }
            if(httpHeaders == null)
            {
               httpHeaders = {};
            }
            httpHeaders[SOAP_ACTION_HEADER] = value;
         }
      }
   }
}

