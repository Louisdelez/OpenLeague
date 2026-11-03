package blix.assets.proxy
{
   import blix.context.IContext;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Scene;
   
   public class MovieClipProxy extends SpriteProxy implements ITimelineObject
   {
      
      protected var _mcAsset:MovieClip;
      
      protected var _isPlaying:Boolean;
      
      protected var pendingTimelineCalls:Vector.<PendingCall> = new Vector.<PendingCall>();
      
      protected var lastKnownFrame:int;
      
      public function MovieClipProxy(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function unconfigureAsset(param1:DisplayObject) : void
      {
         super.unconfigureAsset(param1);
         if(this._mcAsset != null)
         {
            if(_isOnStage)
            {
               this.lastKnownFrame = this._mcAsset.currentFrame;
            }
            this._mcAsset.stop();
         }
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         this._mcAsset = param1 as MovieClip;
         if(this._mcAsset != null)
         {
            this._mcAsset.stop();
         }
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         var _loc2_:PendingCall = null;
         if(_isOnStage == param1)
         {
            return;
         }
         super.setIsOnStage(param1);
         if(param1)
         {
            if(Boolean(this.lastKnownFrame))
            {
               if(this._isPlaying)
               {
                  this._mcAsset.gotoAndPlay(this.lastKnownFrame);
               }
               else
               {
                  this._mcAsset.gotoAndStop(this.lastKnownFrame);
               }
               this.lastKnownFrame = 0;
            }
            for each(_loc2_ in this.pendingTimelineCalls)
            {
               _loc2_.execute(this._mcAsset);
            }
            this.pendingTimelineCalls.length = 0;
         }
         else if(this._mcAsset != null)
         {
            this.lastKnownFrame = this._mcAsset.currentFrame;
         }
      }
      
      public function getMovieClip() : MovieClip
      {
         return this._mcAsset;
      }
      
      public function getIsPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function getCurrentFrame() : int
      {
         return assetProxy.currentFrame;
      }
      
      public function getCurrentFrameLabel() : String
      {
         return assetProxy.currentFrameLabel;
      }
      
      public function getCurrentLabel() : String
      {
         return assetProxy.currentLabel;
      }
      
      public function getCurrentLabels() : Array
      {
         return assetProxy.currentLabel;
      }
      
      public function getCurrentScene() : Scene
      {
         return assetProxy.currentScene;
      }
      
      public function getEnabled() : Boolean
      {
         return assetProxy.enabled;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         assetProxy.enabled = param1;
      }
      
      public function getTotalFrames() : int
      {
         return assetProxy.totalFrames;
      }
      
      public function getTrackAsMenu() : Boolean
      {
         return assetProxy.trackAsMenu;
      }
      
      public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         if(!param1)
         {
            throw new ArgumentError("gotoAndPlay requested an invalid frame.");
         }
         this._isPlaying = true;
         if(getIsOnStage())
         {
            this._mcAsset.gotoAndPlay(param1,param2);
         }
         else
         {
            this.addPendingTimelineCall("gotoAndPlay",[param1,param2]);
         }
      }
      
      public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         if(!param1)
         {
            throw new ArgumentError("gotoAndStop requested an invalid frame.");
         }
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.gotoAndStop(param1,param2);
         }
         else
         {
            this.addPendingTimelineCall("gotoAndStop",[param1,param2]);
         }
      }
      
      public function nextFrame() : void
      {
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.nextFrame();
         }
         else
         {
            this.addPendingTimelineCall("nextFrame");
         }
      }
      
      public function nextScene() : void
      {
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.nextScene();
         }
         else
         {
            this.addPendingTimelineCall("nextScene");
         }
      }
      
      public function play() : void
      {
         this._isPlaying = true;
         if(getIsOnStage())
         {
            this._mcAsset.play();
         }
         else
         {
            this.addPendingTimelineCall("play");
         }
      }
      
      public function prevFrame() : void
      {
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.prevFrame();
         }
         else
         {
            this.addPendingTimelineCall("prevFrame");
         }
      }
      
      public function prevScene() : void
      {
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.prevScene();
         }
         else
         {
            this.addPendingTimelineCall("prevScene");
         }
      }
      
      public function stop() : void
      {
         this._isPlaying = false;
         if(getIsOnStage())
         {
            this._mcAsset.stop();
         }
         else
         {
            this.addPendingTimelineCall("stop");
         }
      }
      
      protected function addPendingTimelineCall(param1:String, param2:Array = null) : void
      {
         this.pendingTimelineCalls[this.pendingTimelineCalls.length] = new PendingCall(param1,param2);
      }
      
      override public function destroy() : void
      {
         this.pendingTimelineCalls.length = 0;
         super.destroy();
      }
   }
}

