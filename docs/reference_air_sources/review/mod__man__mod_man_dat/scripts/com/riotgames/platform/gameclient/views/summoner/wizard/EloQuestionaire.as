package com.riotgames.platform.gameclient.views.summoner.wizard
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.domain.summoner.InitialSkillLevel;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.pvpnet.accountcreation.model.EloQuestionnaireModel;
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
   import mx.controls.RadioButton;
   import mx.controls.RadioButtonGroup;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EloQuestionaire extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _bindings:Array;
      
      private var _353046207veteran:RadioButton;
      
      public var _EloQuestionaire_Image1:Image;
      
      public var eloQuestionnaireModel:EloQuestionnaireModel;
      
      private var _2091065778eloQuestionaireInstructions:Text;
      
      public var _EloQuestionaire_Label2:Label;
      
      public var _EloQuestionaire_Label3:Label;
      
      public var _EloQuestionaire_Label4:Label;
      
      private var _1489437778beginner:RadioButton;
      
      public var _EloQuestionaire_Label5:Label;
      
      private var _1311104296systemMessage:Text;
      
      mx_internal var _watchers:Array;
      
      private var _231242356eloTitle_c:Canvas;
      
      private var _213292952header_lb:Label;
      
      private var _1216492988eloBodySkillBox:HBox;
      
      private var _1590887278rtsplayer:RadioButton;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _1191572123selected:Boolean = false;
      
      private var _1289163222expert:RadioButton;
      
      private var _1589554099skillLevel:RadioButtonGroup;
      
      private var _1280527100yes_btn:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1638209618skillToolTip:String;
      
      private var skillLevelValue:String;
      
      public function EloQuestionaire()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"eloTitle_c",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "width":630,
                        "height":350,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"_EloQuestionaire_Image1",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":628,
                                 "height":344
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"header_lb",
                           "stylesFactory":function():void
                           {
                              this.top = "8";
                              this.left = "10";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"s1FormHeader",
                                 "selectable":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":VBox,
                           "stylesFactory":function():void
                           {
                              this.top = "50";
                              this.left = "-4";
                              this.horizontalAlign = "center";
                              this.verticalAlign = "top";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "height":230,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Text,
                                    "id":"eloQuestionaireInstructions",
                                    "stylesFactory":function():void
                                    {
                                       this.fontSize = 15;
                                       this.paddingTop = 4;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":359,
                                          "height":53,
                                          "styleName":"s1FormMessage",
                                          "selectable":false,
                                          "mouseChildren":false,
                                          "mouseEnabled":false
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HBox,
                                    "id":"eloBodySkillBox",
                                    "stylesFactory":function():void
                                    {
                                       this.verticalCenter = "0";
                                       this.horizontalCenter = "0";
                                       this.horizontalGap = 0;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "horizontalScrollPolicy":"off",
                                          "verticalScrollPolicy":"off",
                                          "height":99,
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Canvas,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "cacheAsBitmap":true,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":RadioButton,
                                                      "id":"beginner",
                                                      "events":{
                                                         "click":"__beginner_click",
                                                         "doubleClick":"__beginner_doubleClick"
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "groupName":"skillLevel",
                                                            "styleName":"s1Questionaire"
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Label,
                                                      "id":"_EloQuestionaire_Label2",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalCenter = "0";
                                                         this.bottom = "12";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"whiteText",
                                                            "mouseChildren":false,
                                                            "mouseEnabled":false
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Canvas,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "cacheAsBitmap":true,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":RadioButton,
                                                      "id":"rtsplayer",
                                                      "events":{"click":"__rtsplayer_click"},
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "groupName":"skillLevel",
                                                            "styleName":"s1Questionaire"
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Label,
                                                      "id":"_EloQuestionaire_Label3",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalCenter = "0";
                                                         this.bottom = "12";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"whiteText",
                                                            "buttonMode":false,
                                                            "useHandCursor":false,
                                                            "mouseChildren":false,
                                                            "mouseEnabled":false
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Canvas,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "cacheAsBitmap":true,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":RadioButton,
                                                      "id":"veteran",
                                                      "events":{"click":"__veteran_click"},
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "groupName":"skillLevel",
                                                            "styleName":"s1Questionaire"
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Label,
                                                      "id":"_EloQuestionaire_Label4",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalCenter = "0";
                                                         this.bottom = "12";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "text":"Veteran",
                                                            "styleName":"whiteText",
                                                            "buttonMode":false,
                                                            "useHandCursor":false,
                                                            "mouseChildren":false,
                                                            "mouseEnabled":false
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Canvas,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "cacheAsBitmap":true,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":RadioButton,
                                                      "id":"expert",
                                                      "events":{"click":"__expert_click"},
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "groupName":"skillLevel",
                                                            "styleName":"s1Questionaire"
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Label,
                                                      "id":"_EloQuestionaire_Label5",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalCenter = "0";
                                                         this.bottom = "12";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"whiteText",
                                                            "buttonMode":false,
                                                            "useHandCursor":false,
                                                            "mouseChildren":false,
                                                            "mouseEnabled":false
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Spacer,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"height":0};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Text,
                                    "id":"systemMessage",
                                    "stylesFactory":function():void
                                    {
                                       this.paddingTop = 14;
                                       this.fontSize = 13;
                                       this.textAlign = "center";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"s1FormMessage",
                                          "width":597,
                                          "height":58,
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
                              this.bottom = "10";
                              this.right = "13";
                              this.horizontalAlign = "right";
                              this.verticalAlign = "middle";
                              this.horizontalGap = -2;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":605,
                                 "height":47,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"yes_btn",
                                    "events":{"click":"__yes_btn_click"},
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
         this._EloQuestionaire_RadioButtonGroup1_i();
         this.addEventListener("initialize",this.___EloQuestionaire_Canvas1_initialize);
         this.addEventListener("show",this.___EloQuestionaire_Canvas1_show);
         this.addEventListener("hide",this.___EloQuestionaire_Canvas1_hide);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EloQuestionaire._watcherSetupUtil = param1;
      }
      
      private function confirmClickHandler() : void
      {
         this.eloQuestionnaireModel.skillLevelValue = this.skillLevelValue;
      }
      
      [Bindable(event="propertyChange")]
      public function get eloTitle_c() : Canvas
      {
         return this._231242356eloTitle_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get yes_btn() : SoundEffectButton
      {
         return this._1280527100yes_btn;
      }
      
      public function set skillToolTip(param1:String) : void
      {
         var _loc2_:Object = this._1638209618skillToolTip;
         if(_loc2_ !== param1)
         {
            this._1638209618skillToolTip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skillToolTip",_loc2_,param1));
         }
      }
      
      public function set eloBodySkillBox(param1:HBox) : void
      {
         var _loc2_:Object = this._1216492988eloBodySkillBox;
         if(_loc2_ !== param1)
         {
            this._1216492988eloBodySkillBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloBodySkillBox",_loc2_,param1));
         }
      }
      
      private function processSkillLevel_change(param1:Object) : void
      {
         if(param1 == this.beginner)
         {
            this.skillLevelValue = InitialSkillLevel.BEGINNER;
            this.skillToolTip = ResourceManager.getInstance().getString("resources","eloQuestionaire_skill_beginner_tooltip");
            this.skillLevel.selection = this.beginner;
         }
         else if(param1 == this.rtsplayer)
         {
            this.skillLevelValue = InitialSkillLevel.RTS_PLAYER;
            this.skillToolTip = ResourceManager.getInstance().getString("resources","eloQuestionaire_skill_rtsplayer_tooltip");
            this.skillLevel.selection = this.rtsplayer;
         }
         else if(param1 == this.veteran)
         {
            this.skillLevelValue = InitialSkillLevel.VETERAN;
            this.skillToolTip = ResourceManager.getInstance().getString("resources","eloQuestionaire_skill_veteran_tooltip");
            this.skillLevel.selection = this.veteran;
         }
         else if(param1 == this.expert)
         {
            this.skillLevelValue = InitialSkillLevel.EXPERT;
            this.skillToolTip = ResourceManager.getInstance().getString("resources","eloQuestionaire_skill_expert_tooltip");
            this.skillLevel.selection = this.expert;
         }
         this.eloQuestionnaireModel.pendingSkillLevelValue = this.skillLevelValue;
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
      
      [Bindable(event="propertyChange")]
      public function get rtsplayer() : RadioButton
      {
         return this._1590887278rtsplayer;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EloQuestionaire = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EloQuestionaire_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_wizard_EloQuestionaireWatcherSetupUtil");
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
      
      public function __expert_click(param1:MouseEvent) : void
      {
         this.processSkillLevel_change(this.expert);
      }
      
      [Bindable(event="propertyChange")]
      private function get selected() : Boolean
      {
         return this._1191572123selected;
      }
      
      public function ___EloQuestionaire_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function __yes_btn_click(param1:MouseEvent) : void
      {
         this.confirmClickHandler();
      }
      
      private function _EloQuestionaire_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_questionnaire_menuBg");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_title");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_instructions");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_skill_beginner");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_skill_rtsplayer");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_skill_veteran");
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_skill_expert");
         _loc1_ = this.skillToolTip;
         _loc1_ = resourceManager.getString("resources","eloQuestionaire_confirm");
         _loc1_ = this.selected;
      }
      
      public function set eloQuestionaireInstructions(param1:Text) : void
      {
         var _loc2_:Object = this._2091065778eloQuestionaireInstructions;
         if(_loc2_ !== param1)
         {
            this._2091065778eloQuestionaireInstructions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloQuestionaireInstructions",_loc2_,param1));
         }
      }
      
      public function ___EloQuestionaire_Canvas1_hide(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      private function set selected(param1:Boolean) : void
      {
         var _loc2_:Object = this._1191572123selected;
         if(_loc2_ !== param1)
         {
            this._1191572123selected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected",_loc2_,param1));
         }
      }
      
      public function __beginner_click(param1:MouseEvent) : void
      {
         this.processSkillLevel_change(this.beginner);
      }
      
      public function set systemMessage(param1:Text) : void
      {
         var _loc2_:Object = this._1311104296systemMessage;
         if(_loc2_ !== param1)
         {
            this._1311104296systemMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"systemMessage",_loc2_,param1));
         }
      }
      
      public function __veteran_click(param1:MouseEvent) : void
      {
         this.processSkillLevel_change(this.veteran);
      }
      
      private function _EloQuestionaire_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_questionnaire_menuBg");
         },function(param1:Object):void
         {
            _EloQuestionaire_Image1.source = param1;
         },"_EloQuestionaire_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_lb.htmlText = param1;
         },"header_lb.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_instructions");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            eloQuestionaireInstructions.htmlText = param1;
         },"eloQuestionaireInstructions.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_skill_beginner");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EloQuestionaire_Label2.htmlText = param1;
         },"_EloQuestionaire_Label2.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_skill_rtsplayer");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EloQuestionaire_Label3.htmlText = param1;
         },"_EloQuestionaire_Label3.htmlText");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_skill_veteran");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EloQuestionaire_Label4.htmlText = param1;
         },"_EloQuestionaire_Label4.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_skill_expert");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EloQuestionaire_Label5.htmlText = param1;
         },"_EloQuestionaire_Label5.htmlText");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = skillToolTip;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            systemMessage.htmlText = param1;
         },"systemMessage.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","eloQuestionaire_confirm");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            yes_btn.label = param1;
         },"yes_btn.label");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return selected;
         },function(param1:Boolean):void
         {
            yes_btn.enabled = param1;
         },"yes_btn.enabled");
         result[9] = binding;
         return result;
      }
      
      public function __beginner_doubleClick(param1:MouseEvent) : void
      {
         this.processSkillLevel_change(this.beginner);
      }
      
      public function set beginner(param1:RadioButton) : void
      {
         var _loc2_:Object = this._1489437778beginner;
         if(_loc2_ !== param1)
         {
            this._1489437778beginner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"beginner",_loc2_,param1));
         }
      }
      
      public function set skillLevel(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._1589554099skillLevel;
         if(_loc2_ !== param1)
         {
            this._1589554099skillLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skillLevel",_loc2_,param1));
         }
      }
      
      public function __rtsplayer_click(param1:MouseEvent) : void
      {
         this.processSkillLevel_change(this.rtsplayer);
      }
      
      [Bindable(event="propertyChange")]
      public function get eloBodySkillBox() : HBox
      {
         return this._1216492988eloBodySkillBox;
      }
      
      [Bindable(event="propertyChange")]
      public function get eloQuestionaireInstructions() : Text
      {
         return this._2091065778eloQuestionaireInstructions;
      }
      
      private function onInitialize() : void
      {
         this.processSkillLevel_change(this.rtsplayer);
      }
      
      [Bindable(event="propertyChange")]
      public function get skillLevel() : RadioButtonGroup
      {
         return this._1589554099skillLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get expert() : RadioButton
      {
         return this._1289163222expert;
      }
      
      public function ___EloQuestionaire_Canvas1_show(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeInEffect(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get beginner() : RadioButton
      {
         return this._1489437778beginner;
      }
      
      public function set expert(param1:RadioButton) : void
      {
         var _loc2_:Object = this._1289163222expert;
         if(_loc2_ !== param1)
         {
            this._1289163222expert = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expert",_loc2_,param1));
         }
      }
      
      public function __skillLevel_change(param1:Event) : void
      {
         this.handleSkillLevel_change(param1);
      }
      
      public function set rtsplayer(param1:RadioButton) : void
      {
         var _loc2_:Object = this._1590887278rtsplayer;
         if(_loc2_ !== param1)
         {
            this._1590887278rtsplayer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rtsplayer",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get veteran() : RadioButton
      {
         return this._353046207veteran;
      }
      
      [Bindable(event="propertyChange")]
      public function get systemMessage() : Text
      {
         return this._1311104296systemMessage;
      }
      
      public function set eloTitle_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._231242356eloTitle_c;
         if(_loc2_ !== param1)
         {
            this._231242356eloTitle_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloTitle_c",_loc2_,param1));
         }
      }
      
      public function set veteran(param1:RadioButton) : void
      {
         var _loc2_:Object = this._353046207veteran;
         if(_loc2_ !== param1)
         {
            this._353046207veteran = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"veteran",_loc2_,param1));
         }
      }
      
      private function _EloQuestionaire_RadioButtonGroup1_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         this.skillLevel = _loc1_;
         _loc1_.addEventListener("change",this.__skillLevel_change);
         _loc1_.initialized(this,"skillLevel");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_lb() : Label
      {
         return this._213292952header_lb;
      }
      
      private function handleSkillLevel_change(param1:Event) : void
      {
         this.selected = true;
         this.processSkillLevel_change(this.skillLevel.selection);
      }
      
      [Bindable(event="propertyChange")]
      public function get skillToolTip() : String
      {
         return this._1638209618skillToolTip;
      }
   }
}

