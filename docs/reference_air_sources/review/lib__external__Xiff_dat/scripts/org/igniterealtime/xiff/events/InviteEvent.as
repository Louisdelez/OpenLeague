package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.conference.Room;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   
   public class InviteEvent extends Event
   {
      
      public static var INVITED:String = "invited";
      
      private var _from:UnescapedJID;
      
      private var _reason:String;
      
      private var _room:Room;
      
      private var _data:Message;
      
      public function InviteEvent()
      {
         super(INVITED);
      }
      
      public function get from() : UnescapedJID
      {
         return this._from;
      }
      
      public function set from(param1:UnescapedJID) : void
      {
         this._from = param1;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
      
      public function set reason(param1:String) : void
      {
         this._reason = param1;
      }
      
      public function get room() : Room
      {
         return this._room;
      }
      
      public function set room(param1:Room) : void
      {
         this._room = param1;
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

