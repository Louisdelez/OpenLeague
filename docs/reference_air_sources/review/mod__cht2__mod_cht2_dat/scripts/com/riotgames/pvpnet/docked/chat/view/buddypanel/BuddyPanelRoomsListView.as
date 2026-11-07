package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import flash.geom.Rectangle;
   
   public class BuddyPanelRoomsListView extends StatefulView
   {
      
      private var _sizer:SpriteProxy;
      
      private var _roomListingScrollArea:ScrollArea;
      
      private var _publicChatsView:BuddyPanelPublicChatsView;
      
      private var _privateChatsView:BuddyPanelPrivateChatsView;
      
      public function BuddyPanelRoomsListView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._roomListingScrollArea = new ScrollArea(this);
         this._roomListingScrollArea.setLinkage("ScrollContainer");
         this._roomListingScrollArea.setVScrollPolicy(ScrollPolicy.AUTO);
         this._roomListingScrollArea.setScrollBarsAutoPosition(false);
         this._roomListingScrollArea.getLayoutInvalidated().add(invalidateLayout);
         this._roomListingScrollArea.setKineticScrolling(true);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         this._roomListingScrollArea.getContents().setLayoutAlgorithm(_loc1_);
         addChild(this._roomListingScrollArea);
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this._publicChatsView = new BuddyPanelPublicChatsView(this);
         this._roomListingScrollArea.getContents().addElement(this._publicChatsView);
         this._privateChatsView = new BuddyPanelPrivateChatsView(this);
         this._roomListingScrollArea.getContents().addElement(this._privateChatsView);
         setCurrentState("noNotifications");
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._roomListingScrollArea.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._roomListingScrollArea.setExplicitPosition(this._sizer.getX(),this._sizer.getY());
         this._roomListingScrollArea.setScrollRect(new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight()));
         return super.updateLayout(param1,param2);
      }
   }
}

