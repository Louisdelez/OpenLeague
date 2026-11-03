package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftDetailDisplayData;
   import flash.events.MouseEvent;
   
   public class GiftDetailLayoutContainer extends LayoutContainerView implements IDataRenderer
   {
      
      private var _giftDetailDisplayData:GiftDetailDisplayData;
      
      private var _layoutData:VerticalLayout = new VerticalLayout();
      
      private var _titleDisplay:GiftTitleView;
      
      private var _verticalDivider:SpriteProxy;
      
      private var _recipientLine:RecipientLineView;
      
      private var _giftCostView:CurrencyGroupView;
      
      private var _unlockButton:LabelButtonX;
      
      private var _onUnlock:Signal = new Signal();
      
      public function GiftDetailLayoutContainer(param1:IContext)
      {
         this._layoutData.setGap(10);
         super(param1,null);
      }
      
      override protected function createChildren() : void
      {
         this._titleDisplay = new GiftTitleView(this);
         setTimelineChildByName("giftTitleView",this._titleDisplay);
         this._verticalDivider = new SpriteProxy(this);
         setTimelineChildByName("giftLockupSeperator",this._verticalDivider);
         this._recipientLine = new RecipientLineView(this);
         setTimelineChildByName("recipientLine",this._recipientLine);
         this._giftCostView = new CurrencyGroupView(this);
         setTimelineChildByName("currencyGroup",this._giftCostView);
         this._unlockButton = new LabelButtonX(this);
         this._unlockButton.addEventListener(MouseEvent.CLICK,this.onUnlockClick);
         this._unlockButton.setAlpha(0);
         this._unlockButton.setVisible(false);
         setTimelineChildByName("unlockButton",this._unlockButton);
         super.createChildren();
         addElement(this._titleDisplay);
         addElement(this._verticalDivider);
         addElement(this._recipientLine);
         addElement(this._giftCostView);
         addElement(this._unlockButton);
         setLayoutAlgorithm(this._layoutData);
      }
      
      public function getData() : *
      {
         return this._giftDetailDisplayData;
      }
      
      public function setData(param1:*) : void
      {
         this._giftDetailDisplayData = GiftDetailDisplayData(param1);
         this._titleDisplay.setData(this._giftDetailDisplayData.giftTitleData);
         this._recipientLine.setData(this._giftDetailDisplayData.giftRecipientData);
         this._giftCostView.setData(this._giftDetailDisplayData.giftCurrencyData);
         this._unlockButton.setText(this._giftDetailDisplayData.unlockButtonLabel);
      }
      
      public function getOnUnlock() : ISignal
      {
         return this._onUnlock;
      }
      
      public function showUnlock() : void
      {
         if(this._unlockButton.getMovieClip() != null)
         {
            this._unlockButton.setVisible(true);
            TweenLite.to(this._unlockButton.getMovieClip(),1,{"alpha":1});
         }
      }
      
      public function hideUnlock() : void
      {
         if(this._unlockButton.getMovieClip() != null)
         {
            TweenLite.to(this._unlockButton.getMovieClip(),1,{
               "alpha":0,
               "onComplete":this.hideUnlockComplete
            });
         }
      }
      
      private function hideUnlockComplete() : void
      {
         this._unlockButton.setVisible(false);
      }
      
      private function onUnlockClick(param1:MouseEvent) : void
      {
         this._onUnlock.dispatch();
      }
      
      override public function destroy() : void
      {
         this._titleDisplay = null;
         this._verticalDivider = null;
         this._recipientLine = null;
         this._giftCostView = null;
         super.destroy();
      }
   }
}

