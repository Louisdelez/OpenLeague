package com.riotgames.pvpnet.communities
{
   import blix.assets.proxy.IDisplayChild;
   import blix.context.IContext;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ICommunitiesProvider extends IProvider
   {
      
      function getCommunitiesView(param1:IContext) : IDisplayChild;
   }
}

