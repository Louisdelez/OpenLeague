package com.riotgames.platform.gameclient.controllers.game.views
{
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.championselection.GameEvent;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.controllers.AdvancedToolTipManager;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.PlayerProfileTooltip;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Menu;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.styles.*;
   
   public class SpectatorChampionSelectionView extends Canvas implements IChampionSelectionView, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const SUNSET_BG:Class = SpectatorChampionSelectionView_SUNSET_BG;
      
      protected static const DETAILS_DELAY:int = 400;
      
      private var _1566114207quitButton:Button;
      
      private var _1805069635bkgImage:Image;
      
      private var _462115240friendlyTeam:ChampionSelectPlayerList;
      
      private var _1737442282blueTeamSummonerImage:Image;
      
      private var _embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerPurple_png_1289890477:Class;
      
      private var _1115259087header_c:GradientCanvas;
      
      private var _1386038354rowChat:ConstraintRow;
      
      private var _2029103300messageCenter:ChampionSelectMessageCenter;
      
      private var _999696181colMiddle:ConstraintColumn;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _12089446header_c_label:Label;
      
      private var _894196291charactersPage_c:ChampionGrid;
      
      private var _glowComponentController:GlowComponentController;
      
      private var _1849727379teamTwoBans:BannedChampionsView;
      
      private var _embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerBlue_png_1420628713:Class;
      
      private var _1050181115enemyTeam:ChampionSelectPlayerList;
      
      private var _1399514947matchDetails:MatchDetailsView;
      
      private var _1440278701teamOneBans:BannedChampionsView;
      
      private var _134469313rowContent:ConstraintRow;
      
      private var championDetails:ParticipantChampionSelection;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var logger:ILogger;
      
      private var _655867780colRight:ConstraintColumn;
      
      private var _1131509414progressBar:ChampionSelectProgressBar;
      
      private var _434478175championSummary_c:ChampionSummaryView;
      
      private var _2120455012matchMapView:MapView;
      
      private var _942482833spectatorWaitBar:SpectatorWaitBar;
      
      protected var rollOverTimer:Timer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _1235528460purpleTeamSummonerImage:Image;
      
      private var playerTooltip:Menu;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _398731868browseButton:Button;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function SpectatorChampionSelectionView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"bkgImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":0,
                        "y":0,
                        "alpha":0.333
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectMessageCenter,
                  "id":"messageCenter",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":790,
                        "x":240,
                        "y":31,
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SpectatorWaitBar,
                  "id":"spectatorWaitBar",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":790,
                        "x":240,
                        "y":31,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.bottom = "rowContent:10";
                     this.left = "colMiddle:0";
                     this.right = "colMiddle:0";
                     this.top = "rowContent:90";
                     this.cornerRadius = 2;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "cacheAsBitmap":true,
                        "styleName":"blueParchmentTablet",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":GradientCanvas,
                           "id":"header_c",
                           "stylesFactory":function():void
                           {
                              this.borderStyle = "none";
                              this.left = "0";
                              this.top = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "height":25,
                                 "percentWidth":100,
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "styleName":"blueHeaderBackground",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"header_c_label",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "10";
                                       this.verticalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"spectatorPanelHeaderText"};
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":ChampionGrid,
                           "id":"charactersPage_c",
                           "stylesFactory":function():void
                           {
                              this.top = "30";
                              this.bottom = "0";
                              this.left = "0";
                              this.right = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "cacheAsBitmap":true,
                                 "interactiveRenderers":false
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectProgressBar,
                  "id":"progressBar",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "colMiddle:0";
                     this.top = "3";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "mouseChildren":false,
                        "mouseEnabled":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSummaryView,
                  "id":"championSummary_c",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 1;
                     this.borderStyle = "none";
                     this.bottom = "0";
                     this.left = "0";
                     this.right = "0";
                     this.top = "rowChat:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"stoneTablet",
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectPlayerList,
                  "id":"friendlyTeam",
                  "stylesFactory":function():void
                  {
                     this.left = "colLeft:9";
                     this.top = "rowContent:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"isSpectating":true};
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectPlayerList,
                  "id":"enemyTeam",
                  "stylesFactory":function():void
                  {
                     this.right = "colRight:5";
                     this.top = "rowContent:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"isSpectating":true};
                  }
               }),new UIComponentDescriptor({
                  "type":BannedChampionsView,
                  "id":"teamOneBans",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.left = "colLeft:12";
                     this.top = "rowChat:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"width":249};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"blueTeamSummonerImage",
                  "stylesFactory":function():void
                  {
                     this.left = "colLeft:0";
                     this.top = "rowChat:-10";
                     this.bottom = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"source":_embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerBlue_png_1420628713};
                  }
               }),new UIComponentDescriptor({
                  "type":MatchDetailsView,
                  "id":"matchDetails",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.left = "colMiddle:0";
                     this.right = "colMiddle:0";
                     this.top = "rowChat:0";
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0;
                     this.bottom = "3";
                     this.left = "colMiddle:0";
                     this.right = "colMiddle:0";
                     this.top = "rowChat:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Button,
                           "id":"quitButton",
                           "events":{"click":"__quitButton_click"},
                           "stylesFactory":function():void
                           {
                              this.bottom = "0";
                              this.left = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":170,
                                 "height":39,
                                 "styleName":"largeButtonBlue",
                                 "buttonMode":true,
                                 "useHandCursor":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Button,
                           "id":"browseButton",
                           "events":{"click":"__browseButton_click"},
                           "stylesFactory":function():void
                           {
                              this.bottom = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":170,
                                 "height":39,
                                 "styleName":"largeButtonBlue",
                                 "buttonMode":true,
                                 "useHandCursor":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":MapView,
                           "id":"matchMapView",
                           "stylesFactory":function():void
                           {
                              this.top = "30";
                              this.bottom = "7";
                              this.right = "7";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"width":279};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":BannedChampionsView,
                  "id":"teamTwoBans",
                  "stylesFactory":function():void
                  {
                     this.bottom = "3";
                     this.right = "colRight:12";
                     this.top = "rowChat:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"width":249};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"purpleTeamSummonerImage",
                  "stylesFactory":function():void
                  {
                     this.right = "colRight:-30";
                     this.top = "rowChat:0";
                     this.bottom = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"source":_embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerPurple_png_1289890477};
                  }
               })]};
            }
         });
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         this._embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerBlue_png_1420628713 = SpectatorChampionSelectionView__embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerBlue_png_1420628713;
         this._embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerPurple_png_1289890477 = SpectatorChampionSelectionView__embed_mxml___________ClientAssets_imageEmbeds_championSelect_spectatorCS_blindPick_summonerPurple_png_1289890477;
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
            this.backgroundAlpha = 1;
            this.backgroundColor = 0;
            this.left = "0";
            this.right = "0";
            this.bottom = "0";
            this.top = "0";
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.constraintRows = [this._SpectatorChampionSelectionView_ConstraintRow1_i(),this._SpectatorChampionSelectionView_ConstraintRow2_i()];
         this.constraintColumns = [this._SpectatorChampionSelectionView_ConstraintColumn1_i(),this._SpectatorChampionSelectionView_ConstraintColumn2_i(),this._SpectatorChampionSelectionView_ConstraintColumn3_i()];
         this.addEventListener("creationComplete",this.___SpectatorChampionSelectionView_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpectatorChampionSelectionView._watcherSetupUtil = param1;
      }
      
      public function set spectatorWaitBar(param1:SpectatorWaitBar) : void
      {
         var _loc2_:Object = this._942482833spectatorWaitBar;
         if(_loc2_ !== param1)
         {
            this._942482833spectatorWaitBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorWaitBar",_loc2_,param1));
         }
      }
      
      private function _SpectatorChampionSelectionView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.width = 270;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      protected function hideChampionOverlay() : void
      {
         if(AdvancedToolTipManager.toolTipOpen)
         {
            AdvancedToolTipManager.destroyCurrentToolTip();
         }
      }
      
      public function __quitButton_click(param1:MouseEvent) : void
      {
         this.onQuitClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyTeam() : ChampionSelectPlayerList
      {
         return this._1050181115enemyTeam;
      }
      
      private function onRollOverSummonerName(param1:MouseEvent) : void
      {
         this.showPlayerTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get charactersPage_c() : ChampionGrid
      {
         return this._894196291charactersPage_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get blueTeamSummonerImage() : Image
      {
         return this._1737442282blueTeamSummonerImage;
      }
      
      private function onRollOverActionButton(param1:MouseEvent) : void
      {
      }
      
      public function set enemyTeam(param1:ChampionSelectPlayerList) : void
      {
         var _loc2_:Object = this._1050181115enemyTeam;
         if(_loc2_ !== param1)
         {
            this._1050181115enemyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchDetails() : MatchDetailsView
      {
         return this._1399514947matchDetails;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c() : GradientCanvas
      {
         return this._1115259087header_c;
      }
      
      protected function updateGameType() : void
      {
         if(this.championSelectionModel.gameTypeConfig)
         {
            if(this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_DRAFT_MODE_SINGLE_PICK || this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_TOURNAMENT || this.championSelectionModel.gameTypeConfig.maxAllowableBans > 0)
            {
               if(this.teamOneBans)
               {
                  this.teamOneBans.visible = true;
               }
               if(this.teamTwoBans)
               {
                  this.teamTwoBans.visible = true;
               }
               if(this.purpleTeamSummonerImage)
               {
                  this.purpleTeamSummonerImage.visible = false;
               }
               if(this.blueTeamSummonerImage)
               {
                  this.blueTeamSummonerImage.visible = false;
               }
            }
            else
            {
               if(this.teamOneBans)
               {
                  this.teamOneBans.visible = false;
               }
               if(this.teamTwoBans)
               {
                  this.teamTwoBans.visible = false;
               }
               if(this.purpleTeamSummonerImage)
               {
                  this.purpleTeamSummonerImage.visible = true;
               }
               if(this.blueTeamSummonerImage)
               {
                  this.blueTeamSummonerImage.visible = true;
               }
            }
         }
      }
      
      private function onCreationComplete() : void
      {
         this.updateGameType();
         this.updateMap();
         this.updateDetails();
         this.updateBans();
         this.updateExtendedLayout();
         this.bkgImage.source = SUNSET_BG;
         this.charactersPage_c.addEventListener(ItemSelectEvent.ROLL_OVER,this.onRollOverChampion);
         this.charactersPage_c.addEventListener(ItemSelectEvent.ROLL_OUT,this.onRollOutChampion);
      }
      
      public function set matchMapView(param1:MapView) : void
      {
         var _loc2_:Object = this._2120455012matchMapView;
         if(_loc2_ !== param1)
         {
            this._2120455012matchMapView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchMapView",_loc2_,param1));
         }
      }
      
      private function onMainMenuStateChanged(param1:Event) : void
      {
         this.updateChampionGridState();
      }
      
      private function onRollOutChampion(param1:ItemSelectEvent) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.championSummary_c.visible = false;
         this.championSummary_c.champion = null;
         this.hideChampionOverlay();
      }
      
      [Bindable(event="propertyChange")]
      public function get colMiddle() : ConstraintColumn
      {
         return this._999696181colMiddle;
      }
      
      public function set teamTwoBans(param1:BannedChampionsView) : void
      {
         var _loc2_:Object = this._1849727379teamTwoBans;
         if(_loc2_ !== param1)
         {
            this._1849727379teamTwoBans = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamTwoBans",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowContent() : ConstraintRow
      {
         return this._134469313rowContent;
      }
      
      private function onCurrentParticipantChanged(param1:Event) : void
      {
         this.updateChampionGridState();
      }
      
      [Bindable(event="propertyChange")]
      public function get messageCenter() : ChampionSelectMessageCenter
      {
         return this._2029103300messageCenter;
      }
      
      public function ___SpectatorChampionSelectionView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _SpectatorChampionSelectionView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowChat = _loc1_;
         _loc1_.height = 130;
         _loc1_.initialized(this,"rowChat");
         return _loc1_;
      }
      
      protected function updateDetails() : void
      {
         if(Boolean(this.matchDetails) && Boolean(this.championSelectionModel))
         {
            this.matchDetails.setGameProperties(this.championSelectionModel.currentGame,this.championSelectionModel.gameMap,this.championSelectionModel.gameTypeConfig);
         }
      }
      
      private function _SpectatorChampionSelectionView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colMiddle = _loc1_;
         _loc1_.width = 724;
         _loc1_.initialized(this,"colMiddle");
         return _loc1_;
      }
      
      public function set progressBar(param1:ChampionSelectProgressBar) : void
      {
         var _loc2_:Object = this._1131509414progressBar;
         if(_loc2_ !== param1)
         {
            this._1131509414progressBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
         }
      }
      
      public function set blueTeamSummonerImage(param1:Image) : void
      {
         var _loc2_:Object = this._1737442282blueTeamSummonerImage;
         if(_loc2_ !== param1)
         {
            this._1737442282blueTeamSummonerImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueTeamSummonerImage",_loc2_,param1));
         }
      }
      
      public function set friendlyTeam(param1:ChampionSelectPlayerList) : void
      {
         var _loc2_:Object = this._462115240friendlyTeam;
         if(_loc2_ !== param1)
         {
            this._462115240friendlyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyTeam",_loc2_,param1));
         }
      }
      
      public function set championSummary_c(param1:ChampionSummaryView) : void
      {
         var _loc2_:Object = this._434478175championSummary_c;
         if(_loc2_ !== param1)
         {
            this._434478175championSummary_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSummary_c",_loc2_,param1));
         }
      }
      
      public function set colLeft(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948491687colLeft;
         if(_loc2_ !== param1)
         {
            this._948491687colLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colLeft",_loc2_,param1));
         }
      }
      
      public function set glowComponentController(param1:GlowComponentController) : void
      {
         this._glowComponentController = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowChat() : ConstraintRow
      {
         return this._1386038354rowChat;
      }
      
      [Bindable(event="propertyChange")]
      public function get browseButton() : Button
      {
         return this._398731868browseButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get quitButton() : Button
      {
         return this._1566114207quitButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
      
      public function cleanupView() : void
      {
         this.hideChampionOverlay();
      }
      
      protected function removeChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         if(this.spectatorWaitBar)
         {
            this.spectatorWaitBar.visible = false;
         }
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.onMainMenuStateChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onMainMenuStateChanged);
      }
      
      public function get rootContext() : IContext
      {
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorWaitBar() : SpectatorWaitBar
      {
         return this._942482833spectatorWaitBar;
      }
      
      protected function displayChampionDetails(param1:TimerEvent = null) : void
      {
         if(this.rollOverTimer)
         {
            this.rollOverTimer.stop();
         }
         this.turnOnChampionDetails();
         this.showChampionOverlay(this.championDetails);
      }
      
      public function set messageCenter(param1:ChampionSelectMessageCenter) : void
      {
         var _loc2_:Object = this._2029103300messageCenter;
         if(_loc2_ !== param1)
         {
            this._2029103300messageCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageCenter",_loc2_,param1));
         }
      }
      
      private function onQuitClicked() : void
      {
         this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.QUIT_GAME));
      }
      
      public function set bkgImage(param1:Image) : void
      {
         var _loc2_:Object = this._1805069635bkgImage;
         if(_loc2_ !== param1)
         {
            this._1805069635bkgImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bkgImage",_loc2_,param1));
         }
      }
      
      public function set rowContent(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._134469313rowContent;
         if(_loc2_ !== param1)
         {
            this._134469313rowContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowContent",_loc2_,param1));
         }
      }
      
      protected function onRollOverChampion(param1:ItemSelectEvent) : void
      {
         if(!this.rollOverTimer)
         {
            this.rollOverTimer = new Timer(DETAILS_DELAY);
            this.rollOverTimer.addEventListener(TimerEvent.TIMER,this.displayChampionDetails,false,0,true);
         }
         this.championDetails = param1.data as ParticipantChampionSelection;
         this.rollOverTimer.reset();
         this.rollOverTimer.start();
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      public function set header_c(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1115259087header_c;
         if(_loc2_ !== param1)
         {
            this._1115259087header_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c",_loc2_,param1));
         }
      }
      
      private function _SpectatorChampionSelectionView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.rowContent = _loc1_;
         _loc1_.height = 535;
         _loc1_.initialized(this,"rowContent");
         return _loc1_;
      }
      
      private function _SpectatorChampionSelectionView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.championSelectionModel;
         _loc1_ = this.championSelectionModel;
         _loc1_ = RiotResourceLoader.getString("championSelection_poolTitle");
         _loc1_ = RiotResourceLoader.getString("championSelection_selectChampionLabel");
         _loc1_ = this.championSelectionModel;
         _loc1_ = this.championSelectionModel;
         _loc1_ = this.championSelectionModel.progressBarVisible;
         _loc1_ = this.championSelectionModel.currentTeamName;
         _loc1_ = this.championSelectionModel.friendlyTeammatesVisible;
         _loc1_ = this.championSelectionModel.currentTeamSelections;
         _loc1_ = this.championSelectionModel.enemyTeamName;
         _loc1_ = this.championSelectionModel.enemyTeamSelections;
         _loc1_ = this.championSelectionModel.enemyTeamVisible;
         _loc1_ = this.championSelectionModel.enemyTeamVisible;
         _loc1_ = RiotResourceLoader.getString("spectator_quit_label");
         _loc1_ = this.quitButton.width + 5;
         _loc1_ = RiotResourceLoader.getString("spectator_browse_label");
      }
      
      public function set charactersPage_c(param1:ChampionGrid) : void
      {
         var _loc2_:Object = this._894196291charactersPage_c;
         if(_loc2_ !== param1)
         {
            this._894196291charactersPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"charactersPage_c",_loc2_,param1));
         }
      }
      
      public function set colMiddle(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._999696181colMiddle;
         if(_loc2_ !== param1)
         {
            this._999696181colMiddle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colMiddle",_loc2_,param1));
         }
      }
      
      private function _SpectatorChampionSelectionView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return this.championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            messageCenter.championSelectionModel = param1;
         },"messageCenter.championSelectionModel");
         result[0] = binding;
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            spectatorWaitBar.championSelectionModel = param1;
         },"spectatorWaitBar.championSelectionModel");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_poolTitle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_c_label.text = param1;
         },"header_c_label.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_selectChampionLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            charactersPage_c.label = param1;
         },"charactersPage_c.label");
         result[3] = binding;
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            charactersPage_c.championSelectionModel = param1;
         },"charactersPage_c.championSelectionModel");
         result[4] = binding;
         binding = new Binding(this,function():ChampionSelectionModel
         {
            return this.championSelectionModel;
         },function(param1:ChampionSelectionModel):void
         {
            progressBar.championSelectionModel = param1;
         },"progressBar.championSelectionModel");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return championSelectionModel.progressBarVisible;
         },function(param1:Boolean):void
         {
            progressBar.visible = param1;
         },"progressBar.visible");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championSelectionModel.currentTeamName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            friendlyTeam.teamColorName = param1;
         },"friendlyTeam.teamColorName");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.friendlyTeammatesVisible;
         },function(param1:Boolean):void
         {
            friendlyTeam.teamPlayersVisible = param1;
         },"friendlyTeam.teamPlayersVisible");
         result[8] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.championSelectionModel.currentTeamSelections;
         },function(param1:ArrayCollection):void
         {
            friendlyTeam.teamPlayers = param1;
         },"friendlyTeam.teamPlayers");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championSelectionModel.enemyTeamName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            enemyTeam.teamColorName = param1;
         },"enemyTeam.teamColorName");
         result[10] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.championSelectionModel.enemyTeamSelections;
         },function(param1:ArrayCollection):void
         {
            enemyTeam.teamPlayers = param1;
         },"enemyTeam.teamPlayers");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.enemyTeamVisible;
         },function(param1:Boolean):void
         {
            enemyTeam.teamPlayersVisible = param1;
         },"enemyTeam.teamPlayersVisible");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.championSelectionModel.enemyTeamVisible;
         },function(param1:Boolean):void
         {
            enemyTeam.visible = param1;
         },"enemyTeam.visible");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("spectator_quit_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitButton.label = param1;
         },"quitButton.label");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = quitButton.width + 5;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            browseButton.setStyle("left",param1);
         },"browseButton.left");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("spectator_browse_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            browseButton.label = param1;
         },"browseButton.label");
         result[16] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpectatorChampionSelectionView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpectatorChampionSelectionView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_SpectatorChampionSelectionViewWatcherSetupUtil");
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
      
      public function set matchDetails(param1:MatchDetailsView) : void
      {
         var _loc2_:Object = this._1399514947matchDetails;
         if(_loc2_ !== param1)
         {
            this._1399514947matchDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchDetails",_loc2_,param1));
         }
      }
      
      public function set teamOneBans(param1:BannedChampionsView) : void
      {
         var _loc2_:Object = this._1440278701teamOneBans;
         if(_loc2_ !== param1)
         {
            this._1440278701teamOneBans = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamOneBans",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         var _loc2_:Object = this.championSelectionModel;
         if(_loc2_ !== param1)
         {
            this._1044583878championSelectionModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSelectionModel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchMapView() : MapView
      {
         return this._2120455012matchMapView;
      }
      
      [Bindable(event="propertyChange")]
      public function get championSummary_c() : ChampionSummaryView
      {
         return this._434478175championSummary_c;
      }
      
      private function _SpectatorChampionSelectionView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.width = 270;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      public function set rowChat(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1386038354rowChat;
         if(_loc2_ !== param1)
         {
            this._1386038354rowChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowChat",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get progressBar() : ChampionSelectProgressBar
      {
         return this._1131509414progressBar;
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamTwoBans() : BannedChampionsView
      {
         return this._1849727379teamTwoBans;
      }
      
      public function get glowComponentController() : GlowComponentController
      {
         return this._glowComponentController;
      }
      
      protected function updateBans() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         if(this.teamOneBans)
         {
            this.teamOneBans.bannedChamps = this.championSelectionModel.teamOneBans;
         }
         if(this.teamTwoBans)
         {
            this.teamTwoBans.bannedChamps = this.championSelectionModel.teamTwoBans;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamOneBans() : BannedChampionsView
      {
         return this._1440278701teamOneBans;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyTeam() : ChampionSelectPlayerList
      {
         return this._462115240friendlyTeam;
      }
      
      public function set browseButton(param1:Button) : void
      {
         var _loc2_:Object = this._398731868browseButton;
         if(_loc2_ !== param1)
         {
            this._398731868browseButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"browseButton",_loc2_,param1));
         }
      }
      
      private function updateChampionGridState() : void
      {
         if(!this.charactersPage_c || !this.championSelectionModel.currentPlayerParticipant)
         {
            return;
         }
         if(this.championSelectionModel.currentPlayerParticipant.pickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            this.charactersPage_c.alpha = 1;
         }
         else
         {
            this.charactersPage_c.alpha = 0.7;
         }
      }
      
      private function turnOnChampionDetails() : void
      {
         this.championSummary_c.visible = true;
         this.championSummary_c.champion = this.championDetails.champion;
      }
      
      public function set quitButton(param1:Button) : void
      {
         var _loc2_:Object = this._1566114207quitButton;
         if(_loc2_ !== param1)
         {
            this._1566114207quitButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quitButton",_loc2_,param1));
         }
      }
      
      public function __browseButton_click(param1:MouseEvent) : void
      {
         this.onBrowseButtonClicked();
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      protected function setChampionSelectionModel() : void
      {
         if(!this.championSelectionModel)
         {
            return;
         }
         this.championSelectionModel.addEventListener(ChampionSelectionModel.MAIN_MENU_STATE_CHANGE,this.onMainMenuStateChanged,false,0,true);
         this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onMainMenuStateChanged,false,0,true);
         this.updateGameType();
         this.updateMap();
         this.updateDetails();
         this.updateBans();
         this.updateExtendedLayout();
      }
      
      private function onRollOutSummonerName(param1:MouseEvent) : void
      {
         if(this.playerTooltip != null)
         {
            this.playerTooltip.hide();
            this.playerTooltip = null;
         }
      }
      
      private function onBrowseButtonClicked() : void
      {
         this.dispatchEvent(new GameEvent(GameEvent.BROWSE_REQUESTED,this.championSelectionModel.currentGame));
      }
      
      protected function updateMap() : void
      {
         if(Boolean(this.matchMapView) && Boolean(this.championSelectionModel))
         {
            this.matchMapView.gameMap = this.championSelectionModel.gameMap;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bkgImage() : Image
      {
         return this._1805069635bkgImage;
      }
      
      private function set _1044583878championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         this.removeChampionSelectionModel();
         this._championSelectionModel = param1;
         this.setChampionSelectionModel();
      }
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      private function onRollOutActionButton(param1:MouseEvent) : void
      {
      }
      
      protected function showChampionOverlay(param1:ParticipantChampionSelection) : void
      {
         var _loc3_:ChampionTooltip = null;
         var _loc2_:Champion = param1.champion;
         if(!_loc2_.skinName || Boolean(_loc2_.isRandomChampion()) || Boolean(_loc2_.isWildCardChampion()))
         {
            return;
         }
         if(!AdvancedToolTipManager.toolTipOpen)
         {
            _loc3_ = new ChampionTooltip();
            _loc3_.data = param1;
            AdvancedToolTipManager.createCustomToolTip(1000 * ApplicationUtil.application.scaleX,117 * ApplicationUtil.application.scaleY,_loc3_);
         }
      }
      
      public function set purpleTeamSummonerImage(param1:Image) : void
      {
         var _loc2_:Object = this._1235528460purpleTeamSummonerImage;
         if(_loc2_ !== param1)
         {
            this._1235528460purpleTeamSummonerImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"purpleTeamSummonerImage",_loc2_,param1));
         }
      }
      
      public function set rootContext(param1:IContext) : void
      {
      }
      
      private function updateExtendedLayout() : void
      {
         var _loc1_:Boolean = this.championSelectionModel != null && Boolean(this.championSelectionModel.extendedTeamSizes);
         if(this.blueTeamSummonerImage != null)
         {
            this.blueTeamSummonerImage.alpha = _loc1_ ? 0.333 : 1;
         }
         if(this.purpleTeamSummonerImage != null)
         {
            this.purpleTeamSummonerImage.alpha = _loc1_ ? 0.333 : 1;
         }
      }
      
      public function set colRight(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._655867780colRight;
         if(_loc2_ !== param1)
         {
            this._655867780colRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colRight",_loc2_,param1));
         }
      }
      
      public function updateRerollButton() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get purpleTeamSummonerImage() : Image
      {
         return this._1235528460purpleTeamSummonerImage;
      }
      
      private function showPlayerTooltip(param1:MouseEvent) : void
      {
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc2_:Label = param1.currentTarget as Label;
         var _loc3_:Number = parseInt(_loc2_.name);
         var _loc4_:String = _loc2_.text;
         var _loc5_:GameParticipant = this.championSelectionModel.currentPlayerParticipant;
         if(!(_loc5_ is PlayerParticipant))
         {
            return;
         }
         if(this.playerTooltip == null)
         {
            this.playerTooltip = Menu.createMenu(this,PlayerParticipant(_loc5_),false);
            this.playerTooltip.setStyle("styleName","playerTooltip");
            this.playerTooltip.itemRenderer = new ClassFactory(PlayerProfileTooltip);
            this.playerTooltip.selectable = false;
            this.playerTooltip.width = 300;
            this.playerTooltip.height = 100;
            _loc6_ = new Point(_loc2_.x,_loc2_.y + _loc2_.height);
            _loc6_ = this.localToGlobal(_loc6_);
            _loc7_ = DisplayObject(ApplicationUtil.application).width;
            this.playerTooltip.x = Math.min(_loc7_ - this.playerTooltip.width,_loc6_.x);
            this.playerTooltip.y = _loc6_.y;
         }
         this.playerTooltip.show();
      }
   }
}

