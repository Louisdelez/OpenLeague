package spark.components.gridClasses
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.IFlexModuleFactory;
   import mx.core.IUITextField;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import spark.components.TextArea;
   import spark.core.IEditableText;
   
   public class DefaultGridItemEditor extends GridItemEditor
   {
      
      private var _1004197030textArea:TextArea;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DefaultGridItemEditor()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._DefaultGridItemEditor_TextArea1_i()];
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function get value() : Object
      {
         return this.textArea.text;
      }
      
      override public function set value(newValue:Object) : void
      {
         this.textArea.text = newValue != null ? newValue.toString() : "";
      }
      
      override public function prepare() : void
      {
         var MAX_WIDTH_INCHES:uint = 0;
         var gridRect:Rectangle = null;
         var globalCellTopLeft:Point = null;
         super.prepare();
         var cellBounds:Rectangle = column.grid.getCellBounds(rowIndex,columnIndex);
         var textDisplay:IEditableText = this.textArea.textDisplay;
         var itemRenderer:IGridItemRenderer = dataGrid.grid.getItemRendererAt(rowIndex,columnIndex);
         if(itemRenderer is IUITextField)
         {
            textDisplay.multiline = IUITextField(itemRenderer).multiline;
            textDisplay.lineBreak = IUITextField(itemRenderer).wordWrap ? "toFit" : "explicit";
         }
         else if("multiline" in itemRenderer)
         {
            textDisplay.multiline = itemRenderer["multiline"];
         }
         else
         {
            textDisplay.multiline = false;
         }
         if(textDisplay.multiline == false && textDisplay.lineBreak == "explicit" && this.isTextAlignStart())
         {
            this.textArea.width = NaN;
            this.textArea.widthInChars = NaN;
            MAX_WIDTH_INCHES = 6;
            gridRect = dataGrid.grid.getVisibleRect();
            globalCellTopLeft = dataGrid.grid.localToGlobal(cellBounds.topLeft);
            this.textArea.maxWidth = Math.min(gridRect.right - globalCellTopLeft.x - 1,MAX_WIDTH_INCHES * Capabilities.screenDPI) - 2;
         }
         else
         {
            this.textArea.width = cellBounds.width + 1;
         }
         this.textArea.minWidth = cellBounds.width + 1;
         this.textArea.height = cellBounds.height + 1;
         var paddingTop:int = int(this.textArea.getStyle("paddingTop"));
         var paddingLeft:int = int(this.textArea.getStyle("paddingLeft"));
         var paddingBottom:int = int(this.textArea.getStyle("paddingBottom"));
         var paddingRight:int = int(this.textArea.getStyle("paddingRight"));
         this.textArea.setStyle("paddingTop",paddingTop + 3);
         this.textArea.setStyle("paddingLeft",paddingLeft + 3);
         this.textArea.setStyle("paddingBottom",paddingBottom + 3);
         this.textArea.setStyle("paddingRight",paddingRight + 4);
      }
      
      override public function setFocus() : void
      {
         this.textArea.setFocus();
         if(this.textArea.textDisplay.multiline)
         {
            this.textArea.selectAll();
         }
      }
      
      private function isTextAlignStart() : Boolean
      {
         var textAlign:String = this.textArea.getStyle("textAlign");
         if(textAlign == "start")
         {
            return true;
         }
         if(textAlign == "end")
         {
            return false;
         }
         var direction:String = this.textArea.getStyle("direction");
         if(direction == "ltr" && textAlign == "left" || direction == "rtl" && textAlign == "right")
         {
            return true;
         }
         return false;
      }
      
      private function _DefaultGridItemEditor_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.setStyle("horizontalScrollPolicy","off");
         _loc1_.setStyle("verticalScrollPolicy","off");
         _loc1_.id = "textArea";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.textArea = _loc1_;
         BindingManager.executeBindings(this,"textArea",this.textArea);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get textArea() : TextArea
      {
         return this._1004197030textArea;
      }
      
      public function set textArea(param1:TextArea) : void
      {
         var _loc2_:Object = this._1004197030textArea;
         if(_loc2_ !== param1)
         {
            this._1004197030textArea = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textArea",_loc2_,param1));
            }
         }
      }
   }
}

