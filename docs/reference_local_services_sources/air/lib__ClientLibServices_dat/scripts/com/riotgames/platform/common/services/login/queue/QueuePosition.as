package com.riotgames.platform.common.services.login.queue
{
   public class QueuePosition
   {
      
      private var _timestamp:Date = new Date();
      
      private var _positions:Object = {};
      
      private var _backlog:int = 0;
      
      public function QueuePosition()
      {
         super();
      }
      
      public function set backlog(param1:int) : void
      {
         this._backlog = param1;
      }
      
      public function get backlog() : int
      {
         return this._backlog;
      }
      
      public function get positions() : Object
      {
         return this._positions;
      }
      
      public function get timestamp() : Date
      {
         return this._timestamp;
      }
   }
}

