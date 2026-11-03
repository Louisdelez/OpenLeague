package
{
   import blix.action.IAction;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.tournament.ITournamentCodeProvider;
   import com.riotgames.pvpnet.tournament.TournamentCodeProvider;
   import com.riotgames.pvpnet.tournament.model.CustomGameModuleConfig;
   import com.riotgames.rust.module.RiotModuleRoot;
   import flash.net.URLRequest;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleCustomGame extends RiotModuleRoot implements IProviderModule
   {
      
      public var config:CustomGameModuleConfig;
      
      private var hasRegistered:Boolean = false;
      
      public var codeProvider:TournamentCodeProvider;
      
      public function ClientModuleCustomGame()
      {
         super();
      }
      
      private function onAssetsLoaded() : void
      {
         this.registerModule();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.reloadResources();
         this.codeProvider.setContext(this);
      }
      
      public function reloadResources() : void
      {
         var _loc1_:IAction = loadAssets(new URLRequest("/assets/customgame/tournamentCode.swf"));
         _loc1_.getCompleted().addOnce(this.onAssetsLoaded);
      }
      
      private function registerModule() : void
      {
         if(!this.hasRegistered)
         {
            this.hasRegistered = true;
            ProviderLookup.publishProvider(ITournamentCodeProvider,this.codeProvider);
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.config = new CustomGameModuleConfig();
         this.codeProvider = new TournamentCodeProvider(this.config);
         registerDependency(TournamentCodeProvider,this.codeProvider);
         registerDependency(CustomGameModuleConfig,this.config);
      }
   }
}

