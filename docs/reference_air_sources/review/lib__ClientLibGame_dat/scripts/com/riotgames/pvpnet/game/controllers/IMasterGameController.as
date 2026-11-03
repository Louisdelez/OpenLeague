package com.riotgames.pvpnet.game.controllers
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.provider.IGameProvider;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   
   public interface IMasterGameController extends ICycleViewController, IGameProvider, IProvider
   {
      
      function startTutorialGame() : void;
      
      function get masterGameViewController() : MasterGameViewController;
      
      function set masterGameViewController(param1:MasterGameViewController) : void;
      
      function get isSolo() : Boolean;
      
      function set isSolo(param1:Boolean) : void;
      
      function get gameType() : String;
      
      function set gameType(param1:String) : void;
      
      function resetGameQueueManager() : void;
      
      function cleanupAfterGameCompleteOrAborted() : void;
      
      function setGamePreparationDelegate(param1:IGamePreparationDelegate) : void;
      
      function get playAgainClicked() : ISignal;
   }
}

