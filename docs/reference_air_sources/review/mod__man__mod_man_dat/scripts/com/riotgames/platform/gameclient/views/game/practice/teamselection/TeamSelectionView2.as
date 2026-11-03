package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.views.game.common.invite.InviteePanel;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class TeamSelectionView2 extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Inject]
      private var _2070536460applicationController:IAppController;
      
      public var alerter:IAlerterProvider;
      
      private var waitAction:AlertWaitAction;
      
      private var _2070565886startChampionSelection_btn:SoundEffectButton;
      
      private var gameTypeConfigManager:GameTypeConfigManager;
      
      public var _TeamSelectionView2_Text1:Text;
      
      private var _1525885706inviteGroup:InviteGroup;
      
      mx_internal var _bindingsByDestination:Object;
      
      public var _TeamSelectionView2_Image1:Image;
      
      private var _51534353map_holder:Canvas;
      
      private var _620697998mapInfo_c:Canvas;
      
      private var _1836939262quitGame_btn:SoundEffectButton;
      
      mx_internal var _watchers:Array;
      
      private var _1439268838teams_c:TeamSelectionPanel2;
      
      private var showedPopup:Boolean = false;
      
      private var _769234152inviteePanel:InviteePanel;
      
      private var _407108067content_c:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      [Inject]
      private var _843995307teamSelectionController:TeamSelectionController;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226:Class;
      
      private var _1674077510mapDetails:Label;
      
      mx_internal var _bindings:Array;
      
      private var _158535007mapImage:Image;
      
      private var isBusyWatcher:ChangeWatcher;
      
      [Inject]
      private var _1450947915masterGameViewController:MasterGameViewController;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function TeamSelectionView2()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"content_c",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0.4;
                     this.left = "0";
                     this.right = "1";
                     this.top = "0";
                     this.bottom = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":TeamSelectionPanel2,
                           "id":"teams_c",
                           "stylesFactory":function():void
                           {
                              this.top = "3";
                              this.bottom = "5";
                              this.left = "3";
                              this.right = "318";
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "stylesFactory":function():void
                           {
                              this.right = "4";
                              this.top = "3";
                              this.bottom = "5";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":310,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Canvas,
                                    "stylesFactory":function():void
                                    {
                                       this.left = "0";
                                       this.right = "0";
                                       this.top = "0";
                                       this.cornerRadius = 2;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "cacheAsBitmap":true,
                                          "height":332,
                                          "styleName":"blueParchmentTablet",
                                          "horizontalScrollPolicy":"off",
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Canvas,
                                             "id":"mapInfo_c",
                                             "stylesFactory":function():void
                                             {
                                                this.top = "0";
                                                this.bottom = "0";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "cacheAsBitmap":true,
                                                   "percentWidth":100,
                                                   "horizontalScrollPolicy":"off",
                                                   "verticalScrollPolicy":"off",
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":GradientCanvas,
                                                      "stylesFactory":function():void
                                                      {
                                                         this.top = "-1";
                                                         this.left = "-1";
                                                         this.right = "-1";
                                                         this.borderStyle = "none";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"blueHeaderBackground",
                                                            "height":36,
                                                            "horizontalScrollPolicy":"off",
                                                            "verticalScrollPolicy":"off",
                                                            "childDescriptors":[new UIComponentDescriptor({
                                                               "type":Image,
                                                               "id":"_TeamSelectionView2_Image1",
                                                               "stylesFactory":function():void
                                                               {
                                                                  this.verticalCenter = "0";
                                                               },
                                                               "propertiesFactory":function():Object
                                                               {
                                                                  return {"source":_embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226};
                                                               }
                                                            }),new UIComponentDescriptor({
                                                               "type":Label,
                                                               "id":"mapDetails",
                                                               "stylesFactory":function():void
                                                               {
                                                                  this.left = "10";
                                                                  this.verticalCenter = "0";
                                                               },
                                                               "propertiesFactory":function():Object
                                                               {
                                                                  return {
                                                                     "styleName":"blueThemeHeaderText",
                                                                     "selectable":false
                                                                  };
                                                               }
                                                            })]
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Canvas,
                                                      "id":"map_holder",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalCenter = "0";
                                                         this.cornerRadius = 0;
                                                         this.top = "45";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "cacheAsBitmap":true,
                                                            "styleName":"blueParchmentTablet",
                                                            "width":291,
                                                            "height":155,
                                                            "verticalScrollPolicy":"off",
                                                            "horizontalScrollPolicy":"off",
                                                            "clipContent":true,
                                                            "childDescriptors":[new UIComponentDescriptor({
                                                               "type":Image,
                                                               "id":"mapImage",
                                                               "stylesFactory":function():void
                                                               {
                                                                  this.verticalCenter = "0";
                                                                  this.horizontalCenter = "0";
                                                               },
                                                               "propertiesFactory":function():Object
                                                               {
                                                                  return {
                                                                     "maintainAspectRatio":false,
                                                                     "percentHeight":100,
                                                                     "percentWidth":100
                                                                  };
                                                               }
                                                            })]
                                                         };
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Text,
                                                      "id":"_TeamSelectionView2_Text1",
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"createGameMapText",
                                                            "x":5,
                                                            "selectable":false
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":InviteePanel,
                                    "id":"inviteePanel",
                                    "stylesFactory":function():void
                                    {
                                       this.bottom = "0";
                                       this.left = "0";
                                       this.right = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "cacheAsBitmap":true,
                                          "visible":true,
                                          "nameColWidth":180,
                                          "height":330
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"quitGame_btn",
                                    "events":{"click":"__quitGame_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.left = "5";
                                       this.bottom = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"longButtonBlue",
                                          "width":147
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":SoundEffectButton,
                                    "id":"startChampionSelection_btn",
                                    "events":{"click":"__startChampionSelection_btn_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.right = "5";
                                       this.bottom = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"gold",
                                          "width":147
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
         this.alerter = AlerterProviderProxy.instance;
         this.gameTypeConfigManager = GameTypeConfigManager.instance;
         this._embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226 = TeamSelectionView2__embed_mxml________ClientAssets_imageEmbeds_teamSelection_pvp_headerFlame_blue_png_1953900226;
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
         this.percentHeight = 100;
         this.addEventListener("initialize",this.___TeamSelectionView2_Canvas1_initialize);
         this.addEventListener("show",this.___TeamSelectionView2_Canvas1_show);
         this.addEventListener("hide",this.___TeamSelectionView2_Canvas1_hide);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TeamSelectionView2._watcherSetupUtil = param1;
      }
      
      public function set startChampionSelection_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2070565886startChampionSelection_btn;
         if(_loc2_ !== param1)
         {
            this._2070565886startChampionSelection_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startChampionSelection_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get startChampionSelection_btn() : SoundEffectButton
      {
         return this._2070565886startChampionSelection_btn;
      }
      
      private function onQuitGameError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_new_quitGameErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get applicationController() : IAppController
      {
         return this._2070536460applicationController;
      }
      
      [Bindable(event="propertyChange")]
      public function get map_holder() : Canvas
      {
         return this._51534353map_holder;
      }
      
      public function set applicationController(param1:IAppController) : void
      {
         var _loc2_:Object = this._2070536460applicationController;
         if(_loc2_ !== param1)
         {
            this._2070536460applicationController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teams_c() : TeamSelectionPanel2
      {
         return this._1439268838teams_c;
      }
      
      private function _TeamSelectionView2_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.mapDetails.x - 8;
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_mapOptionsHeaderLabel");
         _loc1_ = this.map_holder.y + this.map_holder.height + 4;
         _loc1_ = this.htmlMapDescription;
         _loc1_ = this.inviteGroup.isOwner || this.inviteGroup.allowedToInvite && !this.masterGameViewController.masterGameController.isSpectating;
         _loc1_ = resourceManager.getString("resources","practiceGame_new_quitGameButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_new_quitGameButton_tooltip");
         _loc1_ = !this.teamSelectionController.isBusy;
         _loc1_ = resourceManager.getString("resources","practiceGame_new_startGameButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_new_startGameButton_tooltip");
         _loc1_ = this.teamSelectionController.isOwner;
         _loc1_ = this.teamSelectionController.isOwner;
         _loc1_ = !this.teamSelectionController.isBusy;
      }
      
      public function set mapInfo_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._620697998mapInfo_c;
         if(_loc2_ !== param1)
         {
            this._620697998mapInfo_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfo_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content_c() : Canvas
      {
         return this._407108067content_c;
      }
      
      public function ___TeamSelectionView2_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      [Bindable(event="propertyChange")]
      public function set htmlMapDescription(param1:String) : void
      {
         var _loc2_:Object = this.htmlMapDescription;
         if(_loc2_ !== param1)
         {
            this._94069131htmlMapDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlMapDescription",_loc2_,param1));
         }
      }
      
      public function set teams_c(param1:TeamSelectionPanel2) : void
      {
         var _loc2_:Object = this._1439268838teams_c;
         if(_loc2_ !== param1)
         {
            this._1439268838teams_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teams_c",_loc2_,param1));
         }
      }
      
      public function set content_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._407108067content_c;
         if(_loc2_ !== param1)
         {
            this._407108067content_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapDetails() : Label
      {
         return this._1674077510mapDetails;
      }
      
      private function _TeamSelectionView2_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return mapDetails.x - 8;
         },function(param1:Number):void
         {
            _TeamSelectionView2_Image1.x = param1;
         },"_TeamSelectionView2_Image1.x");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_mapOptionsHeaderLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapDetails.text = param1;
         },"mapDetails.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = map_holder.y + map_holder.height + 4;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TeamSelectionView2_Text1.setStyle("top",param1);
         },"_TeamSelectionView2_Text1.top");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.htmlMapDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TeamSelectionView2_Text1.htmlText = param1;
         },"_TeamSelectionView2_Text1.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(inviteGroup.isOwner) || Boolean(inviteGroup.allowedToInvite) && !masterGameViewController.masterGameController.isSpectating;
         },function(param1:Boolean):void
         {
            inviteePanel.allowedtoInvite = param1;
         },"inviteePanel.allowedtoInvite");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_new_quitGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitGame_btn.label = param1;
         },"quitGame_btn.label");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_new_quitGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitGame_btn.toolTip = param1;
         },"quitGame_btn.toolTip");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.teamSelectionController.isBusy;
         },function(param1:Boolean):void
         {
            quitGame_btn.enabled = param1;
         },"quitGame_btn.enabled");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_new_startGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            startChampionSelection_btn.label = param1;
         },"startChampionSelection_btn.label");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_new_startGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            startChampionSelection_btn.toolTip = param1;
         },"startChampionSelection_btn.toolTip");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.teamSelectionController.isOwner;
         },function(param1:Boolean):void
         {
            startChampionSelection_btn.visible = param1;
         },"startChampionSelection_btn.visible");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.teamSelectionController.isOwner;
         },function(param1:Boolean):void
         {
            startChampionSelection_btn.includeInLayout = param1;
         },"startChampionSelection_btn.includeInLayout");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.teamSelectionController.isBusy;
         },function(param1:Boolean):void
         {
            startChampionSelection_btn.enabled = param1;
         },"startChampionSelection_btn.enabled");
         result[12] = binding;
         return result;
      }
      
      private function onStartChampionSelectionError(param1:ServerError) : void
      {
         var _loc2_:String = null;
         if(param1.errorCode == MessageDictionary.NOT_ENOUGH_PLAYERS_TO_START_GAME || param1.errorCode == MessageDictionary.PRACTICE_GAME_CANNOT_SELECT_CHAMP_NEED_MORE_PLAYERS)
         {
            _loc2_ = param1.errorCode;
         }
         else
         {
            _loc2_ = MessageDictionary.STALE_GAME;
         }
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         var _loc4_:AlertAction = new AlertAction(_loc3_.getString("resources","general_generalAlertErrorTitle"),_loc3_.getString("resources",_loc2_,param1.messageArguments));
         _loc4_.add();
      }
      
      private function initializeView() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:GameMap = null;
         this.isBusyWatcher = ChangeWatcher.watch(this.teamSelectionController,"isBusy",this.onIsBusyChanged);
         this.htmlMapDescription = null;
         if(this.mapImage)
         {
            this.mapImage.source = ImagePackLookup.instance.getMapSource(this.teamSelectionController.gameMap);
         }
         if(this.teamSelectionController.gameMap != null && this.teamSelectionController.gameMap.minCustomPlayers > 1 && !this.showedPopup)
         {
            this.showedPopup = true;
            _loc1_ = false;
            for each(_loc2_ in AppConfig.instance.availableMaps)
            {
               if(_loc2_.minCustomPlayers != this.teamSelectionController.gameMap.minCustomPlayers)
               {
                  _loc1_ = true;
                  break;
               }
            }
         }
      }
      
      public function set teamSelectionController(param1:TeamSelectionController) : void
      {
         var _loc2_:Object = this._843995307teamSelectionController;
         if(_loc2_ !== param1)
         {
            this._843995307teamSelectionController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelectionController",_loc2_,param1));
         }
      }
      
      private function onIsBusyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc3_:IResourceManager = null;
         var _loc2_:String = "";
         if(this.waitAction)
         {
            this.waitAction.complete();
         }
         if(Boolean(param1.newValue) && Boolean(this.teamSelectionController))
         {
            CursorManager.getInstance().setBusyCursor();
            switch(this.teamSelectionController.waitingState)
            {
               case TeamSelectionController.WAITING_CHANGE_TEAMS:
                  _loc2_ = RiotResourceLoader.getString("serverWait_switchingTeams");
                  break;
               case TeamSelectionController.WAITING_START_GAME:
                  _loc2_ = RiotResourceLoader.getString("serverWait_startingGame");
            }
            _loc3_ = ResourceManager.getInstance();
            if(this.waitAction == null)
            {
               this.waitAction = new AlertWaitAction(_loc3_.getString("resources","serverWait_retrievingDataMessage"),_loc3_.getString("resources","serverWait_loadingMessage"));
            }
            this.waitAction.add();
         }
         else if(this.teamSelectionController)
         {
            this.teamSelectionController.waitingState = _loc2_;
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : Image
      {
         return this._158535007mapImage;
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this._1450947915masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
         }
      }
      
      public function ___TeamSelectionView2_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function set _94069131htmlMapDescription(param1:String) : void
      {
      }
      
      private function onShow() : void
      {
         this.initializeView();
      }
      
      public function get htmlMapDescription() : String
      {
         var _loc1_:GameMap = this.teamSelectionController.gameMap;
         var _loc2_:GameDTO = this.teamSelectionController.masterGameController.currentGame;
         var _loc3_:GameTypeConfig = this.gameTypeConfigManager.getGameTypeConfig(_loc2_.gameTypeConfigId);
         var _loc4_:String = "";
         if(_loc3_)
         {
            _loc4_ = RiotResourceLoader.getString("practiceGame_gameMode_" + _loc3_.name);
         }
         var _loc5_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(_loc2_.gameMutators,_loc2_.gameMode);
         return _loc1_ == null ? "" : "<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_mapName_label","Map") + "</font><font color=\'#FFFFFF\'>  " + _loc1_.displayName + "</font>\n<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_teamSize_label","Team Size") + "</font><font color=\'#FFFFFF\'>  " + (_loc2_.maxNumPlayers / 2 + "x" + _loc2_.maxNumPlayers / 2).toString() + "</font>\n<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_gameMode_label","Game Mode") + "</font><font color=\'#FFFFFF\'>  " + _loc5_.getGameFlowName() + "</font>\n<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_pickType_label","Pick Type") + "</font><font color=\'#FFFFFF\'>  " + _loc4_ + "</font>\n<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_gameName_label","Game Name") + "</font><font color=\'#FFFFFF\'>  " + _loc2_.name + "</font>";
      }
      
      public function set mapDetails(param1:Label) : void
      {
         var _loc2_:Object = this._1674077510mapDetails;
         if(_loc2_ !== param1)
         {
            this._1674077510mapDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapDetails",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfo_c() : Canvas
      {
         return this._620697998mapInfo_c;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TeamSelectionView2 = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TeamSelectionView2_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionView2WatcherSetupUtil");
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
      
      private function resetView() : void
      {
         this.showedPopup = false;
         if(this.isBusyWatcher)
         {
            this.isBusyWatcher.unwatch();
            this.isBusyWatcher = null;
         }
         if(this.mapImage)
         {
            this.mapImage.source = null;
         }
      }
      
      private function onQuitGameButtonClicked(param1:MouseEvent) : void
      {
         this.teamSelectionController.quitGame(this.onQuitGameError);
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get teamSelectionController() : TeamSelectionController
      {
         return this._843995307teamSelectionController;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._1450947915masterGameViewController;
      }
      
      public function ___TeamSelectionView2_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onHide() : void
      {
         if(this.isBusyWatcher != null)
         {
            this.isBusyWatcher.unwatch();
            this.isBusyWatcher = null;
         }
         if(this.waitAction)
         {
            this.waitAction.complete();
         }
         this.resetView();
      }
      
      public function set mapImage(param1:Image) : void
      {
         var _loc2_:Object = this._158535007mapImage;
         if(_loc2_ !== param1)
         {
            this._158535007mapImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapImage",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
         this.initializeView();
         if(!this.inviteGroup)
         {
            ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         }
      }
      
      public function set inviteePanel(param1:InviteePanel) : void
      {
         var _loc2_:Object = this._769234152inviteePanel;
         if(_loc2_ !== param1)
         {
            this._769234152inviteePanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteePanel",_loc2_,param1));
         }
      }
      
      private function onStartChampionSelectionButtonClicked(param1:MouseEvent) : void
      {
         this.teamSelectionController.startChampionSelection(this.onStartChampionSelectionError);
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this.inviteGroup = param1.getInviteGroup();
      }
      
      public function set map_holder(param1:Canvas) : void
      {
         var _loc2_:Object = this._51534353map_holder;
         if(_loc2_ !== param1)
         {
            this._51534353map_holder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map_holder",_loc2_,param1));
         }
      }
      
      public function __quitGame_btn_click(param1:MouseEvent) : void
      {
         this.onQuitGameButtonClicked(param1);
      }
      
      public function set inviteGroup(param1:InviteGroup) : void
      {
         var _loc2_:Object = this._1525885706inviteGroup;
         if(_loc2_ !== param1)
         {
            this._1525885706inviteGroup = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteGroup",_loc2_,param1));
         }
      }
      
      public function __startChampionSelection_btn_click(param1:MouseEvent) : void
      {
         this.onStartChampionSelectionButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteePanel() : InviteePanel
      {
         return this._769234152inviteePanel;
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteGroup() : InviteGroup
      {
         return this._1525885706inviteGroup;
      }
      
      public function set quitGame_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1836939262quitGame_btn;
         if(_loc2_ !== param1)
         {
            this._1836939262quitGame_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quitGame_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quitGame_btn() : SoundEffectButton
      {
         return this._1836939262quitGame_btn;
      }
   }
}

