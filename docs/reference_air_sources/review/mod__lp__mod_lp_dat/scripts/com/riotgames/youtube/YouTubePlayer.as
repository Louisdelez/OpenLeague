package com.riotgames.youtube
{
   import blix.components.loader.LoaderX;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.callback.callback;
   import blix.util.string.strTrim;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class YouTubePlayer extends LoaderX
   {
      
      private static const YOUTUBE_API_PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
      
      protected var _playerReady:Signal = new Signal();
      
      protected var _playerError:Signal = new Signal();
      
      protected var _playerStateChanged:Signal = new Signal();
      
      protected var _playbackQualityChanged:Signal = new Signal();
      
      protected var _player:Object;
      
      protected var _playerIsReady:Boolean;
      
      protected var _isMuted:Boolean;
      
      protected var _volume:int;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _playerState:int;
      
      protected var _hasInitialized:Boolean;
      
      protected var _playbackQuality:String;
      
      protected var whenReadyQueue:Vector.<Function> = new Vector.<Function>();
      
      public function YouTubePlayer(param1:Context)
      {
         super(param1);
      }
      
      public static function parseId(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc2_:RegExp = /[\w\-\_]{5,15}/g;
         while(true)
         {
            _loc3_ = _loc2_.exec(param1);
            if(!_loc3_)
            {
               break;
            }
            _loc4_ = _loc3_[0];
         }
         return _loc4_;
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         super.setIsOnStage(param1);
         if(!param1)
         {
            this.pauseVideo();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         loaderAction.loader.contentLoaderInfo.addEventListener(Event.INIT,this.loaderInitHandler);
      }
      
      public function getHasInitialized() : Boolean
      {
         return this._hasInitialized;
      }
      
      public function loadChromelessPlayer() : void
      {
         this._hasInitialized = true;
         var _loc1_:LoaderContext = new LoaderContext();
         if(_loc1_.hasOwnProperty("allowCodeImport"))
         {
            _loc1_["allowCodeImport"] = true;
         }
         _loc1_.applicationDomain = new ApplicationDomain(null);
         load(new URLRequest(YOUTUBE_API_PLAYER_URL),_loc1_);
      }
      
      public function loadVideo(param1:String, param2:YouTubeParameters = null) : void
      {
         if(param2 == null)
         {
            param2 = new YouTubeParameters();
         }
         var _loc3_:String = parseId(param1);
         if(!_loc3_)
         {
            return;
         }
         if(this._hasInitialized)
         {
            this.cueVideoById(_loc3_);
            return;
         }
         this._hasInitialized = true;
         this._playerIsReady = false;
         var _loc4_:LoaderContext = new LoaderContext();
         if(_loc4_.hasOwnProperty("allowCodeImport"))
         {
            _loc4_["allowCodeImport"] = true;
         }
         _loc4_.checkPolicyFile = true;
         _loc4_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         param1 = strTrim(param1);
         var _loc5_:URLRequest = new URLRequest("http://www.youtube.com/v/" + _loc3_);
         _loc5_.method = URLRequestMethod.GET;
         var _loc6_:URLVariables = new URLVariables();
         _loc6_["version"] = 3;
         _loc6_["theme"] = "dark";
         _loc6_["fs"] = 0;
         _loc6_["rel"] = 0;
         _loc6_["modestbranding"] = 1;
         _loc5_.data = _loc6_;
         load(_loc5_,_loc4_);
         invalidateLayout();
      }
      
      public function getPlayerIsReady() : Boolean
      {
         return this._playerIsReady;
      }
      
      public function getPlayerStateChanged() : ISignal
      {
         return this._playerStateChanged;
      }
      
      public function getPlaybackQualityChanged() : ISignal
      {
         return this._playbackQualityChanged;
      }
      
      public function getPlayerReady() : ISignal
      {
         return this._playerReady;
      }
      
      public function getPlayerError() : ISignal
      {
         return this._playerError;
      }
      
      public function getPlayerState() : int
      {
         return this._playerState;
      }
      
      protected function loaderInitHandler(param1:Event) : void
      {
         var _loc2_:Loader = (param1.currentTarget as LoaderInfo).loader;
         if(_loc2_.content != null)
         {
            this.setPlayer(_loc2_.content);
         }
      }
      
      protected function setPlayer(param1:Object) : void
      {
         if(this._player == param1)
         {
            return;
         }
         if(this._player != null)
         {
            this._player.removeEventListener("onReady",this.playerReadyHandler);
            this._player.removeEventListener("onError",this.playerErrorHandler);
            this._player.removeEventListener("onStateChange",this.playerStateChangeHandler);
            this._player.removeEventListener("onPlaybackQualityChange",this.videoPlaybackQualityChangeHandler);
         }
         this._player = param1;
         this._playerIsReady = false;
         if(this._player != null)
         {
            this._player.addEventListener("onReady",this.playerReadyHandler);
            this._player.addEventListener("onError",this.playerErrorHandler);
            this._player.addEventListener("onStateChange",this.playerStateChangeHandler);
            this._player.addEventListener("onPlaybackQualityChange",this.videoPlaybackQualityChangeHandler);
         }
      }
      
      protected function playerReadyHandler(param1:Event) : void
      {
         var _loc2_:Function = null;
         this._playerIsReady = true;
         this._playbackQuality = this._player.getPlaybackQuality();
         this._volume = this._player.getVolume();
         this._isMuted = this._player.isMuted();
         this._playerState = this._player.getPlayerState();
         for each(_loc2_ in this.whenReadyQueue)
         {
            _loc2_.call();
         }
         this._playerReady.dispatch(this);
      }
      
      protected function playerErrorHandler(param1:Event) : void
      {
         this._playerError.dispatch(this,param1);
      }
      
      protected function playerStateChangeHandler(param1:Event) : void
      {
         var _loc2_:int = this._playerState;
         this._playerState = Object(param1).data;
         this._playerStateChanged.dispatch(this,_loc2_,this._playerState);
      }
      
      protected function videoPlaybackQualityChangeHandler(param1:Event) : void
      {
         var _loc2_:String = this._playbackQuality;
         this._playbackQuality = Object(param1).data;
         this._playbackQualityChanged.dispatch(this,_loc2_,this._playbackQuality);
      }
      
      public function cueVideoById(param1:String, param2:Number = 0, param3:String = null) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.cueVideoById,[param1,param2,param3]));
            return;
         }
         this._player.cueVideoById(param1,param2,param3);
      }
      
      public function loadVideoById(param1:String, param2:Number = 0, param3:String = null) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.loadVideoById,[param1,param2,param3]));
            return;
         }
         this._player.loadVideoById(param1,param2,param3);
      }
      
      public function cueVideoByUrl(param1:String, param2:Number = 0) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.cueVideoByUrl,[param1,param2]));
            return;
         }
         this._player.cueVideoByUrl(param1,param2);
      }
      
      public function loadVideoByUrl(param1:String, param2:Number = 0) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.loadVideoByUrl,[param1,param2]));
            return;
         }
         this._player.loadVideoByUrl(param1,param2);
      }
      
      public function playVideo() : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.playVideo));
            return;
         }
         this._player.playVideo();
      }
      
      public function pauseVideo() : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.pauseVideo));
            return;
         }
         this._player.pauseVideo();
      }
      
      public function stopVideo() : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.stopVideo));
            return;
         }
         this._player.stopVideo();
      }
      
      public function seekTo(param1:Number, param2:Boolean) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.seekTo,[param1,param2]));
            return;
         }
         this._player.seekTo(param1,param2);
      }
      
      public function getIsMuted() : Boolean
      {
         return this._isMuted;
      }
      
      public function setIsMuted(param1:Boolean) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.setIsMuted,[param1]));
            return;
         }
         this._isMuted = param1;
         if(this._isMuted)
         {
            this._player.mute();
         }
         else
         {
            this._player.unmute();
         }
      }
      
      public function getVolume() : int
      {
         return this._volume;
      }
      
      public function setVolume(param1:int) : void
      {
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.setVolume,[param1]));
            return;
         }
         this._volume = param1;
         this._player.setVolume(param1);
      }
      
      protected function setSize(param1:Number, param2:Number) : void
      {
         if(isNaN(param1) || isNaN(param2))
         {
            return;
         }
         if(!this._playerIsReady)
         {
            this.whenReadyQueue.push(callback(this.setSize,[param1,param2]));
            return;
         }
         this._width = param1;
         this._height = param2;
         this._player.setSize(param1,param2);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(isNaN(param1))
         {
            param1 = 100;
         }
         if(isNaN(param2))
         {
            param2 = 100;
         }
         this.setSize(param1,param2);
         setScrollRect(new Rectangle(0,0,param1,param2));
         return new Rectangle(0,0,param1,param2);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._playerIsReady)
         {
            this._player.destroy();
         }
         this._hasInitialized = false;
      }
   }
}

