package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   import mx.events.EffectEvent;
   
   use namespace mx_internal;
   
   public class CompositeEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var childSets:Array = [];
      
      mx_internal var activeEffectQueue:Array = [];
      
      private var _playheadTime:Number = 0;
      
      mx_internal var timerTween:Tween;
      
      mx_internal var endEffectCalled:Boolean;
      
      public function CompositeEffectInstance(target:Object)
      {
         super(target);
      }
      
      override public function get playheadTime() : Number
      {
         return _playheadTime + super.playheadTime;
      }
      
      override mx_internal function get actualDuration() : Number
      {
         var value:Number = NaN;
         if(repeatCount > 0)
         {
            value = durationWithoutRepeat * repeatCount + (repeatDelay * repeatCount - 1) + startDelay;
         }
         return value;
      }
      
      override public function play() : void
      {
         timerTween = new Tween(this,0,0,durationWithoutRepeat);
         super.play();
      }
      
      override public function finishEffect() : void
      {
         activeEffectQueue = null;
         super.finishEffect();
      }
      
      mx_internal function hasRotateInstance() : Boolean
      {
         var i:int = 0;
         var compChild:CompositeEffectInstance = null;
         if(Boolean(childSets))
         {
            for(i = 0; i < childSets.length; i++)
            {
               if(childSets[i].length > 0)
               {
                  compChild = childSets[i][0] as CompositeEffectInstance;
                  if(childSets[i][0] is RotateInstance || Boolean(compChild) && Boolean(compChild.hasRotateInstance()))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      mx_internal function get durationWithoutRepeat() : Number
      {
         return 0;
      }
      
      override public function initEffect(event:Event) : void
      {
         var instances:Array = null;
         var m:int = 0;
         var j:int = 0;
         super.initEffect(event);
         var n:int = int(childSets.length);
         for(var i:int = 0; i < n; i++)
         {
            instances = childSets[i];
            m = int(instances.length);
            for(j = 0; j < m; j++)
            {
               instances[j].initEffect(event);
            }
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(timerTween))
         {
            timerTween.stop();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         super.mx_internal::playReversed = !playReversed;
         if(Boolean(timerTween))
         {
            timerTween.reverse();
         }
      }
      
      public function addChildSet(childSet:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(Boolean(childSet))
         {
            n = int(childSet.length);
            if(n > 0)
            {
               if(!childSets)
               {
                  childSets = [childSet];
               }
               else
               {
                  childSets.push(childSet);
               }
               for(i = 0; i < n; i++)
               {
                  childSet[i].addEventListener(EffectEvent.EFFECT_END,effectEndHandler);
                  childSet[i].mx_internal::parentCompositeEffectInstance = this;
               }
            }
         }
      }
      
      protected function onEffectEnd(childEffect:IEffectInstance) : void
      {
      }
      
      override mx_internal function playWithNoDuration() : void
      {
         super.mx_internal::playWithNoDuration();
         end();
      }
      
      public function onTweenUpdate(value:Object) : void
      {
         _playheadTime = Boolean(timerTween) ? timerTween.playheadTime : _playheadTime;
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(timerTween))
         {
            timerTween.pause();
         }
      }
      
      mx_internal function effectEndHandler(event:EffectEvent) : void
      {
         onEffectEnd(event.effectInstance);
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(timerTween))
         {
            timerTween.resume();
         }
      }
      
      public function onTweenEnd(value:Object) : void
      {
         _playheadTime = Boolean(timerTween) ? timerTween.playheadTime : _playheadTime;
      }
   }
}

