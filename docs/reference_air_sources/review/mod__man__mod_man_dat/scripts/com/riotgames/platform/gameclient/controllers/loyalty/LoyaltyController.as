package com.riotgames.platform.gameclient.controllers.loyalty
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ILoyaltyProvider;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.loyalty.ChampionReward;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyRewards;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyStateChangeNotification;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.loyalty.ILoyaltyRewardsTracker;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LoyaltyController implements ILoyaltyProvider, IEventDispatcher
   {
      
      private var _currentRewards:LoyaltyRewards;
      
      private var _rewardsChanged:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var inventoryController:IInventoryController;
      
      private var queuedLoyaltyStatus:LoyaltyStateChangeNotification;
      
      public var rewardsDescription:String;
      
      private var receivedUpdateBeforeInventory:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var currentRewardedSkinIds:Array;
      
      private var loyaltyRewardsTracker:ILoyaltyRewardsTracker;
      
      private var currentLoyaltyStatus:LoyaltyStateChangeNotification;
      
      private var crossModuleTrackerProvider:ICrossModuleTrackerProvider;
      
      private var currentRewardedChampionIds:Array;
      
      private const CHAMPION_NAMING_THRESHOLD:int = 5;
      
      public function LoyaltyController(param1:IInventoryController = null, param2:ICrossModuleTrackerProvider = null)
      {
         super();
         this.inventoryController = param1;
         this.crossModuleTrackerProvider = param2;
         if(!param1)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         if(!param2)
         {
            ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
         }
         ProviderLookup.publishProvider(ILoyaltyProvider,this);
      }
      
      private function unsetAllRewardedChampionsAndSkins() : void
      {
         var _loc1_:Champion = null;
         var _loc2_:ChampionSkin = null;
         for each(_loc1_ in this.inventoryController.inventory.championRegistry)
         {
            _loc1_.freeToPlayReward = false;
            for each(_loc2_ in _loc1_.championSkins)
            {
               _loc2_.freeToPlayReward = false;
            }
         }
      }
      
      private function updateNewRewardedSkinIds(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ChampionSkin = null;
         var _loc4_:int = 0;
         var _loc5_:ChampionSkin = null;
         if(!this.inventoryController.inventory.isChampionsLoaded)
         {
            this.logger.warn("Attempted to update rewarded skins prior to inventory! Aborting");
            return;
         }
         if(this.currentRewardedSkinIds)
         {
            for each(_loc2_ in this.currentRewardedSkinIds)
            {
               _loc3_ = this.inventoryController.inventory.skinSkinIdMapping[_loc2_] as ChampionSkin;
               if(_loc3_)
               {
                  _loc3_.freeToPlayReward = false;
               }
               else
               {
                  this.logger.warn("Skin " + _loc2_ + " wasn\'t found when attempting to unset reward");
               }
            }
         }
         if(param1)
         {
            for each(_loc4_ in param1)
            {
               _loc5_ = this.inventoryController.inventory.skinSkinIdMapping[_loc4_] as ChampionSkin;
               if(_loc5_)
               {
                  _loc5_.freeToPlayReward = true;
               }
               else
               {
                  this.logger.warn("Skin " + _loc4_ + " wasn\'t found when attempting to set reward");
               }
            }
         }
         this.currentRewardedSkinIds = param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function updateNewRewardedChampionIds(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Champion = null;
         var _loc4_:int = 0;
         var _loc5_:Champion = null;
         if(!this.inventoryController.inventory.isChampionsLoaded)
         {
            this.logger.warn("Attempted to update rewarded champions prior to inventory! Aborting");
            return;
         }
         if(this.currentRewardedChampionIds)
         {
            for each(_loc2_ in this.currentRewardedChampionIds)
            {
               _loc3_ = this.inventoryController.inventory.championIdMapping[_loc2_] as Champion;
               if(_loc3_)
               {
                  _loc3_.freeToPlayReward = false;
               }
               else
               {
                  this.logger.warn("Champion " + _loc2_ + " wasn\'t found when attempting to unset reward");
               }
            }
         }
         if(param1)
         {
            for each(_loc4_ in param1)
            {
               _loc5_ = this.inventoryController.inventory.championIdMapping[_loc4_] as Champion;
               if(_loc5_)
               {
                  _loc5_.freeToPlayReward = true;
               }
               else
               {
                  this.logger.warn("Champion " + _loc4_ + " wasn\'t found when attempting to set reward");
               }
            }
         }
         this.currentRewardedChampionIds = param1;
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this.crossModuleTrackerProvider = param1;
      }
      
      public function getRewardsDescription() : String
      {
         return this.rewardsDescription;
      }
      
      private function set _489224341currentRewards(param1:LoyaltyRewards) : void
      {
         this._currentRewards = param1;
         this._rewardsChanged.dispatch();
      }
      
      private function onInventoryChampionsRetrieved(param1:InventoryEvent) : void
      {
         if(this.queuedLoyaltyStatus)
         {
            this.processLoyaltyStateUpdate(this.queuedLoyaltyStatus);
            this.inventoryController.removeEventListener(InventoryEvent.CHAMPIONS_RETRIEVED,this.onInventoryChampionsRetrieved);
            this.queuedLoyaltyStatus = null;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventoryController = param1.getInventoryController();
         if(Boolean(this.queuedLoyaltyStatus) && Boolean(this.inventoryController.inventory) && Boolean(this.inventoryController.inventory.isChampionsLoaded))
         {
            this.processLoyaltyStateUpdate(this.queuedLoyaltyStatus);
            this.queuedLoyaltyStatus = null;
         }
         else
         {
            this.inventoryController.addEventListener(InventoryEvent.CHAMPIONS_RETRIEVED,this.onInventoryChampionsRetrieved);
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function createRewardsUpdateMessage(param1:LoyaltyStateChangeNotification, param2:LoyaltyStateChangeNotification) : String
      {
         var _loc4_:ArrayCollection = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc3_:String = new String();
         if(param1 == null && param2 != null)
         {
            _loc3_ = RiotResourceLoader.getString("rewards_update_new","You are receiving extra rewards!\n");
         }
         else if(param1.rewards != null && param2.rewards != null)
         {
            _loc3_ = RiotResourceLoader.getString("rewards_update_changed","Your active rewards have changed.\n");
         }
         else if(param2.rewards == null)
         {
            _loc3_ = RiotResourceLoader.getString("rewards_update_expired","Your rewards have expired.");
            this.logger.warn("User transitioned from having rewards to not having any");
         }
         if(Boolean(param2) && Boolean(param2.rewards))
         {
            if(param2.rewards.xpBoost > 0)
            {
               _loc3_ += RiotResourceLoader.getString("rewards_update_XP_boost","Additional XP Boost: " + param2.rewards.xpBoost,[param2.rewards.xpBoost]) + "\n";
            }
            if(param2.rewards.ipBoost > 0)
            {
               _loc3_ += RiotResourceLoader.getString("rewards_update_IP_boost","Additional IP Boost: " + param2.rewards.ipBoost,[param2.rewards.ipBoost]) + "\n";
            }
            _loc4_ = param2.rewards.champions;
            if(Boolean(_loc4_.length <= this.CHAMPION_NAMING_THRESHOLD) && Boolean(this.inventoryController) && Boolean(this.inventoryController.inventory.isChampionsLoaded))
            {
               if(_loc4_.length > 0)
               {
                  _loc6_ = new String();
                  _loc7_ = 0;
                  while(_loc7_ < _loc4_.length)
                  {
                     _loc6_ += this.inventoryController.inventory.championIdMapping[_loc4_[_loc7_].championId].displayName;
                     _loc6_ = _loc6_ + (_loc7_ == _loc4_.length - 1 ? "." : ", ");
                     _loc7_++;
                  }
                  _loc3_ += RiotResourceLoader.getString("rewards_update_unlocked_champions_listed","Unlocked champions: " + _loc6_,[_loc6_]);
               }
            }
            else
            {
               _loc3_ += RiotResourceLoader.getString("rewards_update_unlocked_champions_numerous",_loc4_.length + " unlocked champions.",[_loc4_.length]);
            }
            _loc5_ = this.countSkinIds(param2.rewards);
            if(_loc5_ > 0)
            {
               _loc3_ += "\n" + RiotResourceLoader.getString("rewards_update_unlocked_skins_numerous",_loc5_ + " skins unlocked.",[_loc5_]);
            }
         }
         return _loc3_;
      }
      
      [Bindable(event="propertyChange")]
      public function set currentRewards(param1:LoyaltyRewards) : void
      {
         var _loc2_:Object = this.currentRewards;
         if(_loc2_ !== param1)
         {
            this._489224341currentRewards = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentRewards",_loc2_,param1));
         }
      }
      
      public function processLoyaltyStateUpdate(param1:LoyaltyStateChangeNotification) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:ChampionReward = null;
         var _loc6_:int = 0;
         if(!param1)
         {
            this.logger.warn("Received a null rewards state notification!");
            return;
         }
         if(!this.inventoryController)
         {
            this.receivedUpdateBeforeInventory = true;
            this.queuedLoyaltyStatus = param1;
            return;
         }
         if(Boolean(this.inventoryController) && !this.inventoryController.inventory.isChampionsLoaded)
         {
            this.receivedUpdateBeforeInventory = true;
            this.queuedLoyaltyStatus = param1;
            this.inventoryController.addEventListener(InventoryEvent.CHAMPIONS_RETRIEVED,this.onInventoryChampionsRetrieved);
            return;
         }
         this.logger.warn("Processing a rewards status...");
         if(param1.rewards)
         {
            this.logger.warn("Reward content:");
            this.logger.warn("Champions: " + (param1.rewards.champions ? param1.rewards.champions.length : 0));
            this.logger.warn("IP Boost: " + String(Boolean(param1.rewards.ipBoost) && param1.rewards.ipBoost > 0 ? param1.rewards.ipBoost : 0));
            this.logger.warn("XP Boost: " + String(Boolean(param1.rewards.xpBoost) && param1.rewards.xpBoost > 0 ? param1.rewards.xpBoost : 0));
         }
         else
         {
            this.logger.warn("Rewards are null");
         }
         var _loc2_:AlertParameters = new AlertParameters();
         _loc2_.location = AlertLocation.LOYALTY_STATUS_IMAGE;
         _loc2_.title = RiotResourceLoader.getString("rewards_update_title","Rewards update");
         this.rewardsDescription = _loc2_.message = this.createRewardsUpdateMessage(this.currentLoyaltyStatus,param1);
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc2_);
         this.currentLoyaltyStatus = param1;
         this.currentRewards = param1.rewards;
         if(this.receivedUpdateBeforeInventory)
         {
            this.unsetAllRewardedChampionsAndSkins();
            this.receivedUpdateBeforeInventory = false;
         }
         else
         {
            this.updateNewRewardedSkinIds(null);
            this.updateNewRewardedChampionIds(null);
         }
         if(!this.receivedUpdateBeforeInventory && this.currentLoyaltyStatus != null && this.currentLoyaltyStatus.rewards != null)
         {
            if(this.loyaltyRewardsTracker)
            {
               this.loyaltyRewardsTracker.completeAndSend();
            }
            this.loyaltyRewardsTracker = this.crossModuleTrackerProvider.getLoyaltyRewardsTracker();
            this.loyaltyRewardsTracker.setPremiumType(this.currentLoyaltyStatus.premiumType);
            this.loyaltyRewardsTracker.setIpBoost(this.currentLoyaltyStatus.rewards.ipBoost);
            this.loyaltyRewardsTracker.setXpBoost(this.currentLoyaltyStatus.rewards.xpBoost);
            _loc3_ = new Array();
            _loc4_ = new Array();
            for each(_loc5_ in this.currentLoyaltyStatus.rewards.champions)
            {
               if(_loc5_.championId)
               {
                  this.loyaltyRewardsTracker.addChampion(_loc5_.championId);
                  _loc3_.push(_loc5_.championId);
               }
               for each(_loc6_ in _loc5_.skins)
               {
                  if(_loc6_)
                  {
                     this.loyaltyRewardsTracker.addSkin(_loc6_);
                     _loc4_.push(_loc6_);
                  }
               }
            }
            this.updateNewRewardedSkinIds(_loc4_);
            this.updateNewRewardedChampionIds(_loc3_);
         }
      }
      
      public function get currentRewards() : LoyaltyRewards
      {
         return this._currentRewards;
      }
      
      private function countSkinIds(param1:LoyaltyRewards) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.champions.length)
         {
            if(param1.champions[_loc3_].skins != null)
            {
               _loc2_ += param1.champions[_loc3_].skins.length;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getRewards() : LoyaltyRewards
      {
         return this._currentRewards;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function getRewardsChanged() : ISignal
      {
         return this._rewardsChanged;
      }
   }
}

