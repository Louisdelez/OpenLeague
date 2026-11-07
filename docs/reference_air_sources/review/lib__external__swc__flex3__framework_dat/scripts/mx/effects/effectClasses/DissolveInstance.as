package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.graphics.RoundedRectangle;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class DissolveInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var color:uint = 4294967295;
      
      public var alphaFrom:Number;
      
      private var overlay:UIComponent;
      
      public var alphaTo:Number;
      
      mx_internal var persistAfterEnd:Boolean = false;
      
      public var targetArea:RoundedRectangle;
      
      public function DissolveInstance(target:Object)
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
            case "resizeEnd":
            case FlexEvent.SHOW:
            case Event.ADDED:
               if(isNaN(alphaFrom))
               {
                  alphaFrom = 0;
               }
               if(isNaN(alphaTo))
               {
                  alphaTo = target.alpha;
               }
               break;
            case FlexEvent.HIDE:
            case "resizeStart":
            case Event.REMOVED:
               if(isNaN(alphaFrom))
               {
                  alphaFrom = target.alpha;
               }
               if(isNaN(alphaTo))
               {
                  alphaTo = 0;
               }
         }
      }
      
      private function overlayCreatedHandler(event:ChildExistenceChangedEvent) : void
      {
         target.removeEventListener(ChildExistenceChangedEvent.OVERLAY_CREATED,overlayCreatedHandler);
         event.stopImmediatePropagation();
         overlay = UIComponent(event.relatedObject);
         tween = createTween(this,1 - alphaFrom,1 - alphaTo,duration);
         mx_internal::applyTweenStartValues();
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         if(!mx_internal::persistAfterEnd)
         {
            target.mx_internal::removeOverlay();
         }
      }
      
      override public function play() : void
      {
         var bgColor:Number = NaN;
         super.play();
         var values:PropertyChanges = propertyChanges;
         if(isNaN(alphaFrom) && isNaN(alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               alphaFrom = target.alpha;
               alphaTo = values.end["alpha"];
            }
            else if(Boolean(values) && values.end["visible"] !== undefined)
            {
               alphaFrom = Boolean(values.start["visible"]) ? Number(target.alpha) : 0;
               alphaTo = Boolean(values.end["visible"]) ? Number(target.alpha) : 0;
            }
            else
            {
               alphaFrom = 0;
               alphaTo = target.alpha;
            }
         }
         else if(isNaN(alphaFrom))
         {
            alphaFrom = alphaTo == 0 ? Number(target.alpha) : 0;
         }
         else if(isNaN(alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               alphaTo = values.end["alpha"];
            }
            else
            {
               alphaTo = alphaFrom == 0 ? Number(target.alpha) : 0;
            }
         }
         if(color == StyleManager.NOT_A_COLOR)
         {
            color = 16777215;
            bgColor = Number(target.getStyle("backgroundColor"));
            if(isNaN(bgColor) && Boolean(target.parent))
            {
               bgColor = Number(target.parent.getStyle("backgroundColor"));
            }
            if(!isNaN(bgColor))
            {
               color = uint(bgColor);
            }
         }
         var targetWidth:Number = Number(target.width);
         var targetHeight:Number = Number(target.height);
         target.addEventListener(ChildExistenceChangedEvent.OVERLAY_CREATED,overlayCreatedHandler);
         target.mx_internal::addOverlay(color,targetArea);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         overlay.alpha = Number(value);
      }
   }
}

