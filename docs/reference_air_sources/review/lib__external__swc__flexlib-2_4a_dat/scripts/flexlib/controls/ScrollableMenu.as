package flexlib.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   import mx.controls.Menu;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.core.Application;
   import mx.core.ScrollPolicy;
   import mx.managers.PopUpManager;
   
   [IconFile("ScrollableMenu.png")]
   public class ScrollableMenu extends Menu
   {
      
      private var yShow:Object = 0;
      
      private var xShow:Object = 0;
      
      public function ScrollableMenu()
      {
         super();
      }
      
      public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean = true) : ScrollableMenu
      {
         var menu:ScrollableMenu = null;
         menu = new ScrollableMenu();
         menu.tabEnabled = false;
         menu.owner = DisplayObjectContainer(Application.application);
         menu.showRoot = showRoot;
         popUpMenu(menu,parent,mdp);
         return menu;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
         var newPolicy:String = null;
         newPolicy = value.toLowerCase();
         itemsSizeChanged = true;
         if(_verticalScrollPolicy != newPolicy)
         {
            _verticalScrollPolicy = newPolicy;
            dispatchEvent(new Event("verticalScrollPolicyChanged"));
         }
         invalidateDisplayList();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openSubMenu(row:IListItemRenderer) : void
      {
         var r:Menu = null;
         var menu:Menu = null;
         supposedToLoseFocus = true;
         r = getRootMenu();
         if(!IMenuItemRenderer(row).menu)
         {
            menu = createSubMenu();
            menu.maxHeight = this.maxHeight;
            menu.verticalScrollPolicy = this.verticalScrollPolicy;
            menu.variableRowHeight = this.variableRowHeight;
            menu.parentMenu = this;
            menu.owner = this;
            menu.showRoot = showRoot;
            menu.dataDescriptor = r.dataDescriptor;
            menu.styleName = r;
            menu.labelField = r.labelField;
            menu.labelFunction = r.labelFunction;
            menu.iconField = r.iconField;
            menu.iconFunction = r.iconFunction;
            menu.itemRenderer = r.itemRenderer;
            menu.rowHeight = r.rowHeight;
            menu.scaleY = r.scaleY;
            menu.scaleX = r.scaleX;
            if(Boolean(row.data) && Boolean(_dataDescriptor.isBranch(row.data)) && Boolean(_dataDescriptor.hasChildren(row.data)))
            {
               menu.dataProvider = _dataDescriptor.getChildren(row.data);
            }
            menu.sourceMenuBar = sourceMenuBar;
            menu.sourceMenuBarItem = sourceMenuBarItem;
            IMenuItemRenderer(row).menu = menu;
            PopUpManager.addPopUp(menu,r,false);
         }
         super.openSubMenu(row);
      }
      
      override protected function configureScrollBars() : void
      {
         var rowCount:int = 0;
         var offset:int = 0;
         var fillerRows:int = 0;
         var colCount:int = 0;
         var oldHorizontalScrollBar:Object = null;
         var oldVerticalScrollBar:Object = null;
         var roundedWidth:int = 0;
         var length:int = 0;
         var numRows:int = 0;
         rowCount = int(listItems.length);
         if(rowCount == 0)
         {
            return;
         }
         if(rowCount > 1 && rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height)
         {
            rowCount--;
         }
         offset = verticalScrollPosition - lockedRowCount - 1;
         fillerRows = 0;
         while(Boolean(rowCount) && listItems[rowCount - 1].length == 0)
         {
            if(!(Boolean(collection) && rowCount + offset >= collection.length))
            {
               break;
            }
            rowCount--;
            fillerRows++;
         }
         colCount = int(listItems[0].length);
         oldHorizontalScrollBar = horizontalScrollBar;
         oldVerticalScrollBar = verticalScrollBar;
         roundedWidth = Math.round(unscaledWidth);
         length = Boolean(collection) ? int(collection.length - lockedRowCount) : 0;
         numRows = rowCount - lockedRowCount;
         setScrollBarProperties(Math.round(listContent.width),roundedWidth,length,numRows);
         maxVerticalScrollPosition = Math.max(length - numRows,0);
      }
      
      override public function show(xShow:Object = null, yShow:Object = null) : void
      {
         this.xShow = xShow;
         this.yShow = yShow;
         super.show(xShow,yShow);
      }
      
      protected function createSubMenu() : Menu
      {
         return new ScrollableMenu();
      }
      
      override public function move(x:Number, y:Number) : void
      {
         invalidateSize();
         super.move(x,y);
      }
      
      override public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      override protected function measure() : void
      {
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var pt:Point = null;
         var stageHeightAvailable:Number = NaN;
         super.measure();
         if(measuredHeight > this.maxHeight)
         {
            measuredHeight = this.maxHeight;
         }
         if(verticalScrollPolicy == ScrollPolicy.ON || verticalScrollPolicy == ScrollPolicy.AUTO)
         {
            if(Boolean(verticalScrollBar))
            {
               measuredMinWidth = measuredWidth = measuredWidth + verticalScrollBar.minWidth;
            }
         }
         xPos = xShow != x ? Number(xShow) : 0;
         yPos = yShow != y ? Number(yShow) : 0;
         pt = new Point(xPos,yPos);
         pt = this.localToGlobal(pt);
         stageHeightAvailable = screen.y + screen.height - pt.y - 10;
         if(stageHeightAvailable < measuredHeight)
         {
            measuredHeight = stageHeightAvailable;
            invalidateSize();
         }
         commitProperties();
      }
   }
}

