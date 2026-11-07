package com.riotgames.pvpnet.tracking
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyFactory;
   import com.riotgames.platform.proxy.ProxyObject;
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
   
   public class ICrossModuleTrackerProvider_proxy implements IProxyObject, ICrossModuleTrackerProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function ICrossModuleTrackerProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function getLoginProcessTracker() : ILoginProcessTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(ILoginProcessTracker);
         _loc1_ = this.__proxy.__methodInvoke("getLoginProcessTracker",[],_loc1_);
         return _loc1_ as ILoginProcessTracker;
      }
      
      public function getChatTracker() : IChatBehaviorTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IChatBehaviorTracker);
         _loc1_ = this.__proxy.__methodInvoke("getChatTracker",[],_loc1_);
         return _loc1_ as IChatBehaviorTracker;
      }
      
      public function getFriendListBehaviorTracker() : IFriendListBehaviorTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IFriendListBehaviorTracker);
         _loc1_ = this.__proxy.__methodInvoke("getFriendListBehaviorTracker",[],_loc1_);
         return _loc1_ as IFriendListBehaviorTracker;
      }
      
      public function getSessionTracker() : ISessionTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(ISessionTracker);
         _loc1_ = this.__proxy.__methodInvoke("getSessionTracker",[],_loc1_);
         return _loc1_ as ISessionTracker;
      }
      
      public function getItemSetsBehaviorTracker() : IItemSetsBehaviorTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IItemSetsBehaviorTracker);
         _loc1_ = this.__proxy.__methodInvoke("getItemSetsBehaviorTracker",[],_loc1_);
         return _loc1_ as IItemSetsBehaviorTracker;
      }
      
      public function getItemSetsOrganizationalStructureTracker() : IItemSetsOrganizationalStructureTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IItemSetsOrganizationalStructureTracker);
         _loc1_ = this.__proxy.__methodInvoke("getItemSetsOrganizationalStructureTracker",[],_loc1_);
         return _loc1_ as IItemSetsOrganizationalStructureTracker;
      }
      
      public function getClientBehaviorTracker() : IClientBehaviorTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IClientBehaviorTracker);
         _loc1_ = this.__proxy.__methodInvoke("getClientBehaviorTracker",[],_loc1_);
         return _loc1_ as IClientBehaviorTracker;
      }
      
      public function getRunesTracker() : IRunesTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IRunesTracker);
         _loc1_ = this.__proxy.__methodInvoke("getRunesTracker",[],_loc1_);
         return _loc1_ as IRunesTracker;
      }
      
      public function getFeaturedContentTracker() : IFeaturedContentTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(IFeaturedContentTracker);
         _loc1_ = this.__proxy.__methodInvoke("getFeaturedContentTracker",[],_loc1_);
         return _loc1_ as IFeaturedContentTracker;
      }
      
      public function getLoyaltyRewardsTracker() : ILoyaltyRewardsTracker
      {
         var _loc1_:* = ProxyFactory.createProxy(ILoyaltyRewardsTracker);
         _loc1_ = this.__proxy.__methodInvoke("getLoyaltyRewardsTracker",[],_loc1_);
         return _loc1_ as ILoyaltyRewardsTracker;
      }
   }
}

