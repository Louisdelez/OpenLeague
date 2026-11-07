package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class PresenceEvent extends Event
   {
      
      public static var PRESENCE:String = "presence";
      
      private var _data:Array;
      
      public function PresenceEvent()
      {
         super(PresenceEvent.PRESENCE,bubbles,cancelable);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
      }
   }
}

