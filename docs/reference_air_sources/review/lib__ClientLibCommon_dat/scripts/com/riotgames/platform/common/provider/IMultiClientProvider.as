package com.riotgames.platform.common.provider
{
   import blix.context.IContext;
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface IMultiClientProvider extends IProvider
   {
      
      function getContext() : IContext;
      
      function getDisplayRoot() : DisplayObjectContainer;
   }
}

