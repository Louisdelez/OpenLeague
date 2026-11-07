package com.riotgames.platform.gameclient.views.lobby
{
   import blix.assets.proxy.SpriteProxy;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.lobby.ChooseGameFlowViewController;
   import com.riotgames.platform.gameclient.domain.game.GameOptionsList;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tournament.ITournamentCodeProvider;
   import com.riotgames.pvpnet.tournament.TournamentCodeProviderProxy;
   import com.riotgames.rust.context.RustContext;
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
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.controls.TextArea;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Glow;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseGameOptionsView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const INFO_DISPLAY_LAST_STEP_BUTTON_BG:Class = ChooseGameOptionsView_INFO_DISPLAY_LAST_STEP_BUTTON_BG;
      
      public static const PLAY_GAME_MENU_BG:Class = ChooseGameOptionsView_PLAY_GAME_MENU_BG;
      
      public static const MAIN_BG:Class = ChooseGameOptionsView_MAIN_BG;
      
      private var _1222997595fadeIn_and_glow_unglow_orange:Sequence;
      
      private var _1282133823fadeIn:Sequence;
      
      private var _212288788command_launch_panel:Canvas;
      
      private var _1146325580selectedOptionViewContainer:ChooseGameViewInfoPanel;
      
      private var _171502629createGameMessageHolder:UIComponent;
      
      public var _ChooseGameOptionsView_Image1:Image;
      
      mx_internal var _bindingsByDestination:Object;
      
      public var _ChooseGameOptionsView_Canvas3:Canvas;
      
      private var _1408376601create_game_btn_label:TextArea;
      
      public var _ChooseGameOptionsView_Canvas5:Canvas;
      
      private var _1225197776game_flow_launch_title:Label;
      
      public var _ChooseGameOptionsView_Canvas7:Canvas;
      
      private var _8673801mainList:GameOptionsTopLevelList;
      
      [Inject]
      public var gameQueueManager:GameQueueManager;
      
      private var _1113967612join_game_btn:SoundEffectButton;
      
      private var _1267997283list1Data:GameOptionsList;
      
      private var _895279571queue_party_label:Label;
      
      private var _558115901scroll_canvas_2:Canvas;
      
      private var _1346266524primaryListsListOptions1:GameOptionsRepeatedList;
      
      private var _852452238create_game_btn:SoundEffectButton;
      
      private var _1027352139glow_unglow_orange:Sequence;
      
      private var _1267073762list2Data:GameOptionsList;
      
      private var _558115900scroll_canvas_1:Canvas;
      
      private var _1549756293optionsListContainer:Canvas;
      
      private var _2098610006soloAvailable:Boolean = false;
      
      private var _673942909partyAvailable:Boolean = false;
      
      private var _1482585350custom_command_launch_panel:Canvas;
      
      private var _450876781soloVisible:Boolean = true;
      
      private var _503840007join_game_btn_label:TextArea;
      
      private var _1937671485cmnd_btn:SoundEffectButton;
      
      [Inject]
      private var _962434184chooseGameFlowViewController:ChooseGameFlowViewController;
      
      private var _1606300422primaryListsList2_title:Label;
      
      private var _970750454queue_party_btn_label:TextArea;
      
      private var _1268920804list0Data:GameOptionsList;
      
      private var _620530174play_together_btn:SoundEffectButton;
      
      private var _558115899scroll_canvas_0:Canvas;
      
      private var lastSelectedList:GameOptionsList = null;
      
      private var _677962841play_solo_btn:SoundEffectButton;
      
      private var _1021232498cmnd_btn_label:TextArea;
      
      mx_internal var _watchers:Array;
      
      private var _357116098tournamentCodeHolder:UIComponent;
      
      private var messageHolderProxy:SpriteProxy;
      
      private var _1801163193primaryListsList1_title:Label;
      
      public var soundManager:ISoundProvider;
      
      private var _913659512primaryListsList0_title:Label;
      
      private var _1456101433fadeIn_and_glow_unglow_blue:Sequence;
      
      private var gameFlowMessage:GameFlowMessage;
      
      private var _1346266525primaryListsListOptions0:GameOptionsRepeatedList;
      
      private var _1346266523primaryListsListOptions2:GameOptionsRepeatedList;
      
      private var pendingCommand:String = "";
      
      private var _2092567426queue_solo_label:Label;
      
      private var _179321728game_flow_launch_canvas:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _1918254881queue_solo_btn_label:TextArea;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1482812698queue_launch_panel:Canvas;
      
      public function ChooseGameOptionsView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"_ChooseGameOptionsView_Image1",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"optionsListContainer",
                  "stylesFactory":function():void
                  {
                     this.borderColor = 16777215;
                     this.borderThickness = 4;
                     this.backgroundAlpha = 1;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "height":230,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":GameOptionsTopLevelList,
                           "id":"mainList",
                           "events":{"itemRollOver":"__mainList_itemRollOver"},
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":230,
                                 "y":6,
                                 "width":186,
                                 "height":218,
                                 "styleName":"optionsFlowList",
                                 "allowMultipleSelection":false,
                                 "itemRenderer":_ChooseGameOptionsView_ClassFactory1_c()
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"primaryListsList0_title",
                           "stylesFactory":function():void
                           {
                              this.color = 14540253;
                              this.textAlign = "center";
                              this.fontSize = 15;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":424,
                                 "y":18,
                                 "height":30,
                                 "width":196
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"_ChooseGameOptionsView_Canvas3",
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":Canvas,
                                 "id":"scroll_canvas_0",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalScrollBarStyleName = "blueGlassScrollBar";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "x":424,
                                       "y":51,
                                       "width":197,
                                       "height":168,
                                       "horizontalScrollPolicy":"off",
                                       "childDescriptors":[new UIComponentDescriptor({
                                          "type":GameOptionsRepeatedList,
                                          "id":"primaryListsListOptions0",
                                          "events":{"itemRollOver":"__primaryListsListOptions0_itemRollOver"},
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "percentWidth":100,
                                                "minHeight":167,
                                                "visible":false,
                                                "allowMultipleSelection":false,
                                                "itemRenderer":_ChooseGameOptionsView_ClassFactory2_c()
                                             };
                                          }
                                       })]
                                    };
                                 }
                              })]};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"primaryListsList1_title",
                           "stylesFactory":function():void
                           {
                              this.color = 14540253;
                              this.textAlign = "center";
                              this.fontSize = 15;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":628,
                                 "y":18,
                                 "height":30,
                                 "width":196
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"_ChooseGameOptionsView_Canvas5",
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":Canvas,
                                 "id":"scroll_canvas_1",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalScrollBarStyleName = "blueGlassScrollBar";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "x":628,
                                       "y":51,
                                       "width":197,
                                       "height":168,
                                       "horizontalScrollPolicy":"off",
                                       "childDescriptors":[new UIComponentDescriptor({
                                          "type":GameOptionsRepeatedList,
                                          "id":"primaryListsListOptions1",
                                          "events":{"itemRollOver":"__primaryListsListOptions1_itemRollOver"},
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "percentWidth":100,
                                                "visible":false,
                                                "allowMultipleSelection":false,
                                                "minHeight":167,
                                                "itemRenderer":_ChooseGameOptionsView_ClassFactory3_c()
                                             };
                                          }
                                       })]
                                    };
                                 }
                              })]};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"primaryListsList2_title",
                           "stylesFactory":function():void
                           {
                              this.color = 14540253;
                              this.textAlign = "center";
                              this.fontSize = 15;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":832,
                                 "y":18,
                                 "height":30,
                                 "width":196
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"_ChooseGameOptionsView_Canvas7",
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":Canvas,
                                 "id":"scroll_canvas_2",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalScrollBarStyleName = "blueGlassScrollBar";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "x":832,
                                       "y":51,
                                       "width":197,
                                       "height":168,
                                       "horizontalScrollPolicy":"off",
                                       "childDescriptors":[new UIComponentDescriptor({
                                          "type":GameOptionsRepeatedList,
                                          "id":"primaryListsListOptions2",
                                          "events":{"itemRollOver":"__primaryListsListOptions2_itemRollOver"},
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "percentWidth":100,
                                                "visible":false,
                                                "allowMultipleSelection":false,
                                                "minHeight":167,
                                                "itemRenderer":_ChooseGameOptionsView_ClassFactory4_c()
                                             };
                                          }
                                       })]
                                    };
                                 }
                              })]};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChooseGameViewInfoPanel,
                  "id":"selectedOptionViewContainer",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.backgroundAlpha = 0;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":436,
                        "width":815
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"game_flow_launch_canvas",
                  "stylesFactory":function():void
                  {
                     this.bottom = "14";
                     this.right = "233";
                     this.backgroundAlpha = 1;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":377,
                        "height":142,
                        "clipContent":false,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"game_flow_launch_title",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 19;
                              this.top = "4";
                              this.left = "10";
                              this.color = 16369716;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "height":27
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"queue_launch_panel",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"queue_solo_label",
                                    "stylesFactory":function():void
                                    {
                                       this.fontSize = 17;
                                       this.left = "10";
                                       this.bottom = "58";
                                       this.color = 15658734;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":176,
                                          "height":24
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"play_solo_btn",
                                    "events":{"click":"__play_solo_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.left = "6";
                                       this.bottom = "6";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":180,
                                          "height":55,
                                          "styleName":"largeButtonOrange"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"queue_solo_btn_label",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "5";
                                       this.bottom = "5";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "selectable":false,
                                          "editable":false,
                                          "mouseEnabled":false,
                                          "mouseChildren":false,
                                          "tabEnabled":false,
                                          "styleName":"chooseGameOptionsButtonTextArea",
                                          "width":185,
                                          "height":50
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"queue_party_label",
                                    "stylesFactory":function():void
                                    {
                                       this.fontSize = 17;
                                       this.right = "10";
                                       this.bottom = "58";
                                       this.color = 15658734;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":176,
                                          "height":24
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"play_together_btn",
                                    "events":{"click":"__play_together_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.right = "6";
                                       this.bottom = "6";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":180,
                                          "height":55,
                                          "styleName":"largeButtonOrange"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"queue_party_btn_label",
                                    "stylesFactory":function():void
                                    {
                                       this.right = "5";
                                       this.bottom = "5";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "selectable":false,
                                          "editable":false,
                                          "mouseEnabled":false,
                                          "mouseChildren":false,
                                          "styleName":"chooseGameOptionsButtonTextArea",
                                          "tabEnabled":false,
                                          "width":185,
                                          "height":50
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"command_launch_panel",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"cmnd_btn",
                                    "events":{"click":"__cmnd_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalCenter = "0";
                                       this.bottom = "33";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":176,
                                          "height":47,
                                          "styleName":"largeButtonOrange"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"cmnd_btn_label",
                                    "stylesFactory":function():void
                                    {
                                       this.verticalCenter = "12";
                                       this.horizontalCenter = "0";
                                       this.fontSize = 17;
                                       this.color = 15658734;
                                       this.textAlign = "center";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "selectable":false,
                                          "editable":false,
                                          "mouseEnabled":false,
                                          "mouseChildren":false,
                                          "tabEnabled":false,
                                          "width":185,
                                          "height":25
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"custom_command_launch_panel",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"join_game_btn",
                                    "events":{"click":"__join_game_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.left = "6";
                                       this.bottom = "6";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":180,
                                          "height":55,
                                          "styleName":"largeButtonOrange"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"join_game_btn_label",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "5";
                                       this.bottom = "5";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"chooseGameOptionsButtonTextArea",
                                          "selectable":false,
                                          "editable":false,
                                          "mouseEnabled":false,
                                          "mouseChildren":false,
                                          "tabEnabled":false,
                                          "width":185,
                                          "height":40
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"create_game_btn",
                                    "events":{"click":"__create_game_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.right = "6";
                                       this.bottom = "6";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":180,
                                          "height":55,
                                          "styleName":"largeButtonOrange"
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":TextArea,
                                    "id":"create_game_btn_label",
                                    "stylesFactory":function():void
                                    {
                                       this.right = "5";
                                       this.bottom = "5";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"chooseGameOptionsButtonTextArea",
                                          "selectable":false,
                                          "editable":false,
                                          "mouseEnabled":false,
                                          "mouseChildren":false,
                                          "tabEnabled":false,
                                          "width":185,
                                          "height":40
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":UIComponent,
                           "id":"createGameMessageHolder",
                           "events":{"creationComplete":"__createGameMessageHolder_creationComplete"}
                        }),new UIComponentDescriptor({
                           "type":UIComponent,
                           "id":"tournamentCodeHolder",
                           "events":{"creationComplete":"__tournamentCodeHolder_creationComplete"}
                        })]
                     };
                  }
               })]};
            }
         });
         this.soundManager = SoundProviderProxy.instance;
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
            this.cornerRadius = 4;
            this.top = "2";
         };
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._ChooseGameOptionsView_State1_c(),this._ChooseGameOptionsView_State2_c(),this._ChooseGameOptionsView_State3_c(),this._ChooseGameOptionsView_State4_c()];
         this._ChooseGameOptionsView_Sequence1_i();
         this._ChooseGameOptionsView_Sequence2_i();
         this._ChooseGameOptionsView_Sequence3_i();
         this.addEventListener("creationComplete",this.___ChooseGameOptionsView_Canvas1_creationComplete);
         this.addEventListener("addedToStage",this.___ChooseGameOptionsView_Canvas1_addedToStage);
         this.addEventListener("currentStateChange",this.___ChooseGameOptionsView_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseGameOptionsView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get join_game_btn() : SoundEffectButton
      {
         return this._1113967612join_game_btn;
      }
      
      public function set join_game_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1113967612join_game_btn;
         if(_loc2_ !== param1)
         {
            this._1113967612join_game_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"join_game_btn",_loc2_,param1));
         }
      }
      
      public function ___ChooseGameOptionsView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.init();
      }
      
      public function set play_together_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._620530174play_together_btn;
         if(_loc2_ !== param1)
         {
            this._620530174play_together_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"play_together_btn",_loc2_,param1));
         }
      }
      
      public function set primaryListsList2_title(param1:Label) : void
      {
         var _loc2_:Object = this._1606300422primaryListsList2_title;
         if(_loc2_ !== param1)
         {
            this._1606300422primaryListsList2_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsList2_title",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_SetPropertyAction2_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get play_together_btn() : SoundEffectButton
      {
         return this._620530174play_together_btn;
      }
      
      private function _ChooseGameOptionsView_Fade2_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get queue_party_btn_label() : TextArea
      {
         return this._970750454queue_party_btn_label;
      }
      
      public function set queue_party_btn_label(param1:TextArea) : void
      {
         var _loc2_:Object = this._970750454queue_party_btn_label;
         if(_loc2_ !== param1)
         {
            this._970750454queue_party_btn_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue_party_btn_label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get list0Data() : GameOptionsList
      {
         return this._1268920804list0Data;
      }
      
      private function _ChooseGameOptionsView_ClassFactory3_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChooseGameOptionsRepeatedRenderer;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get createGameMessageHolder() : UIComponent
      {
         return this._171502629createGameMessageHolder;
      }
      
      private function _ChooseGameOptionsView_State3_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "customSelectedState";
         return _loc1_;
      }
      
      private function _ChooseGameOptionsView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return MAIN_BG;
         },function(param1:Object):void
         {
            _ChooseGameOptionsView_Image1.source = param1;
         },"_ChooseGameOptionsView_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return PLAY_GAME_MENU_BG;
         },function(param1:Object):void
         {
            optionsListContainer.setStyle("backgroundImage",param1);
         },"optionsListContainer.backgroundImage");
         result[1] = binding;
         binding = new Binding(this,function():Function
         {
            return updateAfterClick;
         },function(param1:Function):void
         {
            mainList.onSelectItemCallback = param1;
         },"mainList.onSelectItemCallback");
         result[2] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn_and_glow_unglow_blue : null;
         },function(param1:*):void
         {
            primaryListsList0_title.setStyle("showEffect",param1);
         },"primaryListsList0_title.showEffect");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsList0_title.text != "";
         },function(param1:Boolean):void
         {
            primaryListsList0_title.visible = param1;
         },"primaryListsList0_title.visible");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsListOptions0.visible;
         },function(param1:Boolean):void
         {
            _ChooseGameOptionsView_Canvas3.visible = param1;
         },"_ChooseGameOptionsView_Canvas3.visible");
         result[5] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn : null;
         },function(param1:*):void
         {
            _ChooseGameOptionsView_Canvas3.setStyle("showEffect",param1);
         },"_ChooseGameOptionsView_Canvas3.showEffect");
         result[6] = binding;
         binding = new Binding(this,function():Function
         {
            return updateAfterClick;
         },function(param1:Function):void
         {
            primaryListsListOptions0.onSelectItemCallback = param1;
         },"primaryListsListOptions0.onSelectItemCallback");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return list0Data;
         },function(param1:Object):void
         {
            primaryListsListOptions0.dataProvider = param1;
         },"primaryListsListOptions0.dataProvider");
         result[8] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn_and_glow_unglow_blue : null;
         },function(param1:*):void
         {
            primaryListsList1_title.setStyle("showEffect",param1);
         },"primaryListsList1_title.showEffect");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsList1_title.text != "";
         },function(param1:Boolean):void
         {
            primaryListsList1_title.visible = param1;
         },"primaryListsList1_title.visible");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsListOptions1.visible;
         },function(param1:Boolean):void
         {
            _ChooseGameOptionsView_Canvas5.visible = param1;
         },"_ChooseGameOptionsView_Canvas5.visible");
         result[11] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn : null;
         },function(param1:*):void
         {
            _ChooseGameOptionsView_Canvas5.setStyle("showEffect",param1);
         },"_ChooseGameOptionsView_Canvas5.showEffect");
         result[12] = binding;
         binding = new Binding(this,function():Function
         {
            return updateAfterClick;
         },function(param1:Function):void
         {
            primaryListsListOptions1.onSelectItemCallback = param1;
         },"primaryListsListOptions1.onSelectItemCallback");
         result[13] = binding;
         binding = new Binding(this,function():Object
         {
            return list1Data;
         },function(param1:Object):void
         {
            primaryListsListOptions1.dataProvider = param1;
         },"primaryListsListOptions1.dataProvider");
         result[14] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn_and_glow_unglow_blue : null;
         },function(param1:*):void
         {
            primaryListsList2_title.setStyle("showEffect",param1);
         },"primaryListsList2_title.showEffect");
         result[15] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsList2_title.text != "";
         },function(param1:Boolean):void
         {
            primaryListsList2_title.visible = param1;
         },"primaryListsList2_title.visible");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return primaryListsListOptions2.visible;
         },function(param1:Boolean):void
         {
            _ChooseGameOptionsView_Canvas7.visible = param1;
         },"_ChooseGameOptionsView_Canvas7.visible");
         result[17] = binding;
         binding = new Binding(this,function():*
         {
            return UserPreferencesManager.globalPrefs.enableAnimations ? fadeIn : null;
         },function(param1:*):void
         {
            _ChooseGameOptionsView_Canvas7.setStyle("showEffect",param1);
         },"_ChooseGameOptionsView_Canvas7.showEffect");
         result[18] = binding;
         binding = new Binding(this,function():Function
         {
            return updateAfterClick;
         },function(param1:Function):void
         {
            primaryListsListOptions2.onSelectItemCallback = param1;
         },"primaryListsListOptions2.onSelectItemCallback");
         result[19] = binding;
         binding = new Binding(this,function():Object
         {
            return list2Data;
         },function(param1:Object):void
         {
            primaryListsListOptions2.dataProvider = param1;
         },"primaryListsListOptions2.dataProvider");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = optionsListContainer.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            selectedOptionViewContainer.setStyle("top",param1);
         },"selectedOptionViewContainer.top");
         result[21] = binding;
         binding = new Binding(this,function():Object
         {
            return INFO_DISPLAY_LAST_STEP_BUTTON_BG;
         },function(param1:Object):void
         {
            game_flow_launch_canvas.setStyle("backgroundImage",param1);
         },"game_flow_launch_canvas.backgroundImage");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState != null;
         },function(param1:Boolean):void
         {
            game_flow_launch_canvas.visible = param1;
         },"game_flow_launch_canvas.visible");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == "queueSelectedState";
         },function(param1:Boolean):void
         {
            queue_launch_panel.visible = param1;
         },"queue_launch_panel.visible");
         result[24] = binding;
         binding = new Binding(this,function():Boolean
         {
            return soloVisible;
         },function(param1:Boolean):void
         {
            queue_solo_label.visible = param1;
         },"queue_solo_label.visible");
         result[25] = binding;
         binding = new Binding(this,function():Boolean
         {
            return soloAvailable;
         },function(param1:Boolean):void
         {
            play_solo_btn.enabled = param1;
         },"play_solo_btn.enabled");
         result[26] = binding;
         binding = new Binding(this,function():Boolean
         {
            return soloVisible;
         },function(param1:Boolean):void
         {
            play_solo_btn.visible = param1;
         },"play_solo_btn.visible");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return soloVisible;
         },function(param1:Boolean):void
         {
            queue_solo_btn_label.visible = param1;
         },"queue_solo_btn_label.visible");
         result[28] = binding;
         binding = new Binding(this,function():Boolean
         {
            return partyAvailable;
         },function(param1:Boolean):void
         {
            play_together_btn.enabled = param1;
         },"play_together_btn.enabled");
         result[29] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == "commandSelectedState";
         },function(param1:Boolean):void
         {
            command_launch_panel.visible = param1;
         },"command_launch_panel.visible");
         result[30] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == "customSelectedState";
         },function(param1:Boolean):void
         {
            custom_command_launch_panel.visible = param1;
         },"custom_command_launch_panel.visible");
         result[31] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == "tournamentCodeState";
         },function(param1:Boolean):void
         {
            tournamentCodeHolder.visible = param1;
         },"tournamentCodeHolder.visible");
         result[32] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get queue_party_label() : Label
      {
         return this._895279571queue_party_label;
      }
      
      private function set list0Data(param1:GameOptionsList) : void
      {
         var _loc2_:Object = this._1268920804list0Data;
         if(_loc2_ !== param1)
         {
            this._1268920804list0Data = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list0Data",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_Sequence4_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.glow_unglow_orange = _loc1_;
         _loc1_.children = [this._ChooseGameOptionsView_Glow3_c(),this._ChooseGameOptionsView_Glow4_c()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get scroll_canvas_0() : Canvas
      {
         return this._558115899scroll_canvas_0;
      }
      
      [Bindable(event="propertyChange")]
      public function get scroll_canvas_1() : Canvas
      {
         return this._558115900scroll_canvas_1;
      }
      
      [Bindable(event="propertyChange")]
      public function get scroll_canvas_2() : Canvas
      {
         return this._558115901scroll_canvas_2;
      }
      
      private function set list2Data(param1:GameOptionsList) : void
      {
         var _loc2_:Object = this._1267073762list2Data;
         if(_loc2_ !== param1)
         {
            this._1267073762list2Data = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list2Data",_loc2_,param1));
         }
      }
      
      private function setVisualSelections() : void
      {
         var _loc1_:String = null;
         var _loc2_:GamePropertiesListData = null;
         var _loc3_:GameFlowVariant = null;
         this.mainList.visible = true;
         if(this.mainList.selectedItem)
         {
            this.primaryListsListOptions0.visible = true;
            this.list0Data = this.mainList.selectedItem as GameOptionsList;
            this.primaryListsList0_title.text = this.list0Data.displayTitle;
            if(this.list0Data)
            {
               if(this.list0Data.selectedIndex == -1)
               {
                  this.list0Data.selectedIndex = 0;
               }
               this.primaryListsListOptions0.selectedIndex = this.list0Data.selectedIndex;
               _loc2_ = this.list0Data.selectedChild as GamePropertiesListData;
               this.selectedOptionViewContainer.setInfoBackground(_loc2_);
               _loc3_ = GameFlowVariantFactory.instance.getVariantForGameKey(_loc2_.gameKey);
               this.selectedOptionViewContainer.setModeTextColor(_loc3_.getGameFlowColor());
               this.list1Data = _loc2_ != null ? _loc2_.nextStep as GameOptionsList : null;
               if(this.list1Data)
               {
                  this.primaryListsList1_title.text = this.list1Data.displayTitle;
                  this.primaryListsListOptions1.visible = true;
               }
               else
               {
                  this.primaryListsList1_title.text = "";
                  this.primaryListsListOptions1.visible = false;
               }
               if(Boolean(this.list1Data) && this.list1Data.selectedIndex > -1)
               {
                  this.primaryListsListOptions1.selectedIndex = this.list1Data.selectedIndex;
                  this.selectedOptionViewContainer.setInfoBackground(_loc2_,this.list1Data.selectedChild);
                  this.list2Data = this.list1Data.selectedChild.nextStep as GameOptionsList;
                  if(this.list2Data)
                  {
                     this.primaryListsList2_title.text = this.list2Data.displayTitle;
                     this.primaryListsListOptions2.visible = true;
                  }
                  else
                  {
                     this.primaryListsList2_title.text = "";
                     this.primaryListsListOptions2.visible = false;
                  }
                  if(Boolean(this.list2Data) && this.list2Data.selectedIndex > -1)
                  {
                     this.primaryListsListOptions2.selectedIndex = this.list2Data.selectedIndex;
                     this.selectedOptionViewContainer.setInfoBackground(_loc2_,this.list1Data.selectedChild,this.list2Data.selectedChild);
                     this.lastSelectedList = this.list2Data;
                  }
                  else
                  {
                     this.lastSelectedList = this.list1Data;
                  }
               }
               else
               {
                  this.lastSelectedList = this.list0Data;
                  this.primaryListsList2_title.text = "";
                  this.primaryListsListOptions2.visible = false;
                  this.list2Data = null;
               }
            }
            else
            {
               this.selectedOptionViewContainer.setInfoBackground();
               this.primaryListsList2_title.text = "";
               this.primaryListsList1_title.text = "";
               this.primaryListsListOptions1.visible = false;
               this.primaryListsListOptions2.visible = false;
               this.list2Data = null;
               this.list1Data = null;
            }
         }
         this.pendingCommand = "";
         if(Boolean(this.lastSelectedList) && Boolean(this.lastSelectedList.selectedChild) && this.lastSelectedList.selectedChild.nextStep is XML)
         {
            this.game_flow_launch_canvas.mouseChildren = true;
            this.gameFlowMessage.setVisible(false);
            if(this.lastSelectedList.selectedChild.nextStep.name() == "queue")
            {
               this.currentState = "queueSelectedState";
               this.soloAvailable = this.lastSelectedList.selectedChild.nextStep.@soloEnabled == "true";
               this.partyAvailable = this.lastSelectedList.selectedChild.nextStep.@partyEnabled == "true";
               this.soloVisible = this.lastSelectedList.selectedChild.nextStep.@soloid > -1;
               this.updateLastStepButtonText(this.lastSelectedList.selectedChild);
               this.updateGameQueueMessage(this.lastSelectedList.selectedChild.nextStep as XML);
               if(UserPreferencesManager.globalPrefs.enableAnimations)
               {
                  this.fadeIn_and_glow_unglow_orange.end();
                  this.fadeIn_and_glow_unglow_orange.play([this.queue_launch_panel]);
               }
            }
            else if(this.lastSelectedList.selectedChild.nextStep.name() == "command")
            {
               if((this.lastSelectedList.selectedChild.nextStep as XML).@system == "custom_games")
               {
                  if((this.lastSelectedList.selectedChild.nextStep as XML).@command == "tournament_code")
                  {
                     this.currentState = "tournamentCodeState";
                  }
                  else
                  {
                     this.currentState = "customSelectedState";
                  }
               }
               else if((this.lastSelectedList.selectedChild.nextStep as XML).@system == "tutorials")
               {
                  this.currentState = "commandSelectedState";
                  this.cmnd_btn_label.text = RiotResourceLoader.getString("command_btn_tutorial_go_label","Go");
                  this.pendingCommand = (this.lastSelectedList.selectedChild.nextStep as XML).@command;
               }
               if(UserPreferencesManager.globalPrefs.enableAnimations)
               {
                  this.fadeIn_and_glow_unglow_orange.end();
                  this.fadeIn_and_glow_unglow_orange.play([this.command_launch_panel]);
               }
            }
            if(UserPreferencesManager.globalPrefs.enableAnimations)
            {
               if(!this.game_flow_launch_canvas.visible)
               {
                  this.fadeIn_and_glow_unglow_orange.end();
                  this.fadeIn_and_glow_unglow_orange.play([this.game_flow_launch_canvas]);
               }
            }
            else
            {
               this.game_flow_launch_canvas.alpha = 1;
            }
         }
         else
         {
            this.currentState = null;
         }
         this.selectedOptionViewContainer.switchBackgrounds();
      }
      
      private function updateLastStepButtonText(param1:GamePropertiesListData) : void
      {
         if(!this.queue_party_label || !this.queue_party_btn_label || !param1)
         {
            return;
         }
         if(param1.modifierProperties["gameType"] == "cap")
         {
            this.queue_solo_btn_label.text = RiotResourceLoader.getString("game_flow_cap_solo","Solo - Join a Lobby");
            this.queue_party_btn_label.text = RiotResourceLoader.getString("game_flow_cap_captain","Captain - Create a Lobby");
         }
         else
         {
            this.queue_solo_btn_label.text = RiotResourceLoader.getString("queue_btn_solo_label","Solo");
            this.queue_party_btn_label.text = RiotResourceLoader.getString("queue_btn_" + param1.nextStep.@partyQueueType + "_label",param1.nextStep.@partyQueueType);
         }
         this.queue_party_label.text = RiotResourceLoader.getString("queue_" + param1.nextStep.@partyQueueType + "_label",param1.nextStep.@partyQueueType);
         this.sizePlayButtonLabel(this.queue_party_btn_label);
         this.sizePlayButtonLabel(this.queue_solo_btn_label);
      }
      
      private function _ChooseGameOptionsView_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      private function _ChooseGameOptionsView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      private function _ChooseGameOptionsView_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChooseGameOptionsRepeatedRenderer;
         return _loc1_;
      }
      
      public function set queue_party_label(param1:Label) : void
      {
         var _loc2_:Object = this._895279571queue_party_label;
         if(_loc2_ !== param1)
         {
            this._895279571queue_party_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue_party_label",_loc2_,param1));
         }
      }
      
      public function set createGameMessageHolder(param1:UIComponent) : void
      {
         var _loc2_:Object = this._171502629createGameMessageHolder;
         if(_loc2_ !== param1)
         {
            this._171502629createGameMessageHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createGameMessageHolder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsListOptions0() : GameOptionsRepeatedList
      {
         return this._1346266525primaryListsListOptions0;
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsListOptions1() : GameOptionsRepeatedList
      {
         return this._1346266524primaryListsListOptions1;
      }
      
      public function set game_flow_launch_title(param1:Label) : void
      {
         var _loc2_:Object = this._1225197776game_flow_launch_title;
         if(_loc2_ !== param1)
         {
            this._1225197776game_flow_launch_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"game_flow_launch_title",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_State2_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "commandSelectedState";
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn_and_glow_unglow_orange() : Sequence
      {
         return this._1222997595fadeIn_and_glow_unglow_orange;
      }
      
      [Bindable(event="propertyChange")]
      public function get create_game_btn() : SoundEffectButton
      {
         return this._852452238create_game_btn;
      }
      
      public function set scroll_canvas_0(param1:Canvas) : void
      {
         var _loc2_:Object = this._558115899scroll_canvas_0;
         if(_loc2_ !== param1)
         {
            this._558115899scroll_canvas_0 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scroll_canvas_0",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_Sequence3_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn_and_glow_unglow_orange = _loc1_;
         _loc1_.children = [this._ChooseGameOptionsView_Sequence4_i()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedOptionViewContainer() : ChooseGameViewInfoPanel
      {
         return this._1146325580selectedOptionViewContainer;
      }
      
      public function set cmnd_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1937671485cmnd_btn;
         if(_loc2_ !== param1)
         {
            this._1937671485cmnd_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cmnd_btn",_loc2_,param1));
         }
      }
      
      private function startup() : void
      {
         if(this.mainList.selectedItem != null)
         {
            if(this.chooseGameFlowViewController.pendingSelection == null)
            {
               return;
            }
         }
         else
         {
            this.mainList.dataProvider = this.chooseGameFlowViewController.queueOptionsListCollection;
         }
         var _loc1_:Array = this.chooseGameFlowViewController.pendingSelection ? this.chooseGameFlowViewController.pendingSelection : this.chooseGameFlowViewController.defaultSelections;
         this.setSelectedOptions(_loc1_);
         this.chooseGameFlowViewController.pendingSelection = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsList0_title() : Label
      {
         return this._913659512primaryListsList0_title;
      }
      
      private function launchSelectedGame(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.updateGameModel();
         if(Boolean(param1) && param1.type == MouseEvent.CLICK)
         {
            if(param1.target === this.play_solo_btn)
            {
               this.chooseGameFlowViewController.selectQueue(this.lastSelectedList.selectedChild.nextStep.@soloid,true);
            }
            else if(param1.target === this.play_together_btn)
            {
               _loc2_ = int(this.lastSelectedList.selectedChild.nextStep.@partyid);
               if(this.lastSelectedList.selectedChild.nextStep.@partyQueueType == ChooseGameFlowViewController.PARTY_QUEUE_DUO)
               {
                  _loc2_ = int(this.lastSelectedList.selectedChild.nextStep.@soloid);
               }
               this.chooseGameFlowViewController.selectQueue(_loc2_,false);
            }
            else if(param1.target === this.create_game_btn)
            {
               this.chooseGameFlowViewController.issueCommand(ChooseGameFlowViewController.COMMAND_CREATE);
            }
            else if(param1.target === this.join_game_btn)
            {
               this.chooseGameFlowViewController.issueCommand(ChooseGameFlowViewController.COMMAND_JOIN);
            }
            else if(param1.target === this.cmnd_btn)
            {
               this.chooseGameFlowViewController.issueCommand(this.pendingCommand);
            }
         }
         else if(Boolean(param1) && param1.type == ListEvent.ITEM_DOUBLE_CLICK)
         {
            if(this.pendingCommand != "")
            {
               this.chooseGameFlowViewController.issueCommand(this.pendingCommand);
            }
         }
      }
      
      public function set scroll_canvas_2(param1:Canvas) : void
      {
         var _loc2_:Object = this._558115901scroll_canvas_2;
         if(_loc2_ !== param1)
         {
            this._558115901scroll_canvas_2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scroll_canvas_2",_loc2_,param1));
         }
      }
      
      private function onitemRollOver() : void
      {
         this.soundManager.play(AudioKeys.SOUND_MOUSE_OVER);
      }
      
      private function updateHeaders() : void
      {
         var _loc2_:GameOptionsList = null;
         var _loc3_:IListItemRenderer = null;
         var _loc1_:List = this.mainList as List;
         for each(_loc2_ in this.chooseGameFlowViewController.queueOptionsListCollection)
         {
            _loc3_ = _loc1_.itemToItemRenderer(_loc2_);
            if(_loc3_ != null)
            {
               _loc3_.data = null;
               _loc3_.data = _loc2_;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsListOptions2() : GameOptionsRepeatedList
      {
         return this._1346266523primaryListsListOptions2;
      }
      
      [Bindable(event="propertyChange")]
      private function get partyAvailable() : Boolean
      {
         return this._673942909partyAvailable;
      }
      
      public function __mainList_itemRollOver(param1:ListEvent) : void
      {
         this.onitemRollOver();
      }
      
      public function set scroll_canvas_1(param1:Canvas) : void
      {
         var _loc2_:Object = this._558115900scroll_canvas_1;
         if(_loc2_ !== param1)
         {
            this._558115900scroll_canvas_1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scroll_canvas_1",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get soloVisible() : Boolean
      {
         return this._450876781soloVisible;
      }
      
      private function clearSelections() : void
      {
         if(this.list0Data)
         {
            this.list0Data.selectedIndex = -1;
         }
         if(this.list1Data)
         {
            this.list1Data.selectedIndex = -1;
         }
         if(this.list2Data)
         {
            this.list2Data.selectedIndex = -1;
         }
         this.setSelectedOptions([0,0]);
         if(this.primaryListsListOptions1)
         {
            this.primaryListsListOptions1.selectedIndex = -1;
         }
      }
      
      private function _ChooseGameOptionsView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = MAIN_BG;
         _loc1_ = PLAY_GAME_MENU_BG;
         _loc1_ = this.updateAfterClick;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn_and_glow_unglow_blue : null;
         _loc1_ = this.primaryListsList0_title.text != "";
         _loc1_ = this.primaryListsListOptions0.visible;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn : null;
         _loc1_ = this.updateAfterClick;
         _loc1_ = this.list0Data;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn_and_glow_unglow_blue : null;
         _loc1_ = this.primaryListsList1_title.text != "";
         _loc1_ = this.primaryListsListOptions1.visible;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn : null;
         _loc1_ = this.updateAfterClick;
         _loc1_ = this.list1Data;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn_and_glow_unglow_blue : null;
         _loc1_ = this.primaryListsList2_title.text != "";
         _loc1_ = this.primaryListsListOptions2.visible;
         _loc1_ = UserPreferencesManager.globalPrefs.enableAnimations ? this.fadeIn : null;
         _loc1_ = this.updateAfterClick;
         _loc1_ = this.list2Data;
         _loc1_ = this.optionsListContainer.height;
         _loc1_ = INFO_DISPLAY_LAST_STEP_BUTTON_BG;
         _loc1_ = this.currentState != null;
         _loc1_ = this.currentState == "queueSelectedState";
         _loc1_ = this.soloVisible;
         _loc1_ = this.soloAvailable;
         _loc1_ = this.soloVisible;
         _loc1_ = this.soloVisible;
         _loc1_ = this.partyAvailable;
         _loc1_ = this.currentState == "commandSelectedState";
         _loc1_ = this.currentState == "customSelectedState";
         _loc1_ = this.currentState == "tournamentCodeState";
      }
      
      public function set selectedOptionViewContainer(param1:ChooseGameViewInfoPanel) : void
      {
         var _loc2_:Object = this._1146325580selectedOptionViewContainer;
         if(_loc2_ !== param1)
         {
            this._1146325580selectedOptionViewContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedOptionViewContainer",_loc2_,param1));
         }
      }
      
      private function onCurrentStateChanged(param1:StateChangeEvent) : void
      {
         if(this.game_flow_launch_canvas.visible)
         {
            this.glow_unglow_orange.end();
            this.glow_unglow_orange.play([this.game_flow_launch_canvas]);
         }
      }
      
      private function _ChooseGameOptionsView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChooseGameOptionsTopLevelRenderer;
         return _loc1_;
      }
      
      private function _ChooseGameOptionsView_State1_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "queueSelectedState";
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get soloAvailable() : Boolean
      {
         return this._2098610006soloAvailable;
      }
      
      private function _ChooseGameOptionsView_Sequence2_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn_and_glow_unglow_blue = _loc1_;
         _loc1_.children = [this._ChooseGameOptionsView_SetPropertyAction2_c(),this._ChooseGameOptionsView_Fade2_c(),this._ChooseGameOptionsView_Glow1_c(),this._ChooseGameOptionsView_Glow2_c()];
         return _loc1_;
      }
      
      public function ___ChooseGameOptionsView_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChanged(param1);
      }
      
      public function updateAfterClick(param1:IListItemRenderer) : void
      {
         this.soundManager.play(AudioKeys.SOUND_MOUSE_DOWN);
         var _loc2_:GamePropertiesListData = param1.data as GamePropertiesListData;
         if(!_loc2_)
         {
            if(param1.data is GameOptionsList)
            {
               if(this.mainList.updateNeeded)
               {
                  this.primaryListsListOptions0.visible = false;
                  this.primaryListsListOptions1.visible = false;
                  this.primaryListsListOptions2.visible = false;
               }
               this.setVisualSelections();
            }
            this.chooseGameFlowViewController.resetGameModel();
            this.updateGameModel();
            return;
         }
         if(param1.owner === this.primaryListsListOptions0 && this.primaryListsListOptions0.updateNeeded)
         {
            this.primaryListsListOptions1.visible = false;
            this.primaryListsListOptions2.visible = false;
         }
         else if(param1.owner === this.primaryListsListOptions1 && this.primaryListsListOptions1.updateNeeded)
         {
            this.primaryListsListOptions2.visible = false;
         }
         if(_loc2_.setSelected())
         {
            if(_loc2_.parentList === this.list0Data)
            {
               this.list1Data = _loc2_.nextStep as GameOptionsList;
               if(Boolean(this.list1Data) && Boolean(this.list1Data.selectedChild))
               {
                  this.list2Data = this.list1Data.selectedChild.nextStep as GameOptionsList;
               }
            }
            if(_loc2_.parentList === this.list1Data)
            {
               this.list2Data = this.list1Data.selectedChild.nextStep as GameOptionsList;
            }
            this.updateGameModel();
         }
         if(_loc2_.nextStep is XML)
         {
            if((_loc2_.nextStep as XML).name() == "command")
            {
               this.pendingCommand = (_loc2_.nextStep as XML).@command;
            }
         }
         this.setVisualSelections();
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      [Bindable(event="propertyChange")]
      public function get tournamentCodeHolder() : UIComponent
      {
         return this._357116098tournamentCodeHolder;
      }
      
      public function set primaryListsListOptions2(param1:GameOptionsRepeatedList) : void
      {
         var _loc2_:Object = this._1346266523primaryListsListOptions2;
         if(_loc2_ !== param1)
         {
            this._1346266523primaryListsListOptions2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsListOptions2",_loc2_,param1));
         }
      }
      
      public function set fadeIn_and_glow_unglow_orange(param1:Sequence) : void
      {
         var _loc2_:Object = this._1222997595fadeIn_and_glow_unglow_orange;
         if(_loc2_ !== param1)
         {
            this._1222997595fadeIn_and_glow_unglow_orange = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn_and_glow_unglow_orange",_loc2_,param1));
         }
      }
      
      public function set primaryListsListOptions1(param1:GameOptionsRepeatedList) : void
      {
         var _loc2_:Object = this._1346266524primaryListsListOptions1;
         if(_loc2_ !== param1)
         {
            this._1346266524primaryListsListOptions1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsListOptions1",_loc2_,param1));
         }
      }
      
      private function sizePlayButtonLabel(param1:TextArea) : void
      {
         param1.validateNow();
         if(param1.textHeight < 30)
         {
            param1.height = 40;
         }
         else
         {
            param1.height = 50;
         }
      }
      
      public function set primaryListsListOptions0(param1:GameOptionsRepeatedList) : void
      {
         var _loc2_:Object = this._1346266525primaryListsListOptions0;
         if(_loc2_ !== param1)
         {
            this._1346266525primaryListsListOptions0 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsListOptions0",_loc2_,param1));
         }
      }
      
      private function setSelectedOptions(param1:Array) : void
      {
         var _loc2_:GameOptionsList = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            switch(_loc3_)
            {
               case 0:
                  if(this.chooseGameFlowViewController.queueOptionsListCollection.length > param1[0])
                  {
                     this.mainList.selectedIndex = param1[0];
                  }
                  break;
               default:
                  if(_loc3_ == 1)
                  {
                     _loc2_ = this.chooseGameFlowViewController.queueOptionsListCollection[param1[0]];
                  }
                  else
                  {
                     _loc2_ = _loc2_.selectedChild.nextStep as GameOptionsList;
                  }
                  if(_loc2_.length > param1[_loc3_])
                  {
                     _loc2_.selectedIndex = param1[_loc3_];
                     if(_loc2_.selectedChild)
                     {
                        this["list" + (_loc3_ - 1).toString() + "Data"] = _loc2_.selectedChild.nextStep as GameOptionsList;
                     }
                  }
            }
            _loc3_++;
         }
         this.setVisualSelections();
         this.updateGameModel();
      }
      
      public function __primaryListsListOptions2_itemRollOver(param1:ListEvent) : void
      {
         this.onitemRollOver();
      }
      
      [Bindable(event="propertyChange")]
      public function get queue_solo_btn_label() : TextArea
      {
         return this._1918254881queue_solo_btn_label;
      }
      
      public function set create_game_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._852452238create_game_btn;
         if(_loc2_ !== param1)
         {
            this._852452238create_game_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"create_game_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get queue_launch_panel() : Canvas
      {
         return this._1482812698queue_launch_panel;
      }
      
      private function _ChooseGameOptionsView_Glow4_c() : Glow
      {
         var _loc1_:Glow = new Glow();
         _loc1_.duration = 450;
         _loc1_.alphaFrom = 0.8;
         _loc1_.alphaTo = 0.1;
         _loc1_.blurXFrom = 10;
         _loc1_.blurXTo = 5;
         _loc1_.blurYFrom = 10;
         _loc1_.blurYTo = 5;
         _loc1_.strength = 3;
         _loc1_.color = 16753152;
         return _loc1_;
      }
      
      public function set cmnd_btn_label(param1:TextArea) : void
      {
         var _loc2_:Object = this._1021232498cmnd_btn_label;
         if(_loc2_ !== param1)
         {
            this._1021232498cmnd_btn_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cmnd_btn_label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get command_launch_panel() : Canvas
      {
         return this._212288788command_launch_panel;
      }
      
      [Bindable(event="propertyChange")]
      public function get create_game_btn_label() : TextArea
      {
         return this._1408376601create_game_btn_label;
      }
      
      public function set primaryListsList0_title(param1:Label) : void
      {
         var _loc2_:Object = this._913659512primaryListsList0_title;
         if(_loc2_ !== param1)
         {
            this._913659512primaryListsList0_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsList0_title",_loc2_,param1));
         }
      }
      
      private function onTournamentCodeHolderReady() : void
      {
         var _loc1_:ITournamentCodeProvider = TournamentCodeProviderProxy.instance;
         _loc1_.showTournamentCodePanel(this.tournamentCodeHolder);
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
      }
      
      private function _ChooseGameOptionsView_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._ChooseGameOptionsView_SetPropertyAction1_c(),this._ChooseGameOptionsView_Fade1_c()];
         return _loc1_;
      }
      
      public function set chooseGameFlowViewController(param1:ChooseGameFlowViewController) : void
      {
         var _loc2_:Object = this._962434184chooseGameFlowViewController;
         if(_loc2_ !== param1)
         {
            this._962434184chooseGameFlowViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseGameFlowViewController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get join_game_btn_label() : TextArea
      {
         return this._503840007join_game_btn_label;
      }
      
      [Bindable(event="propertyChange")]
      public function get custom_command_launch_panel() : Canvas
      {
         return this._1482585350custom_command_launch_panel;
      }
      
      public function set game_flow_launch_canvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._179321728game_flow_launch_canvas;
         if(_loc2_ !== param1)
         {
            this._179321728game_flow_launch_canvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"game_flow_launch_canvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsList2_title() : Label
      {
         return this._1606300422primaryListsList2_title;
      }
      
      public function set queue_solo_label(param1:Label) : void
      {
         var _loc2_:Object = this._2092567426queue_solo_label;
         if(_loc2_ !== param1)
         {
            this._2092567426queue_solo_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue_solo_label",_loc2_,param1));
         }
      }
      
      private function set partyAvailable(param1:Boolean) : void
      {
         var _loc2_:Object = this._673942909partyAvailable;
         if(_loc2_ !== param1)
         {
            this._673942909partyAvailable = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"partyAvailable",_loc2_,param1));
         }
      }
      
      public function set optionsListContainer(param1:Canvas) : void
      {
         var _loc2_:Object = this._1549756293optionsListContainer;
         if(_loc2_ !== param1)
         {
            this._1549756293optionsListContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsListContainer",_loc2_,param1));
         }
      }
      
      private function onMessageHolderReady() : void
      {
         var _loc1_:RustContext = new RustContext();
         _loc1_.loadAssets("/assets/swfs/chooseGameFlow/gameFlowTip.swf");
         this.messageHolderProxy = new SpriteProxy(_loc1_,this.createGameMessageHolder);
         this.gameFlowMessage = new GameFlowMessage(this.messageHolderProxy);
         this.messageHolderProxy.addChild(this.gameFlowMessage);
         this.gameFlowMessage.setVisible(false);
      }
      
      private function init() : void
      {
         this.game_flow_launch_title.text = RiotResourceLoader.getString("game_flow_launch_title","Last Step");
         this.queue_solo_label.text = RiotResourceLoader.getString("queue_solo_label","Solo");
         this.queue_solo_btn_label.text = RiotResourceLoader.getString("queue_btn_solo_label","Solo");
         this.cmnd_btn_label.text = RiotResourceLoader.getString("command_btn_tutorial_go_label","Go");
         this.join_game_btn_label.text = RiotResourceLoader.getString("command_btn_join_custom_go_label","Go");
         this.create_game_btn_label.text = RiotResourceLoader.getString("command_btn_create_custom_go_label","Go");
         this.sizePlayButtonLabel(this.queue_solo_btn_label);
         var _loc1_:GlowFilter = new GlowFilter(0,0.7,6,6,2,1,false);
         this.queue_solo_btn_label.filters = [_loc1_];
         this.queue_party_btn_label.filters = [_loc1_];
         this.join_game_btn_label.filters = [_loc1_];
         this.create_game_btn_label.filters = [_loc1_];
         this.cmnd_btn_label.filters = [_loc1_];
         this.chooseGameFlowViewController.getOnOptionsListsUpdated().add(this.updateHeaders);
         this.gameQueueManager.getQueuesUpdated().add(this.clearSelections);
      }
      
      public function __play_solo_btn_click(param1:MouseEvent) : void
      {
         this.launchSelectedGame(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get list2Data() : GameOptionsList
      {
         return this._1267073762list2Data;
      }
      
      public function __play_together_btn_click(param1:MouseEvent) : void
      {
         this.launchSelectedGame(param1);
      }
      
      private function _ChooseGameOptionsView_Glow3_c() : Glow
      {
         var _loc1_:Glow = new Glow();
         _loc1_.duration = 650;
         _loc1_.alphaFrom = 0.1;
         _loc1_.alphaTo = 0.8;
         _loc1_.blurXFrom = 5;
         _loc1_.blurXTo = 10;
         _loc1_.blurYFrom = 5;
         _loc1_.blurYTo = 10;
         _loc1_.strength = 3;
         _loc1_.color = 16753152;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get game_flow_launch_title() : Label
      {
         return this._1225197776game_flow_launch_title;
      }
      
      public function __tournamentCodeHolder_creationComplete(param1:FlexEvent) : void
      {
         this.onTournamentCodeHolderReady();
      }
      
      public function __primaryListsListOptions1_itemRollOver(param1:ListEvent) : void
      {
         this.onitemRollOver();
      }
      
      private function set list1Data(param1:GameOptionsList) : void
      {
         var _loc2_:Object = this._1267997283list1Data;
         if(_loc2_ !== param1)
         {
            this._1267997283list1Data = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list1Data",_loc2_,param1));
         }
      }
      
      private function set soloVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._450876781soloVisible;
         if(_loc2_ !== param1)
         {
            this._450876781soloVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"soloVisible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cmnd_btn() : SoundEffectButton
      {
         return this._1937671485cmnd_btn;
      }
      
      private function set soloAvailable(param1:Boolean) : void
      {
         var _loc2_:Object = this._2098610006soloAvailable;
         if(_loc2_ !== param1)
         {
            this._2098610006soloAvailable = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"soloAvailable",_loc2_,param1));
         }
      }
      
      public function set play_solo_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._677962841play_solo_btn;
         if(_loc2_ !== param1)
         {
            this._677962841play_solo_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"play_solo_btn",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_Glow2_c() : Glow
      {
         var _loc1_:Glow = new Glow();
         _loc1_.duration = 450;
         _loc1_.alphaFrom = 0.8;
         _loc1_.alphaTo = 0.1;
         _loc1_.blurXFrom = 10;
         _loc1_.blurXTo = 5;
         _loc1_.blurYFrom = 10;
         _loc1_.blurYTo = 5;
         _loc1_.strength = 3;
         _loc1_.color = 26367;
         return _loc1_;
      }
      
      public function set glow_unglow_orange(param1:Sequence) : void
      {
         var _loc2_:Object = this._1027352139glow_unglow_orange;
         if(_loc2_ !== param1)
         {
            this._1027352139glow_unglow_orange = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glow_unglow_orange",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cmnd_btn_label() : TextArea
      {
         return this._1021232498cmnd_btn_label;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chooseGameFlowViewController() : ChooseGameFlowViewController
      {
         return this._962434184chooseGameFlowViewController;
      }
      
      public function set primaryListsList1_title(param1:Label) : void
      {
         var _loc2_:Object = this._1801163193primaryListsList1_title;
         if(_loc2_ !== param1)
         {
            this._1801163193primaryListsList1_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"primaryListsList1_title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get game_flow_launch_canvas() : Canvas
      {
         return this._179321728game_flow_launch_canvas;
      }
      
      public function set tournamentCodeHolder(param1:UIComponent) : void
      {
         var _loc2_:Object = this._357116098tournamentCodeHolder;
         if(_loc2_ !== param1)
         {
            this._357116098tournamentCodeHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tournamentCodeHolder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get optionsListContainer() : Canvas
      {
         return this._1549756293optionsListContainer;
      }
      
      public function set fadeIn_and_glow_unglow_blue(param1:Sequence) : void
      {
         var _loc2_:Object = this._1456101433fadeIn_and_glow_unglow_blue;
         if(_loc2_ !== param1)
         {
            this._1456101433fadeIn_and_glow_unglow_blue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn_and_glow_unglow_blue",_loc2_,param1));
         }
      }
      
      private function updateGameModel() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = this["list" + _loc1_.toString() + "Data"];
            if(_loc2_ == null)
            {
               return;
            }
            this.chooseGameFlowViewController.updateGameModel(_loc2_);
            _loc1_++;
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseGameOptionsView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseGameOptionsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_ChooseGameOptionsViewWatcherSetupUtil");
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
      private function get list1Data() : GameOptionsList
      {
         return this._1267997283list1Data;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.chooseGameFlowViewController.registerStartupFunction(this.startup);
      }
      
      public function __create_game_btn_click(param1:MouseEvent) : void
      {
         this.launchSelectedGame(param1);
      }
      
      private function _ChooseGameOptionsView_Glow1_c() : Glow
      {
         var _loc1_:Glow = new Glow();
         _loc1_.duration = 650;
         _loc1_.alphaFrom = 0.1;
         _loc1_.alphaTo = 0.8;
         _loc1_.blurXFrom = 5;
         _loc1_.blurXTo = 10;
         _loc1_.blurYFrom = 5;
         _loc1_.blurYTo = 10;
         _loc1_.strength = 3;
         _loc1_.color = 26367;
         return _loc1_;
      }
      
      public function __join_game_btn_click(param1:MouseEvent) : void
      {
         this.launchSelectedGame(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get play_solo_btn() : SoundEffectButton
      {
         return this._677962841play_solo_btn;
      }
      
      public function __primaryListsListOptions0_itemRollOver(param1:ListEvent) : void
      {
         this.onitemRollOver();
      }
      
      private function updateGameQueueMessage(param1:XML) : void
      {
         if(param1.@message != null && param1.@message != "null")
         {
            this.gameFlowMessage.setVisible(true);
            this.gameFlowMessage.setContent(param1.@shortMessage ? param1.@shortMessage : param1.@message,param1.@messageTipHeader,param1.@messageTipBody);
         }
         else
         {
            this.gameFlowMessage.setVisible(false);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get glow_unglow_orange() : Sequence
      {
         return this._1027352139glow_unglow_orange;
      }
      
      [Bindable(event="propertyChange")]
      public function get primaryListsList1_title() : Label
      {
         return this._1801163193primaryListsList1_title;
      }
      
      public function set fadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      public function set queue_solo_btn_label(param1:TextArea) : void
      {
         var _loc2_:Object = this._1918254881queue_solo_btn_label;
         if(_loc2_ !== param1)
         {
            this._1918254881queue_solo_btn_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue_solo_btn_label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn_and_glow_unglow_blue() : Sequence
      {
         return this._1456101433fadeIn_and_glow_unglow_blue;
      }
      
      [Bindable(event="propertyChange")]
      public function get queue_solo_label() : Label
      {
         return this._2092567426queue_solo_label;
      }
      
      public function set create_game_btn_label(param1:TextArea) : void
      {
         var _loc2_:Object = this._1408376601create_game_btn_label;
         if(_loc2_ !== param1)
         {
            this._1408376601create_game_btn_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"create_game_btn_label",_loc2_,param1));
         }
      }
      
      public function set queue_launch_panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._1482812698queue_launch_panel;
         if(_loc2_ !== param1)
         {
            this._1482812698queue_launch_panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue_launch_panel",_loc2_,param1));
         }
      }
      
      public function set command_launch_panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._212288788command_launch_panel;
         if(_loc2_ !== param1)
         {
            this._212288788command_launch_panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"command_launch_panel",_loc2_,param1));
         }
      }
      
      private function _ChooseGameOptionsView_ClassFactory4_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChooseGameOptionsRepeatedRenderer;
         return _loc1_;
      }
      
      public function __cmnd_btn_click(param1:MouseEvent) : void
      {
         this.launchSelectedGame(param1);
      }
      
      private function _ChooseGameOptionsView_State4_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "tournamentCodeState";
         return _loc1_;
      }
      
      public function ___ChooseGameOptionsView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage(param1);
      }
      
      public function set mainList(param1:GameOptionsTopLevelList) : void
      {
         var _loc2_:Object = this._8673801mainList;
         if(_loc2_ !== param1)
         {
            this._8673801mainList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainList",_loc2_,param1));
         }
      }
      
      public function set join_game_btn_label(param1:TextArea) : void
      {
         var _loc2_:Object = this._503840007join_game_btn_label;
         if(_loc2_ !== param1)
         {
            this._503840007join_game_btn_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"join_game_btn_label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainList() : GameOptionsTopLevelList
      {
         return this._8673801mainList;
      }
      
      public function __createGameMessageHolder_creationComplete(param1:FlexEvent) : void
      {
         this.onMessageHolderReady();
      }
      
      public function set custom_command_launch_panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._1482585350custom_command_launch_panel;
         if(_loc2_ !== param1)
         {
            this._1482585350custom_command_launch_panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"custom_command_launch_panel",_loc2_,param1));
         }
      }
   }
}

