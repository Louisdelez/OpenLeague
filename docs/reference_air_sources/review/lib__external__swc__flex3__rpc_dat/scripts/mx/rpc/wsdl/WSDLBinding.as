package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   
   public class WSDLBinding
   {
      
      private var _name:String;
      
      private var _transport:String;
      
      private var _style:String;
      
      private var _portType:WSDLPortType;
      
      public function WSDLBinding(name:String)
      {
         super();
         _name = name;
      }
      
      public function set style(value:String) : void
      {
         _style = value;
      }
      
      [Inspectable(defaultValue="http://schemas.xmlsoap.org/soap/http/",category="General")]
      public function get transport() : String
      {
         if(_transport == null)
         {
            _transport = WSDLConstants.SOAP_HTTP_URI;
         }
         return _transport;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "WSDLBinding name=" + _name + ", style=" + _style + ", transport=" + _transport;
      }
      
      [Inspectable(enumeration="document,rpc",defaultValue="document",category="General")]
      public function get style() : String
      {
         if(_style == null)
         {
            _style = SOAPConstants.DEFAULT_OPERATION_STYLE;
         }
         return _style;
      }
      
      public function set transport(value:String) : void
      {
         _transport = value;
      }
      
      public function set portType(value:WSDLPortType) : void
      {
         _portType = value;
      }
      
      public function get portType() : WSDLPortType
      {
         return _portType;
      }
   }
}

