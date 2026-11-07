package mx.effects.effectClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   
   use namespace mx_internal;
   
   public class SequenceInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var startTime:Number = 0;
      
      private var currentInstanceDuration:Number = 0;
      
      private var currentSetIndex:int = -1;
      
      private var currentSet:Array;
      
      private var activeChildCount:Number;
      
      public function SequenceInstance(target:Object)
      {
         super(target);
      }
      
      override public function stop() : void
      {
         var queueCopy:Array = null;
         var currentInstances:Array = null;
         var currentCount:int = 0;
         var i:int = 0;
         var n:int = 0;
         var j:int = 0;
         var waitingInstances:Array = null;
         var m:int = 0;
         var k:int = 0;
         var instance:IEffectInstance = null;
         if(Boolean(activeEffectQueue) && activeEffectQueue.length > 0)
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            currentInstances = queueCopy[currentSetIndex];
            currentCount = int(currentInstances.length);
            for(i = 0; i < currentCount; i++)
            {
               currentInstances[i].stop();
            }
            n = int(queueCopy.length);
            for(j = currentSetIndex + 1; j < n; j++)
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
      
      private function playNextChildSet(offset:Number = 0) : Boolean
      {
         var childEffect:EffectInstance = null;
         if(!playReversed)
         {
            if(!activeEffectQueue || currentSetIndex++ >= activeEffectQueue.length - 1)
            {
               return false;
            }
         }
         else if(currentSetIndex-- <= 0)
         {
            return false;
         }
         var instances:Array = activeEffectQueue[currentSetIndex];
         currentSet = [];
         for(var i:int = 0; i < instances.length; i++)
         {
            childEffect = instances[i];
            currentSet.push(childEffect);
            childEffect.playReversed = playReversed;
            if(childEffect.suspendBackgroundProcessing)
            {
               UIComponent.suspendBackgroundProcessing();
            }
            childEffect.startEffect();
         }
         currentInstanceDuration += childEffect.actualDuration;
         return true;
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
      
      override public function end() : void
      {
         var queueCopy:Array = null;
         var currentInstances:Array = null;
         var currentCount:int = 0;
         var i:int = 0;
         var n:int = 0;
         var j:int = 0;
         var waitingInstances:Array = null;
         var m:int = 0;
         var k:int = 0;
         endEffectCalled = true;
         if(Boolean(activeEffectQueue) && activeEffectQueue.length > 0)
         {
            queueCopy = activeEffectQueue.concat();
            activeEffectQueue = null;
            currentInstances = queueCopy[currentSetIndex];
            currentCount = int(currentInstances.length);
            for(i = 0; i < currentCount; i++)
            {
               currentInstances[i].end();
            }
            n = int(queueCopy.length);
            for(j = currentSetIndex + 1; j < n; j++)
            {
               waitingInstances = queueCopy[j];
               m = int(waitingInstances.length);
               for(k = 0; k < m; k++)
               {
                  EffectInstance(waitingInstances[k]).playWithNoDuration();
               }
            }
         }
         super.end();
      }
      
      override public function reverse() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.reverse();
         if(Boolean(currentSet) && currentSet.length > 0)
         {
            n = int(currentSet.length);
            for(i = 0; i < n; i++)
            {
               currentSet[i].reverse();
            }
         }
      }
      
      override protected function onEffectEnd(childEffect:IEffectInstance) : void
      {
         if(Boolean(Object(childEffect).suspendBackgroundProcessing))
         {
            UIComponent.resumeBackgroundProcessing();
         }
         if(endEffectCalled)
         {
            return;
         }
         for(var i:int = 0; i < currentSet.length; i++)
         {
            if(childEffect == currentSet[i])
            {
               currentSet.splice(i,1);
               break;
            }
         }
         if(currentSet.length == 0)
         {
            if(false == playNextChildSet())
            {
               finishRepeat();
            }
         }
      }
      
      override public function resume() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.resume();
         if(Boolean(currentSet) && currentSet.length > 0)
         {
            n = int(currentSet.length);
            for(i = 0; i < n; i++)
            {
               currentSet[i].resume();
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
         activeEffectQueue = [];
         currentSetIndex = playReversed ? int(childSets.length) : -1;
         n = int(childSets.length);
         for(i = 0; i < n; i++)
         {
            instances = childSets[i];
            activeEffectQueue.push(instances);
         }
         super.play();
         startTime = Tween.intervalTime;
         if(activeEffectQueue.length == 0)
         {
            finishRepeat();
            return;
         }
         playNextChildSet();
      }
      
      override public function pause() : void
      {
         var n:int = 0;
         var i:int = 0;
         super.pause();
         if(Boolean(currentSet) && currentSet.length > 0)
         {
            n = int(currentSet.length);
            for(i = 0; i < n; i++)
            {
               currentSet[i].pause();
            }
         }
      }
   }
}

