package com.riotgames.pvpnet.tracking.trackers
{
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.tracker.ITracker;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.chat.ChatBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.chat.IChatBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.client.ClientBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.client.IClientBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.featuredcontent.FeaturedContentTracker;
   import com.riotgames.pvpnet.tracking.trackers.featuredcontent.IFeaturedContentTracker;
   import com.riotgames.pvpnet.tracking.trackers.friend.FriendListBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.ItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.ItemSetsOrganizationalStructureTracker;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import com.riotgames.pvpnet.tracking.trackers.login.LoginProcessTracker;
   import com.riotgames.pvpnet.tracking.trackers.loyalty.ILoyaltyRewardsTracker;
   import com.riotgames.pvpnet.tracking.trackers.loyalty.LoyaltyRewardsTracker;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.pvpnet.tracking.trackers.runes.RunesTracker;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionTracker;
   import com.riotgames.pvpnet.tracking.trackers.session.SessionMetaDataTracker;
   import flash.utils.Dictionary;
   
   public class CrossModuleTrackerController implements ICrossModuleTrackerProvider, IProvider
   {
      
      private var multiUseReverseLookup:Dictionary = new Dictionary();
      
      private var multiUseTrackers:Dictionary = new Dictionary();
      
      private var singleUseTrackers:Dictionary = new Dictionary();
      
      public function CrossModuleTrackerController(param1:IMetricsProvider)
      {
         super();
      }
      
      private function multiUseTrackerSentCleanup(param1:ITracker) : void
      {
         var _loc3_:Dictionary = null;
         var _loc2_:MultiUseTrackerEntry = this.multiUseReverseLookup[param1];
         if(_loc2_ != null)
         {
            _loc3_ = this.multiUseTrackers[_loc2_.trackerClass];
            if(_loc3_ != null)
            {
               _loc3_[_loc2_.id] = null;
               if(_loc3_.length <= 0)
               {
                  this.multiUseTrackers[_loc2_.tracker] = null;
               }
            }
            this.multiUseReverseLookup[param1] = null;
         }
         param1.getSent().remove(this.multiUseTrackerSentCleanup);
      }
      
      public function getClientBehaviorTracker() : IClientBehaviorTracker
      {
         return this.getSingleUseTracker(ClientBehaviorTracker) as IClientBehaviorTracker;
      }
      
      public function getLoyaltyRewardsTracker() : ILoyaltyRewardsTracker
      {
         return this.getSingleUseTracker(LoyaltyRewardsTracker) as ILoyaltyRewardsTracker;
      }
      
      public function getChatTracker() : IChatBehaviorTracker
      {
         return this.getSingleUseTracker(ChatBehaviorTracker) as IChatBehaviorTracker;
      }
      
      private function getMultiUseTrackerById(param1:Class, param2:String) : ITracker
      {
         var _loc5_:MultiUseTrackerEntry = null;
         var _loc3_:Dictionary = this.multiUseTrackers[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new Dictionary();
            this.multiUseTrackers[param1] = _loc3_;
         }
         var _loc4_:ITracker = _loc3_[param2];
         if(_loc4_ == null)
         {
            _loc4_ = new param1() as ITracker;
            _loc3_[param2] = _loc4_;
            _loc4_.getSent().add(this.multiUseTrackerSentCleanup);
            _loc5_ = new MultiUseTrackerEntry(_loc4_,param1,param2);
            this.multiUseReverseLookup[_loc4_] = _loc5_;
         }
         return _loc4_;
      }
      
      private function getSingleUseTracker(param1:Class) : ITracker
      {
         var _loc2_:ITracker = this.singleUseTrackers[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new param1() as ITracker;
            this.singleUseTrackers[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function getFeaturedContentTracker() : IFeaturedContentTracker
      {
         return this.getSingleUseTracker(FeaturedContentTracker) as IFeaturedContentTracker;
      }
      
      public function getFriendListBehaviorTracker() : IFriendListBehaviorTracker
      {
         return this.getSingleUseTracker(FriendListBehaviorTracker) as IFriendListBehaviorTracker;
      }
      
      public function getLoginProcessTracker() : ILoginProcessTracker
      {
         return this.getSingleUseTracker(LoginProcessTracker) as ILoginProcessTracker;
      }
      
      public function getItemSetsOrganizationalStructureTracker() : IItemSetsOrganizationalStructureTracker
      {
         return this.getSingleUseTracker(ItemSetsOrganizationalStructureTracker) as IItemSetsOrganizationalStructureTracker;
      }
      
      public function getItemSetsBehaviorTracker() : IItemSetsBehaviorTracker
      {
         return this.getSingleUseTracker(ItemSetsBehaviorTracker) as IItemSetsBehaviorTracker;
      }
      
      public function getRunesTracker() : IRunesTracker
      {
         return this.getSingleUseTracker(RunesTracker) as IRunesTracker;
      }
      
      public function getSessionTracker() : ISessionTracker
      {
         return this.getSingleUseTracker(SessionMetaDataTracker) as ISessionTracker;
      }
   }
}

import com.riotgames.pvpnet.tracker.ITracker;

class MultiUseTrackerEntry
{
   
   public var trackerClass:Class;
   
   public var tracker:ITracker;
   
   public var id:String;
   
   public function MultiUseTrackerEntry(param1:ITracker, param2:Class, param3:String)
   {
      super();
      this.tracker = param1;
      this.trackerClass = param2;
      this.id = param3;
   }
}
