package com.riotgames.pvpnet.invite.legacy.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   
   public class BeingGameFlowAction extends BasicAction
   {
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _teamName:String = "";
      
      private var _gameType:String = "";
      
      private var _gameDifficulty:String = "";
      
      private var _queueId:int;
      
      private var _mapId:int = 0;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _teamId:String = "";
      
      public function BeingGameFlowAction(param1:int, param2:String, param3:String, param4:String, param5:String, param6:int, param7:InviteQueueManager, param8:PlatformInviteActionFactory)
      {
         super(false);
         this._queueId = param1;
         this._gameDifficulty = param2;
         this._teamName = param3;
         this._teamId = param4;
         this._gameType = param5;
         this._mapId = param6;
         this._inviteQueueManager = param7;
         this._inviteActionFactory = param8;
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:IAction = null;
         if(this._gameType != GameType.CUSTOM_GAME && this._gameType != GameType.PRACTICE_GAME)
         {
            this._inviteQueueManager.setSelectedGameQueueConfigById(this._queueId);
            this._inviteQueueManager.setRankedTeamName(this._teamName);
            this._inviteQueueManager.setRankedTeamId(this._teamId);
         }
         this._inviteQueueManager.setGameDifficulty(this._gameDifficulty);
         this._inviteQueueManager.setGameMapById(this._mapId);
         this._inviteQueueManager.setGameType(this._gameType);
         var _loc1_:Boolean = this._inviteQueueManager.isCapGame();
         switch(this._gameType)
         {
            case GameType.NORMAL_GAME:
               _loc2_ = this._inviteActionFactory.getNormalGameInviteAcceptAction(_loc1_);
               break;
            case GameType.RANKED_TEAM_GAME:
            case GameType.RANKED_GAME_PREMADE:
               _loc2_ = this._inviteActionFactory.getRankedGameInviteAcceptAction(_loc1_);
               break;
            case GameType.COOP_VS_AI:
               _loc2_ = this._inviteActionFactory.getCoopVsAIGameInviteAcceptAction(_loc1_);
               break;
            case GameType.CUSTOM_GAME:
            case GameType.PRACTICE_GAME:
               _loc2_ = this._inviteActionFactory.getPracticeGameInviteAcceptAction(this._mapId);
               break;
            default:
               _loc2_ = this._inviteActionFactory.getNormalGameInviteAcceptAction(_loc1_);
         }
         _loc2_.invoke();
      }
   }
}

