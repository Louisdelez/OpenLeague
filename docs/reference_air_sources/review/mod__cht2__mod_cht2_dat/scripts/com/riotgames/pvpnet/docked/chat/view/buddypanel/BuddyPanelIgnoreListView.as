package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.rust.data.ListAdapter;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   
   public class BuddyPanelIgnoreListView extends SpriteProxy
   {
      
      private var _chatViewMediator:ChatViewMediator;
      
      private var _ignoreListAdapter:ListAdapter;
      
      private var _ignoreList:ListView;
      
      private var _ignoredPlayersDataScroller:DataScroller;
      
      private var _rendererFactory:RendererFactory;
      
      public function BuddyPanelIgnoreListView(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function initializeDependencies() : void
      {
         this._chatViewMediator = getDependency(ChatViewMediator);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._ignoredPlayersDataScroller = new DataScroller(this);
         this._ignoredPlayersDataScroller.getLayoutInvalidated().add(invalidateLayout);
         this._ignoredPlayersDataScroller.setLinkage("ScrollContainer");
         this._ignoredPlayersDataScroller.setScrollPolicy(ScrollPolicy.AUTO);
         this._ignoredPlayersDataScroller.setScrollBarsAutoPosition(false);
         this._rendererFactory = new RendererFactory(BuddyPanelIgnoredUserRenderer,[this]);
         this._rendererFactory.getEntryActivated().add(this.activateEntry);
         this._rendererFactory.getEntryDeactivated().add(this.deactivateEntry);
         this._ignoredPlayersDataScroller.setRendererFactory(this._rendererFactory);
         this._ignoreListAdapter = new ListAdapter();
         this._ignoreList = new ListView(this._ignoreListAdapter);
         this._ignoredPlayersDataScroller.getSelectionBehavior().allowMultipleSelection = true;
         this._ignoredPlayersDataScroller.setDataProvider(this._ignoreList);
         this._ignoreList.sortWithCompare(this.sortIgnoreItems);
         this.updatePrivacyList();
         this._chatViewMediator.getPrivacyListChanged().add(this.updatePrivacyList);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(1);
         this._ignoredPlayersDataScroller.setLayoutAlgorithm(_loc1_);
         addChild(this._ignoredPlayersDataScroller);
         super.createChildren();
      }
      
      private function activateEntry(param1:LayoutEntry, param2:PrivacyListItem) : void
      {
         var _loc3_:BuddyPanelIgnoredUserRenderer = param1.element as BuddyPanelIgnoredUserRenderer;
         _loc3_.getUnblockContextMenuClicked().add(this.unblockUsers);
      }
      
      private function deactivateEntry(param1:LayoutEntry) : void
      {
         var _loc2_:BuddyPanelIgnoredUserRenderer = param1.element as BuddyPanelIgnoredUserRenderer;
         _loc2_.getUnblockContextMenuClicked().remove(this.unblockUsers);
      }
      
      private function unblockUsers(param1:PrivacyListItem) : void
      {
         var _loc4_:PrivacyListItem = null;
         var _loc2_:ChatViewMediator = getDependency(ChatViewMediator);
         var _loc3_:Vector.<Object> = this._ignoredPlayersDataScroller.getSelectionBehavior().getSelectedItems();
         for each(_loc4_ in _loc3_)
         {
            _loc2_.unblockUser(_loc4_ as PrivacyListItem);
         }
         _loc2_.unblockUser(param1);
      }
      
      private function sortIgnoreItems(param1:PrivacyListItem, param2:PrivacyListItem) : Number
      {
         if(param1 == param2)
         {
            return 0;
         }
         if(param2 == null || param2.displayName == null)
         {
            return -1;
         }
         if(param1 == null || param1.displayName == null)
         {
            return 1;
         }
         var _loc3_:String = param1.displayName.toLowerCase();
         var _loc4_:String = param2.displayName.toLowerCase();
         return _loc4_ > _loc3_ ? -1 : 1;
      }
      
      private function updatePrivacyList() : void
      {
         var _loc1_:ArrayCollection = this._chatViewMediator.getPrivacyList();
         this._ignoreListAdapter.setList(_loc1_);
      }
      
      override public function destroy() : void
      {
         this._chatViewMediator.getPrivacyListChanged().remove(this.updatePrivacyList);
         this._rendererFactory.destroy();
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._ignoredPlayersDataScroller.setExplicitSize(param1,param2 - 75);
         return this._ignoredPlayersDataScroller.getScaledBounds();
      }
   }
}

