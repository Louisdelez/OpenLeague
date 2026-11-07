package mx.containers
{
   import flash.events.Event;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.core.Container;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var layoutObject:BoxLayout = new BoxLayout();
      
      public function Box()
      {
         super();
         mx_internal::layoutObject.target = this;
      }
      
      mx_internal function isVertical() : Boolean
      {
         return direction != BoxDirection.HORIZONTAL;
      }
      
      public function set direction(value:String) : void
      {
         layoutObject.direction = value;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      public function pixelsToPercent(pxl:Number) : Number
      {
         var child:IUIComponent = null;
         var size:Number = NaN;
         var perc:Number = NaN;
         var vertical:Boolean = isVertical();
         var totalPerc:Number = 0;
         var totalSize:Number = 0;
         var n:int = numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(getChildAt(i));
            size = vertical ? Number(child.height) : Number(child.width);
            perc = vertical ? child.percentHeight : child.percentWidth;
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
      
      override protected function measure() : void
      {
         super.measure();
         layoutObject.measure();
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return layoutObject.direction;
      }
   }
}

