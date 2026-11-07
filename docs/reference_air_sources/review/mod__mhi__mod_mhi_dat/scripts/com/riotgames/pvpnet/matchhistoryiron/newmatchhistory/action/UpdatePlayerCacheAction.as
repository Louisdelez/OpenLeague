package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   
   public class UpdatePlayerCacheAction extends BasicAction
   {
      
      private var _player:MatchHistoryPlayer;
      
      private var _model:NewMatchHistoryModel;
      
      public function UpdatePlayerCacheAction(param1:MatchHistoryPlayer, param2:NewMatchHistoryModel)
      {
         this._player = param1;
         this._model = param2;
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:MatchHistoryPlayer = null;
         super.doInvocation();
         if(!this._player || this._player.accountId == 0)
         {
            return;
         }
         _loc1_ = this._model.playerDictionary[this._player.currentAccountId];
         if(!_loc1_)
         {
            this._model.playerDictionary[this._player.currentAccountId] = this._player;
         }
         else
         {
            _loc1_.accountId = this._player.accountId;
            _loc1_.currentAccountId = this._player.currentAccountId;
            _loc1_.currentPlatformId = this._player.currentPlatformId;
            _loc1_.matchHistoryUri = this._player.matchHistoryUri;
            _loc1_.platformId = this._player.platformId;
            _loc1_.profileIcon = this._player.profileIcon;
            _loc1_.summonerName = this._player.summonerName;
         }
      }
   }
}

