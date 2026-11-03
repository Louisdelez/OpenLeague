package mx.containers
{
   import flash.events.Event;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.Container;
   import mx.core.IUIComponent;
   
   [Alternative(replacement="spark.components.BorderContainer",since="4.0")]
   [Alternative(replacement="spark.components.VGroup",since="4.0")]
   [Alternative(replacement="spark.components.HGroup",since="4.0")]
   [IconFile("Box.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   public class Box extends Container
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var layoutObject:BoxLayout = new BoxLayout();
      
      public function Box()
      {
         super();
         this.layoutObject.target = this;
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this.layoutObject.direction;
      }
      
      public function set direction(value:String) : void
      {
         this.layoutObject.direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
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
      }
      
      public function pixelsToPercent(pxl:Number) : Number
      {
         var child:IUIComponent = null;
         var size:Number = NaN;
         var perc:Number = NaN;
         var vertical:Boolean = this.isVertical();
         var totalPerc:Number = 0;
         var totalSize:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = getLayoutChildAt(i);
            size = vertical ? Number(child.height) : Number(child.width);
            perc = vertical ? Number(child.percentHeight) : Number(child.percentWidth);
            if(!isNaN(perc))
            {
               totalPerc += perc;
               totalSize += size;
            }
         }
         var p:Number = 100;
         if(totalSize != pxl)
         {
            p = totalSize * totalPerc / (totalSize - pxl) - totalPerc;
         }
         return p;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isVertical() : Boolean
      {
         return this.direction != BoxDirection.HORIZONTAL;
      }
   }
}

