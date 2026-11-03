package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.MoveInstance;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.effects.Move",since="4.0")]
   public class Move extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["x","y"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","horizontalCenter","verticalCenter"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var xTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var yTo:Number;
      
      public function Move(target:Object = null)
      {
         super(target);
         instanceClass = MoveInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var moveInstance:MoveInstance = null;
         super.initInstance(instance);
         moveInstance = MoveInstance(instance);
         moveInstance.xFrom = this.xFrom;
         moveInstance.xTo = this.xTo;
         moveInstance.xBy = this.xBy;
         moveInstance.yFrom = this.yFrom;
         moveInstance.yTo = this.yTo;
         moveInstance.yBy = this.yBy;
      }
   }
}

