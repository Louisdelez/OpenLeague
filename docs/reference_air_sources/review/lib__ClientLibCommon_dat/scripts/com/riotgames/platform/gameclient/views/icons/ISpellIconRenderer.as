package com.riotgames.platform.gameclient.views.icons
{
   import com.riotgames.platform.gameclient.domain.Spell;
   
   public interface ISpellIconRenderer extends IIconRenderer
   {
      
      function loadSpellImage(param1:Spell) : void;
      
      function loadSpellImageById(param1:int) : void;
   }
}

