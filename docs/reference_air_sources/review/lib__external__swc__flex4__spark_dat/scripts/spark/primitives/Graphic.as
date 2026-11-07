package spark.primitives
{
   import spark.components.Group;
   import spark.components.ResizeMode;
   import spark.layouts.BasicLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="tabEnabled",kind="property")]
   [Exclude(name="mouseFocusEnabled",kind="property")]
   [Exclude(name="layout",kind="property")]
   [Exclude(name="focusPane",kind="property")]
   [Exclude(name="focusEnabled",kind="property")]
   [Exclude(name="setFocus",kind="method")]
   public class Graphic extends Group
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var version:Number = 1;
      
      private var _viewHeight:Number;
      
      private var _viewWidth:Number;
      
      public function Graphic()
      {
         super();
         super.layout = new BasicLayout();
         resizeMode = ResizeMode.SCALE;
      }
      
      public function get viewHeight() : Number
      {
         return this._viewHeight;
      }
      
      public function set viewHeight(value:Number) : void
      {
         if(value != this._viewHeight)
         {
            this._viewHeight = value;
            invalidateSize();
         }
      }
      
      public function get viewWidth() : Number
      {
         return this._viewWidth;
      }
      
      public function set viewWidth(value:Number) : void
      {
         if(value != this._viewWidth)
         {
            this._viewWidth = value;
            invalidateSize();
         }
      }
      
      override public function set layout(value:LayoutBase) : void
      {
         throw new Error(resourceManager.getString("components","layoutReadOnly"));
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(!isNaN(this.viewWidth))
         {
            measuredMinWidth = measuredWidth = this.viewWidth;
         }
         if(!isNaN(this.viewHeight))
         {
            measuredMinHeight = measuredHeight = this.viewHeight;
         }
      }
   }
}

