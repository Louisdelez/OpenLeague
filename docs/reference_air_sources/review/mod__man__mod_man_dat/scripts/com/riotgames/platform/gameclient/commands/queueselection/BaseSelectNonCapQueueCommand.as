package com.riotgames.platform.gameclient.commands.queueselection
{
   import blix.action.IAction;
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   
   public class BaseSelectNonCapQueueCommand extends CommandBase
   {
      
      protected var isSolo:Boolean;
      
      protected var queueId:Number;
      
      protected var gameQueueManager:GameQueueManager;
      
      protected var masterGameController:MasterGameController;
      
      protected var inviteProvider:IInviteProvider;
      
      public function BaseSelectNonCapQueueCommand(param1:Boolean, param2:Number, param3:MasterGameController, param4:GameQueueManager, param5:IInviteProvider)
      {
         super();
         this.isSolo = param1;
         this.queueId = param2;
         this.masterGameController = param3;
         this.inviteProvider = param5;
         this.gameQueueManager = param4;
      }
      
      protected function doGameFlow() : void
      {
      }
      
      override public function execute() : void
      {
         var _loc2_:IAction = null;
         this.doGameFlow();
         this.gameQueueManager.setSelectedQueueId(this.queueId);
         this.masterGameController.gameModel.allowFreeChampions = !this.gameQueueManager.selectedGameQueueConfig.disallowFreeChampions;
         this.masterGameController.masterGameViewController.handleSelectMapContinue();
         var _loc1_:GameQueueConfig = this.gameQueueManager.getQueueForID(this.queueId);
         if(_loc1_.teamOnly)
         {
            _loc2_ = this.inviteProvider.getOpenInvitePanelAction();
            _loc2_.invoke();
         }
      }
   }
}

