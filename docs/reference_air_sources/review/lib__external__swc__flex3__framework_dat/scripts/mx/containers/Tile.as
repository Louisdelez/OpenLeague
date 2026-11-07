package mx.containers
{
   import flash.events.Event;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("Tile.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   public class Tile extends Container
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _direction:String = "horizontal";
      
      mx_internal var cellWidth:Number;
      
      mx_internal var cellHeight:Number;
      
      private var _tileHeight:Number;
      
      private var _tileWidth:Number;
      
      public function Tile()
      {
         super();
      }
      
      override protected function measure() : void
      {
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var minWidth:Number = NaN;
         var minHeight:Number = NaN;
         var horizontalGap:Number = NaN;
         var verticalGap:Number = NaN;
         var majorAxis:Number = NaN;
         var minorAxis:Number = NaN;
         var unscaledExplicitWidth:Number = NaN;
         var unscaledExplicitHeight:Number = NaN;
         super.measure();
         findCellSize();
         minWidth = cellWidth;
         minHeight = cellHeight;
         var n:int = numChildren;
         var temp:int = n;
         for(var i:int = 0; i < n; i++)
         {
            if(!IUIComponent(getChildAt(i)).includeInLayout)
            {
               temp--;
            }
         }
         n = temp;
         if(n > 0)
         {
            horizontalGap = getStyle("horizontalGap");
            verticalGap = getStyle("verticalGap");
            if(direction == TileDirection.HORIZONTAL)
            {
               unscaledExplicitWidth = explicitWidth / Math.abs(scaleX);
               if(!isNaN(unscaledExplicitWidth))
               {
                  majorAxis = Math.floor((unscaledExplicitWidth + horizontalGap) / (cellWidth + horizontalGap));
               }
            }
            else
            {
               unscaledExplicitHeight = explicitHeight / Math.abs(scaleY);
               if(!isNaN(unscaledExplicitHeight))
               {
                  majorAxis = Math.floor((unscaledExplicitHeight + verticalGap) / (cellHeight + verticalGap));
               }
            }
            if(isNaN(majorAxis))
            {
               majorAxis = Math.ceil(Math.sqrt(n));
            }
            if(majorAxis < 1)
            {
               majorAxis = 1;
            }
            minorAxis = Math.ceil(n / majorAxis);
            if(direction == TileDirection.HORIZONTAL)
            {
               preferredWidth = majorAxis * cellWidth + (majorAxis - 1) * horizontalGap;
               preferredHeight = minorAxis * cellHeight + (minorAxis - 1) * verticalGap;
            }
            else
            {
               preferredWidth = minorAxis * cellWidth + (minorAxis - 1) * horizontalGap;
               preferredHeight = majorAxis * cellHeight + (majorAxis - 1) * verticalGap;
            }
         }
         else
         {
            preferredWidth = minWidth;
            preferredHeight = minHeight;
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var hPadding:Number = vm.left + vm.right;
         var vPadding:Number = vm.top + vm.bottom;
         minWidth += hPadding;
         preferredWidth += hPadding;
         minHeight += vPadding;
         preferredHeight += vPadding;
         measuredMinWidth = Math.ceil(minWidth);
         measuredMinHeight = Math.ceil(minHeight);
         measuredWidth = Math.ceil(preferredWidth);
         measuredHeight = Math.ceil(preferredHeight);
      }
      
      public function set tileHeight(value:Number) : void
      {
         _tileHeight = value;
         invalidateSize();
      }
      
      mx_internal function calcHorizontalOffset(width:Number, horizontalAlign:String) : Number
      {
         var xOffset:Number = NaN;
         if(horizontalAlign == "left")
         {
            xOffset = 0;
         }
         else if(horizontalAlign == "center")
         {
            xOffset = (cellWidth - width) / 2;
         }
         else if(horizontalAlign == "right")
         {
            xOffset = cellWidth - width;
         }
         return xOffset;
      }
      
      mx_internal function calcVerticalOffset(height:Number, verticalAlign:String) : Number
      {
         var yOffset:Number = NaN;
         if(verticalAlign == "top")
         {
            yOffset = 0;
         }
         else if(verticalAlign == "middle")
         {
            yOffset = (cellHeight - height) / 2;
         }
         else if(verticalAlign == "bottom")
         {
            yOffset = cellHeight - height;
         }
         return yOffset;
      }
      
      public function set tileWidth(value:Number) : void
      {
         _tileWidth = value;
         invalidateSize();
      }
      
      [Inspectable(category="General")]
      [Bindable("resize")]
      public function get tileHeight() : Number
      {
         return _tileHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var i:int = 0;
         var child:IUIComponent = null;
         var xEnd:Number = NaN;
         var yEnd:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(isNaN(cellWidth) || isNaN(cellHeight))
         {
            findCellSize();
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var horizontalAlign:String = getStyle("horizontalAlign");
         var verticalAlign:String = getStyle("verticalAlign");
         var xPos:Number = paddingLeft;
         var yPos:Number = paddingTop;
         var n:int = numChildren;
         if(direction == TileDirection.HORIZONTAL)
         {
            xEnd = Math.ceil(unscaledWidth) - vm.right;
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  if(xPos + cellWidth > xEnd)
                  {
                     if(xPos != paddingLeft)
                     {
                        yPos += cellHeight + verticalGap;
                        xPos = paddingLeft;
                     }
                  }
                  setChildSize(child);
                  xOffset = Math.floor(calcHorizontalOffset(child.width,horizontalAlign));
                  yOffset = Math.floor(calcVerticalOffset(child.height,verticalAlign));
                  child.move(xPos + xOffset,yPos + yOffset);
                  xPos += cellWidth + horizontalGap;
               }
            }
         }
         else
         {
            yEnd = Math.ceil(unscaledHeight) - vm.bottom;
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  if(yPos + cellHeight > yEnd)
                  {
                     if(yPos != paddingTop)
                     {
                        xPos += cellWidth + horizontalGap;
                        yPos = paddingTop;
                     }
                  }
                  setChildSize(child);
                  xOffset = Math.floor(calcHorizontalOffset(child.width,horizontalAlign));
                  yOffset = Math.floor(calcVerticalOffset(child.height,verticalAlign));
                  child.move(xPos + xOffset,yPos + yOffset);
                  yPos += cellHeight + verticalGap;
               }
            }
         }
         cellWidth = NaN;
         cellHeight = NaN;
      }
      
      [Inspectable(category="General")]
      [Bindable("resize")]
      public function get tileWidth() : Number
      {
         return _tileWidth;
      }
      
      private function setChildSize(child:IUIComponent) : void
      {
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var childPref:Number = NaN;
         var childMin:Number = NaN;
         if(child.percentWidth > 0)
         {
            childWidth = Math.min(cellWidth,cellWidth * child.percentWidth / 100);
         }
         else
         {
            childWidth = child.getExplicitOrMeasuredWidth();
            if(childWidth > cellWidth)
            {
               childPref = isNaN(child.explicitWidth) ? 0 : child.explicitWidth;
               childMin = isNaN(child.explicitMinWidth) ? 0 : child.explicitMinWidth;
               childWidth = childPref > cellWidth || childMin > cellWidth ? Math.max(childMin,childPref) : cellWidth;
            }
         }
         if(child.percentHeight > 0)
         {
            childHeight = Math.min(cellHeight,cellHeight * child.percentHeight / 100);
         }
         else
         {
            childHeight = child.getExplicitOrMeasuredHeight();
            if(childHeight > cellHeight)
            {
               childPref = isNaN(child.explicitHeight) ? 0 : child.explicitHeight;
               childMin = isNaN(child.explicitMinHeight) ? 0 : child.explicitMinHeight;
               childHeight = childPref > cellHeight || childMin > cellHeight ? Math.max(childMin,childPref) : cellHeight;
            }
         }
         child.setActualSize(childWidth,childHeight);
      }
      
      mx_internal function findCellSize() : void
      {
         var child:IUIComponent = null;
         var width:Number = NaN;
         var height:Number = NaN;
         var widthSpecified:Boolean = !isNaN(tileWidth);
         var heightSpecified:Boolean = !isNaN(tileHeight);
         if(widthSpecified && heightSpecified)
         {
            cellWidth = tileWidth;
            cellHeight = tileHeight;
            return;
         }
         var maxChildWidth:Number = 0;
         var maxChildHeight:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               width = child.getExplicitOrMeasuredWidth();
               if(width > maxChildWidth)
               {
                  maxChildWidth = width;
               }
               height = child.getExplicitOrMeasuredHeight();
               if(height > maxChildHeight)
               {
                  maxChildHeight = height;
               }
            }
         }
         cellWidth = widthSpecified ? tileWidth : maxChildWidth;
         cellHeight = heightSpecified ? tileHeight : maxChildHeight;
      }
      
      public function set direction(value:String) : void
      {
         _direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="horizontal")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
   }
}

