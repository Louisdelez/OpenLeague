package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   import flash.display.DisplayObjectContainer;
   
   public interface ISampleProvider extends IProvider
   {
      
      function showSampleView(param1:DisplayObjectContainer) : void;
      
      function showButton(param1:DisplayObjectContainer) : void;
   }
}

