package com.riotgames.platform.common.state
{
   import blix.IDestructible;
   
   public interface IState extends IDestructible
   {
      
      function onUpdate() : void;
      
      function onEnter() : void;
      
      function get name() : String;
      
      function onExit() : void;
   }
}

