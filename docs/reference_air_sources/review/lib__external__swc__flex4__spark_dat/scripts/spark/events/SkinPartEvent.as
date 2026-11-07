package spark.events
{
   import flash.events.Event;
   
   [ExcludeClass]
   public class SkinPartEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const PART_ADDED:String = "partAdded";
      
      public static const PART_REMOVED:String = "partRemoved";
      
      public var instance:Object;
      
      public var partName:String;
      
      public function SkinPartEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, partName:String = null, instance:Object = null)
      {
         super(type,bubbles,cancelable);
         this.partName = partName;
         this.instance = instance;
      }
      
      override public function clone() : Event
      {
         return new SkinPartEvent(type,bubbles,cancelable,this.partName,this.instance);
      }
   }
}

