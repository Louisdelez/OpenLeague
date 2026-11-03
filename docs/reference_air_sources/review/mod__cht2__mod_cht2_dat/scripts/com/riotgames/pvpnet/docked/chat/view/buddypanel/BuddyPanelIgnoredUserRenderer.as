package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelIgnoredUserRenderer extends LabelButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _index:uint;
      
      private var _privacyListItem:PrivacyListItem;
      
      private var _blockedBitmap:BitmapProxy;
      
      private var _blockedIconContainer:SpriteProxy;
      
      private var background:StatefulView;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _unblockContextMenuClicked:Signal = new Signal();
      
      public function BuddyPanelIgnoredUserRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("IgnoredPlayerRenderer");
         setMouseChildren(false);
      }
      
      override protected function createChildren() : void
      {
         this._blockedIconContainer = new SpriteProxy(this);
         setTimelineChildByName("ignoredIconContainer",this._blockedIconContainer);
         this._blockedBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._blockedBitmap.setTransformBehavior(_loc1_);
         this._blockedBitmap.setSmoothing(true);
         this._blockedBitmap.setBitmapData(BuddyImages.getBlockedIcon());
         addChild(this._blockedBitmap);
         this.background = new StatefulView(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         _currentStateChanged.add(this.buttonStateChanged);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleContextMenu);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._blockedBitmap.setExplicitSize(this._blockedIconContainer.getWidth(),this._blockedIconContainer.getHeight());
         this._blockedBitmap.setExplicitPosition(this._blockedIconContainer.getX(),this._blockedIconContainer.getY());
         return _asset.getBounds(null);
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      private function handleContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._privacyListItem)
         {
            return;
         }
         var _loc2_:NativeMenu = new NativeMenu();
         var _loc3_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         this.buildMenuItem(_loc2_,ResourceManager.getInstance().getString("resources","summonerContext_unblockUser_label"),this.handleUnblockUser,true);
         _loc2_.display(this.getStage(),_loc3_.x,_loc3_.y);
      }
      
      private function buildMenuItem(param1:NativeMenu, param2:String, param3:Function, param4:Boolean) : void
      {
         var _loc5_:NativeMenuItem = new NativeMenuItem(param2);
         _loc5_.enabled = param4;
         param1.addItem(_loc5_);
         if(param3 != null)
         {
            _loc5_.addEventListener(Event.SELECT,param3,false,0,true);
         }
      }
      
      private function handleUnblockUser(param1:Event) : void
      {
         this._unblockContextMenuClicked.dispatch(this._privacyListItem);
      }
      
      private function buttonStateChanged(param1:StatefulView, param2:String, param3:String) : void
      {
         this.background.setCurrentState(param3);
      }
      
      private function setPrivacyListItem(param1:PrivacyListItem) : void
      {
         this._privacyListItem = param1;
         setText(this._privacyListItem.displayName);
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         if(_selected == param1)
         {
            return;
         }
         _selected = param1;
         refreshState();
      }
      
      public function getUnblockContextMenuClicked() : ISignal
      {
         return this._unblockContextMenuClicked;
      }
      
      override public function destroy() : void
      {
         this._selectionRequested.removeAll();
         this._unblockContextMenuClicked.removeAll();
         super.destroy();
      }
      
      override public function getData() : *
      {
         return this._privacyListItem;
      }
      
      override public function setData(param1:*) : void
      {
         this.setPrivacyListItem(param1);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
   }
}

