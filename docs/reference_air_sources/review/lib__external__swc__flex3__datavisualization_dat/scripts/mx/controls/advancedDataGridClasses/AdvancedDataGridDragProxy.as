package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.collections.IGroupingCollection;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class AdvancedDataGridDragProxy extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function AdvancedDataGridDragProxy()
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
         var pt:Point = null;
         var col:AdvancedDataGridColumn = null;
         var c:IListItemRenderer = null;
         var label:String = null;
         var rowData:AdvancedDataGridListData = null;
         var itemWidth:Number = NaN;
         var groupLabelField:String = null;
         var adgDescription:AdvancedDataGridRendererDescription = null;
         super.createChildren();
         var advancedDataGrid:AdvancedDataGrid = AdvancedDataGrid(owner);
         var items:Array = advancedDataGrid.selectedItems;
         var n:int = int(items.length);
         for(var i:int = 0; i < n; i++)
         {
            src = advancedDataGrid.itemToItemRenderer(items[i]);
            if(src)
            {
               data = items[i];
               o = new UIComponent();
               addChild(DisplayObject(o));
               ww = 0;
               m = int(advancedDataGrid.visibleColumns.length);
               for(j = 0; j < m; j++)
               {
                  col = advancedDataGrid.visibleColumns[j];
                  c = advancedDataGrid.getRenderer(col,data,true);
                  label = col.itemToLabel(data);
                  if(Boolean(advancedDataGrid._rootModel) && Boolean(col.colNum == 0) && advancedDataGrid._rootModel.canHaveChildren(data))
                  {
                     if(advancedDataGrid._rootModel is IGroupingCollection && Boolean(IGroupingCollection(advancedDataGrid._rootModel).grouping))
                     {
                        groupLabelField = IGroupingCollection(advancedDataGrid._rootModel).grouping.label;
                     }
                     if(advancedDataGrid.groupLabelFunction != null)
                     {
                        label = advancedDataGrid.groupLabelFunction(data);
                     }
                     else if(groupLabelField != null && data.hasOwnProperty(groupLabelField))
                     {
                        label = data[groupLabelField];
                     }
                  }
                  rowData = new AdvancedDataGridListData(label,col.dataField,col.colNum,"",advancedDataGrid);
                  if(c is IDropInListItemRenderer)
                  {
                     IDropInListItemRenderer(c).listData = Boolean(data) ? rowData : null;
                  }
                  c.data = data;
                  c.styleName = advancedDataGrid;
                  c.visible = true;
                  o.addChild(DisplayObject(c));
                  itemWidth = advancedDataGrid.getWidthOfItem(c,col,j);
                  c.setActualSize(itemWidth,src.height);
                  c.move(ww,0);
                  ww += itemWidth;
                  if(advancedDataGrid.rendererProviders.length != 0)
                  {
                     adgDescription = advancedDataGrid.getRendererDescription(data,col,true);
                     if(Boolean(adgDescription) && Boolean(adgDescription.renderer))
                     {
                        if(adgDescription.columnSpan == 0)
                        {
                           break;
                        }
                        j += adgDescription.columnSpan - 1;
                     }
                  }
               }
               o.setActualSize(ww,src.height);
               pt = new Point(0,0);
               pt = DisplayObject(src).localToGlobal(pt);
               pt = AdvancedDataGrid(owner).globalToLocal(pt);
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

