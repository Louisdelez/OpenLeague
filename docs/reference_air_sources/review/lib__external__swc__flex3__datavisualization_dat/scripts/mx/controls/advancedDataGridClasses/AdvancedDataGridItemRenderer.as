package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IToolTip;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.styles.StyleProtoChain;
   
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class AdvancedDataGridItemRenderer extends UITextField implements IDataRenderer, IDropInListItemRenderer, ILayoutManagerClient, IListItemRenderer, IStyleClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var invalidateSizeFlag:Boolean = false;
      
      private var _data:Object;
      
      private var _listData:AdvancedDataGridListData;
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var _styleDeclaration:CSSStyleDeclaration;
      
      public function AdvancedDataGridItemRenderer()
      {
         super();
         tabEnabled = false;
         ignorePadding = false;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
         inheritingStyles = nonInheritingStyles = UIComponent.STYLE_UNINITIALIZED;
      }
      
      override public function initialize() : void
      {
         regenerateStyleCache(false);
      }
      
      public function validateDisplayList() : void
      {
         validateNow();
      }
      
      public function getClassStyleDeclarations() : Array
      {
         var s:CSSStyleDeclaration = null;
         var className:String = getQualifiedClassName(this);
         className = className.replace("::",".");
         var decls:Array = [];
         while(className != null && className != "mx.core.UIComponent" && className != "mx.core.UITextField")
         {
            s = StyleManager.getStyleDeclaration(className);
            if(Boolean(s))
            {
               decls.unshift(s);
            }
            try
            {
               className = getQualifiedSuperclassName(getDefinitionByName(className));
               className = className.replace("::",".");
            }
            catch(e:ReferenceError)
            {
               className = null;
            }
         }
         return decls;
      }
      
      public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
      }
      
      public function regenerateStyleCache(recursive:Boolean) : void
      {
         initProtoChain();
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return _styleDeclaration;
      }
      
      override public function set nestLevel(value:int) : void
      {
         super.nestLevel = value;
         UIComponentGlobals.layoutManager.invalidateProperties(this);
         invalidatePropertiesFlag = true;
         UIComponentGlobals.layoutManager.invalidateSize(this);
         invalidateSizeFlag = true;
      }
      
      public function validateSize(recursive:Boolean = false) : void
      {
         invalidateSizeFlag = false;
         validateNow();
      }
      
      protected function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = event.toolTip;
         var xPos:int = DisplayObject(systemManager).mouseX + 11;
         var yPos:int = DisplayObject(systemManager).mouseY + 22;
         var pt:Point = new Point(xPos,yPos);
         pt = DisplayObject(systemManager).localToGlobal(pt);
         pt = DisplayObject(systemManager.getSandboxRoot()).globalToLocal(pt);
         toolTip.move(pt.x,pt.y + (height - toolTip.height) / 2);
         var screen:Rectangle = toolTip.screen;
         var screenRight:Number = screen.x + screen.width;
         if(toolTip.x + toolTip.width > screenRight)
         {
            toolTip.move(screenRight - toolTip.width,toolTip.y);
         }
      }
      
      public function set styleDeclaration(value:CSSStyleDeclaration) : void
      {
         _styleDeclaration = value;
      }
      
      override public function validateNow() : void
      {
         var newColor:Number = NaN;
         if(Boolean(data) && Boolean(parent))
         {
            if(AdvancedDataGrid(_listData.owner).isItemHighlighted(_listData.uid))
            {
               newColor = getStyle("textRollOverColor");
            }
            else if(AdvancedDataGrid(_listData.owner).isItemSelected(_listData.uid))
            {
               newColor = getStyle("textSelectedColor");
            }
            else
            {
               newColor = getStyle("color");
            }
            if(newColor != explicitColor)
            {
               styleChangedFlag = true;
               explicitColor = newColor;
               invalidateDisplayList();
            }
         }
         super.validateNow();
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function clearStyle(styleProp:String) : void
      {
         setStyle(styleProp,undefined);
      }
      
      public function registerEffects(effects:Array) : void
      {
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      public function validateProperties() : void
      {
         var dg:AdvancedDataGrid = null;
         var column:AdvancedDataGridColumn = null;
         var dataTips:Boolean = false;
         invalidatePropertiesFlag = false;
         if(Boolean(_listData))
         {
            dg = AdvancedDataGrid(_listData.owner);
            column = dg.columns[_listData.columnIndex];
            text = _listData.label;
            if(_data is AdvancedDataGridColumn)
            {
               wordWrap = dg.columnHeaderWordWrap(column);
            }
            else
            {
               wordWrap = dg.columnWordWrap(column);
            }
            if(AdvancedDataGrid(_listData.owner).variableRowHeight)
            {
               multiline = true;
            }
            dataTips = dg.showDataTips;
            if(column.showDataTips == true)
            {
               dataTips = true;
            }
            if(column.showDataTips == false)
            {
               dataTips = false;
            }
            if(dataTips)
            {
               if(!(_data is AdvancedDataGridColumn) && (Boolean(textWidth > width || column.dataTipFunction || column.dataTipField || dg.dataTipFunction) || Boolean(dg.dataTipField)))
               {
                  toolTip = column.itemToDataTip(_data);
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
            text = " ";
            toolTip = null;
         }
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = AdvancedDataGridListData(value);
         if(Boolean(nestLevel) && !invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.invalidateProperties(this);
            invalidatePropertiesFlag = true;
            UIComponentGlobals.layoutManager.invalidateSize(this);
            invalidateSizeFlag = true;
         }
      }
      
      public function initProtoChain() : void
      {
         var classSelector:CSSStyleDeclaration = null;
         var inheritChain:Object = null;
         var typeSelector:CSSStyleDeclaration = null;
         styleChangedFlag = true;
         if(Boolean(styleName))
         {
            if(styleName is CSSStyleDeclaration)
            {
               classSelector = CSSStyleDeclaration(styleName);
            }
            else
            {
               if(styleName is IFlexDisplayObject)
               {
                  StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                  return;
               }
               if(styleName is String)
               {
                  classSelector = StyleManager.getStyleDeclaration("." + styleName);
               }
            }
         }
         var nonInheritChain:Object = StyleManager.stylesRoot;
         var p:IStyleClient = parent as IStyleClient;
         if(Boolean(p))
         {
            inheritChain = p.inheritingStyles;
            if(inheritChain == UIComponent.STYLE_UNINITIALIZED)
            {
               inheritChain = nonInheritChain;
            }
         }
         else
         {
            inheritChain = StyleManager.stylesRoot;
         }
         var typeSelectors:Array = getClassStyleDeclarations();
         var n:int = int(typeSelectors.length);
         for(var i:int = 0; i < n; i++)
         {
            typeSelector = typeSelectors[i];
            inheritChain = typeSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = typeSelector.addStyleToProtoChain(nonInheritChain,this);
         }
         if(Boolean(classSelector))
         {
            inheritChain = classSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = classSelector.addStyleToProtoChain(nonInheritChain,this);
         }
         inheritingStyles = Boolean(styleDeclaration) ? styleDeclaration.addStyleToProtoChain(inheritChain,this) : inheritChain;
         nonInheritingStyles = Boolean(styleDeclaration) ? styleDeclaration.addStyleToProtoChain(nonInheritChain,this) : nonInheritChain;
      }
      
      override public function getStyle(styleProp:String) : *
      {
         return Boolean(StyleManager.inheritingStyles[styleProp]) ? inheritingStyles[styleProp] : nonInheritingStyles[styleProp];
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         if(styleProp == "styleName")
         {
            styleName = newValue;
            return;
         }
         var isInheritingStyle:Boolean = Boolean(StyleManager.isInheritingStyle(styleProp));
         var isProtoChainInitialized:Boolean = inheritingStyles != UIComponent.STYLE_UNINITIALIZED;
         if(isInheritingStyle)
         {
            if(getStyle(styleProp) == newValue && isProtoChainInitialized)
            {
               return;
            }
            if(!styleDeclaration)
            {
               styleDeclaration = new CSSStyleDeclaration();
               styleDeclaration.setStyle(styleProp,newValue);
               if(isProtoChainInitialized)
               {
                  regenerateStyleCache(true);
               }
            }
            else
            {
               styleDeclaration.setStyle(styleProp,newValue);
            }
         }
         else
         {
            if(getStyle(styleProp) == newValue && isProtoChainInitialized)
            {
               return;
            }
            if(!styleDeclaration)
            {
               styleDeclaration = new CSSStyleDeclaration();
               styleDeclaration.setStyle(styleProp,newValue);
               if(isProtoChainInitialized)
               {
                  regenerateStyleCache(false);
               }
            }
            else
            {
               styleDeclaration.setStyle(styleProp,newValue);
            }
         }
         if(isProtoChainInitialized)
         {
            styleChanged(styleProp);
            notifyStyleChangeInChildren(styleProp,isInheritingStyle);
         }
      }
   }
}

