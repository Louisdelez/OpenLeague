package com.riotgames.platform.gameclient.account.GameCfgData
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.file.GameCfgData;
   import com.riotgames.platform.common.utils.file.GameIniFile;
   import com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.KeyBindingController;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.gameconfig.PlayerPreferences;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class PlayerPreferencesSyncController
   {
      
      public static const PREFERENCES_KEYBINDING:String = "KEY_BINDINGS";
      
      public var serviceProxy:ServiceProxy;
      
      public var keybindingController:KeyBindingController;
      
      private var _masterGameController:MasterGameController;
      
      private var waitAction:AlertWaitAction;
      
      public var session:Session;
      
      private var updatedFromServer:Dictionary = new Dictionary();
      
      public var clientConfig:ClientConfig;
      
      private var fileTimestamps:Dictionary = new Dictionary();
      
      private var gameStateWatcher:ChangeWatcher = null;
      
      public function PlayerPreferencesSyncController()
      {
         super();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this.waitAction = new AlertWaitAction(_loc1_.getString("resources","serverWait_retrievingDataMessage"),_loc1_.getString("resources","serverWait_loadingMessage"));
         this.init();
      }
      
      private static function createEmptyKeybindingPreference() : PlayerPreferences
      {
         var _loc1_:PlayerPreferences = new PlayerPreferences();
         _loc1_.preferenceKey = PREFERENCES_KEYBINDING;
         _loc1_.version = 1;
         _loc1_.preferences = null;
         _loc1_.enabled = true;
         return _loc1_;
      }
      
      private function saveLastAccessedTime(param1:PlayerPreferences) : void
      {
         if(UserPreferencesManager.userPrefs.prefTimestamps == null)
         {
            UserPreferencesManager.userPrefs.prefTimestamps = new Dictionary();
         }
         if(UserPreferencesManager.globalPrefs.preferencesLoadedSummoner == null)
         {
            UserPreferencesManager.globalPrefs.preferencesLoadedSummoner = new Dictionary();
         }
         UserPreferencesManager.userPrefs.prefTimestamps[param1.preferenceKey] = param1.timestamp;
         if(param1.preferences != null)
         {
            UserPreferencesManager.userPrefs.prefDTO[param1.preferenceKey] = param1;
         }
         UserPreferencesManager.globalPrefs.preferencesLoadedSummoner[param1.preferenceKey] = this.session.summoner.name;
         UserPreferencesManager.instance.saveUserPreferences(this.session.summoner.name);
         this.UpdateFileTimestamp(param1.preferenceKey,this.getPreferencesFilename(param1.preferenceKey));
      }
      
      private function saveKeybindingsIfNeeded() : Boolean
      {
         if(!this.shouldUpdateToCloud(PREFERENCES_KEYBINDING,this.getPreferencesFilename(PREFERENCES_KEYBINDING)))
         {
            return false;
         }
         this.waitAction.add();
         var _loc1_:ArrayCollection = this.keybindingController.getSerializedOverrideData();
         var _loc2_:PlayerPreferences = createEmptyKeybindingPreference();
         _loc2_.preferences = _loc1_;
         this.serviceProxy.playerPreferencesService.savePreferences(_loc2_,this.onSaveSuccess,this.onComplete,this.onError);
         return true;
      }
      
      private function UpdateKeybindings(param1:PlayerPreferences) : void
      {
         var _loc2_:GameCfgData = null;
         var _loc3_:GameIniFile = null;
         if(!param1.enabled)
         {
            return;
         }
         if(UserPreferencesManager.userPrefs.prefDTO[param1.preferenceKey])
         {
            _loc2_ = GameCfgData.deSerializeFromCloud(UserPreferencesManager.userPrefs.prefDTO[param1.preferenceKey].preferences);
            _loc3_ = new GameIniFile();
            _loc3_.initializeFromData(this.getPreferencesFilename(PREFERENCES_KEYBINDING),_loc2_);
            if(this.clientConfig.enableKeybinding == true)
            {
               _loc3_.save();
            }
            this.UpdateFileTimestamp(PREFERENCES_KEYBINDING,this.getPreferencesFilename(PREFERENCES_KEYBINDING));
         }
      }
      
      public function saveToServerIfNeeded(param1:String) : void
      {
         if(!this.clientConfig.playerPreferencesSyncing)
         {
            return;
         }
         this.saveKeybindingsIfNeeded();
      }
      
      private function UpdateFileTimestamp(param1:String, param2:String) : void
      {
         var _loc3_:Number = 0;
         var _loc4_:File = new File(param2);
         if(_loc4_.exists)
         {
            _loc3_ = Number(_loc4_.modificationDate.time);
         }
         this.fileTimestamps[param1] = _loc3_;
      }
      
      private function init() : void
      {
         this.clientConfig = ClientConfig.instance;
         this.serviceProxy = ServiceProxy.instance;
         this.session = Session.instance;
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         this._masterGameController = param1;
         if(param1 != null && this.gameStateWatcher == null)
         {
            this.gameStateWatcher = ChangeWatcher.watch(param1,"currentState",this.onMasterGameStateChanged);
         }
      }
      
      private function onError(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.waitAction.complete();
         _loc2_ = 4;
      }
      
      public function loadFromServerIfNeeded(param1:String) : void
      {
         var _loc4_:Number = NaN;
         this.updatedFromServer[param1] = false;
         if(!this.clientConfig.playerPreferencesSyncing || !this.session.summoner)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(UserPreferencesManager.globalPrefs.preferencesLoadedSummoner == null || UserPreferencesManager.globalPrefs.preferencesLoadedSummoner[param1] != this.session.summoner.name)
         {
            _loc2_ = true;
            _loc3_ = true;
         }
         else if(!this.updatedFromServer[param1])
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            _loc4_ = 0;
            if(UserPreferencesManager.userPrefs.prefTimestamps != null && UserPreferencesManager.userPrefs.prefTimestamps[param1] != null)
            {
               _loc4_ = Number(UserPreferencesManager.userPrefs.prefTimestamps[param1]);
            }
            this.waitAction.add();
            this.serviceProxy.playerPreferencesService.loadPreferences(PREFERENCES_KEYBINDING,_loc4_,_loc3_,this.onLoadPreferencesSuccess,this.onComplete,this.onError);
         }
      }
      
      private function onSaveSuccess(param1:ResultEvent) : void
      {
         var _loc2_:PlayerPreferences = param1.result as PlayerPreferences;
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.enabled)
         {
            return;
         }
         this.saveLastAccessedTime(_loc2_);
      }
      
      private function getPreferencesFilename(param1:String) : String
      {
         if(param1 == PREFERENCES_KEYBINDING)
         {
            return this.keybindingController.getInputOverrideFilename();
         }
         return null;
      }
      
      public function get masterGameController() : MasterGameController
      {
         return this._masterGameController;
      }
      
      private function onMasterGameStateChanged(param1:PropertyChangeEvent) : void
      {
         if(this.masterGameController.currentState == GameViewState.GAME_OVER || this.masterGameController.currentState == GameViewState.NO_GAME)
         {
            this.saveToServerIfNeeded(PREFERENCES_KEYBINDING);
         }
      }
      
      private function onLoadPreferencesSuccess(param1:ResultEvent) : void
      {
         var _loc2_:PlayerPreferences = param1.result as PlayerPreferences;
         if(!_loc2_)
         {
            _loc2_ = createEmptyKeybindingPreference();
         }
         if(!_loc2_.enabled)
         {
            return;
         }
         this.saveLastAccessedTime(_loc2_);
         this.updatedFromServer[_loc2_.preferenceKey] = true;
         if(_loc2_.preferenceKey == PREFERENCES_KEYBINDING)
         {
            this.UpdateKeybindings(_loc2_);
         }
      }
      
      private function onComplete(param1:Object) : void
      {
         this.waitAction.complete();
      }
      
      private function shouldUpdateToCloud(param1:String, param2:String) : Boolean
      {
         if(!this.clientConfig.playerPreferencesSyncing)
         {
            return false;
         }
         var _loc3_:Number = 0;
         var _loc4_:File = new File(param2);
         if(_loc4_.exists)
         {
            _loc3_ = Number(_loc4_.modificationDate.time);
         }
         var _loc5_:Number = 0;
         if(this.fileTimestamps[param1])
         {
            _loc5_ = Number(this.fileTimestamps[param1]);
         }
         return _loc3_ != _loc5_;
      }
   }
}

