package com.riotgames.pvpnet.cap.views.popups
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class CapEditMasteriesPopup extends SpriteProxy
   {
      
      protected var masteriesProvider:IMasteriesProvider;
      
      protected var summonerId:Number;
      
      public var closeButton:ButtonX;
      
      private var displayAdapter:DisplayAdapter;
      
      public var closeClicked:Signal = new Signal();
      
      public function CapEditMasteriesPopup(param1:IContext, param2:IMasteriesProvider, param3:Number = 0)
      {
         this.masteriesProvider = param2;
         this.summonerId = param3;
         super(param1);
         setLinkage("EditMasteriesPopup");
      }
      
      override public function destroy() : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardClick);
         if(this.closeButton)
         {
            this.closeButton.destroy();
            this.closeButton = null;
         }
         if(this.displayAdapter)
         {
            this.displayAdapter = null;
         }
         super.destroy();
      }
      
      private function onKeyboardClick(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.closeClicked.dispatch();
         }
      }
      
      protected function handleCloseClick(param1:MouseEvent) : void
      {
         this.closeClicked.dispatch();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.displayAdapter = new DisplayAdapter(this);
         this.masteriesProvider.showMasteries(this.summonerId,this.displayAdapter);
         this.closeButton = new ButtonX(this);
         setTimelineChildByName("close",this.closeButton);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseClick);
         this.closeButton.getAssetChanged().addOnce(this.bringToFront);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardClick);
      }
      
      private function bringToFront() : void
      {
         var _loc1_:DisplayObject = null;
         if(Boolean(this.closeButton.getAsset()) && Boolean(this.closeButton.getAsset().parent))
         {
            _loc1_ = this.closeButton.getAsset();
            _loc1_.parent.setChildIndex(_loc1_,_loc1_.parent.numChildren - 1);
         }
      }
      
      protected function close() : void
      {
         this.masteriesProvider.closeMasteries();
      }
   }
}

