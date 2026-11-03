package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.RotateInstance;
   
   use namespace mx_internal;
   
   public class Rotate extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["rotation"];
      
      [Inspectable(category="General",defaultValue="0")]
      public var originY:Number;
      
      [Inspectable(category="General",defaultValue="360")]
      public var angleTo:Number = 360;
      
      [Inspectable(category="General",defaultValue="0")]
      public var originX:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var angleFrom:Number = 0;
      
      public function Rotate(target:Object = null)
      {
         super(target);
         instanceClass = RotateInstance;
         hideFocusRing = true;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var rotateInstance:RotateInstance = RotateInstance(instance);
         rotateInstance.angleFrom = angleFrom;
         rotateInstance.angleTo = angleTo;
         rotateInstance.originX = originX;
         rotateInstance.originY = originY;
      }
      
      override public function get hideFocusRing() : Boolean
      {
         return super.hideFocusRing;
      }
      
      override public function set hideFocusRing(value:Boolean) : void
      {
         super.hideFocusRing = value;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}

