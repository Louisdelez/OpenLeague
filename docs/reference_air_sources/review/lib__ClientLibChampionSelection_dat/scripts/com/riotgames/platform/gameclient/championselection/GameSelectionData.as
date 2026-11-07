package com.riotgames.platform.gameclient.championselection
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import flash.display.Sprite;
   
   public class GameSelectionData
   {
      
      private var _parentDisplay:Sprite;
      
      private var _gameMap:GameMap;
      
      private var _gameTypeConfig:GameTypeConfig;
      
      private var _game:GameDTO;
      
      private var _session:Session;
      
      private var _glowController:GlowComponentController;
      
      private var _playerRoster:Array;
      
      private var _chatController:ChatController;
      
      private var _allowFreeChampions:Boolean = true;
      
      private var _arrowedAlertController:ArrowedAlertController;
      
      private var _locale:String;
      
      private var _isSpectating:Boolean = false;
      
      public function GameSelectionData()
      {
         super();
      }
      
      public function get game() : GameDTO
      {
         return this._game;
      }
      
      public function set isSpectating(param1:Boolean) : void
      {
         this._isSpectating = param1;
      }
      
      public function get glowController() : GlowComponentController
      {
         return this._glowController;
      }
      
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      public function get playerRoster() : Array
      {
         return this._playerRoster;
      }
      
      public function set glowController(param1:GlowComponentController) : void
      {
         this._glowController = param1;
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      public function get allowFreeChampions() : Boolean
      {
         return this._allowFreeChampions;
      }
      
      public function set playerRoster(param1:Array) : void
      {
         this._playerRoster = param1;
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         this._gameMap = param1;
      }
      
      public function set gameTypeConfig(param1:GameTypeConfig) : void
      {
         this._gameTypeConfig = param1;
      }
      
      public function get arrowedAlertController() : ArrowedAlertController
      {
         return this._arrowedAlertController;
      }
      
      public function get isSpectating() : Boolean
      {
         return this._isSpectating;
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set game(param1:GameDTO) : void
      {
         this._game = param1;
      }
      
      public function get session() : Session
      {
         return this._session;
      }
      
      public function set arrowedAlertController(param1:ArrowedAlertController) : void
      {
         this._arrowedAlertController = param1;
      }
      
      public function set allowFreeChampions(param1:Boolean) : void
      {
         this._allowFreeChampions = param1;
      }
      
      public function set session(param1:Session) : void
      {
         this._session = param1;
      }
      
      public function set parentDisplay(param1:Sprite) : void
      {
         this._parentDisplay = param1;
      }
      
      public function get gameTypeConfig() : GameTypeConfig
      {
         return this._gameTypeConfig;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         this._chatController = param1;
      }
      
      public function get parentDisplay() : Sprite
      {
         return this._parentDisplay;
      }
      
      public function set locale(param1:String) : void
      {
         this._locale = param1;
      }
   }
}

