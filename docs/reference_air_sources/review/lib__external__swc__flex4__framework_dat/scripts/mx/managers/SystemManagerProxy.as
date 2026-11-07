package mx.managers
{
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.managers.systemClasses.ChildManager;
   import mx.managers.systemClasses.MarshallingSupport;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class SystemManagerProxy extends SystemManager
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var mp:MarshallingSupport;
      
      private var _systemManager:ISystemManager;
      
      public function SystemManagerProxy(systemManager:ISystemManager)
      {
         super();
         this._systemManager = systemManager;
         this.mp = MarshallingSupport(systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
         mx_internal::topLevel = true;
         super.addEventListener(MouseEvent.MOUSE_DOWN,this.proxyMouseDownHandler,true);
         registerImplementation("mx.managers::IActiveWindowManager",new SystemManagerProxyActivePopUpManager(this));
         mx_internal::childManager = new ChildManager(this);
      }
      
      override public function get isProxy() : Boolean
      {
         return true;
      }
      
      override public function get screen() : Rectangle
      {
         return this._systemManager.screen;
      }
      
      override public function get topLevelSystemManager() : ISystemManager
      {
         return this.systemManager.topLevelSystemManager;
      }
      
      override public function get document() : Object
      {
         return this.mp.findFocusManagerContainer(this);
      }
      
      override public function set document(value:Object) : void
      {
      }
      
      public function get systemManager() : ISystemManager
      {
         return this._systemManager;
      }
      
      override public function getDefinitionByName(name:String) : Object
      {
         return this._systemManager.getDefinitionByName(name);
      }
      
      override public function create(... params) : Object
      {
         return IFlexModuleFactory(this._systemManager).create.apply(this,params);
      }
      
      override public function getImplementation(interfaceName:String) : Object
      {
         var obj:Object = super.getImplementation(interfaceName);
         if(Boolean(obj))
         {
            return obj;
         }
         return this._systemManager.getImplementation(interfaceName);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         this._systemManager.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         this._systemManager.removeEventListener(type,listener,useCapture);
      }
      
      override public function isTopLevel() : Boolean
      {
         return this.systemManager.isTopLevel();
      }
      
      override public function getVisibleApplicationRect(bounds:Rectangle = null, skipToSandboxRoot:Boolean = false) : Rectangle
      {
         return this._systemManager.getVisibleApplicationRect(bounds,skipToSandboxRoot);
      }
      
      public function activateByProxy(f:IFocusManagerContainer) : void
      {
         var awm:IActiveWindowManager = IActiveWindowManager(this.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         awm.activate(f);
      }
      
      public function deactivateByProxy(f:IFocusManagerContainer) : void
      {
         if(Boolean(f))
         {
            f.focusManager.deactivate();
         }
      }
      
      private function proxyMouseDownHandler(event:MouseEvent) : void
      {
         if(Boolean(this.mp.findFocusManagerContainer(this)))
         {
            this.mp.dispatchActivatedWindowEvent(this);
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
import mx.core.ISWFBridgeProvider;
import mx.events.SWFBridgeEvent;
import mx.managers.IActiveWindowManager;
import mx.managers.IFocusManagerContainer;
import mx.managers.IMarshalSystemManager;
import mx.managers.ISystemManager;
import mx.utils.NameUtil;
import mx.utils.SecurityUtil;

class SystemManagerProxyActivePopUpManager implements IActiveWindowManager
{
   
   private var systemManager:ISystemManager;
   
   public function SystemManagerProxyActivePopUpManager(systemManager:ISystemManager)
   {
      super();
      this.systemManager = systemManager;
   }
   
   public function activate(f:Object) : void
   {
      var mutualTrust:Boolean = false;
      var bridgeEvent:SWFBridgeEvent = null;
      var mp:IMarshalSystemManager = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
      var bridge:IEventDispatcher = Boolean(mp.swfBridgeGroup) ? mp.swfBridgeGroup.parentBridge : null;
      if(Boolean(bridge))
      {
         mutualTrust = SecurityUtil.hasMutualTrustBetweenParentAndChild(ISWFBridgeProvider(mp));
         bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE,false,false,{
            "notifier":bridge,
            "window":(mutualTrust ? this.systemManager : NameUtil.displayObjectToString(DisplayObject(this.systemManager)))
         });
         this.systemManager.getSandboxRoot().dispatchEvent(bridgeEvent);
      }
   }
   
   public function deactivate(f:Object) : void
   {
      var mutualTrust:Boolean = false;
      var bridgeEvent:SWFBridgeEvent = null;
      var mp:IMarshalSystemManager = IMarshalSystemManager(this.systemManager.getImplementation("mx.managers::IMarshalSystemManager"));
      var bridge:IEventDispatcher = Boolean(mp.swfBridgeGroup) ? mp.swfBridgeGroup.parentBridge : null;
      if(Boolean(bridge))
      {
         mutualTrust = SecurityUtil.hasMutualTrustBetweenParentAndChild(ISWFBridgeProvider(mp));
         bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE,false,false,{
            "notifier":bridge,
            "window":(mutualTrust ? this.systemManager : NameUtil.displayObjectToString(DisplayObject(this.systemManager)))
         });
         this.systemManager.getSandboxRoot().dispatchEvent(bridgeEvent);
      }
   }
   
   public function get numModalWindows() : int
   {
      return this.systemManager.numModalWindows;
   }
   
   public function set numModalWindows(value:int) : void
   {
      this.systemManager.numModalWindows = value;
   }
   
   public function addFocusManager(f:IFocusManagerContainer) : void
   {
   }
   
   public function removeFocusManager(f:IFocusManagerContainer) : void
   {
      this.deactivate(f);
   }
}
