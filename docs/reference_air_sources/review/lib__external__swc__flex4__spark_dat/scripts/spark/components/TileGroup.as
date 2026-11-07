package spark.components
{
   import flash.events.Event;
   import spark.layouts.TileLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   [Exclude(name="layout",kind="property")]
   [IconFile("TileGroup.png")]
   public class TileGroup extends Group
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TileGroup()
      {
         super();
         super.layout = new TileLayout();
      }
      
      private function get tileLayout() : TileLayout
      {
         return TileLayout(layout);
      }
      
      [Inspectable(category="General",enumeration="left,justifyUsingGap,justifyUsingWidth",defaultValue="left")]
      public function get columnAlign() : String
      {
         return this.tileLayout.columnAlign;
      }
      
      public function set columnAlign(value:String) : void
      {
         this.tileLayout.columnAlign = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get columnCount() : int
      {
         return this.tileLayout.columnCount;
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get columnWidth() : int
      {
         return this.tileLayout.columnWidth;
      }
      
      public function set columnWidth(value:int) : void
      {
         this.tileLayout.columnWidth = value;
      }
      
      [Inspectable(category="General",enumeration="left,right,center,justify",defaultValue="justify")]
      public function get horizontalAlign() : String
      {
         return this.tileLayout.horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         this.tileLayout.horizontalAlign = value;
      }
      
      [Inspectable(category="General",defaultValue="6")]
      [Bindable("propertyChange")]
      public function get horizontalGap() : int
      {
         return this.tileLayout.horizontalGap;
      }
      
      public function set horizontalGap(value:int) : void
      {
         this.tileLayout.horizontalGap = value;
      }
      
      [Inspectable(category="General",enumeration="rows,columns",defaultValue="rows")]
      public function get orientation() : String
      {
         return this.tileLayout.orientation;
      }
      
      public function set orientation(value:String) : void
      {
         this.tileLayout.orientation = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingLeft() : Number
      {
         return this.tileLayout.paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         this.tileLayout.paddingLeft = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingRight() : Number
      {
         return this.tileLayout.paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         this.tileLayout.paddingRight = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingTop() : Number
      {
         return this.tileLayout.paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         this.tileLayout.paddingTop = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingBottom() : Number
      {
         return this.tileLayout.paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         this.tileLayout.paddingBottom = value;
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedColumnCount() : int
      {
         return this.tileLayout.requestedColumnCount;
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         this.tileLayout.requestedColumnCount = value;
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedRowCount() : int
      {
         return this.tileLayout.requestedRowCount;
      }
      
      public function set requestedRowCount(value:int) : void
      {
         this.tileLayout.requestedRowCount = value;
      }
      
      [Inspectable(category="General",enumeration="top,justifyUsingGap,justifyUsingHeight",defaultValue="top")]
      public function get rowAlign() : String
      {
         return this.tileLayout.rowAlign;
      }
      
      public function set rowAlign(value:String) : void
      {
         this.tileLayout.rowAlign = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rowCount() : int
      {
         return this.tileLayout.rowCount;
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get rowHeight() : int
      {
         return this.tileLayout.rowHeight;
      }
      
      public function set rowHeight(value:int) : void
      {
         this.tileLayout.rowHeight = value;
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle,justify",defaultValue="justify")]
      public function get verticalAlign() : String
      {
         return this.tileLayout.verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         this.tileLayout.verticalAlign = value;
      }
      
      [Inspectable(category="General",defaultValue="6")]
      [Bindable("propertyChange")]
      public function get verticalGap() : int
      {
         return this.tileLayout.verticalGap;
      }
      
      public function set verticalGap(value:int) : void
      {
         this.tileLayout.verticalGap = value;
      }
      
      override public function set layout(value:LayoutBase) : void
      {
         throw new Error(resourceManager.getString("components","layoutReadOnly"));
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == "propertyChange")
         {
            if(!hasEventListener(type))
            {
               this.tileLayout.addEventListener(type,this.redispatchHandler);
            }
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(type == "propertyChange")
         {
            if(!hasEventListener(type))
            {
               this.tileLayout.removeEventListener(type,this.redispatchHandler);
            }
         }
      }
      
      private function redispatchHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

