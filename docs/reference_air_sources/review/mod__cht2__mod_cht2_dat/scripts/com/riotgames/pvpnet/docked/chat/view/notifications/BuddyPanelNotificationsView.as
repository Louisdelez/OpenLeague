package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.scroll.ScrollArea;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.algorithms.VerticalLayout;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelNotificationsView extends StatefulView
   {
      
      private var _sizer:SpriteProxy;
      
      private var _notificationsScrollArea:ScrollArea;
      
      private var _inviteNotificationsView:BuddyPanelInviteNotificationsView;
      
      private var _friendNotificationsView:BuddyPanelFriendNotificationsView;
      
      private var _eventNotificationsView:BuddyPanelEventNotificationsView;
      
      private var _noNotificationsText:TextFieldProxy;
      
      private var _notificationsProvider:NotificationsProvider;
      
      public function BuddyPanelNotificationsView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._notificationsProvider.getNotificationsChanged().add(this.handleNotificationsChanged);
         this.handleNotificationsChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._notificationsProvider = getDependency(NotificationsProvider);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._notificationsScrollArea = new ScrollArea(this);
         this._notificationsScrollArea.setLinkage("ScrollContainer");
         this._notificationsScrollArea.setVScrollPolicy(ScrollPolicy.ON);
         this._notificationsScrollArea.setScrollBarsAutoPosition(false);
         this._notificationsScrollArea.getLayoutInvalidated().add(invalidateLayout);
         this._notificationsScrollArea.setKineticScrolling(true);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         this._notificationsScrollArea.getContents().setLayoutAlgorithm(_loc1_);
         addChild(this._notificationsScrollArea);
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         this._inviteNotificationsView = new BuddyPanelInviteNotificationsView(this);
         this._notificationsScrollArea.getContents().addElement(this._inviteNotificationsView);
         this._friendNotificationsView = new BuddyPanelFriendNotificationsView(this);
         this._notificationsScrollArea.getContents().addElement(this._friendNotificationsView);
         this._eventNotificationsView = new BuddyPanelEventNotificationsView(this);
         this._notificationsScrollArea.getContents().addElement(this._eventNotificationsView);
         this._noNotificationsText = new TextFieldProxy(this);
         setTimelineChildByName("noNotificationsText",this._noNotificationsText);
         this._noNotificationsText.setText(ResourceManager.getInstance().getString("resources","chat_dockedChatPrompts_no_notifications"));
         super.createChildren();
      }
      
      private function handleNotificationsChanged() : void
      {
         setCurrentState(this._notificationsProvider.getNotifications().length > 0 ? "hasNotifications" : "noNotifications");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._notificationsScrollArea.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._notificationsScrollArea.setExplicitPosition(this._sizer.getX(),this._sizer.getY());
         this._notificationsScrollArea.setScrollRect(new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight()));
         return super.updateLayout(param1,param2);
      }
   }
}

