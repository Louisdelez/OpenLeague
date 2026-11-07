package mx.effects.effectClasses
{
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Parallel;
   
   use namespace mx_internal;
   
   public class ParallelInstance extends CompositeEffectInstance
   {
      
      private static var resizeEffectType:Class;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var resizeEffectLoaded:Boolean = false;
      
      private var doneEffectQueue:Array;
      
      private var replayEffectQueue:Array;
      
      private var isReversed:Boolean = false;
      
      private var timer:Timer;
      
      public function ParallelInstance(target:Object)
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
            _duration = Math.max(instances[0].actualDuration,_duration);
         }
         return _duration;
      }
      
      override public function set playheadTime(value:Number) : void
      {
         var childPlayheadTime:Number = NaN;
         var valueAfterFirstCycle:Number = NaN;
         var instances:Array = null;
         var m:int = 0;
         var j:int = 0;
         var position:Number = NaN;
         var numDone:int = 0;
         var childEffect:EffectInstance = null;
         super.playheadTime = value;
         var compositeDur:Number = Parallel(effect).compositeDuration;
         var firstCycleDur:Number = compositeDur + startDelay + repeatDelay;
         var laterCycleDur:Number = compositeDur + repeatDelay;
         var totalDur:Number = firstCycleDur + laterCycleDur * (repeatCount - 1);
         if(value <= firstCycleDur)
         {
            childPlayheadTime = Math.min(value - startDelay,compositeDur);
            playCount = 1;
         }
         else if(value >= totalDur && repeatCount != 0)
         {
            childPlayheadTime = compositeDur;
            playCount = repeatCount;
         }
         else
         {
            valueAfterFirstCycle = value - firstCycleDur;
            childPlayheadTime = Math.min(childPlayheadTime,compositeDur);
            childPlayheadTime = valueAfterFirstCycle % laterCycleDur;
            playCount = 1 + valueAfterFirstCycle / laterCycleDur;
         }
         for(var i:int = 0; i < childSets.length; i++)
         {
            instances = childSets[i];
            m = int(instances.length);
            for(j = 0; j < m; j++)
            {
               instances[j].playheadTime = playReversed ? Math.max(0,childPlayheadTime - (this.durationWithoutRepeat - instances[j].actualDuration)) : childPlayheadTime;
            }
         }
         if(playReversed && this.replayEffectQueue != null && this.replayEffectQueue.length > 0)
         {
            position = this.durationWithoutRepeat - playheadTime;
            numDone = int(this.replayEffectQueue.length);
            for(i = numDone - 1; i >= 0; i--)
            {
               childEffect = this.replayEffectQueue[i];
               if(position <= childEffect.actualDuration)
               {
                  if(activeEffectQueue == null)
                  {
                     activeEffectQueue = [];
                  }
                  activeEffectQueue.push(childEffect);
                  this.replayEffectQueue.splice(i,1);
                  childEffect.playReversed = playReversed;
                  childEffect.startEffect();
               }
            }
         }
      }
      
      override public function addChildSet(childSet:Array) : void
      {
         var compChild:CompositeEffectInstance = null;
         var resizeChildSet:Array = null;
         var insertionIndex:int = 0;
         var i:int = 0;
         var currentChildSet:Array = null;
         var currentChildSetComposite:CompositeEffectInstance = null;
         super.addChildSet(childSet);
         if(childSets.length > 1 && childSet.length > 0)
         {
            compChild = childSet[0] as CompositeEffectInstance;
            if(!resizeEffectLoaded)
            {
               resizeEffectLoaded = true;
               if(ApplicationDomain.currentDomain.hasDefinition("spark.effects.supportClasses.ResizeInstance"))
               {
                  resizeEffectType = Class(ApplicationDomain.currentDomain.getDefinition("spark.effects.supportClasses.ResizeInstance"));
               }
            }
            if(Boolean(resizeEffectType) && (childSet[0] is resizeEffectType || compChild != null && compChild.hasResizeInstance()))
            {
               resizeChildSet = childSets.pop();
               insertionIndex = 0;
               for(i = 0; i < childSets.length; i++)
               {
                  currentChildSet = childSets[i];
                  currentChildSetComposite = currentChildSet[0] as CompositeEffectInstance;
                  if(!(currentChildSet[0] is resizeEffectType) && (!currentChildSetComposite || !currentChildSetComposite.hasResizeInstance()))
                  {
                     break;
                  }
                  insertionIndex++;
               }
               childSets.splice(insertionIndex,0,resizeChildSet);
            }
            else if(childSet[0] is RotateInstance || compChild != null && compChild.hasRotateInstance())
            {
               childSets.unshift(childSets.pop());
            }
         }
      }
      
      override public function play() : void
      {
         var n:int = 0;
         var i:int = 0;
         var instances:Array = null;
         var m:int = 0;
         var j:int = 0;
         var childEffect:EffectInstance = null;
         var queueCopy:Array = null;
         this.doneEffectQueue = [];
         activeEffectQueue = [];
         this.replayEffectQueue = [];
         var checkQueueLength:Boolean = false;
         super.play();
         n = int(childSets.length);
         for(i = 0; i < n; i++)
         {
            instances = childSets[i];
            m = int(instances.length);
            j = 0;
            while(j < m && activeEffectQueue != null)
            {
               childEffect = instances[j];
               if(playReversed && childEffect.actualDuration < this.durationWithoutRepeat)
               {
                  this.replayEffectQueue.push(childEffect);
                  this.startTimer();
               }
               else
               {
                  childEffect.playReversed = playReversed;
                  activeEffectQueue.push(childEffect);
               }
               if(childEffect.suspendBackgroundProcessing)
               {
                  UIComponent.suspendBackgroundProcessing();
               }
               j++;
            }
         }
         if(activeEffectQueue.length > 0)
         {
            queueCopy = activeEffectQueue.slice(0);
            for(i = 0; i < queueCopy.length; i++)
            {
               queueCopy[i].startEffect();
            }
         }
      }
      
      override public function pause() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.pause();
         if(Boolean(activeEffectQueue))
         {
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].pause();
            }
         }
      }
      
      override public function stop() : void
      {
         var queueCopy:Array = null;
         var n:int = 0;
         var i:int = 0;
         this.stopTimer();
         if(Boolean(activeEffectQueue))
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            n = int(queueCopy.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(queueCopy[i]))
               {
                  queueCopy[i].stop();
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
         if(Boolean(activeEffectQueue))
         {
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].resume();
            }
         }
      }
      
      override public function reverse() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.reverse();
         if(this.isReversed)
         {
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].reverse();
            }
            this.stopTimer();
         }
         else
         {
            this.replayEffectQueue = this.doneEffectQueue.splice(0);
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].reverse();
            }
            this.startTimer();
         }
         this.isReversed = !this.isReversed;
      }
      
      override public function end() : void
      {
         var queueCopy:Array = null;
         var n:int = 0;
         var i:int = 0;
         endEffectCalled = true;
         this.stopTimer();
         if(Boolean(activeEffectQueue))
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            n = int(queueCopy.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(queueCopy[i]))
               {
                  queueCopy[i].end();
               }
            }
         }
         super.end();
      }
      
      override protected function onEffectEnd(childEffect:IEffectInstance) : void
      {
         if(Boolean(Object(childEffect).suspendBackgroundProcessing))
         {
            UIComponent.resumeBackgroundProcessing();
         }
         if(endEffectCalled || activeEffectQueue == null)
         {
            return;
         }
         var n:int = int(activeEffectQueue.length);
         for(var i:int = 0; i < n; i++)
         {
            if(childEffect == activeEffectQueue[i])
            {
               this.doneEffectQueue.push(childEffect);
               activeEffectQueue.splice(i,1);
               break;
            }
         }
         if(n == 1)
         {
            finishRepeat();
         }
      }
      
      private function startTimer() : void
      {
         if(!this.timer)
         {
            this.timer = new Timer(10);
            this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this.timer.start();
      }
      
      private function stopTimer() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.reset();
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var childEffect:EffectInstance = null;
         var position:Number = this.durationWithoutRepeat - playheadTime;
         var numDone:int = int(this.replayEffectQueue.length);
         if(numDone == 0)
         {
            this.stopTimer();
            return;
         }
         for(var i:int = numDone - 1; i >= 0; i--)
         {
            childEffect = this.replayEffectQueue[i];
            if(position <= childEffect.actualDuration)
            {
               if(activeEffectQueue == null)
               {
                  activeEffectQueue = [];
               }
               activeEffectQueue.push(childEffect);
               this.replayEffectQueue.splice(i,1);
               childEffect.playReversed = playReversed;
               childEffect.startEffect();
            }
         }
      }
   }
}

