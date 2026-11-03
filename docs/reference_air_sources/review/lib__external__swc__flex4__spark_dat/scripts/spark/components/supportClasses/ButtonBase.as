package spark.components.supportClasses
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.core.IVisualElement;
   import mx.core.InteractionMode;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.TouchInteractionEvent;
   import mx.managers.IFocusManagerComponent;
   import spark.core.IDisplayText;
   import spark.primitives.BitmapImage;
   
   [DefaultProperty("label")]
   [DefaultTriggerEvent("click")]
   [AccessibilityClass(implementation="spark.accessibility.ButtonBaseAccImpl")]
   [SkinState("disabled")]
   [SkinState("down")]
   [SkinState("over")]
   [SkinState("up")]
   [Event(name="buttonDown",type="mx.events.FlexEvent")]
   [Style(name="touchDelay",type="Number",format="Time",inherit="yes",minValue="0.0")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no",minValueExclusive="0.0")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no",minValue="0.0")]
   [Style(name="iconPlacement",type="String",enumeration="top,bottom,right,left",inherit="no",theme="spark, mobile")]
   [Style(name="icon",type="Object",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="focusAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="spark",minValue="0.0")]
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
   public class ButtonBase extends SkinnableComponent implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      private var _downEventFired:Boolean = false;
      
      private var checkForButtonDownConditions:Boolean = false;
      
      private var autoRepeatTimer:Timer;
      
      private var mouseDownSelectTimer:Timer;
      
      private var mouseUpDeselectTimer:Timer;
      
      private var rollOutWhileFakingDownState:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var disableMinimumDownStateTime:Boolean = false;
      
      [SkinPart(required="false")]
      public var iconDisplay:BitmapImage;
      
      [SkinPart(required="false")]
      public var labelDisplay:IDisplayText;
      
      private var _explicitToolTip:Boolean = false;
      
      private var _autoRepeat:Boolean;
      
      private var _content:*;
      
      private var _hovered:Boolean = false;
      
      private var _keepDown:Boolean = false;
      
      private var _keyboardPressed:Boolean = false;
      
      private var _mouseCaptured:Boolean = false;
      
      private var _stickyHighlighting:Boolean = false;
      
      public function ButtonBase()
      {
         super();
         mouseChildren = false;
         this.addHandlers();
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.labelDisplay as IVisualElement);
      }
      
      [Inspectable(category="General",defaultValue="null")]
      override public function set toolTip(value:String) : void
      {
         super.toolTip = value;
         this._explicitToolTip = value != null;
      }
      
      [Inspectable(defaultValue="false")]
      public function get autoRepeat() : Boolean
      {
         return this._autoRepeat;
      }
      
      public function set autoRepeat(value:Boolean) : void
      {
         if(value == this._autoRepeat)
         {
            return;
         }
         this._autoRepeat = value;
         this.checkAutoRepeatTimerConditions(this.isDown());
      }
      
      [Bindable("contentChange")]
      public function get content() : Object
      {
         return this._content;
      }
      
      public function set content(value:Object) : void
      {
         this._content = value;
         if(Boolean(this.labelDisplay))
         {
            this.labelDisplay.text = this.label;
         }
         dispatchEvent(new Event("contentChange"));
      }
      
      protected function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      protected function set hovered(value:Boolean) : void
      {
         if(value == this._hovered)
         {
            return;
         }
         this._hovered = value;
         this.invalidateButtonState();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function keepDown(down:Boolean, fireEvent:Boolean = true) : void
      {
         if(this._keepDown == down)
         {
            return;
         }
         this._keepDown = down;
         if(!fireEvent)
         {
            this._downEventFired = true;
         }
         if(this._keepDown)
         {
            invalidateSkinState();
         }
         else
         {
            this.invalidateButtonState();
         }
      }
      
      protected function get keyboardPressed() : Boolean
      {
         return this._keyboardPressed;
      }
      
      protected function set keyboardPressed(value:Boolean) : void
      {
         if(value == this._keyboardPressed)
         {
            return;
         }
         this._keyboardPressed = value;
         this.invalidateButtonState();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("contentChange")]
      public function set label(value:String) : void
      {
         this.content = value;
      }
      
      public function get label() : String
      {
         return this.content != null ? this.content.toString() : "";
      }
      
      protected function get mouseCaptured() : Boolean
      {
         return this._mouseCaptured;
      }
      
      protected function set mouseCaptured(value:Boolean) : void
      {
         if(value == this._mouseCaptured)
         {
            return;
         }
         this._mouseCaptured = value;
         this.invalidateButtonState();
         if(!value)
         {
            this.removeSystemMouseHandlers();
         }
      }
      
      public function get stickyHighlighting() : Boolean
      {
         return this._stickyHighlighting;
      }
      
      public function set stickyHighlighting(value:Boolean) : void
      {
         if(value == this._stickyHighlighting)
         {
            return;
         }
         this._stickyHighlighting = value;
         this.invalidateButtonState();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ButtonBase.createAccessibilityImplementation != null)
         {
            ButtonBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.checkForButtonDownConditions)
         {
            this.dispatchButtonEvents();
            this.checkForButtonDownConditions = false;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.labelDisplay)
         {
            this.labelDisplay.addEventListener("isTruncatedChanged",this.labelDisplay_isTruncatedChangedHandler);
            if(this._content !== undefined)
            {
               this.labelDisplay.text = this.label;
            }
         }
         else if(instance == this.iconDisplay)
         {
            this.iconDisplay.source = getStyle("icon");
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.labelDisplay)
         {
            this.labelDisplay.removeEventListener("isTruncatedChanged",this.labelDisplay_isTruncatedChangedHandler);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(!enabled)
         {
            return "disabled";
         }
         if(this.isDown() || this._keepDown)
         {
            return "down";
         }
         if(getStyle("interactionMode") == InteractionMode.MOUSE && (this.hovered || this.mouseCaptured))
         {
            return "over";
         }
         return "up";
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(!styleProp || styleProp == "styleName" || styleProp == "icon")
         {
            if(Boolean(this.iconDisplay))
            {
               this.iconDisplay.source = getStyle("icon");
            }
         }
         super.styleChanged(styleProp);
      }
      
      protected function addHandlers() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.mouseEventHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseEventHandler);
         addEventListener(MouseEvent.CLICK,this.mouseEventHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
      }
      
      private function addSystemMouseHandlers() : void
      {
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
      }
      
      private function removeSystemMouseHandlers() : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
      }
      
      private function isDown() : Boolean
      {
         if(!enabled)
         {
            return false;
         }
         if(this.keyboardPressed)
         {
            return true;
         }
         if(this.mouseCaptured && (this.hovered || this.stickyHighlighting))
         {
            return true;
         }
         return false;
      }
      
      private function invalidateButtonState() : void
      {
         this.checkForButtonDownConditions = true;
         invalidateProperties();
         invalidateSkinState();
      }
      
      private function checkAutoRepeatTimerConditions(buttonDown:Boolean) : void
      {
         var needsTimer:Boolean = this.autoRepeat && buttonDown;
         var hasTimer:Boolean = this.autoRepeatTimer != null;
         if(needsTimer == hasTimer)
         {
            return;
         }
         if(needsTimer)
         {
            this.startAutoRepeatTimer();
         }
         else
         {
            this.stopAutoRepeatTimer();
         }
      }
      
      private function startAutoRepeatTimer() : void
      {
         this.autoRepeatTimer = new Timer(1);
         this.autoRepeatTimer.delay = getStyle("repeatDelay");
         this.autoRepeatTimer.addEventListener(TimerEvent.TIMER,this.autoRepeat_timerDelayHandler);
         this.autoRepeatTimer.start();
      }
      
      private function stopAutoRepeatTimer() : void
      {
         this.autoRepeatTimer.stop();
         this.autoRepeatTimer = null;
      }
      
      private function startSelectButtonAfterDelayTimer() : void
      {
         var touchDelay:Number = Number(getStyle("touchDelay"));
         if(touchDelay > 0)
         {
            this.mouseDownSelectTimer = new Timer(touchDelay,1);
            this.mouseDownSelectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.mouseDownSelectTimer_timerCompleteHandler);
            this.mouseDownSelectTimer.start();
         }
         else
         {
            this.mouseDownSelectTimer_timerCompleteHandler();
         }
      }
      
      private function stopSelectButtonAfterDelayTimer() : void
      {
         if(Boolean(this.mouseDownSelectTimer))
         {
            this.mouseDownSelectTimer.stop();
            this.mouseDownSelectTimer = null;
         }
      }
      
      private function startDeselectButtonAfterDelayTimer() : void
      {
         var minimumDownStateTime:Number = this.disableMinimumDownStateTime ? 0 : Number(getStyle("touchDelay"));
         if(minimumDownStateTime > 0)
         {
            this.mouseUpDeselectTimer = new Timer(minimumDownStateTime,1);
            this.mouseUpDeselectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.mouseUpDeselectTimer_timerCompleteHandler);
            this.mouseUpDeselectTimer.start();
         }
         else
         {
            this.dispatchButtonEvents();
            this.mouseUpDeselectTimer_timerCompleteHandler();
         }
      }
      
      private function stopDeselectButtonAfterDelayTimer() : void
      {
         if(Boolean(this.mouseUpDeselectTimer))
         {
            this.mouseUpDeselectTimer.stop();
            this.mouseUpDeselectTimer = null;
         }
      }
      
      private function dispatchButtonEvents() : void
      {
         var isCurrentlyDown:Boolean = this.isDown();
         if(this._downEventFired != isCurrentlyDown)
         {
            if(isCurrentlyDown && Boolean(hasEventListener(FlexEvent.BUTTON_DOWN)))
            {
               dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
            }
            this._downEventFired = isCurrentlyDown;
            this.checkAutoRepeatTimerConditions(isCurrentlyDown);
         }
      }
      
      protected function buttonReleased() : void
      {
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(!(this.mouseUpDeselectTimer && this.mouseUpDeselectTimer.running))
         {
            this.mouseCaptured = false;
         }
         this.keyboardPressed = false;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode != Keyboard.SPACE && !(getStyle("interactionMode") == InteractionMode.TOUCH && event.keyCode == Keyboard.ENTER))
         {
            return;
         }
         this.keyboardPressed = true;
         event.updateAfterEvent();
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode != Keyboard.SPACE && !(getStyle("interactionMode") == InteractionMode.TOUCH && event.keyCode == Keyboard.ENTER))
         {
            return;
         }
         if(enabled && this.keyboardPressed)
         {
            this.buttonReleased();
            this.keyboardPressed = false;
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         event.updateAfterEvent();
      }
      
      private function touchInteractionStartHandler(event:TouchInteractionEvent) : void
      {
         this.stopSelectButtonAfterDelayTimer();
         this.hovered = false;
         this.mouseCaptured = false;
      }
      
      protected function mouseEventHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = event as MouseEvent;
         switch(event.type)
         {
            case MouseEvent.ROLL_OVER:
               if(mouseEvent.buttonDown && !this.mouseCaptured)
               {
                  return;
               }
               this.hovered = true;
               this.rollOutWhileFakingDownState = false;
               break;
            case MouseEvent.ROLL_OUT:
               if(Boolean(this.mouseUpDeselectTimer) && this.mouseUpDeselectTimer.running)
               {
                  this.rollOutWhileFakingDownState = true;
               }
               else
               {
                  this.hovered = false;
               }
               break;
            case MouseEvent.MOUSE_DOWN:
               if(event.isDefaultPrevented())
               {
                  break;
               }
               this.stopDeselectButtonAfterDelayTimer();
               this.addSystemMouseHandlers();
               if(getStyle("interactionMode") == InteractionMode.TOUCH)
               {
                  this.startSelectButtonAfterDelayTimer();
               }
               else
               {
                  this.mouseCaptured = true;
               }
               break;
            case MouseEvent.MOUSE_UP:
               if(event.target == this)
               {
                  this.hovered = true;
                  if(Boolean(this.mouseDownSelectTimer) && this.mouseDownSelectTimer.running)
                  {
                     this.stopSelectButtonAfterDelayTimer();
                     this.mouseCaptured = true;
                     this.startDeselectButtonAfterDelayTimer();
                  }
                  else if(this.mouseCaptured)
                  {
                     this.buttonReleased();
                     this.mouseCaptured = false;
                  }
               }
               break;
            case MouseEvent.CLICK:
               if(!enabled)
               {
                  event.stopImmediatePropagation();
               }
               else
               {
                  this.clickHandler(MouseEvent(event));
               }
               return;
         }
         if(Boolean(mouseEvent))
         {
            mouseEvent.updateAfterEvent();
         }
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
      }
      
      private function systemManager_mouseUpHandler(event:Event) : void
      {
         if(event.target == this)
         {
            return;
         }
         if(!(this.mouseUpDeselectTimer && this.mouseUpDeselectTimer.running))
         {
            this.mouseCaptured = false;
         }
         if(Boolean(this.mouseDownSelectTimer) && this.mouseDownSelectTimer.running)
         {
            this.stopSelectButtonAfterDelayTimer();
         }
      }
      
      private function autoRepeat_timerDelayHandler(event:TimerEvent) : void
      {
         this.autoRepeatTimer.reset();
         this.autoRepeatTimer.removeEventListener(TimerEvent.TIMER,this.autoRepeat_timerDelayHandler);
         this.autoRepeatTimer.delay = getStyle("repeatInterval");
         this.autoRepeatTimer.addEventListener(TimerEvent.TIMER,this.autoRepeat_timerHandler);
         this.autoRepeatTimer.start();
      }
      
      private function autoRepeat_timerHandler(event:TimerEvent) : void
      {
         dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
      }
      
      private function mouseDownSelectTimer_timerCompleteHandler(event:TimerEvent = null) : void
      {
         this.mouseCaptured = true;
      }
      
      private function mouseUpDeselectTimer_timerCompleteHandler(event:TimerEvent = null) : void
      {
         this.buttonReleased();
         this.mouseCaptured = false;
         if(this.rollOutWhileFakingDownState)
         {
            this.rollOutWhileFakingDownState = false;
            this.hovered = false;
         }
      }
      
      private function labelDisplay_isTruncatedChangedHandler(event:Event) : void
      {
         if(this._explicitToolTip)
         {
            return;
         }
         var isTruncated:Boolean = this.labelDisplay.isTruncated;
         super.toolTip = isTruncated ? this.labelDisplay.text : null;
      }
   }
}

