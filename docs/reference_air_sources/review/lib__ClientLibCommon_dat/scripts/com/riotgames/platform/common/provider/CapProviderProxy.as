package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import com.riotgames.rust.module.RiotModuleView;
   import mx.core.UIComponent;
   
   public class CapProviderProxy extends ProviderProxyBase implements ICapProvider
   {
      
      private static var _instance:ICapProvider;
      
      public function CapProviderProxy()
      {
         super(ICapProvider);
      }
      
      public static function get instance() : ICapProvider
      {
         if(_instance == null)
         {
            _instance = new CapProviderProxy();
         }
         return _instance;
      }
      
      public function set contentHolder(param1:UIComponent) : void
      {
         return _invokeSetter("contentHolder",param1);
      }
      
      public function getModuleView() : RiotModuleView
      {
         return _invoke("getModuleView");
      }
      
      public function isModuleActive() : Boolean
      {
         return _invoke("isModuleActive");
      }
      
      public function quit(param1:Function = null, param2:Function = null) : void
      {
         _invoke("quit",[param1,param2]);
      }
   }
}

