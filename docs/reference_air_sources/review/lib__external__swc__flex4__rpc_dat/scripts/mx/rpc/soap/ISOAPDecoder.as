package mx.rpc.soap
{
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.xml.IXMLDecoder;
   
   [ExcludeClass]
   public interface ISOAPDecoder extends IXMLDecoder
   {
      
      function get forcePartArrays() : Boolean;
      
      function set forcePartArrays(param1:Boolean) : void;
      
      function get ignoreWhitespace() : Boolean;
      
      function set ignoreWhitespace(param1:Boolean) : void;
      
      function get resultFormat() : String;
      
      function set resultFormat(param1:String) : void;
      
      function get headerFormat() : String;
      
      function set headerFormat(param1:String) : void;
      
      function get multiplePartsFormat() : String;
      
      function set multiplePartsFormat(param1:String) : void;
      
      function get wsdlOperation() : WSDLOperation;
      
      function set wsdlOperation(param1:WSDLOperation) : void;
      
      function decodeResponse(param1:*) : SOAPResult;
   }
}

