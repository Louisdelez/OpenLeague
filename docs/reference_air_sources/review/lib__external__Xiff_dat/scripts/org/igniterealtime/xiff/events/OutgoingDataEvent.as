package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class OutgoingDataEvent extends Event
   {
      
      public static var OUTGOING_DATA:String = "outgoingData";
      
      private var _data:*;
      
      public function OutgoingDataEvent()
      {
         super(OutgoingDataEvent.OUTGOING_DATA,false,false);
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
   }
}

