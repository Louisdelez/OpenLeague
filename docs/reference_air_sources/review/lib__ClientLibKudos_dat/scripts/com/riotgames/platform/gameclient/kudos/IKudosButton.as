package com.riotgames.platform.gameclient.kudos
{
   import flash.events.IEventDispatcher;
   
   public interface IKudosButton extends IEventDispatcher
   {
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function cleanup() : void;
   }
}

