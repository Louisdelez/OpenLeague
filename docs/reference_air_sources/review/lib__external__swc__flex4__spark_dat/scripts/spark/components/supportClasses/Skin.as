package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import mx.core.FlexVersion;
   import mx.core.UIComponent;
   import spark.components.Group;
   import spark.core.DisplayObjectSharingMode;
   import spark.core.IGraphicElement;
   import spark.skins.IHighlightBitmapCaptureClient;
   
   public class Skin extends Group implements IHighlightBitmapCaptureClient
   {
      
      private static var exclusionAlphaValues:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function Skin()
      {
         super();
      }
      
      public function get focusSkinExclusions() : Array
      {
         return null;
      }
      
      public function beginHighlightBitmapCapture() : Boolean
      {
         var ex:Object = null;
         var ge:IGraphicElement = null;
         var exclusions:Array = this.focusSkinExclusions;
         if(!exclusions)
         {
            if("hostComponent" in this && this["hostComponent"] is SkinnableComponent)
            {
               exclusions = SkinnableComponent(this["hostComponent"]).suggestedFocusSkinExclusions;
            }
         }
         var exclusionCount:Number = exclusions == null ? 0 : exclusions.length;
         exclusionAlphaValues = [];
         var needRedraw:Boolean = false;
         for(var i:int = 0; i < exclusionCount; i++)
         {
            if(exclusions[i] in this)
            {
               ex = this[exclusions[i]];
               if(ex is UIComponent)
               {
                  exclusionAlphaValues[i] = (ex as UIComponent).$alpha;
                  (ex as UIComponent).$alpha = 0;
               }
               else if(ex is DisplayObject)
               {
                  exclusionAlphaValues[i] = (ex as DisplayObject).alpha;
                  (ex as DisplayObject).alpha = 0;
               }
               else if(ex is IGraphicElement)
               {
                  ge = ex as IGraphicElement;
                  if(ge.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
                  {
                     exclusionAlphaValues[i] = ge.displayObject.alpha;
                     ge.displayObject.alpha = 0;
                  }
                  else
                  {
                     exclusionAlphaValues[i] = ge.alpha;
                     ge.alpha = 0;
                     needRedraw = true;
                  }
               }
            }
         }
         return needRedraw;
      }
      
      public function endHighlightBitmapCapture() : Boolean
      {
         var ex:Object = null;
         var ge:IGraphicElement = null;
         var exclusions:Array = this.focusSkinExclusions;
         if(!exclusions)
         {
            if(this["hostComponent"] is SkinnableComponent)
            {
               exclusions = SkinnableComponent(this["hostComponent"]).suggestedFocusSkinExclusions;
            }
         }
         var exclusionCount:Number = exclusions == null ? 0 : exclusions.length;
         var needRedraw:Boolean = false;
         for(var i:int = 0; i < exclusionCount; i++)
         {
            if(exclusions[i] in this)
            {
               ex = this[exclusions[i]];
               if(ex is UIComponent)
               {
                  (ex as UIComponent).$alpha = exclusionAlphaValues[i];
               }
               else if(ex is DisplayObject)
               {
                  (ex as DisplayObject).alpha = exclusionAlphaValues[i];
               }
               else if(ex is IGraphicElement)
               {
                  ge = ex as IGraphicElement;
                  if(ge.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
                  {
                     ge.displayObject.alpha = exclusionAlphaValues[i];
                  }
                  else
                  {
                     ge.alpha = exclusionAlphaValues[i];
                     needRedraw = true;
                  }
               }
            }
         }
         exclusionAlphaValues = null;
         return needRedraw;
      }
      
      override protected function initializeAccessibility() : void
      {
      }
      
      override public function get explicitMinWidth() : Number
      {
         var parentExplicitMinWidth:Number = NaN;
         if(parent is SkinnableComponent)
         {
            parentExplicitMinWidth = Number(SkinnableComponent(parent).explicitMinWidth);
            if(!isNaN(parentExplicitMinWidth))
            {
               return parentExplicitMinWidth;
            }
         }
         return super.explicitMinWidth;
      }
      
      override public function get explicitMinHeight() : Number
      {
         var parentExplicitMinHeight:Number = NaN;
         if(parent is SkinnableComponent)
         {
            parentExplicitMinHeight = Number(SkinnableComponent(parent).explicitMinHeight);
            if(!isNaN(parentExplicitMinHeight))
            {
               return parentExplicitMinHeight;
            }
         }
         return super.explicitMinHeight;
      }
      
      override public function get explicitMaxWidth() : Number
      {
         var parentExplicitMaxWidth:Number = NaN;
         if(parent is SkinnableComponent)
         {
            parentExplicitMaxWidth = Number(SkinnableComponent(parent).explicitMaxWidth);
            if(!isNaN(parentExplicitMaxWidth))
            {
               return parentExplicitMaxWidth;
            }
         }
         return super.explicitMaxWidth;
      }
      
      override public function get explicitMaxHeight() : Number
      {
         var parentExplicitMaxHeight:Number = NaN;
         if(parent is SkinnableComponent)
         {
            parentExplicitMaxHeight = Number(SkinnableComponent(parent).explicitMaxHeight);
            if(!isNaN(parentExplicitMaxHeight))
            {
               return parentExplicitMaxHeight;
            }
         }
         return super.explicitMaxHeight;
      }
      
      override protected function canSkipMeasurement() : Boolean
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_5)
         {
            return super.canSkipMeasurement();
         }
         return false;
      }
   }
}

