package com.riotgames.platform.gameclient.commands.queueselection
{
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   
   public class SelectNormalQueueCommand extends BaseSelectNonCapQueueCommand
   {
      
      public function SelectNormalQueueCommand(param1:Boolean, param2:Number, param3:MasterGameController, param4:GameQueueManager, param5:IInviteProvider)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function doGameFlow() : void
      {
         masterGameController.startNormalGameFlow(isSolo);
      }
   }
}

