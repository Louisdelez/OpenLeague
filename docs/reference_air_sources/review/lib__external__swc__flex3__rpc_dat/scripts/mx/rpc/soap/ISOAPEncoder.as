package mx.rpc.soap
{
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.xml.IXMLEncoder;
   
   [ExcludeClass]
   public interface ISOAPEncoder extends IXMLEncoder
   {
      
      function set wsdlOperation(param1:WSDLOperation) : void;
      
      function encodeRequest(param1:* = null, param2:Array = null) : XML;
      
      function get wsdlOperation() : WSDLOperation;
      
      function set ignoreWhitespace(param1:Boolean) : void;
      
      function get ignoreWhitespace() : Boolean;
   }
}

