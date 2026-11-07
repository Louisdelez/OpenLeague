package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.DisplayObjectContainer;
   
   public class SampleModuleProxy extends ProviderProxyBase implements ISampleProvider
   {
      
      private static var _instance:SampleModuleProxy;
      
      public function SampleModuleProxy()
      {
         super(ISampleProvider);
      }
      
      public static function get instance() : SampleModuleProxy
      {
         if(_instance == null)
         {
            _instance = new SampleModuleProxy();
         }
         return _instance;
      }
      
      public function showSampleView(param1:DisplayObjectContainer) : void
      {
         _invoke("showSampleView",[param1]);
      }
      
      public function showButton(param1:DisplayObjectContainer) : void
      {
         _invoke("showButton",[param1]);
      }
   }
}

