package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   
   use namespace mx_internal;
   
   public class RotateInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var originX:Number;
      
      public var originY:Number;
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      [Inspectable(category="General",defaultValue="360")]
      public var angleTo:Number = 360;
      
      private var originalOffsetX:Number;
      
      private var originalOffsetY:Number;
      
      private var newX:Number;
      
      private var newY:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var angleFrom:Number = 0;
      
      public function RotateInstance(target:Object)
      {
         super(target);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         if(Math.abs(newX - target.x) > 0.1)
         {
            centerX = target.x + originalOffsetX;
         }
         if(Math.abs(newY - target.y) > 0.1)
         {
            centerY = target.y + originalOffsetY;
         }
         var rotateValue:Number = Number(value);
         var radVal:Number = Math.PI * rotateValue / 180;
         EffectManager.suspendEventHandling();
         target.rotation = rotateValue;
         newX = centerX - originX * Math.cos(radVal) + originY * Math.sin(radVal);
         newY = centerY - originX * Math.sin(radVal) - originY * Math.cos(radVal);
         newX = Number(newX.toFixed(1));
         newY = Number(newY.toFixed(1));
         target.move(newX,newY);
         EffectManager.resumeEventHandling();
      }
      
      override public function play() : void
      {
         super.play();
         var radVal:Number = Math.PI * target.rotation / 180;
         if(isNaN(originX))
         {
            originX = target.width / 2;
         }
         if(isNaN(originY))
         {
            originY = target.height / 2;
         }
         centerX = target.x + originX * Math.cos(radVal) - originY * Math.sin(radVal);
         centerY = target.y + originX * Math.sin(radVal) + originY * Math.cos(radVal);
         if(isNaN(angleFrom))
         {
            angleFrom = target.rotation;
         }
         if(isNaN(angleTo))
         {
            angleTo = target.rotation == 0 ? (angleFrom > 180 ? 360 : 0) : Number(target.rotation);
         }
         tween = createTween(this,angleFrom,angleTo,duration);
         target.rotation = angleFrom;
         radVal = Math.PI * angleFrom / 180;
         EffectManager.suspendEventHandling();
         originalOffsetX = originX * Math.cos(radVal) - originY * Math.sin(radVal);
         originalOffsetY = originX * Math.sin(radVal) + originY * Math.cos(radVal);
         newX = Number((centerX - originalOffsetX).toFixed(1));
         newY = Number((centerY - originalOffsetY).toFixed(1));
         target.move(newX,newY);
         EffectManager.resumeEventHandling();
      }
   }
}

