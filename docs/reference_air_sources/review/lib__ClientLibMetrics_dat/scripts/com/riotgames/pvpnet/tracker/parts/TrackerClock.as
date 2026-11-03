package com.riotgames.pvpnet.tracker.parts
{
   import flash.utils.getTimer;
   
   public class TrackerClock implements IClock
   {
      
      public var _isUTCmode:Boolean;
      
      public function TrackerClock(param1:Boolean = false)
      {
         super();
         this.isUTCmode = param1;
      }
      
      public function getNow() : Number
      {
         if(this.isUTCmode)
         {
            return new Date().getTime();
         }
         return getTimer();
      }
      
      public function get isUTCmode() : Boolean
      {
         return this._isUTCmode;
      }
      
      public function set isUTCmode(param1:Boolean) : void
      {
         this._isUTCmode = param1;
      }
   }
}

