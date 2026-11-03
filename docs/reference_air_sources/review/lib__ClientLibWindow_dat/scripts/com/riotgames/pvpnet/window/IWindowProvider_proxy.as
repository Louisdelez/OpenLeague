package com.riotgames.pvpnet.window
{
   import blix.signals.ISignal;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyFactory;
   import com.riotgames.platform.proxy.ProxyObject;
   import com.riotgames.pvpnet.window.model.WindowBounds;
   import flash.display.Stage;
   
   public class IWindowProvider_proxy implements IProxyObject, IWindowProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IWindowProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function getDisplayStateChange() : ISignal
      {
         var _loc1_:* = ProxyFactory.createProxy(ISignal);
         _loc1_ = this.__proxy.__methodInvoke("getDisplayStateChange",[],_loc1_);
         return _loc1_ as ISignal;
      }
      
      public function getTransparentWindowStage() : Stage
      {
         var _loc1_:* = ProxyFactory.createProxy(Stage);
         _loc1_ = this.__proxy.__methodInvoke("getTransparentWindowStage",[],_loc1_);
         return _loc1_ as Stage;
      }
      
      public function restore() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("restore",[],_loc1_);
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("setVisibility",[param1],_loc2_);
      }
      
      public function minimize() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("minimize",[],_loc1_);
      }
      
      public function maximize() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("maximize",[],_loc1_);
      }
      
      public function fullScreen() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("fullScreen",[],_loc1_);
      }
      
      public function exitFullScreen() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("exitFullScreen",[],_loc1_);
      }
      
      public function getExiting() : ISignal
      {
         var _loc1_:* = ProxyFactory.createProxy(ISignal);
         _loc1_ = this.__proxy.__methodInvoke("getExiting",[],_loc1_);
         return _loc1_ as ISignal;
      }
      
      public function getExited() : ISignal
      {
         var _loc1_:* = ProxyFactory.createProxy(ISignal);
         _loc1_ = this.__proxy.__methodInvoke("getExited",[],_loc1_);
         return _loc1_ as ISignal;
      }
      
      public function exit() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("exit",[],_loc1_);
      }
      
      public function notify(param1:String = null) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("notify",[param1],_loc2_);
      }
      
      public function center(param1:Boolean = false) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("center",[param1],_loc2_);
      }
      
      public function getWindowBounds() : WindowBounds
      {
         var _loc1_:* = ProxyFactory.createProxy(WindowBounds);
         _loc1_ = this.__proxy.__methodInvoke("getWindowBounds",[],_loc1_);
         return _loc1_ as WindowBounds;
      }
      
      public function getFrameRate() : Number
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getFrameRate",[],_loc1_);
         return _loc1_ as Number;
      }
      
      public function setFrameRate(param1:Number) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("setFrameRate",[param1],_loc2_);
      }
      
      public function hideAirClient() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("hideAirClient",[],_loc1_);
      }
      
      public function showAirClient() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("showAirClient",[],_loc1_);
      }
   }
}

