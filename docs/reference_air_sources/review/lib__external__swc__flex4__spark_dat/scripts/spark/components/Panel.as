package spark.components
{
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.core.IDisplayText;
   import spark.layouts.supportClasses.LayoutBase;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("Panel.png")]
   [AccessibilityClass(implementation="spark.accessibility.PanelAccImpl")]
   [SkinState("disabledWithControlBar")]
   [SkinState("normalWithControlBar")]
   [SkinState("disabled")]
   [SkinState("normal")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="spark")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   public class Panel extends SkinnableContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CONTROLBAR_PROPERTY_FLAG:uint = 1 << 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VISIBLE_PROPERTY_FLAG:uint = 1 << 2;
      
      private static var _skinParts:Object = {
         "contentGroup":false,
         "controlBarGroup":false,
         "titleDisplay":false
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var controlBarGroupProperties:Object = {"visible":true};
      
      [SkinPart(required="false")]
      public var controlBarGroup:Group;
      
      [SkinPart(required="false")]
      public var titleDisplay:IDisplayText;
      
      private var _title:String = "";
      
      private var titleChanged:Boolean;
      
      public function Panel()
      {
         super();
         mouseEnabled = false;
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.titleDisplay as IVisualElement);
      }
      
      [ArrayElementType("mx.core.IVisualElement")]
      public function get controlBarContent() : Array
      {
         if(Boolean(this.controlBarGroup))
         {
            return this.controlBarGroup.getMXMLContent();
         }
         return this.controlBarGroupProperties.controlBarContent;
      }
      
      public function set controlBarContent(value:Array) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.mxmlContent = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG,value != null);
         }
         else
         {
            this.controlBarGroupProperties.controlBarContent = value;
         }
         invalidateSkinState();
      }
      
      public function get controlBarLayout() : LayoutBase
      {
         return Boolean(this.controlBarGroup) ? this.controlBarGroup.layout : this.controlBarGroupProperties.layout;
      }
      
      public function set controlBarLayout(value:LayoutBase) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.layout = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.controlBarGroupProperties.layout = value;
         }
      }
      
      public function get controlBarVisible() : Boolean
      {
         return Boolean(this.controlBarGroup) ? Boolean(this.controlBarGroup.visible) : Boolean(this.controlBarGroupProperties.visible);
      }
      
      public function set controlBarVisible(value:Boolean) : void
      {
         if(Boolean(this.controlBarGroup))
         {
            this.controlBarGroup.visible = value;
            this.controlBarGroupProperties = BitFlagUtil.update(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG,value);
         }
         else
         {
            this.controlBarGroupProperties.visible = value;
         }
         invalidateSkinState();
         if(Boolean(skin))
         {
            skin.invalidateSize();
         }
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._title;
      }
      
      private function set _110371416title(value:String) : void
      {
         this._title = value;
         if(Boolean(this.titleDisplay))
         {
            this.titleDisplay.text = this.title;
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Panel.createAccessibilityImplementation != null)
         {
            Panel.createAccessibilityImplementation(this);
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var newControlBarGroupProperties:uint = 0;
         super.partAdded(partName,instance);
         if(instance == this.titleDisplay)
         {
            this.titleDisplay.text = this.title;
         }
         else if(instance == this.controlBarGroup)
         {
            newControlBarGroupProperties = 0;
            if(this.controlBarGroupProperties.controlBarContent !== undefined)
            {
               this.controlBarGroup.mxmlContent = this.controlBarGroupProperties.controlBarContent;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,CONTROLBAR_PROPERTY_FLAG,true));
            }
            if(this.controlBarGroupProperties.layout !== undefined)
            {
               this.controlBarGroup.layout = this.controlBarGroupProperties.layout;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,LAYOUT_PROPERTY_FLAG,true));
            }
            if(this.controlBarGroupProperties.visible !== undefined)
            {
               this.controlBarGroup.visible = this.controlBarGroupProperties.visible;
               newControlBarGroupProperties = uint(BitFlagUtil.update(newControlBarGroupProperties,VISIBLE_PROPERTY_FLAG,true));
            }
            this.controlBarGroupProperties = newControlBarGroupProperties;
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var newControlBarGroupProperties:Object = null;
         super.partRemoved(partName,instance);
         if(instance == this.controlBarGroup)
         {
            newControlBarGroupProperties = {};
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.controlBarContent = this.controlBarGroup.getMXMLContent();
            }
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,LAYOUT_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.layout = this.controlBarGroup.layout;
            }
            if(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG))
            {
               newControlBarGroupProperties.visible = this.controlBarGroup.visible;
            }
            this.controlBarGroupProperties = newControlBarGroupProperties;
            this.controlBarGroup.mxmlContent = null;
            this.controlBarGroup.layout = null;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var state:String = enabled ? "normal" : "disabled";
         if(Boolean(this.controlBarGroup))
         {
            if(Boolean(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,CONTROLBAR_PROPERTY_FLAG)) && Boolean(BitFlagUtil.isSet(this.controlBarGroupProperties as uint,VISIBLE_PROPERTY_FLAG)))
            {
               state += "WithControlBar";
            }
         }
         else if(Boolean(this.controlBarGroupProperties.controlBarContent) && Boolean(this.controlBarGroupProperties.visible))
         {
            state += "WithControlBar";
         }
         return state;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this.title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}

