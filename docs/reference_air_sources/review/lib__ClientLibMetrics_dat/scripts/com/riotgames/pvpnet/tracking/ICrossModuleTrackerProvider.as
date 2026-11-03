package com.riotgames.pvpnet.tracking
{
   import com.riotgames.pvpnet.tracking.trackers.chat.IChatBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.client.IClientBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.featuredcontent.IFeaturedContentTracker;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import com.riotgames.pvpnet.tracking.trackers.loyalty.ILoyaltyRewardsTracker;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionTracker;
   
   [GenerateProxy]
   public interface ICrossModuleTrackerProvider
   {
      
      function getLoginProcessTracker() : ILoginProcessTracker;
      
      function getChatTracker() : IChatBehaviorTracker;
      
      function getFriendListBehaviorTracker() : IFriendListBehaviorTracker;
      
      function getSessionTracker() : ISessionTracker;
      
      function getItemSetsBehaviorTracker() : IItemSetsBehaviorTracker;
      
      function getItemSetsOrganizationalStructureTracker() : IItemSetsOrganizationalStructureTracker;
      
      function getClientBehaviorTracker() : IClientBehaviorTracker;
      
      function getRunesTracker() : IRunesTracker;
      
      function getFeaturedContentTracker() : IFeaturedContentTracker;
      
      function getLoyaltyRewardsTracker() : ILoyaltyRewardsTracker;
   }
}

