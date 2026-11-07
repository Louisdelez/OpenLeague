package com.riotgames.pvpnet.cap.model
{
   import mx.collections.ArrayCollection;
   
   public interface ISpellModel
   {
      
      function set allSpells(param1:ArrayCollection) : void;
      
      function get spellsBusy() : Boolean;
      
      function get allSpells() : ArrayCollection;
      
      function set spellsBusy(param1:Boolean) : void;
   }
}

