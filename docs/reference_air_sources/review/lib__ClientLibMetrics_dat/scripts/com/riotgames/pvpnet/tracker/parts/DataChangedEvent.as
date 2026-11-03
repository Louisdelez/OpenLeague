package com.riotgames.pvpnet.tracker.parts
{
   import flash.events.Event;
   
   public class DataChangedEvent extends Event
   {
      
      public static const DATA_CHANGED:String = "dataChanged";
      
      public static const PRE_DATA_CHANGED:String = "preDataChanged";
      
      public var propertyName:String;
      
      public var oldVal:Object;
      
      public var currentVal:Object;
      
      public var isCancelled:Boolean = false;
      
      public function DataChangedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function stopPropagation() : void
      {
         this.isCancelled = true;
         super.stopPropagation();
      }
      
      override public function stopImmediatePropagation() : void
      {
         this.isCancelled = true;
         super.stopImmediatePropagation();
      }
      
      override public function clone() : Event
      {
         var _loc1_:DataChangedEvent = new DataChangedEvent(type,bubbles,cancelable);
         _loc1_.propertyName = this.propertyName;
         _loc1_.oldVal = this.oldVal;
         _loc1_.currentVal = this.currentVal;
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return "DataChangedEvent phase " + this.type + " from " + this.oldVal + " to: " + this.currentVal;
      }
   }
}

