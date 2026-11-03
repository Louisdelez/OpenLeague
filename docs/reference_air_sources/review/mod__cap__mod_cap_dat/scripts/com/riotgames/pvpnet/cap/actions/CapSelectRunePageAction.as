package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import mx.rpc.events.ResultEvent;
   
   public class CapSelectRunePageAction extends BasicAction
   {
      
      private var _runeBook:SpellBookDTO;
      
      private var _player:CapPlayerSelection;
      
      private var _runePage:SpellBookPageDTO;
      
      private var _service:SpellBookService;
      
      private var _lastRunePage:SpellBookPageDTO;
      
      public function CapSelectRunePageAction(param1:SpellBookService, param2:SpellBookDTO, param3:SpellBookPageDTO, param4:CapPlayerSelection)
      {
         super(false);
         this._runeBook = param2;
         this._runePage = param3;
         this._player = param4;
         this._service = param1;
      }
      
      private function onError(param1:ResultEvent) : void
      {
         this._player.runePage = this._lastRunePage;
         err(new Error());
      }
      
      private function onSuccess(param1:ResultEvent) : void
      {
         this._player.runePage = this._runePage;
         this._runeBook.defaultPage = this._runePage;
         complete();
      }
      
      override protected function doInvocation() : void
      {
         this._lastRunePage = this._player.runePage;
         this._service.selectDefaultSpellBookPage(this._runePage,this.onSuccess,null,this.onError);
      }
   }
}

