package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.RotateInstance;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.effects.Rotate",since="4.0")]
   public class Rotate extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["rotation"];
      
      [Inspectable(category="General",defaultValue="0")]
      public var angleFrom:Number = 0;
      
      [Inspectable(category="General",defaultValue="360")]
      public var angleTo:Number = 360;
      
      [Inspectable(category="General",defaultValue="0")]
      public var originX:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var originY:Number;
      
      public function Rotate(target:Object = null)
      {
         super(target);
         instanceClass = RotateInstance;
         this.hideFocusRing = true;
      }
      
      override public function set hideFocusRing(value:Boolean) : void
      {
         super.hideFocusRing = value;
      }
      
      override public function get hideFocusRing() : Boolean
      {
         return super.hideFocusRing;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var rotateInstance:RotateInstance = RotateInstance(instance);
         rotateInstance.angleFrom = this.angleFrom;
         rotateInstance.angleTo = this.angleTo;
         rotateInstance.originX = this.originX;
         rotateInstance.originY = this.originY;
      }
   }
}

