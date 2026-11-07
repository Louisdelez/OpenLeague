package com.riotgames.platform.gameclient.views.summoner.wizard
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.pvpnet.accountcreation.model.PlayTutorialModel;
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
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class PlayTutorialGame extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _watchers:Array;
      
      private var _playTutorialModel:PlayTutorialModel;
      
      private var _1040321826no_btn:SoundEffectButton;
      
      private var _213292952header_lb:Label;
      
      private var _106433028panel:Canvas;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var _PlayTutorialGame_Image1:Image;
      
      mx_internal var _bindings:Array;
      
      private var _2016839369tutorialMessage:String;
      
      private var _1280527100yes_btn:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public var _PlayTutorialGame_TextArea1:TextArea;
      
      public function PlayTutorialGame()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"panel",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "width":445,
                        "height":271,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"_PlayTutorialGame_Image1"
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"header_lb",
                           "stylesFactory":function():void
                           {
                              this.top = "13";
                              this.left = "13";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"s1FormHeader"};
                           }
                        }),new UIComponentDescriptor({
                           "type":VBox,
                           "stylesFactory":function():void
                           {
                              this.top = "70";
                              this.horizontalAlign = "center";
                              this.verticalAlign = "middle";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"_PlayTutorialGame_TextArea1",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":283,
                                          "height":141,
                                          "styleName":"s1FormMessage",
                                          "selectable":false,
                                          "mouseChildren":false,
                                          "mouseEnabled":false
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HBox,
                           "stylesFactory":function():void
                           {
                              this.bottom = "7";
                              this.horizontalAlign = "center";
                              this.horizontalGap = -2;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":424,
                                 "x":10,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"yes_btn",
                                    "events":{"click":"__yes_btn_click"},
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"s1FormButton"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"no_btn",
                                    "events":{"click":"__no_btn_click"},
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"s1FormButton"};
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
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.addEventListener("creationComplete",this.___PlayTutorialGame_Canvas1_creationComplete);
         this.addEventListener("show",this.___PlayTutorialGame_Canvas1_show);
         this.addEventListener("hide",this.___PlayTutorialGame_Canvas1_hide);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         PlayTutorialGame._watcherSetupUtil = param1;
      }
      
      private function noClickHandler() : void
      {
         this.playTutorialModel.playTutorial = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get panel() : Canvas
      {
         return this._106433028panel;
      }
      
      public function set panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._106433028panel;
         if(_loc2_ !== param1)
         {
            this._106433028panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yes_btn() : SoundEffectButton
      {
         return this._1280527100yes_btn;
      }
      
      private function onTutorialTypeChanged(param1:Boolean) : void
      {
         if(param1)
         {
            this.tutorialMessage = ResourceManager.getInstance().getString("resources","playTutorial_chooseTutorialGame");
         }
         else
         {
            this.tutorialMessage = ResourceManager.getInstance().getString("resources","playTutorial_chooseTutorialGame_advanced");
         }
      }
      
      public function set yes_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1280527100yes_btn;
         if(_loc2_ !== param1)
         {
            this._1280527100yes_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yes_btn",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:PlayTutorialGame = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._PlayTutorialGame_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_wizard_PlayTutorialGameWatcherSetupUtil");
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
      
      public function set tutorialMessage(param1:String) : void
      {
         var _loc2_:Object = this._2016839369tutorialMessage;
         if(_loc2_ !== param1)
         {
            this._2016839369tutorialMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tutorialMessage",_loc2_,param1));
         }
      }
      
      private function _PlayTutorialGame_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_nameSummoner_menuBg");
         },function(param1:Object):void
         {
            _PlayTutorialGame_Image1.source = param1;
         },"_PlayTutorialGame_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","playTutorial_header");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_lb.htmlText = param1;
         },"header_lb.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = tutorialMessage;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PlayTutorialGame_TextArea1.htmlText = param1;
         },"_PlayTutorialGame_TextArea1.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_yes");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            yes_btn.label = param1;
         },"yes_btn.label");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_no");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            no_btn.label = param1;
         },"no_btn.label");
         result[4] = binding;
         return result;
      }
      
      private function _PlayTutorialGame_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_nameSummoner_menuBg");
         _loc1_ = resourceManager.getString("resources","playTutorial_header");
         _loc1_ = this.tutorialMessage;
         _loc1_ = resourceManager.getString("resources","common_button_yes");
         _loc1_ = resourceManager.getString("resources","common_button_no");
      }
      
      public function get playTutorialModel() : PlayTutorialModel
      {
         return this._playTutorialModel;
      }
      
      public function ___PlayTutorialGame_Canvas1_show(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeInEffect(this);
      }
      
      private function yesClickHandler() : void
      {
         this.playTutorialModel.playTutorial = true;
      }
      
      public function __yes_btn_click(param1:MouseEvent) : void
      {
         this.yesClickHandler();
      }
      
      public function set playTutorialModel(param1:PlayTutorialModel) : void
      {
         if(this._playTutorialModel != null)
         {
            this.playTutorialModel.getTutorialTypeChanged().remove(this.onTutorialTypeChanged);
         }
         this._playTutorialModel = param1;
         if(this._playTutorialModel != null)
         {
            this.playTutorialModel.getTutorialTypeChanged().add(this.onTutorialTypeChanged);
            this.playTutorialModel.requestTutorialType();
         }
      }
      
      private function onCreationComplete() : void
      {
      }
      
      public function set no_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1040321826no_btn;
         if(_loc2_ !== param1)
         {
            this._1040321826no_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"no_btn",_loc2_,param1));
         }
      }
      
      public function __no_btn_click(param1:MouseEvent) : void
      {
         this.noClickHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get tutorialMessage() : String
      {
         return this._2016839369tutorialMessage;
      }
      
      public function set header_lb(param1:Label) : void
      {
         var _loc2_:Object = this._213292952header_lb;
         if(_loc2_ !== param1)
         {
            this._213292952header_lb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_lb",_loc2_,param1));
         }
      }
      
      public function ___PlayTutorialGame_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function ___PlayTutorialGame_Canvas1_hide(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get no_btn() : SoundEffectButton
      {
         return this._1040321826no_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_lb() : Label
      {
         return this._213292952header_lb;
      }
   }
}

