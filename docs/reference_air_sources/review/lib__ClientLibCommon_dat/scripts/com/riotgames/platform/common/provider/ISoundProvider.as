package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.utils.ISoundManager;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.rust.context.IButtonAudio;
   
   public interface ISoundProvider extends IProvider, ISoundManager, IButtonAudio
   {
      
      function registerAudioDefinitionFile(param1:String) : void;
   }
}

