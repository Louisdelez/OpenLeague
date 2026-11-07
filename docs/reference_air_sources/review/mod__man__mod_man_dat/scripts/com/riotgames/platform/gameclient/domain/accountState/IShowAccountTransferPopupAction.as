package com.riotgames.platform.gameclient.domain.accountState
{
   import blix.action.IAction;
   
   public interface IShowAccountTransferPopupAction extends IAction
   {
      
      function add(param1:AccountStateChangeContext = null) : void;
   }
}

