package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   
   public class SearchPrepEvent extends Event
   {
      
      public static const SEARCH_PREP_COMPLETE:String = "searchPrepComplete";
      
      private var _server:String;
      
      public function SearchPrepEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get server() : String
      {
         return this._server;
      }
      
      public function set server(param1:String) : void
      {
         this._server = param1;
      }
   }
}

