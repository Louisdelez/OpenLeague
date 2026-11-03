package mx.rpc.soap.types
{
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   
   [ExcludeClass]
   public interface ICustomSOAPType
   {
      
      function decode(param1:SOAPDecoder, param2:*, param3:*, param4:*, param5:XML = null) : void;
      
      function encode(param1:SOAPEncoder, param2:XML, param3:QName, param4:*, param5:XML = null) : void;
   }
}

