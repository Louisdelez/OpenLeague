package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   
   public class SpellBookServiceImpl extends BaseLcdsService implements SpellBookService
   {
      
      public function SpellBookServiceImpl()
      {
         super();
      }
      
      public function getSpellBook(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("spellBookService","getSpellBook",[param1],param2,param3);
      }
      
      public function saveSpellBook(param1:SpellBookDTO, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("spellBookService","saveSpellBook",[param1],param2,param3);
      }
      
      public function selectDefaultSpellBookPage(param1:SpellBookPageDTO, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("spellBookService","selectDefaultSpellBookPage",[param1],param2,param3);
      }
   }
}

