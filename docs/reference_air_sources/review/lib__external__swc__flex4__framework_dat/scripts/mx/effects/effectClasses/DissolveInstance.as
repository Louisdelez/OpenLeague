package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.geom.RoundedRectangle;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class DissolveInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var overlay:UIComponent;
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public var color:uint = 4294967295;
      
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
            case "resizeStart":
            case Event.REMOVED:
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
         var bgColor:Number = NaN;
         super.play();
         var values:PropertyChanges = propertyChanges;
         if(isNaN(this.alphaFrom) && isNaN(this.alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               this.alphaFrom = target.alpha;
               this.alphaTo = values.end["alpha"];
            }
            else if(Boolean(values) && values.end["visible"] !== undefined)
            {
               this.alphaFrom = Boolean(values.start["visible"]) ? Number(target.alpha) : 0;
               this.alphaTo = Boolean(values.end["visible"]) ? Number(target.alpha) : 0;
            }
            else
            {
               this.alphaFrom = 0;
               this.alphaTo = target.alpha;
            }
         }
         else if(isNaN(this.alphaFrom))
         {
            this.alphaFrom = this.alphaTo == 0 ? Number(target.alpha) : 0;
         }
         else if(isNaN(this.alphaTo))
         {
            if(Boolean(values) && values.end["alpha"] !== undefined)
            {
               this.alphaTo = values.end["alpha"];
            }
            else
            {
               this.alphaTo = this.alphaFrom == 0 ? Number(target.alpha) : 0;
            }
         }
         if(this.color == StyleManager.NOT_A_COLOR)
         {
            this.color = 16777215;
            bgColor = Number(target.getStyle("backgroundColor"));
            if(isNaN(bgColor) && Boolean(target.parent))
            {
               bgColor = Number(target.parent.getStyle("backgroundColor"));
            }
            if(!isNaN(bgColor))
            {
               this.color = uint(bgColor);
            }
         }
         var targetWidth:Number = Number(target.width);
         var targetHeight:Number = Number(target.height);
         target.addEventListener(ChildExistenceChangedEvent.OVERLAY_CREATED,this.overlayCreatedHandler);
         target.addOverlay(this.color,this.targetArea);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         this.overlay.alpha = Number(value);
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         if(!this.persistAfterEnd)
         {
            target.removeOverlay();
         }
      }
      
      private function overlayCreatedHandler(event:ChildExistenceChangedEvent) : void
      {
         target.removeEventListener(ChildExistenceChangedEvent.OVERLAY_CREATED,this.overlayCreatedHandler);
         event.stopImmediatePropagation();
         this.overlay = UIComponent(event.relatedObject);
         tween = createTween(this,1 - this.alphaFrom,1 - this.alphaTo,duration);
         applyTweenStartValues();
      }
   }
}

