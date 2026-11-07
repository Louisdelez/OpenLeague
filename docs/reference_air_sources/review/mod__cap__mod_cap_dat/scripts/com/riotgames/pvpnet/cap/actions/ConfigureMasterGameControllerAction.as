package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   
   public class ConfigureMasterGameControllerAction extends BasicAction
   {
      
      private var _masterGameController:IMasterGameController;
      
      private var _gamePreparationDelegate:IGamePreparationDelegate;
      
      private var _currentType:String;
      
      private var _currentState:String;
      
      private var _isRanked:Boolean;
      
      public function ConfigureMasterGameControllerAction(param1:IMasterGameController, param2:String, param3:String, param4:Boolean, param5:IGamePreparationDelegate)
      {
         super(false);
         this._masterGameController = param1;
         this._currentState = param2;
         this._currentType = param3;
         this._isRanked = param4;
         this._gamePreparationDelegate = param5;
      }
      
      override protected function doInvocation() : void
      {
         this._masterGameController.currentState = this._currentState;
         this._masterGameController.gameType = this._currentType;
         this._masterGameController.gameModel.ranked = this._isRanked;
         this._masterGameController.setGamePreparationDelegate(this._gamePreparationDelegate);
         this._masterGameController.initializeCycle();
         complete();
      }
      
      public function get isRanked() : Boolean
      {
         return this._isRanked;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get currentType() : String
      {
         return this._currentType;
      }
   }
}

