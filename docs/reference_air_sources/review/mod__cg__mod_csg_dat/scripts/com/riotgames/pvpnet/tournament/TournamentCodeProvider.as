package com.riotgames.pvpnet.tournament
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.context.IContext;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.provider.IGameProvider;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.practice.ICreatePracticeGameProvider;
   import com.riotgames.pvpnet.tournament.control.TournamentCodeGenerator;
   import com.riotgames.pvpnet.tournament.model.CustomGameModuleConfig;
   import com.riotgames.pvpnet.tournament.view.TournamentCodePanel;
   import flash.display.DisplayObjectContainer;
   
   public class TournamentCodeProvider implements ITournamentCodeProvider
   {
      
      private var _config:CustomGameModuleConfig;
      
      private var gameProvider:IGameProvider;
      
      private var codeGenerator:TournamentCodeGenerator;
      
      private var _context:IContext;
      
      private var createPracticeGameProvider:ICreatePracticeGameProvider;
      
      public function TournamentCodeProvider(param1:CustomGameModuleConfig)
      {
         super();
         this._config = param1;
         ProviderLookup.getProvider(IGameProvider,this.onGotGameProvider);
         ProviderLookup.getProvider(ICreatePracticeGameProvider,this.onGotPracticeGameProvider);
      }
      
      private function onGotGameProvider(param1:IGameProvider) : void
      {
         this.gameProvider = param1;
      }
      
      public function validateCode(param1:String) : Boolean
      {
         return this.codeGenerator.parseJoinOrCreateUrl(param1) != null;
      }
      
      private function onGotPracticeGameProvider(param1:ICreatePracticeGameProvider) : void
      {
         this.createPracticeGameProvider = param1;
      }
      
      public function showTournamentCodePanel(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObjectContainerProxy = new DisplayObjectContainerProxy(this._context,param1);
         var _loc3_:TournamentCodePanel = new TournamentCodePanel(_loc2_);
         _loc2_.addChild(_loc3_);
      }
      
      public function initialize(param1:Array, param2:Array) : void
      {
         this._config.availableMaps = param1;
         this._config.gameTypes = param2;
         this._config.configChanged.dispatch(this._config);
         this.codeGenerator = new TournamentCodeGenerator(this._config);
      }
      
      public function setContext(param1:IContext) : void
      {
         this._context = param1;
      }
      
      public function injectCode(param1:String) : void
      {
         var _loc2_:PracticeGameConfig = this.codeGenerator.parseJoinOrCreateUrl(param1);
         AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         LobbyConfig.instance.isNavigationEnabled = true;
         this.createPracticeGameProvider.setGameConfig(_loc2_);
         this.createPracticeGameProvider.joinOrCreateGame();
      }
   }
}

