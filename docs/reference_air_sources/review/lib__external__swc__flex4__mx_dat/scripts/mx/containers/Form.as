package mx.containers
{
   import flash.display.DisplayObject;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.controls.Label;
   import mx.core.Container;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   
   [Alternative(replacement="spark.components.Form",since="4.5")]
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var layoutObject:BoxLayout = new BoxLayout();
      
      private var measuredLabelWidth:Number;
      
      public function Form()
      {
         super();
         showInAutomationHierarchy = true;
         this.layoutObject.target = this;
         this.layoutObject.direction = BoxDirection.VERTICAL;
      }
      
      override public function set moduleFactory(moduleFactory:IFlexModuleFactory) : void
      {
         super.moduleFactory = moduleFactory;
         styleManager.registerInheritingStyle("labelWidth");
         styleManager.registerSizeInvalidatingStyle("labelWidth");
         styleManager.registerInheritingStyle("indicatorGap");
         styleManager.registerSizeInvalidatingStyle("indicatorGap");
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
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         this.invalidateLabelWidth();
         return super.addChild(child);
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         this.invalidateLabelWidth();
         return super.addChildAt(child,index);
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         this.invalidateLabelWidth();
         return super.removeChild(child);
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         this.invalidateLabelWidth();
         return super.removeChildAt(index);
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.layoutObject.measure();
         this.calculateLabelWidth();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(!styleProp || styleProp == "styleName" || Boolean(styleManager.isSizeInvalidatingStyle(styleProp)))
         {
            this.invalidateLabelWidth();
         }
         super.styleChanged(styleProp);
      }
      
      internal function invalidateLabelWidth() : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:IUIComponent = null;
         if(!isNaN(this.measuredLabelWidth) && Boolean(initialized))
         {
            this.measuredLabelWidth = NaN;
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
      
      internal function calculateLabelWidth() : Number
      {
         var child:DisplayObject = null;
         if(!isNaN(this.measuredLabelWidth))
         {
            return this.measuredLabelWidth;
         }
         var labelWidth:Number = 0;
         var labelWidthSet:Boolean = false;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getChildAt(i);
            if(child is FormItem && Boolean(FormItem(child).includeInLayout))
            {
               labelWidth = Math.max(labelWidth,FormItem(child).getPreferredLabelWidth());
               labelWidthSet = true;
            }
         }
         if(labelWidthSet)
         {
            this.measuredLabelWidth = labelWidth;
         }
         return labelWidth;
      }
   }
}

