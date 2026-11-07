package mx.controls.richTextEditorClasses
{
   import mx.controls.VRule;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class ToolBar extends Container
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function ToolBar()
      {
         super();
      }
      
      override protected function measure() : void
      {
         var hPadding:Number = NaN;
         var child:IUIComponent = null;
         var wPref:Number = NaN;
         var hPref:Number = NaN;
         super.measure();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var preferredWidth:Number = 0;
         var preferredHeight:Number = 0;
         var n:int = numChildren;
         var numGaps:int = -1;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               numGaps++;
               wPref = child.getExplicitOrMeasuredWidth();
               hPref = child.getExplicitOrMeasuredHeight();
               minWidth = Math.max(minWidth,wPref);
               minHeight = Math.max(minHeight,hPref);
               preferredWidth += wPref;
            }
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var wPadding:Number = vm.left + vm.right + numGaps * getStyle("horizontalGap");
         hPadding = vm.top + vm.bottom;
         measuredMinWidth = minWidth + wPadding;
         measuredMinHeight = minHeight + hPadding;
         measuredWidth = preferredWidth + wPadding;
         measuredHeight = minHeight + hPadding;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var lastChild:IUIComponent = null;
         var childWidth:int = 0;
         var childHeight:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var xPos:Number = vm.left;
         var yPos:Number = vm.top;
         var maxYPos:Number = 0;
         var n:int = numChildren;
         var xEnd:Number = unscaledWidth - vm.right;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               childWidth = child.getExplicitOrMeasuredWidth();
               childHeight = child.getExplicitOrMeasuredHeight();
               if(xPos + childWidth > xEnd && xPos != vm.left)
               {
                  yPos = maxYPos + verticalGap;
                  xPos = vm.left;
                  if(child is VRule)
                  {
                     child.setActualSize(0,0);
                     child.move(xPos,yPos);
                     continue;
                  }
                  if(lastChild is VRule)
                  {
                     lastChild.setActualSize(0,0);
                  }
               }
               child.setActualSize(childWidth,childHeight);
               child.move(xPos,yPos);
               lastChild = child;
               maxYPos = Math.max(maxYPos,yPos + childHeight);
               xPos += childWidth + horizontalGap;
            }
         }
         maxYPos += vm.bottom;
         if(height != maxYPos)
         {
            height = maxYPos;
         }
      }
   }
}

