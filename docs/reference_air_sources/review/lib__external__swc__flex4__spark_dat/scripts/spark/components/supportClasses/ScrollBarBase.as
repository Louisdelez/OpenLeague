package spark.components.supportClasses
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.events.SandboxMouseEvent;
   import spark.components.Button;
   import spark.core.IViewport;
   import spark.effects.animation.Animation;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Linear;
   import spark.effects.easing.Sine;
   import spark.events.TrackBaseEvent;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Style(name="smoothScrolling",type="Boolean",inherit="no")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no",minValueExclusive="0.0")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no",minValue="0.0")]
   [Style(name="liveDragging",type="Boolean",inherit="no")]
   [Style(name="autoThumbVisibility",type="Boolean",inherit="no")]
   [Style(name="fixedThumbSize",type="Boolean",inherit="no")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [SkinState("inactive")]
   public class ScrollBarBase extends TrackBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var linearEaser:IEaser = new Linear();
      
      private static var easyInLinearEaser:IEaser = new Linear(0.1);
      
      private static var deceleratingSineEaser:IEaser = new Sine(0);
      
      private static var _skinParts:Object = {
         "incrementButton":false,
         "track":false,
         "thumb":false,
         "decrementButton":false
      };
      
      [SkinPart(required="false")]
      public var decrementButton:Button;
      
      [SkinPart(required="false")]
      public var incrementButton:Button;
      
      private var _animator:Animation = null;
      
      private var steppingDown:Boolean;
      
      private var steppingUp:Boolean;
      
      private var isStepping:Boolean;
      
      private var animatingOnce:Boolean;
      
      private var clickOffset:Point;
      
      private var trackScrollDown:Boolean;
      
      private var trackScrollTimer:Timer;
      
      private var trackPosition:Point = new Point();
      
      private var trackScrolling:Boolean = false;
      
      private var _pageSize:Number = 20;
      
      private var pageSizeChanged:Boolean = false;
      
      private var _pendingValue:Number = 0;
      
      private var _viewport:IViewport;
      
      private var _contentMinimum:Number = NaN;
      
      private var _contentMaximum:Number = NaN;
      
      public function ScrollBarBase()
      {
         super();
      }
      
      private function get animator() : Animation
      {
         if(Boolean(this._animator))
         {
            return this._animator;
         }
         this._animator = new Animation();
         var animTarget:AnimationTarget = new AnimationTarget(this.animationUpdateHandler);
         animTarget.endFunction = this.animationEndHandler;
         this._animator.animationTarget = animTarget;
         return this._animator;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      override public function set minimum(value:Number) : void
      {
         if(value == super.minimum)
         {
            return;
         }
         super.minimum = value;
         invalidateSkinState();
      }
      
      [Inspectable(category="General",defaultValue="100.0")]
      override public function set maximum(value:Number) : void
      {
         if(value == super.maximum)
         {
            return;
         }
         super.maximum = value;
         invalidateSkinState();
      }
      
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0")]
      override public function set snapInterval(value:Number) : void
      {
         super.snapInterval = value;
         this.pageSizeChanged = true;
      }
      
      override protected function setValue(value:Number) : void
      {
         this._pendingValue = value;
         super.setValue(value);
      }
      
      [Inspectable(category="General",defaultValue="20",minValue="0.0")]
      public function get pageSize() : Number
      {
         return this._pageSize;
      }
      
      public function set pageSize(value:Number) : void
      {
         if(value == this._pageSize)
         {
            return;
         }
         this._pageSize = value;
         this.pageSizeChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      protected function get pendingValue() : Number
      {
         return this._pendingValue;
      }
      
      protected function set pendingValue(value:Number) : void
      {
         if(value == this._pendingValue)
         {
            return;
         }
         this._pendingValue = value;
         invalidateDisplayList();
      }
      
      public function get viewport() : IViewport
      {
         return this._viewport;
      }
      
      public function set viewport(value:IViewport) : void
      {
         if(value == this._viewport)
         {
            return;
         }
         if(Boolean(this._viewport))
         {
            this._viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.viewport_propertyChangeHandler);
            this._viewport.removeEventListener(ResizeEvent.RESIZE,this.viewportResizeHandler);
            this._viewport.clipAndEnableScrolling = false;
         }
         this._viewport = value;
         if(Boolean(this._viewport))
         {
            this._viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.viewport_propertyChangeHandler);
            this._viewport.addEventListener(ResizeEvent.RESIZE,this.viewportResizeHandler);
            this._viewport.clipAndEnableScrolling = true;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get contentMinimum() : Number
      {
         return this._contentMinimum;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set contentMinimum(value:Number) : void
      {
         if(value == this._contentMinimum)
         {
            return;
         }
         this._contentMinimum = value;
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get contentMaximum() : Number
      {
         return this._contentMaximum;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set contentMaximum(value:Number) : void
      {
         if(value == this._contentMaximum)
         {
            return;
         }
         this._contentMaximum = value;
         invalidateDisplayList();
      }
      
      private function startAnimation(duration:Number, valueTo:Number, easer:IEaser, startDelay:Number = 0) : void
      {
         this.animator.stop();
         this.animator.duration = duration;
         this.animator.easer = easer;
         this.animator.motionPaths = new <MotionPath>[new SimpleMotionPath("value",value,valueTo)];
         this.animator.startDelay = startDelay;
         this.animator.play();
      }
      
      private function nearestValidSize(size:Number) : Number
      {
         var interval:Number = snapInterval;
         if(interval == 0)
         {
            return size;
         }
         var validSize:Number = Math.round(size / interval) * interval;
         return Math.abs(validSize) < interval ? interval : validSize;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.pageSizeChanged)
         {
            this._pageSize = this.nearestValidSize(this._pageSize);
            this.pageSizeChanged = false;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(maximum <= minimum)
         {
            return "inactive";
         }
         return super.getCurrentSkinState();
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.decrementButton)
         {
            this.decrementButton.addEventListener(FlexEvent.BUTTON_DOWN,this.button_buttonDownHandler);
            this.decrementButton.addEventListener(MouseEvent.ROLL_OVER,this.button_rollOverHandler);
            this.decrementButton.addEventListener(MouseEvent.ROLL_OUT,this.button_rollOutHandler);
            this.decrementButton.autoRepeat = true;
         }
         else if(instance == this.incrementButton)
         {
            this.incrementButton.addEventListener(FlexEvent.BUTTON_DOWN,this.button_buttonDownHandler);
            this.incrementButton.addEventListener(MouseEvent.ROLL_OVER,this.button_rollOverHandler);
            this.incrementButton.addEventListener(MouseEvent.ROLL_OUT,this.button_rollOutHandler);
            this.incrementButton.autoRepeat = true;
         }
         else if(instance == track)
         {
            track.addEventListener(MouseEvent.ROLL_OVER,this.track_rollOverHandler);
            track.addEventListener(MouseEvent.ROLL_OUT,this.track_rollOutHandler);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.decrementButton)
         {
            this.decrementButton.removeEventListener(FlexEvent.BUTTON_DOWN,this.button_buttonDownHandler);
            this.decrementButton.removeEventListener(MouseEvent.ROLL_OVER,this.button_rollOverHandler);
            this.decrementButton.removeEventListener(MouseEvent.ROLL_OUT,this.button_rollOutHandler);
         }
         else if(instance == this.incrementButton)
         {
            this.incrementButton.removeEventListener(FlexEvent.BUTTON_DOWN,this.button_buttonDownHandler);
            this.incrementButton.removeEventListener(MouseEvent.ROLL_OVER,this.button_rollOverHandler);
            this.incrementButton.removeEventListener(MouseEvent.ROLL_OUT,this.button_rollOutHandler);
         }
         else if(instance == track)
         {
            track.removeEventListener(MouseEvent.ROLL_OVER,this.track_rollOverHandler);
            track.removeEventListener(MouseEvent.ROLL_OUT,this.track_rollOutHandler);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "autoThumbVisibility")
         {
            invalidateDisplayList();
         }
      }
      
      override protected function system_mouseMoveHandler(event:MouseEvent) : void
      {
         if(!track)
         {
            return;
         }
         var p:Point = track.globalToLocal(new Point(event.stageX,event.stageY));
         var newValue:Number = pointToValue(p.x - this.clickOffset.x,p.y - this.clickOffset.y);
         newValue = nearestValidValue(newValue,snapInterval);
         if(newValue != this.pendingValue)
         {
            dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
            if(getStyle("liveDragging") === true)
            {
               this.setValue(newValue);
               dispatchEvent(new Event(Event.CHANGE));
            }
            else
            {
               this.pendingValue = newValue;
            }
         }
         event.updateAfterEvent();
      }
      
      override protected function system_mouseUpHandler(event:Event) : void
      {
         if(getStyle("liveDragging") === false && value != this.pendingValue)
         {
            this.setValue(this.pendingValue);
            dispatchEvent(new Event(Event.CHANGE));
         }
         super.system_mouseUpHandler(event);
      }
      
      public function changeValueByPage(increase:Boolean = true) : void
      {
         var val:Number = NaN;
         if(increase)
         {
            val = Math.min(value + this.pageSize,maximum);
         }
         else
         {
            val = Math.max(value - this.pageSize,minimum);
         }
         if(Boolean(getStyle("smoothScrolling")))
         {
            this.startAnimation(getStyle("repeatInterval"),val,linearEaser);
         }
         else
         {
            this.setValue(val);
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function viewport_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         switch(event.property)
         {
            case "contentWidth":
               this.viewportContentWidthChangeHandler(event);
               break;
            case "contentHeight":
               this.viewportContentHeightChangeHandler(event);
               break;
            case "horizontalScrollPosition":
               this.viewportHorizontalScrollPositionChangeHandler(event);
               break;
            case "verticalScrollPosition":
               this.viewportVerticalScrollPositionChangeHandler(event);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportResizeHandler(event:ResizeEvent) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportContentWidthChangeHandler(event:PropertyChangeEvent) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportContentHeightChangeHandler(event:PropertyChangeEvent) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportHorizontalScrollPositionChangeHandler(event:PropertyChangeEvent) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewportVerticalScrollPositionChangeHandler(event:PropertyChangeEvent) : void
      {
      }
      
      override protected function thumb_mouseDownHandler(event:MouseEvent) : void
      {
         this.stopAnimation();
         super.thumb_mouseDownHandler(event);
         this.clickOffset = thumb.globalToLocal(new Point(event.stageX,event.stageY));
      }
      
      protected function button_buttonDownHandler(event:Event) : void
      {
         if(!this.isStepping)
         {
            this.stopAnimation();
         }
         var increment:Boolean = event.target == this.incrementButton;
         if(!this.isStepping && (increment && value < maximum || !increment && value > minimum))
         {
            dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
            this.isStepping = true;
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.button_buttonUpHandler,true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.button_buttonUpHandler);
         }
         if(!this.steppingDown && !this.steppingUp)
         {
            changeValueByStep(increment);
            if(Boolean(getStyle("smoothScrolling")) && (increment && this.pendingValue < maximum || !increment && this.pendingValue > minimum))
            {
               this.animateStepping(increment ? maximum : minimum,Math.max(this.pageSize / 10,stepSize));
            }
            return;
         }
      }
      
      protected function button_buttonUpHandler(event:Event) : void
      {
         if(this.steppingDown || this.steppingUp)
         {
            this.stopAnimation();
            dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
            this.steppingUp = this.steppingDown = false;
            this.isStepping = false;
         }
         else if(this.isStepping)
         {
            dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
            this.isStepping = false;
         }
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.button_buttonUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.button_buttonUpHandler);
      }
      
      override protected function track_mouseDownHandler(event:MouseEvent) : void
      {
         var thumbW:Number = NaN;
         var thumbH:Number = NaN;
         var slideDuration:Number = NaN;
         var adjustedValue:Number = NaN;
         if(!enabled)
         {
            return;
         }
         this.stopAnimation();
         this.trackPosition = track.globalToLocal(new Point(event.stageX,event.stageY));
         if(event.shiftKey)
         {
            thumbW = Boolean(thumb) ? Number(thumb.getLayoutBoundsWidth()) : 0;
            thumbH = Boolean(thumb) ? Number(thumb.getLayoutBoundsHeight()) : 0;
            this.trackPosition.x -= thumbW / 2;
            this.trackPosition.y -= thumbH / 2;
         }
         var newScrollValue:Number = pointToValue(this.trackPosition.x,this.trackPosition.y);
         this.trackScrollDown = newScrollValue > this.pendingValue;
         if(event.shiftKey)
         {
            slideDuration = Number(getStyle("slideDuration"));
            adjustedValue = nearestValidValue(newScrollValue,snapInterval);
            if(Boolean(getStyle("smoothScrolling")) && Boolean(slideDuration != 0) && maximum - minimum != 0)
            {
               dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
               this.startAnimation(slideDuration * (Math.abs(value - newScrollValue) / (maximum - minimum)),adjustedValue,deceleratingSineEaser);
               this.animatingOnce = true;
            }
            else
            {
               this.setValue(adjustedValue);
               dispatchEvent(new Event(Event.CHANGE));
            }
            return;
         }
         dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
         this.animatingOnce = false;
         this.changeValueByPage(this.trackScrollDown);
         this.trackScrolling = true;
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.track_mouseMoveHandler,true);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.track_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.track_mouseUpHandler);
         if(!this.trackScrollTimer)
         {
            this.trackScrollTimer = new Timer(getStyle("repeatDelay"),1);
            this.trackScrollTimer.addEventListener(TimerEvent.TIMER,this.trackScrollTimerHandler);
         }
         else
         {
            this.trackScrollTimer.delay = getStyle("repeatDelay");
            this.trackScrollTimer.repeatCount = 1;
         }
         this.trackScrollTimer.start();
      }
      
      protected function animatePaging(newValue:Number, pageSize:Number) : void
      {
         this.animatingOnce = false;
         this.startAnimation(getStyle("repeatInterval") * (Math.abs(newValue - this.pendingValue) / pageSize),newValue,linearEaser);
      }
      
      protected function animateStepping(newValue:Number, stepSize:Number) : void
      {
         var easer:IEaser = null;
         this.steppingDown = newValue > this.pendingValue;
         this.steppingUp = !this.steppingDown;
         var denominator:Number = stepSize != 0 ? stepSize : 1;
         var duration:Number = getStyle("repeatInterval") * (Math.abs(newValue - this.pendingValue) / denominator);
         if(duration > 5000)
         {
            easer = new Linear(500 / duration);
         }
         else
         {
            easer = easyInLinearEaser;
         }
         this.startAnimation(duration,newValue,easer,getStyle("repeatDelay"));
      }
      
      private function animationUpdateHandler(animation:Animation) : void
      {
         this.setValue(animation.currentValue["value"]);
      }
      
      private function animationEndHandler(animation:Animation) : void
      {
         if(this.trackScrolling)
         {
            this.trackScrolling = false;
         }
         if(this.steppingDown || this.steppingUp)
         {
            changeValueByStep(this.steppingDown);
            this.animator.startDelay = 0;
            return;
         }
         this.setValue(nearestValidValue(this.pendingValue,snapInterval));
         dispatchEvent(new Event(Event.CHANGE));
         if(this.animatingOnce)
         {
            dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
            this.animatingOnce = false;
         }
      }
      
      private function stopAnimation() : void
      {
         if(this.animator.isPlaying)
         {
            this.animationEndHandler(this.animator);
         }
         this.animator.stop();
      }
      
      private function trackScrollTimerHandler(event:Event) : void
      {
         var range:Number = NaN;
         var valueDelta:Number = NaN;
         var pages:int = 0;
         var pageToVal:Number = NaN;
         var newScrollValue:Number = pointToValue(this.trackPosition.x,this.trackPosition.y);
         var fixedThumbSize:Boolean = getStyle("fixedThumbSize") !== false;
         if(this.trackScrollDown)
         {
            range = maximum - minimum;
            if(range == 0)
            {
               return;
            }
            if(value + this.pageSize > newScrollValue && (!fixedThumbSize || nearestValidValue(newScrollValue,this.pageSize) != maximum))
            {
               return;
            }
         }
         else if(newScrollValue > value)
         {
            return;
         }
         if(Boolean(getStyle("smoothScrolling")))
         {
            valueDelta = Math.abs(value - newScrollValue);
            if(newScrollValue > value)
            {
               pages = this.pageSize != 0 ? int(valueDelta / this.pageSize) : int(valueDelta);
               if(fixedThumbSize && nearestValidValue(newScrollValue,this.pageSize) == maximum)
               {
                  pageToVal = maximum;
               }
               else
               {
                  pageToVal = value + pages * this.pageSize;
               }
            }
            else
            {
               pages = this.pageSize != 0 ? int(Math.ceil(valueDelta / this.pageSize)) : int(valueDelta);
               pageToVal = Math.max(minimum,value - pages * this.pageSize);
            }
            this.animatePaging(pageToVal,this.pageSize);
            return;
         }
         var oldValue:Number = value;
         this.changeValueByPage(this.trackScrollDown);
         if(Boolean(this.trackScrollTimer) && this.trackScrollTimer.repeatCount == 1)
         {
            this.trackScrollTimer.delay = getStyle("repeatInterval");
            this.trackScrollTimer.repeatCount = 0;
         }
      }
      
      private function track_mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(this.trackScrolling)
         {
            pt = new Point(event.stageX,event.stageY);
            this.trackPosition = track.globalToLocal(pt);
         }
      }
      
      private function track_mouseUpHandler(event:Event) : void
      {
         this.trackScrolling = false;
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.track_mouseMoveHandler,true);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.track_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.track_mouseUpHandler);
         if(Boolean(getStyle("smoothScrolling")))
         {
            if(!this.animatingOnce)
            {
               if(Boolean(this.trackScrollTimer) && this.trackScrollTimer.running)
               {
                  if(this.animator.isPlaying)
                  {
                     this.animatingOnce = true;
                  }
                  else
                  {
                     dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
                  }
               }
               else
               {
                  this.stopAnimation();
                  dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
               }
            }
         }
         else
         {
            dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
         }
         if(Boolean(this.trackScrollTimer))
         {
            this.trackScrollTimer.reset();
         }
      }
      
      private function track_rollOverHandler(event:MouseEvent) : void
      {
         if(this.trackScrolling && Boolean(this.trackScrollTimer))
         {
            this.trackScrollTimer.start();
         }
      }
      
      private function track_rollOutHandler(event:MouseEvent) : void
      {
         if(this.trackScrolling && Boolean(this.trackScrollTimer))
         {
            this.trackScrollTimer.stop();
         }
      }
      
      private function button_rollOverHandler(event:MouseEvent) : void
      {
         if(this.steppingUp || this.steppingDown)
         {
            this.animator.resume();
         }
      }
      
      private function button_rollOutHandler(event:MouseEvent) : void
      {
         if(this.steppingUp || this.steppingDown)
         {
            this.animator.pause();
         }
      }
   }
}

