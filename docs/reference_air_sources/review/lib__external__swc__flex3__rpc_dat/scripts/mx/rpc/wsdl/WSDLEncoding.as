package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   
   [ExcludeClass]
   public class WSDLEncoding
   {
      
      private var _parts:Array;
      
      private var _message:QName;
      
      private var _soapConstants:SOAPConstants;
      
      private var _namespaceURI:String;
      
      private var _useStyle:String = SOAPConstants.DEFAULT_USE;
      
      private var _encodingStyle:String = SOAPConstants.SOAP_ENCODING_URI;
      
      public function WSDLEncoding()
      {
         super();
      }
      
      public function get parts() : Array
      {
         return _parts;
      }
      
      public function set namespaceURI(value:String) : void
      {
         _namespaceURI = value;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(_soapConstants == null)
         {
            _soapConstants = SOAPConstants.getConstants(null);
         }
         return _soapConstants;
      }
      
      public function setParts(value:String) : void
      {
         var array:Array = null;
         var part:String = null;
         if(value != null && value.length > 0)
         {
            _parts = [];
            array = value.split(" ");
            for each(part in array)
            {
               if(part.length > 0)
               {
                  _parts.push(part);
               }
            }
         }
         else
         {
            _parts = null;
         }
      }
      
      public function get message() : QName
      {
         return _message;
      }
      
      public function get useStyle() : String
      {
         return _useStyle;
      }
      
      public function hasPart(name:String) : Boolean
      {
         var part:String = null;
         if(_parts != null && _parts.length > 0)
         {
            for each(part in _parts)
            {
               if(part == name)
               {
                  return true;
               }
            }
            return false;
         }
         return true;
      }
      
      public function set message(value:QName) : void
      {
         _message = value;
      }
      
      public function get namespaceURI() : String
      {
         return _namespaceURI;
      }
      
      public function set useStyle(value:String) : void
      {
         _useStyle = value;
      }
      
      public function set encodingStyle(value:String) : void
      {
         _encodingStyle = Boolean(value) ? value : soapConstants.encodingURI;
      }
      
      public function get encodingStyle() : String
      {
         if(_encodingStyle == null)
         {
            _encodingStyle = soapConstants.encodingURI;
         }
         return _encodingStyle;
      }
   }
}

