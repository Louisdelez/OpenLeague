package com.riotgames.platform.gameclient.commands.queueselection
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class SelectCapQueueCommand extends CommandBase
   {
      
      private var isSolo:Boolean;
      
      private var gameQueueManager:GameQueueManager;
      
      private var masterGameController:MasterGameController;
      
      private var inviteGroup:InviteGroup;
      
      private var queueId:Number;
      
      public function SelectCapQueueCommand(param1:Boolean, param2:Number, param3:MasterGameController, param4:GameQueueManager, param5:InviteGroup)
      {
         super();
         this.isSolo = param1;
         this.queueId = param2;
         this.masterGameController = param3;
         this.gameQueueManager = param4;
         this.inviteGroup = param5;
      }
      
      override public function execute() : void
      {
         this.gameQueueManager.setSelectedQueueId(this.queueId);
         this.masterGameController.isSolo = this.isSolo;
         this.masterGameController.currentState = GameViewState.CAP_STATE;
         this.inviteGroup.isGroupOpenToMembers = !this.isSolo;
         this.inviteGroup.allowedToInvite = !this.isSolo;
      }
   }
}

