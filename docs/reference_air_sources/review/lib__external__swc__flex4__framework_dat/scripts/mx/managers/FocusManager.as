package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.core.FlexSprite;
   import mx.core.IButton;
   import mx.core.IChildList;
   import mx.core.IIMESupport;
   import mx.core.IRawChildrenContainer;
   import mx.core.ISWFLoader;
   import mx.core.IToggleButton;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   public class FocusManager extends EventDispatcher implements IFocusManager
   {
      
      public static var mixins:Array;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const FROM_INDEX_UNSPECIFIED:int = -2;
      
      private var LARGE_TAB_INDEX:int = 99999;
      
      mx_internal var calculateCandidates:Boolean = true;
      
      mx_internal var popup:Boolean;
      
      mx_internal var IMEEnabled:Boolean;
      
      mx_internal var lastAction:String;
      
      public var browserMode:Boolean;
      
      public var desktopMode:Boolean;
      
      private var browserFocusComponent:InteractiveObject;
      
      mx_internal var focusableObjects:Array;
      
      private var focusableCandidates:Array;
      
      private var activated:Boolean;
      
      private var windowActivated:Boolean;
      
      mx_internal var focusChanged:Boolean;
      
      mx_internal var fauxFocus:DisplayObject;
      
      mx_internal var _showFocusIndicator:Boolean = false;
      
      private var defButton:IButton;
      
      private var _defaultButton:IButton;
      
      private var _defaultButtonEnabled:Boolean = true;
      
      private var _focusPane:Sprite;
      
      private var _form:IFocusManagerContainer;
      
      private var _lastFocus:IFocusManagerComponent;
      
      public function FocusManager(container:IFocusManagerContainer, popup:Boolean = false)
      {
         var n:int = 0;
         var i:int = 0;
         var awm:IActiveWindowManager = null;
         super();
         this.popup = popup;
         this.IMEEnabled = true;
         this.browserMode = Capabilities.playerType == "ActiveX" && !popup;
         this.desktopMode = Capabilities.playerType == "Desktop" && !popup;
         this.windowActivated = !this.desktopMode;
         container.focusManager = this;
         this._form = container;
         this.focusableObjects = [];
         this.focusPane = new FlexSprite();
         this.focusPane.name = "focusPane";
         this.addFocusables(DisplayObject(container));
         container.addEventListener(Event.ADDED,this.addedHandler);
         container.addEventListener(Event.REMOVED,this.removedHandler);
         container.addEventListener(FlexEvent.SHOW,this.showHandler);
         container.addEventListener(FlexEvent.HIDE,this.hideHandler);
         container.addEventListener(FlexEvent.HIDE,this.childHideHandler,true);
         container.addEventListener("_navigationChange_",this.viewHideHandler,true);
         if(container.systemManager is SystemManager)
         {
            if(container != SystemManager(container.systemManager).application)
            {
               container.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
            }
         }
         if(Boolean(mixins))
         {
            n = int(mixins.length);
            for(i = 0; i < n; i++)
            {
               new mixins[i](this);
            }
         }
         try
         {
            awm = IActiveWindowManager(container.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
            if(Boolean(awm))
            {
               awm.addFocusManager(container);
            }
            if(hasEventListener("initialize"))
            {
               dispatchEvent(new Event("initialize"));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function get showFocusIndicator() : Boolean
      {
         return this._showFocusIndicator;
      }
      
      public function set showFocusIndicator(value:Boolean) : void
      {
         var changed:Boolean = this._showFocusIndicator != value;
         this._showFocusIndicator = value;
         if(hasEventListener("showFocusIndicator"))
         {
            dispatchEvent(new Event("showFocusIndicator"));
         }
      }
      
      public function get defaultButton() : IButton
      {
         return this._defaultButton;
      }
      
      public function set defaultButton(value:IButton) : void
      {
         var button:IButton = Boolean(value) ? IButton(value) : null;
         if(button != this._defaultButton)
         {
            if(Boolean(this._defaultButton))
            {
               this._defaultButton.emphasized = false;
            }
            if(Boolean(this.defButton))
            {
               this.defButton.emphasized = false;
            }
            this._defaultButton = button;
            if(this.defButton != this._lastFocus || this._lastFocus == this._defaultButton)
            {
               this.defButton = button;
               if(Boolean(button))
               {
                  button.emphasized = true;
               }
            }
         }
      }
      
      public function get defaultButtonEnabled() : Boolean
      {
         return this._defaultButtonEnabled;
      }
      
      public function set defaultButtonEnabled(value:Boolean) : void
      {
         this._defaultButtonEnabled = value;
         if(Boolean(this.defButton))
         {
            this.defButton.emphasized = value;
         }
      }
      
      public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      public function set focusPane(value:Sprite) : void
      {
         this._focusPane = value;
      }
      
      mx_internal function get form() : IFocusManagerContainer
      {
         return this._form;
      }
      
      mx_internal function set form(value:IFocusManagerContainer) : void
      {
         this._form = value;
      }
      
      mx_internal function get lastFocus() : IFocusManagerComponent
      {
         return this._lastFocus;
      }
      
      mx_internal function set lastFocus(value:IFocusManagerComponent) : void
      {
         this._lastFocus = value;
      }
      
      public function get nextTabIndex() : int
      {
         return this.getMaxTabIndex() + 1;
      }
      
      private function getMaxTabIndex() : int
      {
         var t:Number = NaN;
         var z:Number = 0;
         var n:int = int(this.focusableObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            t = Number(this.focusableObjects[i].tabIndex);
            if(!isNaN(t))
            {
               z = Math.max(z,t);
            }
         }
         return z;
      }
      
      public function getFocus() : IFocusManagerComponent
      {
         var stage:Stage = this.form.systemManager.stage;
         if(!stage)
         {
            return null;
         }
         var o:InteractiveObject = stage.focus;
         if(Boolean(!o) && Boolean(this._lastFocus) || o is TextField && o.parent == stage)
         {
            return this._lastFocus;
         }
         return this.findFocusManagerComponent(o);
      }
      
      public function setFocus(o:IFocusManagerComponent) : void
      {
         o.setFocus();
         if(hasEventListener("setFocus"))
         {
            dispatchEvent(new Event("setFocus"));
         }
      }
      
      private function focusInHandler(event:FocusEvent) : void
      {
         var usesIME:Boolean = false;
         var imeFocus:IIMESupport = null;
         var target:InteractiveObject = InteractiveObject(event.target);
         if(hasEventListener(FocusEvent.FOCUS_IN))
         {
            if(!dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN,false,true,target)))
            {
               return;
            }
         }
         if(this.isParent(DisplayObjectContainer(this.form),target))
         {
            if(Boolean(this._defaultButton))
            {
               if(target is IButton && target != this._defaultButton && !(target is IToggleButton))
               {
                  this._defaultButton.emphasized = false;
               }
               else if(this._defaultButtonEnabled)
               {
                  this._defaultButton.emphasized = true;
               }
            }
            this._lastFocus = this.findFocusManagerComponent(InteractiveObject(target));
            if(Capabilities.hasIME)
            {
               if(this._lastFocus is IIMESupport)
               {
                  imeFocus = IIMESupport(this._lastFocus);
                  if(imeFocus.enableIME)
                  {
                     usesIME = true;
                  }
               }
               if(this.IMEEnabled)
               {
                  IME.enabled = usesIME;
               }
            }
            if(this._lastFocus is IButton && !(this._lastFocus is IToggleButton))
            {
               this.defButton = this._lastFocus as IButton;
            }
            else if(Boolean(this.defButton) && this.defButton != this._defaultButton)
            {
               this.defButton = this._defaultButton;
            }
         }
      }
      
      private function focusOutHandler(event:FocusEvent) : void
      {
         var target:InteractiveObject = InteractiveObject(event.target);
      }
      
      private function activateHandler(event:Event) : void
      {
         if(this.activated && !this.desktopMode)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
            if(Boolean(this._lastFocus) && !this.browserMode)
            {
               this._lastFocus.setFocus();
            }
            this.lastAction = "ACTIVATE";
         }
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(this.activated && !this.desktopMode)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
         }
      }
      
      private function activateWindowHandler(event:Event) : void
      {
         this.windowActivated = true;
         if(this.activated)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
            if(Boolean(this._lastFocus) && !this.browserMode)
            {
               this._lastFocus.setFocus();
            }
            this.lastAction = "ACTIVATE";
         }
      }
      
      private function deactivateWindowHandler(event:Event) : void
      {
         this.windowActivated = false;
         if(this.activated)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
            if(Boolean(this.form.systemManager.stage))
            {
               this.form.systemManager.stage.focus = null;
            }
         }
      }
      
      public function showFocus() : void
      {
         if(!this.showFocusIndicator)
         {
            this.showFocusIndicator = true;
            if(Boolean(this._lastFocus))
            {
               this._lastFocus.drawFocus(true);
            }
         }
      }
      
      public function hideFocus() : void
      {
         if(this.showFocusIndicator)
         {
            this.showFocusIndicator = false;
            if(Boolean(this._lastFocus))
            {
               this._lastFocus.drawFocus(false);
            }
         }
      }
      
      public function activate() : void
      {
         if(this.activated)
         {
            return;
         }
         var sm:ISystemManager = this.form.systemManager;
         if(Boolean(sm))
         {
            if(sm.isTopLevelRoot())
            {
               sm.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
               sm.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
               sm.stage.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
               sm.stage.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
            }
            else
            {
               sm.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
               sm.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
               sm.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
               sm.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
            }
         }
         this.form.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownCaptureHandler,true);
         this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.defaultButtonKeyHandler);
         this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         if(Boolean(sm))
         {
            sm.addEventListener("windowActivate",this.activateWindowHandler,true,0,true);
            sm.addEventListener("windowDeactivate",this.deactivateWindowHandler,true,0,true);
         }
         this.activated = true;
         dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
         if(Boolean(this._lastFocus))
         {
            this.setFocus(this._lastFocus);
         }
         if(hasEventListener("activateFM"))
         {
            dispatchEvent(new Event("activateFM"));
         }
      }
      
      public function deactivate() : void
      {
         var sm:ISystemManager = this.form.systemManager;
         if(Boolean(sm))
         {
            if(sm.isTopLevelRoot())
            {
               sm.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
               sm.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
               sm.stage.removeEventListener(Event.ACTIVATE,this.activateHandler);
               sm.stage.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
            }
            else
            {
               sm.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
               sm.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
               sm.removeEventListener(Event.ACTIVATE,this.activateHandler);
               sm.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
            }
         }
         this.form.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownCaptureHandler,true);
         this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.defaultButtonKeyHandler);
         this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         this.activated = false;
         dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
         if(hasEventListener("deactivateFM"))
         {
            dispatchEvent(new Event("deactivateFM"));
         }
      }
      
      public function findFocusManagerComponent(o:InteractiveObject) : IFocusManagerComponent
      {
         return this.findFocusManagerComponent2(o) as IFocusManagerComponent;
      }
      
      private function findFocusManagerComponent2(o:InteractiveObject) : DisplayObject
      {
         try
         {
            while(Boolean(o))
            {
               if(o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled || o is ISWFLoader)
               {
                  return o;
               }
               o = o.parent;
            }
         }
         catch(error:SecurityError)
         {
         }
         return null;
      }
      
      private function isParent(p:DisplayObjectContainer, o:DisplayObject) : Boolean
      {
         if(p == o)
         {
            return false;
         }
         if(p is IRawChildrenContainer)
         {
            return IRawChildrenContainer(p).rawChildren.contains(o);
         }
         return p.contains(o);
      }
      
      private function isEnabledAndVisible(o:DisplayObject) : Boolean
      {
         var formParent:DisplayObjectContainer = DisplayObjectContainer(this.form);
         while(o != formParent)
         {
            if(o is IUIComponent)
            {
               if(!IUIComponent(o).enabled)
               {
                  return false;
               }
            }
            if(o is IVisualElement)
            {
               if(Boolean(IVisualElement(o).designLayer) && !IVisualElement(o).designLayer.effectiveVisibility)
               {
                  return false;
               }
            }
            if(!o.visible)
            {
               return false;
            }
            o = o.parent;
            if(!o)
            {
               return false;
            }
         }
         return true;
      }
      
      private function sortByTabIndex(a:InteractiveObject, b:InteractiveObject) : int
      {
         var aa:int = a.tabIndex;
         var bb:int = b.tabIndex;
         if(aa == -1)
         {
            aa = int.MAX_VALUE;
         }
         if(bb == -1)
         {
            bb = int.MAX_VALUE;
         }
         return aa > bb ? 1 : (aa < bb ? -1 : int(this.sortByDepth(DisplayObject(a),DisplayObject(b))));
      }
      
      private function sortFocusableObjectsTabIndex() : void
      {
         var c:IFocusManagerComponent = null;
         this.focusableCandidates = [];
         var n:int = int(this.focusableObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            c = this.focusableObjects[i] as IFocusManagerComponent;
            if(Boolean(c && c.tabIndex) && Boolean(!isNaN(Number(c.tabIndex))) || this.focusableObjects[i] is ISWFLoader)
            {
               this.focusableCandidates.push(this.focusableObjects[i]);
            }
         }
         this.focusableCandidates.sort(this.sortByTabIndex);
      }
      
      private function sortByDepth(aa:DisplayObject, bb:DisplayObject) : Number
      {
         var index:int = 0;
         var tmp:String = null;
         var tmp2:String = null;
         var val1:String = "";
         var val2:String = "";
         var zeros:String = "0000";
         var a:DisplayObject = DisplayObject(aa);
         var b:DisplayObject = DisplayObject(bb);
         while(a != DisplayObject(this.form) && Boolean(a.parent))
         {
            index = this.getChildIndex(a.parent,a);
            tmp = index.toString(16);
            if(tmp.length < 4)
            {
               tmp2 = zeros.substring(0,4 - tmp.length) + tmp;
            }
            val1 = tmp2 + val1;
            a = a.parent;
         }
         while(b != DisplayObject(this.form) && Boolean(b.parent))
         {
            index = this.getChildIndex(b.parent,b);
            tmp = index.toString(16);
            if(tmp.length < 4)
            {
               tmp2 = zeros.substring(0,4 - tmp.length) + tmp;
            }
            val2 = tmp2 + val2;
            b = b.parent;
         }
         return val1 > val2 ? 1 : (val1 < val2 ? -1 : 0);
      }
      
      private function getChildIndex(parent:DisplayObjectContainer, child:DisplayObject) : int
      {
         try
         {
            return parent.getChildIndex(child);
         }
         catch(e:Error)
         {
            if(parent is IRawChildrenContainer)
            {
               return IRawChildrenContainer(parent).rawChildren.getChildIndex(child);
            }
            throw e;
         }
      }
      
      private function sortFocusableObjects() : void
      {
         var c:InteractiveObject = null;
         this.focusableCandidates = [];
         var n:int = int(this.focusableObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            c = this.focusableObjects[i];
            if(Boolean(c.tabIndex) && Boolean(!isNaN(Number(c.tabIndex))) && c.tabIndex > 0)
            {
               this.sortFocusableObjectsTabIndex();
               return;
            }
            this.focusableCandidates.push(c);
         }
         this.focusableCandidates.sort(this.sortByDepth);
      }
      
      mx_internal function sendDefaultButtonEvent() : void
      {
         this.defButton.dispatchEvent(new MouseEvent("click"));
      }
      
      mx_internal function addFocusables(o:DisplayObject, skipTopLevel:Boolean = false) : void
      {
         var addToFocusables:Boolean = false;
         var focusable:IFocusManagerComponent = null;
         var doc:DisplayObjectContainer = null;
         var checkChildren:Boolean = false;
         var rawChildren:IChildList = null;
         var i:int = 0;
         if(o is IFocusManagerComponent && !skipTopLevel)
         {
            addToFocusables = false;
            if(o is IFocusManagerComponent)
            {
               focusable = IFocusManagerComponent(o);
               if(focusable.focusEnabled)
               {
                  if(focusable.tabFocusEnabled && this.isTabVisible(o))
                  {
                     addToFocusables = true;
                  }
               }
            }
            if(addToFocusables)
            {
               if(this.focusableObjects.indexOf(o) == -1)
               {
                  this.focusableObjects.push(o);
                  this.calculateCandidates = true;
               }
            }
            o.addEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
            o.addEventListener("tabIndexChange",this.tabIndexChangeHandler);
         }
         if(o is DisplayObjectContainer)
         {
            doc = DisplayObjectContainer(o);
            if(o is IFocusManagerComponent)
            {
               o.addEventListener("hasFocusableChildrenChange",this.hasFocusableChildrenChangeHandler);
               checkChildren = IFocusManagerComponent(o).hasFocusableChildren;
            }
            else
            {
               o.addEventListener("tabChildrenChange",this.tabChildrenChangeHandler);
               checkChildren = doc.tabChildren;
            }
            if(checkChildren)
            {
               if(o is IRawChildrenContainer)
               {
                  rawChildren = IRawChildrenContainer(o).rawChildren;
                  for(i = 0; i < rawChildren.numChildren; i++)
                  {
                     try
                     {
                        this.addFocusables(rawChildren.getChildAt(i));
                     }
                     catch(error:SecurityError)
                     {
                     }
                  }
               }
               else
               {
                  for(i = 0; i < doc.numChildren; i++)
                  {
                     try
                     {
                        this.addFocusables(doc.getChildAt(i));
                     }
                     catch(error:SecurityError)
                     {
                     }
                  }
               }
            }
         }
      }
      
      private function isTabVisible(o:DisplayObject) : Boolean
      {
         var s:DisplayObject = DisplayObject(this.form.systemManager);
         if(!s)
         {
            return false;
         }
         var p:DisplayObjectContainer = o.parent;
         while(Boolean(p) && p != s)
         {
            if(!p.tabChildren)
            {
               return false;
            }
            if(p is IFocusManagerComponent && !IFocusManagerComponent(p).hasFocusableChildren)
            {
               return false;
            }
            p = p.parent;
         }
         return true;
      }
      
      private function isValidFocusCandidate(o:DisplayObject, g:String) : Boolean
      {
         var tg:IFocusManagerGroup = null;
         if(o is IFocusManagerComponent)
         {
            if(!IFocusManagerComponent(o).focusEnabled)
            {
               return false;
            }
         }
         if(!this.isEnabledAndVisible(o))
         {
            return false;
         }
         if(o is IFocusManagerGroup)
         {
            tg = IFocusManagerGroup(o);
            if(g == tg.groupName)
            {
               return false;
            }
         }
         return true;
      }
      
      private function getIndexOfFocusedObject(o:DisplayObject) : int
      {
         var iui:IUIComponent = null;
         if(!o)
         {
            return -1;
         }
         var n:int = int(this.focusableCandidates.length);
         var i:int = 0;
         for(i = 0; i < n; i++)
         {
            if(this.focusableCandidates[i] == o)
            {
               return i;
            }
         }
         for(i = 0; i < n; i++)
         {
            iui = this.focusableCandidates[i] as IUIComponent;
            if(Boolean(iui) && iui.owns(o))
            {
               return i;
            }
         }
         return -1;
      }
      
      private function getIndexOfNextObject(i:int, shiftKey:Boolean, bSearchAll:Boolean, groupName:String) : int
      {
         var o:DisplayObject = null;
         var tg1:IFocusManagerGroup = null;
         var j:int = 0;
         var obj:DisplayObject = null;
         var tg2:IFocusManagerGroup = null;
         var n:int = int(this.focusableCandidates.length);
         var start:int = i;
         while(true)
         {
            if(shiftKey)
            {
               i--;
            }
            else
            {
               i++;
            }
            if(bSearchAll)
            {
               if(shiftKey && i < 0)
               {
                  break;
               }
               if(!shiftKey && i == n)
               {
                  break;
               }
            }
            else
            {
               i = (i + n) % n;
               if(start == i)
               {
                  break;
               }
               if(start == -1)
               {
                  start = i;
               }
            }
            if(this.isValidFocusCandidate(this.focusableCandidates[i],groupName))
            {
               o = DisplayObject(this.findFocusManagerComponent2(this.focusableCandidates[i]));
               if(o is IFocusManagerGroup)
               {
                  tg1 = IFocusManagerGroup(o);
                  for(j = 0; j < this.focusableCandidates.length; j++)
                  {
                     obj = this.focusableCandidates[j];
                     if(obj is IFocusManagerGroup && this.isEnabledAndVisible(obj))
                     {
                        tg2 = IFocusManagerGroup(obj);
                        if(tg2.groupName == tg1.groupName && tg2.selected)
                        {
                           if(InteractiveObject(obj).tabIndex != InteractiveObject(o).tabIndex && !tg1.selected)
                           {
                              return this.getIndexOfNextObject(i,shiftKey,bSearchAll,groupName);
                           }
                           i = j;
                           break;
                        }
                     }
                  }
               }
               return i;
            }
         }
         return i;
      }
      
      private function setFocusToNextObject(event:FocusEvent) : void
      {
         this.focusChanged = false;
         if(this.focusableObjects.length == 0)
         {
            return;
         }
         var focusInfo:FocusInfo = this.getNextFocusManagerComponent2(event.shiftKey,this.fauxFocus);
         if(!this.popup && (focusInfo.wrapped || !focusInfo.displayObject))
         {
            if(hasEventListener("focusWrapping"))
            {
               if(!dispatchEvent(new FocusEvent("focusWrapping",false,true,null,event.shiftKey)))
               {
                  return;
               }
            }
         }
         if(!focusInfo.displayObject)
         {
            event.preventDefault();
            return;
         }
         this.setFocusToComponent(focusInfo.displayObject,event.shiftKey);
      }
      
      private function setFocusToComponent(o:Object, shiftKey:Boolean) : void
      {
         this.focusChanged = false;
         if(Boolean(o))
         {
            if(hasEventListener("setFocusToComponent"))
            {
               if(!dispatchEvent(new FocusEvent("setFocusToComponent",false,true,InteractiveObject(o),shiftKey)))
               {
                  return;
               }
            }
            if(o is IFocusManagerComplexComponent)
            {
               IFocusManagerComplexComponent(o).assignFocus(shiftKey ? "bottom" : "top");
               this.focusChanged = true;
            }
            else if(o is IFocusManagerComponent)
            {
               this.setFocus(IFocusManagerComponent(o));
               this.focusChanged = true;
            }
         }
      }
      
      mx_internal function setFocusToNextIndex(index:int, shiftKey:Boolean) : void
      {
         if(this.focusableObjects.length == 0)
         {
            return;
         }
         if(this.calculateCandidates)
         {
            this.sortFocusableObjects();
            this.calculateCandidates = false;
         }
         var focusInfo:FocusInfo = this.getNextFocusManagerComponent2(shiftKey,null,index);
         if(!this.popup && focusInfo.wrapped)
         {
            if(hasEventListener("setFocusToNextIndex"))
            {
               if(!dispatchEvent(new FocusEvent("setFocusToNextIndex",false,true,null,shiftKey)))
               {
                  return;
               }
            }
         }
         this.setFocusToComponent(focusInfo.displayObject,shiftKey);
      }
      
      public function getNextFocusManagerComponent(backward:Boolean = false) : IFocusManagerComponent
      {
         return this.getNextFocusManagerComponent2(backward,this.fauxFocus).displayObject as IFocusManagerComponent;
      }
      
      private function getNextFocusManagerComponent2(backward:Boolean = false, fromObject:DisplayObject = null, fromIndex:int = -2) : FocusInfo
      {
         var o:DisplayObject = null;
         var g:String = null;
         var tg:IFocusManagerGroup = null;
         if(this.focusableObjects.length == 0)
         {
            return null;
         }
         if(this.calculateCandidates)
         {
            this.sortFocusableObjects();
            this.calculateCandidates = false;
         }
         var i:int = fromIndex;
         if(fromIndex == FROM_INDEX_UNSPECIFIED)
         {
            o = fromObject;
            if(!o)
            {
               o = this.form.systemManager.stage.focus;
            }
            o = DisplayObject(this.findFocusManagerComponent2(InteractiveObject(o)));
            g = "";
            if(o is IFocusManagerGroup)
            {
               tg = IFocusManagerGroup(o);
               g = tg.groupName;
            }
            i = this.getIndexOfFocusedObject(o);
         }
         var bSearchAll:Boolean = false;
         var start:int = i;
         if(i == -1)
         {
            if(backward)
            {
               i = int(this.focusableCandidates.length);
            }
            bSearchAll = true;
         }
         var j:int = this.getIndexOfNextObject(i,backward,bSearchAll,g);
         var wrapped:Boolean = false;
         if(backward)
         {
            if(j >= i)
            {
               wrapped = true;
            }
         }
         else if(j <= i)
         {
            wrapped = true;
         }
         var focusInfo:FocusInfo = new FocusInfo();
         focusInfo.displayObject = this.findFocusManagerComponent2(this.focusableCandidates[j]);
         focusInfo.wrapped = wrapped;
         return focusInfo;
      }
      
      private function getTopLevelFocusTarget(o:InteractiveObject) : InteractiveObject
      {
         while(o != InteractiveObject(this.form))
         {
            if(o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled && IFocusManagerComponent(o).mouseFocusEnabled && (o is IUIComponent ? Boolean(IUIComponent(o).enabled) : Boolean(true)))
            {
               return o;
            }
            if(hasEventListener("getTopLevelFocusTarget"))
            {
               if(!dispatchEvent(new FocusEvent("getTopLevelFocusTarget",false,true,o.parent)))
               {
                  return null;
               }
            }
            o = o.parent;
            if(o == null)
            {
               break;
            }
         }
         return null;
      }
      
      override public function toString() : String
      {
         return Object(this.form).toString() + ".focusManager";
      }
      
      private function clearBrowserFocusComponent() : void
      {
         if(Boolean(this.browserFocusComponent))
         {
            if(this.browserFocusComponent.tabIndex == this.LARGE_TAB_INDEX)
            {
               this.browserFocusComponent.tabIndex = -1;
            }
            this.browserFocusComponent = null;
         }
      }
      
      private function addedHandler(event:Event) : void
      {
         var target:DisplayObject = DisplayObject(event.target);
         if(Boolean(target.stage))
         {
            this.addFocusables(DisplayObject(event.target));
         }
      }
      
      private function removedHandler(event:Event) : void
      {
         var i:int = 0;
         var o:DisplayObject = DisplayObject(event.target);
         var focusPaneParent:DisplayObject = Boolean(this.focusPane) ? this.focusPane.parent : null;
         if(Boolean(focusPaneParent) && o != this.focusPane)
         {
            if(o is DisplayObjectContainer && this.isParent(DisplayObjectContainer(o),this.focusPane))
            {
               if(focusPaneParent is ISystemManager)
               {
                  ISystemManager(focusPaneParent).focusPane = null;
               }
               else
               {
                  IUIComponent(focusPaneParent).focusPane = null;
               }
            }
         }
         if(o is IFocusManagerComponent)
         {
            for(i = 0; i < this.focusableObjects.length; i++)
            {
               if(o == this.focusableObjects[i])
               {
                  if(o == this._lastFocus)
                  {
                     this._lastFocus.drawFocus(false);
                     this._lastFocus = null;
                  }
                  this.focusableObjects.splice(i,1);
                  this.focusableCandidates = [];
                  this.calculateCandidates = true;
                  break;
               }
            }
            o.removeEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
            o.removeEventListener("tabIndexChange",this.tabIndexChangeHandler);
         }
         this.removeFocusables(o,false);
      }
      
      private function removeFocusables(o:DisplayObject, dontRemoveTabChildrenHandler:Boolean) : void
      {
         var i:int = 0;
         if(o is DisplayObjectContainer)
         {
            if(!dontRemoveTabChildrenHandler)
            {
               o.removeEventListener("tabChildrenChange",this.tabChildrenChangeHandler);
               o.removeEventListener("hasFocusableChildrenChange",this.hasFocusableChildrenChangeHandler);
            }
            for(i = 0; i < this.focusableObjects.length; i++)
            {
               if(this.isParent(DisplayObjectContainer(o),this.focusableObjects[i]))
               {
                  if(this.focusableObjects[i] == this._lastFocus)
                  {
                     this._lastFocus.drawFocus(false);
                     this._lastFocus = null;
                  }
                  this.focusableObjects[i].removeEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
                  this.focusableObjects[i].removeEventListener("tabIndexChange",this.tabIndexChangeHandler);
                  this.focusableObjects.splice(i,1);
                  i -= 1;
                  this.focusableCandidates = [];
                  this.calculateCandidates = true;
               }
            }
         }
      }
      
      private function showHandler(event:Event) : void
      {
         var awm:IActiveWindowManager = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(Boolean(awm))
         {
            awm.activate(this.form);
         }
      }
      
      private function hideHandler(event:Event) : void
      {
         var awm:IActiveWindowManager = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(Boolean(awm))
         {
            awm.deactivate(this.form);
         }
      }
      
      private function childHideHandler(event:Event) : void
      {
         var target:DisplayObject = DisplayObject(event.target);
         if(Boolean(this.lastFocus) && Boolean(!this.isEnabledAndVisible(DisplayObject(this.lastFocus))) && Boolean(DisplayObject(this.form).stage))
         {
            DisplayObject(this.form).stage.focus = null;
            this.lastFocus = null;
         }
      }
      
      private function viewHideHandler(event:Event) : void
      {
         var target:DisplayObjectContainer = event.target as DisplayObjectContainer;
         var lastFocusDO:DisplayObject = this.lastFocus as DisplayObject;
         if(Boolean(target) && Boolean(lastFocusDO) && target.contains(lastFocusDO))
         {
            this.lastFocus = null;
         }
      }
      
      private function creationCompleteHandler(event:FlexEvent) : void
      {
         var awm:IActiveWindowManager = null;
         var o:DisplayObject = DisplayObject(this.form);
         if(Boolean(o.parent) && Boolean(o.visible) && !this.activated)
         {
            awm = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
            if(Boolean(awm))
            {
               awm.activate(this.form);
            }
         }
      }
      
      private function tabIndexChangeHandler(event:Event) : void
      {
         this.calculateCandidates = true;
      }
      
      private function tabFocusEnabledChangeHandler(event:Event) : void
      {
         this.calculateCandidates = true;
         var o:IFocusManagerComponent = IFocusManagerComponent(event.target);
         var n:int = int(this.focusableObjects.length);
         for(var i:int = 0; i < n; i++)
         {
            if(this.focusableObjects[i] == o)
            {
               break;
            }
         }
         if(o.tabFocusEnabled)
         {
            if(i == n && this.isTabVisible(DisplayObject(o)))
            {
               if(this.focusableObjects.indexOf(o) == -1)
               {
                  this.focusableObjects.push(o);
               }
            }
         }
         else if(i < n)
         {
            this.focusableObjects.splice(i,1);
         }
      }
      
      private function tabChildrenChangeHandler(event:Event) : void
      {
         if(event.target != event.currentTarget)
         {
            return;
         }
         this.calculateCandidates = true;
         var o:DisplayObjectContainer = DisplayObjectContainer(event.target);
         if(o.tabChildren)
         {
            this.addFocusables(o,true);
         }
         else
         {
            this.removeFocusables(o,true);
         }
      }
      
      private function hasFocusableChildrenChangeHandler(event:Event) : void
      {
         if(event.target != event.currentTarget)
         {
            return;
         }
         this.calculateCandidates = true;
         var o:IFocusManagerComponent = IFocusManagerComponent(event.target);
         if(o.hasFocusableChildren)
         {
            this.addFocusables(DisplayObject(o),true);
         }
         else
         {
            this.removeFocusables(DisplayObject(o),true);
         }
      }
      
      private function mouseFocusChangeHandler(event:FocusEvent) : void
      {
         var tf:TextField = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.relatedObject == null && "isRelatedObjectInaccessible" in event && event["isRelatedObjectInaccessible"] == true)
         {
            return;
         }
         if(event.relatedObject is TextField)
         {
            tf = event.relatedObject as TextField;
            if(tf.type == "input" || tf.selectable)
            {
               return;
            }
         }
         event.preventDefault();
      }
      
      mx_internal function keyFocusChangeHandler(event:FocusEvent) : void
      {
         var sm:ISystemManager = this.form.systemManager;
         if(hasEventListener("keyFocusChange"))
         {
            if(!dispatchEvent(new FocusEvent("keyFocusChange",false,true,InteractiveObject(event.target))))
            {
               return;
            }
         }
         this.showFocusIndicator = true;
         this.focusChanged = false;
         var haveBrowserFocusComponent:Boolean = this.browserFocusComponent != null;
         if(Boolean(this.browserFocusComponent))
         {
            this.clearBrowserFocusComponent();
         }
         if((event.keyCode == Keyboard.TAB || this.browserMode && event.keyCode == 0) && !event.isDefaultPrevented())
         {
            if(haveBrowserFocusComponent)
            {
               if(hasEventListener("browserFocusComponent"))
               {
                  dispatchEvent(new FocusEvent("browserFocusComponent",false,false,InteractiveObject(event.target)));
               }
               return;
            }
            this.setFocusToNextObject(event);
            if(this.focusChanged || sm == sm.getTopLevelRoot())
            {
               event.preventDefault();
            }
         }
      }
      
      mx_internal function keyDownHandler(event:KeyboardEvent) : void
      {
         var o:DisplayObject = null;
         var g:String = null;
         var i:int = 0;
         var j:int = 0;
         var tg:IFocusManagerGroup = null;
         var sm:ISystemManager = this.form.systemManager;
         if(hasEventListener("keyDownFM"))
         {
            if(!dispatchEvent(new FocusEvent("keyDownFM",false,true,InteractiveObject(event.target))))
            {
               return;
            }
         }
         if(sm is SystemManager)
         {
            SystemManager(sm).idleCounter = 0;
         }
         if(event.keyCode == Keyboard.TAB)
         {
            this.lastAction = "KEY";
            if(this.calculateCandidates)
            {
               this.sortFocusableObjects();
               this.calculateCandidates = false;
            }
         }
         if(this.browserMode)
         {
            if(Boolean(this.browserFocusComponent))
            {
               this.clearBrowserFocusComponent();
            }
            if(event.keyCode == Keyboard.TAB && this.focusableCandidates.length > 0)
            {
               o = this.fauxFocus;
               if(!o)
               {
                  o = this.form.systemManager.stage.focus;
               }
               o = DisplayObject(this.findFocusManagerComponent2(InteractiveObject(o)));
               g = "";
               if(o is IFocusManagerGroup)
               {
                  tg = IFocusManagerGroup(o);
                  g = tg.groupName;
               }
               i = this.getIndexOfFocusedObject(o);
               j = this.getIndexOfNextObject(i,event.shiftKey,false,g);
               if(event.shiftKey)
               {
                  if(j >= i)
                  {
                     this.browserFocusComponent = this.getBrowserFocusComponent(event.shiftKey);
                     if(this.browserFocusComponent.tabIndex == -1)
                     {
                        this.browserFocusComponent.tabIndex = 0;
                     }
                  }
               }
               else if(j <= i)
               {
                  this.browserFocusComponent = this.getBrowserFocusComponent(event.shiftKey);
                  if(this.browserFocusComponent.tabIndex == -1)
                  {
                     this.browserFocusComponent.tabIndex = this.LARGE_TAB_INDEX;
                  }
               }
            }
         }
      }
      
      private function defaultButtonKeyHandler(event:KeyboardEvent) : void
      {
         var sm:ISystemManager = this.form.systemManager;
         if(hasEventListener("defaultButtonKeyHandler"))
         {
            if(!dispatchEvent(new FocusEvent("defaultButtonKeyHandler",false,true)))
            {
               return;
            }
         }
         if(Boolean(this.defaultButtonEnabled && event.keyCode == Keyboard.ENTER) && Boolean(this.defaultButton) && Boolean(this.defButton.enabled))
         {
            this.sendDefaultButtonEvent();
         }
      }
      
      private function mouseDownCaptureHandler(event:MouseEvent) : void
      {
         this.showFocusIndicator = false;
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var sm:ISystemManager = this.form.systemManager;
         var o:DisplayObject = this.getTopLevelFocusTarget(InteractiveObject(event.target));
         if(!o)
         {
            return;
         }
         if((o != this._lastFocus || this.lastAction == "ACTIVATE") && !(o is TextField))
         {
            this.setFocus(IFocusManagerComponent(o));
         }
         else if(Boolean(this._lastFocus))
         {
         }
         if(hasEventListener("mouseDownFM"))
         {
            dispatchEvent(new FocusEvent("mouseDownFM",false,false,InteractiveObject(o)));
         }
         this.lastAction = "MOUSEDOWN";
      }
      
      private function getBrowserFocusComponent(shiftKey:Boolean) : InteractiveObject
      {
         var index:int = 0;
         var focusComponent:InteractiveObject = this.form.systemManager.stage.focus;
         if(!focusComponent)
         {
            index = shiftKey ? 0 : int(this.focusableCandidates.length - 1);
            focusComponent = this.focusableCandidates[index];
         }
         return focusComponent;
      }
   }
}

import flash.display.DisplayObject;

class FocusInfo
{
   
   public var displayObject:DisplayObject;
   
   public var wrapped:Boolean;
   
   public function FocusInfo()
   {
      super();
   }
}
