package mx.rpc.events
{
   import flash.events.Event;
   
   public class XMLLoadEvent extends Event
   {
      
      public static const LOAD:String = "xmlLoad";
      
      public var xml:XML;
      
      public var location:String;
      
      public function XMLLoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, xml:XML = null, location:String = null)
      {
         super(type == null ? LOAD : type,bubbles,cancelable);
         this.xml = xml;
         this.location = location;
      }
      
      public static function createEvent(xml:XML = null, location:String = null) : XMLLoadEvent
      {
         return new XMLLoadEvent(LOAD,false,true,xml,location);
      }
      
      override public function clone() : Event
      {
         return new XMLLoadEvent(type,bubbles,cancelable,this.xml,this.location);
      }
      
      override public function toString() : String
      {
         return formatToString("XMLLoadEvent","location","type","bubbles","cancelable","eventPhase");
      }
   }
}

