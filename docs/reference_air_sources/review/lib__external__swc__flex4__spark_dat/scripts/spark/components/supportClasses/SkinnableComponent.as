package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.*;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import spark.events.SkinPartEvent;
   import spark.utils.FTETextUtil;
   
   [ResourceBundle("components")]
   [Exclude(name="getChildIndex",kind="method")]
   [Exclude(name="getChildAt",kind="method")]
   [Exclude(name="numChildren",kind="property")]
   [Exclude(name="swapChildrenAt",kind="method")]
   [Exclude(name="swapChildren",kind="method")]
   [Exclude(name="setChildIndex",kind="method")]
   [Exclude(name="removeChildAt",kind="method")]
   [Exclude(name="removeChild",kind="method")]
   [Exclude(name="addChildAt",kind="method")]
   [Exclude(name="addChild",kind="method")]
   [Exclude(name="themeColor",kind="style")]
   [Style(name="skinClass",type="Class")]
   [Style(name="errorSkin",type="Class")]
   [Style(name="chromeColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   public class SkinnableComponent extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _skinDestructionPolicy:String = "never";
      
      private var skinDestructionPolicyChanged:Boolean = false;
      
      private var _skin:UIComponent;
      
      private var errorObj:DisplayObject;
      
      private var errorStringChanged:Boolean;
      
      private var _explicitMouseEnabled:Boolean = true;
      
      private var _explicitMouseChildren:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var focusObj:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var drawFocusAnyway:Boolean;
      
      private var dynamicPartsCache:Object;
      
      private var skinChanged:Boolean = false;
      
      private var skinFactoryStyleChanged:Boolean = false;
      
      private var skinStateIsDirty:Boolean = false;
      
      public function SkinnableComponent()
      {
         super();
         this.skinStateIsDirty = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get skinDestructionPolicy() : String
      {
         return this._skinDestructionPolicy;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set skinDestructionPolicy(value:String) : void
      {
         if(value == this._skinDestructionPolicy)
         {
            return;
         }
         this._skinDestructionPolicy = value;
         this.skinDestructionPolicyChanged = true;
         invalidateProperties();
      }
      
      [Bindable("skinChanged")]
      public function get skin() : UIComponent
      {
         return this._skin;
      }
      
      private function setSkin(value:UIComponent) : void
      {
         if(value === this._skin)
         {
            return;
         }
         this._skin = value;
         dispatchEvent(new Event("skinChanged"));
      }
      
      public function get suggestedFocusSkinExclusions() : Array
      {
         return null;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return FTETextUtil.calculateFontBaseline(this,height,moduleFactory);
      }
      
      override protected function get currentCSSState() : String
      {
         return this.getCurrentSkinState();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this.invalidateSkinState();
         super.mouseChildren = value ? this._explicitMouseChildren : false;
         super.mouseEnabled = value ? this._explicitMouseEnabled : false;
      }
      
      override public function set errorString(value:String) : void
      {
         super.errorString = value;
         this.errorStringChanged = true;
         invalidateProperties();
      }
      
      override public function set mouseEnabled(value:Boolean) : void
      {
         if(enabled)
         {
            super.mouseEnabled = value;
         }
         this._explicitMouseEnabled = value;
      }
      
      override public function set mouseChildren(value:Boolean) : void
      {
         if(enabled)
         {
            super.mouseChildren = value;
         }
         this._explicitMouseChildren = value;
      }
      
      override public function matchesCSSState(cssState:String) : Boolean
      {
         return this.getCurrentSkinState() == cssState || currentState == cssState;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(moduleFactory))
         {
            this.validateSkinChange();
         }
      }
      
      private function validateSkinChange() : void
      {
         var factory:Object = null;
         var newSkinClass:Class = null;
         var skipReload:Boolean = false;
         if(Boolean(this._skin))
         {
            factory = getStyle("skinFactory");
            if(Boolean(factory))
            {
               skipReload = !this.skinFactoryStyleChanged;
            }
            else
            {
               newSkinClass = getStyle("skinClass");
               skipReload = Boolean(newSkinClass) && getQualifiedClassName(newSkinClass) == getQualifiedClassName(this._skin);
            }
            this.skinFactoryStyleChanged = false;
         }
         if(!skipReload)
         {
            if(Boolean(this.skin))
            {
               this.detachSkin();
            }
            this.attachSkin();
         }
      }
      
      override protected function commitProperties() : void
      {
         var pendingState:String = null;
         super.commitProperties();
         if(this.skinChanged)
         {
            this.skinChanged = false;
            this.validateSkinChange();
         }
         if(this.skinStateIsDirty)
         {
            pendingState = this.getCurrentSkinState();
            stateChanged(this.skin.currentState,pendingState,false);
            this.skin.currentState = pendingState;
            this.skinStateIsDirty = false;
         }
         if(this.errorStringChanged)
         {
            this.updateErrorSkin();
            this.errorStringChanged = false;
         }
         if(this.skinDestructionPolicyChanged)
         {
            if(this.skinDestructionPolicy == "auto")
            {
               addEventListener(Event.ADDED_TO_STAGE,this.adddedToStageHandler);
               addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
            }
            else
            {
               removeEventListener(Event.ADDED_TO_STAGE,this.adddedToStageHandler);
               removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
            }
            this.skinDestructionPolicyChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         if(Boolean(this.skin))
         {
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_5)
            {
               measuredWidth = this.skin.getExplicitOrMeasuredWidth();
               measuredHeight = this.skin.getExplicitOrMeasuredHeight();
               measuredMinWidth = isNaN(this.skin.explicitWidth) ? Number(this.skin.minWidth) : Number(this.skin.explicitWidth);
               measuredMinHeight = isNaN(this.skin.explicitHeight) ? Number(this.skin.minHeight) : Number(this.skin.explicitHeight);
            }
            else
            {
               measuredWidth = this.skin.getExplicitOrMeasuredWidth();
               measuredHeight = this.skin.getExplicitOrMeasuredHeight();
               measuredMinWidth = this.skin.minWidth;
               measuredMinHeight = this.skin.minHeight;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(this.skin))
         {
            this.skin.setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || styleProp == "skinClass" || styleProp == "skinFactory")
         {
            this.skinChanged = true;
            invalidateProperties();
            if(styleProp == "skinFactory")
            {
               this.skinFactoryStyleChanged = true;
            }
         }
         super.styleChanged(styleProp);
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var focusSkinClass:Class = null;
         if(isFocused)
         {
            if(!this.drawFocusAnyway && focusManager.getFocus() != this)
            {
               return;
            }
            if(!this.focusObj)
            {
               focusSkinClass = getStyle("focusSkin");
               if(Boolean(focusSkinClass))
               {
                  this.focusObj = new focusSkinClass();
               }
               if(Boolean(this.focusObj))
               {
                  super.addChildAt(this.focusObj,0);
               }
            }
            if(Boolean(this.focusObj) && "target" in this.focusObj)
            {
               this.focusObj["target"] = this;
            }
         }
         else
         {
            if(Boolean(this.focusObj))
            {
               super.removeChild(this.focusObj);
            }
            this.focusObj = null;
         }
      }
      
      protected function getCurrentSkinState() : String
      {
         return null;
      }
      
      public function invalidateSkinState() : void
      {
         if(this.skinStateIsDirty)
         {
            return;
         }
         this.skinStateIsDirty = true;
         invalidateProperties();
      }
      
      protected function attachSkin() : void
      {
         var skinClass:Class = null;
         var skinClassFactory:IFactory = getStyle("skinFactory") as IFactory;
         if(Boolean(skinClassFactory))
         {
            this.setSkin(skinClassFactory.newInstance() as UIComponent);
         }
         if(!this.skin)
         {
            skinClass = getStyle("skinClass") as Class;
            if(Boolean(skinClass))
            {
               this.setSkin(new skinClass());
            }
         }
         if(Boolean(this.skin))
         {
            this.skin.owner = this;
            if("hostComponent" in this.skin)
            {
               try
               {
                  Object(this.skin).hostComponent = this;
               }
               catch(err:Error)
               {
               }
            }
            this.skin.styleName = this;
            super.addChild(this.skin);
            this.skin.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.skin_propertyChangeHandler);
            this.findSkinParts();
            this.invalidateSkinState();
            return;
         }
         throw new Error(resourceManager.getString("components","skinNotFound",[this]));
      }
      
      protected function findSkinParts() : void
      {
         var id:String = null;
         if(Boolean(this.skinParts))
         {
            for(id in this.skinParts)
            {
               if(this.skinParts[id] == true)
               {
                  if(!(id in this.skin))
                  {
                     throw new Error(resourceManager.getString("components","requiredSkinPartNotFound",[id]));
                  }
               }
               if(id in this.skin)
               {
                  this[id] = this.skin[id];
                  if(this[id] != null && !(this[id] is IFactory))
                  {
                     this.partAdded(id,this[id]);
                  }
               }
            }
         }
      }
      
      protected function clearSkinParts() : void
      {
         var id:String = null;
         var len:int = 0;
         var j:int = 0;
         if(Boolean(this.skinParts))
         {
            for(id in this.skinParts)
            {
               if(this[id] != null)
               {
                  if(!(this[id] is IFactory))
                  {
                     this.partRemoved(id,this[id]);
                  }
                  else
                  {
                     len = this.numDynamicParts(id);
                     for(j = len - 1; j >= 0; j--)
                     {
                        this.removeDynamicPartInstance(id,this.getDynamicPartAt(id,j));
                     }
                  }
               }
               this[id] = null;
            }
         }
      }
      
      protected function detachSkin() : void
      {
         this.skin.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.skin_propertyChangeHandler);
         this.skin.styleName = null;
         this.clearSkinParts();
         super.removeChild(this.skin);
         this.setSkin(null);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateErrorSkin() : void
      {
         var errorObjClass:Class = null;
         if(errorString != null && errorString != "" && Boolean(getStyle("showErrorSkin")))
         {
            if(!this.errorObj)
            {
               errorObjClass = getStyle("errorSkin");
               if(Boolean(errorObjClass))
               {
                  this.errorObj = new errorObjClass();
               }
               if(Boolean(this.errorObj))
               {
                  if("target" in this.errorObj)
                  {
                     this.errorObj["target"] = this;
                  }
                  super.addChild(this.errorObj);
               }
            }
         }
         else
         {
            if(Boolean(this.errorObj))
            {
               super.removeChild(this.errorObj);
            }
            this.errorObj = null;
         }
      }
      
      protected function partAdded(partName:String, instance:Object) : void
      {
         var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_ADDED);
         event.partName = partName;
         event.instance = instance;
         dispatchEvent(event);
      }
      
      protected function partRemoved(partName:String, instance:Object) : void
      {
         var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_REMOVED);
         event.partName = partName;
         event.instance = instance;
         dispatchEvent(event);
      }
      
      protected function createDynamicPartInstance(partName:String) : Object
      {
         var instance:* = undefined;
         var factory:IFactory = this[partName];
         if(Boolean(factory))
         {
            instance = factory.newInstance();
            if(!this.dynamicPartsCache)
            {
               this.dynamicPartsCache = new Object();
            }
            if(!this.dynamicPartsCache[partName])
            {
               this.dynamicPartsCache[partName] = new Array();
            }
            this.dynamicPartsCache[partName].push(instance);
            this.partAdded(partName,instance);
            return instance;
         }
         return null;
      }
      
      protected function removeDynamicPartInstance(partName:String, instance:Object) : void
      {
         this.partRemoved(partName,instance);
         var cache:Array = this.dynamicPartsCache[partName] as Array;
         cache.splice(cache.indexOf(instance),1);
      }
      
      protected function numDynamicParts(partName:String) : int
      {
         if(Boolean(this.dynamicPartsCache) && Boolean(this.dynamicPartsCache[partName]))
         {
            return this.dynamicPartsCache[partName].length;
         }
         return 0;
      }
      
      protected function getDynamicPartAt(partName:String, index:int) : Object
      {
         if(Boolean(this.dynamicPartsCache) && Boolean(this.dynamicPartsCache[partName]))
         {
            return this.dynamicPartsCache[partName][index];
         }
         return null;
      }
      
      protected function getSkinPartPosition(part:IVisualElement) : Point
      {
         return !part || !part.parent ? new Point(0,0) : globalToLocal(part.parent.localToGlobal(new Point((part as ILayoutElement).getLayoutBoundsX(),(part as ILayoutElement).getLayoutBoundsY())));
      }
      
      protected function getBaselinePositionForPart(part:IVisualElement) : Number
      {
         if(!part || !validateBaselinePosition())
         {
            return super.baselinePosition;
         }
         return this.getSkinPartPosition(part).y + part.baselinePosition;
      }
      
      private function skin_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         var skinPartID:String = null;
         if(Boolean(this.skinParts))
         {
            skinPartID = event.property as String;
            if(this.skinParts[skinPartID] != null)
            {
               if(event.newValue == null)
               {
                  if(!(this[skinPartID] is IFactory))
                  {
                     this.partRemoved(skinPartID,this[skinPartID]);
                  }
                  this[skinPartID] = event.newValue;
               }
               else
               {
                  this[skinPartID] = event.newValue;
                  if(!(this[skinPartID] is IFactory))
                  {
                     this.partAdded(skinPartID,this[skinPartID]);
                  }
               }
            }
         }
      }
      
      private function adddedToStageHandler(event:Event) : void
      {
         if(this.skin == null)
         {
            this.attachSkin();
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         this.detachSkin();
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildError"));
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildAtError"));
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildError"));
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildAtError"));
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         throw new Error(resourceManager.getString("components","setChildIndexError"));
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenError"));
      }
      
      override public function swapChildrenAt(index1:int, index2:int) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenAtError"));
      }
   }
}

