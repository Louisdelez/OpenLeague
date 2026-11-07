package mx.effects.effectClasses
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   
   use namespace mx_internal;
   
   public class ParallelInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var timer:Timer;
      
      private var isReversed:Boolean = false;
      
      private var replayEffectQueue:Array;
      
      private var doneEffectQueue:Array;
      
      public function ParallelInstance(target:Object)
      {
         super(target);
      }
      
      override public function stop() : void
      {
         var queueCopy:Array = null;
         var n:int = 0;
         var i:int = 0;
         stopTimer();
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
      
      private function startTimer() : void
      {
         if(!timer)
         {
            timer = new Timer(10);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
         }
         timer.start();
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
      
      private function timerHandler(event:TimerEvent) : void
      {
         var childEffect:EffectInstance = null;
         var position:Number = durationWithoutRepeat - playheadTime;
         var numDone:int = int(replayEffectQueue.length);
         if(numDone == 0)
         {
            stopTimer();
            return;
         }
         for(var i:int = numDone - 1; i >= 0; i--)
         {
            childEffect = replayEffectQueue[i];
            if(position <= childEffect.actualDuration)
            {
               activeEffectQueue.push(childEffect);
               replayEffectQueue.splice(i,1);
               childEffect.playReversed = playReversed;
               childEffect.startEffect();
            }
         }
      }
      
      private function stopTimer() : void
      {
         if(Boolean(timer))
         {
            timer.reset();
         }
      }
      
      override public function addChildSet(childSet:Array) : void
      {
         var compChild:CompositeEffectInstance = null;
         super.addChildSet(childSet);
         if(childSet.length > 0)
         {
            compChild = childSet[0] as CompositeEffectInstance;
            if(childSet[0] is RotateInstance || compChild != null && compChild.hasRotateInstance())
            {
               childSets.pop();
               childSets.unshift(childSet);
            }
         }
      }
      
      override public function reverse() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.reverse();
         if(isReversed)
         {
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].reverse();
            }
            stopTimer();
         }
         else
         {
            replayEffectQueue = doneEffectQueue.splice(0);
            n = int(activeEffectQueue.length);
            for(i = 0; i < n; i++)
            {
               activeEffectQueue[i].reverse();
            }
            startTimer();
         }
         isReversed = !isReversed;
      }
      
      override public function end() : void
      {
         var queueCopy:Array = null;
         var n:int = 0;
         var i:int = 0;
         endEffectCalled = true;
         stopTimer();
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
               doneEffectQueue.push(childEffect);
               activeEffectQueue.splice(i,1);
               break;
            }
         }
         if(n == 1)
         {
            finishRepeat();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         var n:int = int(activeEffectQueue.length);
         for(var i:int = 0; i < n; i++)
         {
            activeEffectQueue[i].resume();
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
         doneEffectQueue = [];
         activeEffectQueue = [];
         replayEffectQueue = [];
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
               if(playReversed && childEffect.actualDuration < durationWithoutRepeat)
               {
                  replayEffectQueue.push(childEffect);
                  startTimer();
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
         super.pause();
         var n:int = int(activeEffectQueue.length);
         for(var i:int = 0; i < n; i++)
         {
            activeEffectQueue[i].pause();
         }
      }
   }
}

