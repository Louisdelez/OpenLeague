package com.riotgames.platform.gameclient.controllers.game.mediators
{
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.controllers.game.commands.ISpellSelectDialog;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import flash.events.IEventDispatcher;
   
   public interface IChampionSelectionViewMediator extends IEventDispatcher
   {
      
      function isSameGame(param1:GameDTO) : Boolean;
      
      function closeSpellSelectDialog() : ISpellSelectDialog;
      
      function startChampionSelect(param1:GameSelectionData) : void;
      
      function destroy() : void;
      
      function showSpellSelectDialog(param1:int) : ISpellSelectDialog;
   }
}

