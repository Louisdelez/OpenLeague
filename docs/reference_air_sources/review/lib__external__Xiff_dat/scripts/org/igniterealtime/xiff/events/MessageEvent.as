package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.Message;
   
   public class MessageEvent extends Event
   {
      
      public static var MESSAGE:String = "message";
      
      private var _data:Message;
      
      public function MessageEvent()
      {
         super(MessageEvent.MESSAGE,false,false);
      }
      
      public function get data() : Message
      {
         return this._data;
      }
      
      public function set data(param1:Message) : void
      {
         this._data = param1;
      }
   }
}

