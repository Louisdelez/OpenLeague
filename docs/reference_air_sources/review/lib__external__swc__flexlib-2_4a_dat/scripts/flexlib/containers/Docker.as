package flexlib.containers
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.containers.utilityClasses.Layout;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   [Style(name="rowStyleName",type="String",inherit="no")]
   [Style(name="dockingAreaStyleName",type="String",inherit="no")]
   public class Docker extends Container
   {
      
      private var dockerViewMetrics:EdgeMetrics;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragProxy:UIComponent;
      
      private var bottomBar:VBox;
      
      private var topBar:VBox;
      
      private var layoutObject:Layout;
      
      public function Docker()
      {
         super();
         layoutObject = new BoxLayout();
         layoutObject.target = this;
         percentHeight = percentWidth = 100;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dragOver(item:DockableToolBar, event:MouseEvent, finalPlacement:Boolean = false) : Boolean
      {
         var pt:Point = null;
         var toolbar:VBox = null;
         var x1:int = 0;
         var y1:int = 0;
         var x2:int = 0;
         var y2:int = 0;
         var rowIndex:int = 0;
         var colIndex:int = 0;
         var createNewRow:Boolean = false;
         var row:HBox = null;
         var i:int = 0;
         var child:DisplayObject = null;
         var j:int = 0;
         var p:UIComponent = null;
         var g:Graphics = null;
         pt = new Point(event.stageX,event.stageY);
         pt = globalToLocal(pt);
         if(pt.y < topBar.height + 15)
         {
            toolbar = topBar;
         }
         else if(pt.y > bottomBar.y - 15)
         {
            toolbar = bottomBar;
            pt.y -= bottomBar.y;
         }
         if(!dragProxy)
         {
            dragProxy = new UIComponent();
            PopUpManager.addPopUp(dragProxy,this);
         }
         else
         {
            dragProxy.graphics.clear();
         }
         if(Boolean(toolbar))
         {
            rowIndex = int(toolbar.numChildren);
            createNewRow = true;
            y1 = y2 = int(toolbar.height);
            x2 = int(toolbar.width);
            for(i = 0; i < toolbar.numChildren; i++)
            {
               row = HBox(toolbar.getChildAt(i));
               if(pt.y <= row.y + row.height * 0.25)
               {
                  rowIndex = i;
                  y1 = y2 = int(row.y);
                  break;
               }
               if(pt.y >= row.y && pt.y <= row.y + row.height * 0.75)
               {
                  child = row.getChildAt(row.numChildren - 1);
                  x1 = x2 = child.x + child.width;
                  colIndex = int(row.numChildren);
                  rowIndex = i;
                  for(j = 0; j < row.numChildren; j++)
                  {
                     child = row.getChildAt(j);
                     if(pt.x < child.x + child.width / 2)
                     {
                        colIndex = j;
                        x2 = x1 = child.x;
                        break;
                     }
                  }
                  if(item.parent == row)
                  {
                     if(row.getChildIndex(item) == j - 1 || child == item)
                     {
                        return true;
                     }
                  }
                  else if(colIndex == row.numChildren && item.measuredWidth + row.measuredWidth > toolbar.width && !finalPlacement)
                  {
                     return true;
                  }
                  y1 = int(row.y);
                  y2 = row.y + row.height;
                  createNewRow = false;
                  break;
               }
            }
            if(finalPlacement)
            {
               if(createNewRow)
               {
                  row = createRow();
                  toolbar.addChildAt(row,rowIndex);
               }
               else
               {
                  row = HBox(toolbar.getChildAt(rowIndex));
               }
               p = UIComponent(item.parent);
               if(row == p && p.getChildIndex(item) < colIndex)
               {
                  colIndex--;
               }
               p.removeChild(item);
               row.addChildAt(item,colIndex);
               wrapRow(row,rowIndex,toolbar);
               if(p is HBox && p.numChildren == 0)
               {
                  p.parent.removeChild(p);
               }
            }
            else
            {
               pt = new Point(x1,toolbar.y + y1);
               pt = localToGlobal(pt);
               g = dragProxy.graphics;
               g.lineStyle(3,getStyle("themeColor"),0.5);
               g.drawRect(pt.x,pt.y,x2 - x1,y2 - y1);
               g.lineStyle(1,getStyle("themeColor"),1);
               g.drawRect(pt.x,pt.y,x2 - x1,y2 - y1);
            }
            return true;
         }
         return false;
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         var i:int = 0;
         var child:IUIComponent = null;
         super.createComponentsFromDescriptors();
         for(i = 0; i < numChildren; i++)
         {
            child = IUIComponent(getChildAt(i));
            if(child is DockableToolBar)
            {
               if(Boolean(contentPane))
               {
                  contentPane.removeChild(DisplayObject(child));
               }
               else
               {
                  removeChild(DisplayObject(child));
               }
               addToolBar(1,DockableToolBar(child));
               i--;
            }
         }
      }
      
      private function wrapRow(row:HBox, rowIndex:int, toolbar:VBox) : void
      {
         var totalW:int = 0;
         var newRow:HBox = null;
         var j:int = 0;
         var ch:DockableToolBar = null;
         totalW = 0;
         for(j = 0; j < row.numChildren; j++)
         {
            ch = DockableToolBar(row.getChildAt(j));
            totalW += ch.measuredWidth;
            if(totalW > toolbar.width && Boolean(j))
            {
               if(!newRow)
               {
                  if(toolbar.numChildren - 1 > rowIndex)
                  {
                     newRow = HBox(toolbar.getChildAt(rowIndex + 1));
                  }
                  else
                  {
                     newRow = createRow();
                     toolbar.addChildAt(newRow,rowIndex + 1);
                  }
               }
               ch.parent.removeChild(ch);
               newRow.addChild(ch);
            }
         }
         if(Boolean(newRow))
         {
            wrapRow(newRow,rowIndex + 1,toolbar);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         layoutObject.measure();
         measuredMinHeight = 0;
         measuredMinWidth = 0;
         topBar.minWidth = 0;
         bottomBar.minWidth = 0;
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var h:int = 0;
         super.layoutChrome(unscaledWidth,unscaledHeight);
         bm = borderMetrics;
         x = Number(bm.left);
         y = Number(bm.top);
         topBar.move(0,0);
         IFlexDisplayObject(topBar).setActualSize(unscaledWidth,topBar.getExplicitOrMeasuredHeight());
         h = int(bottomBar.getExplicitOrMeasuredHeight());
         bottomBar.move(0,unscaledHeight - h);
         IFlexDisplayObject(bottomBar).setActualSize(unscaledWidth,h);
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         var vm:EdgeMetrics = null;
         var o:EdgeMetrics = null;
         if(!dockerViewMetrics)
         {
            dockerViewMetrics = new EdgeMetrics(0,0,0,0);
         }
         vm = dockerViewMetrics;
         o = super.viewMetrics;
         vm.left = o.left;
         vm.top = o.top;
         vm.right = o.right;
         vm.bottom = o.bottom;
         vm.top += topBar.getExplicitOrMeasuredHeight();
         vm.bottom += bottomBar.getExplicitOrMeasuredHeight();
         return vm;
      }
      
      override protected function createChildren() : void
      {
         var toolBarStyleName:String = null;
         if(!topBar)
         {
            topBar = new VBox();
            bottomBar = new VBox();
            bottomBar.percentWidth = topBar.percentWidth = 100;
            bottomBar.horizontalScrollPolicy = topBar.horizontalScrollPolicy = "off";
            bottomBar.verticalScrollPolicy = topBar.verticalScrollPolicy = "off";
            rawChildren.addChild(topBar);
            rawChildren.addChild(bottomBar);
         }
         toolBarStyleName = getStyle("dockingAreaStyleName");
         topBar.styleName = bottomBar.styleName = Boolean(toolBarStyleName) ? toolBarStyleName : this;
         super.createChildren();
      }
      
      private function createRow() : HBox
      {
         var row:HBox = null;
         var rowStyleName:String = null;
         row = new HBox();
         row.percentWidth = 100;
         row.horizontalScrollPolicy = "off";
         rowStyleName = getStyle("rowStyleName");
         row.styleName = Boolean(rowStyleName) ? rowStyleName : this;
         return row;
      }
      
      private function addToolBar(tb:int, child:DockableToolBar) : void
      {
         var toolbar:VBox = null;
         var row:HBox = null;
         toolbar = topBar;
         if(child.initialPosition == "bottom")
         {
            toolbar = bottomBar;
         }
         if(!toolbar.numChildren)
         {
            row = createRow();
            toolbar.addChild(row);
         }
         row = HBox(toolbar.getChildAt(toolbar.numChildren - 1));
         row.addChild(child);
         child.docker = this;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
         for(i = 0; i < topBar.numChildren; i++)
         {
            wrapRow(HBox(topBar.getChildAt(i)),i,topBar);
         }
         for(i = 0; i < bottomBar.numChildren; i++)
         {
            wrapRow(HBox(bottomBar.getChildAt(i)),i,bottomBar);
         }
      }
   }
}

