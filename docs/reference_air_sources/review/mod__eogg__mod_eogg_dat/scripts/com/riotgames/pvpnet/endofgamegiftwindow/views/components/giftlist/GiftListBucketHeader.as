package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftlist
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.GiftCategories;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftBucketHeaderData;
   import flash.events.MouseEvent;
   
   public class GiftListBucketHeader extends StatefulView implements IGiftListBucketHeader
   {
      
      private static const GIFT_LIST_BUCKET_HEADER_LINKAGE:String = "assets.GiftDrawer";
      
      private static const ICON_LINKAGE_RECOMMENDED:String = "assets.RecoDrawerIcon";
      
      private static const ICON_LINKAGE_CHAMPION:String = "assets.ChampDrawerIcon";
      
      private var _bucketHeaderData:GiftBucketHeaderData;
      
      private var _isExpanded:Boolean;
      
      private var _headerLabel:TextFieldProxy;
      
      private var _headerToggleArrow:SpriteProxy;
      
      private var _headerIconContainer:DisplayObjectContainerProxy;
      
      private var _headerIcon:SpriteProxy;
      
      private var _doExpand:Signal = new Signal();
      
      private var _doCollapse:Signal = new Signal();
      
      private var _selectionIndex:uint;
      
      public function GiftListBucketHeader(param1:IContext)
      {
         super(param1,null);
         setLinkage(GIFT_LIST_BUCKET_HEADER_LINKAGE);
      }
      
      override protected function createChildren() : void
      {
         this._headerLabel = new TextFieldProxy(this);
         setTimelineChildByName("drawerText",this._headerLabel);
         this._headerIconContainer = new DisplayObjectContainerProxy(this);
         setTimelineChildByName("iconPlaceholder",this._headerIconContainer);
         this._headerToggleArrow = new SpriteProxy(this);
         setTimelineChildByName("arrow",this._headerToggleArrow);
         this._headerIcon = new SpriteProxy(this);
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._bucketHeaderData;
      }
      
      public function setData(param1:*) : void
      {
         this._bucketHeaderData = GiftBucketHeaderData(param1);
         this.redrawView();
      }
      
      override public function destroy() : void
      {
         this._bucketHeaderData = null;
         if(hasEventListener(MouseEvent.CLICK))
         {
            removeEventListener(MouseEvent.CLICK,this.onHeaderClick);
         }
         this._doExpand.removeAll();
         this._doExpand = null;
         this._doCollapse.removeAll();
         this._doCollapse = null;
         super.destroy();
      }
      
      public function getIndex() : uint
      {
         return this._selectionIndex;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._selectionIndex = param1;
      }
      
      public function get doExpand() : ISignal
      {
         return this._doExpand;
      }
      
      public function get doCollapse() : ISignal
      {
         return this._doCollapse;
      }
      
      private function clearDynamicChildren() : void
      {
         this._headerIconContainer.removeAllChildren();
      }
      
      private function redrawView() : void
      {
         this.clearDynamicChildren();
         this.updateIcon();
         this._headerLabel.setText(this._bucketHeaderData.bucketTitle);
         if(this._bucketHeaderData.isEnabled)
         {
            this.gotoExpanded();
            addEventListener(MouseEvent.CLICK,this.onHeaderClick);
         }
         else
         {
            this.gotoUnexpandable();
            if(hasEventListener(MouseEvent.CLICK))
            {
               removeEventListener(MouseEvent.CLICK,this.onHeaderClick);
            }
         }
      }
      
      private function updateIcon() : void
      {
         this._headerIcon.setLinkage(this.getIconLinkageByGiftType());
         this._headerIconContainer.addChild(this._headerIcon);
      }
      
      private function getIconLinkageByGiftType() : String
      {
         if(this._bucketHeaderData.giftBucketType == GiftCategories.RECOMMENDED)
         {
            return ICON_LINKAGE_RECOMMENDED;
         }
         return ICON_LINKAGE_CHAMPION;
      }
      
      private function onHeaderClick(param1:MouseEvent) : void
      {
         if(this._isExpanded)
         {
            this.gotoCollapsed();
         }
         else
         {
            this.gotoExpanded();
         }
      }
      
      private function gotoExpanded() : void
      {
         setCurrentState("expanded");
         this._isExpanded = true;
         this._doExpand.dispatch(this);
      }
      
      private function gotoCollapsed() : void
      {
         setCurrentState("collapsed");
         this._isExpanded = false;
         this._doCollapse.dispatch(this);
      }
      
      private function gotoUnexpandable() : void
      {
         setCurrentState("unexpandable");
         this._isExpanded = false;
      }
   }
}

