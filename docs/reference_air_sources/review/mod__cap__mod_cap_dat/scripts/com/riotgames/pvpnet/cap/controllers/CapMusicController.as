package com.riotgames.pvpnet.cap.controllers
{
   import blix.IDestructible;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.system.sound.AudioAsset;
   
   public class CapMusicController implements IDestructible
   {
      
      private static const BGM_KEY_PREFIX:String = "CAP_BGM_LAYER_";
      
      private var _soundProvider:ISoundProvider;
      
      private var _currentAudioAsset:AudioAsset;
      
      private var _currentMusicKey:String = "";
      
      public function CapMusicController(param1:ISoundProvider)
      {
         super();
         this._soundProvider = param1;
      }
      
      public function destroy() : void
      {
         this.stopMusic();
      }
      
      public function stopMusic() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in CapAudioKeys.allBgmKeys)
         {
            this._soundProvider.stop(_loc1_);
         }
      }
      
      public function setLayeredMusicLevel(param1:uint) : void
      {
         var _loc3_:String = null;
         var _loc2_:uint = CapAudioKeys.LEVEL_1;
         while(_loc2_ <= CapAudioKeys.LEVEL_COUNT)
         {
            _loc3_ = CapAudioKeys[BGM_KEY_PREFIX + _loc2_];
            if(_loc3_)
            {
               if(_loc2_ <= param1)
               {
                  this._soundProvider.play(_loc3_,true,1);
               }
               else
               {
                  this._soundProvider.play(_loc3_,true,0);
               }
            }
            _loc2_++;
         }
      }
   }
}

