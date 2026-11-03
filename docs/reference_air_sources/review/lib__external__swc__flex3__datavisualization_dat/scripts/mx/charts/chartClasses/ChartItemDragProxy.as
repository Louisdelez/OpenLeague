package mx.charts.chartClasses
{
   import flash.display.DisplayObject;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.charts.ChartItem;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   
   public class ChartItemDragProxy extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function ChartItemDragProxy()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var src:DisplayObject = null;
         var o:ChartItem = null;
         var className:String = null;
         var obj:Object = null;
         var classRef:Class = null;
         super.createChildren();
         var items:Array = ChartBase(owner).selectedChartItems;
         var n:int = int(items.length);
         for(var i:int = 0; i < n; i++)
         {
            src = items[i].itemRenderer;
            if(src)
            {
               o = items[i].clone();
               className = getQualifiedClassName(o.itemRenderer);
               classRef = getDefinitionByName(className) as Class;
               obj = new classRef();
               obj.data = IDataRenderer(o.itemRenderer).data;
               if((o.itemRenderer as Object).hasOwnProperty("styleName"))
               {
                  obj.styleName = Object(o.itemRenderer).styleName;
               }
               o.itemRenderer = IFlexDisplayObject(obj);
               addChild(DisplayObject(o.itemRenderer));
               o.itemRenderer.setActualSize(src.width,src.height);
               o.itemRenderer.x = src.x;
               o.itemRenderer.y = src.y;
               measuredHeight = Math.max(measuredHeight,o.itemRenderer.y + o.itemRenderer.height);
               measuredWidth = Math.max(measuredWidth,o.itemRenderer.x + o.itemRenderer.width);
            }
         }
         invalidateDisplayList();
      }
   }
}

