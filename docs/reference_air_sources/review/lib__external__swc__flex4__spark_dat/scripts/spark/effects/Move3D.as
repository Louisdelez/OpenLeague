package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   [Exclude(name="motionPaths",kind="property")]
   public class Move3D extends AnimateTransform3D
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["translationX","translationY","translationZ","postLayoutTranslationX","postLayoutTranslationY","postLayoutTranslationZ","left","right","top","bottom","horizontalCenter","verticalCenter","baseline","width","height"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","horizontalCenter","verticalCenter","baseline"];
      
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
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var zBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var zFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var zTo:Number;
      
      public function Move3D(target:Object = null)
      {
         super(target);
         applyChangesPostLayout = true;
         applyLocalProjection = true;
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
         var xProp:String = applyChangesPostLayout ? "postLayoutTranslationX" : "translationX";
         var yProp:String = applyChangesPostLayout ? "postLayoutTranslationY" : "translationY";
         var zProp:String = applyChangesPostLayout ? "postLayoutTranslationZ" : "translationZ";
         addMotionPath(xProp,this.xFrom,this.xTo,this.xBy);
         addMotionPath(yProp,this.yFrom,this.yTo,this.yBy);
         addMotionPath(zProp,this.zFrom,this.zTo,this.zBy);
         super.initInstance(instance);
      }
   }
}

