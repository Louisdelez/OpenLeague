package blix.components.scroll
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.Context;
   import blix.frame.getEnterFrame;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import blix.view.behaviors.StandardTransformBehavior;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class ScrollBarBase extends SpriteProxy
   {
      
      public var thumbScalingBehavior:ScalingTransformBehavior;
      
      public var stepDelta:Number = 5;
      
      public var modelToPixels:Number = 1;
      
      protected var _isDraggingChanged:Signal = new Signal();
      
      protected var _scrollModel:ScrollModel;
      
      protected var _isDragging:Boolean;
      
      protected var validateAfterDragging:Boolean;
      
      protected var defaultBounds:Rectangle;
      
      protected var stepDownButton:ButtonX;
      
      protected var stepUpButton:ButtonX;
      
      protected var thumbButton:ButtonX;
      
      protected var track:ButtonX;
      
      public function ScrollBarBase(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         if(Boolean(param1))
         {
            this.defaultBounds = param1.getBounds(null);
         }
      }
      
      override protected function removedFromStageHandler(param1:Event) : void
      {
         getStage().removeEventListener(MouseEvent.MOUSE_UP,this.thumbUpHandler);
         super.removedFromStageHandler(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.stepDownButton == null)
         {
            this.stepDownButton = new ButtonX(this);
            this.stepDownButton.autoRepeat = true;
            this.stepDownButton.setTransformBehavior(new StandardTransformBehavior());
            this.stepDownButton.getLayoutInvalidated().add(invalidateLayout);
            this.stepDownButton.addEventListener(KeyboardEvent.KEY_DOWN,this.stepDownKeyDownHandler);
            this.stepDownButton.addEventListener(MouseEvent.MOUSE_DOWN,this.stepDownMouseDownHandler);
            setTimelineChildByName("stepDown",this.stepDownButton);
         }
         if(this.stepUpButton == null)
         {
            this.stepUpButton = new ButtonX(this);
            this.stepUpButton.autoRepeat = true;
            this.stepUpButton.setTransformBehavior(new StandardTransformBehavior());
            this.stepUpButton.addEventListener(KeyboardEvent.KEY_DOWN,this.stepUpKeyDownHandler);
            this.stepUpButton.addEventListener(MouseEvent.MOUSE_DOWN,this.stepUpMouseDownHandler);
            setTimelineChildByName("stepUp",this.stepUpButton);
         }
         if(this.thumbButton == null)
         {
            this.thumbButton = new ButtonX(this);
            this.thumbButton.setTabEnabled(false);
            this.thumbButton.setShowDownStateOutside(true);
            this.thumbScalingBehavior = new ScalingTransformBehavior();
            this.thumbScalingBehavior.setScalePercentConstraints(new SizeConstraints(new MinMax(1,1000),new MinMax(1,1000)));
            this.thumbScalingBehavior.setScaledSizeConstraints(new SizeConstraints(new MinMax(5,10000),new MinMax(5,10000)));
            this.thumbButton.setTransformBehavior(this.thumbScalingBehavior);
            this.thumbButton.addEventListener(MouseEvent.MOUSE_DOWN,this.thumbDownHandler);
            setTimelineChildByName("thumb",this.thumbButton);
         }
         if(this.track == null)
         {
            this.track = new ButtonX(this);
            this.track.autoRepeat = true;
            this.track.setTransformBehavior(new ScalingTransformBehavior());
            this.track.addEventListener(MouseEvent.MOUSE_DOWN,this.trackMouseDownHandler);
            setTimelineChildByName("track",this.track);
         }
      }
      
      protected function stepDownKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.ENTER)
         {
            this.stepDownButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      protected function stepDownMouseDownHandler(param1:MouseEvent = null) : void
      {
         this._scrollModel.setValue(this._scrollModel.clampValue(this._scrollModel.getValue() - this.stepDelta));
      }
      
      protected function stepUpKeyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.ENTER)
         {
            this.stepUpButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      protected function stepUpMouseDownHandler(param1:MouseEvent = null) : void
      {
         this._scrollModel.setValue(this._scrollModel.clampValue(this._scrollModel.getValue() + this.stepDelta));
      }
      
      protected function trackMouseDownHandler(param1:MouseEvent) : void
      {
         throw new Error("ScrollBarBase is abstract and trackMouseDownHandler must be overwritten.");
      }
      
      protected function thumbDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = this.getDragBounds();
         getStage().addEventListener(MouseEvent.MOUSE_UP,this.thumbUpHandler);
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
         getStage().removeEventListener(MouseEvent.MOUSE_UP,this.thumbUpHandler);
         this.thumbButton.stopDrag();
         this.setIsDragging(false);
         this.updateScrollModelValue();
         if(this.validateAfterDragging)
         {
            layoutIsValidFlag = false;
            validate();
            this.validateAfterDragging = false;
         }
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
         invalidateLayout();
      }
      
      protected function getPageSize() : Number
      {
         throw new Error("ScrollBarBase is abstract and getDefaultPageSize must be overridden.");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this._isDragging)
         {
            this.validateAfterDragging = true;
         }
         var _loc3_:Boolean = this._scrollModel.getMax() > this._scrollModel.getMin();
         this.stepUpButton.setEnabled(_loc3_);
         this.stepDownButton.setEnabled(_loc3_);
         this.track.setEnabled(_loc3_);
         this.thumbButton.setEnabled(_loc3_);
         return new Rectangle();
      }
      
      override public function destroy() : void
      {
         this.thumbButton.stopDrag();
         this.setIsDragging(false);
         super.destroy();
      }
   }
}

