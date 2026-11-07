package com.riotgames.platform.gameclient.domain
{
   import flash.events.EventDispatcher;
   
   public class AbstractEventDispatchingDomainObject extends EventDispatcher
   {
      
      public function AbstractEventDispatchingDomainObject()
      {
         super();
      }
      
      public function set futureData(param1:*) : void
      {
      }
      
      public function set dataVersion(param1:*) : void
      {
      }
      
      public function get futureData() : *
      {
         return null;
      }
      
      public function get dataVersion() : *
      {
         return null;
      }
   }
}

