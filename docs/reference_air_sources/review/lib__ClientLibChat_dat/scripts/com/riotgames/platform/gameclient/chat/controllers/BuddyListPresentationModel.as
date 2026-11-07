package com.riotgames.platform.gameclient.chat.controllers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.domain.RecentPlayerItem;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.data.im.RosterExtension;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class BuddyListPresentationModel implements IEventDispatcher
   {
      
      public static const HEADER_STATE_NOMENUS:String = "noMenusState";
      
      public static const HEADER_STATE_ADD_BUDDY:String = "addBuddyState";
      
      public static const HEADER_STATE_ADD_GROUP:String = "addGroupState";
      
      public static const HEADER_STATE_SUMMONER_SEARCH:String = "summonerSearchState";
      
      public static const HEADER_STATE_SORT:String = "sortState";
      
      private var updateTimeoutId:int = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _sourceRosterGroups:ArrayCollection = null;
      
      private var initializeTimeoutId:int = 0;
      
      private var _buddyListGroups:ArrayCollection = new ArrayCollection();
      
      private var _onlineBuddyCountChanged:Signal = new Signal();
      
      private var _1157507093recentPlayersList:ArrayCollection = new ArrayCollection();
      
      private var pendingUpdate:ArrayCollection = new ArrayCollection();
      
      private var _defaultGroupName:String = "**Default";
      
      private var _1127869517totalBuddyCount:int = 0;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _sortIndex:int = 0;
      
      private var _sortModeChanged:Signal = new Signal();
      
      private var _defaultGroupPriority:int = 0;
      
      private var _offlineGroupName:String = "**Offline";
      
      private var _1602374491localizedSortOptions:ArrayCollection;
      
      private var _490479454buddyHeaderState:String = "noMenusState";
      
      private var _onlineBuddyCount:int = 0;
      
      public function BuddyListPresentationModel()
      {
         super();
      }
      
      public function get defaultGroupPriority() : int
      {
         return this._defaultGroupPriority;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set defaultGroupPriority(param1:int) : void
      {
         this._defaultGroupPriority = param1;
      }
      
      public function get offlineGroupName() : String
      {
         return this._offlineGroupName;
      }
      
      public function logout() : void
      {
         var _loc1_:RosterGroup = null;
         for each(_loc1_ in this.sourceRosterGroups)
         {
            _loc1_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupChanged);
         }
         this.sourceRosterGroups = null;
         this.buddyListGroups.removeAll();
         this.sortIndex = 0;
         this.recentPlayersList.removeAll();
         this.onlineBuddyCount = 0;
         this.totalBuddyCount = 0;
         this.buddyHeaderState = HEADER_STATE_NOMENUS;
      }
      
      private function rosterGroupChanged(param1:CollectionEvent) : void
      {
         var _loc2_:RosterItemVO = null;
         var _loc3_:RosterItemVO = null;
         var _loc4_:PropertyChangeEvent = null;
         if(param1.kind == CollectionEventKind.ADD)
         {
            for each(_loc2_ in param1.items)
            {
               this.addRosterItem(_loc2_);
            }
         }
         else if(param1.kind == CollectionEventKind.REMOVE)
         {
            for each(_loc3_ in param1.items)
            {
               this.removeRosterItem(_loc3_);
            }
         }
         else if(param1.kind == CollectionEventKind.REPLACE || param1.kind == CollectionEventKind.RESET)
         {
            if(this.initializeTimeoutId == 0)
            {
               this.initializeTimeoutId = setTimeout(this.delayInitialize,50);
            }
         }
         else if(param1.kind == CollectionEventKind.UPDATE)
         {
            for each(_loc4_ in param1.items)
            {
               if(_loc4_.property == "online")
               {
                  this.pendingUpdate.addItem(_loc4_.source);
                  if(this.updateTimeoutId == 0)
                  {
                     this.updateTimeoutId = setTimeout(this.updatePending,50);
                  }
               }
            }
         }
      }
      
      private function updateOnlineStatus(param1:RosterItemVO) : Boolean
      {
         var _loc3_:RosterGroup = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:RosterGroup = null;
         var _loc6_:RosterGroup = null;
         var _loc2_:RosterGroup = this.findRosterGroup(param1);
         if(_loc2_ == null)
         {
            _loc3_ = this.getOfflineList();
            if(Boolean(_loc3_) && !_loc3_.refresh())
            {
               _loc3_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupUpdateOnlineStatusListener);
               _loc3_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupUpdateOnlineStatusListener);
               return false;
            }
            _loc2_ = this.findRosterGroupByName(param1);
         }
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupUpdateOnlineStatusListener);
            if(_loc2_.refresh() == false)
            {
               _loc2_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupUpdateOnlineStatusListener);
               return false;
            }
            if(param1.online == false)
            {
               _loc4_ = this.getOfflineList();
               if(Boolean(_loc4_) && _loc2_.label != this.offlineGroupName)
               {
                  _loc2_.removeItem(param1);
                  _loc2_.refresh();
                  _loc4_.addItem(param1);
                  _loc4_.refresh();
                  if(_loc2_.label != this.offlineGroupName)
                  {
                     --this.onlineBuddyCount;
                  }
               }
            }
            else
            {
               _loc5_ = this.findSourceRosterGroup(param1);
               if(Boolean(_loc5_))
               {
                  _loc6_ = this.findMirroredRosterGroup(_loc5_);
                  if(Boolean(_loc6_) && _loc6_.label != _loc2_.label)
                  {
                     if(_loc2_.label == this.offlineGroupName)
                     {
                        ++this.onlineBuddyCount;
                     }
                     _loc2_.removeItem(param1);
                     _loc2_.refresh();
                     _loc6_.addItem(param1);
                     _loc6_.refresh();
                  }
                  else
                  {
                     this.logger.warn("BuddyListPresentationModel.updateOnlineStatus: Could Not find MIRRORED dest Roster Group For User, He may be stuck in wrong group now! User: " + param1.displayName);
                  }
               }
               else
               {
                  this.logger.warn("BuddyListPresentationModel.updateOnlineStatus: Could Not Find original SOURCE Roster Group For User, He may be stuck in wrong group now! User: " + param1.displayName);
               }
            }
         }
         else
         {
            this.logger.warn("BuddyListPresentationModel.updateOnlineStatus: Could Not Find Roster Group For User, He may be stuck in wrong group now! User: " + param1.displayName);
         }
         return true;
      }
      
      private function updatePending() : void
      {
         var _loc1_:ArrayCollection = null;
         var _loc2_:RosterItemVO = null;
         var _loc3_:RosterItemVO = null;
         var _loc4_:int = 0;
         if(this.updateTimeoutId > 0)
         {
            this.updateTimeoutId = 0;
            _loc1_ = new ArrayCollection();
            for each(_loc2_ in this.pendingUpdate)
            {
               if(!this.updateOnlineStatus(_loc2_))
               {
                  break;
               }
               _loc1_.addItem(_loc2_);
            }
            if(_loc1_.length == this.pendingUpdate.length)
            {
               this.pendingUpdate.removeAll();
            }
            else
            {
               for each(_loc3_ in _loc1_)
               {
                  _loc4_ = int(this.pendingUpdate.getItemIndex(_loc3_));
                  if(_loc4_ > -1)
                  {
                     this.pendingUpdate.removeItemAt(_loc4_);
                  }
               }
            }
         }
      }
      
      public function set totalBuddyCount(param1:int) : void
      {
         var _loc2_:Object = this._1127869517totalBuddyCount;
         if(_loc2_ !== param1)
         {
            this._1127869517totalBuddyCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalBuddyCount",_loc2_,param1));
         }
      }
      
      public function get onlineBuddyCount() : int
      {
         return this._onlineBuddyCount;
      }
      
      private function findRosterGroupByName(param1:RosterItemVO) : RosterGroup
      {
         var _loc2_:RosterGroup = null;
         var _loc3_:RosterItemVO = null;
         loop0:
         for each(_loc2_ in this.buddyListGroups)
         {
            var _loc6_:int = 0;
            var _loc7_:* = _loc2_;
            do
            {
               for each(_loc3_ in _loc7_)
               {
               }
               continue loop0;
            }
            while(_loc3_.displayName != param1.displayName);
            return _loc2_;
         }
         return null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function initialize() : void
      {
         this._offlineGroupName = ResourceManager.getInstance().getString("resources","chat_buddyWindow_offlineLabel");
         this.localizedSortOptions = new ArrayCollection();
         var _loc1_:String = ResourceManager.getInstance().getString("resources","chat_buddyWindow_sortByStatus");
         if(_loc1_ == null)
         {
            _loc1_ = "**Status";
         }
         var _loc2_:String = ResourceManager.getInstance().getString("resources","chat_buddyWindow_sortByName");
         if(_loc2_ == null)
         {
            _loc2_ = "**Name";
         }
         this.localizedSortOptions.addItem(_loc1_);
         this.localizedSortOptions.addItem(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get recentPlayersList() : ArrayCollection
      {
         return this._1157507093recentPlayersList;
      }
      
      [Bindable(event="propertyChange")]
      public function get localizedSortOptions() : ArrayCollection
      {
         return this._1602374491localizedSortOptions;
      }
      
      [Bindable(event="propertyChange")]
      public function set sortIndex(param1:int) : void
      {
         var _loc2_:Object = this.sortIndex;
         if(_loc2_ !== param1)
         {
            this._32434732sortIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sortIndex",_loc2_,param1));
         }
      }
      
      private function set _32434732sortIndex(param1:int) : void
      {
         var _loc2_:RosterGroup = null;
         if(this._sortIndex != param1)
         {
            this._sortIndex = param1;
            for each(_loc2_ in this.buddyListGroups)
            {
               if(Boolean(_loc2_.sort))
               {
                  _loc2_.sort.compareFunction = this._sortIndex == 0 ? RosterGroup.compareRosterItemsByStatus : RosterGroup.sortContacts;
                  _loc2_.refresh();
               }
            }
            this._sortModeChanged.dispatch(this._sortIndex);
         }
      }
      
      private function rosterGroupUpdateOnlineStatusListener(param1:CollectionEvent) : void
      {
         if(param1.kind == CollectionEventKind.REFRESH)
         {
            if(this.updateTimeoutId == 0 && this.pendingUpdate.length > 0)
            {
               this.updateTimeoutId = setTimeout(this.updatePending,50);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set onlineBuddyCount(param1:int) : void
      {
         var _loc2_:Object = this.onlineBuddyCount;
         if(_loc2_ !== param1)
         {
            this._1658749084onlineBuddyCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"onlineBuddyCount",_loc2_,param1));
         }
      }
      
      private function findRosterGroup(param1:RosterItemVO) : RosterGroup
      {
         var _loc2_:RosterGroup = null;
         for each(_loc2_ in this.buddyListGroups)
         {
            if(_loc2_.contains(param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set buddyHeaderState(param1:String) : void
      {
         var _loc2_:Object = this._490479454buddyHeaderState;
         if(_loc2_ !== param1)
         {
            this._490479454buddyHeaderState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buddyHeaderState",_loc2_,param1));
         }
      }
      
      private function findMirroredRosterGroup(param1:RosterGroup) : RosterGroup
      {
         var _loc2_:RosterGroup = null;
         for each(_loc2_ in this.buddyListGroups)
         {
            if(_loc2_.label == param1.label)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function addRosterItem(param1:RosterItemVO) : void
      {
         var _loc2_:RosterGroup = null;
         var _loc3_:RosterGroup = null;
         var _loc4_:RosterGroup = null;
         ++this.totalBuddyCount;
         if(param1.online)
         {
            _loc2_ = this.findSourceRosterGroup(param1);
            _loc3_ = this.findMirroredRosterGroup(_loc2_);
            if(!_loc2_ || !_loc3_)
            {
               return;
            }
            _loc3_.addItem(param1);
            _loc3_.refresh();
            ++this.onlineBuddyCount;
         }
         else
         {
            _loc4_ = this.getOfflineList();
            if(Boolean(_loc4_))
            {
               if(param1.comparableDisplayName == null)
               {
                  this.fixEmptyRosterItemName(param1);
               }
               _loc4_.addItem(param1);
               _loc4_.refresh();
            }
         }
      }
      
      private function fixEmptyRosterItemName(param1:RosterItemVO) : void
      {
         param1.displayName = ResourceManager.getInstance().getString("resources","BuddyListTreeRenderer_gameStatus_unknown");
      }
      
      public function addRecentPlayers(param1:ArrayCollection) : void
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:RecentPlayerItem = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc3_ = new RecentPlayerItem();
            _loc3_.playerStats = _loc2_;
            _loc3_.timeStamp = new Date();
            this.addRecentPlayer(_loc3_);
         }
      }
      
      public function set localizedSortOptions(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1602374491localizedSortOptions;
         if(_loc2_ !== param1)
         {
            this._1602374491localizedSortOptions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localizedSortOptions",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalBuddyCount() : int
      {
         return this._1127869517totalBuddyCount;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get sortIndex() : int
      {
         return this._sortIndex;
      }
      
      private function sortOfflineBuddies(param1:ArrayCollection) : void
      {
         var _loc4_:RosterGroup = null;
         var _loc5_:Array = null;
         var _loc6_:RosterItemVO = null;
         var _loc7_:RosterItemVO = null;
         var _loc8_:Sort = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(param1))
         {
            param1.disableAutoUpdate();
            param1.removeAll();
            for each(_loc4_ in this.buddyListGroups)
            {
               if(param1 != _loc4_)
               {
                  _loc4_.disableAutoUpdate();
                  _loc5_ = new Array();
                  for each(_loc6_ in _loc4_)
                  {
                     _loc3_++;
                     if(!_loc6_.online || Boolean(_loc6_.online) && _loc6_.subscribeType != RosterExtension.SUBSCRIBE_TYPE_BOTH)
                     {
                        if(_loc6_.comparableDisplayName == null)
                        {
                           this.fixEmptyRosterItemName(_loc6_);
                        }
                        _loc5_.push(_loc6_);
                     }
                  }
                  for each(_loc7_ in _loc5_)
                  {
                     param1.addItem(_loc7_);
                     _loc4_.removeItem(_loc7_);
                  }
                  _loc8_ = new Sort();
                  _loc8_.compareFunction = this._sortIndex == 0 ? RosterGroup.compareRosterItemsByStatus : RosterGroup.sortContacts;
                  _loc4_.sort = _loc8_;
                  param1.sort = _loc8_;
                  _loc4_.refresh();
                  param1.refresh();
                  _loc2_ += _loc4_.length;
                  _loc4_.enableAutoUpdate();
                  param1.enableAutoUpdate();
               }
            }
            this.onlineBuddyCount = _loc2_;
            this.totalBuddyCount = _loc3_;
            param1.refresh();
            param1.enableAutoUpdate();
            return;
         }
      }
      
      private function sourceRosterGroupsChanged(param1:CollectionEvent) : void
      {
         this.initializeRosterGroups();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get buddyHeaderState() : String
      {
         return this._490479454buddyHeaderState;
      }
      
      private function findSourceRosterGroup(param1:RosterItemVO) : RosterGroup
      {
         var _loc2_:RosterGroup = null;
         var _loc3_:RosterGroup = null;
         var _loc4_:RosterItemVO = null;
         for each(_loc2_ in this.sourceRosterGroups)
         {
            if(_loc2_.contains(param1))
            {
               return _loc2_;
            }
         }
         loop1:
         for each(_loc3_ in this.sourceRosterGroups)
         {
            var _loc7_:int = 0;
            var _loc8_:* = _loc3_;
            do
            {
               for each(_loc4_ in _loc8_)
               {
               }
               continue loop1;
            }
            while(_loc4_.displayName != param1.displayName);
            return _loc3_;
         }
         return null;
      }
      
      private function removeRosterItem(param1:RosterItemVO) : void
      {
         --this.totalBuddyCount;
         var _loc2_:RosterGroup = this.findRosterGroup(param1);
         if(_loc2_ == null)
         {
            return;
         }
         if(param1.online)
         {
            --this.onlineBuddyCount;
         }
         _loc2_.removeItem(param1);
         _loc2_.refresh();
      }
      
      public function set recentPlayersList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1157507093recentPlayersList;
         if(_loc2_ !== param1)
         {
            this._1157507093recentPlayersList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recentPlayersList",_loc2_,param1));
         }
      }
      
      private function addRecentPlayer(param1:RecentPlayerItem) : void
      {
         var _loc2_:RecentPlayerItem = null;
         var _loc3_:int = 0;
         for each(_loc2_ in this.recentPlayersList)
         {
            if(_loc2_.playerStats.userId == param1.playerStats.userId)
            {
               _loc3_ = int(this.recentPlayersList.getItemIndex(_loc2_));
               if(_loc3_ > 0)
               {
                  this.recentPlayersList.removeItemAt(_loc3_);
               }
               break;
            }
         }
         if(!param1.playerStats.isBotPlayer() && !param1.playerStats.isMe)
         {
            this.recentPlayersList.addItemAt(param1,0);
         }
      }
      
      public function get defaultGroupName() : String
      {
         return this._defaultGroupName;
      }
      
      private function getOfflineList() : RosterGroup
      {
         var _loc1_:RosterGroup = null;
         for each(_loc1_ in this.buddyListGroups)
         {
            if(_loc1_.label == this.offlineGroupName)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getSortModeChanged() : ISignal
      {
         return this._sortModeChanged;
      }
      
      private function set _1658749084onlineBuddyCount(param1:int) : void
      {
         var _loc2_:int = this._onlineBuddyCount;
         this._onlineBuddyCount = param1;
         this._onlineBuddyCountChanged.dispatch(_loc2_,param1);
      }
      
      private function initializeRosterGroups() : void
      {
         var _loc1_:RosterGroup = null;
         var _loc2_:RosterGroup = null;
         var _loc3_:RosterGroup = null;
         this.buddyListGroups.removeAll();
         for each(_loc1_ in this.sourceRosterGroups)
         {
            _loc3_ = new RosterGroup(_loc1_.label,_loc1_.priority);
            _loc3_.source = _loc1_.toArray();
            _loc3_.shared = _loc1_.shared;
            _loc1_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupChanged);
            _loc1_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.rosterGroupChanged);
            this.buddyListGroups.addItem(_loc3_);
         }
         _loc2_ = new RosterGroup(this.offlineGroupName,int.MAX_VALUE);
         this.buddyListGroups.addItem(_loc2_);
         this.sortOfflineBuddies(_loc2_);
      }
      
      private function delayInitialize() : void
      {
         if(this.initializeTimeoutId > 0)
         {
            this.initializeRosterGroups();
         }
         this.initializeTimeoutId = 0;
      }
      
      public function set sourceRosterGroups(param1:ArrayCollection) : void
      {
         if(this._sourceRosterGroups != null)
         {
            this._sourceRosterGroups.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.sourceRosterGroupsChanged);
         }
         this._sourceRosterGroups = param1;
         if(this._sourceRosterGroups != null)
         {
            this._sourceRosterGroups.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.sourceRosterGroupsChanged);
            this.initializeRosterGroups();
         }
      }
      
      public function get buddyListGroups() : ArrayCollection
      {
         return this._buddyListGroups;
      }
      
      public function get sourceRosterGroups() : ArrayCollection
      {
         return this._sourceRosterGroups;
      }
      
      public function get onlineBuddyCountChanged() : ISignal
      {
         return this._onlineBuddyCountChanged;
      }
   }
}

