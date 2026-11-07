package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   
   public class WSDLBinding
   {
      
      private var _name:String;
      
      private var _portType:WSDLPortType;
      
      private var _style:String;
      
      private var _transport:String;
      
      public function WSDLBinding(name:String)
      {
         super();
         this._name = name;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get portType() : WSDLPortType
      {
         return this._portType;
      }
      
      public function set portType(value:WSDLPortType) : void
      {
         this._portType = value;
      }
      
      [Inspectable(enumeration="document,rpc",defaultValue="document",category="General")]
      public function get style() : String
      {
         if(this._style == null)
         {
            this._style = SOAPConstants.DEFAULT_OPERATION_STYLE;
         }
         return this._style;
      }
      
      public function set style(value:String) : void
      {
         this._style = value;
      }
      
      [Inspectable(defaultValue="http://schemas.xmlsoap.org/soap/http/",category="General")]
      public function get transport() : String
      {
         if(this._transport == null)
         {
            this._transport = WSDLConstants.SOAP_HTTP_URI;
         }
         return this._transport;
      }
      
      public function set transport(value:String) : void
      {
         this._transport = value;
      }
      
      public function toString() : String
      {
         return "WSDLBinding name=" + this._name + ", style=" + this._style + ", transport=" + this._transport;
      }
   }
}

