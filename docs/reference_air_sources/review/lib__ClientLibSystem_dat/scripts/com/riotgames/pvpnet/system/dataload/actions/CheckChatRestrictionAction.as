package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   import mx.resources.ResourceManager;
   
   public class CheckChatRestrictionAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function CheckChatRestrictionAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:String = null;
         var _loc3_:AlertAction = null;
         if(this._initialClientData.loginDataPacket.reconnectInfo == null)
         {
            _loc1_ = Number(this._initialClientData.loginDataPacket.restrictedChatGamesRemaining);
            if(_loc1_ > 0)
            {
               _loc2_ = "restrictedChat_login_title_plural";
               if(_loc1_ == 1)
               {
                  _loc2_ = "restrictedChat_login_title";
               }
               _loc3_ = new AlertAction(ResourceManager.getInstance().getString("resources",_loc2_,[_loc1_]),ResourceManager.getInstance().getString("resources","restrictedChat_login_message"));
               _loc3_.add();
            }
         }
         complete();
      }
   }
}

