package spark.components.supportClasses
{
   import flash.events.Event;
   import flash.geom.Point;
   import spark.components.DataRenderer;
   import spark.components.IItemRenderer;
   import spark.components.ResizeMode;
   
   public class ItemRenderer extends DataRenderer implements IItemRenderer
   {
      
      private var interactionStateDetector:InteractionStateDetector;
      
      private var rendererStateIsDirty:Boolean = false;
      
      private var playTransitionsOnNextRendererState:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var playTransitions:Boolean = true;
      
      private var _autoDrawBackground:Boolean = true;
      
      private var _down:Boolean = false;
      
      private var _hovered:Boolean = false;
      
      private var _itemIndex:int;
      
      public var labelDisplay:TextBase;
      
      private var _showsCaret:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      private var _label:String = "";
      
      public function ItemRenderer()
      {
         super();
         this.rendererStateIsDirty = true;
         this.interactionStateDetector = new InteractionStateDetector(this);
         this.interactionStateDetector.addEventListener(Event.CHANGE,this.interactionStateDetector_changeHandler);
      }
      
      public function get autoDrawBackground() : Boolean
      {
         return this._autoDrawBackground;
      }
      
      public function set autoDrawBackground(value:Boolean) : void
      {
         if(this._autoDrawBackground == value)
         {
            return;
         }
         this._autoDrawBackground = value;
         if(this._autoDrawBackground)
         {
            redrawRequested = true;
            super.$invalidateDisplayList();
         }
      }
      
      protected function get down() : Boolean
      {
         return this._down;
      }
      
      protected function set down(value:Boolean) : void
      {
         if(value != this._down)
         {
            this._down = value;
            this.invalidateRendererState();
            if(this.autoDrawBackground)
            {
               redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
      }
      
      protected function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      protected function set hovered(value:Boolean) : void
      {
         if(value != this._hovered)
         {
            this._hovered = value;
            this.invalidateRendererState();
            if(this.autoDrawBackground)
            {
               redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
      }
      
      [Bindable("itemIndexChanged")]
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(value:int) : void
      {
         if(value == this._itemIndex)
         {
            return;
         }
         this._itemIndex = value;
         if(this.autoDrawBackground)
         {
            redrawRequested = true;
            super.$invalidateDisplayList();
         }
         dispatchEvent(new Event("itemIndexChanged"));
      }
      
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(value:Boolean) : void
      {
         if(value == this._showsCaret)
         {
            return;
         }
         this._showsCaret = value;
         this.invalidateRendererState();
         if(this.autoDrawBackground)
         {
            redrawRequested = true;
            super.$invalidateDisplayList();
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(value != this._selected)
         {
            this._selected = value;
            this.invalidateRendererState();
            if(this.autoDrawBackground)
            {
               redrawRequested = true;
               super.$invalidateDisplayList();
            }
         }
      }
      
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(value:Boolean) : void
      {
         if(value != this._dragging)
         {
            this._dragging = value;
            this.invalidateRendererState();
         }
      }
      
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         if(value == this._label)
         {
            return;
         }
         this._label = value;
         if(Boolean(this.labelDisplay))
         {
            this.labelDisplay.text = this._label;
         }
         dispatchEvent(new Event("labelChanged"));
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition() || !this.labelDisplay)
         {
            return super.baselinePosition;
         }
         var labelPosition:Point = globalToLocal(this.labelDisplay.parent.localToGlobal(new Point(this.labelDisplay.x,this.labelDisplay.y)));
         return labelPosition.y + this.labelDisplay.baselinePosition;
      }
      
      protected function getCurrentRendererState() : String
      {
         if(this.dragging && Boolean(hasState("dragging")))
         {
            return "dragging";
         }
         if(this.selected && this.down && Boolean(hasState("downAndSelected")))
         {
            return "downAndSelected";
         }
         if(this.selected && this.showsCaret && Boolean(hasState("selectedAndShowsCaret")))
         {
            return "selectedAndShowsCaret";
         }
         if(this.hovered && this.showsCaret && Boolean(hasState("hoveredAndShowsCaret")))
         {
            return "hoveredAndShowsCaret";
         }
         if(this.showsCaret && Boolean(hasState("normalAndShowsCaret")))
         {
            return "normalAndShowsCaret";
         }
         if(this.down && Boolean(hasState("down")))
         {
            return "down";
         }
         if(this.selected && Boolean(hasState("selected")))
         {
            return "selected";
         }
         if(this.hovered && Boolean(hasState("hovered")))
         {
            return "hovered";
         }
         if(hasState("normal"))
         {
            return "normal";
         }
         return currentState;
      }
      
      protected function invalidateRendererState() : void
      {
         this.playTransitionsOnNextRendererState = this.playTransitionsOnNextRendererState || this.playTransitions;
         if(this.rendererStateIsDirty)
         {
            return;
         }
         this.rendererStateIsDirty = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         if(this.rendererStateIsDirty)
         {
            setCurrentState(this.getCurrentRendererState(),this.playTransitionsOnNextRendererState);
            this.playTransitionsOnNextRendererState = false;
            this.rendererStateIsDirty = false;
         }
         super.commitProperties();
      }
      
      override public function styleChanged(styleName:String) : void
      {
         var allStyles:Boolean = styleName == null || styleName == "styleName";
         super.styleChanged(styleName);
         if(this.autoDrawBackground && (allStyles || styleName == "alternatingItemColors" || styleName == "contentBackgroundColor" || styleName == "rollOverColor" || styleName == "downColor" || styleName == "selectionColor"))
         {
            redrawRequested = true;
            super.$invalidateDisplayList();
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBackground() : void
      {
         var backgroundColor:uint = 0;
         var alternatingColors:Array = null;
         var alternatingColorsStyle:Object = null;
         if(!this.autoDrawBackground)
         {
            super.drawBackground();
            return;
         }
         var w:Number = resizeMode == ResizeMode.SCALE ? Number(measuredWidth) : Number(unscaledWidth);
         var h:Number = resizeMode == ResizeMode.SCALE ? Number(measuredHeight) : Number(unscaledHeight);
         if(isNaN(w) || isNaN(h))
         {
            return;
         }
         graphics.clear();
         var drawBackground:Boolean = true;
         var downColor:* = getStyle("downColor");
         if(this.down && downColor !== undefined)
         {
            backgroundColor = downColor;
         }
         else if(this.selected)
         {
            backgroundColor = uint(getStyle("selectionColor"));
         }
         else if(this.hovered)
         {
            backgroundColor = uint(getStyle("rollOverColor"));
         }
         else
         {
            alternatingColorsStyle = getStyle("alternatingItemColors");
            if(Boolean(alternatingColorsStyle))
            {
               alternatingColors = alternatingColorsStyle is Array ? alternatingColorsStyle as Array : [alternatingColorsStyle];
            }
            if(Boolean(alternatingColors) && alternatingColors.length > 0)
            {
               styleManager.getColorNames(alternatingColors);
               backgroundColor = uint(alternatingColors[this.itemIndex % alternatingColors.length]);
            }
            else
            {
               drawBackground = false;
            }
         }
         graphics.beginFill(backgroundColor,drawBackground ? 1 : 0);
         if(this.showsCaret)
         {
            graphics.lineStyle(1,getStyle("selectionColor"));
            graphics.drawRect(0.5,0.5,w - 1,h - 1);
         }
         else
         {
            graphics.lineStyle();
            graphics.drawRect(0,0,w,h);
         }
         graphics.endFill();
      }
      
      private function interactionStateDetector_changeHandler(event:Event) : void
      {
         this.playTransitions = this.interactionStateDetector.playTransitions;
         this.down = this.interactionStateDetector.state == InteractionState.DOWN;
         this.hovered = this.interactionStateDetector.state == InteractionState.OVER;
         this.playTransitions = true;
      }
   }
}

