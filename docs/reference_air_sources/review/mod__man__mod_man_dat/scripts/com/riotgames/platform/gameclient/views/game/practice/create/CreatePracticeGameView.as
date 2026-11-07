package com.riotgames.platform.gameclient.views.game.practice.create
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.components.controls.TextInput;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.skin.image.SmoothImage;
   import com.riotgames.pvpnet.game.controllers.practice.CreatePracticeGameController;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.ComboBox;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.controls.TileList;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class CreatePracticeGameView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const BLUE_GLOW_OVERLAY:Class = CreatePracticeGameView_BLUE_GLOW_OVERLAY;
      
      private var isBusyWatcher:ChangeWatcher;
      
      private var _1822406191chooseMapLabel:Label;
      
      private var _1051062164quit_btn:SoundEffectButton;
      
      private var _1555279254passwordLock_img:SmoothImage;
      
      private var _795311618heading:GradientCanvas;
      
      private var _591501752gameRegion_cb:ComboBox;
      
      private var _79038122rowMapInformation:ConstraintRow;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"mapCanvas",
               "stylesFactory":function():void
               {
                  this.left = "columnMapInfo:10";
                  this.top = "10";
                  this.right = "10";
                  this.bottom = "rowMapInformation:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "styleName":"blueParchmentTablet",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"map_image",
                        "stylesFactory":function():void
                        {
                           this.top = "35";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "scaleContent":true,
                              "includeInLayout":true
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":GradientCanvas,
                        "id":"mapInfoHeading",
                        "stylesFactory":function():void
                        {
                           this.left = "-1";
                           this.right = "-1";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"blueHeaderBackground",
                              "height":36,
                              "y":-1,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_CreatePracticeGameView_Image2",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalCenter = "0";
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"mapInfoLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "10";
                                    this.verticalCenter = "0";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"blueThemeHeaderText"};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "stylesFactory":function():void
               {
                  this.left = "columnMapInfo:10";
                  this.right = "columnMapInfo:10";
                  this.top = "rowMapDescription:10";
                  this.bottom = "10";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "styleName":"blueParchmentTablet",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Text,
                        "id":"mapDescriptionText",
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "0";
                           this.verticalCenter = "0";
                           this.textAlign = "center";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"optionsText",
                              "percentWidth":85,
                              "selectable":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"mapChooseCanvas",
               "stylesFactory":function():void
               {
                  this.left = "10";
                  this.top = "10";
                  this.bottom = "10";
                  this.right = "columnChooseMap:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "styleName":"blueParchmentTablet",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "constraintRows":[_CreatePracticeGameView_ConstraintRow3_i(),_CreatePracticeGameView_ConstraintRow4_i()],
                     "constraintColumns":[_CreatePracticeGameView_ConstraintColumn3_i(),_CreatePracticeGameView_ConstraintColumn4_i()],
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":GradientCanvas,
                        "id":"heading",
                        "stylesFactory":function():void
                        {
                           this.left = "-1";
                           this.right = "-1";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"blueHeaderBackground",
                              "height":36,
                              "y":-1,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_CreatePracticeGameView_Image3",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalCenter = "0";
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"chooseMapLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "10";
                                    this.verticalCenter = "0";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"blueThemeHeaderText"};
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":TileList,
                        "id":"chooseMap_tl",
                        "events":{
                           "itemClick":"__chooseMap_tl_itemClick",
                           "change":"__chooseMap_tl_change"
                        },
                        "stylesFactory":function():void
                        {
                           this.horizontalCenter = "1";
                           this.backgroundAlpha = 0;
                           this.useRollOver = false;
                           this.verticalScrollBarStyleName = "blueGlassScrollBar";
                           this.borderStyle = "none";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":95,
                              "height":375,
                              "rowHeight":183,
                              "columnCount":2,
                              "selectable":false,
                              "tabEnabled":false,
                              "itemRenderer":_CreatePracticeGameView_ClassFactory1_c()
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":HRule,
                        "stylesFactory":function():void
                        {
                           this.left = "25";
                           this.right = "25";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"blackBeveled",
                              "y":427
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"gameOptionsHeader",
                        "stylesFactory":function():void
                        {
                           this.left = "35";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsSubHeader"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"teamSizeLabel",
                        "stylesFactory":function():void
                        {
                           this.right = "columnLabels:5";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":ComboBox,
                        "id":"teamSize_cb",
                        "events":{"change":"__teamSize_cb_change"},
                        "stylesFactory":function():void
                        {
                           this.left = "columnSelectors:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "height":25,
                              "styleName":"runeSelectionComboBox",
                              "width":75,
                              "tabIndex":3
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"allowSpectatorsLabel",
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":ComboBox,
                        "id":"allowSpectatorsComboBox",
                        "events":{"change":"__allowSpectatorsComboBox_change"},
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"runeSelectionComboBox",
                              "tabIndex":4
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"gametypeLabel",
                        "stylesFactory":function():void
                        {
                           this.right = "columnLabels:5";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":ComboBox,
                        "id":"gameType_cb",
                        "stylesFactory":function():void
                        {
                           this.left = "columnSelectors:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "height":25,
                              "styleName":"runeSelectionComboBox",
                              "selectedIndex":0,
                              "tabIndex":5
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"gameRegionLabel",
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":ComboBox,
                        "id":"gameRegion_cb",
                        "events":{"change":"__gameRegion_cb_change"},
                        "propertiesFactory":function():Object
                        {
                           return {
                              "height":25,
                              "styleName":"runeSelectionComboBox",
                              "selectedIndex":0,
                              "tabIndex":5
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"_CreatePracticeGameView_Label8",
                        "stylesFactory":function():void
                        {
                           this.right = "columnLabels:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"textEntry",
                        "stylesFactory":function():void
                        {
                           this.left = "columnSelectors:2";
                           this.right = "columnSelectors:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "height":40,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"name_txti",
                                 "events":{
                                    "change":"__name_txti_change",
                                    "focusOut":"__name_txti_focusOut",
                                    "keyDown":"__name_txti_keyDown"
                                 },
                                 "stylesFactory":function():void
                                 {
                                    this.fontFamily = "ApplicationFont2";
                                    this.left = "2";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":2,
                                       "styleName":"standard",
                                       "height":25,
                                       "maxChars":30,
                                       "tabIndex":1
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_CreatePracticeGameView_Image4",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "1";
                                    this.top = "1";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "height":27,
                                       "maintainAspectRatio":false,
                                       "mouseEnabled":false,
                                       "mouseChildren":false
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"_CreatePracticeGameView_Label9",
                        "stylesFactory":function():void
                        {
                           this.right = "columnLabels:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"_CreatePracticeGameView_Canvas6",
                        "stylesFactory":function():void
                        {
                           this.left = "columnSelectors:2";
                           this.right = "columnSelectors:2";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "height":40,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"password_txti",
                                 "events":{"change":"__password_txti_change"},
                                 "stylesFactory":function():void
                                 {
                                    this.fontFamily = "ApplicationFont2";
                                    this.left = "2";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":2,
                                       "styleName":"standard",
                                       "displayAsPassword":true,
                                       "height":25,
                                       "maxChars":30,
                                       "tabIndex":2
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_CreatePracticeGameView_Image5",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "1";
                                    this.top = "1";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "height":27,
                                       "maintainAspectRatio":false,
                                       "mouseEnabled":false,
                                       "mouseChildren":false
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":SmoothImage,
                                 "id":"passwordLock_img",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"source":_embed_mxml________ClientAssets_imageEmbeds_defaults_lock_png_1733147866};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"quit_btn",
               "events":{"click":"__quit_btn_click"},
               "stylesFactory":function():void
               {
                  this.bottom = "13";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"longButtonBlue",
                     "width":100,
                     "height":40,
                     "useHandCursor":true,
                     "buttonMode":true,
                     "x":15,
                     "tabIndex":7
                  };
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"createPracticeGame_btn",
               "events":{"click":"__createPracticeGame_btn_click"},
               "stylesFactory":function():void
               {
                  this.bottom = "13";
                  this.right = "columnChooseMap:5";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "useHandCursor":true,
                     "buttonMode":true,
                     "styleName":"longButtonBlue",
                     "width":150,
                     "height":40,
                     "tabIndex":6
                  };
               }
            })]};
         }
      });
      
      public var _CreatePracticeGameView_Label9:Label;
      
      private var _249515808rowMapList:ConstraintRow;
      
      private var teamSizes:ArrayCollection = new ArrayCollection();
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _437162452mapCanvas:Canvas;
      
      public var _CreatePracticeGameView_Image2:Image;
      
      public var _CreatePracticeGameView_Image4:Image;
      
      public var _CreatePracticeGameView_Image5:Image;
      
      public var _CreatePracticeGameView_Image3:Image;
      
      private var _1959492452rowOptions:ConstraintRow;
      
      private var _460383985columnChooseMap:ConstraintColumn;
      
      private var _1639311348columnMapInfo:ConstraintColumn;
      
      [Inject]
      private var _1576335205createPracticeGameController:CreatePracticeGameController;
      
      private var _572614720teamSize_cb:ComboBox;
      
      private var _680859002rowMapDescription:ConstraintRow;
      
      private var _1246117048map_image:Image;
      
      private var _1362340074mapInfoLabel:Label;
      
      private var _102302328mapInfoHeading:GradientCanvas;
      
      private var _410027573mapChooseCanvas:Canvas;
      
      private var _1106463438chooseMap_tl:TileList;
      
      private var _409662237password_txti:TextInput;
      
      private var _986630350gameType_cb:ComboBox;
      
      private var _1083520446columnSelectors:ConstraintColumn;
      
      private var _29063690allowSpectatorsComboBox:ComboBox;
      
      private var _1061746875textEntry:Canvas;
      
      private var _385987225allowSpectatorsLabel:Label;
      
      private var _1479897358gameRegionLabel:Label;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_defaults_lock_png_1733147866:Class = CreatePracticeGameView__embed_mxml________ClientAssets_imageEmbeds_defaults_lock_png_1733147866;
      
      private var _985565144gametypeLabel:Label;
      
      private var _1249548294createPracticeGame_btn:SoundEffectButton;
      
      mx_internal var _watchers:Array = [];
      
      private var _1233889581name_txti:TextInput;
      
      private var _241103283mapDescriptionText:Text;
      
      private var _501597177gameOptionsHeader:Label;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var creatingPracticeGameWaitAction:AlertWaitAction;
      
      private var _509328790teamSizeLabel:Label;
      
      mx_internal var _bindings:Array = [];
      
      private var _668875019columnLabels:ConstraintColumn;
      
      private var parameters:PracticeGameParameters;
      
      public var _CreatePracticeGameView_Canvas6:Canvas;
      
      public var _CreatePracticeGameView_Label8:Label;
      
      public function CreatePracticeGameView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentHeight = 100;
         this.percentWidth = 100;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.constraintColumns = [this._CreatePracticeGameView_ConstraintColumn1_i(),this._CreatePracticeGameView_ConstraintColumn2_i()];
         this.constraintRows = [this._CreatePracticeGameView_ConstraintRow1_i(),this._CreatePracticeGameView_ConstraintRow2_i()];
         this.addEventListener("hide",this.___CreatePracticeGameView_Canvas1_hide);
         this.addEventListener("show",this.___CreatePracticeGameView_Canvas1_show);
         this.addEventListener("keyUp",this.___CreatePracticeGameView_Canvas1_keyUp);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         CreatePracticeGameView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get heading() : GradientCanvas
      {
         return this._795311618heading;
      }
      
      [Bindable(event="propertyChange")]
      public function get createPracticeGame_btn() : SoundEffectButton
      {
         return this._1249548294createPracticeGame_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get allowSpectatorsComboBox() : ComboBox
      {
         return this._29063690allowSpectatorsComboBox;
      }
      
      private function onAvailableMapsChanged() : void
      {
         if(this.parameters != null)
         {
            this.parameters.updateMapEnablement();
            this.updateMaps();
         }
      }
      
      public function __name_txti_focusOut(param1:FocusEvent) : void
      {
         this.endEditGameName(param1);
      }
      
      public function set allowSpectatorsComboBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._29063690allowSpectatorsComboBox;
         if(_loc2_ !== param1)
         {
            this._29063690allowSpectatorsComboBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowSpectatorsComboBox",_loc2_,param1));
         }
      }
      
      public function set gameRegionLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1479897358gameRegionLabel;
         if(_loc2_ !== param1)
         {
            this._1479897358gameRegionLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameRegionLabel",_loc2_,param1));
         }
      }
      
      public function set columnChooseMap(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._460383985columnChooseMap;
         if(_loc2_ !== param1)
         {
            this._460383985columnChooseMap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnChooseMap",_loc2_,param1));
         }
      }
      
      public function set createPracticeGame_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1249548294createPracticeGame_btn;
         if(_loc2_ !== param1)
         {
            this._1249548294createPracticeGame_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createPracticeGame_btn",_loc2_,param1));
         }
      }
      
      public function set heading(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._795311618heading;
         if(_loc2_ !== param1)
         {
            this._795311618heading = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"heading",_loc2_,param1));
         }
      }
      
      private function onCanCreateChanged() : void
      {
         var _loc1_:Boolean = this.parameters.getPlayableMaps() != null && this.parameters.getPlayableMaps().length > 0;
         this.createPracticeGame_btn.enabled = Boolean(this.createPracticeGameController.canCreateGame()) && !this.createPracticeGameController.isBusy && _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get gametypeLabel() : Label
      {
         return this._985565144gametypeLabel;
      }
      
      private function _CreatePracticeGameView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.mapInfoLabel.x - 8;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createPracticeGame_mapInformation_heading","Map Info");
         _loc1_ = this.chooseMapLabel.x - 8;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = this.heading.y + this.heading.height + 10;
         _loc1_ = resourceManager.getString("resources","practiceGame_createPracticeGame_gameOptions_heading");
         _loc1_ = this.chooseMap_tl.y + this.chooseMap_tl.height + 15;
         _loc1_ = resourceManager.getString("resources","practiceGame_createPracticeGame_teamSizeLabel");
         _loc1_ = this.gameOptionsHeader.y + 32;
         _loc1_ = this.teamSizeLabel.y - 5;
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorsCheckbox","Allow Spectators");
         _loc1_ = this.teamSizeLabel.y;
         _loc1_ = this.teamSize_cb.x + this.teamSize_cb.width + 10;
         _loc1_ = ClientConfig.instance.observerModeEnabled;
         _loc1_ = this.teamSizeLabel.y - 5;
         _loc1_ = this.allowSpectatorsLabel.x + this.allowSpectatorsLabel.width + 5;
         _loc1_ = this.mapChooseCanvas.width * 0.2 + 5;
         _loc1_ = ClientConfig.instance.observerModeEnabled;
         _loc1_ = resourceManager.getString("resources","practiceGame_createPracticeGame_gameTypeLabel");
         _loc1_ = this.teamSize_cb.y + this.teamSize_cb.height + 15;
         _loc1_ = this.mapChooseCanvas.width * 0.35;
         _loc1_ = this.gametypeLabel.y - 5;
         _loc1_ = resourceManager.getString("resources","practiceGame_createPracticeGame_gameServerRegionLabel");
         _loc1_ = this.gameType_cb.y;
         _loc1_ = this.gameType_cb.x + this.gameType_cb.width + 10;
         _loc1_ = this.mapChooseCanvas.width * 0.2;
         _loc1_ = this.gametypeLabel.y - 5;
         _loc1_ = this.gameRegionLabel.x + this.gameRegionLabel.width + 5;
         _loc1_ = this.gameRegionLabel.visible;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameNameLabel");
         _loc1_ = this.gameType_cb.y + this.gameType_cb.height + 15;
         _loc1_ = this.gameType_cb.y + this.gameType_cb.height + 10;
         _loc1_ = this.mapChooseCanvas.width * 0.5;
         _loc1_ = !this.createPracticeGameController.isBusy;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = this.name_txti.width + 2;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_privateGamePasswordLabel");
         _loc1_ = this.textEntry.y + this.textEntry.height + 5;
         _loc1_ = this.textEntry.y + this.textEntry.height;
         _loc1_ = this.mapChooseCanvas.width * 0.5;
         _loc1_ = !this.createPracticeGameController.isBusy;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = this.name_txti.width + 2;
         _loc1_ = this.password_txti.y + this.password_txti.height * 0.5 - this.passwordLock_img.height * 0.5;
         _loc1_ = this.password_txti.x + this.password_txti.width + 10;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelCreateGameButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelCreateGameButton_tooltip");
         _loc1_ = !this.createPracticeGameController.isBusy;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_createGameButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_createGameButton_tooltip");
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseMapLabel() : Label
      {
         return this._1822406191chooseMapLabel;
      }
      
      private function _CreatePracticeGameView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChooseMapRenderer;
         return _loc1_;
      }
      
      private function _CreatePracticeGameView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.columnMapInfo = _loc1_;
         _loc1_.percentWidth = 45;
         _loc1_.initialized(this,"columnMapInfo");
         return _loc1_;
      }
      
      public function set password_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._409662237password_txti;
         if(_loc2_ !== param1)
         {
            this._409662237password_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"password_txti",_loc2_,param1));
         }
      }
      
      public function ___CreatePracticeGameView_Canvas1_show(param1:FlexEvent) : void
      {
         this.initializeView();
      }
      
      private function _CreatePracticeGameView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return mapInfoLabel.x - 8;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Image2.x = param1;
         },"_CreatePracticeGameView_Image2.x");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _CreatePracticeGameView_Image2.source = param1;
         },"_CreatePracticeGameView_Image2.source");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createPracticeGame_mapInformation_heading","Map Info");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapInfoLabel.text = param1;
         },"mapInfoLabel.text");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return chooseMapLabel.x - 8;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Image3.x = param1;
         },"_CreatePracticeGameView_Image3.x");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _CreatePracticeGameView_Image3.source = param1;
         },"_CreatePracticeGameView_Image3.source");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = heading.y + heading.height + 10;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            chooseMap_tl.setStyle("top",param1);
         },"chooseMap_tl.top");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createPracticeGame_gameOptions_heading");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameOptionsHeader.text = param1;
         },"gameOptionsHeader.text");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return chooseMap_tl.y + chooseMap_tl.height + 15;
         },function(param1:Number):void
         {
            gameOptionsHeader.y = param1;
         },"gameOptionsHeader.y");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createPracticeGame_teamSizeLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            teamSizeLabel.htmlText = param1;
         },"teamSizeLabel.htmlText");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return gameOptionsHeader.y + 32;
         },function(param1:Number):void
         {
            teamSizeLabel.y = param1;
         },"teamSizeLabel.y");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return teamSizeLabel.y - 5;
         },function(param1:Number):void
         {
            teamSize_cb.y = param1;
         },"teamSize_cb.y");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorsCheckbox","Allow Spectators");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            allowSpectatorsLabel.htmlText = param1;
         },"allowSpectatorsLabel.htmlText");
         result[11] = binding;
         binding = new Binding(this,function():Number
         {
            return teamSizeLabel.y;
         },function(param1:Number):void
         {
            allowSpectatorsLabel.y = param1;
         },"allowSpectatorsLabel.y");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return teamSize_cb.x + teamSize_cb.width + 10;
         },function(param1:Number):void
         {
            allowSpectatorsLabel.x = param1;
         },"allowSpectatorsLabel.x");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return ClientConfig.instance.observerModeEnabled;
         },function(param1:Boolean):void
         {
            allowSpectatorsLabel.visible = param1;
         },"allowSpectatorsLabel.visible");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return teamSizeLabel.y - 5;
         },function(param1:Number):void
         {
            allowSpectatorsComboBox.y = param1;
         },"allowSpectatorsComboBox.y");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return allowSpectatorsLabel.x + allowSpectatorsLabel.width + 5;
         },function(param1:Number):void
         {
            allowSpectatorsComboBox.x = param1;
         },"allowSpectatorsComboBox.x");
         result[16] = binding;
         binding = new Binding(this,function():Number
         {
            return mapChooseCanvas.width * 0.2 + 5;
         },function(param1:Number):void
         {
            allowSpectatorsComboBox.width = param1;
         },"allowSpectatorsComboBox.width");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return ClientConfig.instance.observerModeEnabled;
         },function(param1:Boolean):void
         {
            allowSpectatorsComboBox.visible = param1;
         },"allowSpectatorsComboBox.visible");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createPracticeGame_gameTypeLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gametypeLabel.htmlText = param1;
         },"gametypeLabel.htmlText");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return teamSize_cb.y + teamSize_cb.height + 15;
         },function(param1:Number):void
         {
            gametypeLabel.y = param1;
         },"gametypeLabel.y");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return mapChooseCanvas.width * 0.35;
         },function(param1:Number):void
         {
            gameType_cb.width = param1;
         },"gameType_cb.width");
         result[21] = binding;
         binding = new Binding(this,function():Number
         {
            return gametypeLabel.y - 5;
         },function(param1:Number):void
         {
            gameType_cb.y = param1;
         },"gameType_cb.y");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createPracticeGame_gameServerRegionLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            gameRegionLabel.htmlText = param1;
         },"gameRegionLabel.htmlText");
         result[23] = binding;
         binding = new Binding(this,function():Number
         {
            return gameType_cb.y;
         },function(param1:Number):void
         {
            gameRegionLabel.y = param1;
         },"gameRegionLabel.y");
         result[24] = binding;
         binding = new Binding(this,function():Number
         {
            return gameType_cb.x + gameType_cb.width + 10;
         },function(param1:Number):void
         {
            gameRegionLabel.x = param1;
         },"gameRegionLabel.x");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return mapChooseCanvas.width * 0.2;
         },function(param1:Number):void
         {
            gameRegion_cb.width = param1;
         },"gameRegion_cb.width");
         result[26] = binding;
         binding = new Binding(this,function():Number
         {
            return gametypeLabel.y - 5;
         },function(param1:Number):void
         {
            gameRegion_cb.y = param1;
         },"gameRegion_cb.y");
         result[27] = binding;
         binding = new Binding(this,function():Number
         {
            return gameRegionLabel.x + gameRegionLabel.width + 5;
         },function(param1:Number):void
         {
            gameRegion_cb.x = param1;
         },"gameRegion_cb.x");
         result[28] = binding;
         binding = new Binding(this,function():Boolean
         {
            return gameRegionLabel.visible;
         },function(param1:Boolean):void
         {
            gameRegion_cb.visible = param1;
         },"gameRegion_cb.visible");
         result[29] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_gameNameLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreatePracticeGameView_Label8.htmlText = param1;
         },"_CreatePracticeGameView_Label8.htmlText");
         result[30] = binding;
         binding = new Binding(this,function():Number
         {
            return gameType_cb.y + gameType_cb.height + 15;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Label8.y = param1;
         },"_CreatePracticeGameView_Label8.y");
         result[31] = binding;
         binding = new Binding(this,function():Number
         {
            return gameType_cb.y + gameType_cb.height + 10;
         },function(param1:Number):void
         {
            textEntry.y = param1;
         },"textEntry.y");
         result[32] = binding;
         binding = new Binding(this,function():Number
         {
            return mapChooseCanvas.width * 0.5;
         },function(param1:Number):void
         {
            name_txti.width = param1;
         },"name_txti.width");
         result[33] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.createPracticeGameController.isBusy;
         },function(param1:Boolean):void
         {
            name_txti.enabled = param1;
         },"name_txti.enabled");
         result[34] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _CreatePracticeGameView_Image4.source = param1;
         },"_CreatePracticeGameView_Image4.source");
         result[35] = binding;
         binding = new Binding(this,function():Number
         {
            return name_txti.width + 2;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Image4.width = param1;
         },"_CreatePracticeGameView_Image4.width");
         result[36] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_privateGamePasswordLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreatePracticeGameView_Label9.htmlText = param1;
         },"_CreatePracticeGameView_Label9.htmlText");
         result[37] = binding;
         binding = new Binding(this,function():Number
         {
            return textEntry.y + textEntry.height + 5;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Label9.y = param1;
         },"_CreatePracticeGameView_Label9.y");
         result[38] = binding;
         binding = new Binding(this,function():Number
         {
            return textEntry.y + textEntry.height;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Canvas6.y = param1;
         },"_CreatePracticeGameView_Canvas6.y");
         result[39] = binding;
         binding = new Binding(this,function():Number
         {
            return mapChooseCanvas.width * 0.5;
         },function(param1:Number):void
         {
            password_txti.width = param1;
         },"password_txti.width");
         result[40] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.createPracticeGameController.isBusy;
         },function(param1:Boolean):void
         {
            password_txti.enabled = param1;
         },"password_txti.enabled");
         result[41] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _CreatePracticeGameView_Image5.source = param1;
         },"_CreatePracticeGameView_Image5.source");
         result[42] = binding;
         binding = new Binding(this,function():Number
         {
            return name_txti.width + 2;
         },function(param1:Number):void
         {
            _CreatePracticeGameView_Image5.width = param1;
         },"_CreatePracticeGameView_Image5.width");
         result[43] = binding;
         binding = new Binding(this,function():Number
         {
            return password_txti.y + password_txti.height * 0.5 - passwordLock_img.height * 0.5;
         },function(param1:Number):void
         {
            passwordLock_img.y = param1;
         },"passwordLock_img.y");
         result[44] = binding;
         binding = new Binding(this,function():Number
         {
            return password_txti.x + password_txti.width + 10;
         },function(param1:Number):void
         {
            passwordLock_img.x = param1;
         },"passwordLock_img.x");
         result[45] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelCreateGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quit_btn.label = param1;
         },"quit_btn.label");
         result[46] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelCreateGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quit_btn.toolTip = param1;
         },"quit_btn.toolTip");
         result[47] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.createPracticeGameController.isBusy;
         },function(param1:Boolean):void
         {
            quit_btn.enabled = param1;
         },"quit_btn.enabled");
         result[48] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_createGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            createPracticeGame_btn.label = param1;
         },"createPracticeGame_btn.label");
         result[49] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_createGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            createPracticeGame_btn.toolTip = param1;
         },"createPracticeGame_btn.toolTip");
         result[50] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamSize_cb() : ComboBox
      {
         return this._572614720teamSize_cb;
      }
      
      private function endEditGameName(param1:FocusEvent) : void
      {
         this.name_txti.errorString = "";
         var _loc2_:String = StringUtil.trim(this.name_txti.text);
         if(_loc2_.length > 0 && _loc2_.length < 3)
         {
            this.name_txti.errorString = RiotResourceLoader.getString("validator_GameNameMustBe3Characters");
         }
      }
      
      private function onCreatePracticeGameButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:AlertAction = null;
         var _loc3_:Number = NaN;
         var _loc4_:GameTypeConfig = null;
         if(!ClientConfig.instance.practiceGamesEnabled)
         {
            _loc2_ = new AlertAction(RiotResourceLoader.getString("practiceGame_createPracticeGame_disabled_popupTitle"),RiotResourceLoader.getString("practiceGame_createPracticeGame_disabled_popupText"));
            _loc2_.add();
            return;
         }
         _loc3_ = -1;
         if(this.gameType_cb.selectedIndex >= 0 && this.gameType_cb.selectedIndex < this.parameters.practiceGameConfigs.length)
         {
            _loc4_ = this.parameters.practiceGameConfigs.getItemAt(this.gameType_cb.selectedIndex) as GameTypeConfig;
            if(_loc4_)
            {
               _loc3_ = Number(_loc4_.id);
            }
         }
         if(_loc3_ >= 0)
         {
            this.createPracticeGameController.setGameTypeIndex(_loc3_);
            this.createPracticeGameController.createGame();
         }
      }
      
      public function set gametypeLabel(param1:Label) : void
      {
         var _loc2_:Object = this._985565144gametypeLabel;
         if(_loc2_ !== param1)
         {
            this._985565144gametypeLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gametypeLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapDescriptionText() : Text
      {
         return this._241103283mapDescriptionText;
      }
      
      private function initializeView() : void
      {
         var _loc2_:Object = null;
         this.parameters = this.createPracticeGameController.practiceGameParameters;
         this.gameRegionLabel.visible = this.parameters.practiceGameRegionNamesAvailable;
         this.gameRegion_cb.dataProvider = this.parameters.practiceGameRegionNames;
         this.gameRegion_cb.selectedIndex = 0;
         this.createPracticeGameController.setRegion(this.parameters.practiceGameRegionNames[0]);
         this.gameType_cb.dataProvider = this.parameters.practiceGameTypeNames;
         this.gameType_cb.selectedIndex = 0;
         this.gametypeLabel.enabled = this.gameType_cb.enabled = this.parameters.practiceGameTypeNames.length > 1;
         this.createPracticeGameController.canCreateGameChanged.add(this.onCanCreateChanged);
         this.onCanCreateChanged();
         this.createPracticeGameController.game.gameMap = null;
         this.chooseMap_tl.itemRenderer = null;
         this.chooseMap_tl.itemRenderer = new ClassFactory(ChooseMapRenderer);
         AppConfig.instance.availableMapsChanged.add(this.onAvailableMapsChanged);
         this.updateMaps();
         this.allowSpectatorsComboBox.dataProvider = this.parameters.allowSpectatorTypes;
         var _loc1_:int = 0;
         while(_loc1_ < this.parameters.allowSpectatorTypes.length)
         {
            _loc2_ = this.parameters.allowSpectatorTypes[_loc1_];
            if(_loc2_.data == this.createPracticeGameController.game.allowSpectators)
            {
               this.allowSpectatorsComboBox.selectedIndex = _loc1_;
            }
            _loc1_++;
         }
         this.onAllowSpectatorChange();
         this.createPracticeGameController.mapChanged.add(this.updateTeamSizes);
         ClientConfig.instance.getMinNumPlayersForPracticeGameChanged().add(this.updateTeamSizes);
         this.updateTeamSizes();
         this.teamSize_cb.dataProvider = this.teamSizes;
         this.isBusyWatcher = ChangeWatcher.watch(this.createPracticeGameController,"isBusy",this.onIsBusyChanged);
         this.createPracticeGameController.mapChanged.add(this.updateGameDescription);
         this.chooseMap(this.createPracticeGameController.game.gameMap);
         this.chooseMapLabel.text = this.parameters.getGameTitle();
         this.name_txti.text = RiotResourceLoader.getString("practiceGame_defaultGameName",null,[Session.instance.summoner.name]);
         this.name_txti.selectionBeginIndex = 0;
         this.name_txti.selectionEndIndex = this.name_txti.text.length;
         this.onGameNameChanged();
         this.name_txti.setFocus();
      }
      
      public function set name_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._1233889581name_txti;
         if(_loc2_ !== param1)
         {
            this._1233889581name_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name_txti",_loc2_,param1));
         }
      }
      
      public function set chooseMapLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1822406191chooseMapLabel;
         if(_loc2_ !== param1)
         {
            this._1822406191chooseMapLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseMapLabel",_loc2_,param1));
         }
      }
      
      public function set chooseMap_tl(param1:TileList) : void
      {
         var _loc2_:Object = this._1106463438chooseMap_tl;
         if(_loc2_ !== param1)
         {
            this._1106463438chooseMap_tl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseMap_tl",_loc2_,param1));
         }
      }
      
      private function onQuitButtonClicked(param1:MouseEvent) : void
      {
         this.createPracticeGameController.cancelGame();
      }
      
      public function __teamSize_cb_change(param1:ListEvent) : void
      {
         this.handleTeamSizeClick();
      }
      
      private function _CreatePracticeGameView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.columnChooseMap = _loc1_;
         _loc1_.percentWidth = 55;
         _loc1_.initialized(this,"columnChooseMap");
         return _loc1_;
      }
      
      private function onGameNameChanged() : void
      {
         this.createPracticeGameController.setGameName(this.name_txti.text);
         var _loc1_:String = StringUtil.trim(this.name_txti.text);
         if(_loc1_.length < 3 && _loc1_.length > 0)
         {
            this.name_txti.errorString = RiotResourceLoader.getString("validator_GameNameMustBe3Characters");
            return;
         }
         this.name_txti.errorString = "";
         if(!this.createPracticeGameController.canCreateGame())
         {
            if(this.createPracticeGameController.game.gameMap == null)
            {
               this.chooseMap(this.chooseMap_tl.selectedItem as GameMap);
            }
            else
            {
               this.chooseMap(this.createPracticeGameController.game.gameMap);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get passwordLock_img() : SmoothImage
      {
         return this._1555279254passwordLock_img;
      }
      
      public function ___CreatePracticeGameView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.reset();
      }
      
      [Bindable(event="propertyChange")]
      public function get quit_btn() : SoundEffectButton
      {
         return this._1051062164quit_btn;
      }
      
      public function set gameType_cb(param1:ComboBox) : void
      {
         var _loc2_:Object = this._986630350gameType_cb;
         if(_loc2_ !== param1)
         {
            this._986630350gameType_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType_cb",_loc2_,param1));
         }
      }
      
      public function set teamSize_cb(param1:ComboBox) : void
      {
         var _loc2_:Object = this._572614720teamSize_cb;
         if(_loc2_ !== param1)
         {
            this._572614720teamSize_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSize_cb",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoHeading() : GradientCanvas
      {
         return this._102302328mapInfoHeading;
      }
      
      public function set textEntry(param1:Canvas) : void
      {
         var _loc2_:Object = this._1061746875textEntry;
         if(_loc2_ !== param1)
         {
            this._1061746875textEntry = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textEntry",_loc2_,param1));
         }
      }
      
      public function set mapDescriptionText(param1:Text) : void
      {
         var _loc2_:Object = this._241103283mapDescriptionText;
         if(_loc2_ !== param1)
         {
            this._241103283mapDescriptionText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapDescriptionText",_loc2_,param1));
         }
      }
      
      private function updateGameDescription() : void
      {
         if(this.parameters != null)
         {
            this.mapDescriptionText.htmlText = this.parameters.getGameDescription(this.createPracticeGameController.game.gameMap);
         }
      }
      
      private function chooseMapClicked(param1:ListEvent) : void
      {
         var _loc2_:ChooseMapRenderer = param1.itemRenderer as ChooseMapRenderer;
         if(_loc2_ != null)
         {
            this.chooseMap(_loc2_.data as GameMap);
         }
      }
      
      public function __name_txti_keyDown(param1:KeyboardEvent) : void
      {
         this.onEditGameNameKeyDown(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get rowMapInformation() : ConstraintRow
      {
         return this._79038122rowMapInformation;
      }
      
      [Bindable(event="propertyChange")]
      public function get map_image() : Image
      {
         return this._1246117048map_image;
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && Boolean(this.createPracticeGameController.canCreateGame()))
         {
            this.createPracticeGame_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.quit_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function set rowOptions(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1959492452rowOptions;
         if(_loc2_ !== param1)
         {
            this._1959492452rowOptions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowOptions",_loc2_,param1));
         }
      }
      
      public function set createPracticeGameController(param1:CreatePracticeGameController) : void
      {
         var _loc2_:Object = this._1576335205createPracticeGameController;
         if(_loc2_ !== param1)
         {
            this._1576335205createPracticeGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createPracticeGameController",_loc2_,param1));
         }
      }
      
      public function set allowSpectatorsLabel(param1:Label) : void
      {
         var _loc2_:Object = this._385987225allowSpectatorsLabel;
         if(_loc2_ !== param1)
         {
            this._385987225allowSpectatorsLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowSpectatorsLabel",_loc2_,param1));
         }
      }
      
      public function set passwordLock_img(param1:SmoothImage) : void
      {
         var _loc2_:Object = this._1555279254passwordLock_img;
         if(_loc2_ !== param1)
         {
            this._1555279254passwordLock_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"passwordLock_img",_loc2_,param1));
         }
      }
      
      private function onGameRegionChange() : void
      {
         if(this.createPracticeGameController != null)
         {
            this.createPracticeGameController.setRegion(this.gameRegion_cb.selectedItem as String);
         }
      }
      
      public function set quit_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1051062164quit_btn;
         if(_loc2_ !== param1)
         {
            this._1051062164quit_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quit_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowMapList() : ConstraintRow
      {
         return this._249515808rowMapList;
      }
      
      private function handleTeamSizeClick() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = this.teamSize_cb.selectedIndex >= 0 ? int(this.teamSize_cb.selectedIndex) : 0;
         if(this.teamSizes.length > _loc1_)
         {
            _loc2_ = this.teamSizes.getItemAt(_loc1_) as int;
            this.createPracticeGameController.setNumberOfPlayers(_loc2_ * 2);
         }
      }
      
      public function __name_txti_change(param1:Event) : void
      {
         this.onGameNameChanged();
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoLabel() : Label
      {
         return this._1362340074mapInfoLabel;
      }
      
      private function onGamePasswordChanged() : void
      {
         this.createPracticeGameController.setGamePassword(this.password_txti.text);
      }
      
      public function __password_txti_change(param1:Event) : void
      {
         this.onGamePasswordChanged();
      }
      
      private function _CreatePracticeGameView_ConstraintRow4_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowOptions = _loc1_;
         _loc1_.percentHeight = 60;
         _loc1_.initialized(this,"rowOptions");
         return _loc1_;
      }
      
      public function set rowMapDescription(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._680859002rowMapDescription;
         if(_loc2_ !== param1)
         {
            this._680859002rowMapDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowMapDescription",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnLabels() : ConstraintColumn
      {
         return this._668875019columnLabels;
      }
      
      public function set mapInfoHeading(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._102302328mapInfoHeading;
         if(_loc2_ !== param1)
         {
            this._102302328mapInfoHeading = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoHeading",_loc2_,param1));
         }
      }
      
      private function updateMaps() : void
      {
         var _loc1_:ArrayCollection = null;
         var _loc2_:Boolean = false;
         var _loc3_:GameMap = null;
         var _loc4_:GameMap = null;
         if(this.createPracticeGameController != null && this.parameters != null)
         {
            _loc1_ = this.parameters.getPlayableMaps();
            this.chooseMap_tl.dataProvider = _loc1_;
            _loc2_ = false;
            _loc3_ = this.createPracticeGameController.game.gameMap;
            if(_loc3_ != null)
            {
               for each(_loc4_ in _loc1_)
               {
                  if(_loc3_.mapId == _loc4_.mapId)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
            }
            if(!_loc2_)
            {
               if(_loc1_ != null && _loc1_.length > 0)
               {
                  _loc3_ = _loc1_[0];
               }
               else
               {
                  _loc3_ = null;
               }
            }
            this.chooseMap(_loc3_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameRegionLabel() : Label
      {
         return this._1479897358gameRegionLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get columnChooseMap() : ConstraintColumn
      {
         return this._460383985columnChooseMap;
      }
      
      [Bindable(event="propertyChange")]
      public function get password_txti() : TextInput
      {
         return this._409662237password_txti;
      }
      
      public function ___CreatePracticeGameView_Canvas1_keyUp(param1:KeyboardEvent) : void
      {
         this.onKeyUp(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name_txti() : TextInput
      {
         return this._1233889581name_txti;
      }
      
      public function set teamSizeLabel(param1:Label) : void
      {
         var _loc2_:Object = this._509328790teamSizeLabel;
         if(_loc2_ !== param1)
         {
            this._509328790teamSizeLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSizeLabel",_loc2_,param1));
         }
      }
      
      private function _CreatePracticeGameView_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowMapList = _loc1_;
         _loc1_.percentHeight = 40;
         _loc1_.initialized(this,"rowMapList");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseMap_tl() : TileList
      {
         return this._1106463438chooseMap_tl;
      }
      
      private function onRemove() : void
      {
         if(this.isBusyWatcher != null)
         {
            if(this.creatingPracticeGameWaitAction)
            {
               this.creatingPracticeGameWaitAction.complete();
            }
            this.isBusyWatcher.unwatch();
            this.isBusyWatcher = null;
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textEntry() : Canvas
      {
         return this._1061746875textEntry;
      }
      
      public function __chooseMap_tl_itemClick(param1:ListEvent) : void
      {
         this.chooseMapClicked(param1);
      }
      
      private function onIsBusyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:IResourceManager = null;
         if(param1.newValue)
         {
            CursorManager.getInstance().setBusyCursor();
            _loc2_ = ResourceManager.getInstance();
            this.creatingPracticeGameWaitAction = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
            this.creatingPracticeGameWaitAction.add();
         }
         else
         {
            if(this.creatingPracticeGameWaitAction)
            {
               this.creatingPracticeGameWaitAction.complete();
            }
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType_cb() : ComboBox
      {
         return this._986630350gameType_cb;
      }
      
      private function reset() : void
      {
         this.map_image.source = null;
         this.name_txti.htmlText = "";
         this.name_txti.errorString = "";
         this.password_txti.htmlText = "";
         this.teamSize_cb.selectedIndex = 0;
         this.gameType_cb.selectedIndex = 0;
         if(this.createPracticeGameController != null)
         {
            this.createPracticeGameController.setGameName("");
         }
         if(AppConfig.instance.availableMaps != null && AppConfig.instance.availableMaps.length > 0)
         {
            this.chooseMap(AppConfig.instance.availableMaps.getItemAt(0) as GameMap);
         }
         this.onRemove();
      }
      
      public function set rowMapInformation(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._79038122rowMapInformation;
         if(_loc2_ !== param1)
         {
            this._79038122rowMapInformation = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowMapInformation",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowOptions() : ConstraintRow
      {
         return this._1959492452rowOptions;
      }
      
      public function __allowSpectatorsComboBox_change(param1:ListEvent) : void
      {
         this.onAllowSpectatorChange();
      }
      
      [Bindable(event="propertyChange")]
      public function get allowSpectatorsLabel() : Label
      {
         return this._385987225allowSpectatorsLabel;
      }
      
      public function set gameRegion_cb(param1:ComboBox) : void
      {
         var _loc2_:Object = this._591501752gameRegion_cb;
         if(_loc2_ !== param1)
         {
            this._591501752gameRegion_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameRegion_cb",_loc2_,param1));
         }
      }
      
      private function _CreatePracticeGameView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowMapDescription = _loc1_;
         _loc1_.percentHeight = 36;
         _loc1_.initialized(this,"rowMapDescription");
         return _loc1_;
      }
      
      private function onAllowSpectatorChange() : void
      {
         this.createPracticeGameController.setAllowSpectators(this.allowSpectatorsComboBox.selectedItem.data);
      }
      
      public function set map_image(param1:Image) : void
      {
         var _loc2_:Object = this._1246117048map_image;
         if(_loc2_ !== param1)
         {
            this._1246117048map_image = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map_image",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowMapDescription() : ConstraintRow
      {
         return this._680859002rowMapDescription;
      }
      
      private function onEditGameNameKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.endEditGameName(null);
         }
      }
      
      public function set columnSelectors(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1083520446columnSelectors;
         if(_loc2_ !== param1)
         {
            this._1083520446columnSelectors = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnSelectors",_loc2_,param1));
         }
      }
      
      public function __chooseMap_tl_change(param1:ListEvent) : void
      {
         this.chooseMap(this.chooseMap_tl.selectedItem.data);
      }
      
      private function updateTeamSizes() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.createPracticeGameController != null && this.parameters != null)
         {
            _loc1_ = [];
            _loc2_ = int(this.parameters.getMaxTeamSize(this.createPracticeGameController.game.gameMap,ClientConfig.instance.maxPracticeGameSize));
            _loc3_ = 1;
            while(_loc3_ <= _loc2_)
            {
               if(_loc3_ * 2 >= ClientConfig.instance.minNumPlayersForPracticeGame)
               {
                  _loc1_.push(_loc3_);
               }
               _loc3_++;
            }
            this.teamSizes.source = _loc1_;
            if(this.teamSizes.length > 0)
            {
               this.teamSize_cb.selectedIndex = this.teamSizes.length - 1;
            }
            this.createPracticeGameController.setNumberOfPlayers(_loc2_ * 2);
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get createPracticeGameController() : CreatePracticeGameController
      {
         return this._1576335205createPracticeGameController;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:CreatePracticeGameView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._CreatePracticeGameView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_create_CreatePracticeGameViewWatcherSetupUtil");
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
      
      public function set mapChooseCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._410027573mapChooseCanvas;
         if(_loc2_ !== param1)
         {
            this._410027573mapChooseCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapChooseCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamSizeLabel() : Label
      {
         return this._509328790teamSizeLabel;
      }
      
      public function set mapCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._437162452mapCanvas;
         if(_loc2_ !== param1)
         {
            this._437162452mapCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapCanvas",_loc2_,param1));
         }
      }
      
      private function _CreatePracticeGameView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowMapInformation = _loc1_;
         _loc1_.percentHeight = 64;
         _loc1_.initialized(this,"rowMapInformation");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameRegion_cb() : ComboBox
      {
         return this._591501752gameRegion_cb;
      }
      
      private function _CreatePracticeGameView_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.columnSelectors = _loc1_;
         _loc1_.percentWidth = 70;
         _loc1_.initialized(this,"columnSelectors");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get columnSelectors() : ConstraintColumn
      {
         return this._1083520446columnSelectors;
      }
      
      public function set rowMapList(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._249515808rowMapList;
         if(_loc2_ !== param1)
         {
            this._249515808rowMapList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowMapList",_loc2_,param1));
         }
      }
      
      private function chooseMap(param1:GameMap) : void
      {
         if(param1)
         {
            this.createPracticeGameController.setGameMap(param1);
            this.map_image.source = ImagePackLookup.instance.getMinimapSource(param1);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapChooseCanvas() : Canvas
      {
         return this._410027573mapChooseCanvas;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapCanvas() : Canvas
      {
         return this._437162452mapCanvas;
      }
      
      public function __quit_btn_click(param1:MouseEvent) : void
      {
         this.onQuitButtonClicked(param1);
      }
      
      public function set mapInfoLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1362340074mapInfoLabel;
         if(_loc2_ !== param1)
         {
            this._1362340074mapInfoLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoLabel",_loc2_,param1));
         }
      }
      
      public function set columnMapInfo(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1639311348columnMapInfo;
         if(_loc2_ !== param1)
         {
            this._1639311348columnMapInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnMapInfo",_loc2_,param1));
         }
      }
      
      public function set columnLabels(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._668875019columnLabels;
         if(_loc2_ !== param1)
         {
            this._668875019columnLabels = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnLabels",_loc2_,param1));
         }
      }
      
      public function __createPracticeGame_btn_click(param1:MouseEvent) : void
      {
         this.onCreatePracticeGameButtonClicked(param1);
      }
      
      public function set gameOptionsHeader(param1:Label) : void
      {
         var _loc2_:Object = this._501597177gameOptionsHeader;
         if(_loc2_ !== param1)
         {
            this._501597177gameOptionsHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameOptionsHeader",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnMapInfo() : ConstraintColumn
      {
         return this._1639311348columnMapInfo;
      }
      
      public function __gameRegion_cb_change(param1:ListEvent) : void
      {
         this.onGameRegionChange();
      }
      
      private function _CreatePracticeGameView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.columnLabels = _loc1_;
         _loc1_.percentWidth = 30;
         _loc1_.initialized(this,"columnLabels");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameOptionsHeader() : Label
      {
         return this._501597177gameOptionsHeader;
      }
   }
}

