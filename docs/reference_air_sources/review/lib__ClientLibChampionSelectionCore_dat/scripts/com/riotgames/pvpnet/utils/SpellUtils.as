package com.riotgames.pvpnet.utils
{
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.model.SpellSelection;
   import mx.collections.ArrayCollection;
   
   public class SpellUtils
   {
      
      public function SpellUtils()
      {
         super();
      }
      
      public static function getSelectionForSpellFromSelectionCollection(param1:Spell, param2:ArrayCollection) : SpellSelection
      {
         var _loc3_:SpellSelection = null;
         for each(_loc3_ in param2)
         {
            if(Boolean(_loc3_.spell) && _loc3_.spell.spellId == param1.spellId)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getSpellForIdFromSelectionCollection(param1:int, param2:ArrayCollection) : Spell
      {
         var _loc3_:SpellSelection = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.spell.spellId == param1)
            {
               return _loc3_.spell;
            }
         }
         return null;
      }
   }
}

