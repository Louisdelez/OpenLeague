package com.riotgames.pvpnet.invite.legacy.action
{
   import com.riotgames.notification.IDialogQueueProvider;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   
   public class NormalGameInviteAcceptAction extends BaseGameInviteAcceptAction
   {
      
      public function NormalGameInviteAcceptAction(param1:IAppController, param2:MasterGameController, param3:ILobbyViewController, param4:IDialogQueueProvider, param5:Boolean)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function doGameFlow() : void
      {
         getMasterGameController().startNormalGameFlow(false);
      }
   }
}

