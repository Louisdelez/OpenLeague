package com.riotgames.platform.gameclient.leaverbuster
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.LeaverData;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import mx.rpc.events.ResultEvent;
   
   public class LeaverBusterController
   {
      
      public var userPreferencesManager:UserPreferencesManager;
      
      private var gameInProgress:Boolean = false;
      
      public var serviceProxy:ServiceProxy;
      
      public var session:Session;
      
      private var leaverData:LeaverData;
      
      public var masterGameController:MasterGameController;
      
      private var currentGameWatcher:ChangeWatcher = null;
      
      private var gameStateCompleteCallback:Function = null;
      
      public function LeaverBusterController()
      {
         super();
         this.userPreferencesManager = UserPreferencesManager.instance;
         this.session = Session.instance;
         this.serviceProxy = ServiceProxy.instance;
      }
      
      private function saveLeaverData(param1:LeaverData, param2:Boolean) : void
      {
         UserPreferencesManager.globalPrefs.leaverData = param1;
         if(param2)
         {
            this.userPreferencesManager.saveUserPreferences(this.session.summoner.name);
         }
      }
      
      private function onCheckGameStateSuccess(param1:ResultEvent) : void
      {
         var _loc2_:GameDTO = param1.result as GameDTO;
         if(_loc2_)
         {
            this.gameInProgress = _loc2_.gameState == GameState.IN_PROGRESS;
         }
         else
         {
            this.gameInProgress = false;
         }
      }
      
      private function onCheckGameStateError(param1:ServerError) : void
      {
         this.gameInProgress = false;
      }
      
      public function shouldPreventAlternateLogin(param1:int) : Boolean
      {
         var _loc2_:LeaverData = this.getLeaverData();
         if(!_loc2_)
         {
            return false;
         }
         if(!_loc2_.gameInProgress)
         {
            return false;
         }
         if(_loc2_.summonerName == this.session.summoner.name)
         {
            return false;
         }
         if(param1 <= 0)
         {
            this.setGameIsOver();
            return false;
         }
         var _loc3_:Date = new Date();
         var _loc4_:int = int((_loc3_.time - _loc2_.gameTime) / 60000);
         if(_loc4_ > param1)
         {
            this.setGameIsOver();
            return false;
         }
         return true;
      }
      
      public function checkGameState(param1:Function) : void
      {
         var _loc2_:LeaverData = this.getLeaverData();
         if(_loc2_)
         {
            this.serviceProxy.gameService.getGame(_loc2_.gameId,this.onCheckGameStateSuccess,this.onCheckGameStateComplete,this.onCheckGameStateError);
            this.gameStateCompleteCallback = param1;
         }
      }
      
      private function getLeaverData() : LeaverData
      {
         return UserPreferencesManager.globalPrefs.leaverData;
      }
      
      private function onCheckGameStateComplete(param1:Boolean) : void
      {
         var _loc2_:LeaverData = null;
         if(!param1)
         {
            this.gameInProgress = false;
         }
         if(this.gameStateCompleteCallback != null)
         {
            _loc2_ = this.getLeaverData();
            this.gameStateCompleteCallback(this.gameInProgress,_loc2_ ? _loc2_.summonerName : "");
         }
      }
      
      public function setGameIsOver() : void
      {
         var _loc2_:LeaverData = null;
         var _loc1_:LeaverData = this.getLeaverData();
         if(!_loc1_ || Boolean(_loc1_.gameInProgress))
         {
            _loc2_ = new LeaverData();
            _loc2_.summonerName = this.session.summoner.name;
            _loc2_.gameInProgress = false;
            this.saveLeaverData(_loc2_,true);
         }
      }
      
      public function activate() : void
      {
         if(this.currentGameWatcher == null)
         {
            this.currentGameWatcher = ChangeWatcher.watch(this.masterGameController,"currentGame",this.onGameStateChanged);
         }
      }
      
      private function onGameStateChanged(param1:PropertyChangeEvent) : void
      {
         var _loc5_:Date = null;
         if(!this.masterGameController.currentGame || Boolean(this.masterGameController.isSpectating))
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:LeaverData = new LeaverData();
         _loc3_.summonerName = this.session.summoner.name;
         var _loc4_:LeaverData = this.getLeaverData();
         switch(this.masterGameController.currentGame.gameState)
         {
            case GameState.IN_PROGRESS:
            case GameState.START_REQUESTED:
               if(!_loc4_ || !_loc4_.gameInProgress)
               {
                  _loc5_ = new Date();
                  _loc3_.gameInProgress = true;
                  _loc3_.gameTime = _loc5_.time;
                  _loc3_.gameId = this.masterGameController.currentGame.id;
                  _loc2_ = true;
               }
               break;
            case GameState.TERMINATED:
            case GameState.TERMINATED_IN_ERROR:
            case GameState.FAILED_TO_START:
               if(!_loc4_ || Boolean(_loc4_.gameInProgress))
               {
                  _loc3_.gameInProgress = false;
                  _loc2_ = true;
               }
               break;
            default:
               _loc2_ = false;
         }
         if(_loc2_)
         {
            this.saveLeaverData(_loc3_,true);
         }
      }
      
      public function deactivate() : void
      {
         if(this.currentGameWatcher != null)
         {
            this.currentGameWatcher.unwatch();
            this.currentGameWatcher = null;
         }
      }
   }
}

