package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import mx.rpc.events.ResultEvent;
   
   public class GetPublicSummonerByNameAction extends BasicAction
   {
      
      private var _service:SummonerService;
      
      private var _summonerName:String;
      
      public function GetPublicSummonerByNameAction(param1:String, param2:SummonerService)
      {
         super(false);
         this._summonerName = param1;
         this._service = param2;
      }
      
      protected function handlePublicSummonerRequestComplete(param1:ResultEvent) : void
      {
      }
      
      protected function handlePublicSummonerRequestSuccess(param1:ResultEvent) : void
      {
         var _loc2_:PublicSummoner = param1.result as PublicSummoner;
         var _loc3_:String = param1.token.args[0];
         _completed.dispatch(_loc3_,_loc2_);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._service.getSummonerByName(this._summonerName,this.handlePublicSummonerRequestSuccess,this.handlePublicSummonerRequestComplete);
      }
   }
}

