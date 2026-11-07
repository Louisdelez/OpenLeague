package com.riotgames.pvpnet.tips
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.components.tooltip.IToolTipManager;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   
   public interface ITipsProvider extends IProvider
   {
      
      function createWindowToolTipManager(param1:DisplayObjectContainerProxy, param2:ToolTipConfig = null) : IToolTipManager;
      
      function assignCustomToolTip(param1:InteractiveObjectProxy, param2:*, param3:Class, param4:ToolTipConfig = null) : void;
      
      [Deprecated]
      function registerDeprecatedToolTipManager(param1:Stage, param2:ToolTipConfig = null) : void;
      
      [Deprecated]
      function assignDeprecatedToolTip(param1:InteractiveObject, param2:String) : void;
   }
}

