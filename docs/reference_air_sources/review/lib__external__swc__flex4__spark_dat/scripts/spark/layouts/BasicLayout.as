package spark.layouts
{
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.resources.ResourceManager;
   import spark.components.supportClasses.GroupBase;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.layouts.supportClasses.LayoutElementHelper;
   
   [ResourceBundle("layout")]
   public class BasicLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function BasicLayout()
      {
         super();
      }
      
      private static function constraintsDetermineWidth(layoutElement:ILayoutElement) : Boolean
      {
         return !isNaN(layoutElement.percentWidth) || !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.left)) && !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.right));
      }
      
      private static function constraintsDetermineHeight(layoutElement:ILayoutElement) : Boolean
      {
         return !isNaN(layoutElement.percentHeight) || !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.top)) && !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.bottom));
      }
      
      private static function maxSizeToFitIn(totalSize:Number, center:Number, lowConstraint:Number, highConstraint:Number, position:Number) : Number
      {
         if(!isNaN(center))
         {
            return totalSize - 2 * Math.abs(center);
         }
         if(!isNaN(lowConstraint))
         {
            return totalSize - lowConstraint;
         }
         if(!isNaN(highConstraint))
         {
            return totalSize - highConstraint;
         }
         return totalSize - position;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualLayoutSupported() : Boolean
      {
         return false;
      }
      
      private function checkUseVirtualLayout() : void
      {
         if(useVirtualLayout)
         {
            throw new Error(ResourceManager.getInstance().getString("layout","basicLayoutNotVirtualized"));
         }
      }
      
      override public function measure() : void
      {
         var layoutElement:ILayoutElement = null;
         var hCenter:Number = NaN;
         var vCenter:Number = NaN;
         var baseline:Number = NaN;
         var left:Number = NaN;
         var right:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var extX:Number = NaN;
         var extY:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var elementMinWidth:Number = NaN;
         var elementMinHeight:Number = NaN;
         this.checkUseVirtualLayout();
         super.measure();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var width:Number = 0;
         var height:Number = 0;
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var count:int = layoutTarget.numElements;
         for(var i:int = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               hCenter = LayoutElementHelper.parseConstraintValue(layoutElement.horizontalCenter);
               vCenter = LayoutElementHelper.parseConstraintValue(layoutElement.verticalCenter);
               baseline = LayoutElementHelper.parseConstraintValue(layoutElement.baseline);
               left = LayoutElementHelper.parseConstraintValue(layoutElement.left);
               right = LayoutElementHelper.parseConstraintValue(layoutElement.right);
               top = LayoutElementHelper.parseConstraintValue(layoutElement.top);
               bottom = LayoutElementHelper.parseConstraintValue(layoutElement.bottom);
               if(!isNaN(left) && !isNaN(right))
               {
                  extX = left + right;
               }
               else if(!isNaN(hCenter))
               {
                  extX = Math.abs(hCenter) * 2;
               }
               else if(!isNaN(left) || !isNaN(right))
               {
                  extX = isNaN(left) ? 0 : left;
                  extX += isNaN(right) ? 0 : right;
               }
               else
               {
                  extX = Number(layoutElement.getBoundsXAtSize(NaN,NaN));
               }
               if(!isNaN(top) && !isNaN(bottom))
               {
                  extY = top + bottom;
               }
               else if(!isNaN(vCenter))
               {
                  extY = Math.abs(vCenter) * 2;
               }
               else if(!isNaN(baseline))
               {
                  extY = Math.round(baseline - layoutElement.baselinePosition);
               }
               else if(!isNaN(top) || !isNaN(bottom))
               {
                  extY = isNaN(top) ? 0 : top;
                  extY += isNaN(bottom) ? 0 : bottom;
               }
               else
               {
                  extY = Number(layoutElement.getBoundsYAtSize(NaN,NaN));
               }
               preferredWidth = Number(layoutElement.getPreferredBoundsWidth());
               preferredHeight = Number(layoutElement.getPreferredBoundsHeight());
               width = Math.max(width,extX + preferredWidth);
               height = Math.max(height,extY + preferredHeight);
               elementMinWidth = constraintsDetermineWidth(layoutElement) ? Number(layoutElement.getMinBoundsWidth()) : preferredWidth;
               elementMinHeight = constraintsDetermineHeight(layoutElement) ? Number(layoutElement.getMinBoundsHeight()) : preferredHeight;
               minWidth = Math.max(minWidth,extX + elementMinWidth);
               minHeight = Math.max(minHeight,extY + elementMinHeight);
            }
         }
         layoutTarget.measuredWidth = Math.ceil(Math.max(width,minWidth));
         layoutTarget.measuredHeight = Math.ceil(Math.max(height,minHeight));
         layoutTarget.measuredMinWidth = Math.ceil(minWidth);
         layoutTarget.measuredMinHeight = Math.ceil(minHeight);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var layoutElement:ILayoutElement = null;
         var hCenter:Number = NaN;
         var vCenter:Number = NaN;
         var baseline:Number = NaN;
         var left:Number = NaN;
         var right:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var percentWidth:Number = NaN;
         var percentHeight:Number = NaN;
         var elementMaxWidth:Number = NaN;
         var elementMaxHeight:Number = NaN;
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var elementWidth:Number = NaN;
         var elementHeight:Number = NaN;
         var childX:Number = NaN;
         var childY:Number = NaN;
         var availableWidth:Number = NaN;
         var availableHeight:Number = NaN;
         this.checkUseVirtualLayout();
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var count:int = layoutTarget.numElements;
         var maxX:Number = 0;
         var maxY:Number = 0;
         for(var i:int = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               hCenter = LayoutElementHelper.parseConstraintValue(layoutElement.horizontalCenter);
               vCenter = LayoutElementHelper.parseConstraintValue(layoutElement.verticalCenter);
               baseline = LayoutElementHelper.parseConstraintValue(layoutElement.baseline);
               left = LayoutElementHelper.parseConstraintValue(layoutElement.left);
               right = LayoutElementHelper.parseConstraintValue(layoutElement.right);
               top = LayoutElementHelper.parseConstraintValue(layoutElement.top);
               bottom = LayoutElementHelper.parseConstraintValue(layoutElement.bottom);
               percentWidth = Number(layoutElement.percentWidth);
               percentHeight = Number(layoutElement.percentHeight);
               elementMaxWidth = NaN;
               elementMaxHeight = NaN;
               childWidth = NaN;
               childHeight = NaN;
               if(!isNaN(percentWidth))
               {
                  availableWidth = unscaledWidth;
                  if(!isNaN(left))
                  {
                     availableWidth -= left;
                  }
                  if(!isNaN(right))
                  {
                     availableWidth -= right;
                  }
                  childWidth = Math.round(availableWidth * Math.min(percentWidth * 0.01,1));
                  elementMaxWidth = Math.min(layoutElement.getMaxBoundsWidth(),maxSizeToFitIn(unscaledWidth,hCenter,left,right,layoutElement.getLayoutBoundsX()));
               }
               else if(!isNaN(left) && !isNaN(right))
               {
                  childWidth = unscaledWidth - right - left;
               }
               if(!isNaN(percentHeight))
               {
                  availableHeight = unscaledHeight;
                  if(!isNaN(top))
                  {
                     availableHeight -= top;
                  }
                  if(!isNaN(bottom))
                  {
                     availableHeight -= bottom;
                  }
                  childHeight = Math.round(availableHeight * Math.min(percentHeight * 0.01,1));
                  elementMaxHeight = Math.min(layoutElement.getMaxBoundsHeight(),maxSizeToFitIn(unscaledHeight,vCenter,top,bottom,layoutElement.getLayoutBoundsY()));
               }
               else if(!isNaN(top) && !isNaN(bottom))
               {
                  childHeight = unscaledHeight - bottom - top;
               }
               if(!isNaN(childWidth))
               {
                  if(isNaN(elementMaxWidth))
                  {
                     elementMaxWidth = Number(layoutElement.getMaxBoundsWidth());
                  }
                  childWidth = Math.max(layoutElement.getMinBoundsWidth(),Math.min(elementMaxWidth,childWidth));
               }
               if(!isNaN(childHeight))
               {
                  if(isNaN(elementMaxHeight))
                  {
                     elementMaxHeight = Number(layoutElement.getMaxBoundsHeight());
                  }
                  childHeight = Math.max(layoutElement.getMinBoundsHeight(),Math.min(elementMaxHeight,childHeight));
               }
               layoutElement.setLayoutBoundsSize(childWidth,childHeight);
               elementWidth = Number(layoutElement.getLayoutBoundsWidth());
               elementHeight = Number(layoutElement.getLayoutBoundsHeight());
               childX = NaN;
               childY = NaN;
               if(!isNaN(hCenter))
               {
                  childX = Math.round((unscaledWidth - elementWidth) / 2 + hCenter);
               }
               else if(!isNaN(left))
               {
                  childX = left;
               }
               else if(!isNaN(right))
               {
                  childX = unscaledWidth - elementWidth - right;
               }
               else
               {
                  childX = Number(layoutElement.getLayoutBoundsX());
               }
               if(!isNaN(vCenter))
               {
                  childY = Math.round((unscaledHeight - elementHeight) / 2 + vCenter);
               }
               else if(!isNaN(baseline))
               {
                  childY = Math.round(baseline - IVisualElement(layoutElement).baselinePosition);
               }
               else if(!isNaN(top))
               {
                  childY = top;
               }
               else if(!isNaN(bottom))
               {
                  childY = unscaledHeight - elementHeight - bottom;
               }
               else
               {
                  childY = Number(layoutElement.getLayoutBoundsY());
               }
               layoutElement.setLayoutBoundsPosition(childX,childY);
               maxX = Math.max(maxX,childX + elementWidth);
               maxY = Math.max(maxY,childY + elementHeight);
            }
         }
         layoutTarget.setContentSize(Math.ceil(maxX),Math.ceil(maxY));
      }
   }
}

