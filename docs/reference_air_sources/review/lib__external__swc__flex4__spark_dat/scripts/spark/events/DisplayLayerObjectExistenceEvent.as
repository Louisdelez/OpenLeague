package spark.events
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   [ExcludeClass]
   public class DisplayLayerObjectExistenceEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const OBJECT_ADD:String = "objectAdd";
      
      public static const OBJECT_REMOVE:String = "objectRemove";
      
      public var index:int;
      
      public var object:DisplayObject;
      
      public function DisplayLayerObjectExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, object:DisplayObject = null, index:int = -1)
      {
         super(type,bubbles,cancelable);
         this.object = object;
         this.index = index;
      }
      
      override public function clone() : Event
      {
         return new DisplayLayerObjectExistenceEvent(type,bubbles,cancelable,this.object,this.index);
      }
   }
}

