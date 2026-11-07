package com.riotgames.pvpnet.matchhistoryiron.controller.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryPlayerModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import mx.collections.ArrayCollection;
   import mx.rpc.events.ResultEvent;
   
   public class GetSummonerNameAction extends BasicAction
   {
      
      private var _summonerService:SummonerService;
      
      private var _model:MatchHistoryStatModel;
      
      private var _playerIdList:Array;
      
      public function GetSummonerNameAction(param1:MatchHistoryStatModel, param2:SummonerService)
      {
         super(false);
         this._summonerService = param2;
         this._model = param1;
         this._playerIdList = this.getSummonerId();
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._summonerService.getSummonerNames(this._playerIdList,this.onSummonerNameReceived,this.onSummonerNameComplete);
      }
      
      private function onSummonerNameReceived(param1:ResultEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         var _loc4_:int = 0;
         if(this._model.teamList)
         {
            _loc3_ = 0;
            while(_loc3_ < this._model.teamList.length)
            {
               if(!this._model.teamList[_loc3_].isYou)
               {
                  this._model.teamList[_loc3_].summonerName = _loc2_.getItemAt(_loc4_) as String;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         if(this._model.otherTeamList)
         {
            _loc3_ = 0;
            while(_loc3_ < this._model.otherTeamList.length)
            {
               if(!this._model.otherTeamList[_loc3_].isYou)
               {
                  this._model.otherTeamList[_loc3_].summonerName = _loc2_.getItemAt(_loc4_) as String;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         this._model.setAsReady();
      }
      
      private function onSummonerNameComplete(param1:Object = null) : void
      {
         complete();
      }
      
      private function getSummonerId() : Array
      {
         var _loc1_:Array = new Array();
         if(Boolean(this._model) && Boolean(this._model.teamList))
         {
            _loc1_ = _loc1_.concat(this.getSummonerIdByTeam(this._model.teamList));
         }
         if(Boolean(this._model) && Boolean(this._model.otherTeamList))
         {
            _loc1_ = _loc1_.concat(this.getSummonerIdByTeam(this._model.otherTeamList));
         }
         return _loc1_;
      }
      
      private function getSummonerIdByTeam(param1:Vector.<MatchHistoryPlayerModel>) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(!param1[_loc3_].isYou)
            {
               _loc2_.push(param1[_loc3_].summonerId);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

