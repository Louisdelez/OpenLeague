package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class MainProviderProxy extends ProviderProxyBase implements IMainProvider
   {
      
      private static var _instance:MainProviderProxy;
      
      public function MainProviderProxy()
      {
         super(IMainProvider);
      }
      
      public static function get instance() : MainProviderProxy
      {
         if(_instance == null)
         {
            _instance = new MainProviderProxy();
         }
         return _instance;
      }
      
      public function set loginData(param1:ServerSessionObject) : void
      {
         _invokeSetter("loginData",param1);
      }
      
      public function showMainView(param1:DisplayObjectContainer, param2:Function) : void
      {
         _invoke("showMainView",[param1,param2]);
      }
      
      public function onExiting(param1:Event) : void
      {
         _invoke("onExiting",[param1]);
      }
      
      public function onClosing(param1:Boolean) : void
      {
         _invoke("onClosing",[param1]);
      }
      
      public function onRestore() : void
      {
         _invoke("onRestore");
      }
   }
}

