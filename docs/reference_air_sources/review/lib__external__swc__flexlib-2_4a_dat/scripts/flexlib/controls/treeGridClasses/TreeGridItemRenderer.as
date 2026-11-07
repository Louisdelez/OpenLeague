package flexlib.controls.treeGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.controls.TreeGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IToolTip;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.events.TreeEvent;
   import mx.managers.ILayoutManagerClient;
   
   [Style(name="verticalTrunks",type="String",enumeration="none,normal,dotted",inherit="no")]
   [Style(name="testColor",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class TreeGridItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, ILayoutManagerClient, IListItemRenderer
   {
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      private var _data:Object;
      
      protected var icon:IFlexDisplayObject;
      
      private var listOwner:TreeGrid;
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var invalidateSizeFlag:Boolean = false;
      
      protected var trunk:Sprite;
      
      private var _listData:TreeGridListData;
      
      protected var label:UITextField;
      
      public function TreeGridItemRenderer()
      {
         super();
      }
      
      override public function set nestLevel(value:int) : void
      {
         super.nestLevel = value;
      }
      
      override protected function measure() : void
      {
         var w:Number = NaN;
         super.measure();
         w = Boolean(_data) ? _listData.indent : 5;
         w += 5;
         if(Boolean(disclosureIcon))
         {
            w += disclosureIcon.width;
         }
         if(Boolean(icon))
         {
            w += icon.measuredWidth;
         }
         if(label.width < 4 || label.height < 4)
         {
            label.width = 4;
            label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            w += label.getExplicitOrMeasuredWidth();
            measuredWidth = w;
            measuredHeight = label.getExplicitOrMeasuredHeight();
         }
         else
         {
            label.width = Math.max(explicitWidth - w,4);
            measuredHeight = label.getExplicitOrMeasuredHeight();
            if(Boolean(icon) && icon.measuredHeight > measuredHeight)
            {
               measuredHeight = icon.measuredHeight;
            }
         }
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      private function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = null;
         var pt:Point = null;
         var screen:Rectangle = null;
         var screenRight:Number = NaN;
         toolTip = event.toolTip;
         pt = new Point(0,0);
         pt = label.localToGlobal(pt);
         pt = root.globalToLocal(pt);
         toolTip.move(pt.x,pt.y + (height - toolTip.height) / 2);
         screen = systemManager.screen;
         screenRight = screen.x + screen.width;
         if(toolTip.x + toolTip.width > screenRight)
         {
            toolTip.move(screenRight - toolTip.width,toolTip.y);
         }
      }
      
      override protected function commitProperties() : void
      {
         var disclosureIconClass:Class = null;
         var disclosureInstance:* = undefined;
         var wrapper:SpriteAsset = null;
         var iconClass:Class = null;
         super.commitProperties();
         if(Boolean(icon))
         {
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(Boolean(disclosureIcon))
         {
            disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            removeChild(DisplayObject(disclosureIcon));
            disclosureIcon = null;
         }
         if(Boolean(trunk))
         {
            trunk.graphics.clear();
            removeChild(DisplayObject(trunk));
            trunk = null;
         }
         if(Boolean(_data))
         {
            listOwner = TreeGrid(_listData.owner);
            if(Boolean(_listData.disclosureIcon))
            {
               disclosureIconClass = _listData.disclosureIcon;
               disclosureInstance = new disclosureIconClass();
               if(!(disclosureInstance is InteractiveObject))
               {
                  wrapper = new SpriteAsset();
                  wrapper.addChild(disclosureInstance as DisplayObject);
                  disclosureIcon = wrapper as IFlexDisplayObject;
               }
               else
               {
                  disclosureIcon = disclosureInstance;
               }
               addChild(disclosureIcon as DisplayObject);
               disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            }
            if(_listData.trunk != "none")
            {
               trunk = new Sprite();
               addChild(trunk);
            }
            if(Boolean(_listData.icon))
            {
               iconClass = _listData.icon;
               icon = new iconClass();
               addChild(DisplayObject(icon));
            }
            label.text = _listData.label;
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.wordWrap;
            if(listOwner.showDataTips)
            {
               if(label.textWidth > label.width || listOwner.dataTipFunction != null)
               {
                  toolTip = listOwner.itemToDataTip(_data);
               }
               else
               {
                  toolTip = null;
               }
            }
            else
            {
               toolTip = null;
            }
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
         invalidateDisplayList();
      }
      
      private function disclosureMouseDownHandler(event:Event) : void
      {
         var open:Boolean = false;
         event.stopPropagation();
         open = _listData.open;
         _listData.open = !open;
         listOwner.dispatchTreeEvent(TreeEvent.ITEM_OPENING,_listData,this,event,!open,true);
      }
      
      public function set listData(value:BaseListData) : void
      {
         if(!value)
         {
            return;
         }
         _listData = TreeGridListData(value);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!label)
         {
            label = new UITextField();
            label.styleName = this;
            addChild(label);
         }
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var startx:Number = NaN;
         var labelColor:Number = NaN;
         var i:int = 0;
         var currentx:Number = NaN;
         var endy:Number = NaN;
         var test:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         startx = Boolean(_data) ? _listData.indent : 0;
         startx += 5;
         if(Boolean(disclosureIcon))
         {
            disclosureIcon.x = startx;
            startx = disclosureIcon.x + disclosureIcon.width;
            disclosureIcon.setActualSize(disclosureIcon.width,disclosureIcon.height);
            disclosureIcon.visible = Boolean(_data) ? _listData.hasChildren : false;
         }
         if(Boolean(trunk))
         {
            trunk.graphics.clear();
            trunk.graphics.lineStyle(1,16777215,0.5);
            for(i = 0; i < _listData.depth - 1; i++)
            {
               currentx = 5 + i * _listData.indentationGap;
               trunk.graphics.moveTo(currentx + disclosureIcon.width / 2,0 - _listData.trunkOffsetTop);
               trunk.graphics.lineTo(currentx + disclosureIcon.width / 2,this.height + _listData.trunkOffsetBottom);
            }
            if(Boolean(disclosureIcon) && Boolean(disclosureIcon.visible))
            {
               trunk.graphics.moveTo(startx - disclosureIcon.width / 2,0 - _listData.trunkOffsetTop);
               trunk.graphics.lineTo(startx - disclosureIcon.width / 2,disclosureIcon.y);
               if(_listData.hasSibling)
               {
                  trunk.graphics.moveTo(startx - disclosureIcon.width / 2,disclosureIcon.y + disclosureIcon.height);
                  trunk.graphics.lineTo(startx - disclosureIcon.width / 2,this.height + _listData.trunkOffsetBottom);
               }
               trunk.graphics.moveTo(startx,disclosureIcon.y + disclosureIcon.height / 2);
               trunk.graphics.lineTo(startx + _listData.indentationGap / 3,disclosureIcon.y + disclosureIcon.height / 2);
               startx += _listData.indentationGap / 3;
            }
            else if(!disclosureIcon.visible)
            {
               endy = 0;
               if(_listData.hasSibling)
               {
                  endy = this.height + _listData.trunkOffsetBottom;
               }
               else
               {
                  endy = disclosureIcon.y + disclosureIcon.height / 2;
               }
               trunk.graphics.moveTo(startx - disclosureIcon.width / 2,0 - _listData.trunkOffsetTop);
               trunk.graphics.lineTo(startx - disclosureIcon.width / 2,endy);
               trunk.graphics.moveTo(startx - disclosureIcon.width / 2,disclosureIcon.y + disclosureIcon.height / 2);
               trunk.graphics.lineTo(startx + _listData.indentationGap / 3,disclosureIcon.y + disclosureIcon.height / 2);
               startx += _listData.indentationGap / 3;
            }
         }
         if(Boolean(icon))
         {
            icon.x = startx;
            startx = icon.x + icon.measuredWidth;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
         }
         label.x = startx;
         label.setActualSize(unscaledWidth - startx,measuredHeight);
         if(label.truncateToFit())
         {
            label.toolTip = _listData.label;
         }
         label.y = (unscaledHeight - label.height) / 2;
         if(Boolean(icon))
         {
            icon.y = (unscaledHeight - icon.height) / 2;
         }
         if(Boolean(disclosureIcon))
         {
            disclosureIcon.y = (unscaledHeight - disclosureIcon.height) / 2;
         }
         if(Boolean(data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = Number(getStyle("disabledColor"));
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               labelColor = Number(getStyle("textRollOverColor"));
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               labelColor = Number(getStyle("textSelectedColor"));
            }
            else
            {
               labelColor = Number(getStyle("color"));
            }
            test = Number(getStyle("testColor"));
            label.setColor(labelColor);
         }
      }
   }
}

