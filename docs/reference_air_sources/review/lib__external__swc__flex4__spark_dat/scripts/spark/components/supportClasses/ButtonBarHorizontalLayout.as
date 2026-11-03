package spark.components.supportClasses
{
   import mx.core.ILayoutElement;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class ButtonBarHorizontalLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _gap:int = 0;
      
      public function ButtonBarHorizontalLayout()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get gap() : int
      {
         return this._gap;
      }
      
      public function set gap(value:int) : void
      {
         if(this._gap == value)
         {
            return;
         }
         this._gap = value;
         var g:GroupBase = target;
         if(Boolean(g))
         {
            g.invalidateSize();
            g.invalidateDisplayList();
         }
      }
      
      override public function measure() : void
      {
         var layoutElement:ILayoutElement = null;
         super.measure();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var elementCount:int = 0;
         var gap:Number = this.gap;
         var width:Number = 0;
         var height:Number = 0;
         var count:int = layoutTarget.numElements;
         for(var i:int = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               width += layoutElement.getPreferredBoundsWidth();
               elementCount++;
               height = Math.max(height,layoutElement.getPreferredBoundsHeight());
            }
         }
         if(elementCount > 1)
         {
            width += gap * (elementCount - 1);
         }
         layoutTarget.measuredWidth = width;
         layoutTarget.measuredHeight = height;
      }
      
      override public function updateDisplayList(width:Number, height:Number) : void
      {
         var layoutElement:ILayoutElement = null;
         var averageWidth:Number = NaN;
         var preferredWidth:Number = NaN;
         var gap:Number = this.gap;
         super.updateDisplayList(width,height);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var totalPreferredWidth:Number = 0;
         var count:int = layoutTarget.numElements;
         var elementCount:int = count;
         for(var i:int = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!layoutElement || !layoutElement.includeInLayout)
            {
               elementCount--;
            }
            else
            {
               totalPreferredWidth += layoutElement.getPreferredBoundsWidth();
            }
         }
         if(elementCount == 0)
         {
            layoutTarget.setContentSize(0,0);
            return;
         }
         layoutTarget.setContentSize(width,height);
         if(width == 0)
         {
            gap = 0;
         }
         var excessSpace:Number = width - totalPreferredWidth - gap * (elementCount - 1);
         var widthToDistribute:Number = width - gap * (elementCount - 1);
         var largeChildrenCount:int = elementCount;
         if(excessSpace < 0)
         {
            averageWidth = width / elementCount;
            for(i = 0; i < count; i++)
            {
               layoutElement = layoutTarget.getElementAt(i);
               if(!(!layoutElement || !layoutElement.includeInLayout))
               {
                  preferredWidth = Number(layoutElement.getPreferredBoundsWidth());
                  if(preferredWidth <= averageWidth)
                  {
                     widthToDistribute -= preferredWidth;
                     largeChildrenCount--;
                  }
               }
            }
            widthToDistribute = Math.max(0,widthToDistribute);
         }
         var x:Number = 0;
         var childWidth:Number = NaN;
         var childWidthRounded:Number = NaN;
         var roundOff:Number = 0;
         for(i = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               if(excessSpace > 0)
               {
                  childWidth = widthToDistribute * layoutElement.getPreferredBoundsWidth() / totalPreferredWidth;
               }
               else if(excessSpace < 0)
               {
                  childWidth = averageWidth < layoutElement.getPreferredBoundsWidth() ? widthToDistribute / largeChildrenCount : NaN;
               }
               if(!isNaN(childWidth))
               {
                  childWidthRounded = Math.round(childWidth + roundOff);
                  roundOff += childWidth - childWidthRounded;
               }
               layoutElement.setLayoutBoundsSize(childWidthRounded,height);
               layoutElement.setLayoutBoundsPosition(x,0);
               x += gap + layoutElement.getLayoutBoundsWidth();
               childWidthRounded = NaN;
            }
         }
      }
   }
}

