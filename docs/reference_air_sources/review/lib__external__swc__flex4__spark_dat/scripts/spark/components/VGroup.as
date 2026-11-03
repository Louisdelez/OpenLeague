package spark.components
{
   import flash.events.Event;
   import spark.layouts.VerticalLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   [Exclude(name="layout",kind="property")]
   [IconFile("VGroup.png")]
   public class VGroup extends Group
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function VGroup()
      {
         super();
         super.layout = new VerticalLayout();
      }
      
      private function get verticalLayout() : VerticalLayout
      {
         return VerticalLayout(layout);
      }
      
      [Inspectable(category="General",defaultValue="6")]
      public function get gap() : int
      {
         return this.verticalLayout.gap;
      }
      
      public function set gap(value:int) : void
      {
         this.verticalLayout.gap = value;
      }
      
      [Inspectable(category="General",enumeration="left,right,center,justify,contentJustify",defaultValue="left")]
      public function get horizontalAlign() : String
      {
         return this.verticalLayout.horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         this.verticalLayout.horizontalAlign = value;
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle",defaultValue="top")]
      public function get verticalAlign() : String
      {
         return this.verticalLayout.verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         this.verticalLayout.verticalAlign = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingLeft() : Number
      {
         return this.verticalLayout.paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         this.verticalLayout.paddingLeft = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingRight() : Number
      {
         return this.verticalLayout.paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         this.verticalLayout.paddingRight = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingTop() : Number
      {
         return this.verticalLayout.paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         this.verticalLayout.paddingTop = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingBottom() : Number
      {
         return this.verticalLayout.paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         this.verticalLayout.paddingBottom = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rowCount() : int
      {
         return this.verticalLayout.rowCount;
      }
      
      [Inspectable(category="General")]
      public function get requestedMaxRowCount() : int
      {
         return this.verticalLayout.requestedMaxRowCount;
      }
      
      public function set requestedMaxRowCount(value:int) : void
      {
         this.verticalLayout.requestedMaxRowCount = value;
      }
      
      [Inspectable(category="General")]
      public function get requestedMinRowCount() : int
      {
         return this.verticalLayout.requestedMinRowCount;
      }
      
      public function set requestedMinRowCount(value:int) : void
      {
         this.verticalLayout.requestedMinRowCount = value;
      }
      
      [Inspectable(category="General")]
      public function get requestedRowCount() : int
      {
         return this.verticalLayout.requestedRowCount;
      }
      
      public function set requestedRowCount(value:int) : void
      {
         this.verticalLayout.requestedRowCount = value;
      }
      
      [Inspectable(category="General")]
      public function get rowHeight() : Number
      {
         return this.verticalLayout.rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         this.verticalLayout.rowHeight = value;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get variableRowHeight() : Boolean
      {
         return this.verticalLayout.variableRowHeight;
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         this.verticalLayout.variableRowHeight = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("indexInViewChanged")]
      public function get firstIndexInView() : int
      {
         return this.verticalLayout.firstIndexInView;
      }
      
      [Inspectable(category="General")]
      [Bindable("indexInViewChanged")]
      public function get lastIndexInView() : int
      {
         return this.verticalLayout.lastIndexInView;
      }
      
      override public function set layout(value:LayoutBase) : void
      {
         throw new Error(resourceManager.getString("components","layoutReadOnly"));
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         switch(type)
         {
            case "indexInViewChanged":
            case "propertyChange":
               if(!hasEventListener(type))
               {
                  this.verticalLayout.addEventListener(type,this.redispatchHandler);
               }
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         switch(type)
         {
            case "indexInViewChanged":
            case "propertyChange":
               if(!hasEventListener(type))
               {
                  this.verticalLayout.removeEventListener(type,this.redispatchHandler);
               }
         }
      }
      
      private function redispatchHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

