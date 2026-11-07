package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.Tween;
   
   use namespace mx_internal;
   
   public class SoundEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var origVolume:Number;
      
      private var origPan:Number;
      
      private var volumeTween:Tween;
      
      private var panTween:Tween;
      
      private var soundDuration:Number;
      
      private var tweenCount:int = 0;
      
      private var intervalID:Number;
      
      private var endOnTweens:Boolean = false;
      
      private var pausedPosition:Number;
      
      private var resumedPosition:Number = 0;
      
      private var pausedTransform:SoundTransform;
      
      public var bufferTime:Number = 1000;
      
      public var loops:int = 0;
      
      public var panEasingFunction:Function;
      
      public var panFrom:Number;
      
      public var panTo:Number;
      
      private var _soundChannel:SoundChannel;
      
      public var sound:Sound;
      
      private var _source:Object;
      
      public var startTime:Number = 0;
      
      public var useDuration:Boolean = true;
      
      public var volumeEasingFunction:Function;
      
      public var volumeFrom:Number;
      
      public var volumeTo:Number;
      
      public function SoundEffectInstance(target:Object)
      {
         super(target);
      }
      
      private function get totalDuration() : Number
      {
         var multiplier:int = 0;
         if(this.useDuration)
         {
            return duration;
         }
         if(this.sound == null)
         {
            return 0;
         }
         multiplier = this.loops + 1;
         return this.sound.length * multiplier;
      }
      
      public function get isLoading() : Boolean
      {
         if(!this.sound)
         {
            return false;
         }
         return this.source is Class || this.sound.bytesTotal > 0;
      }
      
      public function get soundChannel() : SoundChannel
      {
         return this._soundChannel;
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         this._source = value;
      }
      
      override public function play() : void
      {
         var timer:Timer = null;
         super.play();
         if(!this.sound)
         {
            return;
         }
         var transform:SoundTransform = new SoundTransform();
         if(!isNaN(this.volumeFrom) || !isNaN(this.volumeTo))
         {
            if(isNaN(this.volumeFrom))
            {
               this.volumeFrom = 1;
            }
            else if(isNaN(this.volumeTo))
            {
               this.volumeTo = 1;
            }
            transform.volume = this.volumeFrom;
            this.volumeTween = new Tween(this,this.volumeFrom,this.volumeTo,this.totalDuration);
            if(this.volumeEasingFunction != null)
            {
               this.volumeTween.easingFunction = this.volumeEasingFunction;
            }
            this.volumeTween.setTweenHandlers(this.onVolumeTweenUpdate,this.onVolumeTweenEnd);
            ++this.tweenCount;
         }
         if(!isNaN(this.panFrom) || !isNaN(this.panTo))
         {
            if(isNaN(this.panFrom))
            {
               this.panFrom = 0;
            }
            else if(isNaN(this.panTo))
            {
               this.panTo = 0;
            }
            transform.pan = this.panFrom;
            this.panTween = new Tween(this,this.panFrom,this.panTo,this.totalDuration);
            if(this.panEasingFunction != null)
            {
               this.panTween.easingFunction = this.panEasingFunction;
            }
            this.panTween.setTweenHandlers(this.onPanTweenUpdate,this.onPanTweenEnd);
            ++this.tweenCount;
         }
         this.endOnTweens = this.tweenCount > 0;
         if(this.useDuration && !this.endOnTweens)
         {
            timer = new Timer(this.totalDuration,1);
            timer.addEventListener(TimerEvent.TIMER,this.durationEndHandler);
            timer.start();
         }
         this.pausedPosition = NaN;
         this.resumedPosition = this.startTime;
         this._soundChannel = this.sound.play(this.startTime,this.loops,transform);
         if(Boolean(this.soundChannel))
         {
            this.soundChannel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
         }
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(this.volumeTween))
         {
            this.volumeTween.pause();
         }
         if(Boolean(this.panTween))
         {
            this.panTween.pause();
         }
         if(Boolean(this.soundChannel))
         {
            this.pausedPosition = this.soundChannel.position;
            this.pausedTransform = this.soundChannel.soundTransform;
            this.soundChannel.stop();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(this.volumeTween))
         {
            this.volumeTween.stop();
         }
         if(Boolean(this.panTween))
         {
            this.panTween.stop();
         }
         if(Boolean(this.soundChannel))
         {
            this.soundChannel.stop();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(this.volumeTween))
         {
            this.volumeTween.resume();
         }
         if(Boolean(this.panTween))
         {
            this.panTween.resume();
         }
         this.resumedPosition += this.pausedPosition;
         if(Boolean(this.sound))
         {
            this._soundChannel = this.sound.play(this.resumedPosition,this.loops,this.pausedTransform);
            if(Boolean(this.soundChannel))
            {
               this.soundChannel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
            }
         }
      }
      
      override public function end() : void
      {
         super.end();
         this.pausedPosition = NaN;
         this.resumedPosition = this.startTime;
         if(Boolean(this.volumeTween))
         {
            this.volumeTween.endTween();
         }
         if(Boolean(this.panTween))
         {
            this.panTween.endTween();
         }
      }
      
      override public function finishEffect() : void
      {
         if(Boolean(this.soundChannel))
         {
            this.soundChannel.stop();
         }
         super.finishEffect();
      }
      
      mx_internal function onVolumeTweenUpdate(value:Object) : void
      {
         var copyTransform:SoundTransform = null;
         if(Boolean(this.soundChannel))
         {
            copyTransform = this.soundChannel.soundTransform;
            copyTransform.volume = Number(value);
            this.soundChannel.soundTransform = copyTransform;
         }
      }
      
      mx_internal function onVolumeTweenEnd(value:Object) : void
      {
         this.onVolumeTweenUpdate(value);
         this.finishTween();
      }
      
      mx_internal function onPanTweenUpdate(value:Object) : void
      {
         var copyTransform:SoundTransform = null;
         if(Boolean(this.soundChannel))
         {
            copyTransform = this.soundChannel.soundTransform;
            copyTransform.pan = Number(value);
            this.soundChannel.soundTransform = copyTransform;
         }
      }
      
      mx_internal function onPanTweenEnd(value:Object) : void
      {
         this.onPanTweenUpdate(value);
         this.finishTween();
      }
      
      private function finishTween() : void
      {
         if(this.tweenCount == 0 || --this.tweenCount == 0)
         {
            if(Boolean(this.soundChannel))
            {
               this.soundChannel.stop();
            }
            finishRepeat();
         }
      }
      
      private function durationEndHandler(event:TimerEvent) : void
      {
         this.finishTween();
      }
      
      private function soundCompleteHandler(event:Event) : void
      {
         dispatchEvent(event);
         if(!this.useDuration && !this.endOnTweens)
         {
            this.finishTween();
         }
      }
   }
}

