package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   [Exclude(name="motionPaths",kind="property")]
   public class Rotate extends AnimateTransform
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["rotationZ","postLayoutRotationZ","width","height"];
      
      private static var RELEVANT_STYLES:Array = [];
      
      [Inspectable(category="General")]
      public var angleFrom:Number;
      
      [Inspectable(category="General")]
      public var angleTo:Number;
      
      [Inspectable(category="General")]
      public var angleBy:Number;
      
      public function Rotate(target:Object = null)
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
         if(!applyChangesPostLayout)
         {
            addMotionPath("rotationZ",this.angleFrom,this.angleTo,this.angleBy);
         }
         else
         {
            addMotionPath("postLayoutRotationZ",this.angleFrom,this.angleTo,this.angleBy);
         }
         super.initInstance(instance);
      }
   }
}

