package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.formatters.NumberFormatter;
   import mx.managers.IFocusManagerComponent;
   import spark.effects.animation.Animation;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.Sine;
   import spark.events.TrackBaseEvent;
   
   [AccessibilityClass(implementation="spark.accessibility.SliderBaseAccImpl")]
   [Exclude(name="textAlign",kind="style")]
   [Exclude(name="fontWeight",kind="style")]
   [Exclude(name="fontSize",kind="style")]
   [Exclude(name="color",kind="style")]
   [Style(name="liveDragging",type="Boolean",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="focusAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   public class SliderBase extends TrackBase implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const MAX_DRAG_RATE:Number = 30;
      
      private static var _skinParts:Object = {
         "dataTip":false,
         "track":false,
         "thumb":false
      };
      
      [SkinPart(required="false",type="mx.core.IDataRenderer")]
      public var dataTip:IFactory;
      
      private var dataFormatter:NumberFormatter;
      
      private var animator:Animation = null;
      
      private var dataTipInitialPosition:Point;
      
      private var dataTipInstance:IDataRenderer;
      
      private var slideToValue:Number;
      
      private var isKeyDown:Boolean = false;
      
      private var clickOffset:Point;
      
      private var mostRecentMousePoint:Point;
      
      private var dragTimer:Timer = null;
      
      private var dragPending:Boolean = false;
      
      private var _dataTipFormatFunction:Function;
      
      [Inspectable(defaultValue="2",minValue="0")]
      public var dataTipPrecision:int = 2;
      
      private var _pendingValue:Number = 0;
      
      public var showDataTip:Boolean = true;
      
      public function SliderBase()
      {
         super();
         maximum = 10;
      }
      
      [Inspectable(category="General",defaultValue="10.0")]
      override public function get maximum() : Number
      {
         return super.maximum;
      }
      
      public function get dataTipFormatFunction() : Function
      {
         return this._dataTipFormatFunction;
      }
      
      public function set dataTipFormatFunction(value:Function) : void
      {
         this._dataTipFormatFunction = value;
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
      
      override protected function initializeAccessibility() : void
      {
         if(SliderBase.createAccessibilityImplementation != null)
         {
            SliderBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == thumb)
         {
            thumb.focusEnabled = false;
         }
         else if(instance == track)
         {
            track.focusEnabled = false;
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         if(Boolean(thumb))
         {
            thumb.drawFocusAnyway = true;
            thumb.drawFocus(isFocused);
         }
         else
         {
            super.drawFocus(isFocused);
         }
      }
      
      override protected function setValue(value:Number) : void
      {
         this._pendingValue = value;
         super.setValue(value);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateErrorSkin() : void
      {
      }
      
      protected function updateDataTip(dataTipInstance:IDataRenderer, initialPosition:Point) : void
      {
      }
      
      private function formatDataTipText(value:Number) : Object
      {
         var formattedValue:Object = null;
         if(this.dataTipFormatFunction != null)
         {
            formattedValue = this.dataTipFormatFunction(value);
         }
         else
         {
            if(this.dataFormatter == null)
            {
               this.dataFormatter = new NumberFormatter();
            }
            this.dataFormatter.precision = this.dataTipPrecision;
            formattedValue = this.dataFormatter.format(value);
         }
         return formattedValue;
      }
      
      private function animationUpdateHandler(animation:Animation) : void
      {
         this.pendingValue = animation.currentValue["value"];
      }
      
      private function animationEndHandler(animation:Animation) : void
      {
         this.setValue(this.slideToValue);
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
      }
      
      private function stopAnimation() : void
      {
         this.animator.stop();
         this.setValue(nearestValidValue(this.pendingValue,snapInterval));
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
      }
      
      override protected function thumb_mouseDownHandler(event:MouseEvent) : void
      {
         var tipAsUIComponent:UIComponent = null;
         if(Boolean(this.animator) && this.animator.isPlaying)
         {
            this.stopAnimation();
         }
         super.thumb_mouseDownHandler(event);
         this.clickOffset = thumb.globalToLocal(new Point(event.stageX,event.stageY));
         if(Boolean(this.dataTip) && Boolean(this.showDataTip) && enabled)
         {
            this.dataTipInstance = IDataRenderer(createDynamicPartInstance("dataTip"));
            this.dataTipInstance.data = this.formatDataTipText(nearestValidValue(this.pendingValue,snapInterval));
            tipAsUIComponent = this.dataTipInstance as UIComponent;
            if(Boolean(tipAsUIComponent))
            {
               tipAsUIComponent.owner = this;
               tipAsUIComponent.isPopUp = true;
            }
            systemManager.toolTipChildren.addChild(DisplayObject(this.dataTipInstance));
            if(Boolean(tipAsUIComponent))
            {
               tipAsUIComponent.validateNow();
               tipAsUIComponent.setActualSize(tipAsUIComponent.getExplicitOrMeasuredWidth(),tipAsUIComponent.getExplicitOrMeasuredHeight());
            }
            this.dataTipInitialPosition = new Point(DisplayObject(this.dataTipInstance).x,DisplayObject(this.dataTipInstance).y);
            this.updateDataTip(this.dataTipInstance,this.dataTipInitialPosition);
         }
      }
      
      private function handleMousePoint(p:Point) : void
      {
         var tipAsUIComponent:UIComponent = null;
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
         if(Boolean(this.dataTipInstance) && this.showDataTip)
         {
            this.dataTipInstance.data = this.formatDataTipText(this.pendingValue);
            tipAsUIComponent = this.dataTipInstance as UIComponent;
            if(Boolean(tipAsUIComponent))
            {
               tipAsUIComponent.validateNow();
               tipAsUIComponent.setActualSize(tipAsUIComponent.getExplicitOrMeasuredWidth(),tipAsUIComponent.getExplicitOrMeasuredHeight());
            }
            this.updateDataTip(this.dataTipInstance,this.dataTipInitialPosition);
         }
      }
      
      override protected function system_mouseMoveHandler(event:MouseEvent) : void
      {
         if(!track)
         {
            return;
         }
         this.mostRecentMousePoint = track.globalToLocal(new Point(event.stageX,event.stageY));
         if(!this.dragTimer)
         {
            this.dragTimer = new Timer(1000 / MAX_DRAG_RATE,0);
            this.dragTimer.addEventListener(TimerEvent.TIMER,this.dragTimerHandler);
         }
         if(!this.dragTimer.running)
         {
            this.handleMousePoint(this.mostRecentMousePoint);
            event.updateAfterEvent();
            this.dragTimer.start();
            this.dragPending = false;
         }
         else
         {
            this.dragPending = true;
         }
      }
      
      private function dragTimerHandler(event:TimerEvent) : void
      {
         if(this.dragPending)
         {
            this.handleMousePoint(this.mostRecentMousePoint);
            event.updateAfterEvent();
            this.dragPending = false;
         }
         else
         {
            this.dragTimer.stop();
         }
      }
      
      override protected function system_mouseUpHandler(event:Event) : void
      {
         if(Boolean(this.dragTimer))
         {
            if(this.dragPending)
            {
               this.handleMousePoint(this.mostRecentMousePoint);
               if(event is MouseEvent)
               {
                  MouseEvent(event).updateAfterEvent();
               }
            }
            this.dragTimer.stop();
            this.dragTimer.removeEventListener(TimerEvent.TIMER,this.dragTimerHandler);
            this.dragTimer = null;
         }
         if(getStyle("liveDragging") === false && value != this.pendingValue)
         {
            this.setValue(this.pendingValue);
            dispatchEvent(new Event(Event.CHANGE));
         }
         if(Boolean(this.dataTipInstance))
         {
            removeDynamicPartInstance("dataTip",this.dataTipInstance);
            systemManager.toolTipChildren.removeChild(DisplayObject(this.dataTipInstance));
            this.dataTipInstance = null;
         }
         super.system_mouseUpHandler(event);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var newValue:Number = NaN;
         super.keyDownHandler(event);
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(Boolean(this.animator) && this.animator.isPlaying)
         {
            this.stopAnimation();
         }
         var prevValue:Number = this.value;
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event,true));
         switch(keyCode)
         {
            case Keyboard.DOWN:
            case Keyboard.LEFT:
               newValue = nearestValidValue(this.pendingValue - stepSize,snapInterval);
               if(prevValue != newValue)
               {
                  if(!this.isKeyDown)
                  {
                     dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
                     this.isKeyDown = true;
                  }
                  this.setValue(newValue);
                  dispatchEvent(new Event(Event.CHANGE));
               }
               event.preventDefault();
               break;
            case Keyboard.UP:
            case Keyboard.RIGHT:
               newValue = nearestValidValue(this.pendingValue + stepSize,snapInterval);
               if(prevValue != newValue)
               {
                  if(!this.isKeyDown)
                  {
                     dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
                     this.isKeyDown = true;
                  }
                  this.setValue(newValue);
                  dispatchEvent(new Event(Event.CHANGE));
               }
               event.preventDefault();
               break;
            case Keyboard.HOME:
               value = minimum;
               if(value != prevValue)
               {
                  dispatchEvent(new Event(Event.CHANGE));
               }
               event.preventDefault();
               break;
            case Keyboard.END:
               value = this.maximum;
               if(value != prevValue)
               {
                  dispatchEvent(new Event(Event.CHANGE));
               }
               event.preventDefault();
         }
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
            case Keyboard.LEFT:
            case Keyboard.UP:
            case Keyboard.RIGHT:
               if(this.isKeyDown)
               {
                  dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
                  this.isKeyDown = false;
               }
               event.preventDefault();
         }
      }
      
      override protected function track_mouseDownHandler(event:MouseEvent) : void
      {
         var slideDuration:Number = NaN;
         var animTarget:AnimationTarget = null;
         if(!enabled)
         {
            return;
         }
         var thumbW:Number = Boolean(thumb) ? Number(thumb.width) : 0;
         var thumbH:Number = Boolean(thumb) ? Number(thumb.height) : 0;
         var offsetX:Number = event.stageX - thumbW / 2;
         var offsetY:Number = event.stageY - thumbH / 2;
         var p:Point = track.globalToLocal(new Point(offsetX,offsetY));
         var newValue:Number = pointToValue(p.x,p.y);
         newValue = nearestValidValue(newValue,snapInterval);
         if(newValue != this.pendingValue)
         {
            slideDuration = Number(getStyle("slideDuration"));
            if(slideDuration != 0)
            {
               if(!this.animator)
               {
                  this.animator = new Animation();
                  animTarget = new AnimationTarget(this.animationUpdateHandler);
                  animTarget.endFunction = this.animationEndHandler;
                  this.animator.animationTarget = animTarget;
                  this.animator.easer = new Sine(0);
               }
               if(this.animator.isPlaying)
               {
                  this.stopAnimation();
               }
               this.slideToValue = newValue;
               this.animator.duration = slideDuration * (Math.abs(this.pendingValue - this.slideToValue) / (this.maximum - minimum));
               this.animator.motionPaths = new <MotionPath>[new SimpleMotionPath("value",this.pendingValue,this.slideToValue)];
               dispatchEvent(new FlexEvent(FlexEvent.CHANGE_START));
               this.animator.play();
            }
            else
            {
               this.setValue(newValue);
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
         event.updateAfterEvent();
      }
   }
}

