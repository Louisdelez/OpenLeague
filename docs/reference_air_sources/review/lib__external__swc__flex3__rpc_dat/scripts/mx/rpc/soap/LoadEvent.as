package mx.rpc.soap
{
   import flash.events.Event;
   import flash.xml.XMLDocument;
   import mx.rpc.events.WSDLLoadEvent;
   import mx.rpc.wsdl.WSDL;
   
   public class LoadEvent extends WSDLLoadEvent
   {
      
      public static const LOAD:String = "load";
      
      private var _document:XMLDocument;
      
      public function LoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, wsdl:WSDL = null, location:String = null)
      {
         super(type == null ? LOAD : type,bubbles,cancelable,wsdl,location);
      }
      
      public static function createEvent(wsdl:WSDL, location:String = null) : LoadEvent
      {
         return new LoadEvent(LOAD,false,true,wsdl,location);
      }
      
      [Deprecated(replacement="xml")]
      public function get document() : XMLDocument
      {
         if(_document == null && xml != null)
         {
            try
            {
               _document = new XMLDocument(xml.toXMLString());
            }
            catch(e:Error)
            {
            }
         }
         return _document;
      }
      
      override public function toString() : String
      {
         return formatToString("LoadEvent","location","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new LoadEvent(type,bubbles,cancelable,wsdl,location);
      }
   }
}

