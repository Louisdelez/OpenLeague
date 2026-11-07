package mx.containers.utilityClasses
{
   import mx.containers.BoxDirection;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   
   [ExcludeClass]
   public class BoxLayout extends Layout
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var direction:String = "vertical";
      
      public function BoxLayout()
      {
         super();
      }
      
      override public function measure() : void
      {
         var target:Container = null;
         var wPadding:Number = NaN;
         var hPadding:Number = NaN;
         var child:IUIComponent = null;
         var wPref:Number = NaN;
         var hPref:Number = NaN;
         target = super.target;
         var isVertical:Boolean = this.isVertical();
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var preferredWidth:Number = 0;
         var preferredHeight:Number = 0;
         var n:int = target.numChildren;
         var numChildrenWithOwnSpace:int = n;
         for(var i:int = 0; i < n; i++)
         {
            child = target.getLayoutChildAt(i);
            if(!child.includeInLayout)
            {
               numChildrenWithOwnSpace--;
            }
            else
            {
               wPref = Number(child.getExplicitOrMeasuredWidth());
               hPref = Number(child.getExplicitOrMeasuredHeight());
               if(isVertical)
               {
                  minWidth = Math.max(!isNaN(child.percentWidth) ? Number(child.minWidth) : wPref,minWidth);
                  preferredWidth = Math.max(wPref,preferredWidth);
                  minHeight += !isNaN(child.percentHeight) ? child.minHeight : hPref;
                  preferredHeight += hPref;
               }
               else
               {
                  minWidth += !isNaN(child.percentWidth) ? child.minWidth : wPref;
                  preferredWidth += wPref;
                  minHeight = Math.max(!isNaN(child.percentHeight) ? Number(child.minHeight) : hPref,minHeight);
                  preferredHeight = Math.max(hPref,preferredHeight);
               }
            }
         }
         wPadding = this.widthPadding(numChildrenWithOwnSpace);
         hPadding = this.heightPadding(numChildrenWithOwnSpace);
         target.measuredMinWidth = minWidth + wPadding;
         target.measuredMinHeight = minHeight + hPadding;
         target.measuredWidth = preferredWidth + wPadding;
         target.measuredHeight = preferredHeight + hPadding;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var gap:Number = NaN;
         var numChildrenWithOwnSpace:int = 0;
         var excessSpace:Number = NaN;
         var top:Number = NaN;
         var left:Number = NaN;
         var i:int = 0;
         var obj:IUIComponent = null;
         var child:IUIComponent = null;
         var percentWidth:Number = NaN;
         var percentHeight:Number = NaN;
         var width:Number = NaN;
         var height:Number = NaN;
         var target:Container = super.target;
         var n:int = target.numChildren;
         if(n == 0)
         {
            return;
         }
         var vm:EdgeMetrics = target.viewMetricsAndPadding;
         var paddingLeft:Number = Number(target.getStyle("paddingLeft"));
         var paddingTop:Number = Number(target.getStyle("paddingTop"));
         var horizontalAlign:Number = this.getHorizontalAlignValue();
         var verticalAlign:Number = this.getVerticalAlignValue();
         var mw:Number = target.scaleX > 0 && target.scaleX != 1 ? target.minWidth / Math.abs(target.scaleX) : Number(target.minWidth);
         var mh:Number = target.scaleY > 0 && target.scaleY != 1 ? target.minHeight / Math.abs(target.scaleY) : Number(target.minHeight);
         var w:Number = Math.max(unscaledWidth,mw) - vm.right - vm.left;
         var h:Number = Math.max(unscaledHeight,mh) - vm.bottom - vm.top;
         var horizontalScrollBar:ScrollBar = target.horizontalScrollBar;
         var verticalScrollBar:ScrollBar = target.verticalScrollBar;
         if(n == 1)
         {
            child = target.getLayoutChildAt(0);
            percentWidth = Number(child.percentWidth);
            percentHeight = Number(child.percentHeight);
            if(Boolean(percentWidth))
            {
               width = Math.max(child.minWidth,Math.min(child.maxWidth,percentWidth >= 100 ? w : w * percentWidth / 100));
            }
            else
            {
               width = Number(child.getExplicitOrMeasuredWidth());
            }
            if(Boolean(percentHeight))
            {
               height = Math.max(child.minHeight,Math.min(child.maxHeight,percentHeight >= 100 ? h : h * percentHeight / 100));
            }
            else
            {
               height = Number(child.getExplicitOrMeasuredHeight());
            }
            if(child.scaleX == 1 && child.scaleY == 1)
            {
               child.setActualSize(Math.floor(width),Math.floor(height));
            }
            else
            {
               child.setActualSize(width,height);
            }
            if(verticalScrollBar != null && target.verticalScrollPolicy == ScrollPolicy.AUTO)
            {
               w += verticalScrollBar.minWidth;
            }
            if(horizontalScrollBar != null && target.horizontalScrollPolicy == ScrollPolicy.AUTO)
            {
               h += horizontalScrollBar.minHeight;
            }
            left = (w - child.width) * horizontalAlign + paddingLeft;
            top = (h - child.height) * verticalAlign + paddingTop;
            child.move(Math.floor(left),Math.floor(top));
         }
         else if(this.isVertical())
         {
            gap = Number(target.getStyle("verticalGap"));
            numChildrenWithOwnSpace = n;
            for(i = 0; i < n; i++)
            {
               if(!IUIComponent(target.getChildAt(i)).includeInLayout)
               {
                  numChildrenWithOwnSpace--;
               }
            }
            excessSpace = Number(Flex.flexChildHeightsProportionally(target,h - (numChildrenWithOwnSpace - 1) * gap,w));
            if(horizontalScrollBar != null && target.horizontalScrollPolicy == ScrollPolicy.AUTO)
            {
               excessSpace += horizontalScrollBar.minHeight;
            }
            if(verticalScrollBar != null && target.verticalScrollPolicy == ScrollPolicy.AUTO)
            {
               w += verticalScrollBar.minWidth;
            }
            top = paddingTop + excessSpace * verticalAlign;
            for(i = 0; i < n; i++)
            {
               obj = target.getLayoutChildAt(i);
               left = (w - obj.width) * horizontalAlign + paddingLeft;
               obj.move(Math.floor(left),Math.floor(top));
               if(obj.includeInLayout)
               {
                  top += obj.height + gap;
               }
            }
         }
         else
         {
            gap = Number(target.getStyle("horizontalGap"));
            numChildrenWithOwnSpace = n;
            for(i = 0; i < n; i++)
            {
               if(!IUIComponent(target.getChildAt(i)).includeInLayout)
               {
                  numChildrenWithOwnSpace--;
               }
            }
            excessSpace = Number(Flex.flexChildWidthsProportionally(target,w - (numChildrenWithOwnSpace - 1) * gap,h));
            if(horizontalScrollBar != null && target.horizontalScrollPolicy == ScrollPolicy.AUTO)
            {
               h += horizontalScrollBar.minHeight;
            }
            if(verticalScrollBar != null && target.verticalScrollPolicy == ScrollPolicy.AUTO)
            {
               excessSpace += verticalScrollBar.minWidth;
            }
            left = paddingLeft + excessSpace * horizontalAlign;
            for(i = 0; i < n; i++)
            {
               obj = target.getLayoutChildAt(i);
               top = (h - obj.height) * verticalAlign + paddingTop;
               obj.move(Math.floor(left),Math.floor(top));
               if(obj.includeInLayout)
               {
                  left += obj.width + gap;
               }
            }
         }
      }
      
      private function isVertical() : Boolean
      {
         return this.direction != BoxDirection.HORIZONTAL;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function widthPadding(numChildren:Number) : Number
      {
         var vm:EdgeMetrics = target.viewMetricsAndPadding;
         var padding:Number = vm.left + vm.right;
         if(numChildren > 1 && this.isVertical() == false)
         {
            padding += target.getStyle("horizontalGap") * (numChildren - 1);
         }
         return padding;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function heightPadding(numChildren:Number) : Number
      {
         var vm:EdgeMetrics = target.viewMetricsAndPadding;
         var padding:Number = vm.top + vm.bottom;
         if(numChildren > 1 && this.isVertical())
         {
            padding += target.getStyle("verticalGap") * (numChildren - 1);
         }
         return padding;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHorizontalAlignValue() : Number
      {
         var horizontalAlign:String = target.getStyle("horizontalAlign");
         if(horizontalAlign == "center")
         {
            return 0.5;
         }
         if(horizontalAlign == "right")
         {
            return 1;
         }
         return 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getVerticalAlignValue() : Number
      {
         var verticalAlign:String = target.getStyle("verticalAlign");
         if(verticalAlign == "middle")
         {
            return 0.5;
         }
         if(verticalAlign == "bottom")
         {
            return 1;
         }
         return 0;
      }
   }
}

