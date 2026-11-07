package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class DataGridDragProxy extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function DataGridDragProxy()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var src:IListItemRenderer = null;
         var o:UIComponent = null;
         var data:Object = null;
         var ww:Number = NaN;
         var m:int = 0;
         var j:int = 0;
         var col:DataGridColumn = null;
         var c:IListItemRenderer = null;
         var rowData:DataGridListData = null;
         var pt:Point = null;
         super.createChildren();
         var items:Array = DataGridBase(owner).selectedItems;
         var n:int = int(items.length);
         for(var i:int = 0; i < n; i++)
         {
            src = DataGridBase(owner).itemToItemRenderer(items[i]);
            if(src)
            {
               data = items[i];
               o = new UIComponent();
               addChild(DisplayObject(o));
               o.layoutDirection = DataGridBase(owner).layoutDirection;
               ww = 0;
               if(Boolean(DataGridBase(owner).visibleLockedColumns))
               {
                  m = int(DataGridBase(owner).visibleLockedColumns.length);
                  for(j = 0; j < m; j++)
                  {
                     col = DataGridBase(owner).visibleLockedColumns[j];
                     c = DataGridBase(owner).createColumnItemRenderer(col,false,data);
                     rowData = new DataGridListData(col.itemToLabel(data),col.dataField,col.colNum,"",DataGridBase(owner));
                     c.styleName = DataGridBase(owner);
                     o.addChild(DisplayObject(c));
                     if(c is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(c).listData = Boolean(data) ? rowData : null;
                     }
                     c.data = data;
                     c.visible = true;
                     c.setActualSize(col.width,src.height);
                     c.move(ww,0);
                     ww += col.width;
                  }
               }
               m = int(DataGridBase(owner).visibleColumns.length);
               for(j = 0; j < m; j++)
               {
                  col = DataGridBase(owner).visibleColumns[j];
                  c = DataGridBase(owner).createColumnItemRenderer(col,false,data);
                  rowData = new DataGridListData(col.itemToLabel(data),col.dataField,col.colNum,"",DataGridBase(owner));
                  c.styleName = DataGridBase(owner);
                  o.addChild(DisplayObject(c));
                  if(c is IDropInListItemRenderer)
                  {
                     IDropInListItemRenderer(c).listData = Boolean(data) ? rowData : null;
                  }
                  c.data = data;
                  c.visible = true;
                  c.setActualSize(col.width,src.height);
                  c.move(ww,0);
                  ww += col.width;
               }
               o.setActualSize(ww,src.height);
               pt = new Point(0,0);
               pt = DisplayObject(src).localToGlobal(pt);
               pt = DataGridBase(owner).globalToLocal(pt);
               o.y = pt.y;
               measuredHeight = o.y + o.height;
               measuredWidth = ww;
            }
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var child:UIComponent = null;
         super.measure();
         var w:Number = 0;
         var h:Number = 0;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as UIComponent;
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

