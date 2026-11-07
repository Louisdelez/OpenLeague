package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.utils.getQualifiedClassName;
   import mx.core.Singleton;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.resources.ResourceManagerImpl;
   
   public class InitializeResourceLoaderAction extends BasicAction
   {
      
      public function InitializeResourceLoaderAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         Singleton.registerClass(getQualifiedClassName(IResourceManager),ResourceManagerImpl);
         ResourceManager.getInstance().localeChain = ClientConfig.instance.locale == null ? ClientConfig.instance.locales : [ClientConfig.instance.locale];
         complete();
      }
   }
}

