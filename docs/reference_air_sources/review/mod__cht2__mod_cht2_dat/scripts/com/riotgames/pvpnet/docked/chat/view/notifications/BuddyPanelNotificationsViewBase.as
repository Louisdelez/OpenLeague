package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BuddyPanelNotificationsViewBase extends SpriteProxy
   {
      
      protected var _notificationsProvider:NotificationsProvider;
      
      protected var _sectionHeader:BuddyPanelNotificationsHeader;
      
      protected var _rendererFactory:RendererFactory;
      
      protected var _notificationsListView:ListView;
      
      protected var _notificationsDataGroup:DataGroup;
      
      protected var _myNotifications:Vector.<DockedPrompt>;
      
      private var timeoutId:uint;
      
      private var _showIntro:Boolean;
      
      public function BuddyPanelNotificationsViewBase(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function initializeDependencies() : void
      {
         this._notificationsProvider = getDependency(NotificationsProvider);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._rendererFactory = new RendererFactory(EventNotificationListRenderer,[this]);
         this._notificationsListView = new ListView();
         this._sectionHeader = new BuddyPanelNotificationsHeader(this);
         this._sectionHeader.getClearRequested().add(this.handleClearRequested);
         addChild(this._sectionHeader);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(1);
         var _loc2_:Padding = new Padding(1,0,0,0);
         _loc1_.setPadding(_loc2_);
         this._notificationsDataGroup = new DataGroup(this);
         this._notificationsDataGroup.setRendererFactory(this._rendererFactory);
         this._notificationsDataGroup.setDataProvider(this._notificationsListView);
         this._notificationsDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._notificationsDataGroup.setLayoutAlgorithm(_loc1_);
         addChild(this._notificationsDataGroup);
         this._notificationsProvider.getNotificationsChanged().add(this.handleNotificationsChanged);
         this.handleNotificationsChanged();
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._notificationsDataGroup.setExplicitSize(NaN,NaN);
         this._notificationsDataGroup.setExplicitPosition(0,this._sectionHeader.getHeight());
         return new Rectangle(0,0,_loc3_.x,_loc3_.y + this._sectionHeader.getHeight());
      }
      
      private function handleNotificationsChanged() : void
      {
         var _loc2_:DockedPrompt = null;
         var _loc3_:Boolean = false;
         var _loc1_:Vector.<DockedPrompt> = this._notificationsProvider.getNotifications();
         this._myNotifications = new Vector.<DockedPrompt>();
         for each(_loc2_ in _loc1_)
         {
            if(this.notificationFilter(_loc2_))
            {
               this._myNotifications.push(_loc2_);
            }
         }
         this._notificationsListView.setSource(this._myNotifications);
         _loc3_ = this._myNotifications.length > 0;
         setVisible(_loc3_);
      }
      
      protected function notificationFilter(param1:DockedPrompt) : Boolean
      {
         throw new Error("notificationFilter needs to be overridden.");
      }
      
      protected function handleClearRequested() : void
      {
         throw new Error("handleClearRequested needs to be overridden.");
      }
      
      override public function destroy() : void
      {
         this._rendererFactory.destroy();
         super.destroy();
      }
   }
}

