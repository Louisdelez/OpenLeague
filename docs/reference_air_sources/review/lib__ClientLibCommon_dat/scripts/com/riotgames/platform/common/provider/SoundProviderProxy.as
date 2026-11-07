package com.riotgames.platform.common.provider
{
   import blix.action.IAction;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import flash.display.MovieClip;
   
   public class SoundProviderProxy extends ProviderProxyBase implements ISoundProvider
   {
      
      private static var _instance:ISoundProvider;
      
      public function SoundProviderProxy()
      {
         super(ISoundProvider);
         _queueRequests = false;
      }
      
      public static function get instance() : ISoundProvider
      {
         if(_instance == null)
         {
            _instance = new SoundProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:ISoundProvider) : void
      {
         _instance = param1;
      }
      
      public function registerAudioDefinitionFile(param1:String) : void
      {
         _invoke("registerAudioDefinitionFile",[param1]);
      }
      
      public function muteMovieClipAudio(param1:MovieClip) : void
      {
         _invoke("muteMovieClipAudio",[param1]);
      }
      
      public function playLoginMusic() : void
      {
         _invoke("playLoginMusic");
      }
      
      public function stop(param1:String) : void
      {
         _invoke("stop",[param1]);
      }
      
      public function toggleMuteLocalMusicOnAnimationEnabledToggle(param1:Boolean) : void
      {
         _invoke("toggleMuteLocalMusicOnAnimationEnabledToggle",[param1]);
      }
      
      public function playSummonChampionBySkinname(param1:String) : IAction
      {
         return _invoke("playSummonChampionBySkinname",[param1]);
      }
      
      public function applyForceMute(param1:Boolean) : void
      {
         _invoke("applyForceMute",[param1]);
      }
      
      public function getMusicMute() : Boolean
      {
         return _invoke("getMusicMute");
      }
      
      public function applyVolumeToMovieClip(param1:MovieClip) : void
      {
         _invoke("applyVolumeToMovieClip",[param1]);
      }
      
      public function stopLoginMusic() : void
      {
         _invoke("stopLoginMusic");
      }
      
      public function play(param1:String, param2:Boolean = false, param3:Number = 1, param4:Boolean = false) : IAction
      {
         return _invoke("play",[param1,param2,param3,param4]);
      }
      
      public function playMouseOverButton(param1:String = "") : void
      {
         _invoke("playMouseOverButton",[param1]);
      }
      
      public function stopBackgroundMusic() : void
      {
         _invoke("stopBackgroundMusic");
      }
      
      public function playMouseDownButton(param1:String = "") : void
      {
         _invoke("playMouseDownButton",[param1]);
      }
   }
}

