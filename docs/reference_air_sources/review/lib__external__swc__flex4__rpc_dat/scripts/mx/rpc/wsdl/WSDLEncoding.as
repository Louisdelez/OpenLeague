package mx.rpc.wsdl
{
   import mx.rpc.soap.SOAPConstants;
   
   [ExcludeClass]
   public class WSDLEncoding
   {
      
      private var _encodingStyle:String = "http://schemas.xmlsoap.org/soap/encoding/";
      
      private var _message:QName;
      
      private var _namespaceURI:String;
      
      private var _parts:Array;
      
      private var _soapConstants:SOAPConstants;
      
      private var _useStyle:String = "literal";
      
      public function WSDLEncoding()
      {
         super();
      }
      
      public function get encodingStyle() : String
      {
         if(this._encodingStyle == null)
         {
            this._encodingStyle = this.soapConstants.encodingURI;
         }
         return this._encodingStyle;
      }
      
      public function set encodingStyle(value:String) : void
      {
         this._encodingStyle = Boolean(value) ? value : this.soapConstants.encodingURI;
      }
      
      public function get message() : QName
      {
         return this._message;
      }
      
      public function set message(value:QName) : void
      {
         this._message = value;
      }
      
      public function get namespaceURI() : String
      {
         return this._namespaceURI;
      }
      
      public function set namespaceURI(value:String) : void
      {
         this._namespaceURI = value;
      }
      
      public function get parts() : Array
      {
         return this._parts;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(this._soapConstants == null)
         {
            this._soapConstants = SOAPConstants.getConstants(null);
         }
         return this._soapConstants;
      }
      
      public function get useStyle() : String
      {
         return this._useStyle;
      }
      
      public function set useStyle(value:String) : void
      {
         this._useStyle = value;
      }
      
      public function hasPart(name:String) : Boolean
      {
         var part:String = null;
         if(this._parts != null && this._parts.length > 0)
         {
            for each(part in this._parts)
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
      
      public function setParts(value:String) : void
      {
         var array:Array = null;
         var part:String = null;
         if(value != null && value.length > 0)
         {
            this._parts = [];
            array = value.split(" ");
            for each(part in array)
            {
               if(part.length > 0)
               {
                  this._parts.push(part);
               }
            }
         }
         else
         {
            this._parts = null;
         }
      }
   }
}

