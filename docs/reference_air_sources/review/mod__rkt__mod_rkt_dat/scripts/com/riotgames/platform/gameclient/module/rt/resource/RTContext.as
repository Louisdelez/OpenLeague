package com.riotgames.platform.gameclient.module.rt.resource
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.ToolTipManager;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationRegistry;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.rust.context.IButtonAudio;
   import com.riotgames.rust.context.RustContext;
   import flash.display.Sprite;
   
   public class RTContext extends RustContext
   {
      
      public function RTContext(param1:IButtonAudio)
      {
         super();
         registerDependency(IButtonAudio,param1);
         this.initializeConfigurationRegistry();
      }
      
      public function setTooltipRoot(param1:Sprite) : void
      {
         registerDependency(IToolTipManager,new ToolTipManager(new SpriteProxy(this,param1),new ToolTipHandler()));
      }
      
      private function initializeConfigurationRegistry() : void
      {
         var _loc1_:IConfigurationRegistry = new ConfigurationRegistry();
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED,false);
         _loc1_.registerConfigurationModel(_loc2_);
         registerDependency(IConfigurationRegistry,_loc1_);
      }
   }
}

