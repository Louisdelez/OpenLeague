package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelNotificationsHeader extends SpriteProxy
   {
      
      private var _label:TextFieldProxy;
      
      private var _clearButton:ButtonX;
      
      private var _clearRequested:Signal = new Signal();
      
      public function BuddyPanelNotificationsHeader(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("NotificationHeader");
      }
      
      override protected function createChildren() : void
      {
         this._clearButton = new ButtonX(this);
         setTimelineChildByName("clearNotificationsButton",this._clearButton);
         this._clearButton.addEventListener(MouseEvent.CLICK,this.handleClearButtonClicked);
         assignToolTip(this._clearButton,ResourceManager.getInstance().getString("resources","chat_notificationsHeader_clearAll"));
         this._label = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._label);
         super.createChildren();
      }
      
      private function handleClearButtonClicked(param1:MouseEvent) : void
      {
         this._clearRequested.dispatch();
      }
      
      public function getClearRequested() : ISignal
      {
         return this._clearRequested;
      }
      
      public function setLabel(param1:String) : void
      {
         this._label.setText(param1);
      }
   }
}

