package com.riotgames.platform.common.commands
{
   import blix.action.IAction;
   import com.riotgames.platform.common.responder.IResponder;
   
   public interface ICommand extends IAction, IResponder
   {
      
      function execute() : void;
   }
}

