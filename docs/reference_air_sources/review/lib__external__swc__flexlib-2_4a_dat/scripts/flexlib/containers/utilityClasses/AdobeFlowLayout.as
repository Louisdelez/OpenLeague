package flexlib.containers.utilityClasses
{
   import mx.containers.utilityClasses.Layout;
   import mx.controls.VRule;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   
   [ExcludeClass]
   public class AdobeFlowLayout extends Layout
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitHeightSet:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitMeasuredHeight:int = 0;
      
      private var lastWidth:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var modifyTargetHeight:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var rowCount:int = -1;
      
      public function AdobeFlowLayout()
      {
         super();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var target:Container = null;
         var vm:EdgeMetrics = null;
         var horizontalGap:Number = NaN;
         var verticalGap:Number = NaN;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var maxYPos:Number = NaN;
         var n:int = 0;
         var child:IUIComponent = null;
         var lastChild:IUIComponent = null;
         var childWidth:int = 0;
         var childHeight:int = 0;
         var popupIndex:int = 0;
         var xEnd:Number = NaN;
         var full:Boolean = false;
         var remainingRows:int = 0;
         var xWrapWidth:int = 0;
         var i:int = 0;
         var numLines:int = 0;
         target = Container(super.target);
         vm = target.viewMetricsAndPadding;
         horizontalGap = Number(target.getStyle("horizontalGap"));
         verticalGap = Number(target.getStyle("verticalGap"));
         xPos = Number(vm.left);
         yPos = Number(vm.top);
         maxYPos = 0;
         n = int(target.numChildren);
         popupIndex = 0;
         xEnd = unscaledWidth - vm.right;
         full = false;
         remainingRows = 65535;
         xWrapWidth = 65535;
         if(rowCount > 0 && Boolean(target.parent))
         {
            numLines = target.parent.height / target.measuredHeight;
            xWrapWidth = target.measuredWidth / rowCount;
            remainingRows = rowCount - 1;
         }
         for(i = 0; i < target.numChildren; i++)
         {
            child = IUIComponent(target.getChildAt(i));
            if(child.includeInLayout)
            {
               childWidth = int(child.getExplicitOrMeasuredWidth());
               childHeight = int(child.getExplicitOrMeasuredHeight());
               if(!full)
               {
                  if((xPos + childWidth > xEnd && xPos != vm.left || xPos > xWrapWidth) && Boolean(remainingRows))
                  {
                     yPos = maxYPos + verticalGap;
                     remainingRows--;
                     xPos = Number(vm.left);
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
               }
               child.setActualSize(childWidth,childHeight);
               child.move(xPos,yPos);
               lastChild = child;
               maxYPos = Math.max(maxYPos,yPos + childHeight);
               xPos += childWidth + horizontalGap;
            }
         }
         maxYPos += vm.bottom;
         if(target.height != maxYPos && isNaN(target.percentHeight) && !explicitHeightSet)
         {
            if(modifyTargetHeight)
            {
               target.height = maxYPos;
            }
            else
            {
               explicitMeasuredHeight = target.measuredHeight = maxYPos;
               target.height = NaN;
            }
            explicitHeightSet = false;
            if(lastWidth != unscaledWidth)
            {
               target.callLater(target.invalidateDisplayList);
               lastWidth = unscaledWidth;
            }
         }
      }
      
      override public function measure() : void
      {
         var target:Container = null;
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var n:int = 0;
         var numGaps:int = 0;
         var i:int = 0;
         var vm:EdgeMetrics = null;
         var wPadding:Number = NaN;
         var hPadding:Number = NaN;
         var child:IUIComponent = null;
         var wPref:Number = NaN;
         var hPref:Number = NaN;
         target = Container(super.target);
         minWidth = 0;
         minHeight = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         n = int(target.numChildren);
         numGaps = -1;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(target.getChildAt(i));
            if(child.includeInLayout)
            {
               numGaps++;
               wPref = Number(child.getExplicitOrMeasuredWidth());
               hPref = Number(child.getExplicitOrMeasuredHeight());
               minWidth = Math.max(minWidth,child.minWidth);
               minHeight = Math.max(minHeight,hPref);
               preferredWidth += wPref;
            }
         }
         vm = target.viewMetricsAndPadding;
         wPadding = vm.left + vm.right + numGaps * target.getStyle("horizontalGap");
         hPadding = vm.top + vm.bottom;
         target.measuredMinWidth = minWidth + wPadding;
         target.measuredMinHeight = minHeight + hPadding;
         if(rowCount > 1)
         {
            target.measuredWidth = preferredWidth / rowCount + wPadding + minWidth;
         }
         else
         {
            target.measuredWidth = preferredWidth + wPadding;
         }
         target.measuredHeight = minHeight + hPadding;
         if(Boolean(explicitMeasuredHeight))
         {
            target.measuredMinHeight = target.measuredHeight = explicitMeasuredHeight;
         }
      }
   }
}

