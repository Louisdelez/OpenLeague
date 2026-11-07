package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   [Exclude(name="motionPaths",kind="property")]
   public class Rotate3D extends AnimateTransform3D
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["rotationX","rotationY","rotationZ","postLayoutRotationX","postLayoutRotationY","postLayoutRotationZ","width","height"];
      
      private static var RELEVANT_STYLES:Array = [];
      
      [Inspectable(category="General")]
      public var angleXFrom:Number;
      
      [Inspectable(category="General")]
      public var angleXTo:Number;
      
      [Inspectable(category="General")]
      public var angleYFrom:Number;
      
      [Inspectable(category="General")]
      public var angleYTo:Number;
      
      [Inspectable(category="General")]
      public var angleZFrom:Number;
      
      [Inspectable(category="General")]
      public var angleZTo:Number;
      
      public function Rotate3D(target:Object = null)
      {
         super(target);
         applyLocalProjection = true;
         instanceClass = AnimateTransformInstance;
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
         var xProp:String = applyChangesPostLayout ? "postLayoutRotationX" : "rotationX";
         var yProp:String = applyChangesPostLayout ? "postLayoutRotationY" : "rotationY";
         var zProp:String = applyChangesPostLayout ? "postLayoutRotationZ" : "rotationZ";
         addMotionPath(xProp,this.angleXFrom,this.angleXTo);
         addMotionPath(yProp,this.angleYFrom,this.angleYTo);
         addMotionPath(zProp,this.angleZFrom,this.angleZTo);
         super.initInstance(instance);
      }
   }
}

