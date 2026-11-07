package mx.rpc.events
{
   import flash.events.Event;
   import mx.rpc.wsdl.WSDL;
   
   [ExcludeClass]
   public class WSDLLoadEvent extends XMLLoadEvent
   {
      
      public static const LOAD:String = "wsdlLoad";
      
      public var wsdl:WSDL;
      
      public function WSDLLoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, wsdl:WSDL = null, location:String = null)
      {
         super(type == null ? LOAD : type,bubbles,cancelable,wsdl == null ? null : wsdl.xml,location);
         this.wsdl = wsdl;
      }
      
      public static function createEvent(wsdl:WSDL, location:String = null) : WSDLLoadEvent
      {
         return new WSDLLoadEvent(LOAD,false,true,wsdl,location);
      }
      
      override public function clone() : Event
      {
         return new WSDLLoadEvent(type,bubbles,cancelable,wsdl,location);
      }
      
      override public function toString() : String
      {
         return formatToString("WSDLLoadEvent","location","type","bubbles","cancelable","eventPhase");
      }
   }
}

