package com.riotgames.platform.gameclient.championselection
{
   import blix.context.IContext;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChampionSelection extends IProvider
   {
      
      function getChampionSelectionScreen(param1:IContext) : IMainScreen;
      
      function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function startChampionSelect(param1:GameSelectionData) : void;
   }
}

