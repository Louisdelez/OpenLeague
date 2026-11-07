package mx.events
{
   import flash.events.Event;
   
   public class CuePointEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CUE_POINT:String = "cuePoint";
      
      public var cuePointName:String;
      
      public var cuePointTime:Number;
      
      public var cuePointType:String;
      
      public function CuePointEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, cuePointName:String = null, cuePointTime:Number = NaN, cuePointType:String = null)
      {
         super(type,bubbles,cancelable);
         this.cuePointName = cuePointName;
         this.cuePointTime = cuePointTime;
         this.cuePointType = cuePointType;
      }
      
      override public function clone() : Event
      {
         return new CuePointEvent(type,bubbles,cancelable,this.cuePointName,this.cuePointTime,this.cuePointType);
      }
   }
}

