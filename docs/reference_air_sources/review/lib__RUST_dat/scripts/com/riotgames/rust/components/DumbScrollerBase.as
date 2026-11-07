package com.riotgames.rust.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.scroll.ScrollModel;
   import blix.context.Context;
   import blix.frame.getEnterFrame;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class DumbScrollerBase extends SpriteProxy
   {
      
      protected var _isDraggingChanged:Signal = new Signal();
      
      protected var stepUpButton:ButtonX;
      
      protected var stepDownButton:ButtonX;
      
      protected var thumbButton:ButtonX;
      
      protected var track:SpriteProxy;
      
      protected var _autoHide:Boolean = true;
      
      protected var _scrollModel:ScrollModel;
      
      protected var _isDragging:Boolean;
      
      protected var defaultSize:Rectangle;
      
      public function DumbScrollerBase(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.stepUpButton == null)
         {
            this.stepUpButton = new ButtonX(this);
            setTimelineChildByName("stepUp",this.stepUpButton);
         }
         if(this.stepDownButton == null)
         {
            this.stepDownButton = new ButtonX(this);
            this.stepDownButton.getLayoutInvalidated().add(invalidateLayout);
            setTimelineChildByName("stepDown",this.stepDownButton);
         }
         if(this.thumbButton == null)
         {
            this.thumbButton = new ButtonX(this);
            this.thumbButton.setTransformBehavior(new ScalingTransformBehavior());
            this.thumbButton.addEventListener(MouseEvent.MOUSE_DOWN,this.thumbDownHandler);
            setTimelineChildByName("thumb",this.thumbButton);
         }
         if(this.track == null)
         {
            this.track = new SpriteProxy(this);
            setTimelineChildByName("track",this.track);
         }
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         this.defaultSize = getBounds(null);
      }
      
      protected function thumbDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = this.getDragBounds();
         this.thumbButton.getStage().addEventListener(MouseEvent.MOUSE_UP,this.thumbUpHandler);
         this.thumbButton.startDrag(false,_loc2_);
         this.setIsDragging(true);
      }
      
      [Abstract]
      protected function getDragBounds() : Rectangle
      {
         throw new Error("ScrollBarBase is abstract and getDragBounds must be overwritten.");
      }
      
      protected function thumbUpHandler(param1:MouseEvent) : void
      {
         (param1.currentTarget as IEventDispatcher).removeEventListener(param1.type,this.thumbUpHandler);
         this.thumbButton.stopDrag();
         this.setIsDragging(false);
         this.updateScrollModelValue();
      }
      
      [Abstract]
      protected function updateScrollModelValue() : void
      {
         throw new Error("ScrollBarBase is abstract and updateScrollModelValue must be overwritten.");
      }
      
      public function getIsDraggingChanged() : ISignal
      {
         return this._isDraggingChanged;
      }
      
      public function getIsDragging() : Boolean
      {
         return this._isDragging;
      }
      
      protected function setIsDragging(param1:Boolean) : void
      {
         if(this._isDragging == param1)
         {
            return;
         }
         this._isDragging = param1;
         if(this._isDragging)
         {
            getEnterFrame().add(this.draggingEnterFrameHandler);
         }
         else
         {
            getEnterFrame().remove(this.draggingEnterFrameHandler);
         }
         this._isDraggingChanged.dispatch(this,param1);
      }
      
      protected function draggingEnterFrameHandler() : void
      {
         this.updateScrollModelValue();
      }
      
      public function getScrollModel() : ScrollModel
      {
         return this._scrollModel;
      }
      
      public function setScrollModel(param1:ScrollModel) : void
      {
         if(this._scrollModel == param1)
         {
            return;
         }
         if(this._scrollModel != null)
         {
            this._scrollModel.getChanged().remove(this.scrollModelChangedHandler);
         }
         this._scrollModel = param1;
         if(this._scrollModel != null)
         {
            this._scrollModel.getChanged().add(this.scrollModelChangedHandler);
         }
         this.scrollModelChangedHandler();
      }
      
      protected function scrollModelChangedHandler() : void
      {
         if(this._autoHide)
         {
            this.refreshVisibility();
         }
         invalidateLayout();
      }
      
      public function getAutoHide() : Boolean
      {
         return this._autoHide;
      }
      
      public function setAutoHide(param1:Boolean) : void
      {
         if(this._autoHide == param1)
         {
            return;
         }
         this._autoHide = param1;
         if(!param1)
         {
            setVisible(true);
         }
         else
         {
            this.refreshVisibility();
         }
      }
      
      protected function refreshVisibility() : void
      {
         if(this._scrollModel == null)
         {
            setVisible(false);
            return;
         }
         setVisible(this._scrollModel.getMax() > this._scrollModel.getMin());
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.thumbButton.getStage()))
         {
            this.thumbButton.getStage().removeEventListener(MouseEvent.MOUSE_UP,this.thumbUpHandler);
         }
         this.thumbButton.stopDrag();
         this.setIsDragging(false);
         super.destroy();
      }
   }
}

