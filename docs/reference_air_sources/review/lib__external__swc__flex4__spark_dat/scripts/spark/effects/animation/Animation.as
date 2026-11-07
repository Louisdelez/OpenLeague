package spark.effects.animation
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import mx.events.EffectEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Linear;
   import spark.effects.easing.Sine;
   import spark.effects.interpolation.IInterpolator;
   
   [ResourceBundle("sparkEffects")]
   [DefaultProperty("motionPaths")]
   public final class Animation
   {
      
      private static var linearEaser:IEaser;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const TIMER_RESOLUTION:Number = 1000 / 60;
      
      private static var intervalTime:Number = NaN;
      
      private static var activeAnimations:Vector.<Animation> = new Vector.<Animation>();
      
      private static var timer:Timer = null;
      
      private static var defaultEaser:IEaser = new Sine(0.5);
      
      private static var delayedStartAnims:Vector.<Animation> = new Vector.<Animation>();
      
      private static var delayedStartTimes:Dictionary = new Dictionary();
      
      private var id:int = -1;
      
      private var _doSeek:Boolean = false;
      
      private var _isPlaying:Boolean = false;
      
      private var _doReverse:Boolean = false;
      
      private var _invertValues:Boolean = false;
      
      private var startTime:Number;
      
      private var started:Boolean = false;
      
      private var cycleStartTime:Number;
      
      private var delayTime:Number = -1;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public var currentValue:Object;
      
      public var motionPaths:Vector.<MotionPath>;
      
      private var _animationTarget:IAnimationTarget = null;
      
      private var _playheadTime:Number;
      
      [Inspectable(minValue="0.0")]
      public var duration:Number = 500;
      
      private var _repeatBehavior:String = RepeatBehavior.LOOP;
      
      private var _repeatCount:int = 1;
      
      private var _repeatDelay:Number = 0;
      
      private var _startDelay:Number = 0;
      
      public var interpolator:IInterpolator = null;
      
      private var _cycleTime:Number = 0;
      
      private var _cycleFraction:Number;
      
      private var _easer:IEaser = defaultEaser;
      
      private var _playReversed:Boolean;
      
      public function Animation(duration:Number = 500, property:String = null, startValue:Object = null, endValue:Object = null)
      {
         super();
         this.duration = duration;
         if(property != null && (startValue !== null || endValue !== null))
         {
            this.motionPaths = new <MotionPath>[new MotionPath(property)];
            this.motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,startValue),new Keyframe(duration,endValue)];
         }
      }
      
      private static function addAnimation(animation:Animation) : void
      {
         var i:int = 0;
         if(Boolean(animation.motionPaths && animation.motionPaths.length > 0) && Boolean(animation.motionPaths[0]) && (animation.motionPaths[0].property == "width" || animation.motionPaths[0].property == "height"))
         {
            activeAnimations.splice(0,0,animation);
            animation.id = 0;
            for(i = 1; i < activeAnimations.length; i++)
            {
               Animation(activeAnimations[i]).id = i;
            }
         }
         else
         {
            animation.id = activeAnimations.length;
            activeAnimations.push(animation);
         }
         if(!timer)
         {
            Timeline.pulse();
            timer = new Timer(TIMER_RESOLUTION);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
            timer.start();
         }
         intervalTime = Timeline.currentTime;
         animation.cycleStartTime = intervalTime;
      }
      
      private static function removeAnimationAt(index:int) : void
      {
         var n:int = 0;
         var i:int = 0;
         var curAnimation:Animation = null;
         if(index >= 0 && index < activeAnimations.length)
         {
            activeAnimations.splice(index,1);
            n = int(activeAnimations.length);
            for(i = index; i < n; i++)
            {
               curAnimation = Animation(activeAnimations[i]);
               --curAnimation.id;
            }
         }
         stopTimerIfDone();
      }
      
      private static function removeAnimation(animation:Animation) : void
      {
         removeAnimationAt(animation.id);
      }
      
      private static function timerHandler(event:TimerEvent) : void
      {
         var incrementIndex:Boolean = false;
         var animation:Animation = null;
         var anim:Animation = null;
         var animStartTime:Number = NaN;
         var oldTime:Number = intervalTime;
         intervalTime = Timeline.pulse();
         var n:int = int(activeAnimations.length);
         var i:int = 0;
         while(i < activeAnimations.length)
         {
            incrementIndex = true;
            animation = Animation(activeAnimations[i]);
            if(Boolean(animation))
            {
               incrementIndex = !animation.doInterval();
            }
            if(incrementIndex)
            {
               i++;
            }
         }
         while(delayedStartAnims.length > 0)
         {
            anim = Animation(delayedStartAnims[0]);
            animStartTime = Number(delayedStartTimes[anim]);
            if(animStartTime >= Timeline.currentTime)
            {
               break;
            }
            if(anim.playReversed)
            {
               anim.end();
            }
            else
            {
               anim.start();
            }
         }
         event.updateAfterEvent();
      }
      
      private static function stopTimerIfDone() : void
      {
         if(Boolean(timer) && Boolean(activeAnimations.length == 0) && delayedStartAnims.length == 0)
         {
            intervalTime = NaN;
            timer.reset();
            timer = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function pulse() : void
      {
         if(Boolean(timer))
         {
            Timeline.pulse();
         }
      }
      
      public function get animationTarget() : IAnimationTarget
      {
         return this._animationTarget;
      }
      
      public function set animationTarget(value:IAnimationTarget) : void
      {
         this._animationTarget = value;
      }
      
      [Inspectable(minValue="0.0")]
      public function get playheadTime() : Number
      {
         return this._playheadTime + this.startDelay;
      }
      
      public function set playheadTime(value:Number) : void
      {
         this.seek(value,true);
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get repeatBehavior() : String
      {
         return this._repeatBehavior;
      }
      
      public function set repeatBehavior(value:String) : void
      {
         this._repeatBehavior = value;
      }
      
      [Inspectable(minValue="0")]
      public function set repeatCount(value:int) : void
      {
         this._repeatCount = value;
      }
      
      public function get repeatCount() : int
      {
         return this._repeatCount;
      }
      
      [Inspectable(minValue="0.0")]
      public function set repeatDelay(value:Number) : void
      {
         this._repeatDelay = value;
      }
      
      public function get repeatDelay() : Number
      {
         return this._repeatDelay;
      }
      
      [Inspectable(minValue="0.0")]
      public function set startDelay(value:Number) : void
      {
         this._startDelay = value;
      }
      
      public function get startDelay() : Number
      {
         return this._startDelay;
      }
      
      public function get cycleTime() : Number
      {
         return this._cycleTime;
      }
      
      public function get cycleFraction() : Number
      {
         return this._cycleFraction;
      }
      
      public function get easer() : IEaser
      {
         return this._easer;
      }
      
      public function set easer(value:IEaser) : void
      {
         if(!value)
         {
            if(!linearEaser)
            {
               linearEaser = new Linear();
            }
            value = linearEaser;
         }
         this._easer = value;
      }
      
      public function get playReversed() : Boolean
      {
         return this._playReversed;
      }
      
      public function set playReversed(value:Boolean) : void
      {
         if(this._isPlaying)
         {
            if(this._invertValues != value)
            {
               this._invertValues = value;
               this.seek(this.duration - this._cycleTime,true);
            }
         }
         this._doReverse = value;
         this._playReversed = value;
      }
      
      private function doInterval() : Boolean
      {
         var currentTime:Number = NaN;
         var numRepeats:int = 0;
         var delayTimer:Timer = null;
         var animationEnded:Boolean = false;
         var repeated:Boolean = false;
         if(this._isPlaying || this._doSeek)
         {
            currentTime = intervalTime - this.cycleStartTime;
            this._playheadTime = intervalTime - this.startTime;
            if(currentTime >= this.duration)
            {
               numRepeats = 2;
               if(this.duration + this.repeatDelay > 0)
               {
                  numRepeats += (this._playheadTime - this.duration) / (this.duration + this.repeatDelay);
               }
               if(this.repeatCount == 0 || numRepeats <= this.repeatCount)
               {
                  if(this.repeatDelay != 0)
                  {
                     if(this._doSeek)
                     {
                        this._cycleTime = currentTime % (this.duration + this.repeatDelay);
                        if(this._cycleTime > this.duration)
                        {
                           this._cycleTime = this.duration;
                        }
                        this.calculateValue(this._cycleTime);
                        this.sendUpdateEvent();
                        return false;
                     }
                     this._cycleTime = this.duration;
                     this.calculateValue(this._cycleTime);
                     this.sendUpdateEvent();
                     removeAnimation(this);
                     delayTimer = new Timer(this.repeatDelay,1);
                     delayTimer.addEventListener(TimerEvent.TIMER,this.repeat);
                     delayTimer.start();
                     return false;
                  }
                  this._cycleTime = currentTime % this.duration;
                  this.cycleStartTime = intervalTime - this._cycleTime;
                  currentTime = this._cycleTime;
                  if(this.repeatBehavior == RepeatBehavior.REVERSE)
                  {
                     this._invertValues = !this._invertValues;
                  }
                  repeated = true;
               }
               else if(currentTime > this.duration)
               {
                  currentTime = this.duration;
                  this._playheadTime = this.duration;
               }
            }
            this._cycleTime = currentTime;
            this.calculateValue(currentTime);
            if(currentTime >= this.duration && !this._doSeek)
            {
               if(!this.playReversed || this.startDelay == 0)
               {
                  this.end();
                  animationEnded = true;
               }
               else
               {
                  this.stopAnimation();
                  this.addToDelayedAnimations(this.startDelay);
               }
            }
            else
            {
               if(repeated)
               {
                  this.sendAnimationEvent(EffectEvent.EFFECT_REPEAT);
               }
               this.sendUpdateEvent();
            }
         }
         return animationEnded;
      }
      
      private function sendUpdateEvent() : void
      {
         if(Boolean(this._animationTarget))
         {
            this._animationTarget.animationUpdate(this);
         }
      }
      
      private function sendAnimationEvent(eventType:String) : void
      {
         if(Boolean(this._animationTarget))
         {
            switch(eventType)
            {
               case EffectEvent.EFFECT_START:
                  this._animationTarget.animationStart(this);
                  break;
               case EffectEvent.EFFECT_END:
                  this._animationTarget.animationEnd(this);
                  break;
               case EffectEvent.EFFECT_STOP:
                  this._animationTarget.animationStop(this);
                  break;
               case EffectEvent.EFFECT_REPEAT:
                  this._animationTarget.animationRepeat(this);
                  break;
               case EffectEvent.EFFECT_UPDATE:
                  this._animationTarget.animationUpdate(this);
            }
         }
      }
      
      private function calculateValue(currentTime:Number) : void
      {
         var i:int = 0;
         this.currentValue = new Object();
         if(this.duration == 0)
         {
            for(i = 0; i < this.motionPaths.length; i++)
            {
               this.currentValue[this.motionPaths[i].property] = this._invertValues ? this.motionPaths[i].keyframes[0].value : this.motionPaths[i].keyframes[this.motionPaths[i].keyframes.length - 1].value;
            }
            return;
         }
         if(this._invertValues)
         {
            currentTime = this.duration - currentTime;
         }
         this._cycleFraction = this.easer.ease(currentTime / this.duration);
         if(Boolean(this.motionPaths))
         {
            for(i = 0; i < this.motionPaths.length; i++)
            {
               this.currentValue[this.motionPaths[i].property] = this.motionPaths[i].getValue(this._cycleFraction);
            }
         }
      }
      
      private function removeFromDelayedAnimations() : void
      {
         var animPendingTime:int = 0;
         var i:int = 0;
         if(Boolean(delayedStartTimes[this]))
         {
            animPendingTime = int(delayedStartTimes[this]);
            for(i = 0; i < delayedStartAnims.length; i++)
            {
               if(delayedStartAnims[i] == this)
               {
                  delayedStartAnims.splice(i,1);
                  break;
               }
            }
            delete delayedStartTimes[this];
         }
      }
      
      public function end() : void
      {
         var i:int = 0;
         if(this.startDelay > 0 && delayedStartAnims.length > 0)
         {
            for(i = 0; i < delayedStartAnims.length; i++)
            {
               if(this == delayedStartAnims[i])
               {
                  delete delayedStartTimes[this];
                  delayedStartAnims.splice(i,1);
                  break;
               }
            }
         }
         if(!this.started)
         {
            this.sendAnimationEvent(EffectEvent.EFFECT_START);
         }
         if(this.repeatCount > 1 && this.repeatBehavior == "reverse" && this.repeatCount % 2 == 0)
         {
            this._invertValues = true;
         }
         if(!(this._doReverse && this.startDelay > 0))
         {
            this.calculateValue(this.duration);
            this.sendUpdateEvent();
         }
         this.sendAnimationEvent(EffectEvent.EFFECT_END);
         if(this.isPlaying)
         {
            this.stopAnimation();
         }
         else
         {
            stopTimerIfDone();
         }
      }
      
      private function addToDelayedAnimations(timeToDelay:Number) : void
      {
         var timeAtIndex:int = 0;
         if(!timer)
         {
            Timeline.pulse();
            timer = new Timer(TIMER_RESOLUTION);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
            timer.start();
         }
         var animStartTime:int = Timeline.currentTime + timeToDelay;
         var insertIndex:int = -1;
         for(var i:int = 0; i < delayedStartAnims.length; i++)
         {
            timeAtIndex = int(delayedStartTimes[delayedStartAnims[i]]);
            if(animStartTime < timeAtIndex)
            {
               insertIndex = i;
               break;
            }
         }
         if(insertIndex >= 0)
         {
            delayedStartAnims.splice(insertIndex,0,this);
         }
         else
         {
            delayedStartAnims.push(this);
         }
         delayedStartTimes[this] = animStartTime;
      }
      
      public function play() : void
      {
         var i:int = 0;
         var j:int = 0;
         var keyframes:Vector.<Keyframe> = null;
         var startTime:Number = NaN;
         this.stopAnimation();
         for(i = 0; i < this.motionPaths.length; i++)
         {
            keyframes = this.motionPaths[i].keyframes;
            if(isNaN(keyframes[0].time))
            {
               keyframes[0].time = 0;
            }
            else if(keyframes[0].time > 0)
            {
               startTime = keyframes[0].time;
               keyframes.splice(0,0,new Keyframe(0,null));
               keyframes.splice(1,0,new Keyframe(startTime - 1,null));
               if(this.playReversed)
               {
                  keyframes[0].value = keyframes[2].value;
                  keyframes[1].value = keyframes[2].value;
               }
            }
            for(j = 1; j < keyframes.length; j++)
            {
               if(isNaN(keyframes[j].time))
               {
                  keyframes[j].time = this.duration;
               }
            }
         }
         for(i = 0; i < this.motionPaths.length; i++)
         {
            this.motionPaths[i].scaleKeyframes(this.duration);
         }
         if(this._doReverse)
         {
            this._invertValues = true;
         }
         if(this.startDelay > 0 && !this.playReversed)
         {
            this.addToDelayedAnimations(this.startDelay);
         }
         else
         {
            this.start();
         }
      }
      
      private function seek(playheadTime:Number, includeStartDelay:Boolean = false) : void
      {
         var isPlayingTmp:Boolean = false;
         var animPendingTime:int = 0;
         var i:int = 0;
         var postDelaySeekTime:Number = NaN;
         var insertIndex:int = 0;
         this.startTime = this.cycleStartTime = intervalTime - playheadTime;
         this._doSeek = true;
         if(!this._isPlaying || this.playReversed)
         {
            isPlayingTmp = this._isPlaying;
            intervalTime = Timeline.currentTime;
            if(includeStartDelay && this.startDelay > 0)
            {
               if(Boolean(delayedStartTimes[this]))
               {
                  animPendingTime = int(delayedStartTimes[this]);
                  for(i = 0; i < delayedStartAnims.length; i++)
                  {
                     if(delayedStartAnims[i] == this)
                     {
                        delayedStartAnims.splice(i,1);
                        break;
                     }
                  }
                  delete delayedStartTimes[this];
                  postDelaySeekTime = playheadTime - this.startDelay;
                  if(this.playReversed)
                  {
                     postDelaySeekTime -= this.duration;
                  }
                  if(postDelaySeekTime < 0)
                  {
                     animPendingTime = intervalTime + (this.startDelay - playheadTime);
                     insertIndex = -1;
                     for(i = 0; i < delayedStartAnims.length; i++)
                     {
                        if(animPendingTime < delayedStartTimes[delayedStartAnims[i]])
                        {
                           insertIndex = i;
                           break;
                        }
                     }
                     if(insertIndex >= 0)
                     {
                        delayedStartAnims.splice(insertIndex,0,this);
                     }
                     else
                     {
                        delayedStartAnims.push(this);
                     }
                     delayedStartTimes[this] = animPendingTime;
                     return;
                  }
                  playheadTime -= this.startDelay;
                  if(!this.isPlaying)
                  {
                     this.start();
                  }
                  this.startTime = this.cycleStartTime = intervalTime - playheadTime;
                  this.doInterval();
                  this._doSeek = false;
                  return;
               }
            }
            if(!isPlayingTmp)
            {
               this.sendAnimationEvent(EffectEvent.EFFECT_START);
               this.setupInterpolation();
            }
            this.startTime = this.cycleStartTime = intervalTime - playheadTime;
         }
         this.doInterval();
         this._doSeek = false;
      }
      
      private function setupInterpolation() : void
      {
         var i:int = 0;
         if(Boolean(this.interpolator) && Boolean(this.motionPaths))
         {
            for(i = 0; i < this.motionPaths.length; i++)
            {
               this.motionPaths[i].interpolator = this.interpolator;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function reverse() : void
      {
         if(this._isPlaying)
         {
            this._doReverse = false;
            this.seek(this.duration - this._cycleTime);
            this._invertValues = !this._invertValues;
         }
         else
         {
            this._doReverse = !this._doReverse;
         }
      }
      
      public function pause() : void
      {
         var animPendingTime:Number = Number(delayedStartTimes[this]);
         if(!isNaN(animPendingTime))
         {
            this.delayTime = animPendingTime - Timeline.currentTime;
            this.removeFromDelayedAnimations();
         }
         this._isPlaying = false;
      }
      
      private function stopAnimation() : void
      {
         this.removeFromDelayedAnimations();
         if(this.id >= 0)
         {
            Animation.removeAnimationAt(this.id);
            this.id = -1;
            this._invertValues = false;
            this._isPlaying = false;
         }
      }
      
      public function stop() : void
      {
         this.stopAnimation();
         this.sendAnimationEvent(EffectEvent.EFFECT_STOP);
      }
      
      public function resume() : void
      {
         this._isPlaying = true;
         if(this.delayTime >= 0)
         {
            this.addToDelayedAnimations(this.delayTime);
         }
         else
         {
            this.cycleStartTime = intervalTime - this._cycleTime;
            this.startTime = intervalTime - this._playheadTime;
            if(this._doReverse)
            {
               this.reverse();
               this._doReverse = false;
            }
         }
      }
      
      private function repeat(event:TimerEvent = null) : void
      {
         if(this.repeatBehavior == RepeatBehavior.REVERSE)
         {
            this._invertValues = !this._invertValues;
         }
         this.calculateValue(0);
         this.sendAnimationEvent(EffectEvent.EFFECT_REPEAT);
         this.sendUpdateEvent();
         Animation.addAnimation(this);
      }
      
      private function start(event:TimerEvent = null) : void
      {
         var i:int = 0;
         var animStartTime:int = 0;
         var overrun:int = 0;
         var actualStartTime:int = 0;
         if(!this.playReversed)
         {
            for(i = 0; i < delayedStartAnims.length; i++)
            {
               if(this == delayedStartAnims[i])
               {
                  animStartTime = int(delayedStartTimes[this]);
                  overrun = Timeline.currentTime - animStartTime;
                  if(overrun > 0)
                  {
                     actualStartTime = Math.min(overrun,this.duration);
                  }
                  delete delayedStartTimes[this];
                  delayedStartAnims.splice(i,1);
                  break;
               }
            }
         }
         this.sendAnimationEvent(EffectEvent.EFFECT_START);
         this.setupInterpolation();
         this.calculateValue(0);
         this.sendUpdateEvent();
         Animation.addAnimation(this);
         this.startTime = this.cycleStartTime;
         this._isPlaying = true;
         if(actualStartTime > 0)
         {
            this.seek(actualStartTime);
         }
         this.started = true;
      }
   }
}

