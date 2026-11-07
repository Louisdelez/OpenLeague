package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class WaitCommand extends CommandBase
   {
      
      protected var _resourceManager:IResourceManager;
      
      private var _isBusy:Boolean = false;
      
      protected var _alertAction:AlertWaitAction;
      
      protected var _cursorManager:ICursorManager;
      
      public function WaitCommand(param1:IResourceManager, param2:ICursorManager)
      {
         super();
         this._resourceManager = param1;
         this._cursorManager = param2;
      }
      
      protected function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      protected function set isBusy(param1:Boolean) : void
      {
         if(this._isBusy == param1)
         {
            return;
         }
         if(this._isBusy)
         {
            this._cursorManager.removeBusyCursor();
            if(Boolean(this._alertAction))
            {
               this._alertAction.complete();
            }
         }
         this._isBusy = param1;
         if(this._isBusy)
         {
            if(!this._alertAction)
            {
               this._alertAction = new AlertWaitAction(this._resourceManager.getString("resources","serverWait_retrievingDataMessage"),this._resourceManager.getString("resources","serverWait_loadingMessage"));
            }
            this._cursorManager.setBusyCursor();
            this._alertAction.isModal = false;
            this._alertAction.add();
         }
      }
      
      override public function execute() : void
      {
         this.isBusy = true;
         super.execute();
      }
      
      override protected function onComplete(param1:Object = null) : void
      {
         this.isBusy = false;
         super.onComplete(param1);
      }
   }
}

