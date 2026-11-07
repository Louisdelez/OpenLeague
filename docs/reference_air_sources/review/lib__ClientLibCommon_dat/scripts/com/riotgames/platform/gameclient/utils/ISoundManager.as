package com.riotgames.platform.gameclient.utils
{
   import blix.action.IAction;
   import flash.display.MovieClip;
   
   public interface ISoundManager
   {
      
      function stop(param1:String) : void;
      
      function playSummonChampionBySkinname(param1:String) : IAction;
      
      function getMusicMute() : Boolean;
      
      function muteMovieClipAudio(param1:MovieClip) : void;
      
      function playLoginMusic() : void;
      
      function play(param1:String, param2:Boolean = false, param3:Number = -1, param4:Boolean = false) : IAction;
      
      function stopBackgroundMusic() : void;
      
      function applyForceMute(param1:Boolean) : void;
      
      function toggleMuteLocalMusicOnAnimationEnabledToggle(param1:Boolean) : void;
      
      function applyVolumeToMovieClip(param1:MovieClip) : void;
      
      function stopLoginMusic() : void;
   }
}

