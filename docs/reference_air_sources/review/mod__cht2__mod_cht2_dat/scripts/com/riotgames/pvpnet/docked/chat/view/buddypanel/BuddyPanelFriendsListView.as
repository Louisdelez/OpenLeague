package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.docked.chat.view.accordion.AccordionEntry;
   import com.riotgames.pvpnet.docked.chat.view.accordion.AccordionView;
   import com.riotgames.pvpnet.docked.chat.view.accordion.BuddyPanelAccordionHeader;
   import com.riotgames.pvpnet.docked.friendlist.view.FriendScroller;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelFriendsListView extends SpriteProxy
   {
      
      private var _sizer:SpriteProxy;
      
      private var friendList:FriendScroller;
      
      private var recentPlayersList:BuddyPanelRecentPlayersView;
      
      private var ignoreList:BuddyPanelIgnoreListView;
      
      private var accordion:AccordionView;
      
      private var ignoreListExpanded:Signal = new Signal();
      
      private var otherListExpanded:Signal = new Signal();
      
      public function BuddyPanelFriendsListView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.accordion = new AccordionView(this,new Sprite());
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this._sizer.getAssetChanged().add(this.onSizerSet);
         addChild(this.accordion);
         this.accordion.setExplicitPosition(this._sizer.getActualPosition().x,this._sizer.getActualPosition().y);
         var _loc1_:Vector.<AccordionEntry> = new Vector.<AccordionEntry>();
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         this.friendList = new FriendScroller(this);
         _loc1_.push(new AccordionEntry(_loc2_.getString("resources","chat_buddyWindow_buddyBayLabel"),this.friendList));
         this.recentPlayersList = new BuddyPanelRecentPlayersView(this);
         _loc1_.push(new AccordionEntry(_loc2_.getString("resources","chat_buddyWindow_recentlyPlayedLabel"),this.recentPlayersList));
         this.ignoreList = new BuddyPanelIgnoreListView(this);
         _loc1_.push(new AccordionEntry(_loc2_.getString("resources","chat_buddyWindow_ignoreLabel"),this.ignoreList));
         this.accordion.rendererClass = BuddyPanelAccordionHeader;
         this.accordion.setData(_loc1_);
      }
      
      private function onSizerSet() : void
      {
         if(this._sizer.getAsset())
         {
            this.accordion.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         }
      }
      
      private function onAccordionItemExpanded(param1:AccordionEntry) : void
      {
         var _loc2_:DisplayObjectProxy = param1.content;
         if(_loc2_ == this.ignoreList)
         {
            this.ignoreListExpanded.dispatch();
         }
         else
         {
            this.otherListExpanded.dispatch();
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.accordion.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this.accordion.getItemExpanded().add(this.onAccordionItemExpanded);
         return super.updateLayout(param1,param2);
      }
      
      public function resetBuddyListFilter() : void
      {
         this.friendList.resetBuddyListFilter();
      }
      
      public function filterBuddyList(param1:String) : void
      {
         this.friendList.filterBuddyList(param1);
      }
      
      public function setShowOfflineFriends(param1:Boolean) : void
      {
         this.friendList.setShowOfflineFriends(param1);
      }
      
      public function setFriendScrollerSortMode(param1:String) : void
      {
         this.friendList.setSortMode(param1);
      }
      
      public function getIgnoreListExpanded() : Signal
      {
         return this.ignoreListExpanded;
      }
      
      public function getOtherListExpanded() : Signal
      {
         return this.otherListExpanded;
      }
   }
}

