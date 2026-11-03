package mx.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.containers.utilityClasses.Flex;
   import mx.controls.FormItemLabel;
   import mx.controls.Label;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.styles.CSSStyleDeclaration;
   
   [Alternative(replacement="spark.components.FormItem",since="4.5")]
   [IconFile("FormItem.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="labelWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="labelStyleName",type="String",inherit="no")]
   [Style(name="indicatorSkin",type="Class",inherit="no")]
   [Style(name="indicatorGap",type="Number",format="Length",inherit="yes")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class FormItem extends Container
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var labelObj:Label;
      
      private var indicatorObj:IFlexDisplayObject;
      
      private var guessedRowWidth:Number;
      
      private var guessedNumColumns:int;
      
      private var numberOfGuesses:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var verticalLayoutObject:BoxLayout = new BoxLayout();
      
      private var _label:String = "";
      
      private var labelChanged:Boolean = false;
      
      private var _direction:String = "vertical";
      
      private var _required:Boolean = false;
      
      public function FormItem()
      {
         super();
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         _verticalScrollPolicy = ScrollPolicy.OFF;
         this.verticalLayoutObject.target = this;
         this.verticalLayoutObject.direction = BoxDirection.VERTICAL;
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      override public function get label() : String
      {
         return this._label;
      }
      
      override public function set label(value:String) : void
      {
         this._label = value;
         this.labelChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         if(parent is Form)
         {
            Form(parent).invalidateLabelWidth();
         }
         dispatchEvent(new Event("labelChanged"));
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
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
      
      [Bindable("itemLabelChanged")]
      public function get itemLabel() : Label
      {
         return this.labelObj;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("requiredChanged")]
      public function get required() : Boolean
      {
         return this._required;
      }
      
      public function set required(value:Boolean) : void
      {
         if(value != this._required)
         {
            this._required = value;
            invalidateDisplayList();
            dispatchEvent(new Event("requiredChanged"));
         }
      }
      
      override protected function createChildren() : void
      {
         var labelStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.createChildren();
         if(!this.labelObj)
         {
            this.labelObj = new FormItemLabel();
            labelStyleName = getStyle("labelStyleName");
            if(Boolean(labelStyleName))
            {
               styleDecl = styleManager.getMergedStyleDeclaration("." + labelStyleName);
               if(Boolean(styleDecl))
               {
                  this.labelObj.styleDeclaration = styleDecl;
               }
            }
            rawChildren.addChild(this.labelObj);
            dispatchEvent(new Event("itemLabelChanged"));
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.labelChanged)
         {
            this.labelObj.text = this.label;
            this.labelObj.validateSize();
            this.labelChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.direction == FormItemDirection.VERTICAL)
         {
            this.measureVertical();
         }
         else
         {
            this.measureHorizontal();
         }
      }
      
      private function measureVertical() : void
      {
         this.verticalLayoutObject.measure();
         var extraWidth:Number = this.calculateLabelWidth() + getStyle("indicatorGap");
         measuredMinWidth += extraWidth;
         measuredWidth += extraWidth;
         var labelHeight:Number = Number(this.labelObj.getExplicitOrMeasuredHeight());
         measuredMinHeight = Math.max(measuredMinHeight,labelHeight);
         measuredHeight = Math.max(measuredHeight,labelHeight);
      }
      
      private function measureHorizontal() : void
      {
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var i:int = 0;
         var child:IUIComponent = null;
         var numColumns:int = this.guessedNumColumns = this.calcNumColumns(this.guessedRowWidth);
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var indicatorGap:Number = Number(getStyle("indicatorGap"));
         var tempMinWidth:Number = 0;
         var tempWidth:Number = 0;
         var tempMinHeight:Number = 0;
         var tempHeight:Number = 0;
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         var maxPreferredWidth:Number = 0;
         var col:int = 0;
         if(numColumns < numChildren)
         {
            for(i = 0; i < numChildren; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  maxPreferredWidth = Math.max(maxPreferredWidth,child.getExplicitOrMeasuredWidth());
               }
            }
         }
         var row:int = 0;
         for(i = 0; i < numChildren; i++)
         {
            child = getLayoutChildAt(i);
            if(child.includeInLayout)
            {
               tempMinWidth += !isNaN(child.percentWidth) ? child.minWidth : child.getExplicitOrMeasuredWidth();
               tempWidth += maxPreferredWidth > 0 ? maxPreferredWidth : child.getExplicitOrMeasuredWidth();
               if(col > 0)
               {
                  tempMinWidth += horizontalGap;
                  tempWidth += horizontalGap;
               }
               tempMinHeight = Math.max(tempMinHeight,!isNaN(child.percentHeight) ? Number(child.minHeight) : Number(child.getExplicitOrMeasuredHeight()));
               tempHeight = Math.max(tempHeight,child.getExplicitOrMeasuredHeight());
               col++;
               if(col >= numColumns || i == numChildren - 1)
               {
                  minWidth = Math.max(minWidth,tempMinWidth);
                  preferredWidth = Math.max(preferredWidth,tempWidth);
                  minHeight += tempMinHeight;
                  preferredHeight += tempHeight;
                  if(row > 0)
                  {
                     minHeight += verticalGap;
                     preferredHeight += verticalGap;
                  }
                  col = 0;
                  row++;
                  tempMinWidth = 0;
                  tempWidth = 0;
                  tempMinHeight = 0;
                  tempHeight = 0;
               }
            }
         }
         var labelWidth:Number = this.calculateLabelWidth() + indicatorGap;
         minWidth += labelWidth;
         preferredWidth += labelWidth;
         if(this.label != null && this.label != "")
         {
            minHeight = Math.max(minHeight,this.labelObj.getExplicitOrMeasuredHeight());
            preferredHeight = Math.max(preferredHeight,this.labelObj.getExplicitOrMeasuredHeight());
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         minHeight += vm.top + vm.bottom;
         minWidth += vm.left + vm.right;
         preferredHeight += vm.top + vm.bottom;
         preferredWidth += vm.left + vm.right;
         measuredMinWidth = minWidth;
         measuredMinHeight = minHeight;
         measuredWidth = preferredWidth;
         measuredHeight = preferredHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var childBaseline:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.direction == FormItemDirection.VERTICAL)
         {
            this.updateDisplayListVerticalChildren(unscaledWidth,unscaledHeight);
         }
         else
         {
            this.updateDisplayListHorizontalChildren(unscaledWidth,unscaledHeight);
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var x:Number = Number(vm.left);
         var y:Number = Number(vm.top);
         var labelWidth:Number = this.calculateLabelWidth();
         if(numChildren > 0)
         {
            child = getLayoutChildAt(0);
            childBaseline = Number(child.baselinePosition);
            if(!isNaN(childBaseline))
            {
               y += childBaseline - this.labelObj.baselinePosition;
            }
         }
         this.labelObj.setActualSize(labelWidth,this.labelObj.getExplicitOrMeasuredHeight());
         this.labelObj.move(x,y);
         x += labelWidth;
         this.displayIndicator(x,y);
      }
      
      private function updateDisplayListVerticalChildren(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var extraWidth:Number = this.calculateLabelWidth() + getStyle("indicatorGap");
         if(!isNaN(explicitMinWidth))
         {
            _explicitMinWidth -= extraWidth;
         }
         else if(!isNaN(measuredMinWidth))
         {
            measuredMinWidth -= extraWidth;
         }
         this.verticalLayoutObject.updateDisplayList(unscaledWidth - extraWidth,unscaledHeight);
         if(!isNaN(explicitMinWidth))
         {
            _explicitMinWidth += extraWidth;
         }
         else if(!isNaN(measuredMinWidth))
         {
            measuredMinWidth += extraWidth;
         }
         var n:Number = numChildren;
         for(var i:Number = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            child.move(child.x + extraWidth,child.y);
         }
      }
      
      private function updateDisplayListHorizontalChildren(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var child:IUIComponent = null;
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         var wPref:Number = NaN;
         var hPref:Number = NaN;
         var percentWidth:Number = NaN;
         var percentHeight:Number = NaN;
         var excessSpace:Number = NaN;
         var widthSlop:Number = NaN;
         var rowPercentHeight:Number = NaN;
         var rowMaxHeight:Number = NaN;
         var totalPercentHeight:Number = NaN;
         var heightSpaceForChildren:Number = NaN;
         var heightSpaceToDistribute:Number = NaN;
         var done:Boolean = false;
         var explicitHeightChildren:Array = null;
         var unused:Number = NaN;
         var heightSpacePerPercent:Number = NaN;
         var rowMaxChildHeight:Number = NaN;
         var xOffset:Number = NaN;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var labelWidth:Number = this.calculateLabelWidth();
         var indicatorGap:Number = Number(getStyle("indicatorGap"));
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var horizontalAlignValue:Number = this.getHorizontalAlignValue();
         var mw:Number = scaleX > 0 && scaleX != 1 ? minWidth / Math.abs(scaleX) : Number(minWidth);
         var mh:Number = scaleY > 0 && scaleY != 1 ? minHeight / Math.abs(scaleY) : Number(minHeight);
         var w:Number = Math.max(unscaledWidth,mw) - vm.left - vm.right;
         var h:Number = Math.max(unscaledHeight,mh) - vm.top - vm.bottom;
         var maxWidth:Number = 0;
         var controlWidth:Number = w - labelWidth - indicatorGap;
         if(controlWidth < 0)
         {
            controlWidth = 0;
         }
         var numColumns:int = this.calcNumColumns(controlWidth);
         var col:int = 0;
         if(numColumns != this.guessedNumColumns && isNaN(explicitWidth))
         {
            if(this.numberOfGuesses < 2)
            {
               this.guessedRowWidth = controlWidth;
               ++this.numberOfGuesses;
               invalidateSize();
               return;
            }
            numColumns = this.guessedNumColumns;
            this.numberOfGuesses = 0;
         }
         else
         {
            this.numberOfGuesses = 0;
         }
         var left:Number = paddingLeft + labelWidth + indicatorGap;
         var top:Number = paddingTop;
         var x:Number = left;
         var y:Number = top;
         var numChildrenWithOwnSpace:int = numChildren;
         for(i = 0; i < numChildren; i++)
         {
            if(!IUIComponent(getChildAt(i)).includeInLayout)
            {
               numChildrenWithOwnSpace--;
            }
         }
         if(numColumns == numChildrenWithOwnSpace)
         {
            excessSpace = Number(Flex.flexChildWidthsProportionally(this,controlWidth - (numChildrenWithOwnSpace - 1) * horizontalGap,h));
            left += excessSpace * horizontalAlignValue;
            for(i = 0; i < numChildren; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  child.move(Math.floor(left),top);
                  left += child.width + horizontalGap;
               }
            }
         }
         else
         {
            for(i = 0; i < numChildren; i++)
            {
               child = getLayoutChildAt(i);
               if(child.includeInLayout)
               {
                  wPref = Number(child.getExplicitOrMeasuredWidth());
                  percentWidth = Number(child.percentWidth);
                  childWidth = !isNaN(percentWidth) ? percentWidth * controlWidth / 100 : wPref;
                  childWidth = Math.max(child.minWidth,Math.min(child.maxWidth,childWidth));
                  maxWidth = Math.max(maxWidth,childWidth);
               }
            }
            maxWidth = Math.min(maxWidth,Math.floor((controlWidth - (numColumns - 1) * horizontalGap) / numColumns));
            widthSlop = controlWidth - (numColumns * maxWidth + (numColumns - 1) * horizontalGap);
            if(widthSlop < 0)
            {
               widthSlop = 0;
            }
            left += widthSlop * horizontalAlignValue;
            rowPercentHeight = 0;
            rowMaxHeight = 0;
            totalPercentHeight = 0;
            heightSpaceForChildren = h;
            heightSpaceToDistribute = heightSpaceForChildren;
            col = 0;
            for(i = 0; i < numChildren; i++)
            {
               child = getLayoutChildAt(i);
               if(!child.includeInLayout)
               {
                  if(i == numChildren - 1)
                  {
                     heightSpaceToDistribute -= rowMaxHeight;
                     if(i != numChildren - 1)
                     {
                        heightSpaceToDistribute -= verticalGap;
                     }
                     if(rowMaxHeight > 0 && rowPercentHeight > 0)
                     {
                        rowPercentHeight = Math.max(0,rowPercentHeight - 100 * rowMaxHeight / heightSpaceForChildren);
                     }
                     totalPercentHeight += rowPercentHeight;
                     rowMaxHeight = 0;
                     rowPercentHeight = 0;
                     col = 0;
                  }
               }
               else
               {
                  if(!isNaN(child.percentHeight))
                  {
                     rowPercentHeight = Math.max(rowPercentHeight,child.percentHeight);
                  }
                  else
                  {
                     rowMaxHeight = Math.max(rowMaxHeight,child.getExplicitOrMeasuredHeight());
                  }
                  if(++col >= numColumns || i == numChildren - 1)
                  {
                     heightSpaceToDistribute -= rowMaxHeight;
                     if(i != numChildren - 1)
                     {
                        heightSpaceToDistribute -= verticalGap;
                     }
                     if(rowMaxHeight > 0 && rowPercentHeight > 0)
                     {
                        rowPercentHeight = Math.max(0,rowPercentHeight - 100 * rowMaxHeight / heightSpaceForChildren);
                     }
                     totalPercentHeight += rowPercentHeight;
                     rowMaxHeight = 0;
                     rowPercentHeight = 0;
                     col = 0;
                  }
               }
            }
            done = false;
            explicitHeightChildren = new Array(numChildren);
            for(i = 0; i < numChildren; i++)
            {
               explicitHeightChildren[i] = -1;
            }
            unused = heightSpaceToDistribute - heightSpaceForChildren * totalPercentHeight / 100;
            if(unused > 0)
            {
               heightSpaceToDistribute -= unused;
            }
            do
            {
               done = true;
               heightSpacePerPercent = heightSpaceToDistribute / totalPercentHeight;
               col = 0;
               x = left;
               y = top;
               rowMaxChildHeight = 0;
               for(i = 0; i < numChildren; i++)
               {
                  child = getLayoutChildAt(i);
                  if(child.includeInLayout)
                  {
                     wPref = Number(child.getExplicitOrMeasuredWidth());
                     hPref = Number(child.getExplicitOrMeasuredHeight());
                     percentWidth = Number(child.percentWidth);
                     percentHeight = Number(child.percentHeight);
                     childWidth = Math.min(maxWidth,!isNaN(percentWidth) ? percentWidth * controlWidth / 100 : wPref);
                     childWidth = Math.max(child.minWidth,Math.min(child.maxWidth,childWidth));
                     if(explicitHeightChildren[i] != -1)
                     {
                        childHeight = Number(explicitHeightChildren[i]);
                     }
                     else
                     {
                        childHeight = !isNaN(percentHeight) ? percentHeight * heightSpacePerPercent : hPref;
                        if(childHeight < child.minHeight)
                        {
                           childHeight = Number(child.minHeight);
                           totalPercentHeight -= child.percentHeight;
                           heightSpaceToDistribute -= childHeight;
                           explicitHeightChildren[i] = childHeight;
                           done = false;
                           break;
                        }
                        if(childHeight > child.maxHeight)
                        {
                           childHeight = Number(child.maxHeight);
                           totalPercentHeight -= child.percentHeight;
                           heightSpaceToDistribute -= childHeight;
                           explicitHeightChildren[i] = childHeight;
                           done = false;
                           break;
                        }
                     }
                     if(child.scaleX == 1 && child.scaleY == 1)
                     {
                        child.setActualSize(Math.floor(childWidth),Math.floor(childHeight));
                     }
                     else
                     {
                        child.setActualSize(childWidth,childHeight);
                     }
                     xOffset = (maxWidth - child.width) * horizontalAlignValue;
                     child.move(Math.floor(x + xOffset),Math.floor(y));
                     rowMaxChildHeight = Math.max(rowMaxChildHeight,child.height);
                     if(++col >= numColumns)
                     {
                        x = left;
                        col = 0;
                        y += rowMaxChildHeight + verticalGap;
                        rowMaxChildHeight = 0;
                     }
                     else
                     {
                        x += maxWidth + horizontalGap;
                     }
                  }
               }
            }
            while(!done);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var labelStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.styleChanged(styleProp);
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || styleProp == "labelStyleName")
         {
            if(Boolean(this.labelObj))
            {
               labelStyleName = getStyle("labelStyleName");
               if(Boolean(labelStyleName))
               {
                  styleDecl = styleManager.getMergedStyleDeclaration("." + labelStyleName);
                  if(Boolean(styleDecl))
                  {
                     this.labelObj.styleDeclaration = styleDecl;
                     this.labelObj.regenerateStyleCache(true);
                  }
               }
            }
         }
      }
      
      internal function getPreferredLabelWidth() : Number
      {
         if(!this.label || this.label == "")
         {
            return 0;
         }
         if(isNaN(this.labelObj.measuredWidth))
         {
            this.labelObj.validateSize();
         }
         var labelWidth:Number = Number(this.labelObj.measuredWidth);
         if(isNaN(labelWidth))
         {
            return 0;
         }
         return labelWidth;
      }
      
      private function calculateLabelWidth() : Number
      {
         var labelWidth:Number = Number(getStyle("labelWidth"));
         if(labelWidth == 0)
         {
            labelWidth = NaN;
         }
         if(isNaN(labelWidth) && parent is Form)
         {
            labelWidth = Form(parent).calculateLabelWidth();
         }
         if(isNaN(labelWidth))
         {
            labelWidth = this.getPreferredLabelWidth();
         }
         return labelWidth;
      }
      
      private function calcNumColumns(w:Number) : int
      {
         var child:IUIComponent = null;
         var childWidth:Number = NaN;
         var totalWidth:Number = 0;
         var maxChildWidth:Number = 0;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(this.direction != FormItemDirection.HORIZONTAL)
         {
            return 1;
         }
         var numChildrenWithOwnSpace:Number = numChildren;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getLayoutChildAt(i);
            if(!child.includeInLayout)
            {
               numChildrenWithOwnSpace--;
            }
            else
            {
               childWidth = Number(child.getExplicitOrMeasuredWidth());
               maxChildWidth = Math.max(maxChildWidth,childWidth);
               totalWidth += childWidth;
               if(i > 0)
               {
                  totalWidth += horizontalGap;
               }
            }
         }
         if(isNaN(w) || totalWidth <= w)
         {
            return numChildrenWithOwnSpace;
         }
         if(maxChildWidth * 2 <= w)
         {
            return 2;
         }
         return 1;
      }
      
      private function displayIndicator(xPos:Number, yPos:Number) : void
      {
         var indicatorClass:Class = null;
         if(this.required)
         {
            if(!this.indicatorObj)
            {
               indicatorClass = getStyle("indicatorSkin") as Class;
               this.indicatorObj = IFlexDisplayObject(new indicatorClass());
               rawChildren.addChild(DisplayObject(this.indicatorObj));
            }
            this.indicatorObj.x = xPos + (getStyle("indicatorGap") - this.indicatorObj.width) / 2;
            if(Boolean(this.labelObj))
            {
               this.indicatorObj.y = yPos + (this.labelObj.getExplicitOrMeasuredHeight() - this.indicatorObj.measuredHeight) / 2;
            }
         }
         else if(Boolean(this.indicatorObj))
         {
            rawChildren.removeChild(DisplayObject(this.indicatorObj));
            this.indicatorObj = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHorizontalAlignValue() : Number
      {
         var horizontalAlign:String = getStyle("horizontalAlign");
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
   }
}

