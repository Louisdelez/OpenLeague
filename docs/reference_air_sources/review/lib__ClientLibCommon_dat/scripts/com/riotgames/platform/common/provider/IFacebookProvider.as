package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import flash.events.IEventDispatcher;
   import mx.core.UIComponent;
   
   public interface IFacebookProvider extends IProvider, IEventDispatcher
   {
      
      function createFacebookFlow() : UIComponent;
   }
}

