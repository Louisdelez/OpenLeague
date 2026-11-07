package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   public class AnimateTransform3D extends AnimateTransform
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _applyLocalProjection:Boolean = true;
      
      public var removeLocalProjectionWhenComplete:Boolean = false;
      
      public var autoCenterProjection:Boolean = true;
      
      public var fieldOfView:Number;
      
      public var focalLength:Number;
      
      public var projectionX:Number = 0;
      
      public var projectionY:Number = 0;
      
      public function AnimateTransform3D(target:Object = null)
      {
         super(target);
         instanceClass = AnimateTransformInstance;
         applyChangesPostLayout = true;
      }
      
      [Inspectable(category="General",enumeration="true,false")]
      override public function get applyChangesPostLayout() : Boolean
      {
         return super.applyChangesPostLayout;
      }
      
      public function get applyLocalProjection() : Boolean
      {
         return this._applyLocalProjection;
      }
      
      public function set applyLocalProjection(value:Boolean) : void
      {
         this._applyLocalProjection = value;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var transformInstance:AnimateTransformInstance = null;
         super.initInstance(instance);
         transformInstance = AnimateTransformInstance(instance);
         transformInstance.applyLocalProjection = this.applyLocalProjection;
         transformInstance.removeLocalProjectionWhenComplete = this.removeLocalProjectionWhenComplete;
         transformInstance.autoCenterProjection = this.autoCenterProjection;
         transformInstance.fieldOfView = this.fieldOfView;
         transformInstance.focalLength = this.focalLength;
         transformInstance.projectionX = this.projectionX;
         transformInstance.projectionY = this.projectionY;
      }
   }
}

