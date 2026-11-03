package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   
   use namespace mx_internal;
   
   public class RotateInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      private var newX:Number;
      
      private var newY:Number;
      
      private var originalOffsetX:Number;
      
      private var originalOffsetY:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var angleFrom:Number = 0;
      
      [Inspectable(category="General",defaultValue="360")]
      public var angleTo:Number = 360;
      
      public var originX:Number;
      
      public var originY:Number;
      
      public function RotateInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         super.play();
         var radVal:Number = Math.PI * target.rotation / 180;
         if(isNaN(this.originX))
         {
            this.originX = target.width / 2;
         }
         if(isNaN(this.originY))
         {
            this.originY = target.height / 2;
         }
         this.centerX = target.x + this.originX * Math.cos(radVal) - this.originY * Math.sin(radVal);
         this.centerY = target.y + this.originX * Math.sin(radVal) + this.originY * Math.cos(radVal);
         if(isNaN(this.angleFrom))
         {
            this.angleFrom = target.rotation;
         }
         if(isNaN(this.angleTo))
         {
            this.angleTo = target.rotation == 0 ? (this.angleFrom > 180 ? 360 : 0) : Number(target.rotation);
         }
         tween = createTween(this,this.angleFrom,this.angleTo,duration);
         target.rotation = this.angleFrom;
         radVal = Math.PI * this.angleFrom / 180;
         EffectManager.suspendEventHandling();
         this.originalOffsetX = this.originX * Math.cos(radVal) - this.originY * Math.sin(radVal);
         this.originalOffsetY = this.originX * Math.sin(radVal) + this.originY * Math.cos(radVal);
         this.newX = Number((this.centerX - this.originalOffsetX).toFixed(1));
         this.newY = Number((this.centerY - this.originalOffsetY).toFixed(1));
         target.move(this.newX,this.newY);
         EffectManager.resumeEventHandling();
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         if(Math.abs(this.newX - target.x) > 0.1)
         {
            this.centerX = target.x + this.originalOffsetX;
         }
         if(Math.abs(this.newY - target.y) > 0.1)
         {
            this.centerY = target.y + this.originalOffsetY;
         }
         var rotateValue:Number = Number(value);
         var radVal:Number = Math.PI * rotateValue / 180;
         EffectManager.suspendEventHandling();
         target.rotation = rotateValue;
         this.newX = this.centerX - this.originX * Math.cos(radVal) + this.originY * Math.sin(radVal);
         this.newY = this.centerY - this.originX * Math.sin(radVal) - this.originY * Math.cos(radVal);
         this.newX = Number(this.newX.toFixed(1));
         this.newY = Number(this.newY.toFixed(1));
         target.move(this.newX,this.newY);
         EffectManager.resumeEventHandling();
      }
   }
}

