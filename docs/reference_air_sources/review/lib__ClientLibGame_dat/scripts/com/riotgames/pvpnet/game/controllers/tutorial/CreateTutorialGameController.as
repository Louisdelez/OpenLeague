package com.riotgames.pvpnet.game.controllers.tutorial
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.pvpnet.game.BattleTrainingConfig;
   import com.riotgames.pvpnet.game.controllers.ICycleViewController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class CreateTutorialGameController implements ICycleViewController, IEventDispatcher
   {
      
      public var masterGameController:MasterGameController;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _1180619197isBusy:Boolean = false;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var proxiedOnError:Function;
      
      private var _isBasicTutorial:Boolean = true;
      
      private var _gameName:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function CreateTutorialGameController()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get gameName() : String
      {
         return this._gameName;
      }
      
      private function set _1769344611gameName(param1:String) : void
      {
         this._gameName = param1;
      }
      
      private function set _879340706isBasicTutorial(param1:Boolean) : void
      {
         if(param1 == false && this.isAdvancedTutorialEnabled())
         {
            this.masterGameController.gameModel.tutorialType = GameModel.TUTORIAL_TYPE_ADVANCED;
            this._isBasicTutorial = param1;
         }
         else
         {
            this.masterGameController.gameModel.tutorialType = GameModel.TUTORIAL_TYPE_BASIC;
            this._isBasicTutorial = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isBasicTutorial() : Boolean
      {
         return this._isBasicTutorial;
      }
      
      public function isAdvancedTutorialEnabled() : Boolean
      {
         return Boolean(BattleTrainingConfig.getEnabledConfig().getBoolean());
      }
      
      public function chooseTutorialType(param1:Boolean) : void
      {
         this.isBasicTutorial = param1;
      }
      
      public function createGame(param1:Function) : void
      {
         this.proxiedOnError = param1;
         this.isBusy = true;
         this.serviceProxy.gameService.createTutorialGame(this.isBasicTutorial ? 0 : 1,this.onGameCreated,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function cancelGame() : void
      {
         this.masterGameController.playAnotherGame();
      }
      
      public function initialize() : void
      {
      }
      
      public function initializeCycle() : void
      {
      }
      
      public function abortCycle() : void
      {
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
         this.gameName = null;
         this.proxiedOnError = null;
         this.isBusy = false;
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
            this.proxiedOnError = null;
         }
      }
      
      private function onGameCreated(param1:ResultEvent) : void
      {
         this.masterGameController.currentGame = param1.result as GameDTO;
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
            }
         }
      }
      
      public function set gameName(param1:String) : void
      {
         var _loc2_:Object = this.gameName;
         if(_loc2_ !== param1)
         {
            this._1769344611gameName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameName",_loc2_,param1));
            }
         }
      }
      
      public function set isBasicTutorial(param1:Boolean) : void
      {
         var _loc2_:Object = this.isBasicTutorial;
         if(_loc2_ !== param1)
         {
            this._879340706isBasicTutorial = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBasicTutorial",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

