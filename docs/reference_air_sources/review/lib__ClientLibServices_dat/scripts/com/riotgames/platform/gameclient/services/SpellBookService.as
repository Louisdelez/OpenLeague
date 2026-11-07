package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   
   public interface SpellBookService
   {
      
      function selectDefaultSpellBookPage(param1:SpellBookPageDTO, param2:Function, param3:Function, param4:Function) : void;
      
      function getSpellBook(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function saveSpellBook(param1:SpellBookDTO, param2:Function, param3:Function, param4:Function) : void;
   }
}

