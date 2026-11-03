package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   import mx.resources.ResourceManager;
   
   public class CheckRankedRestrictionAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function CheckRankedRestrictionAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:AllSummonerData = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:AlertAction = null;
         if(this._initialClientData.loginDataPacket.reconnectInfo == null)
         {
            _loc1_ = Number(this._initialClientData.loginDataPacket.restrictedGamesRemainingForRanked);
            _loc2_ = this._initialClientData.loginDataPacket.allSummonerData;
            _loc3_ = 0;
            if(Boolean(_loc2_) && Boolean(_loc2_.summonerLevel))
            {
               _loc3_ = Number(_loc2_.summonerLevel.summonerLevel);
            }
            if(_loc1_ > 0 && _loc3_ >= 30)
            {
               Session.instance.rankedRestrictedGamesRemaining = _loc1_;
               _loc4_ = "restrictedRanked_login_title_plural";
               if(_loc1_ == 1)
               {
                  _loc4_ = "restrictedRanked_login_title";
               }
               _loc5_ = new AlertAction(ResourceManager.getInstance().getString("resources",_loc4_,[_loc1_]),ResourceManager.getInstance().getString("resources","restrictedRanked_login_message"));
               _loc5_.add();
            }
         }
         complete();
      }
   }
}

