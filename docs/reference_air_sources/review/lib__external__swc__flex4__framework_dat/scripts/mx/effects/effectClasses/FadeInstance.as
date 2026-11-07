package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   public class FadeInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var origAlpha:Number = NaN;
      
      private var restoreAlpha:Boolean;
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public function FadeInstance(target:Object)
      {
         super(target);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
         switch(event.type)
         {
            case "childrenCreationComplete":
            case FlexEvent.CREATION_COMPLETE:
            case FlexEvent.SHOW:
            case Event.ADDED:
            case "resizeEnd":
               if(isNaN(this.alphaFrom))
               {
                  this.alphaFrom = 0;
               }
               if(isNaN(this.alphaTo))
               {
                  this.alphaTo = target.alpha;
               }
               break;
            case FlexEvent.HIDE:
            case Event.REMOVED:
            case "resizeStart":
               this.restoreAlpha = true;
               if(isNaN(this.alphaFrom))
               {
                  this.alphaFrom = target.alpha;
               }
               if(isNaN(this.alphaTo))
               {
                  this.alphaTo = 0;
               }
         }
      }
      
      override public function play() : void
      {
         super.play();
         this.origAlpha = target.alpha;
         var values:PropertyChanges = propertyChanges;
         if(isNaN(this.alphaFrom) && isNaN(this.alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               this.alphaFrom = this.origAlpha;
               this.alphaTo = values.end["alpha"];
            }
            else if(Boolean(values) && values.end["visible"] !== undefined)
            {
               this.alphaFrom = Boolean(values.start["visible"]) ? this.origAlpha : 0;
               this.alphaTo = Boolean(values.end["visible"]) ? this.origAlpha : 0;
            }
            else
            {
               this.alphaFrom = 0;
               this.alphaTo = this.origAlpha;
            }
         }
         else if(isNaN(this.alphaFrom))
         {
            this.alphaFrom = this.alphaTo == 0 ? this.origAlpha : 0;
         }
         else if(isNaN(this.alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               this.alphaTo = values.end["alpha"];
            }
            else
            {
               this.alphaTo = this.alphaFrom == 0 ? this.origAlpha : 0;
            }
         }
         tween = createTween(this,this.alphaFrom,this.alphaTo,duration);
         target.alpha = tween.getCurrentValue(0);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         target.alpha = value;
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         if(hideOnEffectEnd || this.restoreAlpha)
         {
            target.alpha = this.origAlpha;
         }
      }
   }
}

