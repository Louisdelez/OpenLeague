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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var sound:Sound;
      
      private var origPan:Number;
      
      private var intervalID:Number;
      
      private var endOnTweens:Boolean = false;
      
      private var resumedPosition:Number = 0;
      
      public var panEasingFunction:Function;
      
      public var bufferTime:Number = 1000;
      
      public var volumeTo:Number;
      
      public var useDuration:Boolean = true;
      
      private var _source:Object;
      
      private var origVolume:Number;
      
      private var soundDuration:Number;
      
      private var panTween:Tween;
      
      public var startTime:Number = 0;
      
      private var _soundChannel:SoundChannel;
      
      public var loops:int = 0;
      
      public var volumeEasingFunction:Function;
      
      private var pausedTransform:SoundTransform;
      
      private var tweenCount:int = 0;
      
      public var panFrom:Number;
      
      public var volumeFrom:Number;
      
      private var volumeTween:Tween;
      
      private var pausedPosition:Number;
      
      public var panTo:Number;
      
      public function SoundEffectInstance(target:Object)
      {
         super(target);
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(volumeTween))
         {
            volumeTween.stop();
         }
         if(Boolean(panTween))
         {
            panTween.stop();
         }
         _soundChannel.stop();
      }
      
      override public function finishEffect() : void
      {
         if(Boolean(_soundChannel))
         {
            _soundChannel.stop();
         }
         super.finishEffect();
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(volumeTween))
         {
            volumeTween.pause();
         }
         if(Boolean(panTween))
         {
            panTween.pause();
         }
         pausedPosition = _soundChannel.position;
         pausedTransform = _soundChannel.soundTransform;
         _soundChannel.stop();
      }
      
      mx_internal function onPanTweenEnd(value:Object) : void
      {
         mx_internal::onPanTweenUpdate(value);
         finishTween();
      }
      
      mx_internal function onVolumeTweenUpdate(value:Object) : void
      {
         var copyTransform:SoundTransform = _soundChannel.soundTransform;
         copyTransform.volume = Number(value);
         _soundChannel.soundTransform = copyTransform;
      }
      
      mx_internal function onPanTweenUpdate(value:Object) : void
      {
         var copyTransform:SoundTransform = _soundChannel.soundTransform;
         copyTransform.pan = Number(value);
         _soundChannel.soundTransform = copyTransform;
      }
      
      public function get source() : Object
      {
         return _source;
      }
      
      private function finishTween() : void
      {
         if(tweenCount == 0 || --tweenCount == 0)
         {
            if(Boolean(_soundChannel))
            {
               _soundChannel.stop();
            }
            finishRepeat();
         }
      }
      
      private function durationEndHandler(event:TimerEvent) : void
      {
         finishTween();
      }
      
      public function get isLoading() : Boolean
      {
         return source is Class || sound.bytesTotal > 0;
      }
      
      public function set source(value:Object) : void
      {
         _source = value;
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(volumeTween))
         {
            volumeTween.resume();
         }
         if(Boolean(panTween))
         {
            panTween.resume();
         }
         resumedPosition += pausedPosition;
         _soundChannel = sound.play(resumedPosition,loops,pausedTransform);
         _soundChannel.addEventListener("soundComplete",soundCompleteHandler);
      }
      
      private function soundCompleteHandler(event:Event) : void
      {
         dispatchEvent(event);
         if(!useDuration && !endOnTweens)
         {
            finishTween();
         }
      }
      
      override public function play() : void
      {
         var timer:Timer = null;
         super.play();
         var transform:SoundTransform = new SoundTransform();
         if(!isNaN(volumeFrom) || !isNaN(volumeTo))
         {
            if(isNaN(volumeFrom))
            {
               volumeFrom = 1;
            }
            else if(isNaN(volumeTo))
            {
               volumeTo = 1;
            }
            transform.volume = volumeFrom;
            volumeTween = new Tween(this,volumeFrom,volumeTo,totalDuration);
            if(volumeEasingFunction != null)
            {
               volumeTween.easingFunction = volumeEasingFunction;
            }
            volumeTween.setTweenHandlers(mx_internal::onVolumeTweenUpdate,mx_internal::onVolumeTweenEnd);
            ++tweenCount;
         }
         if(!isNaN(panFrom) || !isNaN(panTo))
         {
            if(isNaN(panFrom))
            {
               panFrom = 0;
            }
            else if(isNaN(panTo))
            {
               panTo = 0;
            }
            transform.pan = panFrom;
            panTween = new Tween(this,panFrom,panTo,totalDuration);
            if(panEasingFunction != null)
            {
               panTween.easingFunction = panEasingFunction;
            }
            panTween.setTweenHandlers(mx_internal::onPanTweenUpdate,mx_internal::onPanTweenEnd);
            ++tweenCount;
         }
         endOnTweens = tweenCount > 0;
         if(useDuration && !endOnTweens)
         {
            timer = new Timer(totalDuration,1);
            timer.addEventListener(TimerEvent.TIMER,durationEndHandler);
            timer.start();
         }
         pausedPosition = NaN;
         resumedPosition = startTime;
         _soundChannel = sound.play(startTime,loops,transform);
         _soundChannel.addEventListener("soundComplete",soundCompleteHandler);
      }
      
      override public function end() : void
      {
         super.end();
         pausedPosition = NaN;
         resumedPosition = startTime;
         if(Boolean(volumeTween))
         {
            volumeTween.endTween();
         }
         if(Boolean(panTween))
         {
            panTween.endTween();
         }
      }
      
      mx_internal function onVolumeTweenEnd(value:Object) : void
      {
         mx_internal::onVolumeTweenUpdate(value);
         finishTween();
      }
      
      public function get soundChannel() : SoundChannel
      {
         return _soundChannel;
      }
      
      private function get totalDuration() : Number
      {
         var multiplier:int = 0;
         if(useDuration)
         {
            return duration;
         }
         multiplier = loops + 1;
         return sound.length * multiplier;
      }
   }
}

