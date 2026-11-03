package flash.desktop
{
   import flash.display.*;
   import flash.events.*;
   import flash.system.Security;
   import flash.utils.*;
   
   [native(cls="ApplicationClass",instance="ApplicationObject",methods="auto",construct="native")]
   [Event(name="keyUp",type="flash.events.KeyboardEvent")]
   [Event(name="keyDown",type="flash.events.KeyboardEvent")]
   [Event(name="userPresent",type="flash.events.Event")]
   [Event(name="userIdle",type="flash.events.Event")]
   [Event(name="networkChange",type="flash.events.Event")]
   [Event(name="exiting",type="flash.events.Event")]
   [Event(name="deactivate",type="flash.events.Event")]
   [Event(name="activate",type="flash.events.Event")]
   [Event(name="browserInvoke",type="flash.events.BrowserInvokeEvent")]
   [Event(name="invoke",type="flash.events.InvokeEvent")]
   public final class NativeApplication extends EventDispatcher
   {
      
      private static var _instance:NativeApplication;
      
      private static const kInvalidParamError:uint = 2004;
      
      private static const _supportsMenu:Boolean = initSupportsMenu();
      
      private static const _supportsDockIcon:Boolean = initSupportsDockIcon();
      
      private static const _supportsSystemTrayIcon:Boolean = initSupportsSystemTrayIcon();
      
      private static const _thisApplicationPath:String = initThisApplicationPath();
      
      private var queuedEvents:Array = new Array();
      
      private var timers:Object = new Object();
      
      private var networkChangeTimer:Timer = null;
      
      private var presenceChangeTimer:Timer = null;
      
      private var nPresenceListeners:int = 0;
      
      private var nPresenceIdleThreshold:int = 300;
      
      private var bPresenceUserIsIdle:Boolean = false;
      
      private var inDispatchInvokeEvent:Boolean = false;
      
      public function NativeApplication()
      {
         super();
         this.registerClosures(this.onNetworkChange);
         this.addEventListener(KeyboardEvent.KEY_DOWN,this._onKeyDownCapture,true,int.MIN_VALUE,false);
         this.addEventListener(KeyboardEvent.KEY_DOWN,this._onKeyDownBubble,false,int.MIN_VALUE,false);
      }
      
      private static native function _createSingleton() : void;
      
      public static function get nativeApplication() : NativeApplication
      {
         var sandboxType:String = Security.sandboxType;
         if(sandboxType != "application" && sandboxType != "runtime")
         {
            throw new Error("Only Application content can access the NativeApplication object.");
         }
         if(_instance == null)
         {
            _createSingleton();
         }
         return _instance;
      }
      
      [API("661")]
      public static function get supportsMenu() : Boolean
      {
         return _supportsMenu;
      }
      
      private static native function initSupportsMenu() : Boolean;
      
      [API("661")]
      public static function get supportsDockIcon() : Boolean
      {
         return _supportsDockIcon;
      }
      
      private static native function initSupportsDockIcon() : Boolean;
      
      [API("661")]
      public static function get supportsSystemTrayIcon() : Boolean
      {
         return _supportsSystemTrayIcon;
      }
      
      private static native function initSupportsSystemTrayIcon() : Boolean;
      
      [API("668")]
      public static native function get supportsDefaultApplication() : Boolean;
      
      [API("668")]
      public static native function get supportsStartAtLogin() : Boolean;
      
      private static native function initThisApplicationPath() : String;
      
      private static native function _hasBundleIdentifier() : Boolean;
      
      private function _onKeyDownCapture(ev:KeyboardEvent) : void
      {
         var mainMenu:NativeMenu = null;
         if(!ev.isDefaultPrevented())
         {
            mainMenu = null;
            if(supportsMenu)
            {
               mainMenu = this.menu;
            }
            else if(Boolean(this.activeWindow) && Boolean(NativeWindow.supportsMenu))
            {
               mainMenu = this.activeWindow.menu;
            }
            if(Boolean(mainMenu) && Boolean(this._menuPerformKeyEquivalent(mainMenu,ev)))
            {
               ev.preventDefault();
               ev.stopPropagation();
            }
         }
      }
      
      private native function _menuPerformKeyEquivalent(param1:NativeMenu, param2:KeyboardEvent) : Boolean;
      
      private function _onKeyDownBubble(ev:KeyboardEvent) : void
      {
         if(!ev.isDefaultPrevented())
         {
            this.performKeyEquivalent(ev);
         }
      }
      
      [API("661")]
      public native function exit(param1:int = 0) : void;
      
      [API("661")]
      public native function get runtimeVersion() : String;
      
      [API("661")]
      public native function get runtimePatchLevel() : uint;
      
      [API("661")]
      public native function get applicationID() : String;
      
      [API("661")]
      public native function get publisherID() : String;
      
      [API("661")]
      public native function get applicationDescriptor() : XML;
      
      [API("661")]
      public native function get menu() : NativeMenu;
      
      [API("661")]
      public native function set menu(param1:NativeMenu) : void;
      
      [API("661")]
      public native function get autoExit() : Boolean;
      
      [API("661")]
      public native function set autoExit(param1:Boolean) : void;
      
      [API("661")]
      public native function get icon() : InteractiveIcon;
      
      [Version("air2.0")]
      public native function get systemIdleMode() : String;
      
      [Version("air2.0")]
      public native function set systemIdleMode(param1:String) : void;
      
      [API("661")]
      public native function get startAtLogin() : Boolean;
      
      [API("661")]
      public native function set startAtLogin(param1:Boolean) : void;
      
      [API("661")]
      public function activate(window:NativeWindow = null) : void
      {
         var windows:Array = this.openedWindows;
         if(windows == null)
         {
            return;
         }
         windows = windows.filter(function(item:*, index:int, array:Array):Boolean
         {
            return item.visible;
         });
         if(window == null)
         {
            window = windows.length > 0 ? windows[windows.length - 1] : null;
         }
         this._activate(window);
      }
      
      private native function _activate(param1:NativeWindow) : void;
      
      [API("661")]
      public native function get activeWindow() : NativeWindow;
      
      [API("661")]
      public native function get openedWindows() : Array;
      
      [API("661")]
      public native function get timeSinceLastUserInput() : int;
      
      [API("661")]
      public function get idleThreshold() : int
      {
         return this.nPresenceIdleThreshold;
      }
      
      [API("661")]
      public function set idleThreshold(value:int) : void
      {
         if(value < 5 || value > 86400)
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         this.nPresenceIdleThreshold = value;
      }
      
      private native function performKeyEquivalent(param1:KeyboardEvent) : Boolean;
      
      public native function copy() : Boolean;
      
      public native function cut() : Boolean;
      
      public native function paste() : Boolean;
      
      public native function clear() : Boolean;
      
      public native function selectAll() : Boolean;
      
      private function verifyKnownExtension(extension:String) : void
      {
         var fileType:XML = null;
         var fileTypeExt:String = null;
         var found:Boolean = false;
         var appXML:XML = this.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         if(extension.toLowerCase() == "air")
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         for each(fileType in appXML.ns::fileTypes.elements())
         {
            fileTypeExt = fileType.ns::extension.toLowerCase();
            if(extension == fileTypeExt)
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
      }
      
      private function getKnownExtensionName(extension:String) : String
      {
         var fileType:XML = null;
         var fileTypeExt:String = null;
         var appXML:XML = this.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         for each(fileType in appXML.ns::fileTypes.elements())
         {
            fileTypeExt = fileType.ns::extension.toLowerCase();
            if(extension == fileTypeExt)
            {
               return fileType.ns::name.toString();
            }
         }
         Error.throwError(ArgumentError,kInvalidParamError);
         return null;
      }
      
      private function getKnownExtensionContentType(extension:String) : String
      {
         var fileType:XML = null;
         var fileTypeExt:String = null;
         var appXML:XML = this.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         for each(fileType in appXML.ns::fileTypes.elements())
         {
            fileTypeExt = fileType.ns::extension.toLowerCase();
            if(extension == fileTypeExt)
            {
               return fileType.ns::contentType.toString();
            }
         }
         Error.throwError(ArgumentError,kInvalidParamError);
         return null;
      }
      
      private function getKnownExtensionIcons(extension:String) : Array
      {
         var icons:Array = null;
         var fileType:XML = null;
         var fileTypeExt:String = null;
         var appXML:XML = this.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         icons = null;
         for each(fileType in appXML.ns::fileTypes.elements())
         {
            fileTypeExt = fileType.ns::extension.toLowerCase();
            if(extension == fileTypeExt)
            {
               icons = new Array();
               icons.push(fileType.ns::icon.elements(new QName(ns,"image16x16")).toString());
               icons.push(fileType.ns::icon.elements(new QName(ns,"image32x32")).toString());
               icons.push(fileType.ns::icon.elements(new QName(ns,"image48x48")).toString());
               icons.push(fileType.ns::icon.elements(new QName(ns,"image128x128")).toString());
               return icons;
            }
         }
         Error.throwError(ArgumentError,kInvalidParamError);
         return null;
      }
      
      [API("661")]
      public function getDefaultApplication(extension:String) : String
      {
         if(!supportsDefaultApplication || null == this.applicationDescriptor)
         {
            return null;
         }
         extension = extension.toLowerCase();
         this.verifyKnownExtension(extension);
         return this._getDefaultApplication(extension);
      }
      
      private native function _getDefaultApplication(param1:String) : String;
      
      [API("661")]
      public function isSetAsDefaultApplication(extension:String) : Boolean
      {
         var fileExtName:String = null;
         var defaultAppName:String = null;
         if(!supportsDefaultApplication || null == this.applicationDescriptor)
         {
            return false;
         }
         extension = extension.toLowerCase();
         this.verifyKnownExtension(extension);
         var result:Boolean = false;
         var ourAppPath:String = new String(_thisApplicationPath);
         if(_hasBundleIdentifier())
         {
            fileExtName = this.getKnownExtensionName(extension);
            result = Boolean(this._isSetAsDefaultApplication(ourAppPath,extension,fileExtName));
         }
         else
         {
            ourAppPath = ourAppPath.toLocaleLowerCase();
            defaultAppName = this._getDefaultApplication(extension);
            if(Boolean(defaultAppName))
            {
               defaultAppName = defaultAppName.toLocaleLowerCase();
            }
            if(defaultAppName == ourAppPath)
            {
               result = true;
            }
            else
            {
               result = false;
            }
         }
         return result;
      }
      
      private native function _isSetAsDefaultApplication(param1:String, param2:String, param3:String) : Boolean;
      
      [API("661")]
      public function setAsDefaultApplication(extension:String) : void
      {
         if(!supportsDefaultApplication || null == this.applicationDescriptor)
         {
            return;
         }
         extension = extension.toLowerCase();
         this.verifyKnownExtension(extension);
         var name:String = this.getKnownExtensionName(extension);
         var contentType:String = this.getKnownExtensionContentType(extension);
         var icons:Array = this.getKnownExtensionIcons(extension);
         this._setAsDefaultApplication(extension,name,contentType,icons);
      }
      
      private native function _setAsDefaultApplication(param1:String, param2:String, param3:String, param4:Array) : void;
      
      [API("661")]
      public function removeAsDefaultApplication(extension:String) : void
      {
         var name:String = null;
         var contentType:String = null;
         var icons:Array = null;
         if(!supportsDefaultApplication || null == this.applicationDescriptor)
         {
            return;
         }
         extension = extension.toLowerCase();
         this.verifyKnownExtension(extension);
         if(this.isSetAsDefaultApplication(extension))
         {
            name = this.getKnownExtensionName(extension);
            contentType = this.getKnownExtensionContentType(extension);
            icons = this.getKnownExtensionIcons(extension);
            this._removeAsDefaultApplication(extension,name,contentType,icons);
         }
      }
      
      private native function _removeAsDefaultApplication(param1:String, param2:String, param3:String, param4:Array) : void;
      
      [API("661")]
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var target:EventDispatcher = null;
         var timer:Timer = null;
         var events:Array = null;
         if(type == InvokeEvent.INVOKE || type == BrowserInvokeEvent.BROWSER_INVOKE)
         {
            target = this;
            timer = new Timer(0,1);
            events = this.queuedEvents.concat();
            this.timers[timer] = timer;
            timer.addEventListener(TimerEvent.TIMER,function():void
            {
               var dispatcher:EventDispatcher = null;
               dispatcher = new EventDispatcher(target);
               dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
               events.forEach(function(item:*, index:int, array:Array):void
               {
                  inDispatchInvokeEvent = true;
                  try
                  {
                     dispatcher.dispatchEvent(item);
                  }
                  finally
                  {
                     inDispatchInvokeEvent = false;
                  }
               });
               dispatcher.removeEventListener(type,listener,useCapture);
               timers[timer] = null;
            });
            timer.start();
         }
         if(type == Event.USER_IDLE)
         {
            if(this.nPresenceListeners == 0)
            {
               this.presenceChangeTimer = new Timer(this.idleThreshold * 1000);
               this.presenceChangeTimer.addEventListener(TimerEvent.TIMER,this.onCheckForPresenceChange);
               this.presenceChangeTimer.start();
            }
            ++this.nPresenceListeners;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      [API("661")]
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(type == Event.USER_IDLE)
         {
            --this.nPresenceListeners;
            if(this.nPresenceListeners == 0)
            {
               this.presenceChangeTimer.stop();
               this.presenceChangeTimer = null;
            }
         }
         super.removeEventListener(type,listener,useCapture);
      }
      
      [API("661")]
      override public function dispatchEvent(event:Event) : Boolean
      {
         if(!this.inDispatchInvokeEvent && (event.type == InvokeEvent.INVOKE || event.type == BrowserInvokeEvent.BROWSER_INVOKE))
         {
            this.queuedEvents.push(event);
         }
         return super.dispatchEvent(event);
      }
      
      private native function registerClosures(param1:Function) : void;
      
      private function onNetworkChange() : void
      {
         var DELAY:Number = 2000;
         if(Boolean(this.networkChangeTimer))
         {
            this.networkChangeTimer.delay = DELAY;
         }
         else
         {
            this.networkChangeTimer = new Timer(DELAY,1);
            this.networkChangeTimer.addEventListener(TimerEvent.TIMER,function():void
            {
               networkChangeTimer = null;
               dispatchEvent(new Event(Event.NETWORK_CHANGE));
            });
            this.networkChangeTimer.start();
         }
      }
      
      private native function _timeSinceLastMouseOrKeyboardEvent() : int;
      
      private function onCheckForPresenceChange(event:TimerEvent) : void
      {
         var delay:int = (this.idleThreshold - this.timeSinceLastUserInput) * 1000;
         if(Boolean(this.bPresenceUserIsIdle) && this.timeSinceLastUserInput < this.idleThreshold)
         {
            this.bPresenceUserIsIdle = false;
            this.dispatchEvent(new Event(Event.USER_PRESENT));
         }
         else if(!this.bPresenceUserIsIdle && this.timeSinceLastUserInput >= this.idleThreshold)
         {
            this.bPresenceUserIsIdle = true;
            this.dispatchEvent(new Event(Event.USER_IDLE));
            delay = 500;
         }
         else if(this.bPresenceUserIsIdle)
         {
            delay = 500;
         }
         if(Boolean(this.presenceChangeTimer))
         {
            delay = delay < 0 ? int(this.idleThreshold * 1000) : delay;
            this.presenceChangeTimer.delay = delay;
         }
      }
   }
}

