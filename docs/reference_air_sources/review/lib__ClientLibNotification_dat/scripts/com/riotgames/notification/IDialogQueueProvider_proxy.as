package com.riotgames.notification
{
   import blix.action.IAction;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IDialogQueueProvider_proxy implements IProxyObject, IDialogQueueProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IDialogQueueProvider_proxy()
      {
         super();
      }
      
      public function getAllDialogs() : Vector.<IAction>
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getAllDialogs",[],_loc1_);
         return _loc1_ as Vector.<IAction>;
      }
      
      public function removeActiveDialogs() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("removeActiveDialogs",[],_loc1_);
      }
      
      public function addDialog(param1:IAction) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("addDialog",[param1],_loc2_);
      }
      
      public function getActiveDialogs() : Vector.<IAction>
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("getActiveDialogs",[],_loc1_);
         return _loc1_ as Vector.<IAction>;
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function removeDialog(param1:IAction) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("removeDialog",[param1],_loc2_);
      }
   }
}

