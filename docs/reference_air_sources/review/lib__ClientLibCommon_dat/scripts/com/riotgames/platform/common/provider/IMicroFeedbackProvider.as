package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface IMicroFeedbackProvider extends IProvider
   {
      
      function setParentView(param1:DisplayObjectContainer) : void;
   }
}

