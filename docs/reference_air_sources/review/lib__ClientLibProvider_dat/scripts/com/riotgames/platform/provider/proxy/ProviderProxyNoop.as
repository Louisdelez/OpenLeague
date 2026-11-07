package com.riotgames.platform.provider.proxy
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class ProviderProxyNoop extends ProviderProxyBase
   {
      
      public function ProviderProxyNoop(param1:Class, param2:Boolean = true)
      {
         super(param1,param2);
      }
      
      override protected function _invoke(param1:String, param2:Array = null) : *
      {
         var _loc3_:Function = null;
         if(!_hasRequestedLoad)
         {
            ProviderLookup.instance.requestProvider(_providerId);
            _hasRequestedLoad = true;
         }
         if(Boolean(impl))
         {
            _loc3_ = impl[param1];
            return _loc3_.apply(null,param2);
         }
      }
   }
}

