package com.riotgames.pvpnet.queuerestriction.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.domain.queuerestriction.QueueRestrictionCacheItem;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionActionFactory;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionCache;
   import com.riotgames.pvpnet.queuerestriction.controller.QueueRestrictionController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class FilterIneligibleQueuePartnersAction extends BasicAction
   {
      
      private var _eligibleQueuePartners:Array;
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _rosterItems:Array;
      
      private var _queueRestrictionActionFactory:QueueRestrictionActionFactory;
      
      public function FilterIneligibleQueuePartnersAction(param1:Array, param2:QueueRestrictionActionFactory, param3:QueueRestrictionCache)
      {
         super(false);
         this._rosterItems = param1;
         this._queueRestrictionActionFactory = param2;
         this._queueRestrictionCache = param3;
         this._eligibleQueuePartners = new Array();
      }
      
      private function onProcessQueueRestrictionsComplete() : void
      {
         var _loc1_:RosterItemVO = null;
         var _loc2_:Number = NaN;
         var _loc3_:QueueRestrictionCacheItem = null;
         var _loc4_:String = null;
         var _loc5_:AlertAction = null;
         for each(_loc1_ in this._rosterItems)
         {
            _loc2_ = Number(RosterUtility.summonerIdFromJID(_loc1_.jid));
            _loc3_ = this._queueRestrictionCache.getQueueRestrictionCacheItem(_loc2_);
            if(Boolean(_loc3_) && !_loc3_.getRankedDuoQueueEligibility())
            {
               _loc4_ = QueueRestrictionController.getRankedDuoQueueRestrictedText(Session.instance,ServiceProxy.instance.leagueService.cache);
               _loc5_ = new AlertAction(RiotResourceLoader.getString("queue_restriction_ineligible_partner_title","**Ineligible Duo Partner"),_loc4_);
               _loc5_.add();
            }
            else if(Boolean(_loc3_) && Boolean(_loc3_.getIsRankedRestricted()))
            {
               _loc5_ = new AlertAction(RiotResourceLoader.getString("queue_restriction_ineligible_partner_title","**Ineligible Duo Partner"),RiotResourceLoader.getString("ranked_restricted_tooltip","**The summoner you are attempting to duo queue with is ineligible for ranked mode due to previous behavior on their account"));
               _loc5_.add();
            }
            else
            {
               this._eligibleQueuePartners.push(_loc1_);
            }
         }
         complete();
      }
      
      public function getEligibleQueuePartners() : Array
      {
         return this._eligibleQueuePartners;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:ProcessQueueRestrictionsActions = this._queueRestrictionActionFactory.getProcessQueueRestrictionsAction(this._rosterItems);
         _loc1_.getCompleted().add(this.onProcessQueueRestrictionsComplete);
         _loc1_.invoke();
      }
   }
}

