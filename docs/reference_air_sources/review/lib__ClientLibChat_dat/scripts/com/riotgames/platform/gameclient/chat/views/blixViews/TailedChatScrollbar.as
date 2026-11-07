package com.riotgames.platform.gameclient.chat.views.blixViews
{
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.scroll.VScrollBarX;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class TailedChatScrollbar extends VScrollBarX
   {
      
      private var _mousewheelTarget:InteractiveObjectProxy;
      
      private var _onThumbMoved:Signal = new Signal();
      
      private var _unTailChatSignal:Signal = new Signal();
      
      private const WHEEL_DELTA:uint = 20;
      
      public function TailedChatScrollbar(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      public function setMousewheelEventTarget(param1:InteractiveObjectProxy) : void
      {
         this._mousewheelTarget = param1;
         this._mousewheelTarget.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,false,0,true);
      }
      
      public function get unTailChatSignal() : Signal
      {
         return this._unTailChatSignal;
      }
      
      override protected function trackMouseDownHandler(param1:MouseEvent) : void
      {
         super.trackMouseDownHandler(param1);
         this._unTailChatSignal.dispatch();
      }
      
      override protected function stepUpMouseDownHandler(param1:MouseEvent = null) : void
      {
         super.stepUpMouseDownHandler(param1);
         this._onThumbMoved.dispatch();
      }
      
      override protected function thumbDownHandler(param1:MouseEvent) : void
      {
         super.thumbDownHandler(param1);
         this._unTailChatSignal.dispatch();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         this.setVisible(thumbButton.getVisible());
         return _loc3_;
      }
      
      private function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            if(_scrollModel.getClampedValue() > 1)
            {
               _scrollModel.setValue(_scrollModel.getClampedValue() - this.WHEEL_DELTA);
            }
         }
         else
         {
            _scrollModel.setValue(_scrollModel.getClampedValue() + this.WHEEL_DELTA);
         }
         invalidateLayout();
         this._onThumbMoved.dispatch();
      }
      
      override protected function stepDownMouseDownHandler(param1:MouseEvent = null) : void
      {
         super.stepDownMouseDownHandler(param1);
         this._onThumbMoved.dispatch();
      }
      
      override protected function thumbUpHandler(param1:MouseEvent) : void
      {
         super.thumbUpHandler(param1);
         this._onThumbMoved.dispatch();
      }
      
      public function get onThumbMoved() : ISignal
      {
         return this._onThumbMoved;
      }
   }
}

