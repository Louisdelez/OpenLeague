package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.MoveInstance;
   
   use namespace mx_internal;
   
   public class Move extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["x","y"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xTo:Number;
      
      public function Move(target:Object = null)
      {
         super(target);
         instanceClass = MoveInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var moveInstance:MoveInstance = null;
         super.initInstance(instance);
         moveInstance = MoveInstance(instance);
         moveInstance.xFrom = xFrom;
         moveInstance.xTo = xTo;
         moveInstance.xBy = xBy;
         moveInstance.yFrom = yFrom;
         moveInstance.yTo = yTo;
         moveInstance.yBy = yBy;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}

