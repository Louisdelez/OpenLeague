package com.riotgames.pvpnet.contextualeducation.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ContextualEducationTipModel extends EventDispatcher
   {
      
      private var _body:String = "";
      
      private var _header:String = "";
      
      public function ContextualEducationTipModel()
      {
         super();
      }
      
      public function get body() : String
      {
         return this._body;
      }
      
      public function setHeaderAndBody(param1:String, param2:String) : void
      {
         this._header = param1;
         this._body = param2;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get header() : String
      {
         return this._header;
      }
   }
}

