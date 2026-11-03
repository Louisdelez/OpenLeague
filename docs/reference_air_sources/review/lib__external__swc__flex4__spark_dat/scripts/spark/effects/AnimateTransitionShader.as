package spark.effects
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import mx.core.IUIComponent;
   import mx.effects.IEffectInstance;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.effects.supportClasses.AnimateTransitionShaderInstance;
   import spark.primitives.supportClasses.GraphicElement;
   import spark.utils.BitmapUtil;
   
   [ResourceBundle("sparkEffects")]
   [DiscouragedForProfile("mobileDevice")]
   public class AnimateTransitionShader extends Animate
   {
      
      private static var _resourceManager:IResourceManager;
      
      public var bitmapFrom:BitmapData;
      
      public var bitmapTo:BitmapData;
      
      public var shaderByteCode:Object;
      
      public var shaderProperties:Object;
      
      public function AnimateTransitionShader(target:Object = null)
      {
         super(target);
         instanceClass = AnimateTransitionShaderInstance;
      }
      
      private static function get resourceManager() : IResourceManager
      {
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
         }
         return _resourceManager;
      }
      
      override public function getAffectedProperties() : Array
      {
         return ["bitmapInfo","visible","parent"];
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         var bmData:BitmapData = null;
         var bounds:Rectangle = null;
         if(property != "bitmapInfo")
         {
            return super.getValueFromTarget(target,property);
         }
         if(!target.visible || !target.parent)
         {
            return null;
         }
         if(!(target is GraphicElement || target is IUIComponent))
         {
            throw new Error(resourceManager.getString("sparkEffects","cannotOperateOn"));
         }
         var tempFilters:Array = target.filters;
         target.filters = [];
         try
         {
            if(target is GraphicElement)
            {
               bmData = GraphicElement(target).captureBitmapData(true,0,false);
               bounds = new Rectangle(0,0,Boolean(bmData) ? bmData.width : 0,Boolean(bmData) ? bmData.height : 0);
            }
            else
            {
               bounds = new Rectangle();
               bmData = BitmapUtil.getSnapshot(IUIComponent(target),bounds,true);
            }
         }
         catch(e:SecurityError)
         {
         }
         var bmHolder:Object = new Object();
         bmHolder["bitmap"] = bmData;
         bmHolder["bounds"] = bounds;
         target.filters = tempFilters;
         return bmHolder;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var animateTransitionShaderInstance:AnimateTransitionShaderInstance = AnimateTransitionShaderInstance(instance);
         animateTransitionShaderInstance.bitmapFrom = this.bitmapFrom;
         animateTransitionShaderInstance.bitmapTo = this.bitmapTo;
         if(!this.shaderByteCode)
         {
            animateTransitionShaderInstance.shaderByteCode = null;
         }
         else
         {
            animateTransitionShaderInstance.shaderByteCode = this.shaderByteCode is ByteArray ? ByteArray(this.shaderByteCode) : new this.shaderByteCode();
         }
         animateTransitionShaderInstance.shaderProperties = this.shaderProperties;
      }
   }
}

