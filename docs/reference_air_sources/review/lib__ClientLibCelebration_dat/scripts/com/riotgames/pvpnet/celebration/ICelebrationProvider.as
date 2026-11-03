package com.riotgames.pvpnet.celebration
{
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface ICelebrationProvider extends IProvider
   {
      
      function showFirstTimeLeaverDialogue() : void;
   }
}

