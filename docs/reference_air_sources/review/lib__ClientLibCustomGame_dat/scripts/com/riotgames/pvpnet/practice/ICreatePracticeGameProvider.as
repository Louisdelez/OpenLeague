package com.riotgames.pvpnet.practice
{
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ICreatePracticeGameProvider extends IProvider
   {
      
      function joinOrCreateGame() : void;
      
      function setGameConfig(param1:PracticeGameConfig) : void;
   }
}

