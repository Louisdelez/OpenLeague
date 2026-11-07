package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class INotificationsProvider_proxy implements IProxyObject, INotificationsProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function INotificationsProvider_proxy()
      {
         super();
      }
      
      public function showDockedPrompt(param1:DockedPrompt) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("showDockedPrompt",[param1],_loc2_);
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function removeNotification(param1:DockedPrompt, param2:String, param3:String = null, param4:Boolean = true) : void
      {
         var _loc5_:* = null;
         _loc5_ = this.__proxy.__methodInvoke("removeNotification",[param1,param2,param3,param4],_loc5_);
      }
   }
}

