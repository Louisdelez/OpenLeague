package spark.components.supportClasses
{
   import mx.core.ILayoutElement;
   import spark.components.IconPlacement;
   import spark.core.IDisplayText;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.layouts.supportClasses.LayoutElementHelper;
   
   [ExcludeClass]
   public class LabelAndIconLayout extends LayoutBase
   {
      
      private var labelElement:ILayoutElement;
      
      private var iconElement:ILayoutElement;
      
      private var _gap:int = 6;
      
      private var _iconPlacement:String = "left";
      
      private var _paddingLeft:Number = 0;
      
      private var _paddingRight:Number = 0;
      
      private var _paddingTop:Number = 0;
      
      private var _paddingBottom:Number = 0;
      
      public function LabelAndIconLayout()
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
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get iconPlacement() : String
      {
         return this._iconPlacement;
      }
      
      public function set iconPlacement(value:String) : void
      {
         if(this._iconPlacement == value)
         {
            return;
         }
         this._iconPlacement = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         if(this._paddingLeft == value)
         {
            return;
         }
         this._paddingLeft = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         if(this._paddingRight == value)
         {
            return;
         }
         this._paddingRight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         if(this._paddingTop == value)
         {
            return;
         }
         this._paddingTop = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         if(this._paddingBottom == value)
         {
            return;
         }
         this._paddingBottom = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      override public function measure() : void
      {
         super.measure();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var width:Number = this._paddingLeft + this._paddingRight;
         var height:Number = this._paddingTop + this._paddingBottom;
         var horizontal:Boolean = this.iconPlacement == IconPlacement.LEFT || this.iconPlacement == IconPlacement.RIGHT;
         this.assignLayoutElements();
         var iconHeight:Number = Boolean(this.iconElement) ? Number(this.iconElement.getPreferredBoundsHeight()) : 0;
         var iconWidth:Number = Boolean(this.iconElement) ? Number(this.iconElement.getPreferredBoundsWidth()) : 0;
         var labelWidth:Number = Boolean(this.labelElement) && Boolean(IDisplayText(this.labelElement).text) ? Number(this.labelElement.getPreferredBoundsWidth()) : 0;
         var labelHeight:Number = Boolean(this.labelElement) && Boolean(IDisplayText(this.labelElement).text) ? Number(this.labelElement.getPreferredBoundsHeight()) : 0;
         if(horizontal)
         {
            width += labelWidth + iconWidth;
            if(Boolean(labelWidth) && Boolean(iconWidth))
            {
               width += this._gap;
            }
            height += Math.max(labelHeight,iconHeight);
         }
         else
         {
            width += Math.max(labelWidth,iconWidth);
            height += labelHeight + iconHeight;
            if(Boolean(labelHeight) && Boolean(iconHeight))
            {
               height += this._gap;
            }
         }
         layoutTarget.measuredWidth = Math.ceil(width);
         layoutTarget.measuredHeight = Math.ceil(height);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var gap:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var width:Number = this._paddingLeft + this._paddingRight;
         var height:Number = this._paddingTop + this._paddingBottom;
         var horizontal:Boolean = this.iconPlacement == IconPlacement.LEFT || this.iconPlacement == IconPlacement.RIGHT;
         this.assignLayoutElements();
         var iconHeight:Number = Boolean(this.iconElement) ? Number(this.iconElement.getPreferredBoundsHeight()) : 0;
         var iconWidth:Number = Boolean(this.iconElement) ? Number(this.iconElement.getPreferredBoundsWidth()) : 0;
         var validLabel:Boolean = Boolean(this.labelElement) && Boolean(IDisplayText(this.labelElement).text);
         var labelWidth:Number = validLabel ? Number(this.labelElement.getPreferredBoundsWidth()) : 0;
         var labelHeight:Number = validLabel ? Number(this.labelElement.getPreferredBoundsHeight()) : 0;
         var labelVerticalCenter:Number = validLabel ? LayoutElementHelper.parseConstraintValue(this.labelElement.verticalCenter) : 0;
         var labelX:Number = 0;
         var labelY:Number = 0;
         var iconX:Number = 0;
         var iconY:Number = 0;
         var viewWidth:Number = unscaledWidth - this._paddingLeft - this._paddingRight;
         var viewHeight:Number = unscaledHeight - this._paddingTop - this._paddingBottom;
         if(horizontal)
         {
            gap = Boolean(iconWidth) && Boolean(labelWidth) ? this._gap : 0;
            if(labelWidth > 0)
            {
               labelWidth = Math.max(Math.min(viewWidth - iconWidth - gap,labelWidth),0);
            }
            labelHeight = Math.min(unscaledHeight,labelHeight);
            labelX = (viewWidth - labelWidth - iconWidth - gap) / 2 + this.paddingLeft;
            if(this.iconPlacement == IconPlacement.LEFT)
            {
               labelX += iconWidth + gap;
               iconX = labelX - (iconWidth + gap);
            }
            else
            {
               iconX = labelX + labelWidth + gap;
            }
            if(this._paddingLeft + this._paddingRight + iconWidth > unscaledWidth)
            {
               iconX = unscaledWidth / 2 - iconWidth / 2;
            }
            iconY = (viewHeight - iconHeight) / 2 + this._paddingTop;
            labelY = (viewHeight - labelHeight) / 2 + this._paddingTop + labelVerticalCenter;
         }
         else
         {
            gap = Boolean(iconHeight) && Boolean(labelHeight) ? this._gap : 0;
            if(labelWidth > 0)
            {
               labelWidth = Math.max(viewWidth,0);
               labelHeight = Math.min(viewHeight - iconHeight - gap,labelHeight);
            }
            labelX = this._paddingLeft;
            iconX += (viewWidth - iconWidth) / 2 + this._paddingLeft;
            if(this.iconPlacement == IconPlacement.BOTTOM)
            {
               labelY += (viewHeight - labelHeight - iconHeight - gap) / 2 + labelVerticalCenter + this._paddingTop;
               iconY += labelY + labelHeight + gap;
            }
            else
            {
               iconY = (viewHeight - labelHeight - iconHeight - gap) / 2 + this._paddingTop;
               labelY += iconY + iconHeight + gap + labelVerticalCenter;
            }
            if(this._paddingTop + this._paddingBottom + iconHeight > unscaledHeight)
            {
               iconY = unscaledHeight / 2 - iconHeight / 2;
            }
         }
         if(Boolean(this.labelElement))
         {
            this.labelElement.setLayoutBoundsSize(labelWidth,labelHeight);
            this.labelElement.setLayoutBoundsPosition(Math.ceil(labelX),Math.ceil(labelY));
         }
         if(Boolean(this.iconElement))
         {
            this.iconElement.setLayoutBoundsSize(iconWidth,iconHeight);
            this.iconElement.setLayoutBoundsPosition(Math.ceil(iconX),Math.ceil(iconY));
         }
         layoutTarget.setContentSize(Math.ceil(Math.max(unscaledWidth,Math.max(iconWidth,labelWidth))),Math.ceil(Math.max(unscaledHeight,Math.max(iconHeight,labelHeight))));
      }
      
      private function invalidateTargetSizeAndDisplayList() : void
      {
         var g:GroupBase = target;
         if(!g)
         {
            return;
         }
         g.invalidateSize();
         g.invalidateDisplayList();
      }
      
      private function assignLayoutElements() : void
      {
         var layoutElement:ILayoutElement = null;
         for(var i:int = 0; i < target.numElements; i++)
         {
            layoutElement = target.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               if(layoutElement is IDisplayText)
               {
                  this.labelElement = layoutElement;
               }
               else
               {
                  this.iconElement = layoutElement;
               }
            }
         }
      }
   }
}

