package com.riotgames.platform.gameclient.controllers.game.commands
{
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.core.IFlexDisplayObject;
   
   public interface ISpellSelectDialog extends IEventDispatcher, IFlexDisplayObject
   {
      
      function set chooseBoth(param1:Boolean) : void;
      
      function set spellProvider(param1:ArrayCollection) : void;
      
      function set spellIndex(param1:uint) : void;
      
      function get chooseBoth() : Boolean;
      
      function get spellProvider() : ArrayCollection;
      
      function get spellIndex() : uint;
   }
}

