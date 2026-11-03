package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
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
   import mx.controls.Image;
   import mx.controls.RadioButton;
   import mx.controls.RadioButtonGroup;
   import mx.controls.Text;
   import mx.controls.VRule;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGameGraph extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const END_OF_GAME_CONCRETE_TEXTURE:Class = EndOfGameGraph_END_OF_GAME_CONCRETE_TEXTURE;
      
      public static const BLUE_GLOW_OVERLAY:Class = EndOfGameGraph_BLUE_GLOW_OVERLAY;
      
      public static const GREEN_GLOW_OVERLAY:Class = EndOfGameGraph_GREEN_GLOW_OVERLAY;
      
      public static const PURPLE_GLOW_OVERLAY:Class = EndOfGameGraph_PURPLE_GLOW_OVERLAY;
      
      public static const RED_GLOW_OVERLAY:Class = EndOfGameGraph_RED_GLOW_OVERLAY;
      
      private static const GRAPH_SECTION_HEIGHT:int = 300;
      
      private var _326573852bottomMiddleText1:Text;
      
      private var _1524564555itemCanvas:Canvas;
      
      private var _1301142843radioButtonCanvas:Canvas;
      
      private var _1379247771friendlyGraphCanvas:Canvas;
      
      private var _95755156topRightText:Text;
      
      public var _EndOfGameGraph_VRule1:VRule;
      
      public var _EndOfGameGraph_VRule3:VRule;
      
      public var _EndOfGameGraph_VRule4:VRule;
      
      public var _EndOfGameGraph_VRule5:VRule;
      
      public var _EndOfGameGraph_VRule6:VRule;
      
      public var _EndOfGameGraph_VRule2:VRule;
      
      private var _endOfGameStatsController:EndOfGameStatsController;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1293525279bottomLeftText:Text;
      
      private var _1002647945texture2:Image;
      
      private var _1662289030topMiddleText1:Text;
      
      private var _1439287470team_rb:RadioButton;
      
      private var _1318036428stat_rbg:RadioButtonGroup;
      
      private var _1276019086maximumStatDisplay:int;
      
      private var lastSelecetedStat:PlayerStat;
      
      protected var itemRendererMap:Dictionary;
      
      public var _EndOfGameGraph_Image1:Image;
      
      public var _EndOfGameGraph_Image6:Image;
      
      private var _1662289028topMiddleText3:Text;
      
      private var _1872043954player_rb:RadioButton;
      
      private var _172762774treeCanvas:Canvas;
      
      private var _431096815bottomGraphBorder:Image;
      
      private var _904618363topGraphBorder:Image;
      
      private var _1414463927topLeftText:Text;
      
      mx_internal var _watchers:Array = [];
      
      private var _1855925378bottomRightText:Text;
      
      private var mousedOverStat:PlayerStat;
      
      private var _326573850bottomMiddleText3:Text;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _maximumStat:int;
      
      private var _2123755233yourTeam_txt:Text;
      
      private var _1662289029topMiddleText2:Text;
      
      public var endOfGameTree:EndOfGameGraphTree;
      
      private var _326573851bottomMiddleText2:Text;
      
      private var _1844395106enemyGraphCanvas:Canvas;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"treeCanvas",
               "stylesFactory":function():void
               {
                  this.backgroundColor = 4897;
                  this.backgroundAlpha = 1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":533,
                     "y":76,
                     "width":280,
                     "height":596,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameGraph_Image1",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "maintainAspectRatio":false,
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"topLeftText",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "text":"0",
                     "width":70,
                     "selectable":false,
                     "y":10,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"topMiddleText1",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "selectable":false,
                     "y":10,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"topMiddleText2",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "selectable":false,
                     "y":10,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"topMiddleText3",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "selectable":false,
                     "y":10,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"topRightText",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":451,
                     "y":10,
                     "width":70,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"bottomLeftText",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "text":"0",
                     "width":70,
                     "y":662,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"bottomMiddleText1",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "y":662,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"bottomMiddleText2",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "y":662,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"bottomMiddleText3",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":70,
                     "y":662,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"bottomRightText",
               "stylesFactory":function():void
               {
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":451,
                     "y":662,
                     "width":70,
                     "selectable":false,
                     "styleName":"endOfGameGraphNumber"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"friendlyGraphCanvas",
               "stylesFactory":function():void
               {
                  this.backgroundColor = 200715;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":60,
                     "y":28,
                     "width":460,
                     "height":310,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule1",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule2",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule3",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"topGraphBorder",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "maintainAspectRatio":false,
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"texture",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "blendMode":"overlay",
                              "alpha":0.48,
                              "maintainAspectRatio":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"enemyGraphCanvas",
               "stylesFactory":function():void
               {
                  this.backgroundColor = 853769;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":60,
                     "y":354,
                     "width":460,
                     "height":310,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule4",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule5",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "id":"_EndOfGameGraph_VRule6",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":1,
                              "alpha":0.2
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"bottomGraphBorder",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "maintainAspectRatio":false,
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"texture2",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "blendMode":"overlay",
                              "alpha":0.48,
                              "maintainAspectRatio":false
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"itemCanvas",
               "propertiesFactory":function():Object
               {
                  return {
                     "clipContent":false,
                     "height":635
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"radioButtonCanvas",
               "stylesFactory":function():void
               {
                  this.backgroundColor = 4897;
                  this.backgroundAlpha = 1;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":533,
                     "y":10,
                     "width":280,
                     "height":58,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameGraph_Image6",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.right = "0";
                           this.top = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "maintainAspectRatio":false,
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":RadioButton,
                        "id":"player_rb",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "groupName":"stat_rbg",
                              "styleName":"blueRadioButton",
                              "x":15,
                              "y":5,
                              "selected":true
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":RadioButton,
                        "id":"team_rb",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "groupName":"stat_rbg",
                              "styleName":"blueRadioButton",
                              "x":15,
                              "y":27
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"yourTeam_txt",
               "stylesFactory":function():void
               {
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "rotation":270,
                     "x":20,
                     "y":330,
                     "width":310,
                     "styleName":"endOfGameGraphNumber",
                     "visible":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"enemyTeam_txt",
               "stylesFactory":function():void
               {
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "rotation":270,
                     "x":20,
                     "y":658,
                     "width":310,
                     "styleName":"endOfGameGraphNumber",
                     "visible":false
                  };
               }
            })]};
         }
      });
      
      private var _565581514enemyTeam_txt:Text;
      
      private var _1417816805texture:Image;
      
      public function EndOfGameGraph()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._EndOfGameGraph_RadioButtonGroup1_i();
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameGraph._watcherSetupUtil = param1;
      }
      
      protected function onRemovedFromStage() : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onItemRendererMouseMove);
         this.endOfGameTree.removeEventListener(EndOfGameGraphTree.endOfGameAccordionClick,this.endOfGameAccordionClickHandler);
         this.treeCanvas.removeChild(this.endOfGameTree);
         this.endOfGameTree = null;
         this.itemRendererMap = new Dictionary(true);
         this.itemCanvas.removeAllChildren();
      }
      
      [Bindable(event="propertyChange")]
      public function get stat_rbg() : RadioButtonGroup
      {
         return this._1318036428stat_rbg;
      }
      
      [Bindable(event="propertyChange")]
      public function get treeCanvas() : Canvas
      {
         return this._172762774treeCanvas;
      }
      
      public function set topGraphBorder(param1:Image) : void
      {
         var _loc2_:Object = this._904618363topGraphBorder;
         if(_loc2_ !== param1)
         {
            this._904618363topGraphBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topGraphBorder",_loc2_,param1));
         }
      }
      
      public function set topMiddleText2(param1:Text) : void
      {
         var _loc2_:Object = this._1662289029topMiddleText2;
         if(_loc2_ !== param1)
         {
            this._1662289029topMiddleText2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topMiddleText2",_loc2_,param1));
         }
      }
      
      protected function showIcons(param1:Boolean) : void
      {
         var _loc2_:UIComponent = null;
         for each(_loc2_ in this.itemCanvas.getChildren())
         {
            if(_loc2_ is Image)
            {
               _loc2_.visible = param1;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomLeftText() : Text
      {
         return this._1293525279bottomLeftText;
      }
      
      private function onItemRendererMouseMove(param1:MouseEvent) : void
      {
         if(param1.target is Canvas && param1.target.parent is EndOfGameGraphItem)
         {
            if(param1.target.data != this.lastSelecetedStat)
            {
               this.onItemRendererMouseOver(param1);
            }
            this.lastSelecetedStat = param1.target.data;
         }
         if(param1.target is EndOfGameGraph && Boolean(this.lastSelecetedStat))
         {
            callLater(this.onItemRendererMouseOut,[null]);
            this.lastSelecetedStat = null;
            this.mousedOverStat = null;
         }
      }
      
      public function set maximumStatDisplay(param1:int) : void
      {
         var _loc2_:Object = this._1276019086maximumStatDisplay;
         if(_loc2_ !== param1)
         {
            this._1276019086maximumStatDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maximumStatDisplay",_loc2_,param1));
         }
      }
      
      public function set texture2(param1:Image) : void
      {
         var _loc2_:Object = this._1002647945texture2;
         if(_loc2_ !== param1)
         {
            this._1002647945texture2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"texture2",_loc2_,param1));
         }
      }
      
      public function set topRightText(param1:Text) : void
      {
         var _loc2_:Object = this._95755156topRightText;
         if(_loc2_ !== param1)
         {
            this._95755156topRightText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRightText",_loc2_,param1));
         }
      }
      
      private function onItemRendererMouseOver(param1:Event) : void
      {
         this.mousedOverStat = param1.target.data;
         this.endOfGameAccordionClickHandler(null);
      }
      
      public function set treeCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._172762774treeCanvas;
         if(_loc2_ !== param1)
         {
            this._172762774treeCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"treeCanvas",_loc2_,param1));
         }
      }
      
      public function set enemyGraphCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1844395106enemyGraphCanvas;
         if(_loc2_ !== param1)
         {
            this._1844395106enemyGraphCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyGraphCanvas",_loc2_,param1));
         }
      }
      
      protected function endOfGameAccordionClickHandler(param1:Event) : void
      {
         var _loc2_:ArrayCollection = null;
         var _loc3_:int = 0;
         this._maximumStat = 0;
         this.showItems(false);
         if(this.stat_rbg.selection === this.team_rb)
         {
            this.drawGraphItem(this._endOfGameStatsController.combinedTeamStats[0] as PlayerParticipantStatsSummary,false,0,1);
            this.drawGraphItem(this._endOfGameStatsController.combinedTeamStats[1] as PlayerParticipantStatsSummary,true,0,1);
            this.yourTeam_txt.visible = true;
            this.enemyTeam_txt.visible = true;
            this.showIcons(false);
         }
         else if(this.stat_rbg.selection === this.player_rb)
         {
            _loc2_ = this.teamPlayerStats;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.drawGraphItem(_loc2_[_loc3_] as PlayerParticipantStatsSummary,false,_loc3_,_loc2_.length);
               _loc3_++;
            }
            _loc2_ = this.otherTeamPlayerStats;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.drawGraphItem(_loc2_[_loc3_] as PlayerParticipantStatsSummary,true,_loc3_,_loc2_.length);
               _loc3_++;
            }
            this.yourTeam_txt.visible = false;
            this.enemyTeam_txt.visible = false;
            this.showIcons(true);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topLeftText() : Text
      {
         return this._1414463927topLeftText;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemCanvas() : Canvas
      {
         return this._1524564555itemCanvas;
      }
      
      public function set bottomLeftText(param1:Text) : void
      {
         var _loc2_:Object = this._1293525279bottomLeftText;
         if(_loc2_ !== param1)
         {
            this._1293525279bottomLeftText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomLeftText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyTeam_txt() : Text
      {
         return this._565581514enemyTeam_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get team_rb() : RadioButton
      {
         return this._1439287470team_rb;
      }
      
      private function _EndOfGameGraph_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = this.friendlyGraphCanvas.x - 70;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.25);
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.friendlyGraphCanvas.x - 70 + this.friendlyGraphCanvas.width * 0.25;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.5);
         _loc1_ = this.friendlyGraphCanvas.x - 70 + this.friendlyGraphCanvas.width * 0.5;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.75);
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.friendlyGraphCanvas.x - 70 + this.friendlyGraphCanvas.width * 0.75;
         _loc1_ = this.maximumStatDisplay;
         _loc1_ = this.enemyGraphCanvas.x - 70;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.25);
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.enemyGraphCanvas.x - 70 + this.enemyGraphCanvas.width * 0.25;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.5);
         _loc1_ = this.enemyGraphCanvas.x - 70 + this.enemyGraphCanvas.width * 0.5;
         _loc1_ = Math.round(this.maximumStatDisplay * 0.75);
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.enemyGraphCanvas.x - 70 + this.enemyGraphCanvas.width * 0.75;
         _loc1_ = this.maximumStatDisplay;
         _loc1_ = this.friendlyGraphCanvas.width * 0.25;
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.friendlyGraphCanvas.width * 0.5;
         _loc1_ = this.friendlyGraphCanvas.width * 0.75;
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = END_OF_GAME_CONCRETE_TEXTURE;
         _loc1_ = this.friendlyGraphCanvas.width * 0.25;
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = this.friendlyGraphCanvas.width * 0.5;
         _loc1_ = this.friendlyGraphCanvas.width * 0.75;
         _loc1_ = this.maximumStatDisplay >= 10;
         _loc1_ = END_OF_GAME_CONCRETE_TEXTURE;
         _loc1_ = this.friendlyGraphCanvas.width - 1;
         _loc1_ = this.friendlyGraphCanvas.x + 1;
         _loc1_ = this.friendlyGraphCanvas.y + 1;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = RiotResourceLoader.getString("endOfGame_grid_player_stats","Player Stats");
         _loc1_ = RiotResourceLoader.getString("endOfGame_grid_team_totals","Team Totals");
      }
      
      [Bindable(event="propertyChange")]
      public function get player_rb() : RadioButton
      {
         return this._1872043954player_rb;
      }
      
      [Bindable(event="propertyChange")]
      public function get texture() : Image
      {
         return this._1417816805texture;
      }
      
      public function set friendlyGraphCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1379247771friendlyGraphCanvas;
         if(_loc2_ !== param1)
         {
            this._1379247771friendlyGraphCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendlyGraphCanvas",_loc2_,param1));
         }
      }
      
      public function set texture(param1:Image) : void
      {
         var _loc2_:Object = this._1417816805texture;
         if(_loc2_ !== param1)
         {
            this._1417816805texture = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"texture",_loc2_,param1));
         }
      }
      
      public function get otherTeamPlayerStats() : ArrayCollection
      {
         return this._endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats as ArrayCollection;
      }
      
      [Bindable(event="propertyChange")]
      public function get texture2() : Image
      {
         return this._1002647945texture2;
      }
      
      [Bindable(event="propertyChange")]
      public function get topMiddleText1() : Text
      {
         return this._1662289030topMiddleText1;
      }
      
      [Bindable(event="propertyChange")]
      public function get topMiddleText3() : Text
      {
         return this._1662289028topMiddleText3;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRightText() : Text
      {
         return this._1855925378bottomRightText;
      }
      
      [Bindable(event="propertyChange")]
      public function get topMiddleText2() : Text
      {
         return this._1662289029topMiddleText2;
      }
      
      [Bindable(event="propertyChange")]
      public function get topGraphBorder() : Image
      {
         return this._904618363topGraphBorder;
      }
      
      public function set radioButtonCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1301142843radioButtonCanvas;
         if(_loc2_ !== param1)
         {
            this._1301142843radioButtonCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"radioButtonCanvas",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameGraph = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameGraph_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGraphWatcherSetupUtil");
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
      
      public function set topLeftText(param1:Text) : void
      {
         var _loc2_:Object = this._1414463927topLeftText;
         if(_loc2_ !== param1)
         {
            this._1414463927topLeftText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topLeftText",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGraph_RadioButtonGroup1_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         this.stat_rbg = _loc1_;
         _loc1_.addEventListener("change",this.__stat_rbg_change);
         _loc1_.initialized(this,"stat_rbg");
         return _loc1_;
      }
      
      public function get maximumStat() : int
      {
         var _loc1_:PlayerStat = null;
         var _loc2_:ArrayCollection = null;
         var _loc3_:int = 0;
         var _loc4_:PlayerStat = null;
         if(this._maximumStat)
         {
            return this._maximumStat;
         }
         this._maximumStat = 0;
         for each(_loc1_ in this.teamPlayerStats[0].statistics)
         {
            if(this.endOfGameTree.selectedStats[_loc1_.statTypeName])
            {
               if(this.stat_rbg.selection === this.team_rb)
               {
                  _loc2_ = new ArrayCollection([this._endOfGameStatsController.combinedTeamStats[0]]);
               }
               else
               {
                  _loc2_ = this.teamPlayerStats;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = PlayerStat.findStat(_loc1_.statTypeName,_loc2_[_loc3_].statistics);
                  if((Boolean(_loc4_)) && _loc4_.value > this._maximumStat)
                  {
                     this._maximumStat = _loc4_.value;
                  }
                  _loc3_++;
               }
               if(this.stat_rbg.selection === this.team_rb)
               {
                  _loc2_ = new ArrayCollection([this._endOfGameStatsController.combinedTeamStats[1]]);
               }
               else
               {
                  _loc2_ = this.otherTeamPlayerStats;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = PlayerStat.findStat(_loc1_.statTypeName,_loc2_[_loc3_].statistics);
                  if((Boolean(_loc4_)) && _loc4_.value > this._maximumStat)
                  {
                     this._maximumStat = _loc4_.value;
                  }
                  _loc3_++;
               }
            }
         }
         this._maximumStat = this.graphRound(this._maximumStat);
         if(this._maximumStat % 2 == 1 && this._maximumStat < 10)
         {
            ++this._maximumStat;
         }
         this.maximumStatDisplay = this._maximumStat;
         return this._maximumStat;
      }
      
      [Bindable(event="propertyChange")]
      public function get maximumStatDisplay() : int
      {
         return this._1276019086maximumStatDisplay;
      }
      
      private function _EndOfGameGraph_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _EndOfGameGraph_Image1.source = param1;
         },"_EndOfGameGraph_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.x - 70;
         },function(param1:Number):void
         {
            topLeftText.x = param1;
         },"topLeftText.x");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.25);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topMiddleText1.text = param1;
         },"topMiddleText1.text");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            topMiddleText1.visible = param1;
         },"topMiddleText1.visible");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.x - 70 + friendlyGraphCanvas.width * 0.25;
         },function(param1:Number):void
         {
            topMiddleText1.x = param1;
         },"topMiddleText1.x");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.5);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topMiddleText2.text = param1;
         },"topMiddleText2.text");
         result[5] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.x - 70 + friendlyGraphCanvas.width * 0.5;
         },function(param1:Number):void
         {
            topMiddleText2.x = param1;
         },"topMiddleText2.x");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.75);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topMiddleText3.text = param1;
         },"topMiddleText3.text");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            topMiddleText3.visible = param1;
         },"topMiddleText3.visible");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.x - 70 + friendlyGraphCanvas.width * 0.75;
         },function(param1:Number):void
         {
            topMiddleText3.x = param1;
         },"topMiddleText3.x");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = maximumStatDisplay;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            topRightText.text = param1;
         },"topRightText.text");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return enemyGraphCanvas.x - 70;
         },function(param1:Number):void
         {
            bottomLeftText.x = param1;
         },"bottomLeftText.x");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.25);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            bottomMiddleText1.text = param1;
         },"bottomMiddleText1.text");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            bottomMiddleText1.visible = param1;
         },"bottomMiddleText1.visible");
         result[13] = binding;
         binding = new Binding(this,function():Number
         {
            return enemyGraphCanvas.x - 70 + enemyGraphCanvas.width * 0.25;
         },function(param1:Number):void
         {
            bottomMiddleText1.x = param1;
         },"bottomMiddleText1.x");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.5);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            bottomMiddleText2.text = param1;
         },"bottomMiddleText2.text");
         result[15] = binding;
         binding = new Binding(this,function():Number
         {
            return enemyGraphCanvas.x - 70 + enemyGraphCanvas.width * 0.5;
         },function(param1:Number):void
         {
            bottomMiddleText2.x = param1;
         },"bottomMiddleText2.x");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = Math.round(maximumStatDisplay * 0.75);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            bottomMiddleText3.text = param1;
         },"bottomMiddleText3.text");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            bottomMiddleText3.visible = param1;
         },"bottomMiddleText3.visible");
         result[18] = binding;
         binding = new Binding(this,function():Number
         {
            return enemyGraphCanvas.x - 70 + enemyGraphCanvas.width * 0.75;
         },function(param1:Number):void
         {
            bottomMiddleText3.x = param1;
         },"bottomMiddleText3.x");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = maximumStatDisplay;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            bottomRightText.text = param1;
         },"bottomRightText.text");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.25;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule1.x = param1;
         },"_EndOfGameGraph_VRule1.x");
         result[21] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            _EndOfGameGraph_VRule1.visible = param1;
         },"_EndOfGameGraph_VRule1.visible");
         result[22] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.5;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule2.x = param1;
         },"_EndOfGameGraph_VRule2.x");
         result[23] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.75;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule3.x = param1;
         },"_EndOfGameGraph_VRule3.x");
         result[24] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            _EndOfGameGraph_VRule3.visible = param1;
         },"_EndOfGameGraph_VRule3.visible");
         result[25] = binding;
         binding = new Binding(this,function():Object
         {
            return END_OF_GAME_CONCRETE_TEXTURE;
         },function(param1:Object):void
         {
            texture.source = param1;
         },"texture.source");
         result[26] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.25;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule4.x = param1;
         },"_EndOfGameGraph_VRule4.x");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            _EndOfGameGraph_VRule4.visible = param1;
         },"_EndOfGameGraph_VRule4.visible");
         result[28] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.5;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule5.x = param1;
         },"_EndOfGameGraph_VRule5.x");
         result[29] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width * 0.75;
         },function(param1:Number):void
         {
            _EndOfGameGraph_VRule6.x = param1;
         },"_EndOfGameGraph_VRule6.x");
         result[30] = binding;
         binding = new Binding(this,function():Boolean
         {
            return maximumStatDisplay >= 10;
         },function(param1:Boolean):void
         {
            _EndOfGameGraph_VRule6.visible = param1;
         },"_EndOfGameGraph_VRule6.visible");
         result[31] = binding;
         binding = new Binding(this,function():Object
         {
            return END_OF_GAME_CONCRETE_TEXTURE;
         },function(param1:Object):void
         {
            texture2.source = param1;
         },"texture2.source");
         result[32] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.width - 1;
         },function(param1:Number):void
         {
            itemCanvas.width = param1;
         },"itemCanvas.width");
         result[33] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.x + 1;
         },function(param1:Number):void
         {
            itemCanvas.x = param1;
         },"itemCanvas.x");
         result[34] = binding;
         binding = new Binding(this,function():Number
         {
            return friendlyGraphCanvas.y + 1;
         },function(param1:Number):void
         {
            itemCanvas.y = param1;
         },"itemCanvas.y");
         result[35] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _EndOfGameGraph_Image6.source = param1;
         },"_EndOfGameGraph_Image6.source");
         result[36] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_grid_player_stats","Player Stats");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            player_rb.label = param1;
         },"player_rb.label");
         result[37] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endOfGame_grid_team_totals","Team Totals");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            team_rb.label = param1;
         },"team_rb.label");
         result[38] = binding;
         return result;
      }
      
      public function set player_rb(param1:RadioButton) : void
      {
         var _loc2_:Object = this._1872043954player_rb;
         if(_loc2_ !== param1)
         {
            this._1872043954player_rb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player_rb",_loc2_,param1));
         }
      }
      
      protected function drawGraphItem(param1:PlayerParticipantStatsSummary, param2:Boolean, param3:int, param4:uint) : void
      {
         var _loc5_:EndOfGameGraphItem = null;
         var _loc6_:Image = null;
         if(this.itemRendererMap[param1.summonerName] == null)
         {
            _loc5_ = new EndOfGameGraphItem();
            _loc5_.height = GRAPH_SECTION_HEIGHT / param4;
            _loc5_.width = this.itemCanvas.width;
            _loc5_.clipContent = false;
            _loc5_.y = param3 * (_loc5_.height + 2);
            if(param2)
            {
               _loc5_.y += 326;
            }
            this.itemCanvas.addChild(_loc5_);
            this.itemRendererMap[param1.summonerName] = _loc5_;
            if(this.stat_rbg.selection === this.player_rb)
            {
               _loc6_ = new Image();
               _loc6_.source = ChampionImages.getIconPath(param1.skinName);
               _loc6_.width = _loc6_.height = 32;
               _loc6_.x = -50;
               _loc6_.y = _loc5_.y + _loc5_.height * 0.5 - _loc6_.height * 0.5;
               _loc6_.toolTip = param1.summonerName;
               this.itemCanvas.addChild(_loc6_);
            }
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.onItemRendererMouseOver,false,0,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.onItemRendererMouseOut,false,0,true);
         }
         else
         {
            _loc5_ = this.itemRendererMap[param1.summonerName];
            _loc5_.visible = true;
         }
         _loc5_.render(param1,this.endOfGameTree.selectedStats,this.maximumStat,this.mousedOverStat);
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyGraphCanvas() : Canvas
      {
         return this._1844395106enemyGraphCanvas;
      }
      
      public function get teamPlayerStats() : ArrayCollection
      {
         return this._endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats as ArrayCollection;
      }
      
      [Bindable(event="propertyChange")]
      public function get friendlyGraphCanvas() : Canvas
      {
         return this._1379247771friendlyGraphCanvas;
      }
      
      public function __stat_rbg_change(param1:Event) : void
      {
         this.endOfGameAccordionClickHandler(null);
      }
      
      public function shouldDrawStatCategory(param1:String) : Boolean
      {
         if(this._endOfGameStatsController.endOfGameStats == null)
         {
            return true;
         }
         var _loc2_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this._endOfGameStatsController.endOfGameStats.gameMutators,this._endOfGameStatsController.endOfGameStats.gameMode);
         return _loc2_.showStatCategory(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get topRightText() : Text
      {
         return this._95755156topRightText;
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         this._endOfGameStatsController = param1;
         if(param1)
         {
            this.itemRendererMap = new Dictionary(true);
            this.maximumStatDisplay = 0;
            this.createTree();
            this.callLater(this.endOfGameAccordionClickHandler,[null]);
            addEventListener(MouseEvent.MOUSE_MOVE,this.onItemRendererMouseMove,false,0,true);
            this.yourTeam_txt.text = param1.combinedTeamStats[0].summonerName;
            this.enemyTeam_txt.text = param1.combinedTeamStats[1].summonerName;
            if(param1.localPlayer != null)
            {
               this.topGraphBorder.source = GREEN_GLOW_OVERLAY;
               this.bottomGraphBorder.source = RED_GLOW_OVERLAY;
            }
            else
            {
               this.topGraphBorder.source = BLUE_GLOW_OVERLAY;
               this.bottomGraphBorder.source = PURPLE_GLOW_OVERLAY;
               this.friendlyGraphCanvas.setStyle("backgroundColor",3607);
               this.enemyGraphCanvas.setStyle("backgroundColor",786450);
            }
         }
         else
         {
            this.onRemovedFromStage();
         }
      }
      
      public function set enemyTeam_txt(param1:Text) : void
      {
         var _loc2_:Object = this._565581514enemyTeam_txt;
         if(_loc2_ !== param1)
         {
            this._565581514enemyTeam_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTeam_txt",_loc2_,param1));
         }
      }
      
      public function set team_rb(param1:RadioButton) : void
      {
         var _loc2_:Object = this._1439287470team_rb;
         if(_loc2_ !== param1)
         {
            this._1439287470team_rb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team_rb",_loc2_,param1));
         }
      }
      
      public function createTree() : void
      {
         this.endOfGameTree = new EndOfGameGraphTree();
         this.endOfGameTree.x = 8;
         this.endOfGameTree.y = 6;
         this.endOfGameTree.width = this.treeCanvas.width - 16;
         this.endOfGameTree.height = this.treeCanvas.height - 12;
         this.endOfGameTree.shouldDrawStatCategoryCallback = this.shouldDrawStatCategory;
         this.endOfGameTree.addEventListener(EndOfGameGraphTree.endOfGameAccordionClick,this.endOfGameAccordionClickHandler,false,0,true);
         this.treeCanvas.addChild(this.endOfGameTree);
         this.endOfGameTree.bindToStats(this.teamPlayerStats[0] as PlayerParticipantStatsSummary);
      }
      
      public function set yourTeam_txt(param1:Text) : void
      {
         var _loc2_:Object = this._2123755233yourTeam_txt;
         if(_loc2_ !== param1)
         {
            this._2123755233yourTeam_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yourTeam_txt",_loc2_,param1));
         }
      }
      
      protected function showItems(param1:Boolean) : void
      {
         var _loc2_:UIComponent = null;
         for each(_loc2_ in this.itemCanvas.getChildren())
         {
            if(_loc2_ is EndOfGameGraphItem)
            {
               _loc2_.visible = param1;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get radioButtonCanvas() : Canvas
      {
         return this._1301142843radioButtonCanvas;
      }
      
      public function set bottomMiddleText1(param1:Text) : void
      {
         var _loc2_:Object = this._326573852bottomMiddleText1;
         if(_loc2_ !== param1)
         {
            this._326573852bottomMiddleText1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomMiddleText1",_loc2_,param1));
         }
      }
      
      public function set bottomMiddleText2(param1:Text) : void
      {
         var _loc2_:Object = this._326573851bottomMiddleText2;
         if(_loc2_ !== param1)
         {
            this._326573851bottomMiddleText2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomMiddleText2",_loc2_,param1));
         }
      }
      
      public function set itemCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1524564555itemCanvas;
         if(_loc2_ !== param1)
         {
            this._1524564555itemCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemCanvas",_loc2_,param1));
         }
      }
      
      public function set stat_rbg(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._1318036428stat_rbg;
         if(_loc2_ !== param1)
         {
            this._1318036428stat_rbg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stat_rbg",_loc2_,param1));
         }
      }
      
      public function set bottomGraphBorder(param1:Image) : void
      {
         var _loc2_:Object = this._431096815bottomGraphBorder;
         if(_loc2_ !== param1)
         {
            this._431096815bottomGraphBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomGraphBorder",_loc2_,param1));
         }
      }
      
      protected function graphRound(param1:Number) : int
      {
         var _loc2_:int = int(param1 / 10000);
         var _loc3_:int = int(param1 % 10000);
         if(Boolean(_loc2_) && _loc3_ < 1000)
         {
            return 1000 + 10000 * _loc2_;
         }
         var _loc4_:int = 1;
         if(_loc3_ >= 1000)
         {
            _loc4_ = 1000;
         }
         else if(_loc3_ >= 100)
         {
            _loc4_ = 100;
         }
         else if(_loc3_ >= 10)
         {
            _loc4_ = 10;
         }
         return Math.ceil(_loc3_ / _loc4_) * _loc4_ + 10000 * _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get yourTeam_txt() : Text
      {
         return this._2123755233yourTeam_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomMiddleText1() : Text
      {
         return this._326573852bottomMiddleText1;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomMiddleText2() : Text
      {
         return this._326573851bottomMiddleText2;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomGraphBorder() : Image
      {
         return this._431096815bottomGraphBorder;
      }
      
      public function set topMiddleText1(param1:Text) : void
      {
         var _loc2_:Object = this._1662289030topMiddleText1;
         if(_loc2_ !== param1)
         {
            this._1662289030topMiddleText1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topMiddleText1",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomMiddleText3() : Text
      {
         return this._326573850bottomMiddleText3;
      }
      
      public function set topMiddleText3(param1:Text) : void
      {
         var _loc2_:Object = this._1662289028topMiddleText3;
         if(_loc2_ !== param1)
         {
            this._1662289028topMiddleText3 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topMiddleText3",_loc2_,param1));
         }
      }
      
      public function set bottomMiddleText3(param1:Text) : void
      {
         var _loc2_:Object = this._326573850bottomMiddleText3;
         if(_loc2_ !== param1)
         {
            this._326573850bottomMiddleText3 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomMiddleText3",_loc2_,param1));
         }
      }
      
      public function set bottomRightText(param1:Text) : void
      {
         var _loc2_:Object = this._1855925378bottomRightText;
         if(_loc2_ !== param1)
         {
            this._1855925378bottomRightText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRightText",_loc2_,param1));
         }
      }
      
      private function onItemRendererMouseOut(param1:Event) : void
      {
         if(this.lastSelecetedStat)
         {
            this.mousedOverStat = null;
            this.lastSelecetedStat = null;
            this.endOfGameAccordionClickHandler(null);
         }
      }
   }
}

