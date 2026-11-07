package com.riotgames.pvpnet.queuerestriction.controller
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.services.ILeagueCache;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.controller.PlatformInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionActionFactory;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionCache;
   import com.riotgames.pvpnet.queuerestriction.action.FilterIneligibleQueuePartnersAction;
   import com.riotgames.pvpnet.queuerestriction.configurations.QueueRestrictionConfiguration;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class QueueRestrictionController implements IQueueRestrictionController
   {
      
      private var _queueRestrictionActionFactory:QueueRestrictionActionFactory;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _active:Boolean = false;
      
      private var _inviteController:PlatformInviteController;
      
      private var _inviteGroup:InviteGroup;
      
      public function QueueRestrictionController(param1:PlatformInviteController, param2:InviteQueueManager, param3:InviteGroup, param4:IChatRosterProvider, param5:QueueRestrictionCache, param6:QueueRestrictionActionFactory)
      {
         super();
         this._inviteController = param1;
         this._inviteQueueManager = param2;
         this._inviteGroup = param3;
         this._chatRosterProvider = param4;
         this._queueRestrictionCache = param5;
         this._queueRestrictionActionFactory = param6;
      }
      
      public static function getRankedDuoQueueRestrictedText(param1:Session, param2:ILeagueCache) : String
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(Boolean(param1.summoner) && Boolean(param2))
         {
            _loc3_ = Boolean(param1.summoner.previousSeasonHighestTier) && param1.summoner.previousSeasonHighestTier != Summoner.TIER_UNRANKED ? param1.summoner.previousSeasonHighestTier : QueueRestrictionConfiguration.getDefaultUnseededTier();
            _loc4_ = param2.getTierRangeWithinMyTierForQueue(QueueType.RANKED_SOLO_5x5,QueueRestrictionConfiguration.getRankedDuoQueueRestrictionMaxDelta(),_loc3_);
            _loc5_ = RiotResourceLoader.getString("leagues_rank_" + _loc4_[0].value());
            _loc6_ = RiotResourceLoader.getString("leagues_rank_" + _loc4_[1].value());
            _loc7_ = "**Please select a Duo Partner between " + _loc5_ + " and " + _loc6_ + ".";
            return RiotResourceLoader.getString("queue_restriction_tooltip",_loc7_,[_loc5_,_loc6_]);
         }
         return RiotResourceLoader.getString("queue_restriction_ineligible_partner_title");
      }
      
      public function disconnectListeners() : void
      {
         this._inviteController.getLobbyCreatedSignal().remove(this.activate);
         this._inviteController.getOwnerChangedSignal().remove(this.handleOwnerChanged);
         this._inviteController.getInvitePrivilegeChangedSignal().remove(this.handleInvitePrivilegeChanged);
         this._inviteController.getQuitLobbySignal().remove(this.deactivate);
      }
      
      private function handleOwnerChanged(param1:Object) : void
      {
         if(param1 is Boolean && param1 as Boolean)
         {
            this.activate();
         }
      }
      
      public function deactivate() : void
      {
         if(this._active)
         {
            this._active = false;
            this._chatRosterProvider.getRosterPresenceUpdatedSignal().remove(this.handleRosterPresenceUpdated);
            this._chatRosterProvider.getBuddyRemovedSignal().remove(this.buddyRemoved);
            this.cleanupQueueRestrictions();
            this._queueRestrictionCache.reset();
         }
         else
         {
            this.logger.debug("queue-restriction controller is already deactivated!");
         }
      }
      
      private function populateQueueRestrictions() : void
      {
         var _loc1_:Array = this._chatRosterProvider.getAllRosterItems();
         this._queueRestrictionActionFactory.getProcessQueueRestrictionsAction(_loc1_).invoke();
      }
      
      private function buddyRemoved(param1:RosterItemVO) : void
      {
         var _loc2_:Number = NaN;
         if(param1)
         {
            this.logger.debug("Removed " + param1.displayName);
            _loc2_ = Number(RosterUtility.summonerIdFromJID(param1.jid));
            this._queueRestrictionCache.removeQueueRestrictionCacheItem(_loc2_);
         }
      }
      
      private function cleanupQueueRestrictions() : void
      {
         var _loc1_:RosterItemVO = null;
         for each(_loc1_ in this._chatRosterProvider.getAllRosterItems())
         {
            _loc1_.isDuoQueueRestricted = false;
            _loc1_.isRankedRestricted = false;
         }
      }
      
      public function checkIsEligibleQueuePartner(param1:RosterItemVO, param2:Function) : void
      {
         var rosterItem:RosterItemVO = param1;
         var callBack:Function = param2;
         var onFilterIneligibleQueuePartnerCompleted:Function = function(param1:FilterIneligibleQueuePartnersAction):void
         {
            if(param1.getEligibleQueuePartners().length == 0)
            {
               callBack.apply(null,[false,rosterItem]);
            }
            else
            {
               callBack.apply(null,[true,rosterItem]);
            }
         };
         var action:FilterIneligibleQueuePartnersAction = this._queueRestrictionActionFactory.getFilterIneligibleQueuePartnersAction([rosterItem]);
         action.getCompleted().add(onFilterIneligibleQueuePartnerCompleted);
         action.invoke();
      }
      
      private function handleRosterPresenceUpdated(param1:RosterItemVO) : void
      {
         if(this._active && !this._inviteGroup.myJID.equals(param1.jid,true) && Boolean(RosterUtility.isOnlineAndAvailableForInvite(param1)))
         {
            this._queueRestrictionActionFactory.getProcessQueueRestrictionsAction([param1]).invoke();
         }
      }
      
      public function connectListeners() : void
      {
         this._inviteController.getLobbyCreatedSignal().add(this.activate);
         this._inviteController.getOwnerChangedSignal().add(this.handleOwnerChanged);
         this._inviteController.getInvitePrivilegeChangedSignal().add(this.handleInvitePrivilegeChanged);
         this._inviteController.getQuitLobbySignal().add(this.deactivate);
      }
      
      public function activate() : void
      {
         var _loc1_:Boolean = Boolean(QueueRestrictionConfiguration.isQueueRestrictionRequired(this._inviteQueueManager.getSelectedGameQueueConfig()));
         if(!this._active && _loc1_)
         {
            this._active = true;
            this._queueRestrictionCache.reset();
            this.populateQueueRestrictions();
            this._chatRosterProvider.getRosterPresenceUpdatedSignal().add(this.handleRosterPresenceUpdated);
            this._chatRosterProvider.getBuddyRemovedSignal().add(this.buddyRemoved);
         }
         else if(this._active && _loc1_)
         {
            this.logger.debug("queue-restriction controller is already active!");
         }
         else if(!this._active && !_loc1_)
         {
            this.logger.debug("queue-restriction is not enabled or not required for this queue.");
         }
         else if(this._active && !_loc1_)
         {
            this.logger.debug("queue-restriction is enabled but not required for this queue.");
            this.deactivate();
         }
      }
      
      private function handleInvitePrivilegeChanged(param1:Object) : void
      {
         if(param1 is Boolean && param1 as Boolean)
         {
            this.activate();
         }
      }
   }
}

