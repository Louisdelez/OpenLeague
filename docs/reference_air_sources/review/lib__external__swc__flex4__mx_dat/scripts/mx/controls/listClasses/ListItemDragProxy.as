package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   
   public class ListItemDragProxy extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ListItemDragProxy()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var src:IListItemRenderer = null;
         var o:IListItemRenderer = null;
         var contentHolder:ListBaseContentHolder = null;
         var listData:BaseListData = null;
         super.createChildren();
         var items:Array = ListBase(owner).selectedItems;
         var n:int = int(items.length);
         for(var i:int = 0; i < n; i++)
         {
            src = ListBase(owner).itemToItemRenderer(items[i]);
            if(src)
            {
               o = ListBase(owner).createItemRenderer(items[i]);
               o.styleName = ListBase(owner);
               addChild(DisplayObject(o));
               if(o is IDropInListItemRenderer)
               {
                  listData = IDropInListItemRenderer(src).listData;
                  IDropInListItemRenderer(o).listData = Boolean(items[i]) ? listData : null;
               }
               o.data = items[i];
               o.visible = true;
               contentHolder = src.parent as ListBaseContentHolder;
               o.setActualSize(src.width,src.height);
               o.x = src.x + contentHolder.leftOffset;
               o.y = src.y + contentHolder.topOffset;
               measuredHeight = Math.max(measuredHeight,o.y + o.height);
               measuredWidth = Math.max(measuredWidth,o.x + o.width);
            }
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var child:IListItemRenderer = null;
         super.measure();
         var w:Number = 0;
         var h:Number = 0;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as IListItemRenderer;
            if(Boolean(child))
            {
               w = Math.max(w,child.x + child.width);
               h = Math.max(h,child.y + child.height);
            }
         }
         measuredWidth = measuredMinWidth = w;
         measuredHeight = measuredMinHeight = h;
      }
   }
}

