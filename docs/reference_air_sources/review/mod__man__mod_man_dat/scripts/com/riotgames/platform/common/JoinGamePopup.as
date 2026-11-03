package com.riotgames.platform.common
{
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.event.JoinGamePopupEvent;
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
   import mx.controls.HRule;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.controls.TextInput;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class JoinGamePopup extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const STYLE_CANVAS:String = "popupMessageCanvas";
      
      public static const STYLE_TITLE:String = "popupMessageTitle";
      
      public static const STYLE_BODY:String = "popupMessageBody";
      
      public static const STYLE_HRULE:String = "popupMessageHRule";
      
      public static const STYLE_BUTTON:String = "s1FormButton";
      
      public static const STYLE_TEXTINPUT:String = "standard";
      
      private var _3088b2:SoundEffectButton;
      
      mx_internal var _watchers:Array;
      
      private var _3756vb:VBox;
      
      public var _JoinGamePopup_HRule1:HRule;
      
      public var _JoinGamePopup_HRule2:HRule;
      
      private var _3322hb:HBox;
      
      private var _118v:Text;
      
      private var _3087b1:SoundEffectButton;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _1613974726promptInput:TextInput;
      
      private var _1166031975headerLabel:Label;
      
      mx_internal var _bindings:Array;
      
      private var _1208363484cConatiner:GradientCanvas;
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1054695389midVBox:VBox;
      
      public function JoinGamePopup()
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
                           "id":"vb",
                           "stylesFactory":function():void
                           {
                              this.paddingLeft = 10;
                              this.paddingRight = 10;
                              this.paddingTop = 10;
                              this.paddingBottom = 10;
                              this.verticalGap = 6;
                              this.verticalAlign = "middle";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"headerLabel",
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"popupMessageTitle"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HRule,
                                    "id":"_JoinGamePopup_HRule1",
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
                                    "id":"midVBox",
                                    "stylesFactory":function():void
                                    {
                                       this.verticalCenter = "0";
                                       this.verticalAlign = "middle";
                                       this.horizontalAlign = "center";
                                       this.paddingLeft = 37;
                                       this.paddingRight = 37;
                                       this.paddingTop = 10;
                                       this.paddingBottom = 10;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Text,
                                             "id":"v",
                                             "stylesFactory":function():void
                                             {
                                                this.textAlign = "center";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "selectable":false,
                                                   "mouseChildren":false,
                                                   "mouseEnabled":false
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Spacer,
                                             "propertiesFactory":function():Object
                                             {
                                                return {"height":6};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":TextInput,
                                             "id":"promptInput",
                                             "events":{"enter":"__promptInput_enter"},
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":94,
                                                   "displayAsPassword":true
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HRule,
                                    "id":"_JoinGamePopup_HRule2",
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
                                    "id":"hb",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalGap = 5;
                                       this.horizontalAlign = "center";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":SoundEffectButton,
                                             "id":"b1",
                                             "events":{"click":"__b1_click"}
                                          }),new UIComponentDescriptor({
                                             "type":SoundEffectButton,
                                             "id":"b2",
                                             "events":{"click":"__b2_click"}
                                          })]
                                       };
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
         this.minWidth = 360;
         this.minHeight = 200;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._JoinGamePopup_DropShadowFilter1_i();
         this.addEventListener("creationComplete",this.___JoinGamePopup_Canvas1_creationComplete);
         this.addEventListener("remove",this.___JoinGamePopup_Canvas1_remove);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         JoinGamePopup._watcherSetupUtil = param1;
      }
      
      private function _JoinGamePopup_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():IFlexDisplayObject
         {
            return b1;
         },function(param1:IFlexDisplayObject):void
         {
            this.defaultButton = param1;
         },"this.defaultButton");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_CANVAS;
         },function(param1:Object):void
         {
            cConatiner.styleName = param1;
         },"cConatiner.styleName");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_passwordPrompt_passwordPromptTitle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerLabel.text = param1;
         },"headerLabel.text");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _JoinGamePopup_HRule1.styleName = param1;
         },"_JoinGamePopup_HRule1.styleName");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            v.styleName = param1;
         },"v.styleName");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_passwordPrompt_passwordPromptLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            v.text = param1;
         },"v.text");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_TEXTINPUT;
         },function(param1:Object):void
         {
            promptInput.styleName = param1;
         },"promptInput.styleName");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _JoinGamePopup_HRule2.styleName = param1;
         },"_JoinGamePopup_HRule2.styleName");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_passwordPrompt_okButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            b1.label = param1;
         },"b1.label");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            b1.styleName = param1;
         },"b1.styleName");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_passwordPrompt_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            b2.label = param1;
         },"b2.label");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            b2.styleName = param1;
         },"b2.styleName");
         result[11] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get v() : Text
      {
         return this._118v;
      }
      
      private function _JoinGamePopup_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.distance = 3;
         _loc1_.alpha = 0.8;
         _loc1_.quality = 3;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get hb() : HBox
      {
         return this._3322hb;
      }
      
      public function set v(param1:Text) : void
      {
         var _loc2_:Object = this._118v;
         if(_loc2_ !== param1)
         {
            this._118v = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"v",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get b1() : SoundEffectButton
      {
         return this._3087b1;
      }
      
      [Bindable(event="propertyChange")]
      public function get b2() : SoundEffectButton
      {
         return this._3088b2;
      }
      
      public function set promptInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._1613974726promptInput;
         if(_loc2_ !== param1)
         {
            this._1613974726promptInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"promptInput",_loc2_,param1));
         }
      }
      
      public function set b1(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._3087b1;
         if(_loc2_ !== param1)
         {
            this._3087b1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"b1",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:JoinGamePopup = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._JoinGamePopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_common_JoinGamePopupWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get cConatiner() : GradientCanvas
      {
         return this._1208363484cConatiner;
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
      
      public function set b2(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._3088b2;
         if(_loc2_ !== param1)
         {
            this._3088b2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"b2",_loc2_,param1));
         }
      }
      
      public function onCreationComplete() : void
      {
         this.cConatiner.filters = [this.dropshadow];
         AnimationHelper.playFadeInEffect(this);
         this.callLater(this.promptInput.setFocus);
      }
      
      public function __b1_click(param1:MouseEvent) : void
      {
         this.onOkButtonClicked(param1);
      }
      
      public function onOkButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = this.promptInput.text;
         this.dispatchEvent(new JoinGamePopupEvent(_loc2_,JoinGamePopupEvent.OK_BUTTON_CLICK,true));
         this.promptInput.text = "";
      }
      
      [Bindable(event="propertyChange")]
      public function get vb() : VBox
      {
         return this._3756vb;
      }
      
      public function __promptInput_enter(param1:FlexEvent) : void
      {
         this.onOkButtonClicked(null);
      }
      
      public function set midVBox(param1:VBox) : void
      {
         var _loc2_:Object = this._1054695389midVBox;
         if(_loc2_ !== param1)
         {
            this._1054695389midVBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"midVBox",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get promptInput() : TextInput
      {
         return this._1613974726promptInput;
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
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
      
      public function ___JoinGamePopup_Canvas1_remove(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      public function onCancelButtonClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new JoinGamePopupEvent(this.promptInput.text,JoinGamePopupEvent.CANCEL_BUTTON_CLICK,true));
         this.promptInput.text = "";
      }
      
      [Bindable(event="propertyChange")]
      public function get midVBox() : VBox
      {
         return this._1054695389midVBox;
      }
      
      private function _JoinGamePopup_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.b1;
         _loc1_ = STYLE_CANVAS;
         _loc1_ = resourceManager.getString("resources","practiceGame_passwordPrompt_passwordPromptTitle");
         _loc1_ = STYLE_HRULE;
         _loc1_ = STYLE_BODY;
         _loc1_ = resourceManager.getString("resources","practiceGame_passwordPrompt_passwordPromptLabel");
         _loc1_ = STYLE_TEXTINPUT;
         _loc1_ = STYLE_HRULE;
         _loc1_ = resourceManager.getString("resources","practiceGame_passwordPrompt_okButtonLabel");
         _loc1_ = STYLE_BUTTON;
         _loc1_ = resourceManager.getString("resources","practiceGame_passwordPrompt_cancelButtonLabel");
         _loc1_ = STYLE_BUTTON;
      }
      
      public function ___JoinGamePopup_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      public function set vb(param1:VBox) : void
      {
         var _loc2_:Object = this._3756vb;
         if(_loc2_ !== param1)
         {
            this._3756vb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"vb",_loc2_,param1));
         }
      }
      
      public function set hb(param1:HBox) : void
      {
         var _loc2_:Object = this._3322hb;
         if(_loc2_ !== param1)
         {
            this._3322hb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hb",_loc2_,param1));
         }
      }
      
      public function __b2_click(param1:MouseEvent) : void
      {
         this.onCancelButtonClicked(param1);
      }
   }
}

