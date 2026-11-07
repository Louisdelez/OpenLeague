package com.riotgames.pvpnet.tracker.parts
{
   import flash.events.EventDispatcher;
   import flash.net.registerClassAlias;
   
   public class NamedValue extends EventDispatcher
   {
      
      private static const REG:* = registerClassAlias("com.riotgames.pvpnet.tracker.parts.NamedValue",NamedValue);
      
      public var id:Number = 0;
      
      public var name:String = "Record";
      
      protected var val:Number = 0;
      
      public var dispatchEventsEnabled:Boolean = true;
      
      public function NamedValue(param1:String = "Record", param2:Number = 0)
      {
         super();
         this.name = param1;
         this.val = param2;
      }
      
      public function get position() : Number
      {
         return this.val;
      }
      
      public function set position(param1:Number) : void
      {
         var _loc2_:DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGED);
         _loc2_.oldVal = this.val;
         _loc2_.currentVal = param1;
         this.val = param1;
         dispatchEvent(_loc2_);
      }
      
      public function increment(param1:Number = 1) : void
      {
         this.val += param1;
      }
      
      public function decrement(param1:Number = 1) : void
      {
         this.val -= param1;
      }
      
      public function clone() : NamedValue
      {
         var _loc1_:NamedValue = new NamedValue(String(this.name),Number(this.val));
         _loc1_.id = Number(this.id);
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return "" + this.name + "@" + this.val;
      }
   }
}

