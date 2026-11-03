package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   [Exclude(name="motionPaths",kind="property")]
   public class Scale extends AnimateTransform
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["scaleX","scaleY","postLayoutScaleX","postLayoutScaleY","width","height"];
      
      private static var RELEVANT_STYLES:Array = [];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleYBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var scaleXBy:Number;
      
      public function Scale(target:Object = null)
      {
         super(target);
         instanceClass = AnimateTransformInstance;
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
         addMotionPath(xProp,this.scaleXFrom,this.scaleXTo,this.scaleXBy);
         addMotionPath(yProp,this.scaleYFrom,this.scaleYTo,this.scaleYBy);
         super.initInstance(instance);
      }
   }
}

