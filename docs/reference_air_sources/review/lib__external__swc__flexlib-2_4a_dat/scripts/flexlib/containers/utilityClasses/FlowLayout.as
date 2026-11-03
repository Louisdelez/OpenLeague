package flexlib.containers.utilityClasses
{
   import mx.containers.BoxDirection;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   
   public class FlowLayout extends BoxLayout
   {
      
      public function FlowLayout()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
      }
      
      override public function measure() : void
      {
         direction = BoxDirection.VERTICAL;
         super.measure();
         direction = BoxDirection.HORIZONTAL;
         if(!isNaN(target.explicitWidth))
         {
            doLayout(target.explicitWidth,false);
         }
         else if(!isNaN(target.percentWidth) && target.parent is UIComponent && !isNaN(UIComponent(target.parent).explicitWidth))
         {
            doLayout(UIComponent(target.parent).explicitWidth * target.percentWidth / 100,false);
         }
      }
      
      private function doLayout(unscaledWidth:Number, moveChildren:Boolean) : void
      {
         var vm:EdgeMetrics = null;
         var hAlign:Number = NaN;
         var vAlign:Number = NaN;
         var hGap:Number = NaN;
         var vGap:Number = NaN;
         var len:Number = NaN;
         var currentRowChildren:Array = null;
         var currentRowHeight:Number = NaN;
         var currentRowY:Number = NaN;
         var currentRowLastX:Number = NaN;
         var child:IFlexDisplayObject = null;
         var tmpChild:IFlexDisplayObject = null;
         var rowExcessSpace:Number = NaN;
         var top:Number = NaN;
         var maxX:Number = NaN;
         var maxY:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingLeft:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         vm = target.viewMetricsAndPadding;
         hAlign = Number(getHorizontalAlignValue());
         vAlign = Number(getVerticalAlignValue());
         hGap = Number(target.getStyle("horizontalGap"));
         vGap = Number(target.getStyle("verticalGap"));
         len = Number(target.numChildren);
         currentRowChildren = new Array();
         currentRowHeight = 0;
         currentRowY = Number(vm.top);
         currentRowLastX = Number(vm.left);
         paddingRight = target.getStyle("paddingRight") + target.borderMetrics.right;
         paddingLeft = target.getStyle("paddingLeft") + target.borderMetrics.left;
         for(i = 0; i < len; i++)
         {
            child = IFlexDisplayObject(target.getChildAt(i));
            if(!(child is UIComponent && !UIComponent(child).includeInLayout))
            {
               if(currentRowLastX + child.width > unscaledWidth - paddingRight)
               {
                  currentRowLastX -= hGap;
                  rowExcessSpace = unscaledWidth - paddingRight - currentRowLastX;
                  rowExcessSpace *= hAlign;
                  currentRowLastX = rowExcessSpace == 0 ? paddingLeft : rowExcessSpace;
                  for(j = 0; j < currentRowChildren.length; j++)
                  {
                     tmpChild = currentRowChildren[j];
                     top = (currentRowHeight - tmpChild.height) * vAlign;
                     if(moveChildren)
                     {
                        tmpChild.move(Math.floor(currentRowLastX),currentRowY + Math.floor(top));
                     }
                     currentRowLastX += tmpChild.width + hGap;
                  }
                  currentRowY += currentRowHeight + vGap;
                  currentRowLastX = paddingLeft;
                  currentRowHeight = 0;
                  currentRowChildren = [];
               }
               currentRowLastX += child.width + hGap;
               currentRowChildren.push(child);
               currentRowHeight = Math.max(child.height,currentRowHeight);
            }
         }
         currentRowLastX -= hGap;
         rowExcessSpace = unscaledWidth - paddingRight - currentRowLastX;
         rowExcessSpace *= hAlign;
         currentRowLastX = rowExcessSpace == 0 ? paddingLeft : rowExcessSpace;
         for(j = 0; j < currentRowChildren.length; j++)
         {
            tmpChild = currentRowChildren[j];
            top = (currentRowHeight - tmpChild.height) * vAlign;
            if(moveChildren)
            {
               tmpChild.move(Math.floor(currentRowLastX),currentRowY + Math.floor(top));
            }
            currentRowLastX += hGap + tmpChild.width;
         }
         if(!moveChildren)
         {
            target.measuredHeight = currentRowY + currentRowHeight + vm.bottom + vm.top;
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         doLayout(unscaledWidth,true);
      }
   }
}

