package com.riotgames.platform.common.components
{
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.HRule;
   import mx.controls.Label;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.styles.*;
   
   public class MessagePopupTemplate extends Canvas implements IBindingClient, IFocusManagerContainer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _styleButton:String;
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      public const STYLE_TITLE:String = "popupMessageTitle";
      
      public const STYLE_HRULE:String = "popupMessageHRule";
      
      public const STYLE_BODY:String = "popupMessageBody";
      
      public var contentRow:UIComponent;
      
      public const HORIZONTAL_BUTTON_GAP:Number = 6;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      public const STYLE_BUTTON:String = "s1FormButton";
      
      public var _MessagePopupTemplate_HRule1:HRule;
      
      public var _MessagePopupTemplate_HRule2:HRule;
      
      private var _213303133headerTxt:Label;
      
      public var _MessagePopupTemplate_VBox1:VBox;
      
      public const OUTTER_PADDING:Number = 10;
      
      public const STYLE_CANVAS:String = "popupMessageCanvas";
      
      private var _646058107contentHolder:VBox;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      [ArrayElementType("mx.core.UIComponent")]
      public var buttonRow:Array;
      
      private var _1977519450headerText:String;
      
      private var _629945214buttonHolder:HBox;
      
      public var useCustomStyles:Boolean = false;
      
      public const VERTICAL_GAP:Number = 6;
      
      private var _setMinWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _1208363484cConatiner:GradientCanvas;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function MessagePopupTemplate()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"cConatiner",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":VBox,
                           "id":"_MessagePopupTemplate_VBox1",
                           "stylesFactory":function():void
                           {
                              this.horizontalCenter = "0";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"headerTxt"
                                 }),new UIComponentDescriptor({
                                    "type":HRule,
                                    "id":"_MessagePopupTemplate_HRule1",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "alpha":0.5
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"contentHolder",
                                    "stylesFactory":function():void
                                    {
                                       this.verticalCenter = "0";
                                       this.horizontalCenter = "0";
                                       this.verticalAlign = "middle";
                                       this.paddingLeft = 37;
                                       this.paddingRight = 37;
                                       this.paddingTop = 20;
                                       this.paddingBottom = 20;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "percentHeight":100
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HRule,
                                    "id":"_MessagePopupTemplate_HRule2",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "alpha":0.5
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HBox,
                                    "id":"buttonHolder",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalAlign = "center";
                                       this.verticalAlign = "top";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"percentWidth":100};
                                    }
                                 })]
                              };
                           }
                        })]
                     };
                  }
               })]};
            }
         });
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.verticalCenter = "0";
            this.horizontalCenter = "0";
         };
         this.cacheAsBitmap = true;
         this.minWidth = 380;
         this.minHeight = 200;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._MessagePopupTemplate_DropShadowFilter1_i();
         this.addEventListener("creationComplete",this.___MessagePopupTemplate_Canvas1_creationComplete);
         this.addEventListener("hide",this.___MessagePopupTemplate_Canvas1_hide);
         this.addEventListener("remove",this.___MessagePopupTemplate_Canvas1_remove);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         MessagePopupTemplate._watcherSetupUtil = param1;
      }
      
      public function set styleButton(param1:String) : void
      {
         this._styleButton = param1;
      }
      
      public function ___MessagePopupTemplate_Canvas1_hide(param1:FlexEvent) : void
      {
         this.canvas1_hideHandler(param1);
      }
      
      public function ___MessagePopupTemplate_Canvas1_remove(param1:FlexEvent) : void
      {
         this.canvas1_removeHandler(param1);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:MessagePopupTemplate = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._MessagePopupTemplate_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_common_components_MessagePopupTemplateWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      private function _MessagePopupTemplate_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return STYLE_CANVAS;
         },function(param1:Object):void
         {
            cConatiner.styleName = param1;
         },"cConatiner.styleName");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return OUTTER_PADDING;
         },function(param1:Number):void
         {
            _MessagePopupTemplate_VBox1.setStyle("paddingLeft",param1);
         },"_MessagePopupTemplate_VBox1.paddingLeft");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return OUTTER_PADDING;
         },function(param1:Number):void
         {
            _MessagePopupTemplate_VBox1.setStyle("paddingRight",param1);
         },"_MessagePopupTemplate_VBox1.paddingRight");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return OUTTER_PADDING;
         },function(param1:Number):void
         {
            _MessagePopupTemplate_VBox1.setStyle("paddingTop",param1);
         },"_MessagePopupTemplate_VBox1.paddingTop");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return OUTTER_PADDING;
         },function(param1:Number):void
         {
            _MessagePopupTemplate_VBox1.setStyle("paddingBottom",param1);
         },"_MessagePopupTemplate_VBox1.paddingBottom");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return VERTICAL_GAP;
         },function(param1:Number):void
         {
            _MessagePopupTemplate_VBox1.setStyle("verticalGap",param1);
         },"_MessagePopupTemplate_VBox1.verticalGap");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return "popupMessageTitle";
         },function(param1:Object):void
         {
            headerTxt.styleName = param1;
         },"headerTxt.styleName");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = headerText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerTxt.htmlText = param1;
         },"headerTxt.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _MessagePopupTemplate_HRule1.styleName = param1;
         },"_MessagePopupTemplate_HRule1.styleName");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _MessagePopupTemplate_HRule2.styleName = param1;
         },"_MessagePopupTemplate_HRule2.styleName");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return OUTTER_PADDING;
         },function(param1:Number):void
         {
            buttonHolder.setStyle("paddingTop",param1);
         },"buttonHolder.paddingTop");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return HORIZONTAL_BUTTON_GAP;
         },function(param1:Number):void
         {
            buttonHolder.setStyle("horizontalGap",param1);
         },"buttonHolder.horizontalGap");
         result[11] = binding;
         return result;
      }
      
      public function set contentHolder(param1:VBox) : void
      {
         var _loc2_:Object = this._646058107contentHolder;
         if(_loc2_ !== param1)
         {
            this._646058107contentHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentHolder",_loc2_,param1));
         }
      }
      
      public function get setMinWidth() : Number
      {
         return this._setMinWidth;
      }
      
      public function set dropshadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1823111375dropshadow;
         if(_loc2_ !== param1)
         {
            this._1823111375dropshadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dropshadow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerTxt() : Label
      {
         return this._213303133headerTxt;
      }
      
      [Bindable(event="propertyChange")]
      public function get cConatiner() : GradientCanvas
      {
         return this._1208363484cConatiner;
      }
      
      [Bindable(event="propertyChange")]
      public function get contentHolder() : VBox
      {
         return this._646058107contentHolder;
      }
      
      public function onCreationComplete() : void
      {
         this.cConatiner.filters = [this.dropshadow];
         this.setupContent();
         this.setupButtons();
         AnimationHelper.playFadeInEffect(this);
      }
      
      public function setupContent() : void
      {
         if(this.contentRow != null)
         {
            this.contentHolder.addChild(this.contentRow);
         }
      }
      
      private function _MessagePopupTemplate_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.STYLE_CANVAS;
         _loc1_ = this.OUTTER_PADDING;
         _loc1_ = this.OUTTER_PADDING;
         _loc1_ = this.OUTTER_PADDING;
         _loc1_ = this.OUTTER_PADDING;
         _loc1_ = this.VERTICAL_GAP;
         _loc1_ = "popupMessageTitle";
         _loc1_ = this.headerText;
         _loc1_ = this.STYLE_HRULE;
         _loc1_ = this.STYLE_HRULE;
         _loc1_ = this.OUTTER_PADDING;
         _loc1_ = this.HORIZONTAL_BUTTON_GAP;
      }
      
      public function get styleButton() : String
      {
         return this._styleButton;
      }
      
      public function setupButtons() : void
      {
         var _loc1_:uint = 0;
         if(this.buttonRow != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.buttonRow.length)
            {
               if(!this.useCustomStyles)
               {
                  if(!this.styleButton)
                  {
                     UIComponent(this.buttonRow[_loc1_]).styleName = this.STYLE_BUTTON;
                  }
                  else
                  {
                     UIComponent(this.buttonRow[_loc1_]).styleName = this._styleButton;
                  }
               }
               this.buttonHolder.addChild(Button(this.buttonRow[_loc1_]));
               _loc1_++;
            }
         }
      }
      
      protected function canvas1_hideHandler(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      public function set headerTxt(param1:Label) : void
      {
         var _loc2_:Object = this._213303133headerTxt;
         if(_loc2_ !== param1)
         {
            this._213303133headerTxt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerTxt",_loc2_,param1));
         }
      }
      
      public function set setMinWidth(param1:Number) : void
      {
         this._setMinWidth = param1;
         this.minWidth = this._setMinWidth;
         this.invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
      
      public function set cConatiner(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1208363484cConatiner;
         if(_loc2_ !== param1)
         {
            this._1208363484cConatiner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cConatiner",_loc2_,param1));
         }
      }
      
      protected function canvas1_removeHandler(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      private function _MessagePopupTemplate_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.distance = 4;
         _loc1_.alpha = 1;
         _loc1_.quality = 3;
         _loc1_.blurX = 3;
         _loc1_.blurY = 3;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerText() : String
      {
         return this._1977519450headerText;
      }
      
      public function set headerText(param1:String) : void
      {
         var _loc2_:Object = this._1977519450headerText;
         if(_loc2_ !== param1)
         {
            this._1977519450headerText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerText",_loc2_,param1));
         }
      }
      
      public function set buttonHolder(param1:HBox) : void
      {
         var _loc2_:Object = this._629945214buttonHolder;
         if(_loc2_ !== param1)
         {
            this._629945214buttonHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonHolder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonHolder() : HBox
      {
         return this._629945214buttonHolder;
      }
      
      public function ___MessagePopupTemplate_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
   }
}

