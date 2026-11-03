package com.riotgames.pvpnet.queuerestriction.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.QueueRestrictionService;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.queuerestriction.QueueRestrictionCacheItem;
   import com.riotgames.platform.gameclient.domain.queuerestriction.QueueRestrictionResponse;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionCache;
   import com.riotgames.pvpnet.queuerestriction.configurations.QueueRestrictionConfiguration;
   import com.riotgames.pvpnet.queuerestriction.controller.RankedDuoQueueRestrictionProcessor;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class ProcessQueueRestrictionsActions extends BasicAction
   {
      
      private var _bypassCache:Boolean;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _rosterItems:Array;
      
      private var _queueRestrictionService:QueueRestrictionService;
      
      public function ProcessQueueRestrictionsActions(param1:Array, param2:QueueRestrictionCache, param3:QueueRestrictionService, param4:InviteQueueManager, param5:IChatRosterProvider, param6:Boolean)
      {
         super(false);
         this._rosterItems = param1;
         this._queueRestrictionCache = param2;
         this._queueRestrictionService = param3;
         this._inviteQueueManager = param4;
         this._chatRosterProvider = param5;
         this._bypassCache = param6;
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:RosterItemVO = null;
         var _loc3_:Number = NaN;
         var _loc4_:QueueRestrictionCacheItem = null;
         var _loc1_:Array = new Array();
         if(QueueRestrictionConfiguration.isQueueRestrictionRequired(this._inviteQueueManager.getSelectedGameQueueConfig()))
         {
            for each(_loc2_ in this._rosterItems)
            {
               if(RosterUtility.isOnlineAndAvailableForInvite(_loc2_))
               {
                  _loc3_ = Number(RosterUtility.summonerIdFromJID(_loc2_.jid));
                  _loc4_ = this._bypassCache ? null : new RankedDuoQueueRestrictionProcessor(_loc2_,this._queueRestrictionCache.getQueueRestrictionCacheItem(_loc3_)).process();
                  if((Boolean(_loc4_)) && this.isBuddy(_loc3_))
                  {
                     this._queueRestrictionCache.addOrUpdateQueueRestrictionCacheItem(_loc4_);
                     _loc2_.isDuoQueueRestricted = !_loc4_.getRankedDuoQueueEligibility();
                     _loc2_.isRankedRestricted = _loc4_.getIsRankedRestricted();
                  }
                  else
                  {
                     _loc1_.push(_loc3_);
                  }
               }
            }
         }
         if(_loc1_.length > 0)
         {
            this._queueRestrictionService.getQueueRestrictions(this._inviteQueueManager.getSelectedGameQueueConfigId(),_loc1_,this.onServiceSuccess,null,this.onServiceError);
         }
         else
         {
            complete();
         }
      }
      
      private function onServiceSuccess(param1:ResultEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:RosterItemVO = null;
         var _loc5_:PresenceStatusData = null;
         var _loc6_:QueueRestrictionCacheItem = null;
         var _loc2_:QueueRestrictionResponse = param1.result as QueueRestrictionResponse;
         if(_loc2_)
         {
            for(_loc3_ in _loc2_.eligibilityMap)
            {
               if(Session.instance.getSummonerId() != Number(_loc3_))
               {
                  _loc4_ = RosterUtility.getRosterItemVoFromJID(ChatController.unescapedJIDFromSummonerId(Number(_loc3_)).bareJID);
                  _loc5_ = PresenceController.getPresenceData(_loc4_.status);
                  _loc6_ = this._queueRestrictionCache.getQueueRestrictionCacheItem(Number(_loc3_));
                  if(!_loc6_)
                  {
                     _loc6_ = new QueueRestrictionCacheItem(Number(_loc3_));
                  }
                  if(_loc5_.rankedLeagueQueueType == QueueType.RANKED_SOLO_5x5)
                  {
                     _loc6_.setLastCheckedTier(LeagueCache.tierToValue(LeagueTier.valueOf(_loc5_.rankedLeagueTier)));
                     _loc6_.setLastCheckedRank(LeagueCache.rankToValue(LeagueRank.valueOf(_loc5_.rankedLeagueDivision)));
                  }
                  _loc6_.setRankedDuoQueueEligibility(_loc2_.eligibilityMap[_loc3_] != "DUO_QUEUE_LIMITED");
                  _loc6_.setIsRankedRestricted(_loc2_.eligibilityMap[_loc3_] == "RANKED_RESTRICTION");
                  this._queueRestrictionCache.addOrUpdateQueueRestrictionCacheItem(_loc6_);
                  _loc4_.isDuoQueueRestricted = !_loc6_.getRankedDuoQueueEligibility();
                  _loc4_.isRankedRestricted = _loc6_.getIsRankedRestricted();
               }
            }
         }
         else
         {
            this.logger.error("Did not receive a valid response trying to retrieve queueRestrictions!");
         }
         complete();
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         this.logger.error("Error trying to retrieve queueRestrictions with error=" + param1);
         complete();
      }
      
      private function isBuddy(param1:Number) : Boolean
      {
         return this._chatRosterProvider.getBuddyBySummonerId(param1) != null;
      }
   }
}

