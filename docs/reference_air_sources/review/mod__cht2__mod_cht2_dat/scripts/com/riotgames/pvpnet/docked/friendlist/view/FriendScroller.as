package com.riotgames.pvpnet.docked.friendlist.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollModel;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.factory.ClassPool;
   import blix.frame.getEnterFrame;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.BuddyBusyStatus;
   import com.riotgames.platform.gameclient.chat.domain.BuddyGroup;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.docked.IFriendScroller;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.rust.components.grouplist.DefaultRendererPool;
   import com.riotgames.rust.components.grouplist.GroupModel;
   import com.riotgames.rust.components.grouplist.IRendererPool;
   import com.riotgames.rust.components.grouplist.VirtualizedCollapsibleVerticalGroup;
   import com.riotgames.rust.components.grouplist.VisibilityModel;
   import flash.desktop.NativeDragActions;
   import flash.desktop.NativeDragManager;
   import flash.events.NativeDragEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   
   public class FriendScroller extends ScrollArea implements IFriendScroller
   {
      
      public static const SORT_MODE_NAME:String = "name";
      
      public static const SORT_MODE_STATUS:String = "status";
      
      private static const DRAG_SCROLL_PERCENT:Number = 0.2;
      
      private static const DRAG_SCROLL_SPEED:Number = 20;
      
      private var _sizer:SpriteProxy;
      
      private var _headerPool:IRendererPool;
      
      private var _friendRendererPool:IRendererPool;
      
      private var _visibility:VisibilityModel;
      
      private var buddies:ListCollectionView;
      
      private var buddyNameFilter:String = "";
      
      private var showOfflineFriends:Boolean;
      
      private var insertionIndicator:SpriteProxy;
      
      private var groupDropTarget:VirtualizedCollapsibleVerticalGroup;
      
      private var _addBuddyRequested:Signal = new Signal();
      
      private var _addGroupRequested:Signal = new Signal();
      
      private var buddyGroupToGroupModel:Dictionary = new Dictionary();
      
      private var groupModelToGroupLayout:Dictionary = new Dictionary();
      
      private var _sortMode:String = "status";
      
      private var _configurationRegistry:IConfigurationRegistry;
      
      private var whitespaceRegex:RegExp = /[\s\r\n]+/gi;
      
      public function FriendScroller(param1:IContext)
      {
         super(param1);
         this._headerPool = new DefaultRendererPool(new ClassPool(GroupHeaderRenderer,[this]));
         this._friendRendererPool = new DefaultRendererPool(new ClassPool(FriendListRenderer,[this]));
         this._visibility = new VisibilityModel();
         this._visibility.visibilityContext = this;
         this._visibility.visibleRect = new Rectangle(0,0,100,100);
         _vScrollModel.getChanged().add(this.calculateVisibility);
         _hScrollModel.getChanged().add(this.calculateVisibility);
         setVScrollPolicy(ScrollPolicy.ON);
         setScrollBarsAutoPosition(false);
         setLinkage("chat.FriendList");
         this.fetchBuddyData();
         this.mouseDelta = 20;
      }
      
      override protected function createChildren() : void
      {
         this._sizer = new SpriteProxy(this);
         this.setTimelineChildByName("listSizer",this._sizer);
         this._sizer.getAssetChanged().add(this.onSizerAssetSet);
         _contents = new LayoutContainerView(this);
         this.setTimelineChildByName("listContent",_contents);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         _contents.setLayoutAlgorithm(_loc1_);
         this.setVScrollPolicy(ScrollPolicy.ON);
         this.insertionIndicator = new SpriteProxy(this);
         this.insertionIndicator.setLinkage("chat.InsertionIndicator");
         this.insertionIndicator.setVisible(false);
         this.insertionIndicator.setMouseEnabled(false);
         this.insertionIndicator.setMouseChildren(false);
         this.insertionIndicator.setTransformBehavior(new ScalingTransformBehavior());
         addChild(this.insertionIndicator);
         super.createChildren();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._configurationRegistry = this.getDependency(IConfigurationRegistry,true);
      }
      
      private function isMobileEnabled() : Boolean
      {
         return this._configurationRegistry.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED).getBoolean();
      }
      
      public function getAddBuddyRequested() : ISignal
      {
         return this._addBuddyRequested;
      }
      
      public function getAddGroupRequested() : ISignal
      {
         return this._addGroupRequested;
      }
      
      public function sortByName() : void
      {
         this.setSortMode(SORT_MODE_NAME);
      }
      
      public function sortByStatus() : void
      {
         this.setSortMode(SORT_MODE_STATUS);
      }
      
      public function setSortMode(param1:String) : void
      {
         if(this._sortMode != param1)
         {
            this._sortMode = param1;
            this.updateBuddyGroups();
         }
      }
      
      public function setShowOfflineFriends(param1:Boolean) : void
      {
         if(this.showOfflineFriends != param1)
         {
            this.showOfflineFriends = param1;
            this.updateBuddyGroups();
         }
      }
      
      private function calculateVisibility() : void
      {
         var _loc1_:Rectangle = this._visibility.visibleRect;
         _loc1_.x = 0;
         _loc1_.y = _vScrollModel.getClampedValue();
         _loc1_.width = _scrollAreaSize.x;
         _loc1_.height = _scrollAreaSize.y;
         this._visibility.visibleRect = _loc1_;
      }
      
      private function onSizerAssetSet() : void
      {
         if(this._sizer.getAsset() != null)
         {
            this.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         }
      }
      
      private function fetchBuddyData() : void
      {
         var _loc1_:IChatRosterProvider = getDependency(IChatRosterProvider);
         this.buddies = _loc1_.getBuddyGroups();
         this.buddies.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onBuddyGroupsChanged);
         this.updateBuddyGroups();
      }
      
      private function onBuddyGroupsChanged(param1:CollectionEvent) : void
      {
         this.updateBuddyGroups();
      }
      
      private function processCollectionChange(param1:CollectionEvent) : void
      {
         var _loc2_:BuddyGroup = param1.currentTarget as BuddyGroup;
         var _loc3_:GroupModel = this.buddyGroupToGroupModel[_loc2_];
         if(_loc3_)
         {
            _loc3_.itemData = _loc2_.source.filter(this.isBuddyVisible).sort(this.sortBuddies);
         }
      }
      
      private function updateBuddyGroups() : void
      {
         var _loc1_:BuddyGroup = null;
         var _loc2_:GroupModel = null;
         var _loc3_:VirtualizedCollapsibleVerticalGroup = null;
         var _loc4_:SizeLayoutData = null;
         this.removeOrphanedGroups();
         for each(_loc1_ in this.buddies)
         {
            _loc2_ = this.buddyGroupToGroupModel[_loc1_];
            if(!_loc2_)
            {
               _loc2_ = new GroupModel();
               _loc2_.headerData = _loc1_;
               _loc2_.itemData = _loc1_.source.filter(this.isBuddyVisible).sort(this.sortBuddies);
               _loc2_.unfilteredSize = _loc1_.source.length;
               _loc1_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.processCollectionChange);
               _loc3_ = new VirtualizedCollapsibleVerticalGroup(this,_loc2_,this._visibility,this._headerPool,this._friendRendererPool);
               _loc3_.headerPadding = 0;
               _loc3_.itemPadding = 0;
               _loc3_.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.dragEnterHandler);
               _loc3_.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
               _loc3_.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.handleDragComplete);
               this.buddyGroupToGroupModel[_loc1_] = _loc2_;
               this.groupModelToGroupLayout[_loc2_] = _loc3_;
               _loc4_ = new SizeLayoutData();
               _loc4_.setWidthPercent(1);
               if(_loc1_.source.length == 0)
               {
                  _contents.addElementAt(_loc3_,0,_loc4_);
               }
               else
               {
                  _contents.addElement(_loc3_,_loc4_);
               }
            }
            else
            {
               _loc2_.headerData = _loc1_;
               _loc2_.itemData = _loc1_.source.filter(this.isBuddyVisible).sort(this.sortBuddies);
               _loc2_.unfilteredSize = _loc1_.source.length;
            }
         }
      }
      
      private function removeOrphanedGroups() : void
      {
         var _loc2_:GroupModel = null;
         var _loc3_:GroupModel = null;
         var _loc4_:VirtualizedCollapsibleVerticalGroup = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.buddyGroupToGroupModel)
         {
            if(!this.buddies.contains(_loc2_.headerData))
            {
               _loc1_.push(_loc2_);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            _loc3_.headerData.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.processCollectionChange);
            _loc4_ = this.groupModelToGroupLayout[_loc3_];
            _loc4_.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.dragEnterHandler);
            _loc4_.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleDragDrop);
            _loc4_.removeEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE,this.handleDragComplete);
            _contents.removeElement(_loc4_);
            delete this.buddyGroupToGroupModel[_loc3_.headerData];
            delete this.groupModelToGroupLayout[_loc3_];
         }
      }
      
      private function sortBuddies(param1:Buddy, param2:Buddy) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == param2)
         {
            return 0;
         }
         if(param2 == null)
         {
            return -1;
         }
         if(param1 == null)
         {
            return 1;
         }
         if(Boolean(param1.getIsMutualFriend()) && !param2.getIsMutualFriend())
         {
            return -1;
         }
         if(!param1.getIsMutualFriend() && Boolean(param2.getIsMutualFriend()))
         {
            return 1;
         }
         if(param1.getStatus() == Buddy.STATUS_ONLINE && param2.getStatus() == Buddy.STATUS_OFFLINE)
         {
            return -1;
         }
         if(param1.getStatus() == Buddy.STATUS_OFFLINE && param2.getStatus() == Buddy.STATUS_ONLINE)
         {
            return 1;
         }
         if(this._sortMode == SORT_MODE_NAME)
         {
            return this.sortBuddyByName(param1,param2);
         }
         if(this._sortMode == SORT_MODE_STATUS)
         {
            _loc3_ = this.getStatusSortRankForBuddy(param1);
            _loc4_ = this.getStatusSortRankForBuddy(param2);
            if(_loc3_ == _loc4_)
            {
               return this.sortBuddyByName(param1,param2);
            }
            if(_loc3_ < _loc4_)
            {
               return -1;
            }
            return 1;
         }
         return 0;
      }
      
      private function sortBuddyByName(param1:Buddy, param2:Buddy) : int
      {
         var _loc3_:String = param1.getName() ? param1.getName().toLowerCase() : "";
         var _loc4_:String = param2.getName() ? param2.getName().toLowerCase() : "";
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc4_ < _loc3_)
         {
            return 1;
         }
         return 0;
      }
      
      private function getStatusSortRank(param1:String) : int
      {
         switch(param1)
         {
            case BuddyBusyStatus.AVAILABLE:
               return 0;
            case BuddyBusyStatus.DO_NOT_DISTURB:
               return 1;
            case BuddyBusyStatus.AVAILABLE_MOBILE:
               return 2;
            case BuddyBusyStatus.AWAY:
               return 3;
            default:
               return 4;
         }
      }
      
      private function getStatusSortRankForBuddy(param1:Buddy) : int
      {
         var _loc2_:String = param1.getBusyStatus();
         if(param1.isOnMobile())
         {
            _loc2_ = this.isMobileEnabled() ? BuddyBusyStatus.AVAILABLE_MOBILE : BuddyBusyStatus.AWAY;
         }
         return this.getStatusSortRank(_loc2_);
      }
      
      protected function isBuddyVisible(param1:Buddy, param2:int, param3:Array) : Boolean
      {
         if(!this.showOfflineFriends && (!param1.getIsOnline() || !param1.getIsMutualFriend()))
         {
            return false;
         }
         var _loc4_:String = this.buddyNameFilter.replace(this.whitespaceRegex,"").toLocaleLowerCase();
         if(_loc4_.length == 0)
         {
            return true;
         }
         return param1.getName().replace(this.whitespaceRegex,"").toLocaleLowerCase().indexOf(_loc4_) >= 0;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         this.calculateVisibility();
         return _loc3_;
      }
      
      private function dragEnterHandler(param1:NativeDragEvent) : void
      {
         if(param1.clipboard.hasFormat(Buddy.DATA_FORMAT))
         {
            getEnterFrame().add(this.updateDragScrolling);
            this.groupDropTarget = param1.currentTarget as VirtualizedCollapsibleVerticalGroup;
            param1.dropAction = NativeDragActions.MOVE;
            NativeDragManager.acceptDragDrop(this.groupDropTarget.getInteractiveAsset());
            this.insertionIndicator.setVisible(true);
         }
      }
      
      private function handleDragDrop(param1:NativeDragEvent) : void
      {
         var _loc3_:ChatViewMediator = null;
         var _loc2_:Buddy = param1.clipboard.getData(Buddy.DATA_FORMAT) as Buddy;
         if(_loc2_)
         {
            _loc3_ = getDependency(ChatViewMediator);
            _loc3_.moveBuddyToGroup(_loc2_,this.groupDropTarget.getGroupModel().headerData.getLabel());
         }
         this.insertionIndicator.setVisible(false);
         getEnterFrame().remove(this.updateDragScrolling);
      }
      
      private function handleDragComplete(param1:NativeDragEvent) : void
      {
         if(param1.clipboard.hasFormat(Buddy.DATA_FORMAT))
         {
            this.insertionIndicator.setVisible(false);
            getEnterFrame().remove(this.updateDragScrolling);
         }
      }
      
      private function updateDragScrolling() : void
      {
         var _loc4_:Number = NaN;
         if(!getMouseIsDown())
         {
            this.insertionIndicator.setVisible(false);
            getEnterFrame().remove(this.updateDragScrolling);
            return;
         }
         var _loc1_:Number = Number(getMouseX());
         var _loc2_:Number = Number(getMouseY());
         var _loc3_:Rectangle = getUnscaledBounds();
         if(!_loc3_.contains(_loc1_,_loc2_))
         {
            this.insertionIndicator.setVisible(false);
            return;
         }
         var _loc5_:ScrollModel = _vScrollModel;
         var _loc6_:Number = _loc3_.top + _loc3_.height * DRAG_SCROLL_PERCENT;
         if(_loc2_ <= _loc6_)
         {
            _loc4_ = 1 - (_loc2_ - _loc3_.top) / (_loc3_.height * DRAG_SCROLL_PERCENT);
            _loc5_.setValue(_loc5_.clampValue(_loc5_.getValue() - DRAG_SCROLL_SPEED * _loc4_));
         }
         var _loc7_:Number = _loc3_.bottom - _loc3_.height * DRAG_SCROLL_PERCENT;
         if(_loc2_ >= _loc7_)
         {
            _loc4_ = (_loc2_ - _loc7_) / (_loc3_.height * DRAG_SCROLL_PERCENT);
            _loc5_.setValue(_loc5_.clampValue(_loc5_.getValue() + DRAG_SCROLL_SPEED * _loc4_));
         }
         var _loc8_:Rectangle = this.groupDropTarget.getScaledBounds().clone();
         _loc8_.offset(0,-_loc5_.getValue());
         _loc8_ = _loc8_.intersection(_loc3_);
         if(!_loc8_.contains(_loc1_,_loc2_))
         {
            this.insertionIndicator.setVisible(false);
         }
         else
         {
            this.insertionIndicator.setVisible(true);
            this.insertionIndicator.setExplicitSize(_loc8_.width,_loc8_.height);
            this.insertionIndicator.setExplicitPosition(_loc8_.x,_loc8_.y);
         }
      }
      
      public function filterBuddyList(param1:String) : void
      {
         this.buddyNameFilter = param1;
         this.updateBuddyGroups();
      }
      
      public function resetBuddyListFilter() : void
      {
         this.filterBuddyList("");
      }
      
      override public function destroy() : void
      {
         getEnterFrame().remove(this.updateDragScrolling);
         super.destroy();
      }
   }
}

