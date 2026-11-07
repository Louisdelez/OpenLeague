package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   
   public class SelectRunePageCommand extends CommandBase
   {
      
      private var runeBook:SpellBookDTO;
      
      private var spellBookService:SpellBookService;
      
      private var model:ChampionSelectionModel;
      
      private var newPage:SpellBookPageDTO;
      
      public function SelectRunePageCommand(param1:ChampionSelectionModel, param2:SpellBookDTO, param3:SpellBookService, param4:SpellBookPageDTO)
      {
         super();
         this.model = param1;
         this.spellBookService = param3;
         this.newPage = param4;
         this.runeBook = param2;
      }
      
      private function onSelectRunePageError(param1:ServerError) : void
      {
         this.model.runePageSynced = true;
         onError(param1);
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this.newPage.pageId > 0)
         {
            if(this.runeBook.defaultPage != null && this.runeBook.defaultPage.pageId == this.newPage.pageId)
            {
               return;
            }
            this.model.runePageSynced = false;
            this.spellBookService.selectDefaultSpellBookPage(this.newPage,this.onSelectRunePageSuccess,onComplete,this.onSelectRunePageError);
         }
      }
      
      private function onSelectRunePageSuccess(param1:Boolean) : void
      {
         var _loc2_:SpellBookPageDTO = null;
         onResult(param1);
         if(param1)
         {
            this.model.runePageSynced = true;
            _loc2_ = this.runeBook.defaultPage;
            this.newPage.current = true;
            this.runeBook.defaultPage = this.newPage;
            if(Boolean(_loc2_))
            {
               _loc2_.current = false;
            }
         }
      }
   }
}

