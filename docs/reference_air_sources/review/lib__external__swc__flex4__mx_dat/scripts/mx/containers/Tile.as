package mx.containers
{
   import flash.events.Event;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IUIComponent;
   
   [Alternative(replacement="spark.components.BorderContainer",since="4.0")]
   [Alternative(replacement="spark.components.TileGroup",since="4.0")]
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cellWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cellHeight:Number;
      
      private var _direction:String = "horizontal";
      
      private var _tileHeight:Number;
      
      private var _tileWidth:Number;
      
      public function Tile()
      {
         super();
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="horizontal")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Inspectable(category="General")]
      [Bindable("resize")]
      public function get tileHeight() : Number
      {
         return this._tileHeight;
      }
      
      public function set tileHeight(value:Number) : void
      {
         this._tileHeight = value;
         invalidateSize();
      }
      
      [Inspectable(category="General")]
      [Bindable("resize")]
      public function get tileWidth() : Number
      {
         return this._tileWidth;
      }
      
      public function set tileWidth(value:Number) : void
      {
         this._tileWidth = value;
         invalidateSize();
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
         this.findCellSize();
         minWidth = this.cellWidth;
         minHeight = this.cellHeight;
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
            horizontalGap = Number(getStyle("horizontalGap"));
            verticalGap = Number(getStyle("verticalGap"));
            if(this.direction == TileDirection.HORIZONTAL)
            {
               unscaledExplicitWidth = explicitWidth / Math.abs(scaleX);
               if(!isNaN(unscaledExplicitWidth))
               {
                  majorAxis = Math.floor((unscaledExplicitWidth + horizontalGap) / (this.cellWidth + horizontalGap));
               }
            }
            else
            {
               unscaledExplicitHeight = explicitHeight / Math.abs(scaleY);
               if(!isNaN(unscaledExplicitHeight))
               {
                  majorAxis = Math.floor((unscaledExplicitHeight + verticalGap) / (this.cellHeight + verticalGap));
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
            if(this.direction == TileDirection.HORIZONTAL)
            {
               preferredWidth = majorAxis * this.cellWidth + (majorAxis - 1) * horizontalGap;
               preferredHeight = minorAxis * this.cellHeight + (minorAxis - 1) * verticalGap;
            }
            else
            {
               preferredWidth = minorAxis * this.cellWidth + (minorAxis - 1) * horizontalGap;
               preferredHeight = majorAxis * this.cellHeight + (majorAxis - 1) * verticalGap;
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var i:int = 0;
         var child:IUIComponent = null;
         var xEnd:Number = NaN;
         var yEnd:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(isNaN(this.cellWidth) || isNaN(this.cellHeight))
         {
            this.findCellSize();
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var horizontalAlign:String = getStyle("horizontalAlign");
         var verticalAlign:String = getStyle("verticalAlign");
         var xPos:Number = paddingLeft;
         var yPos:Number = paddingTop;
         var n:int = numChildren;
         if(this.direction == TileDirection.HORIZONTAL)
         {
            xEnd = Math.ceil(unscaledWidth) - vm.right;
            for(i = 0; i < n; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  if(xPos + this.cellWidth > xEnd)
                  {
                     if(xPos != paddingLeft)
                     {
                        yPos += this.cellHeight + verticalGap;
                        xPos = paddingLeft;
                     }
                  }
                  this.setChildSize(child);
                  xOffset = Math.floor(this.calcHorizontalOffset(child.width,horizontalAlign));
                  yOffset = Math.floor(this.calcVerticalOffset(child.height,verticalAlign));
                  child.move(xPos + xOffset,yPos + yOffset);
                  xPos += this.cellWidth + horizontalGap;
               }
            }
         }
         else
         {
            yEnd = Math.ceil(unscaledHeight) - vm.bottom;
            for(i = 0; i < n; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  if(yPos + this.cellHeight > yEnd)
                  {
                     if(yPos != paddingTop)
                     {
                        xPos += this.cellWidth + horizontalGap;
                        yPos = paddingTop;
                     }
                  }
                  this.setChildSize(child);
                  xOffset = Math.floor(this.calcHorizontalOffset(child.width,horizontalAlign));
                  yOffset = Math.floor(this.calcVerticalOffset(child.height,verticalAlign));
                  child.move(xPos + xOffset,yPos + yOffset);
                  yPos += this.cellHeight + verticalGap;
               }
            }
         }
         this.cellWidth = NaN;
         this.cellHeight = NaN;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function findCellSize() : void
      {
         var child:IUIComponent = null;
         var width:Number = NaN;
         var height:Number = NaN;
         var widthSpecified:Boolean = !isNaN(this.tileWidth);
         var heightSpecified:Boolean = !isNaN(this.tileHeight);
         if(widthSpecified && heightSpecified)
         {
            this.cellWidth = this.tileWidth;
            this.cellHeight = this.tileHeight;
            return;
         }
         var maxChildWidth:Number = 0;
         var maxChildHeight:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            if(child.includeInLayout)
            {
               width = Number(child.getExplicitOrMeasuredWidth());
               if(width > maxChildWidth)
               {
                  maxChildWidth = width;
               }
               height = Number(child.getExplicitOrMeasuredHeight());
               if(height > maxChildHeight)
               {
                  maxChildHeight = height;
               }
            }
         }
         this.cellWidth = widthSpecified ? this.tileWidth : maxChildWidth;
         this.cellHeight = heightSpecified ? this.tileHeight : maxChildHeight;
      }
      
      private function setChildSize(child:IUIComponent) : void
      {
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var childPref:Number = NaN;
         var childMin:Number = NaN;
         if(child.percentWidth > 0)
         {
            childWidth = Math.min(this.cellWidth,this.cellWidth * child.percentWidth / 100);
         }
         else
         {
            childWidth = Number(child.getExplicitOrMeasuredWidth());
            if(childWidth > this.cellWidth)
            {
               childPref = isNaN(child.explicitWidth) ? 0 : Number(child.explicitWidth);
               childMin = isNaN(child.explicitMinWidth) ? 0 : Number(child.explicitMinWidth);
               childWidth = childPref > this.cellWidth || childMin > this.cellWidth ? Math.max(childMin,childPref) : this.cellWidth;
            }
         }
         if(child.percentHeight > 0)
         {
            childHeight = Math.min(this.cellHeight,this.cellHeight * child.percentHeight / 100);
         }
         else
         {
            childHeight = Number(child.getExplicitOrMeasuredHeight());
            if(childHeight > this.cellHeight)
            {
               childPref = isNaN(child.explicitHeight) ? 0 : Number(child.explicitHeight);
               childMin = isNaN(child.explicitMinHeight) ? 0 : Number(child.explicitMinHeight);
               childHeight = childPref > this.cellHeight || childMin > this.cellHeight ? Math.max(childMin,childPref) : this.cellHeight;
            }
         }
         child.setActualSize(childWidth,childHeight);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function calcHorizontalOffset(width:Number, horizontalAlign:String) : Number
      {
         var xOffset:Number = NaN;
         if(horizontalAlign == "left")
         {
            xOffset = 0;
         }
         else if(horizontalAlign == "center")
         {
            xOffset = (this.cellWidth - width) / 2;
         }
         else if(horizontalAlign == "right")
         {
            xOffset = this.cellWidth - width;
         }
         return xOffset;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function calcVerticalOffset(height:Number, verticalAlign:String) : Number
      {
         var yOffset:Number = NaN;
         if(verticalAlign == "top")
         {
            yOffset = 0;
         }
         else if(verticalAlign == "middle")
         {
            yOffset = (this.cellHeight - height) / 2;
         }
         else if(verticalAlign == "bottom")
         {
            yOffset = this.cellHeight - height;
         }
         return yOffset;
      }
   }
}

