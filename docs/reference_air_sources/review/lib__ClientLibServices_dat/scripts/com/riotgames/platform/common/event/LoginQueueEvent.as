package com.riotgames.platform.common.event
{
   import flash.events.Event;
   
   public class LoginQueueEvent extends Event
   {
      
      public static const POSITION_CHANGED:String = "positionChanged";
      
      private var _depth:int;
      
      public var isCapped:Boolean;
      
      private var _millisLeft:Number;
      
      private var _loginsPerSecond:int;
      
      public var delta:int;
      
      public var nextUpdate:int;
      
      private var _timestamp:Date;
      
      public function LoginQueueEvent(param1:int, param2:Date, param3:int, param4:Number, param5:int, param6:Boolean, param7:int)
      {
         super(POSITION_CHANGED);
         this._depth = param1;
         this._timestamp = param2;
         this._loginsPerSecond = param3;
         this._millisLeft = param4;
         this.delta = param5;
         this.isCapped = param6;
         this.nextUpdate = param7;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      public function get loginsPerSecond() : int
      {
         return this._loginsPerSecond;
      }
      
      public function get millisLeft() : Number
      {
         return this._millisLeft;
      }
      
      public function get timestamp() : Date
      {
         return this._timestamp;
      }
   }
}

