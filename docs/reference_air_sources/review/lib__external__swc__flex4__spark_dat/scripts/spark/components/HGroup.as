package spark.components
{
   import flash.events.Event;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   [Exclude(name="layout",kind="property")]
   [IconFile("HGroup.png")]
   public class HGroup extends Group
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function HGroup()
      {
         super();
         super.layout = new HorizontalLayout();
      }
      
      private function get horizontalLayout() : HorizontalLayout
      {
         return HorizontalLayout(layout);
      }
      
      [Inspectable(category="General",defaultValue="6")]
      public function get gap() : int
      {
         return this.horizontalLayout.gap;
      }
      
      public function set gap(value:int) : void
      {
         this.horizontalLayout.gap = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get columnCount() : int
      {
         return this.horizontalLayout.columnCount;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingLeft() : Number
      {
         return this.horizontalLayout.paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         this.horizontalLayout.paddingLeft = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingRight() : Number
      {
         return this.horizontalLayout.paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         this.horizontalLayout.paddingRight = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingTop() : Number
      {
         return this.horizontalLayout.paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         this.horizontalLayout.paddingTop = value;
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get paddingBottom() : Number
      {
         return this.horizontalLayout.paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         this.horizontalLayout.paddingBottom = value;
      }
      
      [Inspectable(category="General")]
      public function get requestedMaxColumnCount() : int
      {
         return this.horizontalLayout.requestedMaxColumnCount;
      }
      
      public function set requestedMaxColumnCount(value:int) : void
      {
         this.horizontalLayout.requestedMaxColumnCount = value;
      }
      
      [Inspectable(category="General")]
      public function get requestedMinColumnCount() : int
      {
         return this.horizontalLayout.requestedMinColumnCount;
      }
      
      public function set requestedMinColumnCount(value:int) : void
      {
         this.horizontalLayout.requestedMinColumnCount = value;
      }
      
      [Inspectable(category="General")]
      public function get requestedColumnCount() : int
      {
         return this.horizontalLayout.requestedColumnCount;
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         this.horizontalLayout.requestedColumnCount = value;
      }
      
      [Inspectable(category="General")]
      public function get columnWidth() : Number
      {
         return this.horizontalLayout.columnWidth;
      }
      
      public function set columnWidth(value:Number) : void
      {
         this.horizontalLayout.columnWidth = value;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      public function get variableColumnWidth() : Boolean
      {
         return this.horizontalLayout.variableColumnWidth;
      }
      
      public function set variableColumnWidth(value:Boolean) : void
      {
         this.horizontalLayout.variableColumnWidth = value;
      }
      
      [Inspectable(category="General",enumeration="left,right,center",defaultValue="left")]
      public function get horizontalAlign() : String
      {
         return this.horizontalLayout.horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         this.horizontalLayout.horizontalAlign = value;
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle,justify,contentJustify,baseline",defaultValue="top")]
      public function get verticalAlign() : String
      {
         return this.horizontalLayout.verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         this.horizontalLayout.verticalAlign = value;
      }
      
      [Inspectable(category="General")]
      [Bindable("indexInViewChanged")]
      public function get firstIndexInView() : int
      {
         return this.horizontalLayout.firstIndexInView;
      }
      
      [Inspectable(category="General")]
      [Bindable("indexInViewChanged")]
      public function get lastIndexInView() : int
      {
         return this.horizontalLayout.lastIndexInView;
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
                  this.horizontalLayout.addEventListener(type,this.redispatchHandler);
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
                  this.horizontalLayout.removeEventListener(type,this.redispatchHandler);
               }
         }
      }
      
      private function redispatchHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

