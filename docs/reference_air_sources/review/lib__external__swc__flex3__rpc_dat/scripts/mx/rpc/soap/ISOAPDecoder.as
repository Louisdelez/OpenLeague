package mx.rpc.soap
{
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.xml.IXMLDecoder;
   
   [ExcludeClass]
   public interface ISOAPDecoder extends IXMLDecoder
   {
      
      function get wsdlOperation() : WSDLOperation;
      
      function get headerFormat() : String;
      
      function set wsdlOperation(param1:WSDLOperation) : void;
      
      function get multiplePartsFormat() : String;
      
      function set headerFormat(param1:String) : void;
      
      function set multiplePartsFormat(param1:String) : void;
      
      function get ignoreWhitespace() : Boolean;
      
      function set forcePartArrays(param1:Boolean) : void;
      
      function get resultFormat() : String;
      
      function decodeResponse(param1:*) : SOAPResult;
      
      function set resultFormat(param1:String) : void;
      
      function get forcePartArrays() : Boolean;
      
      function set ignoreWhitespace(param1:Boolean) : void;
   }
}

