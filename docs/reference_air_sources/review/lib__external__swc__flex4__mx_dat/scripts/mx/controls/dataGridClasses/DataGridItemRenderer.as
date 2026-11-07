package mx.controls.dataGridClasses
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import mx.controls.DataGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IToolTip;
   import mx.core.UIComponentGlobals;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.styles.StyleProtoChain;
   import mx.utils.PopUpUtil;
   
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class DataGridItemRenderer extends UITextField implements IDataRenderer, IDropInListItemRenderer, ILayoutManagerClient, IListItemRenderer, IStyleClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var invalidatePropertiesFlag:Boolean = false;
      
      private var invalidateSizeFlag:Boolean = false;
      
      private var _data:Object;
      
      private var _listData:DataGridListData;
      
      private var _styleDeclaration:CSSStyleDeclaration;
      
      public function DataGridItemRenderer()
      {
         super();
         tabEnabled = false;
         mouseWheelEnabled = false;
         ignorePadding = false;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,this.toolTipShowHandler);
         inheritingStyles = nonInheritingStyles = StyleProtoChain.STYLE_UNINITIALIZED;
      }
      
      override public function set nestLevel(value:int) : void
      {
         super.nestLevel = value;
         UIComponentGlobals.layoutManager.invalidateProperties(this);
         this.invalidatePropertiesFlag = true;
         UIComponentGlobals.layoutManager.invalidateSize(this);
         this.invalidateSizeFlag = true;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = DataGridListData(value);
         if(Boolean(nestLevel) && !this.invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.invalidateProperties(this);
            this.invalidatePropertiesFlag = true;
            UIComponentGlobals.layoutManager.invalidateSize(this);
            this.invalidateSizeFlag = true;
         }
      }
      
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return this._styleDeclaration;
      }
      
      public function set styleDeclaration(value:CSSStyleDeclaration) : void
      {
         this._styleDeclaration = value;
      }
      
      override public function initialize() : void
      {
         this.regenerateStyleCache(false);
      }
      
      override public function validateNow() : void
      {
         var newColor:Number = NaN;
         if(Boolean(this.data) && Boolean(parent))
         {
            if(DataGridBase(this._listData.owner).isItemHighlighted(this._listData.uid))
            {
               newColor = this.getStyle("textRollOverColor");
            }
            else if(DataGridBase(this._listData.owner).isItemSelected(this._listData.uid))
            {
               newColor = this.getStyle("textSelectedColor");
            }
            else
            {
               newColor = this.getStyle("color");
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
      
      override public function getStyle(styleProp:String) : *
      {
         return Boolean(styleManager.inheritingStyles[styleProp]) ? inheritingStyles[styleProp] : nonInheritingStyles[styleProp];
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         if(styleProp == "styleName")
         {
            styleName = newValue;
            return;
         }
         var isInheritingStyle:Boolean = Boolean(styleManager.isInheritingStyle(styleProp));
         var isProtoChainInitialized:Boolean = inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED;
         if(isInheritingStyle)
         {
            if(this.getStyle(styleProp) == newValue && isProtoChainInitialized)
            {
               return;
            }
            if(!this.styleDeclaration)
            {
               this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
               this.styleDeclaration.setLocalStyle(styleProp,newValue);
               if(isProtoChainInitialized)
               {
                  this.regenerateStyleCache(true);
               }
            }
            else
            {
               this.styleDeclaration.setLocalStyle(styleProp,newValue);
            }
         }
         else
         {
            if(this.getStyle(styleProp) == newValue && isProtoChainInitialized)
            {
               return;
            }
            if(!this.styleDeclaration)
            {
               this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
               this.styleDeclaration.setLocalStyle(styleProp,newValue);
               if(isProtoChainInitialized)
               {
                  this.regenerateStyleCache(false);
               }
            }
            else
            {
               this.styleDeclaration.setLocalStyle(styleProp,newValue);
            }
         }
         if(isProtoChainInitialized)
         {
            styleChanged(styleProp);
            this.notifyStyleChangeInChildren(styleProp,isInheritingStyle);
         }
      }
      
      public function validateProperties() : void
      {
         var dg:DataGrid = null;
         var column:DataGridColumn = null;
         var dataTips:Boolean = false;
         this.invalidatePropertiesFlag = false;
         if(Boolean(this._listData))
         {
            dg = DataGrid(this._listData.owner);
            column = dg.columns[this._listData.columnIndex];
            text = this._listData.label;
            if(this._data is DataGridColumn)
            {
               wordWrap = dg.columnHeaderWordWrap(column);
            }
            else
            {
               wordWrap = dg.columnWordWrap(column);
            }
            if(DataGrid(this._listData.owner).variableRowHeight)
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
               if(!(this._data is DataGridColumn) && (Boolean(textWidth > width || column.dataTipFunction || column.dataTipField || dg.dataTipFunction) || Boolean(dg.dataTipField)))
               {
                  toolTip = column.itemToDataTip(this._data);
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
      
      public function validateSize(recursive:Boolean = false) : void
      {
         this.invalidateSizeFlag = false;
         this.validateNow();
      }
      
      public function validateDisplayList() : void
      {
         this.validateNow();
      }
      
      public function clearStyle(styleProp:String) : void
      {
         this.setStyle(styleProp,undefined);
      }
      
      public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
      }
      
      public function initProtoChain() : void
      {
         var styleNames:Array = null;
         var c:int = 0;
         var inheritChain:Object = null;
         var typeSelector:CSSStyleDeclaration = null;
         var classSelector:CSSStyleDeclaration = null;
         styleChangedFlag = true;
         var classSelectors:Array = [];
         if(Boolean(styleName))
         {
            if(styleName is CSSStyleDeclaration)
            {
               classSelectors.push(CSSStyleDeclaration(styleName));
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
                  styleNames = styleName.split(/\s+/);
                  for(c = 0; c < styleNames.length; c++)
                  {
                     if(Boolean(styleNames[c].length))
                     {
                        classSelectors.push(styleManager.getMergedStyleDeclaration("." + styleNames[c]));
                     }
                  }
               }
            }
         }
         var nonInheritChain:Object = styleManager.stylesRoot;
         var p:IStyleClient = parent as IStyleClient;
         if(Boolean(p))
         {
            inheritChain = p.inheritingStyles;
            if(inheritChain == StyleProtoChain.STYLE_UNINITIALIZED)
            {
               inheritChain = nonInheritChain;
            }
         }
         else
         {
            inheritChain = styleManager.stylesRoot;
         }
         var typeSelectors:Array = this.getClassStyleDeclarations();
         var n:int = int(typeSelectors.length);
         for(var i:int = 0; i < n; i++)
         {
            typeSelector = typeSelectors[i];
            inheritChain = typeSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = typeSelector.addStyleToProtoChain(nonInheritChain,this);
         }
         for(i = 0; i < classSelectors.length; i++)
         {
            classSelector = classSelectors[i];
            if(Boolean(classSelector))
            {
               inheritChain = classSelector.addStyleToProtoChain(inheritChain,this);
               nonInheritChain = classSelector.addStyleToProtoChain(nonInheritChain,this);
            }
         }
         inheritingStyles = Boolean(this.styleDeclaration) ? this.styleDeclaration.addStyleToProtoChain(inheritChain,this) : inheritChain;
         nonInheritingStyles = Boolean(this.styleDeclaration) ? this.styleDeclaration.addStyleToProtoChain(nonInheritChain,this) : nonInheritChain;
      }
      
      public function regenerateStyleCache(recursive:Boolean) : void
      {
         this.initProtoChain();
      }
      
      public function registerEffects(effects:Array) : void
      {
      }
      
      public function getClassStyleDeclarations() : Array
      {
         var s:CSSStyleDeclaration = null;
         var className:String = getQualifiedClassName(this);
         className = className.replace("::",".");
         var decls:Array = [];
         while(className != null && className != "mx.core.UIComponent" && className != "mx.core.UITextField")
         {
            s = styleManager.getMergedStyleDeclaration(className);
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
      
      protected function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = event.toolTip;
         var pt:Point = PopUpUtil.positionOverComponent(this,systemManager,toolTip.width,toolTip.height,height / 2);
         toolTip.move(pt.x,pt.y);
      }
   }
}

