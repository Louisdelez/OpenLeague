package spark.components
{
   import flash.events.Event;
   import mx.collections.IList;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.SkinnableContainerBase;
   import spark.events.RendererExistenceEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   [IconFile("SkinnableDataContainer.png")]
   [DefaultProperty("dataProvider")]
   [Style(name="focusThickness",type="Number",format="Length",inherit="no",minValue="0.0")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="focusAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Event(name="rendererRemove",type="spark.events.RendererExistenceEvent")]
   [Event(name="rendererAdd",type="spark.events.RendererExistenceEvent")]
   public class SkinnableDataContainer extends SkinnableContainerBase implements IItemRendererOwner
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const DATA_PROVIDER_PROPERTY_FLAG:uint = 1 << 1;
      
      private static const ITEM_RENDERER_PROPERTY_FLAG:uint = 1 << 2;
      
      private static const ITEM_RENDERER_FUNCTION_PROPERTY_FLAG:uint = 1 << 3;
      
      private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 4;
      
      private static const TYPICAL_ITEM_PROPERTY_FLAG:uint = 1 << 5;
      
      private static var _skinParts:Object = {"dataGroup":false};
      
      private var _385593099dataGroup:DataGroup;
      
      private var dataGroupProperties:Object = {};
      
      public function SkinnableDataContainer()
      {
         super();
      }
      
      [Inspectable(defaultValue="true")]
      public function get autoLayout() : Boolean
      {
         var v:* = undefined;
         if(Boolean(this.dataGroup))
         {
            return this.dataGroup.autoLayout;
         }
         v = this.dataGroupProperties.autoLayout;
         return v === undefined ? true : Boolean(v);
      }
      
      public function set autoLayout(value:Boolean) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.autoLayout = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.autoLayout = value;
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataProviderChanged")]
      public function get dataProvider() : IList
      {
         return Boolean(this.dataGroup) ? this.dataGroup.dataProvider : this.dataGroupProperties.dataProvider;
      }
      
      public function set dataProvider(value:IList) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.dataProvider = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,DATA_PROVIDER_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.dataProvider = value;
         }
         dispatchEvent(new Event("dataProviderChanged"));
      }
      
      [Inspectable(category="Data")]
      public function get itemRenderer() : IFactory
      {
         return Boolean(this.dataGroup) ? this.dataGroup.itemRenderer : this.dataGroupProperties.itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.itemRenderer = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,ITEM_RENDERER_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.itemRenderer = value;
         }
      }
      
      [Inspectable(category="Data")]
      public function get itemRendererFunction() : Function
      {
         return Boolean(this.dataGroup) ? this.dataGroup.itemRendererFunction : this.dataGroupProperties.itemRendererFunction;
      }
      
      public function set itemRendererFunction(value:Function) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.itemRendererFunction = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,ITEM_RENDERER_FUNCTION_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.itemRendererFunction = value;
         }
      }
      
      [Inspectable(category="General")]
      public function get layout() : LayoutBase
      {
         return Boolean(this.dataGroup) ? this.dataGroup.layout : this.dataGroupProperties.layout;
      }
      
      public function set layout(value:LayoutBase) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.layout = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.layout = value;
         }
      }
      
      [Inspectable(category="Data")]
      public function get typicalItem() : Object
      {
         return Boolean(this.dataGroup) ? this.dataGroup.typicalItem : this.dataGroupProperties.typicalItem;
      }
      
      public function set typicalItem(value:Object) : void
      {
         if(Boolean(this.dataGroup))
         {
            this.dataGroup.typicalItem = value;
            this.dataGroupProperties = BitFlagUtil.update(this.dataGroupProperties as uint,TYPICAL_ITEM_PROPERTY_FLAG,true);
         }
         else
         {
            this.dataGroupProperties.typicalItem = value;
         }
      }
      
      public function itemToLabel(item:Object) : String
      {
         if(item !== null)
         {
            return item.toString();
         }
         return " ";
      }
      
      public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object) : void
      {
         renderer.owner = this;
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).itemIndex = itemIndex;
         }
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).label = this.itemToLabel(data);
         }
         if(renderer is IDataRenderer && renderer !== data)
         {
            IDataRenderer(renderer).data = data;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newDataGroupProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.dataGroup)
         {
            newDataGroupProperties = 0;
            if(this.dataGroupProperties.layout !== undefined)
            {
               this.dataGroup.layout = this.dataGroupProperties.layout;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true));
            }
            if(this.dataGroupProperties.autoLayout !== undefined)
            {
               this.dataGroup.autoLayout = this.dataGroupProperties.autoLayout;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG,true));
            }
            if(this.dataGroupProperties.dataProvider !== undefined)
            {
               this.dataGroup.dataProvider = this.dataGroupProperties.dataProvider;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,DATA_PROVIDER_PROPERTY_FLAG,true));
            }
            if(this.dataGroupProperties.itemRenderer !== undefined)
            {
               this.dataGroup.itemRenderer = this.dataGroupProperties.itemRenderer;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,ITEM_RENDERER_PROPERTY_FLAG,true));
            }
            if(this.dataGroupProperties.itemRendererFunction !== undefined)
            {
               this.dataGroup.itemRendererFunction = this.dataGroupProperties.itemRendererFunction;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,ITEM_RENDERER_FUNCTION_PROPERTY_FLAG,true));
            }
            if(this.dataGroupProperties.typicalItem !== undefined)
            {
               this.dataGroup.typicalItem = this.dataGroupProperties.typicalItem;
               newDataGroupProperties = uint(BitFlagUtil.update(newDataGroupProperties as uint,TYPICAL_ITEM_PROPERTY_FLAG,true));
            }
            this.dataGroupProperties = newDataGroupProperties;
            this.dataGroup.rendererUpdateDelegate = this;
            if(hasEventListener(RendererExistenceEvent.RENDERER_ADD))
            {
               this.dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD,dispatchEvent);
            }
            if(hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
            {
               this.dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE,dispatchEvent);
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newDataGroupProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.dataGroup)
         {
            this.dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD,dispatchEvent);
            this.dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE,dispatchEvent);
            newDataGroupProperties = {};
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,LAYOUT_PROPERTY_FLAG))
            {
               newDataGroupProperties.layout = this.dataGroup.layout;
            }
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG))
            {
               newDataGroupProperties.autoLayout = this.dataGroup.autoLayout;
            }
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,DATA_PROVIDER_PROPERTY_FLAG))
            {
               newDataGroupProperties.dataProvider = this.dataGroup.dataProvider;
            }
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,ITEM_RENDERER_PROPERTY_FLAG))
            {
               newDataGroupProperties.itemRenderer = this.dataGroup.itemRenderer;
            }
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,ITEM_RENDERER_FUNCTION_PROPERTY_FLAG))
            {
               newDataGroupProperties.itemRendererFunction = this.dataGroup.itemRendererFunction;
            }
            if(BitFlagUtil.isSet(this.dataGroupProperties as uint,TYPICAL_ITEM_PROPERTY_FLAG))
            {
               newDataGroupProperties.typicalItem = this.dataGroup.typicalItem;
            }
            this.dataGroupProperties = newDataGroupProperties;
            this.dataGroup.dataProvider = null;
            this.dataGroup.layout = null;
            this.dataGroup.rendererUpdateDelegate = null;
         }
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         if(type == RendererExistenceEvent.RENDERER_ADD && Boolean(this.dataGroup))
         {
            this.dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD,dispatchEvent);
         }
         if(type == RendererExistenceEvent.RENDERER_REMOVE && Boolean(this.dataGroup))
         {
            this.dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE,dispatchEvent);
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(type == RendererExistenceEvent.RENDERER_ADD && Boolean(this.dataGroup))
         {
            if(!hasEventListener(RendererExistenceEvent.RENDERER_ADD))
            {
               this.dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD,dispatchEvent);
            }
         }
         if(type == RendererExistenceEvent.RENDERER_REMOVE && Boolean(this.dataGroup))
         {
            if(!hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
            {
               this.dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE,dispatchEvent);
            }
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get dataGroup() : DataGroup
      {
         return this._385593099dataGroup;
      }
      
      public function set dataGroup(param1:DataGroup) : void
      {
         var _loc2_:Object = this._385593099dataGroup;
         if(_loc2_ !== param1)
         {
            this._385593099dataGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataGroup",_loc2_,param1));
            }
         }
      }
   }
}

