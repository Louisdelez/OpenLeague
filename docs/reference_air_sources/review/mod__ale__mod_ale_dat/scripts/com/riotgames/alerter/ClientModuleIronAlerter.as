package com.riotgames.alerter
{
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleIronAlerter extends Sprite implements IProviderModule
   {
      
      private var alerter:Alerter;
      
      public function ClientModuleIronAlerter()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.alerter = new Alerter(new AlertViewFactory(null,param1));
         ProviderLookup.publishProvider(IAlerterProvider,this.alerter);
      }
   }
}

