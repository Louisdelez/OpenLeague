package com.riotgames.platform.gameclient.domain
{
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass]
   public class GlobalPrefs implements IEventDispatcher
   {
      
      public static const DEFAULT_REMEMBER_LOGIN:Boolean = false;
      
      public static const DEFAULT_LOGIN_NAME:String = "";
      
      public static const DEFAULT_MUTE:Boolean = false;
      
      public static const DEFAULT_VOLUME:Number = 0.7;
      
      public static const DEFAULT_MUSIC_MUTE:Boolean = false;
      
      public static const DEFAULT_MUSIC_VOLUME:Number = 0.7;
      
      public static const DEFAULT_ENABLE_ANIMATIONS:Boolean = true;
      
      public var loginMusicMuteChanging:Signal = new Signal();
      
      public var preferencesLoadedSummoner:Dictionary = new Dictionary();
      
      private var _loginMusicMute:Boolean = false;
      
      public var musicVolumeChanged:Signal = new Signal();
      
      private var _introPlayed:String = "false";
      
      public var localeData:UserLocaleProperties;
      
      private var _volume:Number = 0.7;
      
      public var volumeChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1719467628loginName:String = "";
      
      private var _79466322enableAnimations:Boolean = true;
      
      public var introPlayedChanged:Signal = new Signal();
      
      public var muteChanged:Signal = new Signal();
      
      private var _musicMute:Boolean = false;
      
      private var _musicVolume:Number = 0.7;
      
      public var musicMuteChanging:Signal = new Signal();
      
      private var _1864357668rememberLogin:Boolean = false;
      
      public var musicMuteChanged:Signal = new Signal();
      
      private var _mute:Boolean = false;
      
      public var introPlayedChanging:Signal = new Signal();
      
      public var loginMusicMuteChanged:Signal = new Signal();
      
      public function GlobalPrefs()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get sfxVolume() : Number
      {
         return this._volume;
      }
      
      [Bindable(event="propertyChange")]
      public function get rememberLogin() : Boolean
      {
         return this._1864357668rememberLogin;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function set _389945822musicMute(param1:Boolean) : void
      {
         this.musicMuteChanging.dispatch(param1);
         this._musicMute = param1;
         this.musicMuteChanged.dispatch(param1);
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      [Bindable(event="propertyChange")]
      public function get loginName() : String
      {
         return this._1719467628loginName;
      }
      
      public function get musicVolume() : Number
      {
         return this._musicVolume;
      }
      
      public function set loginName(param1:String) : void
      {
         var _loc2_:Object = this._1719467628loginName;
         if(_loc2_ !== param1)
         {
            this._1719467628loginName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loginName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set mute(param1:Boolean) : void
      {
         var _loc2_:Object = this.mute;
         if(_loc2_ !== param1)
         {
            this._3363353mute = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mute",_loc2_,param1));
         }
      }
      
      public function set rememberLogin(param1:Boolean) : void
      {
         var _loc2_:Object = this._1864357668rememberLogin;
         if(_loc2_ !== param1)
         {
            this._1864357668rememberLogin = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rememberLogin",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set musicMute(param1:Boolean) : void
      {
         var _loc2_:Object = this.musicMute;
         if(_loc2_ !== param1)
         {
            this._389945822musicMute = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"musicMute",_loc2_,param1));
         }
      }
      
      public function set musicVolume(param1:Number) : void
      {
         this._musicVolume = param1;
         if(this._musicVolume > 1)
         {
            this._musicVolume *= 0.1;
         }
         this.musicVolumeChanged.dispatch(this._musicVolume);
      }
      
      public function set enableAnimations(param1:Boolean) : void
      {
         var _loc2_:Object = this._79466322enableAnimations;
         if(_loc2_ !== param1)
         {
            this._79466322enableAnimations = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableAnimations",_loc2_,param1));
         }
      }
      
      public function set leaverData(param1:LeaverData) : void
      {
         this.localeData = UserLocaleProperties.convertToFakeData(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set introPlayed(param1:String) : void
      {
         var _loc2_:Object = this.introPlayed;
         if(_loc2_ !== param1)
         {
            this._115643297introPlayed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"introPlayed",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get enableAnimations() : Boolean
      {
         return this._79466322enableAnimations;
      }
      
      private function set _3363353mute(param1:Boolean) : void
      {
         this._mute = param1;
         this.muteChanged.dispatch(param1);
      }
      
      public function get musicMute() : Boolean
      {
         return this._musicMute;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      private function set _115643297introPlayed(param1:String) : void
      {
         this.introPlayedChanging.dispatch(param1);
         this._introPlayed = param1;
         this.introPlayedChanged.dispatch(param1);
      }
      
      private function set _1692831861loginMusicMute(param1:Boolean) : void
      {
         this.loginMusicMuteChanging.dispatch(param1);
         this._loginMusicMute = param1;
         this.loginMusicMuteChanged.dispatch(param1);
      }
      
      public function get introPlayed() : String
      {
         return this._introPlayed;
      }
      
      public function get leaverData() : LeaverData
      {
         return UserLocaleProperties.convertToLeaverData(this.localeData);
      }
      
      [Bindable(event="propertyChange")]
      public function set loginMusicMute(param1:Boolean) : void
      {
         var _loc2_:Object = this.loginMusicMute;
         if(_loc2_ !== param1)
         {
            this._1692831861loginMusicMute = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loginMusicMute",_loc2_,param1));
         }
      }
      
      public function get loginMusicMute() : Boolean
      {
         return this._loginMusicMute;
      }
      
      public function set sfxVolume(param1:Number) : void
      {
         this._volume = param1;
         if(this._volume > 1)
         {
            this._volume *= 0.1;
         }
         this.volumeChanged.dispatch(this._volume);
      }
   }
}

