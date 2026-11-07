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
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal static var useProgressiveLayout:Boolean = false;
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
      private var _constraintColumns:Array = [];
      
      protected var layoutObject:Layout = new BoxLayout();
      
      private var _layout:String = "vertical";
      
      private var processingCreationQueue:Boolean = false;
      
      protected var boxLayoutClass:Class = BoxLayout;
      
      private var resizeHandlerAdded:Boolean = false;
      
      private var preloadObj:Object;
      
      private var creationQueue:Array = [];
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
      private var _constraintRows:Array = [];
      
      protected var canvasLayoutClass:Class = CanvasLayout;
      
      public function LayoutContainer()
      {
         super();
         layoutObject.target = this;
      }
      
      public function get constraintColumns() : Array
      {
         return _constraintColumns;
      }
      
      override mx_internal function get usePadding() : Boolean
      {
         return layout != ContainerLayout.ABSOLUTE;
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.layoutChrome(unscaledWidth,unscaledHeight);
         if(!doingLayout)
         {
            createBorder();
         }
      }
      
      public function set constraintColumns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != _constraintColumns)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintColumn(value[i]).container = this;
            }
            _constraintColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function set layout(value:String) : void
      {
         if(_layout != value)
         {
            _layout = value;
            if(Boolean(layoutObject))
            {
               layoutObject.target = null;
            }
            if(_layout == ContainerLayout.ABSOLUTE)
            {
               layoutObject = new canvasLayoutClass();
            }
            else
            {
               layoutObject = new boxLayoutClass();
               if(_layout == ContainerLayout.VERTICAL)
               {
                  BoxLayout(layoutObject).direction = BoxDirection.VERTICAL;
               }
               else
               {
                  BoxLayout(layoutObject).direction = BoxDirection.HORIZONTAL;
               }
            }
            if(Boolean(layoutObject))
            {
               layoutObject.target = this;
            }
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("layoutChanged"));
         }
      }
      
      public function get constraintRows() : Array
      {
         return _constraintRows;
      }
      
      override protected function measure() : void
      {
         super.measure();
         layoutObject.measure();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
         createBorder();
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal,absolute",defaultValue="vertical")]
      [Bindable("layoutChanged")]
      public function get layout() : String
      {
         return _layout;
      }
      
      public function set constraintRows(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != _constraintRows)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintRow(value[i]).container = this;
            }
            _constraintRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
   }
}

