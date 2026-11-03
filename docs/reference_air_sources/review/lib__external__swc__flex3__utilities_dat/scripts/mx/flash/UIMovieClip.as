package mx.flash
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.ui.Keyboard;
   import mx.automation.IAutomationObject;
   import mx.core.IConstraintClient;
   import mx.core.IDeferredInstantiationUIComponent;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IStateClient;
   import mx.core.IUIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.events.StateChangeEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.IToolTipManagerClient;
   
   [Event(name="toolTipStart",type="mx.events.ToolTipEvent")]
   [Event(name="toolTipShown",type="mx.events.ToolTipEvent")]
   [Event(name="toolTipShow",type="mx.events.ToolTipEvent")]
   [Event(name="toolTipHide",type="mx.events.ToolTipEvent")]
   [Event(name="toolTipEnd",type="mx.events.ToolTipEvent")]
   [Event(name="toolTipCreate",type="mx.events.ToolTipEvent")]
   [Event(name="currentStateChange",type="mx.events.StateChangeEvent")]
   [Event(name="currentStateChanging",type="mx.events.StateChangeEvent")]
   [Event(name="dragComplete",type="mx.events.DragEvent")]
   [Event(name="dragDrop",type="mx.events.DragEvent")]
   [Event(name="dragExit",type="mx.events.DragEvent")]
   [Event(name="dragOver",type="mx.events.DragEvent")]
   [Event(name="dragEnter",type="mx.events.DragEvent")]
   [Event(name="mouseWheelOutside",type="mx.events.FlexMouseEvent")]
   [Event(name="mouseDownOutside",type="mx.events.FlexMouseEvent")]
   [Event(name="show",type="mx.events.FlexEvent")]
   [Event(name="resize",type="mx.events.ResizeEvent")]
   [Event(name="remove",type="mx.events.FlexEvent")]
   [Event(name="preinitialize",type="mx.events.FlexEvent")]
   [Event(name="move",type="mx.events.MoveEvent")]
   [Event(name="initialize",type="mx.events.FlexEvent")]
   [Event(name="hide",type="mx.events.FlexEvent")]
   [Event(name="creationComplete",type="mx.events.FlexEvent")]
   [Event(name="add",type="mx.events.FlexEvent")]
   public dynamic class UIMovieClip extends MovieClip implements IDeferredInstantiationUIComponent, IToolTipManagerClient, IStateClient, IFocusManagerComponent, IConstraintClient, IAutomationObject
   {
      
      private var _explicitWidth:Number;
      
      private var reverseDirectionFocus:Boolean = false;
      
      private var oldHeight:Number;
      
      protected var _height:Number;
      
      private var _automationName:String = null;
      
      private var _automationDelegate:IAutomationObject;
      
      private var _currentState:String;
      
      private var _document:Object;
      
      private var _systemManager:ISystemManager;
      
      private var _isPopUp:Boolean = false;
      
      private var focusableObjects:Array = [];
      
      private var _percentWidth:Number;
      
      private var _top:*;
      
      private var _explicitHeight:Number;
      
      private var explicitSizeChanged:Boolean = false;
      
      private var _measuredWidth:Number;
      
      private var _toolTip:String;
      
      [Inspectable]
      public var boundingBoxName:String = "boundingBox";
      
      protected var _width:Number;
      
      private var _tweeningProperties:Array;
      
      protected var initialized:Boolean = false;
      
      private var _focusPane:Sprite;
      
      private var _left:*;
      
      private var transitionEndState:String;
      
      private var focusListenersAdded:Boolean = false;
      
      private var stateMap:Object;
      
      private var _showInAutomationHierarchy:Boolean = true;
      
      private var _descriptor:UIComponentDescriptor;
      
      private var oldX:Number;
      
      private var oldY:Number;
      
      private var _right:*;
      
      private var validateMeasuredSizeFlag:Boolean = true;
      
      private var _focusEnabled:Boolean = true;
      
      protected var trackSizeChanges:Boolean = true;
      
      private var _includeInLayout:Boolean = true;
      
      private var _explicitMinWidth:Number;
      
      private var _bottom:*;
      
      private var _explicitMaxHeight:Number;
      
      private var explicitTabEnabledChanged:Boolean = false;
      
      private var transitionStartFrame:Number;
      
      private var _explicitMaxWidth:Number;
      
      private var _measuredMinHeight:Number = 0;
      
      private var _verticalCenter:*;
      
      private var _baseline:*;
      
      private var transitionDirection:Number = 0;
      
      private var _measuredHeight:Number;
      
      private var _owner:DisplayObjectContainer;
      
      private var _id:String;
      
      private var transitionEndFrame:Number;
      
      private var _parent:DisplayObjectContainer;
      
      private var _explicitMinHeight:Number;
      
      private var _percentHeight:Number;
      
      private var _measuredMinWidth:Number = 0;
      
      private var oldWidth:Number;
      
      private var _horizontalCenter:*;
      
      public function UIMovieClip()
      {
         super();
         addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,0,true);
         addEventListener(FocusEvent.FOCUS_IN,focusInHandler,false,0,true);
         addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
      }
      
      [Inspectable]
      public function get left() : *
      {
         return _left;
      }
      
      [Bindable(event="propertyChange")]
      public function set left(value:*) : void
      {
         var oldValue:Object = this.left;
         if(oldValue !== value)
         {
            this._3317767left = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"left",oldValue,value));
         }
      }
      
      protected function enterFrameHandler(event:Event) : void
      {
         var currentBounds:Rectangle = null;
         var newFrame:Number = NaN;
         if(explicitSizeChanged)
         {
            explicitSizeChanged = false;
            setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
         }
         if(isNaN(oldX))
         {
            oldX = x;
         }
         if(isNaN(oldY))
         {
            oldY = y;
         }
         if(x != oldX || y != oldY)
         {
            dispatchMoveEvent();
         }
         if(trackSizeChanges)
         {
            currentBounds = bounds;
            currentBounds.width *= scaleX;
            currentBounds.height *= scaleY;
            if(isNaN(oldWidth))
            {
               oldWidth = _width = currentBounds.width;
            }
            if(isNaN(oldHeight))
            {
               oldHeight = _height = currentBounds.height;
            }
            if(sizeChanged(currentBounds.width,oldWidth) || sizeChanged(currentBounds.height,oldHeight))
            {
               _width = currentBounds.width;
               _height = currentBounds.height;
               validateMeasuredSizeFlag = true;
               notifySizeChanged();
               dispatchResizeEvent();
            }
            else if(sizeChanged(width,oldWidth) || sizeChanged(height,oldHeight))
            {
               dispatchResizeEvent();
            }
         }
         if(Boolean(currentLabel) && Boolean(currentLabel.indexOf(":") < 0) && currentLabel != _currentState)
         {
            _currentState = currentLabel;
         }
         if(transitionDirection != 0)
         {
            newFrame = currentFrame + transitionDirection;
            if(transitionDirection > 0 && newFrame >= transitionEndFrame || transitionDirection < 0 && newFrame <= transitionEndFrame)
            {
               gotoAndStop(stateMap[transitionEndState].frame);
               transitionDirection = 0;
            }
            else
            {
               gotoAndStop(newFrame);
            }
         }
      }
      
      public function get minHeight() : Number
      {
         if(!isNaN(explicitMinHeight))
         {
            return explicitMinHeight;
         }
         return measuredMinHeight;
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         var mHeight:Number = NaN;
         if(isNaN(explicitHeight))
         {
            mHeight = measuredHeight;
            if(!isNaN(explicitMinHeight) && mHeight < explicitMinHeight)
            {
               mHeight = explicitMinHeight;
            }
            if(!isNaN(explicitMaxHeight) && mHeight > explicitMaxHeight)
            {
               mHeight = explicitMaxHeight;
            }
            return mHeight;
         }
         return explicitHeight;
      }
      
      [Inspectable]
      public function get right() : *
      {
         return _right;
      }
      
      private function validateMeasuredSize() : void
      {
         if(validateMeasuredSizeFlag)
         {
            validateMeasuredSizeFlag = false;
            _measuredWidth = bounds.width;
            _measuredHeight = bounds.height;
         }
      }
      
      public function get tweeningProperties() : Array
      {
         return _tweeningProperties;
      }
      
      [Inspectable]
      public function get bottom() : *
      {
         return _bottom;
      }
      
      public function set explicitMaxWidth(value:Number) : void
      {
         _explicitMaxWidth = value;
      }
      
      public function set minHeight(value:Number) : void
      {
         explicitMinHeight = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set right(value:*) : void
      {
         var oldValue:Object = this.right;
         if(oldValue !== value)
         {
            this._108511772right = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"right",oldValue,value));
         }
      }
      
      private function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(event.keyCode == Keyboard.TAB)
         {
            if(stage.focus == focusableObjects[event.shiftKey ? 0 : focusableObjects.length - 1])
            {
               removeFocusEventListeners();
            }
            else
            {
               event.stopImmediatePropagation();
            }
         }
      }
      
      public function get automationName() : String
      {
         if(Boolean(_automationName))
         {
            return _automationName;
         }
         if(Boolean(automationDelegate))
         {
            return automationDelegate.automationName;
         }
         return "";
      }
      
      [Inspectable]
      public function get baseline() : *
      {
         return _baseline;
      }
      
      private function set _1383228885bottom(value:*) : void
      {
         if(value != _bottom)
         {
            _bottom = value;
            notifySizeChanged();
         }
      }
      
      public function get explicitMinHeight() : Number
      {
         return _explicitMinHeight;
      }
      
      private function keyFocusChangeCaptureHandler(event:FocusEvent) : void
      {
         reverseDirectionFocus = event.shiftKey;
      }
      
      [Bindable(event="propertyChange")]
      public function set bottom(value:*) : void
      {
         var oldValue:Object = this.bottom;
         if(oldValue !== value)
         {
            this._1383228885bottom = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottom",oldValue,value));
         }
      }
      
      public function set id(value:String) : void
      {
         _id = value;
      }
      
      public function set tweeningProperties(value:Array) : void
      {
         _tweeningProperties = value;
      }
      
      override public function set height(value:Number) : void
      {
         explicitHeight = value;
      }
      
      public function get focusPane() : Sprite
      {
         return _focusPane;
      }
      
      protected function notifySizeChanged() : void
      {
         if(Boolean(parent) && parent is IInvalidating)
         {
            IInvalidating(parent).invalidateSize();
            IInvalidating(parent).invalidateDisplayList();
         }
      }
      
      public function get numAutomationChildren() : int
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.numAutomationChildren;
         }
         return 0;
      }
      
      protected function focusInHandler(event:FocusEvent) : void
      {
         if(!focusListenersAdded)
         {
            addFocusEventListeners();
         }
      }
      
      public function set document(value:Object) : void
      {
         _document = value;
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         var mWidth:Number = NaN;
         if(isNaN(explicitWidth))
         {
            mWidth = measuredWidth;
            if(!isNaN(explicitMinWidth) && mWidth < explicitMinWidth)
            {
               mWidth = explicitMinWidth;
            }
            if(!isNaN(explicitMaxWidth) && mWidth > explicitMaxWidth)
            {
               mWidth = explicitMaxWidth;
            }
            return mWidth;
         }
         return explicitWidth;
      }
      
      private function set _3317767left(value:*) : void
      {
         if(value != _left)
         {
            _left = value;
            notifySizeChanged();
         }
      }
      
      public function get explicitHeight() : Number
      {
         return _explicitHeight;
      }
      
      public function get showInAutomationHierarchy() : Boolean
      {
         return _showInAutomationHierarchy;
      }
      
      public function get systemManager() : ISystemManager
      {
         var r:DisplayObject = null;
         var o:DisplayObjectContainer = null;
         var ui:IUIComponent = null;
         if(!_systemManager)
         {
            r = root;
            if(Boolean(r))
            {
               _systemManager = r as ISystemManager;
            }
            else
            {
               o = parent;
               while(Boolean(o))
               {
                  ui = o as IUIComponent;
                  if(Boolean(ui))
                  {
                     _systemManager = ui.systemManager;
                     break;
                  }
                  o = o.parent;
               }
            }
         }
         return _systemManager;
      }
      
      public function get percentWidth() : Number
      {
         return _percentWidth;
      }
      
      public function set automationName(value:String) : void
      {
         _automationName = value;
      }
      
      public function set explicitMinHeight(value:Number) : void
      {
         _explicitMinHeight = value;
         notifySizeChanged();
      }
      
      public function get baselinePosition() : Number
      {
         return 0;
      }
      
      [Bindable(event="propertyChange")]
      public function set baseline(value:*) : void
      {
         var oldValue:Object = this.baseline;
         if(oldValue !== value)
         {
            this._1720785339baseline = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"baseline",oldValue,value));
         }
      }
      
      public function set focusEnabled(value:Boolean) : void
      {
         _focusEnabled = value;
      }
      
      public function get currentState() : String
      {
         return _currentState;
      }
      
      public function get minWidth() : Number
      {
         if(!isNaN(explicitMinWidth))
         {
            return explicitMinWidth;
         }
         return measuredMinWidth;
      }
      
      public function get measuredWidth() : Number
      {
         validateMeasuredSize();
         return _measuredWidth;
      }
      
      public function get mouseFocusEnabled() : Boolean
      {
         return false;
      }
      
      public function get automationValue() : Array
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.automationValue;
         }
         return [];
      }
      
      private function set _115029top(value:*) : void
      {
         if(value != _top)
         {
            _top = value;
            notifySizeChanged();
         }
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         return Boolean(_parent) ? _parent : super.parent;
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return Boolean(_owner) ? _owner : parent;
      }
      
      protected function get bounds() : Rectangle
      {
         if(Boolean(boundingBoxName && boundingBoxName != "") && Boolean(boundingBoxName in this) && Boolean(this[boundingBoxName]))
         {
            return this[boundingBoxName].getBounds(this);
         }
         return getBounds(this);
      }
      
      public function setActualSize(newWidth:Number, newHeight:Number) : void
      {
         if(sizeChanged(_width,newWidth) || sizeChanged(_height,newHeight))
         {
            dispatchResizeEvent();
         }
         _width = newWidth;
         _height = newHeight;
         super.scaleX = newWidth / measuredWidth;
         super.scaleY = newHeight / measuredHeight;
      }
      
      public function parentChanged(p:DisplayObjectContainer) : void
      {
         if(!p)
         {
            _parent = null;
         }
         else if(p is IUIComponent || p is ISystemManager)
         {
            _parent = p;
         }
         else
         {
            _parent = p.parent;
         }
      }
      
      public function createAutomationIDPart(child:IAutomationObject) : Object
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.createAutomationIDPart(child);
         }
         return null;
      }
      
      public function getAutomationChildAt(index:int) : IAutomationObject
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.getAutomationChildAt(index);
         }
         return null;
      }
      
      private function removeFocusEventListeners() : void
      {
         stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
         stage.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
         focusListenersAdded = false;
      }
      
      public function set focusPane(value:Sprite) : void
      {
         _focusPane = value;
      }
      
      public function get maxWidth() : Number
      {
         return isNaN(explicitMaxWidth) ? 10000 : explicitMaxWidth;
      }
      
      public function setConstraintValue(constraintName:String, value:*) : void
      {
         this[constraintName] = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set verticalCenter(value:*) : void
      {
         var oldValue:Object = this.verticalCenter;
         if(oldValue !== value)
         {
            this._926273685verticalCenter = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalCenter",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set top(value:*) : void
      {
         var oldValue:Object = this.top;
         if(oldValue !== value)
         {
            this._115029top = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"top",oldValue,value));
         }
      }
      
      public function set descriptor(value:UIComponentDescriptor) : void
      {
         _descriptor = value;
      }
      
      override public function set visible(value:Boolean) : void
      {
         setVisible(value);
      }
      
      public function set measuredMinWidth(value:Number) : void
      {
         _measuredMinWidth = value;
      }
      
      public function set includeInLayout(value:Boolean) : void
      {
         _includeInLayout = value;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         _explicitHeight = value;
         explicitSizeChanged = true;
         notifySizeChanged();
      }
      
      public function get explicitMinWidth() : Number
      {
         return _explicitMinWidth;
      }
      
      public function set showInAutomationHierarchy(value:Boolean) : void
      {
         _showInAutomationHierarchy = value;
      }
      
      public function set systemManager(value:ISystemManager) : void
      {
         _systemManager = value;
      }
      
      public function registerEffects(effects:Array) : void
      {
      }
      
      public function set percentWidth(value:Number) : void
      {
         _percentWidth = value;
         notifySizeChanged();
      }
      
      private function creationCompleteHandler(event:Event) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
         if(Boolean(systemManager))
         {
            systemManager.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeCaptureHandler,true,0,true);
         }
         else if(Boolean(parentDocument) && Boolean(parentDocument.systemManager))
         {
            parentDocument.systemManager.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeCaptureHandler,true,0,true);
         }
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      private function set _926273685verticalCenter(value:*) : void
      {
         if(value != _verticalCenter)
         {
            _verticalCenter = value;
            notifySizeChanged();
         }
      }
      
      public function get explicitMaxWidth() : Number
      {
         return _explicitMaxWidth;
      }
      
      public function executeBindings(recurse:Boolean = false) : void
      {
         var bindingsHost:Object = Boolean(descriptor) && Boolean(descriptor.document) ? descriptor.document : parentDocument;
         var mgr:* = ApplicationDomain.currentDomain.getDefinition("mx.binding.BindingManager");
         if(mgr != null)
         {
            mgr.executeBindings(bindingsHost,id,this);
         }
      }
      
      public function set minWidth(value:Number) : void
      {
         explicitMinWidth = value;
      }
      
      [PercentProxy("percentHeight")]
      override public function get height() : Number
      {
         if(!isNaN(_height))
         {
            return _height;
         }
         return super.height;
      }
      
      public function set currentState(value:String) : void
      {
         var frameName:String = null;
         var startFrame:Number = NaN;
         var endFrame:Number = NaN;
         var event:StateChangeEvent = null;
         if(value == _currentState)
         {
            return;
         }
         if(!stateMap)
         {
            buildStateMap();
         }
         if(Boolean(stateMap[value]))
         {
            frameName = _currentState + "-" + value + ":start";
            if(Boolean(stateMap[frameName]))
            {
               startFrame = Number(stateMap[frameName].frame);
               endFrame = Number(stateMap[_currentState + "-" + value + ":end"].frame);
            }
            if(isNaN(startFrame))
            {
               frameName = value + "-" + _currentState + ":end";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap[value + "-" + _currentState + ":start"].frame);
               }
            }
            if(isNaN(startFrame))
            {
               frameName = "*-" + value + ":start";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap["*-" + value + ":end"].frame);
               }
            }
            if(isNaN(startFrame))
            {
               frameName = value + "-*:end";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap[value + "-*:start"].frame);
               }
            }
            if(isNaN(startFrame))
            {
               frameName = _currentState + "-*:start";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap[_currentState + "-*:end"].frame);
               }
            }
            if(isNaN(startFrame))
            {
               frameName = "*-" + _currentState + ":end";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap["*-" + _currentState + ":start"].frame);
               }
            }
            if(isNaN(startFrame))
            {
               frameName = "*-*:start";
               if(Boolean(stateMap[frameName]))
               {
                  startFrame = Number(stateMap[frameName].frame);
                  endFrame = Number(stateMap["*-*:end"].frame);
               }
            }
            if(isNaN(startFrame) && value in stateMap)
            {
               startFrame = Number(stateMap[value].frame);
            }
            if(isNaN(startFrame))
            {
               return;
            }
            event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
            event.oldState = _currentState;
            event.newState = value;
            dispatchEvent(event);
            if(isNaN(endFrame))
            {
               gotoAndStop(startFrame);
               transitionDirection = 0;
            }
            else
            {
               if(currentFrame < Math.min(startFrame,endFrame) || currentFrame > Math.max(startFrame,endFrame))
               {
                  gotoAndStop(startFrame);
               }
               else
               {
                  startFrame = currentFrame;
               }
               transitionStartFrame = startFrame;
               transitionEndFrame = endFrame;
               transitionDirection = endFrame > startFrame ? 1 : -1;
               transitionEndState = value;
            }
            event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
            event.oldState = _currentState;
            event.newState = value;
            dispatchEvent(event);
            _currentState = value;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set horizontalCenter(value:*) : void
      {
         var oldValue:Object = this.horizontalCenter;
         if(oldValue !== value)
         {
            this._2016110183horizontalCenter = value;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalCenter",oldValue,value));
         }
      }
      
      public function get document() : Object
      {
         return _document;
      }
      
      private function focusOutHandler(event:FocusEvent) : void
      {
         if(focusableObjects.indexOf(event.relatedObject) == -1)
         {
            removeFocusEventListeners();
         }
      }
      
      public function replayAutomatableEvent(event:Event) : Boolean
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.replayAutomatableEvent(event);
         }
         return false;
      }
      
      public function get focusEnabled() : Boolean
      {
         return _focusEnabled && focusableObjects.length > 0;
      }
      
      private function set _108511772right(value:*) : void
      {
         if(value != _right)
         {
            _right = value;
            notifySizeChanged();
         }
      }
      
      [Inspectable]
      public function get top() : *
      {
         return _top;
      }
      
      public function set maxHeight(value:Number) : void
      {
         explicitMaxHeight = value;
      }
      
      public function set cacheHeuristic(value:Boolean) : void
      {
      }
      
      private function set _1720785339baseline(value:*) : void
      {
         if(value != _baseline)
         {
            _baseline = value;
            notifySizeChanged();
         }
      }
      
      private function addFocusEventListeners() : void
      {
         stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler,false,1,true);
         stage.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler,false,0,true);
         focusListenersAdded = true;
      }
      
      public function getConstraintValue(constraintName:String) : *
      {
         return this[constraintName];
      }
      
      public function set owner(value:DisplayObjectContainer) : void
      {
         _owner = value;
      }
      
      protected function findFocusCandidates(obj:DisplayObjectContainer) : void
      {
         var child:InteractiveObject = null;
         for(var i:int = 0; i < obj.numChildren; i++)
         {
            child = obj.getChildAt(i) as InteractiveObject;
            if(Boolean(child) && child.tabEnabled)
            {
               focusableObjects.push(child);
               if(!explicitTabEnabledChanged)
               {
                  tabEnabled = true;
               }
            }
            if(child is DisplayObjectContainer)
            {
               findFocusCandidates(DisplayObjectContainer(child));
            }
         }
      }
      
      [Inspectable]
      public function get verticalCenter() : *
      {
         return _verticalCenter;
      }
      
      public function get cachePolicy() : String
      {
         return "";
      }
      
      private function set _2016110183horizontalCenter(value:*) : void
      {
         if(value != _horizontalCenter)
         {
            _horizontalCenter = value;
            notifySizeChanged();
         }
      }
      
      public function get descriptor() : UIComponentDescriptor
      {
         return _descriptor;
      }
      
      public function createReferenceOnParentDocument(parentDocument:IFlexDisplayObject) : void
      {
         if(Boolean(id) && id != "")
         {
            parentDocument[id] = this;
         }
      }
      
      public function get includeInLayout() : Boolean
      {
         return _includeInLayout;
      }
      
      public function set automationDelegate(value:Object) : void
      {
         _automationDelegate = value as IAutomationObject;
      }
      
      public function get measuredMinWidth() : Number
      {
         return _measuredMinWidth;
      }
      
      protected function sizeChanged(oldValue:Number, newValue:Number) : Boolean
      {
         return Math.abs(oldValue - newValue) > 1;
      }
      
      public function set isPopUp(value:Boolean) : void
      {
         _isPopUp = value;
      }
      
      public function get measuredHeight() : Number
      {
         validateMeasuredSize();
         return _measuredHeight;
      }
      
      public function initialize() : void
      {
         var child:IUIComponent = null;
         initialized = true;
         dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
         if(Boolean(boundingBoxName && boundingBoxName != "") && Boolean(boundingBoxName in this) && Boolean(this[boundingBoxName]))
         {
            this[boundingBoxName].visible = false;
         }
         if(explicitSizeChanged)
         {
            explicitSizeChanged = false;
            setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
         }
         findFocusCandidates(this);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as IUIComponent;
            if(Boolean(child))
            {
               child.initialize();
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
         dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
      }
      
      public function resolveAutomationIDPart(criteria:Object) : Array
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.resolveAutomationIDPart(criteria);
         }
         return [];
      }
      
      public function setFocus() : void
      {
         stage.focus = focusableObjects[reverseDirectionFocus ? focusableObjects.length - 1 : 0];
         addFocusEventListeners();
      }
      
      public function set percentHeight(value:Number) : void
      {
         _percentHeight = value;
         notifySizeChanged();
      }
      
      [Inspectable]
      public function get horizontalCenter() : *
      {
         return _horizontalCenter;
      }
      
      override public function set width(value:Number) : void
      {
         explicitWidth = value;
      }
      
      public function set maxWidth(value:Number) : void
      {
         explicitMaxWidth = value;
      }
      
      private function buildStateMap() : void
      {
         var labels:Array = currentLabels;
         stateMap = {};
         for(var i:int = 0; i < labels.length; i++)
         {
            stateMap[labels[i].name] = labels[i];
         }
      }
      
      protected function dispatchResizeEvent() : void
      {
         var resizeEvent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
         resizeEvent.oldWidth = oldWidth;
         resizeEvent.oldHeight = oldHeight;
         dispatchEvent(resizeEvent);
         oldWidth = width;
         oldHeight = height;
      }
      
      public function deleteReferenceOnParentDocument(parentDocument:IFlexDisplayObject) : void
      {
         if(Boolean(id) && id != "")
         {
            parentDocument[id] = null;
         }
      }
      
      public function owns(displayObject:DisplayObject) : Boolean
      {
         while(Boolean(displayObject) && displayObject != this)
         {
            if(displayObject is IUIComponent)
            {
               displayObject = IUIComponent(displayObject).owner;
            }
            else
            {
               displayObject = displayObject.parent;
            }
         }
         return displayObject == this;
      }
      
      public function set explicitMaxHeight(value:Number) : void
      {
         _explicitMaxHeight = value;
         notifySizeChanged();
      }
      
      public function setVisible(value:Boolean, noEvent:Boolean = false) : void
      {
         super.visible = value;
         if(!noEvent)
         {
            dispatchEvent(new FlexEvent(value ? FlexEvent.SHOW : FlexEvent.HIDE));
         }
      }
      
      public function get maxHeight() : Number
      {
         return isNaN(explicitMaxHeight) ? 10000 : explicitMaxHeight;
      }
      
      public function get automationDelegate() : Object
      {
         return _automationDelegate;
      }
      
      public function set explicitMinWidth(value:Number) : void
      {
         _explicitMinWidth = value;
         notifySizeChanged();
      }
      
      public function get isPopUp() : Boolean
      {
         return _isPopUp;
      }
      
      public function get percentHeight() : Number
      {
         return _percentHeight;
      }
      
      [PercentProxy("percentWidth")]
      override public function get width() : Number
      {
         if(!isNaN(_width))
         {
            return _width;
         }
         return super.width;
      }
      
      public function get explicitMaxHeight() : Number
      {
         return _explicitMaxHeight;
      }
      
      public function move(x:Number, y:Number) : void
      {
         this.x = x;
         this.y = y;
         if(x != oldX || y != oldY)
         {
            dispatchMoveEvent();
         }
      }
      
      public function get toolTip() : String
      {
         return _toolTip;
      }
      
      public function get parentDocument() : Object
      {
         var p:IUIComponent = null;
         var sm:ISystemManager = null;
         if(document == this)
         {
            p = parent as IUIComponent;
            if(Boolean(p))
            {
               return p.document;
            }
            sm = parent as ISystemManager;
            if(Boolean(sm))
            {
               return sm.document;
            }
            return null;
         }
         return document;
      }
      
      override public function set tabEnabled(value:Boolean) : void
      {
         super.tabEnabled = value;
         explicitTabEnabledChanged = true;
      }
      
      public function set toolTip(value:String) : void
      {
         var toolTipManager:* = ApplicationDomain.currentDomain.getDefinition("mx.managers.ToolTipManager");
         var oldValue:String = _toolTip;
         _toolTip = value;
         if(Boolean(toolTipManager))
         {
            toolTipManager.mx_internal::registerToolTip(this,oldValue,value);
         }
      }
      
      public function set explicitWidth(value:Number) : void
      {
         _explicitWidth = value;
         explicitSizeChanged = true;
         notifySizeChanged();
      }
      
      private function dispatchMoveEvent() : void
      {
         var moveEvent:MoveEvent = new MoveEvent(MoveEvent.MOVE);
         moveEvent.oldX = oldX;
         moveEvent.oldY = oldY;
         dispatchEvent(moveEvent);
         oldX = x;
         oldY = y;
      }
      
      public function get explicitWidth() : Number
      {
         return _explicitWidth;
      }
      
      public function get measuredMinHeight() : Number
      {
         return _measuredMinHeight;
      }
      
      public function drawFocus(isFocused:Boolean) : void
      {
      }
      
      public function set measuredMinHeight(value:Number) : void
      {
         _measuredMinHeight = value;
      }
      
      override public function get tabEnabled() : Boolean
      {
         return super.tabEnabled;
      }
      
      public function get automationTabularData() : Object
      {
         if(Boolean(automationDelegate))
         {
            return automationDelegate.automationTabularData;
         }
         return null;
      }
   }
}

