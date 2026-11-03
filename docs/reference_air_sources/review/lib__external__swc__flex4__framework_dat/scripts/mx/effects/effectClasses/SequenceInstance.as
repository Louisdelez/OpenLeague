package mx.effects.effectClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Sequence;
   import mx.effects.Tween;
   
   use namespace mx_internal;
   
   public class SequenceInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var activeChildCount:Number;
      
      private var currentInstanceDuration:Number = 0;
      
      private var currentSet:Array;
      
      private var currentSetIndex:int = -1;
      
      private var startTime:Number = 0;
      
      private var isPaused:Boolean = false;
      
      public function SequenceInstance(target:Object)
      {
         super(target);
      }
      
      override mx_internal function get durationWithoutRepeat() : Number
      {
         var instances:Array = null;
         var _duration:Number = 0;
         var n:int = int(childSets.length);
         for(var i:int = 0; i < n; i++)
         {
            instances = childSets[i];
            _duration += instances[0].actualDuration;
         }
         return _duration;
      }
      
      override public function set playheadTime(value:Number) : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var l:int = 0;
         var iterationPlayheadTime:Number = NaN;
         var valueAfterFirstCycle:Number = NaN;
         var cumulativeDuration:Number = NaN;
         var activeLength:Number = NaN;
         var setToCompare:int = 0;
         var childEffectInstances:Array = null;
         var startTime:Number = NaN;
         var endTime:Number = NaN;
         var currentEffectInstances:Array = null;
         var prevPlayheadTime:Number = playheadTime;
         super.playheadTime = value;
         var compositeDur:Number = Sequence(effect).compositeDuration;
         var firstCycleDur:Number = compositeDur + startDelay + repeatDelay;
         var laterCycleDur:Number = compositeDur + repeatDelay;
         var totalDur:Number = firstCycleDur + laterCycleDur * (repeatCount - 1);
         if(value <= firstCycleDur)
         {
            iterationPlayheadTime = Math.min(value - startDelay,compositeDur);
            playCount = 1;
         }
         else if(value >= totalDur && repeatCount != 0)
         {
            iterationPlayheadTime = compositeDur;
            playCount = repeatCount;
         }
         else
         {
            valueAfterFirstCycle = value - firstCycleDur;
            iterationPlayheadTime = valueAfterFirstCycle % laterCycleDur;
            iterationPlayheadTime = Math.min(iterationPlayheadTime,compositeDur);
            playCount = 1 + valueAfterFirstCycle / laterCycleDur;
         }
         if(Boolean(activeEffectQueue) && activeEffectQueue.length > 0)
         {
            cumulativeDuration = 0;
            activeLength = activeEffectQueue.length;
            for(i = 0; i < activeLength; i++)
            {
               setToCompare = playReversed ? int(activeLength - 1 - i) : i;
               startTime = cumulativeDuration;
               endTime = cumulativeDuration + childSets[setToCompare][0].actualDuration;
               cumulativeDuration = endTime;
               if(startTime <= iterationPlayheadTime && iterationPlayheadTime <= endTime)
               {
                  endEffectCalled = true;
                  if(this.currentSetIndex == setToCompare)
                  {
                     for(j = 0; j < this.currentSet.length; j++)
                     {
                        this.currentSet[j].playheadTime = iterationPlayheadTime - startTime;
                     }
                  }
                  else if(setToCompare < this.currentSetIndex)
                  {
                     if(playReversed)
                     {
                        for(j = 0; j < this.currentSet.length; j++)
                        {
                           this.currentSet[j].end();
                        }
                        for(j = this.currentSetIndex - 1; j > setToCompare; j--)
                        {
                           childEffectInstances = activeEffectQueue[j];
                           for(k = 0; k < childEffectInstances.length; k++)
                           {
                              if(playReversed)
                              {
                                 childEffectInstances[k].playReversed = true;
                              }
                              childEffectInstances[k].play();
                              childEffectInstances[k].end();
                           }
                        }
                     }
                     else
                     {
                        for(j = 0; j < this.currentSet.length; j++)
                        {
                           this.currentSet[j].playheadTime = 0;
                           this.currentSet[j].stop();
                        }
                        for(j = this.currentSetIndex - 1; j > setToCompare; j--)
                        {
                           childEffectInstances = activeEffectQueue[j];
                           for(k = 0; k < childEffectInstances.length; k++)
                           {
                              childEffectInstances[k].play();
                              childEffectInstances[k].stop();
                           }
                        }
                     }
                     this.currentSetIndex = setToCompare;
                     this.playCurrentChildSet();
                     for(k = 0; k < this.currentSet.length; k++)
                     {
                        this.currentSet[k].playheadTime = iterationPlayheadTime - startTime;
                        if(this.isPaused)
                        {
                           this.currentSet[k].pause();
                        }
                     }
                  }
                  else
                  {
                     if(playReversed)
                     {
                        for(j = 0; j < this.currentSet.length; j++)
                        {
                           this.currentSet[j].playheadTime = 0;
                           this.currentSet[j].stop();
                        }
                        for(k = this.currentSetIndex + 1; k < setToCompare; k++)
                        {
                           childEffectInstances = activeEffectQueue[k];
                           for(l = 0; l < childEffectInstances.length; l++)
                           {
                              childEffectInstances[l].playheadTime = 0;
                              childEffectInstances[l].stop();
                           }
                        }
                     }
                     else
                     {
                        currentEffectInstances = this.currentSet.concat();
                        for(j = 0; j < currentEffectInstances.length; j++)
                        {
                           currentEffectInstances[j].end();
                        }
                        for(k = this.currentSetIndex + 1; k < setToCompare; k++)
                        {
                           childEffectInstances = activeEffectQueue[k];
                           for(l = 0; l < childEffectInstances.length; l++)
                           {
                              childEffectInstances[l].play();
                              childEffectInstances[l].end();
                           }
                        }
                     }
                     this.currentSetIndex = setToCompare;
                     this.playCurrentChildSet();
                     for(k = 0; k < this.currentSet.length; k++)
                     {
                        this.currentSet[k].playheadTime = iterationPlayheadTime - startTime;
                        if(this.isPaused)
                        {
                           this.currentSet[k].pause();
                        }
                     }
                  }
                  endEffectCalled = false;
                  break;
               }
            }
         }
      }
      
      override public function play() : void
      {
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var instances:Array = null;
         this.isPaused = false;
         activeEffectQueue = [];
         this.currentSetIndex = playReversed ? int(childSets.length) : -1;
         n = int(childSets.length);
         for(i = 0; i < n; i++)
         {
            instances = childSets[i];
            activeEffectQueue.push(instances);
         }
         super.play();
         this.startTime = Tween.intervalTime;
         if(activeEffectQueue.length == 0)
         {
            finishRepeat();
            return;
         }
         this.playNextChildSet();
      }
      
      override public function pause() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.pause();
         this.isPaused = true;
         if(Boolean(this.currentSet) && this.currentSet.length > 0)
         {
            n = int(this.currentSet.length);
            for(i = 0; i < n; i++)
            {
               this.currentSet[i].pause();
            }
         }
      }
      
      override public function stop() : void
      {
         var queueCopy:Array = null;
         var currentInstances:Array = null;
         var n:int = 0;
         var j:int = 0;
         var currentCount:int = 0;
         var i:int = 0;
         var waitingInstances:Array = null;
         var m:int = 0;
         var k:int = 0;
         var instance:IEffectInstance = null;
         this.isPaused = false;
         if(Boolean(activeEffectQueue) && activeEffectQueue.length > 0)
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            currentInstances = queueCopy[this.currentSetIndex];
            if(Boolean(currentInstances))
            {
               currentCount = int(currentInstances.length);
               for(i = 0; i < currentCount; i++)
               {
                  currentInstances[i].stop();
               }
            }
            n = int(queueCopy.length);
            for(j = this.currentSetIndex + 1; j < n; j++)
            {
               waitingInstances = queueCopy[j];
               m = int(waitingInstances.length);
               for(k = 0; k < m; k++)
               {
                  instance = waitingInstances[k];
                  instance.effect.deleteInstance(instance);
               }
            }
         }
         super.stop();
      }
      
      override public function resume() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.resume();
         this.isPaused = false;
         if(Boolean(this.currentSet) && this.currentSet.length > 0)
         {
            n = int(this.currentSet.length);
            for(i = 0; i < n; i++)
            {
               this.currentSet[i].resume();
            }
         }
      }
      
      override public function reverse() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.reverse();
         if(Boolean(this.currentSet) && this.currentSet.length > 0)
         {
            n = int(this.currentSet.length);
            for(i = 0; i < n; i++)
            {
               this.currentSet[i].reverse();
            }
         }
      }
      
      override public function end() : void
      {
         var queueCopy:Array = null;
         var currentInstances:Array = null;
         var n:int = 0;
         var j:int = 0;
         var currentCount:int = 0;
         var i:int = 0;
         var waitingInstances:Array = null;
         var m:int = 0;
         var k:int = 0;
         endEffectCalled = true;
         if(Boolean(activeEffectQueue) && activeEffectQueue.length > 0)
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            currentInstances = queueCopy[this.currentSetIndex];
            if(Boolean(currentInstances))
            {
               currentCount = int(currentInstances.length);
               for(i = 0; i < currentCount; i++)
               {
                  currentInstances[i].end();
               }
            }
            n = int(queueCopy.length);
            for(j = this.currentSetIndex + 1; j < n; j++)
            {
               waitingInstances = queueCopy[j];
               m = int(waitingInstances.length);
               for(k = 0; k < m; k++)
               {
                  EffectInstance(waitingInstances[k]).playWithNoDuration();
               }
            }
         }
         this.isPaused = false;
         super.end();
      }
      
      override protected function onEffectEnd(childEffect:IEffectInstance) : void
      {
         if(Boolean(Object(childEffect).suspendBackgroundProcessing))
         {
            UIComponent.resumeBackgroundProcessing();
         }
         for(var i:int = 0; i < this.currentSet.length; i++)
         {
            if(childEffect == this.currentSet[i])
            {
               this.currentSet.splice(i,1);
               break;
            }
         }
         if(endEffectCalled)
         {
            return;
         }
         if(this.currentSet.length == 0)
         {
            if(false == this.playNextChildSet())
            {
               finishRepeat();
            }
         }
      }
      
      private function playCurrentChildSet() : void
      {
         var childEffect:EffectInstance = null;
         var instances:Array = activeEffectQueue[this.currentSetIndex];
         this.currentSet = [];
         for(var i:int = 0; i < instances.length; i++)
         {
            childEffect = instances[i];
            this.currentSet.push(childEffect);
            childEffect.playReversed = playReversed;
            if(childEffect.suspendBackgroundProcessing)
            {
               UIComponent.suspendBackgroundProcessing();
            }
            childEffect.startEffect();
         }
         this.currentInstanceDuration += childEffect.actualDuration;
      }
      
      private function playNextChildSet(offset:Number = 0) : Boolean
      {
         if(!playReversed)
         {
            if(!activeEffectQueue || this.currentSetIndex++ >= activeEffectQueue.length - 1)
            {
               return false;
            }
         }
         else if(this.currentSetIndex-- <= 0)
         {
            return false;
         }
         this.playCurrentChildSet();
         return true;
      }
   }
}

