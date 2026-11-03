package mx.containers
{
   import flash.display.DisplayObject;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.controls.Label;
   import mx.core.Container;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   [IconFile("Form.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="indicatorGap",type="Number",format="Length",inherit="yes")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class Form extends Container
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var classInitialized:Boolean = false;
      
      mx_internal var layoutObject:BoxLayout = new BoxLayout();
      
      private var measuredLabelWidth:Number;
      
      public function Form()
      {
         super();
         if(!classInitialized)
         {
            initializeClass();
            classInitialized = true;
         }
         showInAutomationHierarchy = true;
         mx_internal::layoutObject.target = this;
         mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
      }
      
      private static function initializeClass() : void
      {
         StyleManager.registerInheritingStyle("labelWidth");
         StyleManager.registerSizeInvalidatingStyle("labelWidth");
         StyleManager.registerInheritingStyle("indicatorGap");
         StyleManager.registerSizeInvalidatingStyle("indicatorGap");
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         invalidateLabelWidth();
         return super.addChild(child);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(!styleProp || styleProp == "styleName" || StyleManager.isSizeInvalidatingStyle(styleProp))
         {
            invalidateLabelWidth();
         }
         super.styleChanged(styleProp);
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         invalidateLabelWidth();
         return super.removeChildAt(index);
      }
      
      internal function calculateLabelWidth() : Number
      {
         var child:DisplayObject = null;
         if(!isNaN(measuredLabelWidth))
         {
            return measuredLabelWidth;
         }
         var labelWidth:Number = 0;
         var labelWidthSet:Boolean = false;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getChildAt(i);
            if(child is FormItem && FormItem(child).includeInLayout)
            {
               labelWidth = Math.max(labelWidth,FormItem(child).getPreferredLabelWidth());
               labelWidthSet = true;
            }
         }
         if(labelWidthSet)
         {
            measuredLabelWidth = labelWidth;
         }
         return labelWidth;
      }
      
      internal function invalidateLabelWidth() : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:IUIComponent = null;
         if(!isNaN(measuredLabelWidth) && initialized)
         {
            measuredLabelWidth = NaN;
            n = numChildren;
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child is IInvalidating)
               {
                  IInvalidating(child).invalidateSize();
               }
            }
         }
      }
      
      [Bindable("updateComplete")]
      public function get maxLabelWidth() : Number
      {
         var child:DisplayObject = null;
         var itemLabel:Label = null;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getChildAt(i);
            if(child is FormItem)
            {
               itemLabel = FormItem(child).itemLabel;
               if(Boolean(itemLabel))
               {
                  return itemLabel.width;
               }
            }
         }
         return 0;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         mx_internal::layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         invalidateLabelWidth();
         return super.addChildAt(child,index);
      }
      
      override protected function measure() : void
      {
         super.measure();
         mx_internal::layoutObject.measure();
         calculateLabelWidth();
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         invalidateLabelWidth();
         return super.removeChild(child);
      }
   }
}

