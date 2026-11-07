package mx.controls.treeClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.Tree;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ToolTipEvent;
   import mx.events.TreeEvent;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class TreeItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      private var _listData:TreeListData;
      
      private var _data:Object;
      
      protected var label:IUITextField;
      
      private var listOwner:Tree;
      
      protected var icon:IFlexDisplayObject;
      
      public function TreeItemRenderer()
      {
         super();
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         var disclosureIconClass:Class = null;
         var disclosureInstance:* = undefined;
         var wrapper:SpriteAsset = null;
         var iconClass:Class = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            index = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(index);
         }
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
         if(_data != null)
         {
            listOwner = Tree(_listData.owner);
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
            if(Boolean(_listData.icon))
            {
               iconClass = _listData.icon;
               icon = new iconClass();
               addChild(DisplayObject(icon));
            }
            label.text = _listData.label;
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.wordWrap;
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
         invalidateDisplayList();
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = TreeListData(value);
         invalidateProperties();
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      mx_internal function createLabel(childIndex:int) : void
      {
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            if(childIndex == -1)
            {
               addChild(DisplayObject(label));
            }
            else
            {
               addChildAt(DisplayObject(label),childIndex);
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var w:Number = Boolean(_data) ? _listData.indent : 0;
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
      
      mx_internal function removeLabel() : void
      {
         if(label != null)
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createLabel(-1);
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      private function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         var toolTip:IToolTip = event.toolTip;
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         var pt:Point = new Point(0,0);
         pt = label.localToGlobal(pt);
         pt = sbRoot.globalToLocal(pt);
         toolTip.move(pt.x,pt.y + (height - toolTip.height) / 2);
         if(sm != sbRoot)
         {
            request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
            sbRoot.dispatchEvent(request);
            screen = Rectangle(request.value);
         }
         else
         {
            screen = sm.getVisibleApplicationRect();
         }
         var screenRight:Number = screen.x + screen.width;
         pt.x = toolTip.x;
         pt.y = toolTip.y;
         pt = sbRoot.localToGlobal(pt);
         if(pt.x + toolTip.width > screenRight)
         {
            toolTip.move(toolTip.x - (pt.x + toolTip.width - screenRight),toolTip.y);
         }
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      private function disclosureMouseDownHandler(event:Event) : void
      {
         event.stopPropagation();
         if(listOwner.isOpening || !listOwner.enabled)
         {
            return;
         }
         var open:Boolean = _listData.open;
         _listData.open = !open;
         listOwner.dispatchTreeEvent(TreeEvent.ITEM_OPENING,_listData.item,this,event,!open,true,true);
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      mx_internal function getDisclosureIcon() : IFlexDisplayObject
      {
         return disclosureIcon;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var labelColor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var startx:Number = Boolean(_data) ? _listData.indent : 0;
         if(Boolean(disclosureIcon))
         {
            disclosureIcon.x = startx;
            startx = disclosureIcon.x + disclosureIcon.width;
            disclosureIcon.setActualSize(disclosureIcon.width,disclosureIcon.height);
            disclosureIcon.visible = Boolean(_data) ? _listData.hasChildren : false;
         }
         if(Boolean(icon))
         {
            icon.x = startx;
            startx = icon.x + icon.measuredWidth;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
         }
         label.x = startx;
         label.setActualSize(unscaledWidth - startx,measuredHeight);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            label.y = 0;
            if(Boolean(icon))
            {
               icon.y = 0;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = 0;
            }
         }
         else if(verticalAlign == "bottom")
         {
            label.y = unscaledHeight - label.height + 2;
            if(Boolean(icon))
            {
               icon.y = unscaledHeight - icon.height;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = unscaledHeight - disclosureIcon.height;
            }
         }
         else
         {
            label.y = (unscaledHeight - label.height) / 2;
            if(Boolean(icon))
            {
               icon.y = (unscaledHeight - icon.height) / 2;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = (unscaledHeight - disclosureIcon.height) / 2;
            }
         }
         if(Boolean(data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = getStyle("disabledColor");
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               labelColor = getStyle("textRollOverColor");
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               labelColor = getStyle("textSelectedColor");
            }
            else
            {
               labelColor = getStyle("color");
            }
            label.setColor(labelColor);
         }
         if(_data != null)
         {
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
      }
   }
}

