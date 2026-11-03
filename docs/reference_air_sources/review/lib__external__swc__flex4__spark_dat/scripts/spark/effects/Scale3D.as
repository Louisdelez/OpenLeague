package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   
   [Exclude(name="motionPaths",kind="property")]
   public class Scale3D extends AnimateTransform3D
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["scaleX","scaleY","scaleZ","postLayoutScaleX","postLayoutScaleY","postLayoutScaleZ","width","height"];
      
      private static var RELEVANT_STYLES:Array = [];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleZFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleZTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleZBy:Number;
      
      public function Scale3D(target:Object = null)
      {
         super(target);
         applyLocalProjection = true;
         applyChangesPostLayout = true;
         transformEffectSubclass = true;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function createInstance(target:Object = null) : IEffectInstance
      {
         motionPaths = new Vector.<MotionPath>();
         return super.createInstance(target);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var xProp:String = applyChangesPostLayout ? "postLayoutScaleX" : "scaleX";
         var yProp:String = applyChangesPostLayout ? "postLayoutScaleY" : "scaleY";
         var zProp:String = applyChangesPostLayout ? "postLayoutScaleZ" : "scaleZ";
         addMotionPath(xProp,this.scaleXFrom,this.scaleXTo,this.scaleXBy);
         addMotionPath(yProp,this.scaleYFrom,this.scaleYTo,this.scaleYBy);
         addMotionPath(zProp,this.scaleZFrom,this.scaleZTo,this.scaleZBy);
         super.initInstance(instance);
      }
   }
}

