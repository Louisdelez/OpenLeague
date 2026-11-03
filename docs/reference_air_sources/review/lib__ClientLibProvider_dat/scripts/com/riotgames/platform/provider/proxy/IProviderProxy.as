package com.riotgames.platform.provider.proxy
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IProviderProxy extends IProvider
   {
      
      function get proxyLoaded() : Boolean;
   }
}

