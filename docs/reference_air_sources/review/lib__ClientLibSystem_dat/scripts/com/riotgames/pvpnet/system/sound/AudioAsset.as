package com.riotgames.pvpnet.system.sound
{
   import blix.action.BasicAction;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.theme.ThemeConfig;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class AudioAsset extends BasicAction
   {
      
      private var _themeConfig:ThemeConfig;
      
      private var _soundCompleteSignal:Signal = new Signal();
      
      private var _soundEndingSignal:Signal = new Signal();
      
      private var _soundLoopingSignal:Signal = new Signal();
      
      private var _originalURL:String = "";
      
      private var _loaded:Boolean = false;
      
      private var _playWhenLoaded:Boolean = false;
      
      private var _locale:String = "";
      
      private var _defaultToUS:Boolean = false;
      
      private var _loopOverlap:int = 950;
      
      private var _layeredVolumeModifier:Number = 1;
      
      private var _volumeModifier:Number = 1;
      
      private var _forceMute:Boolean = false;
      
      private var _fileType:String;
      
      private var _fadeInTime:Number = 0;
      
      private var _fadeOutTime:Number = 0;
      
      private var _muteFadeInTime:Number = 0;
      
      private var _muteFadeOutTime:Number = 0;
      
      private var _loop:Boolean = false;
      
      private var _looping:Boolean = false;
      
      private var _isPlaying:Boolean = false;
      
      private var _isStopping:Boolean = false;
      
      private var _loopTimer:Timer;
      
      private var _loopChannel:SoundChannel;
      
      private var _sound:Sound;
      
      private var _channel:SoundChannel;
      
      public function AudioAsset(param1:String, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:String, param9:Boolean, param10:int, param11:ThemeConfig = null)
      {
         super(false);
         this._originalURL = param1;
         this._fileType = param2;
         this._locale = param8;
         this._defaultToUS = param9;
         this._volumeModifier = param3;
         this._fadeInTime = param4;
         this._fadeOutTime = param5;
         this._loopOverlap = param10;
         this._muteFadeInTime = param6;
         this._muteFadeOutTime = param7;
         this._themeConfig = param11;
         var _loc12_:URLRequest = this.processPathForThemeAndLocale(this._originalURL,param8);
         if(_loc12_ == null)
         {
            return;
         }
         this._sound = new Sound(_loc12_);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this._sound.addEventListener(Event.COMPLETE,this.onAssetLoaded);
         UserPreferencesManager.userPrefsAvailableChangedSignal.add(this.onUserPreferencesAvailableChanged);
      }
      
      public function get soundCompleteSignal() : Signal
      {
         return this._soundCompleteSignal;
      }
      
      public function get soundEndingSignal() : Signal
      {
         return this._soundEndingSignal;
      }
      
      public function get soundLoopingSignal() : Signal
      {
         return this._soundLoopingSignal;
      }
      
      public function get layeredVolumeModifier() : Number
      {
         return this._layeredVolumeModifier;
      }
      
      public function set layeredVolumeModifier(param1:Number) : void
      {
         if(this._layeredVolumeModifier == param1)
         {
            return;
         }
         this._layeredVolumeModifier = param1;
         if(this._layeredVolumeModifier > 1)
         {
            this._layeredVolumeModifier = 1;
         }
         if(this._layeredVolumeModifier < 0)
         {
            this._layeredVolumeModifier = 0;
         }
         this.setAudioProperties();
      }
      
      public function setLayeredAudioVolume(param1:Number) : void
      {
         if(this._channel == null)
         {
            this.layeredVolumeModifier = param1;
            return;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.5,{"layeredVolumeModifier":param1});
      }
      
      public function getFileType() : String
      {
         return this._fileType;
      }
      
      private function registerPreferencesListeners() : void
      {
         if(UserPreferencesManager.userPreferencesAvailable)
         {
            UserPreferencesManager.globalPrefs.muteChanged.remove(this.onMuteChanged);
            UserPreferencesManager.globalPrefs.volumeChanged.remove(this.onVolumeChanged);
            UserPreferencesManager.globalPrefs.musicMuteChanged.remove(this.onMuteChanged);
            UserPreferencesManager.globalPrefs.musicVolumeChanged.remove(this.onVolumeChanged);
            UserPreferencesManager.globalPrefs.loginMusicMuteChanged.remove(this.onMuteChanged);
            if(this._fileType == AudioTypes.SFX)
            {
               UserPreferencesManager.userPrefs.muteChanged.add(this.onMuteChanged);
               UserPreferencesManager.userPrefs.volumeChanged.add(this.onVolumeChanged);
            }
            else if(this._fileType == AudioTypes.MUSIC || this._fileType == AudioTypes.LAYERED_MUSIC)
            {
               UserPreferencesManager.userPrefs.musicMuteChanged.add(this.onMuteChanged);
               UserPreferencesManager.userPrefs.musicVolumeChanged.add(this.onVolumeChanged);
            }
         }
         else
         {
            UserPreferencesManager.userPrefs.muteChanged.remove(this.onMuteChanged);
            UserPreferencesManager.userPrefs.volumeChanged.remove(this.onVolumeChanged);
            UserPreferencesManager.userPrefs.musicMuteChanged.remove(this.onMuteChanged);
            UserPreferencesManager.userPrefs.musicVolumeChanged.remove(this.onVolumeChanged);
            if(this._fileType == AudioTypes.SFX)
            {
               UserPreferencesManager.globalPrefs.muteChanged.add(this.onMuteChanged);
               UserPreferencesManager.globalPrefs.volumeChanged.add(this.onVolumeChanged);
            }
            else if(this._fileType == AudioTypes.MUSIC || this._fileType == AudioTypes.LAYERED_MUSIC)
            {
               UserPreferencesManager.globalPrefs.musicMuteChanged.add(this.onMuteChanged);
               UserPreferencesManager.globalPrefs.musicVolumeChanged.add(this.onVolumeChanged);
            }
            else if(this._fileType == AudioTypes.LOGIN_MUSIC || this._fileType == AudioTypes.LOGIN_LORE)
            {
               UserPreferencesManager.globalPrefs.musicVolumeChanged.add(this.onVolumeChanged);
               UserPreferencesManager.globalPrefs.loginMusicMuteChanged.add(this.onMuteChanged);
            }
         }
      }
      
      private function processPathForThemeAndLocale(param1:String, param2:String) : URLRequest
      {
         var _loc3_:URLRequest = null;
         var _loc6_:Array = null;
         var _loc7_:File = null;
         var _loc4_:String = param1;
         var _loc5_:Boolean = false;
         if(param1.indexOf("{locale}") != -1)
         {
            _loc5_ = true;
            _loc4_ = param1.replace("{locale}",param2);
         }
         if(this._themeConfig != null && param1.indexOf("{theme}") != -1)
         {
            _loc6_ = _loc4_.split("{theme}");
            _loc3_ = this._themeConfig.getThemeAssetUrl(_loc6_[0],_loc6_[1]);
            if(_loc5_ && _loc3_ == null)
            {
               _loc4_ = param1.replace("{locale}","en_US");
               _loc6_ = _loc4_.split("{theme}");
               _loc3_ = this._themeConfig.getThemeAssetUrl(_loc6_[0],_loc6_[1]);
            }
         }
         else
         {
            _loc7_ = new File(File.applicationDirectory.nativePath + "/" + _loc4_);
            if(_loc7_.exists)
            {
               _loc3_ = new URLRequest(_loc4_);
            }
            else
            {
               _loc4_ = param1.replace("{locale}","en_US");
               _loc7_ = new File(File.applicationDirectory.nativePath + "/" + _loc4_);
               if(_loc7_.exists)
               {
                  _loc3_ = new URLRequest(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      private function onAssetLoaded(param1:Event) : void
      {
         this._loaded = true;
         if(this._playWhenLoaded)
         {
            this.play(this._loop);
         }
      }
      
      private function onLoadLocalizedSoundFailed(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this._defaultToUS)
         {
            this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadLocalizedSoundFailed);
            this._sound.removeEventListener(Event.COMPLETE,this.onAssetLoaded);
            _loc2_ = this._originalURL.replace("{locale}","en_US");
            this._sound = new Sound(new URLRequest(_loc2_));
            this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._sound.addEventListener(Event.COMPLETE,this.onAssetLoaded);
         }
         else
         {
            err(new Error());
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         err(new IOError(param1.text,param1.errorID));
      }
      
      override public function invoke() : void
      {
         this.play();
      }
      
      override public function abort() : void
      {
         this.stop(false);
      }
      
      public function play(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:SoundTransform = null;
         var _loc4_:Number = NaN;
         if(this._loaded)
         {
            reset();
            if(this._isPlaying)
            {
               if(this._fileType == AudioTypes.SFX)
               {
                  this.stop(true);
               }
               else if(!this._looping)
               {
                  return;
               }
            }
            this._loop = param1;
            if(!this._looping)
            {
               this.registerPreferencesListeners();
            }
            _loc2_ = 0;
            if(this._isStopping)
            {
               if(this._channel != null)
               {
                  _loc2_ = this._channel.soundTransform.volume;
                  TweenLite.killTweensOf(this._channel);
               }
               this.stopSound();
            }
            _loc3_ = new SoundTransform(_loc2_);
            if(this._loop)
            {
               if(this._loopTimer == null)
               {
                  _loc4_ = this._sound.length - this._loopOverlap;
                  if(_loc4_ <= 500)
                  {
                     _loc4_ = 500;
                  }
                  this._loopTimer = new Timer(_loc4_,1);
                  this._loopTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLoopTimer);
               }
               this._channel = this._sound.play(87,0,_loc3_);
               if(this._channel != null)
               {
                  this._loopTimer.start();
                  this._looping = false;
               }
            }
            else
            {
               if(this._loopTimer == null)
               {
                  _loc4_ = this._sound.length - this._loopOverlap;
                  if(_loc4_ <= 500)
                  {
                     _loc4_ = 500;
                  }
                  this._loopTimer = new Timer(_loc4_,1);
                  this._loopTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onNonLoopTimer);
               }
               this._channel = this._sound.play(0,0,_loc3_);
               if(this._channel != null)
               {
                  this._channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundDonePlaying,false,0,true);
                  this._loopTimer.start();
               }
            }
            if(this._channel != null)
            {
               this.startFadingIn();
               this._isPlaying = true;
            }
            else
            {
               this.abort();
            }
         }
         else
         {
            this._playWhenLoaded = true;
            this._loop = param1;
         }
      }
      
      private function onLoopTimer(param1:TimerEvent) : void
      {
         this._loopChannel = this._channel;
         this.startLoopFadingOut();
         this._looping = true;
         this.play(this._loop);
         this._soundLoopingSignal.dispatch();
      }
      
      private function onNonLoopTimer(param1:TimerEvent) : void
      {
         this._soundEndingSignal.dispatch();
      }
      
      private function startFadingIn() : void
      {
         if(this._fadeInTime > 0 && this._fileType != AudioTypes.SFX && !this._forceMute)
         {
            TweenLite.killTweensOf(this._channel);
            TweenLite.to(this._channel,this._fadeInTime,{"volume":this.getVolume()});
         }
         else if(!this._forceMute)
         {
            this.setAudioProperties();
         }
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this._isPlaying = false;
         this._isStopping = true;
         this._playWhenLoaded = false;
         if(this._loopTimer != null)
         {
            this._loopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onLoopTimer);
            this._loopTimer = null;
            this._looping = false;
         }
         if(this._channel != null)
         {
            if(param1)
            {
               this.stopSound();
            }
            else
            {
               this.startFadingOut();
            }
         }
         this.destroy();
      }
      
      private function startFadingOut() : void
      {
         if(this._fadeOutTime > 1)
         {
            TweenLite.killTweensOf(this._channel);
            TweenLite.to(this._channel,this._fadeOutTime,{
               "volume":0,
               "onComplete":this.stopSound
            });
         }
         else
         {
            TweenLite.to(this._channel,1,{
               "volume":0,
               "onComplete":this.stopSound
            });
         }
      }
      
      private function stopSound() : void
      {
         if(Boolean(this._channel))
         {
            this._channel.stop();
            this._channel = null;
         }
         this._isStopping = false;
      }
      
      private function startLoopFadingOut() : void
      {
         if(this._fadeOutTime > 1)
         {
            TweenLite.killTweensOf(this._loopChannel);
            TweenLite.to(this._loopChannel,this._fadeOutTime,{
               "volume":0,
               "onComplete":this.stopLoopSound
            });
         }
         else
         {
            TweenLite.to(this._loopChannel,1,{
               "volume":0,
               "onComplete":this.stopLoopSound
            });
         }
      }
      
      private function stopLoopSound() : void
      {
         if(Boolean(this._loopChannel))
         {
            this._loopChannel.stop();
            this._loopChannel = null;
         }
      }
      
      override public function destroy() : void
      {
         UserPreferencesManager.userPrefsAvailableChangedSignal.remove(this.onUserPreferencesAvailableChanged);
         UserPreferencesManager.globalPrefs.muteChanged.remove(this.onMuteChanged);
         UserPreferencesManager.globalPrefs.volumeChanged.remove(this.onVolumeChanged);
         UserPreferencesManager.globalPrefs.musicMuteChanged.remove(this.onMuteChanged);
         UserPreferencesManager.globalPrefs.musicVolumeChanged.remove(this.onVolumeChanged);
         UserPreferencesManager.globalPrefs.loginMusicMuteChanged.remove(this.onMuteChanged);
         UserPreferencesManager.userPrefs.muteChanged.remove(this.onMuteChanged);
         UserPreferencesManager.userPrefs.volumeChanged.remove(this.onVolumeChanged);
         UserPreferencesManager.userPrefs.musicMuteChanged.remove(this.onMuteChanged);
         UserPreferencesManager.userPrefs.musicVolumeChanged.remove(this.onVolumeChanged);
         super.destroy();
      }
      
      private function onSoundDonePlaying(param1:Event) : void
      {
         this._soundCompleteSignal.dispatch();
         complete();
      }
      
      public function setForceMute(param1:Boolean) : void
      {
         this._forceMute = param1;
         this.onMuteChanged(param1);
      }
      
      private function getMute() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._fileType == AudioTypes.SFX)
         {
            _loc1_ = UserPreferencesManager.userPreferencesAvailable ? Boolean(UserPreferencesManager.userPrefs.mute) : Boolean(UserPreferencesManager.globalPrefs.mute);
         }
         else if(this._fileType == AudioTypes.LOGIN_MUSIC || this._fileType == AudioTypes.LOGIN_LORE)
         {
            _loc1_ = Boolean(UserPreferencesManager.globalPrefs.loginMusicMute);
         }
         else
         {
            _loc1_ = UserPreferencesManager.userPreferencesAvailable ? Boolean(UserPreferencesManager.userPrefs.musicMute) : Boolean(UserPreferencesManager.globalPrefs.musicMute);
         }
         return _loc1_;
      }
      
      private function getVolume() : Number
      {
         var _loc1_:Number = 0;
         if(this.getMute())
         {
            return _loc1_;
         }
         if(this._fileType == AudioTypes.SFX)
         {
            _loc1_ = UserPreferencesManager.userPreferencesAvailable ? Number(UserPreferencesManager.userPrefs.sfxVolume) : Number(UserPreferencesManager.globalPrefs.sfxVolume);
         }
         else
         {
            _loc1_ = UserPreferencesManager.userPreferencesAvailable ? Number(UserPreferencesManager.userPrefs.musicVolume) : Number(UserPreferencesManager.globalPrefs.musicVolume);
         }
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         if(this._layeredVolumeModifier != 1)
         {
            _loc1_ *= this._layeredVolumeModifier;
         }
         return _loc1_ * this._volumeModifier;
      }
      
      private function setAudioProperties() : void
      {
         var _loc1_:SoundTransform = null;
         if(Boolean(this._channel))
         {
            TweenLite.killTweensOf(this._channel);
            _loc1_ = new SoundTransform(this.getVolume());
            this._channel.soundTransform = _loc1_;
         }
      }
      
      private function onUserPreferencesAvailableChanged() : void
      {
         this.registerPreferencesListeners();
      }
      
      private function onMuteChanged(param1:Boolean) : void
      {
         if(Boolean(this._channel))
         {
            if(param1 == true)
            {
               TweenLite.killTweensOf(this);
               TweenLite.killTweensOf(this._channel);
               TweenLite.to(this._channel,this._muteFadeOutTime,{"volume":0});
            }
            else
            {
               TweenLite.killTweensOf(this._channel);
               TweenLite.to(this._channel,this._muteFadeInTime,{"volume":this.getVolume()});
            }
         }
      }
      
      private function onVolumeChanged(param1:Number) : void
      {
         this.setAudioProperties();
      }
   }
}

