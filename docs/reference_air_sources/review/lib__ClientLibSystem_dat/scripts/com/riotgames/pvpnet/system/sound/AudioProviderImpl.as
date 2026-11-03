package com.riotgames.pvpnet.system.sound
{
   import blix.action.IAction;
   import com.greensock.plugins.TweenPlugin;
   import com.greensock.plugins.VolumePlugin;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.theme.ThemeConfig;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class AudioProviderImpl implements ISoundProvider
   {
      
      private static const DEFAULT_VOLUME_MOD_PERCENT:Number = 1;
      
      private static const DEFAULT_FADE_IN_TIME:Number = 1;
      
      private static const DEFAULT_FADE_OUT_TIME:Number = 1;
      
      private static const DEFAULT_LOOP_OVERLAP_TIME:int = 950;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var fileDictionary:Dictionary = new Dictionary();
      
      private var audioXML:XML;
      
      private var _clientConfig:ClientConfig;
      
      private var fileMap:Dictionary = new Dictionary(true);
      
      private var _forceMute:Boolean = false;
      
      private var _backgroundTrackPlaying:AudioAsset;
      
      private var loginMusicPlaying:Boolean = false;
      
      public function AudioProviderImpl(param1:ClientConfig)
      {
         super();
         TweenPlugin.activate([VolumePlugin]);
         this._clientConfig = param1;
         this.audioXML = <DATA/>;
         this.loadAudioDefinitionFile("assets/sounds/AudioEventDefinitions.xml");
      }
      
      public function registerAudioDefinitionFile(param1:String) : void
      {
         this.loadAudioDefinitionFile(param1);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function registerDirectXML(param1:String, param2:XML) : void
      {
         this.fileDictionary[param1] = param2;
         this.readAndRegisterXML(param2);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function updateSingleXML(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         for each(_loc2_ in this.fileDictionary)
         {
            for each(_loc3_ in _loc2_.descendants())
            {
               if(param1.name() == _loc3_.name())
               {
                  for each(_loc4_ in param1.@*)
                  {
                     _loc3_[_loc4_.name()] = _loc4_.toXMLString();
                  }
               }
            }
         }
      }
      
      public function applyForceMute(param1:Boolean) : void
      {
         var _loc2_:AudioAsset = null;
         this._forceMute = param1;
         for each(_loc2_ in this.fileMap)
         {
            _loc2_.setForceMute(param1);
         }
      }
      
      public function play(param1:String, param2:Boolean = false, param3:Number = -1, param4:Boolean = false) : IAction
      {
         if(param1 == null || param1 == "")
         {
            return null;
         }
         var _loc5_:AudioAsset = this.getSoundForKey(param1,param4);
         if(_loc5_ == null)
         {
            return null;
         }
         if(AudioTypes.isTypeExclusivePlayMusic(_loc5_.getFileType()))
         {
            if(this._backgroundTrackPlaying != null)
            {
               this.stopBackgroundMusic();
            }
            this._backgroundTrackPlaying = _loc5_;
         }
         if(param3 >= 0)
         {
            _loc5_.setLayeredAudioVolume(param3);
         }
         _loc5_.play(param2);
         return _loc5_;
      }
      
      private function preloadAsset(param1:String) : void
      {
         this.getSoundForKey(param1);
      }
      
      public function stop(param1:String) : void
      {
         if(param1 == null || param1 == "" || this.fileMap[param1] == null)
         {
            return;
         }
         (this.fileMap[param1] as AudioAsset).stop();
      }
      
      public function stopBackgroundMusic() : void
      {
         if(this._backgroundTrackPlaying != null)
         {
            this._backgroundTrackPlaying.stop();
            this._backgroundTrackPlaying = null;
         }
      }
      
      private function getSoundForKey(param1:String, param2:Boolean = false) : AudioAsset
      {
         var _loc3_:AudioAsset = null;
         var _loc4_:XML = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(this.fileMap[param1] == null || param2)
         {
            if(this.audioXML != null)
            {
               _loc4_ = this.audioXML.descendants(param1.toUpperCase())[0];
               if(_loc4_ == null)
               {
                  this.logger.warn("Bad key passed in to Audio.play :: " + param1.toUpperCase());
                  return null;
               }
               _loc5_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_VOLUME_MODIFER))
               {
                  _loc5_ = DEFAULT_VOLUME_MOD_PERCENT;
               }
               else
               {
                  _loc5_ = Number(_loc4_[AudioAttributes.FILE_VOLUME_MODIFER]);
               }
               _loc6_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_FADE_IN_TIME_IN_SECONDS))
               {
                  _loc6_ = DEFAULT_FADE_IN_TIME;
               }
               else
               {
                  _loc6_ = Number(_loc4_[AudioAttributes.FILE_FADE_IN_TIME_IN_SECONDS]);
               }
               _loc7_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_FADE_OUT_TIME_IN_SECONDS))
               {
                  _loc7_ = DEFAULT_FADE_OUT_TIME;
               }
               else
               {
                  _loc7_ = Number(_loc4_[AudioAttributes.FILE_FADE_OUT_TIME_IN_SECONDS]);
               }
               _loc8_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_MUTE_FADE_IN_TIME_IN_SECONDS))
               {
                  _loc8_ = DEFAULT_FADE_IN_TIME;
               }
               else
               {
                  _loc8_ = Number(_loc4_[AudioAttributes.FILE_MUTE_FADE_IN_TIME_IN_SECONDS]);
               }
               _loc9_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_MUTE_FADE_OUT_TIME_IN_SECONDS))
               {
                  _loc9_ = DEFAULT_FADE_OUT_TIME;
               }
               else
               {
                  _loc9_ = Number(_loc4_[AudioAttributes.FILE_MUTE_FADE_OUT_TIME_IN_SECONDS]);
               }
               _loc10_ = 0;
               if(!_loc4_.hasOwnProperty(AudioAttributes.FILE_LOOP_OVERLAP_IN_MS))
               {
                  _loc10_ = DEFAULT_LOOP_OVERLAP_TIME;
               }
               else
               {
                  _loc10_ = Number(_loc4_[AudioAttributes.FILE_LOOP_OVERLAP_IN_MS]);
               }
               _loc3_ = new AudioAsset(_loc4_[AudioAttributes.FILE_PATH],_loc4_[AudioAttributes.FILE_KEY_TYPE],_loc5_ * _loc4_[AudioAttributes.GROUP_VOLUME_MODIFIER],_loc6_,_loc7_,_loc8_,_loc9_,this._clientConfig.locale,_loc4_[AudioAttributes.FILE_DEFAULT_TO_US_LOCALE] == "true",_loc10_,ThemeConfig.instance);
               _loc3_.setForceMute(this._forceMute);
               if(param2 && this.fileMap[param1] != null)
               {
                  (this.fileMap[param1] as AudioAsset).stop();
               }
               this.fileMap[param1] = _loc3_;
            }
         }
         else
         {
            _loc3_ = this.fileMap[param1];
         }
         return _loc3_;
      }
      
      private function loadAudioDefinitionFile(param1:String) : void
      {
         var _loc3_:XML = null;
         var _loc4_:FileStream = null;
         var _loc2_:File = File.applicationDirectory.resolvePath(param1);
         if(_loc2_.exists)
         {
            _loc4_ = new FileStream();
            _loc4_.open(_loc2_,FileMode.READ);
            _loc3_ = XML(_loc4_.readUTFBytes(_loc4_.bytesAvailable));
            this.fileDictionary[_loc2_.nativePath] = _loc3_;
            _loc4_.close();
            this.readAndRegisterXML(_loc3_);
            return;
         }
      }
      
      private function readAndRegisterXML(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Number = NaN;
         var _loc5_:XML = null;
         var _loc2_:String = "/assets/sounds";
         if(param1.hasOwnProperty(AudioAttributes.GROUP_BASE_AUDIO_PATH))
         {
            _loc2_ = param1[AudioAttributes.GROUP_BASE_AUDIO_PATH];
         }
         for each(_loc3_ in param1.children())
         {
            _loc4_ = 1;
            if(_loc3_.hasOwnProperty(AudioAttributes.GROUP_VOLUME_MODIFIER))
            {
               _loc4_ = Number(_loc3_[AudioAttributes.GROUP_VOLUME_MODIFIER]);
               if(_loc4_ < 0)
               {
                  _loc4_ = 0;
               }
            }
            for each(_loc5_ in _loc3_.descendants())
            {
               if(_loc5_.hasOwnProperty(AudioAttributes.FILE_PATH))
               {
                  _loc5_[AudioAttributes.FILE_PATH] = _loc2_ + "/" + _loc5_[AudioAttributes.FILE_PATH];
                  _loc5_[AudioAttributes.GROUP_VOLUME_MODIFIER] = _loc4_;
               }
            }
         }
         this.rebuildAudioXML();
      }
      
      private function rebuildAudioXML() : void
      {
         var _loc1_:XML = null;
         var _loc2_:XML = null;
         this.audioXML = <DATA/>;
         for each(_loc1_ in this.fileDictionary)
         {
            for each(_loc2_ in _loc1_.descendants())
            {
               if(_loc2_.hasOwnProperty(AudioAttributes.FILE_PATH))
               {
                  this.audioXML.appendChild(_loc2_);
                  if(_loc2_.hasOwnProperty(AudioAttributes.FILE_PRELOAD_FILE))
                  {
                     if(_loc2_[AudioAttributes.FILE_PRELOAD_FILE] == "true")
                     {
                        this.preloadAsset(_loc2_.name());
                     }
                  }
               }
            }
         }
      }
      
      public function playLoginMusic() : void
      {
         if(this.loginMusicPlaying)
         {
            return;
         }
         this.loginMusicPlaying = true;
         this.play(AudioKeys.SOUND_LOGIN_SCREEN_INTRO);
         this.play(AudioKeys.SOUND_LOGIN_SCREEN_LORE);
         if(this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] != null)
         {
            (this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] as AudioAsset).soundEndingSignal.add(this.loginIntroComplete);
         }
      }
      
      private function loginIntroComplete() : void
      {
         if(this.loginMusicPlaying == true)
         {
            this.play(AudioKeys.SOUND_LOGIN_SCREEN_LOOP,true);
         }
      }
      
      public function stopLoginMusic() : void
      {
         if(this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] != null)
         {
            (this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] as AudioAsset).stop();
         }
         if(this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_LOOP] != null)
         {
            (this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_LOOP] as AudioAsset).stop();
         }
         if(this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_LORE] != null)
         {
            (this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_LORE] as AudioAsset).stop();
         }
         if(this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] != null)
         {
            (this.fileMap[AudioKeys.SOUND_LOGIN_SCREEN_INTRO] as AudioAsset).soundCompleteSignal.remove(this.loginIntroComplete);
         }
         this.loginMusicPlaying = false;
      }
      
      public function toggleMuteLocalMusicOnAnimationEnabledToggle(param1:Boolean) : void
      {
         var _loc2_:AudioAsset = this.getSoundForKey(AudioKeys.SOUND_LOGIN_SCREEN_INTRO);
         var _loc3_:AudioAsset = this.getSoundForKey(AudioKeys.SOUND_LOGIN_SCREEN_LOOP);
         _loc2_.setForceMute(param1);
         _loc3_.setForceMute(param1);
      }
      
      public function playSummonChampionBySkinname(param1:String) : IAction
      {
         var _loc2_:AudioAsset = this.fileMap[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new AudioAsset("/assets/sounds/{locale}/champions/" + param1 + ".mp3",AudioTypes.SFX,1,0,0,0,0,this._clientConfig.locale,true,0);
            _loc2_.setForceMute(this._forceMute);
            this.fileMap[param1] = _loc2_;
            _loc2_.play();
            return _loc2_;
         }
         _loc2_.play();
         return _loc2_;
      }
      
      public function applyVolumeToMovieClip(param1:MovieClip) : void
      {
         var _loc2_:SoundTransform = null;
         var _loc4_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         if(this.getMusicMute())
         {
            _loc2_ = new SoundTransform(0);
         }
         else
         {
            _loc2_ = new SoundTransform(this.getMusicVolume());
         }
         param1.soundTransform = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is MovieClip)
            {
               this.applyVolumeToMovieClip(_loc4_ as MovieClip);
            }
            _loc3_++;
         }
      }
      
      public function muteMovieClipAudio(param1:MovieClip) : void
      {
         var _loc3_:DisplayObject = null;
         param1.soundTransform = new SoundTransform(0);
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is MovieClip)
            {
               this.muteMovieClipAudio(_loc3_ as MovieClip);
            }
            _loc2_++;
         }
      }
      
      public function getMusicMute() : Boolean
      {
         if(this._forceMute)
         {
            return true;
         }
         if(UserPreferencesManager.userPreferencesAvailable)
         {
            return UserPreferencesManager.userPrefs.musicMute;
         }
         return UserPreferencesManager.globalPrefs.loginMusicMute;
      }
      
      private function getMusicVolume() : Number
      {
         return UserPreferencesManager.userPreferencesAvailable ? Number(UserPreferencesManager.userPrefs.musicVolume) : Number(UserPreferencesManager.globalPrefs.musicVolume);
      }
      
      public function playMouseOverButton(param1:String = "") : void
      {
         if(param1 == null || param1 == "")
         {
            this.play(AudioKeys.SOUND_MOUSE_OVER);
         }
         else
         {
            this.play(param1);
         }
      }
      
      public function playMouseDownButton(param1:String = "") : void
      {
         if(param1 == null || param1 == "")
         {
            this.play(AudioKeys.SOUND_MOUSE_DOWN);
         }
         else
         {
            this.play(param1);
         }
      }
   }
}

