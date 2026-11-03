package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class CuePointEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const CUE_POINT:String = "cuePoint";
      
      public var cuePointType:String;
      
      public var cuePointName:String;
      
      public var cuePointTime:Number;
      
      public function CuePointEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, cuePointName:String = null, cuePointTime:Number = NaN, cuePointType:String = null)
      {
         super(type,bubbles,cancelable);
         this.cuePointName = cuePointName;
         this.cuePointTime = cuePointTime;
         this.cuePointType = cuePointType;
      }
      
      override public function clone() : Event
      {
         return new CuePointEvent(type,bubbles,cancelable,cuePointName,cuePointTime,cuePointType);
      }
   }
}

