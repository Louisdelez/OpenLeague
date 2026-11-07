package com.riotgames.rust.components
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.Context;
   import blix.signals.Signal;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class DumbScroller extends DumbScrollerBase
   {
      
      private static const DEFAULT_MIN_THUMB_SIZE:Number = 20;
      
      public var stepUpSignal:Signal = new Signal();
      
      public var stepDownSignal:Signal = new Signal();
      
      public var pageUpSignal:Signal = new Signal();
      
      public var pageDownSignal:Signal = new Signal();
      
      public var snapSignal:Signal = new Signal();
      
      public var minimumThumbSize:Number = 20;
      
      private var isHorizontal:Boolean;
      
      private var _pageSize:Number;
      
      public function DumbScroller(param1:Context)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         track = this.wire("track",ButtonX);
         track.getAssetChanged().add(this.onTrackSet);
         this.onTrackSet();
         super.createChildren();
         stepUpButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onStepUpClicked);
         stepDownButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onStepDownClicked);
         track.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackClicked);
      }
      
      public function set pageSize(param1:Number) : void
      {
         this._pageSize = param1;
         invalidateLayout();
      }
      
      private function onTrackSet() : void
      {
         if(Boolean(track.getAsset()))
         {
            this.isHorizontal = track.getWidth() > track.getHeight();
         }
      }
      
      private function onStepUpClicked(param1:MouseEvent) : void
      {
         this.stepUpSignal.dispatch(this);
      }
      
      private function onStepDownClicked(param1:MouseEvent) : void
      {
         this.stepDownSignal.dispatch(this);
      }
      
      private function onTrackClicked(param1:MouseEvent) : void
      {
         if(this.isHorizontal)
         {
            if(getMouseX() < thumbButton.getX())
            {
               this.pageDownSignal.dispatch(this);
            }
            else if(getMouseX() > thumbButton.getX() + thumbButton.getWidth())
            {
               this.pageUpSignal.dispatch(this);
            }
         }
         else if(getMouseY() < thumbButton.getY())
         {
            this.pageDownSignal.dispatch(this);
         }
         else if(getMouseY() > thumbButton.getY() + thumbButton.getHeight())
         {
            this.pageUpSignal.dispatch(this);
         }
      }
      
      override protected function thumbUpHandler(param1:MouseEvent) : void
      {
         if(getIsDragging())
         {
            super.thumbUpHandler(param1);
            this.snapSignal.dispatch();
         }
      }
      
      override protected function getDragBounds() : Rectangle
      {
         if(this.isHorizontal)
         {
            return new Rectangle(track.getX(),0,track.getWidth() - thumbButton.getWidth() + 1,0);
         }
         return new Rectangle(0,track.getY(),0,track.getHeight() - thumbButton.getHeight() + 1);
      }
      
      private function getSpan() : Number
      {
         if(this.isHorizontal)
         {
            return track.getWidth() - thumbButton.getWidth();
         }
         return track.getHeight() - thumbButton.getHeight();
      }
      
      override protected function updateScrollModelValue() : void
      {
         var _loc1_:Number = NaN;
         if(this.isHorizontal)
         {
            _loc1_ = (thumbButton.getX() - track.getX()) / this.getSpan();
         }
         else
         {
            _loc1_ = (thumbButton.getY() - track.getY()) / this.getSpan();
         }
         _scrollModel.setValue(_scrollModel.getMin() + _loc1_ * (_scrollModel.getMax() - _scrollModel.getMin()));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:Number = _scrollModel.getMax() + this._pageSize;
         if(_loc3_ > 0)
         {
            _loc5_ = this.isHorizontal ? Number(track.getWidth()) : Number(track.getHeight());
            _loc6_ = this._pageSize / _loc3_ * _loc5_;
            _loc6_ = Math.min(Math.max(this.minimumThumbSize,_loc6_),_loc5_);
            if(this.isHorizontal)
            {
               thumbButton.setWidth(_loc6_);
            }
            else
            {
               thumbButton.setHeight(_loc6_);
            }
         }
         var _loc4_:Number = (_scrollModel.getClampedValue() - _scrollModel.getMin()) / (_scrollModel.getMax() - _scrollModel.getMin());
         if(this.isHorizontal)
         {
            thumbButton.setX(track.getX() + _loc4_ * this.getSpan());
         }
         else
         {
            thumbButton.setY(track.getY() + _loc4_ * this.getSpan());
         }
         return super.updateLayout(param1,param2);
      }
      
      protected function wire(param1:String, param2:Class = null) : *
      {
         if(param2 == null)
         {
            param2 = SpriteProxy;
         }
         var _loc3_:DisplayObjectProxy = new param2(this);
         setTimelineChildByName(param1,_loc3_);
         return _loc3_;
      }
   }
}

