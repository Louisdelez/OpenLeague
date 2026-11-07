package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   
   public class DisabledCommand extends CommandBase
   {
      
      private var _reason:String;
      
      private var _commandProxyName:String;
      
      public function DisabledCommand(param1:String, param2:String)
      {
         super();
         this._commandProxyName = param1;
         this._reason = param2;
      }
      
      override protected function logExecute() : void
      {
      }
      
      override public function execute() : void
      {
         super.execute();
         onComplete();
         onResult();
      }
   }
}

