package com.riotgames.platform.gameclient.controllers.lobby
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChooseGameFlowViewProvider extends IProvider
   {
      
      function selectQueue(param1:int, param2:Boolean) : void;
   }
}

