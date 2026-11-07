package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.events.SoftKeyboardTrigger;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.core.EventPriority;
   import mx.core.FlexGlobals;
   import mx.core.FlexVersion;
   import mx.effects.IEffect;
   import mx.effects.Parallel;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.PopUpManager;
   import mx.managers.SystemManager;
   import mx.styles.StyleProtoChain;
   import spark.effects.Move;
   import spark.effects.Resize;
   import spark.effects.animation.Animation;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Power;
   import spark.events.PopUpEvent;
   
   [SkinState("closed")]
   [Style(name="softKeyboardEffectDuration",type="Number",format="Time",inherit="no",minValue="0.0")]
   [Event(name="close",type="spark.events.PopUpEvent")]
   [Event(name="open",type="spark.events.PopUpEvent")]
   public class SkinnablePopUpContainer extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var closeEvent:PopUpEvent;
      
      private var addedToPopUpManager:Boolean = false;
      
      private var softKeyboardEffect:IEffect;
      
      private var softKeyboardEffectCachedYPosition:Number;
      
      private var softKeyboardEffectPendingEventType:String = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var softKeyboardEffectPendingEffectDelay:Number = 100;
      
      private var softKeyboardEffectPendingEventTimer:Timer;
      
      private var softKeyboardEffectOrientationChanging:Boolean = false;
      
      private var softKeyboardEffectOrientationHandlerAdded:Boolean = false;
      
      private var softKeyboardStateChangeListenersInstalled:Boolean;
      
      private var resizeListenerInstalled:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      private var _resizeForSoftKeyboard:Boolean = true;
      
      private var _moveForSoftKeyboard:Boolean = true;
      
      private var _softKeyboardEffectExplicitHeightFlag:Boolean = false;
      
      private var _softKeyboardEffectExplicitWidthFlag:Boolean = false;
      
      private var _softKeyboardEffectCachedHeight:Number;
      
      private var _isSoftKeyboardEffectActive:Boolean;
      
      private var _marginTop:Number = 0;
      
      private var _marginBottom:Number = 0;
      
      private var _isMouseDown:Boolean = false;
      
      public function SkinnablePopUpContainer()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setIsOpen(value:Boolean) : void
      {
         this._isOpen = value;
         invalidateSkinState();
      }
      
      public function get resizeForSoftKeyboard() : Boolean
      {
         return this._resizeForSoftKeyboard;
      }
      
      public function set resizeForSoftKeyboard(value:Boolean) : void
      {
         if(this._resizeForSoftKeyboard == value)
         {
            return;
         }
         this._resizeForSoftKeyboard = value;
      }
      
      public function get moveForSoftKeyboard() : Boolean
      {
         return this._moveForSoftKeyboard;
      }
      
      public function set moveForSoftKeyboard(value:Boolean) : void
      {
         if(this._moveForSoftKeyboard == value)
         {
            return;
         }
         this._moveForSoftKeyboard = value;
      }
      
      public function open(owner:DisplayObjectContainer, modal:Boolean = false) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.closeEvent = null;
         this.owner = owner;
         if(!this.addedToPopUpManager)
         {
            this.addedToPopUpManager = true;
            PopUpManager.addPopUp(this,owner,modal);
            this.updatePopUpPosition();
         }
         this._isOpen = true;
         invalidateSkinState();
         if(Boolean(skin))
         {
            skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         else
         {
            this.stateChangeComplete_handler(null);
         }
      }
      
      public function updatePopUpPosition() : void
      {
      }
      
      public function close(commit:Boolean = false, data:* = undefined) : void
      {
         if(!this.isOpen)
         {
            return;
         }
         this.closeEvent = new PopUpEvent(PopUpEvent.CLOSE,false,false,commit,data);
         this._isOpen = false;
         invalidateSkinState();
         if(Boolean(skin))
         {
            skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         else
         {
            this.stateChangeComplete_handler(null);
         }
      }
      
      protected function createSoftKeyboardEffect(yTo:Number, heightTo:Number) : IEffect
      {
         var move:Move = null;
         var resize:Resize = null;
         var parallel:Parallel = null;
         var easer:IEaser = new Power(0,5);
         if(yTo != this.y)
         {
            move = new Move();
            move.target = this;
            move.yTo = yTo;
            move.disableLayout = true;
            move.easer = easer;
         }
         if(heightTo != this.height)
         {
            resize = new Resize();
            resize.target = this;
            resize.heightTo = heightTo;
            resize.disableLayout = true;
            resize.easer = easer;
         }
         if(Boolean(move) && Boolean(resize))
         {
            parallel = new Parallel();
            parallel.addChild(move);
            parallel.addChild(resize);
            return parallel;
         }
         if(Boolean(move) || Boolean(resize))
         {
            return Boolean(move) ? move : resize;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get softKeyboardEffectExplicitHeightFlag() : Boolean
      {
         return this._softKeyboardEffectExplicitHeightFlag;
      }
      
      private function setSoftKeyboardEffectExplicitHeightFlag(value:Boolean) : void
      {
         this._softKeyboardEffectExplicitHeightFlag = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get softKeyboardEffectExplicitWidthFlag() : Boolean
      {
         return this._softKeyboardEffectExplicitWidthFlag;
      }
      
      private function setSoftKeyboardEffectExplicitWidthFlag(value:Boolean) : void
      {
         this._softKeyboardEffectExplicitWidthFlag = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get softKeyboardEffectCachedHeight() : Number
      {
         var heightTo:Number = this._softKeyboardEffectCachedHeight;
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            if(!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
            {
               heightTo = Number(explicitMaxHeight);
            }
            else
            {
               heightTo = Number(measuredHeight);
            }
         }
         return heightTo;
      }
      
      private function setSoftKeyboardEffectCachedHeight(value:Number) : void
      {
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            this._softKeyboardEffectCachedHeight = value;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get isSoftKeyboardEffectActive() : Boolean
      {
         return this._isSoftKeyboardEffectActive;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get softKeyboardEffectMarginTop() : Number
      {
         return this._marginTop;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set softKeyboardEffectMarginTop(value:Number) : void
      {
         this._marginTop = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get softKeyboardEffectMarginBottom() : Number
      {
         return this._marginBottom;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set softKeyboardEffectMarginBottom(value:Number) : void
      {
         this._marginBottom = value;
      }
      
      private function get isMouseDown() : Boolean
      {
         return this._isMouseDown;
      }
      
      private function set isMouseDown(value:Boolean) : void
      {
         this._isMouseDown = value;
         this.playPendingEffect(true);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initProtoChain() : void
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
         {
            super.initProtoChain();
         }
         else
         {
            StyleProtoChain.initProtoChain(this,false);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var state:String = super.getCurrentSkinState();
         if(!this.isOpen)
         {
            return state == "normal" ? "closed" : state;
         }
         return state;
      }
      
      private function startEffect(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.startEffect);
         if(!this.isOpen || !this.softKeyboardEffect)
         {
            return;
         }
         this.softKeyboardEffect.addEventListener(EffectEvent.EFFECT_END,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect.addEventListener(EffectEvent.EFFECT_STOP,this.softKeyboardEffectCleanup);
         if(this.isSoftKeyboardEffectActive)
         {
            this.installSoftKeyboardStateChangeListeners();
         }
         Animation.pulse();
         this.softKeyboardEffect.play();
      }
      
      private function stateChangeComplete_handler(event:Event) : void
      {
         if(Boolean(event))
         {
            event.target.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         var topLevelApp:Application = FlexGlobals.topLevelApplication as Application;
         var softKeyboardEffectEnabled:Boolean = Boolean(topLevelApp) && Application.softKeyboardBehavior == "none";
         var smStage:Stage = systemManager.stage;
         if(this.isOpen)
         {
            dispatchEvent(new PopUpEvent(PopUpEvent.OPEN,false,false));
            if(softKeyboardEffectEnabled)
            {
               if(Boolean(smStage))
               {
                  smStage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stage_softKeyboardActivateHandler,true,EventPriority.DEFAULT,true);
                  smStage.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stage_softKeyboardDeactivateHandler,true,EventPriority.DEFAULT,true);
                  systemManager.addEventListener(Event.RESIZE,this.systemManager_resizeHandler,false,EventPriority.EFFECT);
                  this.updateSoftKeyboardEffect(true);
               }
            }
         }
         else
         {
            dispatchEvent(this.closeEvent);
            this.closeEvent = null;
            if(softKeyboardEffectEnabled && Boolean(smStage))
            {
               smStage.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stage_softKeyboardActivateHandler,true);
               smStage.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stage_softKeyboardDeactivateHandler,true);
               systemManager.removeEventListener(Event.RESIZE,this.systemManager_resizeHandler);
            }
            PopUpManager.removePopUp(this);
            this.addedToPopUpManager = false;
            owner = null;
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function stage_softKeyboardActivateHandler(event:SoftKeyboardEvent = null) : void
      {
         var isFirstActivate:Boolean = false;
         this.softKeyboardEffectPendingEventType = null;
         if(!this.isSoftKeyboardEffectActive && !this.softKeyboardEffect)
         {
            isFirstActivate = true;
         }
         if(isFirstActivate)
         {
            this.updateSoftKeyboardEffect(false);
         }
         else if(this.isMouseDown)
         {
            this.setPendingSoftKeyboardEvent(event);
         }
         else
         {
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function stage_softKeyboardDeactivateHandler(event:SoftKeyboardEvent = null) : void
      {
         if(!this.isSoftKeyboardEffectActive || this.softKeyboardEffectOrientationChanging)
         {
            return;
         }
         this.softKeyboardEffectPendingEventType = null;
         if(event.triggerType == SoftKeyboardTrigger.USER_TRIGGERED)
         {
            this.updateSoftKeyboardEffect(false);
         }
         else
         {
            this.setPendingSoftKeyboardEvent(event);
         }
      }
      
      private function stage_orientationChangingHandler(event:Event) : void
      {
         this.softKeyboardEffectOrientationChanging = true;
      }
      
      private function stage_orientationChangeHandler(event:Event) : void
      {
         this.softKeyboardEffectOrientationChanging = false;
      }
      
      private function mouseHandler(event:MouseEvent) : void
      {
         this.isMouseDown = event.type == MouseEvent.MOUSE_DOWN;
      }
      
      private function systemManager_mouseUpHandler(event:Event) : void
      {
         this.isMouseDown = false;
      }
      
      private function pendingEffectTimer_timerCompleteHandler(event:Event) : void
      {
         this.playPendingEffect(false);
      }
      
      private function playPendingEffect(isMouseEvent:Boolean) : void
      {
         var isActivate:Boolean = false;
         var isTimerRunning:Boolean = Boolean(this.softKeyboardEffectPendingEventTimer) && this.softKeyboardEffectPendingEventTimer.running;
         var mouseDownDuringTimer:Boolean = isTimerRunning && (isMouseEvent && this.isMouseDown);
         if(Boolean(this.softKeyboardEffectPendingEventTimer) && (mouseDownDuringTimer || !isMouseEvent))
         {
            this.softKeyboardEffectPendingEventTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.pendingEffectTimer_timerCompleteHandler);
            this.softKeyboardEffectPendingEventTimer.stop();
            this.softKeyboardEffectPendingEventTimer = null;
            if(mouseDownDuringTimer)
            {
               return;
            }
         }
         var canPlayEffect:Boolean = Boolean(this.softKeyboardEffectPendingEventType) && this.isOpen && (!isMouseEvent || isMouseEvent && !this.isMouseDown);
         if(canPlayEffect)
         {
            isActivate = this.softKeyboardEffectPendingEventType == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE;
            this.updateSoftKeyboardEffect(isActivate);
         }
      }
      
      private function softKeyboardEffectCleanup(event:EffectEvent) : void
      {
         this.softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_END,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_STOP,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect = null;
         if(this.isSoftKeyboardEffectActive)
         {
            this.installActiveResizeListener();
         }
         else
         {
            this.uninstallActiveResizeListener();
            this.uninstallSoftKeyboardStateChangeListeners();
         }
      }
      
      private function resizeHandler(event:Event = null) : void
      {
         this.setSoftKeyboardEffectExplicitWidthFlag(!isNaN(explicitWidth));
         this.setSoftKeyboardEffectExplicitHeightFlag(!isNaN(explicitHeight));
      }
      
      private function systemManager_resizeHandler(event:Event) : void
      {
         if(!this.softKeyboardEffectOrientationChanging)
         {
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function updateSoftKeyboardEffect(snapPosition:Boolean) : void
      {
         var scaleFactor:Number = NaN;
         var popUpY:Number = NaN;
         var popUpHeight:Number = NaN;
         var overlapGlobal:Number = NaN;
         var yToGlobal:Number = NaN;
         var heightToGlobal:Number = NaN;
         if(Boolean(this.softKeyboardEffect) && Boolean(this.softKeyboardEffect.isPlaying))
         {
            this.softKeyboardEffect.stop();
         }
         this.uninstallActiveResizeListener();
         var softKeyboardRect:Rectangle = systemManager.stage.softKeyboardRect;
         var isKeyboardOpen:Boolean = this.isOpen && softKeyboardRect.height > 0;
         if(isNaN(this.softKeyboardEffectCachedYPosition))
         {
            if(!isKeyboardOpen)
            {
               return;
            }
            this.softKeyboardEffectCachedYPosition = this.y;
            this.setSoftKeyboardEffectCachedHeight(this.height);
            this.resizeHandler();
         }
         var sandboxRoot:DisplayObject = systemManager.getSandboxRoot();
         var yToLocal:Number = this.softKeyboardEffectCachedYPosition;
         var heightToLocal:Number = this.softKeyboardEffectCachedHeight;
         if(isKeyboardOpen)
         {
            scaleFactor = 1;
            if(Boolean(systemManager as SystemManager))
            {
               scaleFactor = Number(SystemManager(systemManager).densityScale);
            }
            popUpY = yToLocal * scaleFactor;
            popUpHeight = heightToLocal * scaleFactor;
            overlapGlobal = popUpY + popUpHeight - softKeyboardRect.y;
            yToGlobal = popUpY;
            heightToGlobal = popUpHeight;
            if(overlapGlobal > 0)
            {
               if(this.moveForSoftKeyboard)
               {
                  yToGlobal = Math.max(this.softKeyboardEffectMarginTop * scaleFactor,popUpY - overlapGlobal);
               }
               if(this.resizeForSoftKeyboard)
               {
                  overlapGlobal = yToGlobal + popUpHeight - softKeyboardRect.y;
                  if(overlapGlobal > 0)
                  {
                     heightToGlobal = popUpHeight - overlapGlobal - this.softKeyboardEffectMarginBottom * scaleFactor;
                  }
               }
            }
            if(yToGlobal != popUpY || heightToGlobal != popUpHeight)
            {
               yToLocal = Math.floor(yToGlobal / scaleFactor);
               heightToLocal = Math.floor(heightToGlobal / scaleFactor);
               heightToLocal = Math.max(heightToLocal,getMinBoundsHeight());
            }
         }
         this._isSoftKeyboardEffectActive = isKeyboardOpen;
         var duration:Number = Number(getStyle("softKeyboardEffectDuration"));
         if(!snapPosition && duration > 0)
         {
            this.softKeyboardEffect = this.createSoftKeyboardEffect(yToLocal,heightToLocal);
         }
         if(Boolean(this.softKeyboardEffect))
         {
            this.softKeyboardEffect.duration = duration;
            addEventListener(Event.ENTER_FRAME,this.startEffect);
         }
         else
         {
            this.y = yToLocal;
            if(this.isOpen)
            {
               this.height = heightToLocal;
               validateNow();
               if(this.isSoftKeyboardEffectActive)
               {
                  this.installActiveResizeListener();
                  this.installSoftKeyboardStateChangeListeners();
               }
            }
            else
            {
               this.uninstallSoftKeyboardStateChangeListeners();
               this.softKeyboardEffectResetExplicitSize();
               this.softKeyboardEffectCachedYPosition = NaN;
               this.setSoftKeyboardEffectExplicitWidthFlag(false);
               this.setSoftKeyboardEffectExplicitHeightFlag(false);
               this.setSoftKeyboardEffectCachedHeight(NaN);
            }
         }
      }
      
      private function setPendingSoftKeyboardEvent(event:SoftKeyboardEvent) : void
      {
         this.softKeyboardEffectPendingEventType = event.type;
         if(!this.isMouseDown)
         {
            this.softKeyboardEffectPendingEventTimer = new Timer(this.softKeyboardEffectPendingEffectDelay,1);
            this.softKeyboardEffectPendingEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.pendingEffectTimer_timerCompleteHandler);
            this.softKeyboardEffectPendingEventTimer.start();
         }
      }
      
      private function installSoftKeyboardStateChangeListeners() : void
      {
         var sandboxRoot:DisplayObject = null;
         var smStage:Stage = null;
         if(!this.softKeyboardStateChangeListenersInstalled)
         {
            sandboxRoot = systemManager.getSandboxRoot();
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
            sandboxRoot.addEventListener(MouseEvent.MOUSE_UP,this.mouseHandler,true);
            sandboxRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            this.softKeyboardEffectOrientationChanging = false;
            smStage = systemManager.stage;
            smStage.addEventListener("orientationChanging",this.stage_orientationChangingHandler);
            smStage.addEventListener("orientationChange",this.stage_orientationChangeHandler);
            this.softKeyboardStateChangeListenersInstalled = true;
         }
      }
      
      private function uninstallSoftKeyboardStateChangeListeners() : void
      {
         var sandboxRoot:DisplayObject = null;
         var smStage:Stage = null;
         if(this.softKeyboardStateChangeListenersInstalled)
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
            sandboxRoot = systemManager.getSandboxRoot();
            sandboxRoot.removeEventListener(MouseEvent.MOUSE_UP,this.mouseHandler,true);
            sandboxRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            smStage = systemManager.stage;
            smStage.removeEventListener("orientationChange",this.stage_orientationChangeHandler);
            smStage.removeEventListener("orientationChanging",this.stage_orientationChangeHandler);
            this.softKeyboardStateChangeListenersInstalled = false;
         }
      }
      
      private function installActiveResizeListener() : void
      {
         if(!this.resizeListenerInstalled)
         {
            addEventListener("explicitWidthChanged",this.resizeHandler);
            addEventListener("explicitHeightChanged",this.resizeHandler);
            this.resizeListenerInstalled = true;
         }
      }
      
      private function uninstallActiveResizeListener() : void
      {
         if(this.resizeListenerInstalled)
         {
            removeEventListener("explicitWidthChanged",this.resizeHandler);
            removeEventListener("explicitHeightChanged",this.resizeHandler);
            this.resizeListenerInstalled = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function softKeyboardEffectResetExplicitSize() : void
      {
         var installed:Boolean = this.resizeListenerInstalled;
         if(installed)
         {
            this.uninstallActiveResizeListener();
         }
         if(!this.softKeyboardEffectExplicitWidthFlag)
         {
            explicitWidth = NaN;
         }
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            explicitHeight = NaN;
         }
         if(installed)
         {
            this.installActiveResizeListener();
         }
      }
   }
}

