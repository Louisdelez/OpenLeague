package com.riotgames.pvpnet.clientfeaturedcontent
{
   import com.riotgames.platform.proxy.IProxyObject;
   import com.riotgames.platform.proxy.ProxyObject;
   
   public class IClientFeaturedContentProvider_proxy implements IProxyObject, IClientFeaturedContentProvider
   {
      
      private var __proxy:ProxyObject = new ProxyObject();
      
      public function IClientFeaturedContentProvider_proxy()
      {
         super();
      }
      
      public function __setTarget(param1:Object) : void
      {
         this.__proxy.__setTarget(param1);
      }
      
      public function displayPopup(param1:String = null) : void
      {
         var _loc2_:* = null;
         _loc2_ = this.__proxy.__methodInvoke("displayPopup",[param1],_loc2_);
      }
      
      public function enteredMatchmakingQueue() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("enteredMatchmakingQueue",[],_loc1_);
      }
      
      public function closeFromShowAFKFilterChampionSelectionPopupActionAccepted() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("closeFromShowAFKFilterChampionSelectionPopupActionAccepted",[],_loc1_);
      }
      
      public function closeFromShowLegacyChampionSelectionPopupActionAccepted() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("closeFromShowLegacyChampionSelectionPopupActionAccepted",[],_loc1_);
      }
      
      public function closeFromGameViewStateChampionSelection() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("closeFromGameViewStateChampionSelection",[],_loc1_);
      }
      
      public function closeFromKeyboardEscape() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("closeFromKeyboardEscape",[],_loc1_);
      }
      
      public function closeFromCloseButtonClicked() : void
      {
         var _loc1_:* = null;
         _loc1_ = this.__proxy.__methodInvoke("closeFromCloseButtonClicked",[],_loc1_);
      }
   }
}

