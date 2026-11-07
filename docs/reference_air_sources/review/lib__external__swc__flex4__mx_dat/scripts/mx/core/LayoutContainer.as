package mx.core
{
   import flash.events.Event;
   import mx.containers.BoxDirection;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.containers.utilityClasses.CanvasLayout;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.containers.utilityClasses.IConstraintLayout;
   import mx.containers.utilityClasses.Layout;
   
   [Exclude(name="y",kind="property")]
   [Exclude(name="x",kind="property")]
   [Exclude(name="toolTip",kind="property")]
   [Exclude(name="tabIndex",kind="property")]
   [Exclude(name="label",kind="property")]
   [Exclude(name="icon",kind="property")]
   [Exclude(name="direction",kind="property")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   public class LayoutContainer extends Container implements IConstraintLayout
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var useProgressiveLayout:Boolean = false;
      
      protected var layoutObject:Layout = new BoxLayout();
      
      protected var canvasLayoutClass:Class = CanvasLayout;
      
      protected var boxLayoutClass:Class = BoxLayout;
      
      private var resizeHandlerAdded:Boolean = false;
      
      private var preloadObj:Object;
      
      private var creationQueue:Array = [];
      
      private var processingCreationQueue:Boolean = false;
      
      private var _constraintColumns:Array = [];
      
      private var _constraintRows:Array = [];
      
      private var _layout:String = "vertical";
      
      public function LayoutContainer()
      {
         super();
         this.layoutObject.target = this;
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
      public function get constraintColumns() : Array
      {
         return this._constraintColumns;
      }
      
      public function set constraintColumns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintColumns)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintColumn(value[i]).container = this;
            }
            this._constraintColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
      public function get constraintRows() : Array
      {
         return this._constraintRows;
      }
      
      public function set constraintRows(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintRows)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintRow(value[i]).container = this;
            }
            this._constraintRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal,absolute",defaultValue="vertical")]
      [Bindable("layoutChanged")]
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(value:String) : void
      {
         if(this._layout != value)
         {
            this._layout = value;
            if(Boolean(this.layoutObject))
            {
               this.layoutObject.target = null;
            }
            if(this._layout == ContainerLayout.ABSOLUTE)
            {
               this.layoutObject = new this.canvasLayoutClass();
            }
            else
            {
               this.layoutObject = new this.boxLayoutClass();
               if(this._layout == ContainerLayout.VERTICAL)
               {
                  BoxLayout(this.layoutObject).direction = BoxDirection.VERTICAL;
               }
               else
               {
                  BoxLayout(this.layoutObject).direction = BoxDirection.HORIZONTAL;
               }
            }
            if(Boolean(this.layoutObject))
            {
               this.layoutObject.target = this;
            }
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("layoutChanged"));
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get usePadding() : Boolean
      {
         return this.layout != ContainerLayout.ABSOLUTE;
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.layoutObject.measure();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
         createBorder();
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.layoutChrome(unscaledWidth,unscaledHeight);
         if(!doingLayout)
         {
            createBorder();
         }
      }
   }
}

