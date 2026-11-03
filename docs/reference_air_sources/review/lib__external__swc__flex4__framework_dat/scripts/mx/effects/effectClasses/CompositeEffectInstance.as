package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   import mx.events.EffectEvent;
   
   use namespace mx_internal;
   
   public class CompositeEffectInstance extends EffectInstance
   {
      
      private static var resizeEffectType:Class;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var resizeEffectLoaded:Boolean = false;
      
      mx_internal var activeEffectQueue:Array = [];
      
      private var _playheadTime:Number = 0;
      
      mx_internal var childSets:Array = [];
      
      mx_internal var endEffectCalled:Boolean;
      
      mx_internal var timerTween:Tween;
      
      public function CompositeEffectInstance(target:Object)
      {
         super(target);
      }
      
      override mx_internal function get actualDuration() : Number
      {
         var value:Number = NaN;
         if(repeatCount > 0)
         {
            value = this.durationWithoutRepeat * repeatCount + repeatDelay * (repeatCount - 1) + startDelay;
         }
         return value;
      }
      
      override public function get playheadTime() : Number
      {
         return this._playheadTime;
      }
      
      override public function set playheadTime(value:Number) : void
      {
         if(Boolean(this.timerTween))
         {
            this.timerTween.seek(value);
         }
         else
         {
            this._playheadTime = value;
         }
         super.playheadTime = value;
      }
      
      mx_internal function get durationWithoutRepeat() : Number
      {
         return 0;
      }
      
      override public function play() : void
      {
         this.timerTween = new Tween(this,0,0,this.durationWithoutRepeat);
         super.play();
      }
      
      override public function pause() : void
      {
         super.pause();
         if(Boolean(this.timerTween))
         {
            this.timerTween.pause();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(Boolean(this.timerTween))
         {
            this.timerTween.stop();
         }
      }
      
      override public function end() : void
      {
         super.end();
         if(Boolean(this.timerTween))
         {
            this.timerTween.endTween();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(Boolean(this.timerTween))
         {
            this.timerTween.resume();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         super.mx_internal::playReversed = !playReversed;
         if(Boolean(this.timerTween))
         {
            this.timerTween.reverse();
         }
      }
      
      override public function finishEffect() : void
      {
         this.activeEffectQueue = null;
         super.finishEffect();
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
               if(!this.childSets)
               {
                  this.childSets = [childSet];
               }
               else
               {
                  this.childSets.push(childSet);
               }
               for(i = 0; i < n; i++)
               {
                  childSet[i].addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
                  childSet[i].parentCompositeEffectInstance = this;
               }
            }
         }
      }
      
      mx_internal function hasRotateInstance() : Boolean
      {
         var i:int = 0;
         var compChild:CompositeEffectInstance = null;
         if(Boolean(this.childSets))
         {
            for(i = 0; i < this.childSets.length; i++)
            {
               if(this.childSets[i].length > 0)
               {
                  compChild = this.childSets[i][0] as CompositeEffectInstance;
                  if(this.childSets[i][0] is RotateInstance || Boolean(compChild) && Boolean(compChild.hasRotateInstance()))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      mx_internal function hasResizeInstance() : Boolean
      {
         var i:int = 0;
         var compChild:CompositeEffectInstance = null;
         if(Boolean(this.childSets))
         {
            if(!resizeEffectLoaded)
            {
               resizeEffectLoaded = true;
               if(ApplicationDomain.currentDomain.hasDefinition("spark.effects.supportClasses.ResizeInstance"))
               {
                  resizeEffectType = Class(ApplicationDomain.currentDomain.getDefinition("spark.effects.supportClasses.ResizeInstance"));
               }
            }
            if(Boolean(resizeEffectType))
            {
               for(i = 0; i < this.childSets.length; i++)
               {
                  if(this.childSets[i].length > 0)
                  {
                     compChild = this.childSets[i][0] as CompositeEffectInstance;
                     if(this.childSets[i][0] is resizeEffectType || Boolean(compChild) && Boolean(compChild.hasResizeInstance()))
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      override mx_internal function playWithNoDuration() : void
      {
         super.mx_internal::playWithNoDuration();
         this.end();
      }
      
      protected function onEffectEnd(childEffect:IEffectInstance) : void
      {
      }
      
      public function onTweenUpdate(value:Object) : void
      {
         this._playheadTime = Boolean(this.timerTween) ? this.timerTween.playheadTime : this._playheadTime;
      }
      
      public function onTweenEnd(value:Object) : void
      {
         this._playheadTime = Boolean(this.timerTween) ? this.timerTween.playheadTime : this._playheadTime;
      }
      
      override public function initEffect(event:Event) : void
      {
         var instances:Array = null;
         var m:int = 0;
         var j:int = 0;
         super.initEffect(event);
         var n:int = int(this.childSets.length);
         for(var i:int = 0; i < n; i++)
         {
            instances = this.childSets[i];
            m = int(instances.length);
            for(j = 0; j < m; j++)
            {
               instances[j].initEffect(event);
            }
         }
      }
      
      mx_internal function effectEndHandler(event:EffectEvent) : void
      {
         this.onEffectEnd(event.effectInstance);
      }
   }
}

