package
{
   import com.riotgames.platform.common.provider.IReportingProvider;
   import com.riotgames.platform.gameclient.module.reporting.Reporter;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import mx.modules.ModuleBase;
   
   public class ClientModuleReporting extends ModuleBase implements IProviderModule
   {
      
      public function ClientModuleReporting()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         var _loc2_:IReportingProvider = new Reporter();
         ProviderLookup.publishProvider(IReportingProvider,_loc2_);
      }
   }
}

