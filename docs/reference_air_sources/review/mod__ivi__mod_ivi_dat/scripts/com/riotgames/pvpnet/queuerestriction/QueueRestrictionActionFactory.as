package com.riotgames.pvpnet.queuerestriction
{
   import com.riotgames.platform.common.services.QueueRestrictionService;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.queuerestriction.action.FilterIneligibleQueuePartnersAction;
   import com.riotgames.pvpnet.queuerestriction.action.ProcessQueueRestrictionsActions;
   
   public class QueueRestrictionActionFactory
   {
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var _queueRestrictionService:QueueRestrictionService;
      
      public function QueueRestrictionActionFactory(param1:QueueRestrictionCache, param2:QueueRestrictionService, param3:InviteQueueManager, param4:IChatRosterProvider)
      {
         super();
         this._queueRestrictionCache = param1;
         this._queueRestrictionService = param2;
         this._inviteQueueManager = param3;
         this._chatRosterProvider = param4;
      }
      
      public function getProcessQueueRestrictionsAction(param1:Array, param2:Boolean = false) : ProcessQueueRestrictionsActions
      {
         return new ProcessQueueRestrictionsActions(param1,this._queueRestrictionCache,this._queueRestrictionService,this._inviteQueueManager,this._chatRosterProvider,param2);
      }
      
      public function getFilterIneligibleQueuePartnersAction(param1:Array) : FilterIneligibleQueuePartnersAction
      {
         return new FilterIneligibleQueuePartnersAction(param1,this,this._queueRestrictionCache);
      }
   }
}

