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
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _direction:String = "vertical";
      
      private var guessedNumColumns:int;
      
      private var _required:Boolean = false;
      
      mx_internal var verticalLayoutObject:BoxLayout = new BoxLayout();
      
      private var labelChanged:Boolean = false;
      
      private var guessedRowWidth:Number;
      
      private var labelObj:Label;
      
      private var numberOfGuesses:int = 0;
      
      private var indicatorObj:IFlexDisplayObject;
      
      private var _label:String = "";
      
      public function FormItem()
      {
         super();
         mx_internal::_horizontalScrollPolicy = ScrollPolicy.OFF;
         mx_internal::_verticalScrollPolicy = ScrollPolicy.OFF;
         mx_internal::verticalLayoutObject.target = this;
         mx_internal::verticalLayoutObject.direction = BoxDirection.VERTICAL;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var labelStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.styleChanged(styleProp);
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || styleProp == "labelStyleName")
         {
            if(Boolean(labelObj))
            {
               labelStyleName = getStyle("labelStyleName");
               if(Boolean(labelStyleName))
               {
                  styleDecl = StyleManager.getStyleDeclaration("." + labelStyleName);
                  if(Boolean(styleDecl))
                  {
                     labelObj.styleDeclaration = styleDecl;
                     labelObj.regenerateStyleCache(true);
                  }
               }
            }
         }
      }
      
      mx_internal function getHorizontalAlignValue() : Number
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
      
      private function calcNumColumns(w:Number) : int
      {
         var child:IUIComponent = null;
         var childWidth:Number = NaN;
         var totalWidth:Number = 0;
         var maxChildWidth:Number = 0;
         var horizontalGap:Number = getStyle("horizontalGap");
         if(direction != FormItemDirection.HORIZONTAL)
         {
            return 1;
         }
         var numChildrenWithOwnSpace:Number = numChildren;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(!child.includeInLayout)
            {
               numChildrenWithOwnSpace--;
            }
            else
            {
               childWidth = child.getExplicitOrMeasuredWidth();
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(labelChanged)
         {
            labelObj.text = label;
            labelObj.validateSize();
            labelChanged = false;
         }
      }
      
      [Deprecated(replacement="FormItem.itemLabel",since="3.0")]
      mx_internal function get labelObject() : Object
      {
         return labelObj;
      }
      
      private function previousUpdateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var child:IUIComponent = null;
         var childBaseline:Number = NaN;
         var childWidth:Number = NaN;
         var horizontalGap:Number = NaN;
         var verticalGap:Number = NaN;
         var horizontalAlignValue:Number = NaN;
         var maxWidth:Number = NaN;
         var numColumns:int = 0;
         var x:Number = NaN;
         var col:int = 0;
         var h:Number = NaN;
         var excessSpace:Number = NaN;
         var widthSlop:Number = NaN;
         var xOffset:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var left:Number = vm.left;
         var top:Number = vm.top;
         var y:Number = top;
         var labelWidth:Number = calculateLabelWidth();
         var indicatorGap:Number = getStyle("indicatorGap");
         var horizontalAlign:String = getStyle("horizontalAlign");
         if(horizontalAlign == "right")
         {
            horizontalAlignValue = 1;
         }
         else if(horizontalAlign == "center")
         {
            horizontalAlignValue = 0.5;
         }
         else
         {
            horizontalAlignValue = 0;
         }
         var n:int = numChildren;
         if(n > 0)
         {
            child = IUIComponent(getChildAt(0));
            childBaseline = child.baselinePosition;
            if(!isNaN(childBaseline))
            {
               y += childBaseline - labelObj.baselinePosition;
            }
         }
         labelObj.setActualSize(labelWidth,labelObj.getExplicitOrMeasuredHeight());
         labelObj.move(left,y);
         left += labelWidth;
         displayIndicator(left,y);
         left += indicatorGap;
         var controlWidth:Number = unscaledWidth - vm.right - left;
         if(controlWidth < 0)
         {
            controlWidth = 0;
         }
         if(direction == FormItemDirection.HORIZONTAL)
         {
            maxWidth = 0;
            numColumns = calcNumColumns(controlWidth);
            col = 0;
            horizontalGap = getStyle("horizontalGap");
            verticalGap = getStyle("verticalGap");
            if(numColumns != guessedNumColumns && numberOfGuesses == 0)
            {
               guessedRowWidth = controlWidth;
               numberOfGuesses = 1;
               invalidateSize();
            }
            else
            {
               numberOfGuesses = 0;
            }
            if(numColumns == n)
            {
               h = height - (top + vm.bottom);
               excessSpace = Flex.flexChildWidthsProportionally(this,controlWidth - (n - 1) * horizontalGap,h);
               left += excessSpace * horizontalAlignValue;
               for(i = 0; i < n; i++)
               {
                  child = IUIComponent(getChildAt(i));
                  child.move(Math.floor(left),top);
                  left += child.width + horizontalGap;
               }
            }
            else
            {
               for(i = 0; i < n; i++)
               {
                  child = IUIComponent(getChildAt(i));
                  maxWidth = Math.max(maxWidth,child.getExplicitOrMeasuredWidth());
               }
               widthSlop = controlWidth - (numColumns * maxWidth + (numColumns - 1) * horizontalGap);
               if(widthSlop < 0)
               {
                  widthSlop = 0;
               }
               left += widthSlop * horizontalAlignValue;
               x = left;
               for(i = 0; i < n; i++)
               {
                  child = IUIComponent(getChildAt(i));
                  childWidth = Math.min(maxWidth,child.getExplicitOrMeasuredWidth());
                  child.setActualSize(childWidth,child.getExplicitOrMeasuredHeight());
                  child.move(x,top);
                  if(++col >= numColumns)
                  {
                     x = left;
                     col = 0;
                     top += child.height + verticalGap;
                  }
                  else
                  {
                     x += maxWidth + horizontalGap;
                  }
               }
            }
         }
         else
         {
            verticalGap = getStyle("verticalGap");
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(!isNaN(child.percentWidth))
               {
                  childWidth = Math.floor(controlWidth * Math.min(child.percentWidth,100) / 100);
               }
               else
               {
                  childWidth = child.getExplicitOrMeasuredWidth();
                  if(isNaN(child.explicitWidth))
                  {
                     if(childWidth < Math.floor(controlWidth * 0.25))
                     {
                        childWidth = Math.floor(controlWidth * 0.25);
                     }
                     else if(childWidth < Math.floor(controlWidth * 0.5))
                     {
                        childWidth = Math.floor(controlWidth * 0.5);
                     }
                     else if(childWidth < Math.floor(controlWidth * 0.75))
                     {
                        childWidth = Math.floor(controlWidth * 0.75);
                     }
                     else if(childWidth < Math.floor(controlWidth))
                     {
                        childWidth = Math.floor(controlWidth);
                     }
                  }
               }
               child.setActualSize(childWidth,child.getExplicitOrMeasuredHeight());
               xOffset = (controlWidth - childWidth) * horizontalAlignValue;
               child.move(left + xOffset,top);
               top += child.height;
               top += verticalGap;
            }
         }
         y = vm.top;
         if(n > 0)
         {
            child = IUIComponent(getChildAt(0));
            childBaseline = child.baselinePosition;
            if(!isNaN(childBaseline))
            {
               y += childBaseline - labelObj.baselinePosition;
            }
         }
         labelObj.move(labelObj.x,y);
      }
      
      override protected function createChildren() : void
      {
         var labelStyleName:String = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.createChildren();
         if(!labelObj)
         {
            labelObj = new FormItemLabel();
            labelStyleName = getStyle("labelStyleName");
            if(Boolean(labelStyleName))
            {
               styleDecl = StyleManager.getStyleDeclaration("." + labelStyleName);
               if(Boolean(styleDecl))
               {
                  labelObj.styleDeclaration = styleDecl;
               }
            }
            rawChildren.addChild(labelObj);
            dispatchEvent(new Event("itemLabelChanged"));
         }
      }
      
      internal function getPreferredLabelWidth() : Number
      {
         if(!label || label == "")
         {
            return 0;
         }
         if(isNaN(labelObj.measuredWidth))
         {
            labelObj.validateSize();
         }
         var labelWidth:Number = labelObj.measuredWidth;
         if(isNaN(labelWidth))
         {
            return 0;
         }
         return labelWidth;
      }
      
      override protected function measure() : void
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            previousMeasure();
            return;
         }
         super.measure();
         if(direction == FormItemDirection.VERTICAL)
         {
            measureVertical();
         }
         else
         {
            measureHorizontal();
         }
      }
      
      [Bindable("itemLabelChanged")]
      public function get itemLabel() : Label
      {
         return labelObj;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("requiredChanged")]
      public function get required() : Boolean
      {
         return _required;
      }
      
      private function previousMeasure() : void
      {
         var preferredWidth:Number = NaN;
         var preferredHeight:Number = NaN;
         var i:int = 0;
         var child:IUIComponent = null;
         super.measure();
         var numColumns:int = guessedNumColumns = calcNumColumns(guessedRowWidth);
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var indicatorGap:Number = getStyle("indicatorGap");
         var col:int = 0;
         var tempMinWidth:Number = 0;
         var tempWidth:Number = 0;
         var tempMinHeight:Number = 0;
         var tempHeight:Number = 0;
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         preferredWidth = 0;
         preferredHeight = 0;
         var maxPreferredWidth:Number = 0;
         var n:int = numChildren;
         if(direction == FormItemDirection.HORIZONTAL && numColumns < n)
         {
            for(i = 0; i < n; i++)
            {
               child = IUIComponent(getChildAt(i));
               maxPreferredWidth = Math.max(maxPreferredWidth,child.getExplicitOrMeasuredWidth());
            }
         }
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(col < numColumns)
            {
               tempMinWidth += !isNaN(child.percentWidth) ? child.minWidth : child.getExplicitOrMeasuredWidth();
               tempWidth += maxPreferredWidth > 0 ? maxPreferredWidth : child.getExplicitOrMeasuredWidth();
               if(col > 0)
               {
                  tempMinWidth += horizontalGap;
                  tempWidth += horizontalGap;
               }
               tempMinHeight = Math.max(tempMinHeight,!isNaN(child.percentHeight) ? child.minHeight : child.getExplicitOrMeasuredHeight());
               tempHeight = Math.max(tempHeight,child.getExplicitOrMeasuredHeight());
            }
            col++;
            if(col >= numColumns || i == n - 1)
            {
               minWidth = Math.max(minWidth,tempMinWidth);
               preferredWidth = Math.max(preferredWidth,tempWidth);
               minHeight += tempMinHeight;
               preferredHeight += tempHeight;
               if(i > 0)
               {
                  minHeight += verticalGap;
                  preferredHeight += verticalGap;
               }
               col = 0;
               tempMinWidth = 0;
               tempWidth = 0;
               tempMinHeight = 0;
               tempHeight = 0;
            }
         }
         var labelWidth:Number = calculateLabelWidth() + indicatorGap;
         minWidth += labelWidth;
         preferredWidth += labelWidth;
         if(label != null && label != "")
         {
            minHeight = Math.max(minHeight,labelObj.getExplicitOrMeasuredHeight());
            preferredHeight = Math.max(preferredHeight,labelObj.getExplicitOrMeasuredHeight());
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
      
      private function measureHorizontal() : void
      {
         var minHeight:Number = NaN;
         var preferredHeight:Number = NaN;
         var i:int = 0;
         var child:IUIComponent = null;
         var numColumns:int = guessedNumColumns = calcNumColumns(guessedRowWidth);
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var indicatorGap:Number = getStyle("indicatorGap");
         var tempMinWidth:Number = 0;
         var tempWidth:Number = 0;
         var tempMinHeight:Number = 0;
         var tempHeight:Number = 0;
         var minWidth:Number = 0;
         minHeight = 0;
         var preferredWidth:Number = 0;
         preferredHeight = 0;
         var maxPreferredWidth:Number = 0;
         var col:int = 0;
         if(numColumns < numChildren)
         {
            for(i = 0; i < numChildren; i++)
            {
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  maxPreferredWidth = Math.max(maxPreferredWidth,child.getExplicitOrMeasuredWidth());
               }
            }
         }
         var row:int = 0;
         for(i = 0; i < numChildren; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child.includeInLayout)
            {
               tempMinWidth += !isNaN(child.percentWidth) ? child.minWidth : child.getExplicitOrMeasuredWidth();
               tempWidth += maxPreferredWidth > 0 ? maxPreferredWidth : child.getExplicitOrMeasuredWidth();
               if(col > 0)
               {
                  tempMinWidth += horizontalGap;
                  tempWidth += horizontalGap;
               }
               tempMinHeight = Math.max(tempMinHeight,!isNaN(child.percentHeight) ? child.minHeight : child.getExplicitOrMeasuredHeight());
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
         var labelWidth:Number = calculateLabelWidth() + indicatorGap;
         minWidth += labelWidth;
         preferredWidth += labelWidth;
         if(label != null && label != "")
         {
            minHeight = Math.max(minHeight,labelObj.getExplicitOrMeasuredHeight());
            preferredHeight = Math.max(preferredHeight,labelObj.getExplicitOrMeasuredHeight());
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
      
      public function set required(value:Boolean) : void
      {
         if(value != _required)
         {
            _required = value;
            invalidateDisplayList();
            dispatchEvent(new Event("requiredChanged"));
         }
      }
      
      private function updateDisplayListVerticalChildren(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var extraWidth:Number = calculateLabelWidth() + getStyle("indicatorGap");
         if(!isNaN(explicitMinWidth))
         {
            _explicitMinWidth -= extraWidth;
         }
         else if(!isNaN(measuredMinWidth))
         {
            measuredMinWidth -= extraWidth;
         }
         verticalLayoutObject.updateDisplayList(unscaledWidth - extraWidth,unscaledHeight);
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
            child = IUIComponent(getChildAt(i));
            child.move(child.x + extraWidth,child.y);
         }
      }
      
      private function displayIndicator(xPos:Number, yPos:Number) : void
      {
         var indicatorClass:Class = null;
         if(required)
         {
            if(!indicatorObj)
            {
               indicatorClass = getStyle("indicatorSkin") as Class;
               indicatorObj = IFlexDisplayObject(new indicatorClass());
               rawChildren.addChild(DisplayObject(indicatorObj));
            }
            indicatorObj.x = xPos + (getStyle("indicatorGap") - indicatorObj.width) / 2;
            if(Boolean(labelObj))
            {
               indicatorObj.y = yPos + (labelObj.getExplicitOrMeasuredHeight() - indicatorObj.measuredHeight) / 2;
            }
         }
         else if(Boolean(indicatorObj))
         {
            rawChildren.removeChild(DisplayObject(indicatorObj));
            indicatorObj = null;
         }
      }
      
      override public function set label(value:String) : void
      {
         _label = value;
         labelChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         if(parent is Form)
         {
            Form(parent).invalidateLabelWidth();
         }
         dispatchEvent(new Event("labelChanged"));
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
         var heightSpacePerPercent:* = undefined;
         var rowMaxChildHeight:* = undefined;
         var xOffset:* = undefined;
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var labelWidth:Number = calculateLabelWidth();
         var indicatorGap:Number = getStyle("indicatorGap");
         var horizontalGap:Number = getStyle("horizontalGap");
         var verticalGap:Number = getStyle("verticalGap");
         var paddingLeft:Number = getStyle("paddingLeft");
         var paddingTop:Number = getStyle("paddingTop");
         var horizontalAlignValue:Number = getHorizontalAlignValue();
         var mw:Number = scaleX > 0 && scaleX != 1 ? minWidth / Math.abs(scaleX) : minWidth;
         var mh:Number = scaleY > 0 && scaleY != 1 ? minHeight / Math.abs(scaleY) : minHeight;
         var w:Number = Math.max(unscaledWidth,mw) - vm.left - vm.right;
         var h:Number = Math.max(unscaledHeight,mh) - vm.top - vm.bottom;
         var maxWidth:Number = 0;
         var controlWidth:Number = w - labelWidth - indicatorGap;
         if(controlWidth < 0)
         {
            controlWidth = 0;
         }
         var numColumns:int = calcNumColumns(controlWidth);
         var col:int = 0;
         if(numColumns != guessedNumColumns && isNaN(explicitWidth))
         {
            if(numberOfGuesses < 2)
            {
               guessedRowWidth = controlWidth;
               ++numberOfGuesses;
               invalidateSize();
               return;
            }
            numColumns = guessedNumColumns;
            numberOfGuesses = 0;
         }
         else
         {
            numberOfGuesses = 0;
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
            excessSpace = Flex.flexChildWidthsProportionally(this,controlWidth - (numChildrenWithOwnSpace - 1) * horizontalGap,h);
            left += excessSpace * horizontalAlignValue;
            for(i = 0; i < numChildren; i++)
            {
               child = IUIComponent(getChildAt(i));
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
               child = IUIComponent(getChildAt(i));
               if(child.includeInLayout)
               {
                  wPref = child.getExplicitOrMeasuredWidth();
                  percentWidth = child.percentWidth;
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
               child = IUIComponent(getChildAt(i));
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
                  child = IUIComponent(getChildAt(i));
                  if(child.includeInLayout)
                  {
                     wPref = child.getExplicitOrMeasuredWidth();
                     hPref = child.getExplicitOrMeasuredHeight();
                     percentWidth = child.percentWidth;
                     percentHeight = child.percentHeight;
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
                           childHeight = child.minHeight;
                           totalPercentHeight -= child.percentHeight;
                           heightSpaceToDistribute -= childHeight;
                           explicitHeightChildren[i] = childHeight;
                           done = false;
                           break;
                        }
                        if(childHeight > child.maxHeight)
                        {
                           childHeight = child.maxHeight;
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
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      override public function get label() : String
      {
         return _label;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         var childBaseline:Number = NaN;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            previousUpdateDisplayList(unscaledWidth,unscaledHeight);
            return;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(direction == FormItemDirection.VERTICAL)
         {
            updateDisplayListVerticalChildren(unscaledWidth,unscaledHeight);
         }
         else
         {
            updateDisplayListHorizontalChildren(unscaledWidth,unscaledHeight);
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var x:Number = vm.left;
         var y:Number = vm.top;
         var labelWidth:Number = calculateLabelWidth();
         if(numChildren > 0)
         {
            child = IUIComponent(getChildAt(0));
            childBaseline = child.baselinePosition;
            if(!isNaN(childBaseline))
            {
               y += childBaseline - labelObj.baselinePosition;
            }
         }
         labelObj.setActualSize(labelWidth,labelObj.getExplicitOrMeasuredHeight());
         labelObj.move(x,y);
         x += labelWidth;
         displayIndicator(x,y);
      }
      
      private function calculateLabelWidth() : Number
      {
         var labelWidth:Number = getStyle("labelWidth");
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
            labelWidth = getPreferredLabelWidth();
         }
         return labelWidth;
      }
      
      private function measureVertical() : void
      {
         var labelHeight:Number = NaN;
         verticalLayoutObject.measure();
         var extraWidth:Number = calculateLabelWidth() + getStyle("indicatorGap");
         measuredMinWidth += extraWidth;
         measuredWidth += extraWidth;
         labelHeight = labelObj.getExplicitOrMeasuredHeight();
         measuredMinHeight = Math.max(measuredMinHeight,labelHeight);
         measuredHeight = Math.max(measuredHeight,labelHeight);
      }
      
      public function set direction(value:String) : void
      {
         _direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return _direction;
      }
   }
}

