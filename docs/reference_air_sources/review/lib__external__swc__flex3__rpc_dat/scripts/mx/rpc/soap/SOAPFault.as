package mx.rpc.soap
{
   import mx.rpc.Fault;
   
   public class SOAPFault extends Fault
   {
      
      public var faultactor:String;
      
      public var element:XML;
      
      public var faultcode:QName;
      
      public function SOAPFault(faultCode:QName, faultString:String, detail:String = null, element:XML = null, faultactor:String = null)
      {
         super(faultCode.localName,faultString,detail);
         this.element = element;
         this.faultactor = faultactor;
         this.faultcode = faultCode;
      }
      
      public function get detail() : String
      {
         return _faultDetail;
      }
      
      public function set detail(value:String) : void
      {
         _faultDetail = value;
      }
      
      override public function toString() : String
      {
         return "SOAPFault (" + faultCode + "): " + faultString + " " + faultDetail;
      }
      
      public function get faultstring() : String
      {
         return _faultString;
      }
      
      public function set faultstring(value:String) : void
      {
         _faultString = value;
      }
   }
}

