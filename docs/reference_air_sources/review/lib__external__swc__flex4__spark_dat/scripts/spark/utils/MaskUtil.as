package spark.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.filters.ShaderFilter;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.graphics.shaderClasses.LuminosityMaskShader;
   import spark.core.MaskType;
   
   [ExcludeClass]
   public class MaskUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function MaskUtil()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function applyLuminositySettings(mask:DisplayObject, maskType:String, luminosityInvert:Boolean, luminosityClip:Boolean) : void
      {
         var shaderFilterIndex:int = 0;
         var shaderFilter:ShaderFilter = null;
         if(!mask || maskType != MaskType.LUMINOSITY || mask.filters.length == 0)
         {
            return;
         }
         var len:int = int(mask.filters.length);
         for(shaderFilterIndex = 0; shaderFilterIndex < len; )
         {
            if(mask.filters[shaderFilterIndex] is ShaderFilter && ShaderFilter(mask.filters[shaderFilterIndex]).shader is LuminosityMaskShader)
            {
               shaderFilter = mask.filters[shaderFilterIndex];
               break;
            }
            shaderFilterIndex++;
         }
         if(Boolean(shaderFilter))
         {
            LuminosityMaskShader(shaderFilter.shader).mode = calculateLuminositySettings(luminosityInvert,luminosityClip);
            mask.filters[shaderFilterIndex] = shaderFilter;
            mask.filters = mask.filters;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function applyMask(mask:DisplayObject, parent:DisplayObjectContainer) : void
      {
         if(!mask)
         {
            return;
         }
         var maskComp:UIComponent = mask as UIComponent;
         if(Boolean(maskComp))
         {
            if(Boolean(parent))
            {
               UIComponent(parent).addingChild(maskComp);
               UIComponent(parent).childAdded(maskComp);
            }
            UIComponentGlobals.layoutManager.validateClient(maskComp,true);
            maskComp.invalidateDisplayList();
            maskComp.setActualSize(maskComp.getExplicitOrMeasuredWidth(),maskComp.getExplicitOrMeasuredHeight());
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function applyMaskType(mask:DisplayObject, maskType:String, luminosityInvert:Boolean, luminosityClip:Boolean, drawnDisplayObject:DisplayObject) : void
      {
         var luminosityMaskShader:LuminosityMaskShader = null;
         var shaderFilter:ShaderFilter = null;
         if(!mask)
         {
            return;
         }
         if(maskType == MaskType.CLIP)
         {
            mask.cacheAsBitmap = false;
            mask.filters = [];
         }
         else if(maskType == MaskType.ALPHA)
         {
            mask.cacheAsBitmap = true;
            drawnDisplayObject.cacheAsBitmap = true;
         }
         else if(maskType == MaskType.LUMINOSITY)
         {
            mask.cacheAsBitmap = true;
            drawnDisplayObject.cacheAsBitmap = true;
            luminosityMaskShader = new LuminosityMaskShader();
            luminosityMaskShader.mode = calculateLuminositySettings(luminosityInvert,luminosityClip);
            shaderFilter = new ShaderFilter(luminosityMaskShader);
            mask.filters = [shaderFilter];
         }
      }
      
      private static function calculateLuminositySettings(luminosityInvert:Boolean, luminosityClip:Boolean) : int
      {
         var mode:int = 0;
         if(luminosityInvert)
         {
            mode += 1;
         }
         if(luminosityClip)
         {
            mode += 2;
         }
         return mode;
      }
   }
}

