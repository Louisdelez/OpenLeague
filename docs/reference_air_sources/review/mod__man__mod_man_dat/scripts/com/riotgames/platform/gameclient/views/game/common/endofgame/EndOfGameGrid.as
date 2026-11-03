package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.components.containers.RiotCanvas;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGameGrid extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const BLUE_GLOW_OVERLAY:Class = EndOfGameGrid_BLUE_GLOW_OVERLAY;
      
      public static const GREEN_GLOW_OVERLAY:Class = EndOfGameGrid_GREEN_GLOW_OVERLAY;
      
      public static const PURPLE_GLOW_OVERLAY:Class = EndOfGameGrid_PURPLE_GLOW_OVERLAY;
      
      public static const RED_GLOW_OVERLAY:Class = EndOfGameGrid_RED_GLOW_OVERLAY;
      
      public static const END_OF_GAME_CONCRETE_TEXTURE:Class = EndOfGameGrid_END_OF_GAME_CONCRETE_TEXTURE;
      
      private static const HEADER_HEIGHT:int = 41;
      
      private static const HEADER_WIDTH:int = 75;
      
      private static const MIN_COLUMN_HEIGHT:int = 460;
      
      private var _2124637195dataColumnsCanvas:RiotCanvas;
      
      private var _2029774044mainColumnBox:HBox;
      
      private var _915690533rightTeamBorder:Image;
      
      private var _371292177enemyTeamLabel:Label;
      
      private var _1977284811headerList:EndOfGameGridColumn;
      
      private var _endOfGameStatsController:EndOfGameStatsController;
      
      private var headerHeightChangeWatcher:ChangeWatcher;
      
      private var _230149499selectorRow:ConstraintRow;
      
      private var _597686085mainGridRow:ConstraintRow;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _284903399glowBorder:Image;
      
      private var _531485485dataColumns:ConstraintColumn;
      
      private var _1529964101headerCanvas:HBox;
      
      private var _877612163enemyCheckBoxCanvas:Canvas;
      
      private var _334559152leftTeamBorder:Image;
      
      private var _496851304teamCheckBoxCanvas:Canvas;
      
      mx_internal var _watchers:Array = [];
      
      private var _1977306905headerMask:Canvas;
      
      public var _EndOfGameGrid_Image2:Image;
      
      public var _EndOfGameGrid_Image4:Image;
      
      private var _1706272635headerColumnCanvas:Canvas;
      
      private var _1542833219headerColumn:ConstraintColumn;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _193839465teamLabel:Label;
      
      private var _1870012318titleRow:ConstraintRow;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"headerColumnCanvas",
               "events":{"mouseWheel":"__headerColumnCanvas_mouseWheel"},
               "stylesFactory":function():void
               {
                  this.left = "headerColumn:0";
                  this.right = "headerColumn:0";
                  this.top = "mainGridRow:0";
                  this.bottom = "mainGridRow:4";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":EndOfGameGridColumn,
                        "id":"headerList",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "titleColumn":true,
                              "width":275,
                              "teamMembership":"neutral"
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":RiotCanvas,
               "id":"dataColumnsCanvas",
               "events":{"scroll":"__dataColumnsCanvas_scroll"},
               "stylesFactory":function():void
               {
                  this.left = "dataColumns:0";
                  this.right = "dataColumns:0";
                  this.top = "mainGridRow:0";
                  this.bottom = "mainGridRow:4";
                  this.verticalScrollBarStyleName = "blueGlassScrollBar";
                  this.whiteBoxEnabled = true;
                  this.whiteBoxColor = 4123;
                  this.whiteBoxAlpha = 0.3;
                  this.horizontalScrollBarStyleName = "blueGlassScrollBar";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":HBox,
                     "id":"mainColumnBox",
                     "stylesFactory":function():void
                     {
                        this.horizontalGap = 0;
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":HBox,
               "id":"headerCanvas",
               "stylesFactory":function():void
               {
                  this.horizontalGap = 0;
               },
               "propertiesFactory":function():Object
               {
                  return {"percentWidth":100};
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"headerMask",
               "stylesFactory":function():void
               {
                  this.left = "dataColumns:0";
                  this.top = "0";
                  this.backgroundAlpha = 0;
                  this.backgroundColor = 16777215;
               },
               "propertiesFactory":function():Object
               {
                  return {"visible":false};
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"teamCheckBoxCanvas",
               "stylesFactory":function():void
               {
                  this.top = "selectorRow:7";
                  this.left = "0";
                  this.bottom = "0";
                  this.backgroundAlpha = 1;
                  this.backgroundColor = 200715;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":404,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"teamLabel",
                        "stylesFactory":function():void
                        {
                           this.top = "4";
                           this.left = "5";
                           this.fontFamily = "ApplicationFont2";
                           this.color = 16777215;
                           this.fontSize = 16;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"blueCheckBox"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"leftTeamBorder",
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
                        "type":Canvas,
                        "stylesFactory":function():void
                        {
                           this.left = "5";
                           this.right = "5";
                           this.top = "30";
                           this.bottom = "5";
                           this.backgroundAlpha = 1;
                           this.backgroundColor = 265495;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameGrid_Image2",
                        "stylesFactory":function():void
                        {
                           this.left = "5";
                           this.right = "5";
                           this.top = "30";
                           this.bottom = "5";
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
               "type":Canvas,
               "id":"enemyCheckBoxCanvas",
               "stylesFactory":function():void
               {
                  this.top = "selectorRow:7";
                  this.bottom = "0";
                  this.right = "0";
                  this.backgroundAlpha = 1;
                  this.backgroundColor = 853769;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":404,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"enemyTeamLabel",
                        "stylesFactory":function():void
                        {
                           this.top = "4";
                           this.left = "5";
                           this.fontFamily = "ApplicationFont2";
                           this.color = 16777215;
                           this.fontSize = 16;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"blueCheckBox"};
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"rightTeamBorder",
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
                        "type":Canvas,
                        "stylesFactory":function():void
                        {
                           this.left = "5";
                           this.right = "5";
                           this.top = "30";
                           this.bottom = "5";
                           this.backgroundAlpha = 1;
                           this.backgroundColor = 265495;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameGrid_Image4",
                        "stylesFactory":function():void
                        {
                           this.left = "5";
                           this.right = "5";
                           this.top = "30";
                           this.bottom = "5";
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
               "type":Image,
               "id":"glowBorder",
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.right = "0";
                  this.top = "0";
                  this.bottom = "mainGridRow:3";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "maintainAspectRatio":false,
                     "mouseEnabled":false,
                     "mouseChildren":false
                  };
               }
            })]};
         }
      });
      
      public function EndOfGameGrid()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._EndOfGameGrid_ConstraintColumn1_i(),this._EndOfGameGrid_ConstraintColumn2_i()];
         this.constraintRows = [this._EndOfGameGrid_ConstraintRow1_i(),this._EndOfGameGrid_ConstraintRow2_i(),this._EndOfGameGrid_ConstraintRow3_i()];
         this.addEventListener("show",this.___EndOfGameGrid_Canvas1_show);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameGrid._watcherSetupUtil = param1;
      }
      
      public function set selectorRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._230149499selectorRow;
         if(_loc2_ !== param1)
         {
            this._230149499selectorRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectorRow",_loc2_,param1));
         }
      }
      
      public function set enemyCheckBoxCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._877612163enemyCheckBoxCanvas;
         if(_loc2_ !== param1)
         {
            this._877612163enemyCheckBoxCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyCheckBoxCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dataColumnsCanvas() : RiotCanvas
      {
         return this._2124637195dataColumnsCanvas;
      }
      
      private function validateHeaderSizes() : void
      {
         var _loc1_:EndOfGameGridColumn = this.mainColumnBox.getChildAt(0) as EndOfGameGridColumn;
         if(_loc1_.height > 0)
         {
            this.headerList.height = this.mainColumnBox.getChildAt(0).height;
         }
         if(this.dataColumnsCanvas.horizontalScrollBar)
         {
            if(!this.headerList.bufferEnabled)
            {
               this.headerList.height += this.dataColumnsCanvas.horizontalScrollBar.height;
            }
            else
            {
               this.dataColumnsCanvas.verticalScrollPolicy = ScrollPolicy.OFF;
            }
         }
         if(this.dataColumnsCanvas.verticalScrollPolicy != ScrollPolicy.OFF && Boolean(this.dataColumnsCanvas.verticalScrollBar))
         {
            this.headerMask.width = this.dataColumns.width - this.dataColumnsCanvas.verticalScrollBar.width;
         }
         else
         {
            this.headerMask.width = this.dataColumns.width;
         }
         this.onDataColumnScroll();
      }
      
      public function set dataColumnsCanvas(param1:RiotCanvas) : void
      {
         var _loc2_:Object = this._2124637195dataColumnsCanvas;
         if(_loc2_ !== param1)
         {
            this._2124637195dataColumnsCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataColumnsCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get glowBorder() : Image
      {
         return this._284903399glowBorder;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerMask() : Canvas
      {
         return this._1977306905headerMask;
      }
      
      public function __headerColumnCanvas_mouseWheel(param1:MouseEvent) : void
      {
         this.headerColumnCanvasMouseWheelHandler(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get rightTeamBorder() : Image
      {
         return this._915690533rightTeamBorder;
      }
      
      public function set teamLabel(param1:Label) : void
      {
         var _loc2_:Object = this._193839465teamLabel;
         if(_loc2_ !== param1)
         {
            this._193839465teamLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamLabel",_loc2_,param1));
         }
      }
      
      public function set glowBorder(param1:Image) : void
      {
         var _loc2_:Object = this._284903399glowBorder;
         if(_loc2_ !== param1)
         {
            this._284903399glowBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glowBorder",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGrid_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.dataColumns = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"dataColumns");
         return _loc1_;
      }
      
      public function ___EndOfGameGrid_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      public function set headerMask(param1:Canvas) : void
      {
         var _loc2_:Object = this._1977306905headerMask;
         if(_loc2_ !== param1)
         {
            this._1977306905headerMask = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerMask",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGrid_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.mainGridRow = _loc1_;
         _loc1_.height = 506;
         _loc1_.initialized(this,"mainGridRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerColumn() : ConstraintColumn
      {
         return this._1542833219headerColumn;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerCanvas() : HBox
      {
         return this._1529964101headerCanvas;
      }
      
      public function set teamCheckBoxCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._496851304teamCheckBoxCanvas;
         if(_loc2_ !== param1)
         {
            this._496851304teamCheckBoxCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamCheckBoxCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftTeamBorder() : Image
      {
         return this._334559152leftTeamBorder;
      }
      
      private function drawSingleHeader(param1:PlayerParticipantStatsSummary, param2:int = 0) : void
      {
         var _loc8_:Image = null;
         var _loc9_:TextField = null;
         var _loc10_:TextFormat = null;
         var _loc3_:UIComponent = new UIComponent();
         _loc3_.height = HEADER_HEIGHT;
         _loc3_.width = HEADER_WIDTH;
         _loc3_.name = param1.summonerName;
         var _loc4_:Canvas = new Canvas();
         _loc4_.width = _loc3_.width;
         _loc4_.height = _loc3_.height;
         _loc4_.setStyle("backgroundColor",param2);
         _loc4_.setStyle("backgroundAlpha",1);
         _loc3_.addChild(_loc4_);
         var _loc5_:Image = new Image();
         _loc5_.source = END_OF_GAME_CONCRETE_TEXTURE;
         _loc5_.width = _loc3_.width;
         _loc5_.height = _loc3_.height;
         _loc5_.maintainAspectRatio = false;
         _loc5_.blendMode = BlendMode.OVERLAY;
         _loc5_.alpha = 0.48;
         _loc3_.addChild(_loc5_);
         if(param1)
         {
            if(param1.skinName)
            {
               _loc8_ = new Image();
               _loc8_.source = ChampionImages.getIconPath(param1.skinName);
               _loc8_.width = _loc8_.height = 32;
               _loc8_.x = _loc3_.width * 0.5 - _loc8_.width * 0.5;
               _loc8_.y = _loc3_.height * 0.5 - _loc8_.height * 0.5;
               _loc8_.toolTip = param1.summonerName;
               _loc3_.addChild(_loc8_);
            }
            else
            {
               _loc9_ = new TextField();
               _loc10_ = new TextFormat();
               _loc10_.font = "ApplicationFont2";
               _loc10_.size = 14;
               _loc10_.color = 16777215;
               _loc10_.align = TextFormatAlign.CENTER;
               _loc9_.defaultTextFormat = _loc10_;
               _loc9_.selectable = false;
               _loc9_.wordWrap = true;
               _loc9_.text = param1.summonerName;
               _loc9_.embedFonts = true;
               _loc9_.width = 70;
               _loc9_.height = _loc9_.textHeight + 4;
               _loc9_.x = 37 - _loc9_.width * 0.5;
               _loc9_.y = HEADER_HEIGHT * 0.5 - _loc9_.height * 0.5;
               _loc3_.addChild(_loc9_);
            }
         }
         var _loc6_:Canvas = new Canvas();
         _loc6_.height = _loc3_.height;
         _loc6_.width = _loc3_.width;
         _loc3_.addChild(_loc6_);
         this.headerCanvas.addChild(_loc3_);
         var _loc7_:Graphics = _loc6_.graphics;
         _loc7_.lineStyle(1,16777215,0.2);
         _loc7_.moveTo(_loc3_.width - 1,0);
         _loc7_.lineTo(_loc3_.width - 1,HEADER_HEIGHT);
         _loc7_.moveTo(0,HEADER_HEIGHT - 1);
         _loc7_.lineTo(_loc3_.width - 1,HEADER_HEIGHT - 1);
      }
      
      public function __dataColumnsCanvas_scroll(param1:ScrollEvent) : void
      {
         callLater(this.onDataColumnScroll);
      }
      
      [Bindable(event="propertyChange")]
      public function get titleRow() : ConstraintRow
      {
         return this._1870012318titleRow;
      }
      
      private function _EndOfGameGrid_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.titleRow = _loc1_;
         _loc1_.height = 0;
         _loc1_.initialized(this,"titleRow");
         return _loc1_;
      }
      
      protected function ResetView() : void
      {
         var _loc2_:EndOfGameGridCheckBox = null;
         this.headerList.data = null;
         this.headerCanvas.x = 0;
         this.mainColumnBox.removeAllChildren();
         this.headerCanvas.removeAllChildren();
         var _loc1_:* = 0;
         while(_loc1_ < this.teamCheckBoxCanvas.rawChildren.numChildren)
         {
            _loc2_ = this.teamCheckBoxCanvas.rawChildren.getChildAt(_loc1_) as EndOfGameGridCheckBox;
            if(_loc2_)
            {
               this.teamCheckBoxCanvas.rawChildren.removeChild(_loc2_);
               _loc1_--;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.enemyCheckBoxCanvas.rawChildren.numChildren)
         {
            _loc2_ = this.enemyCheckBoxCanvas.rawChildren.getChildAt(_loc1_) as EndOfGameGridCheckBox;
            if(_loc2_)
            {
               this.enemyCheckBoxCanvas.rawChildren.removeChild(_loc2_);
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      public function set mainGridRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._597686085mainGridRow;
         if(_loc2_ !== param1)
         {
            this._597686085mainGridRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainGridRow",_loc2_,param1));
         }
      }
      
      public function set rightTeamBorder(param1:Image) : void
      {
         var _loc2_:Object = this._915690533rightTeamBorder;
         if(_loc2_ !== param1)
         {
            this._915690533rightTeamBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightTeamBorder",_loc2_,param1));
         }
      }
      
      protected function headerColumnCanvasMouseWheelHandler(param1:MouseEvent) : void
      {
         if(this.dataColumnsCanvas.verticalScrollPolicy != ScrollPolicy.OFF)
         {
            this.dataColumnsCanvas.verticalScrollPosition -= param1.delta * this.dataColumnsCanvas.verticalLineScrollSize;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerColumnCanvas() : Canvas
      {
         return this._1706272635headerColumnCanvas;
      }
      
      private function onShow() : void
      {
         this.validateHeaderSizes();
      }
      
      [Bindable(event="propertyChange")]
      public function get selectorRow() : ConstraintRow
      {
         return this._230149499selectorRow;
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyCheckBoxCanvas() : Canvas
      {
         return this._877612163enemyCheckBoxCanvas;
      }
      
      public function set headerColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1542833219headerColumn;
         if(_loc2_ !== param1)
         {
            this._1542833219headerColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerColumn",_loc2_,param1));
         }
      }
      
      public function set headerCanvas(param1:HBox) : void
      {
         var _loc2_:Object = this._1529964101headerCanvas;
         if(_loc2_ !== param1)
         {
            this._1529964101headerCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerCanvas",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameGrid = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameGrid_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridWatcherSetupUtil");
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
      
      private function onCheckboxChanged(param1:Event) : void
      {
         var _loc3_:EndOfGameGridColumn = null;
         var _loc4_:UIComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.mainColumnBox.numChildren)
         {
            _loc3_ = this.mainColumnBox.getChildAt(_loc2_) as EndOfGameGridColumn;
            if(param1.target.data.summonerName == _loc3_.data.summonerName)
            {
               _loc3_.includeInLayout = _loc3_.visible = param1.target.selected;
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.headerCanvas.numChildren)
         {
            _loc4_ = this.headerCanvas.getChildAt(_loc2_) as UIComponent;
            if(param1.target.data.summonerName == _loc4_.name)
            {
               _loc4_.includeInLayout = _loc4_.visible = param1.target.selected;
               break;
            }
            _loc2_++;
         }
         callLater(this.validateHeaderSizes);
         callLater(this.onDataColumnScroll);
      }
      
      private function onDataColumnScroll() : void
      {
         this.headerCanvas.x = -this.dataColumnsCanvas.horizontalScrollPosition;
         if(this.headerCanvas.x > 0)
         {
            this.headerCanvas.x = 0;
         }
         else if(this.headerCanvas.x < -this.dataColumnsCanvas.maxHorizontalScrollPosition)
         {
            this.headerCanvas.x = -this.dataColumnsCanvas.maxHorizontalScrollPosition;
         }
      }
      
      private function _EndOfGameGrid_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.headerColumn = _loc1_;
         _loc1_.width = 275;
         _loc1_.initialized(this,"headerColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamLabel() : Label
      {
         return this._193839465teamLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamCheckBoxCanvas() : Canvas
      {
         return this._496851304teamCheckBoxCanvas;
      }
      
      public function set leftTeamBorder(param1:Image) : void
      {
         var _loc2_:Object = this._334559152leftTeamBorder;
         if(_loc2_ !== param1)
         {
            this._334559152leftTeamBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftTeamBorder",_loc2_,param1));
         }
      }
      
      private function isExtendedTeamSize(param1:ArrayCollection) : Boolean
      {
         return param1 != null && param1.length > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
      }
      
      public function set dataColumns(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._531485485dataColumns;
         if(_loc2_ !== param1)
         {
            this._531485485dataColumns = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataColumns",_loc2_,param1));
         }
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
      
      private function drawGrid() : void
      {
         var _loc2_:int = 0;
         var _loc4_:EndOfGameGridColumn = null;
         var _loc5_:PlayerParticipantStatsSummary = null;
         var _loc6_:EndOfGameGridCheckBox = null;
         this.drawHeaderListHeaderSpace();
         var _loc1_:Spacer = new Spacer();
         _loc1_.width = this.headerColumn.width;
         this.headerCanvas.addChild(_loc1_);
         if(this.isExtendedTeamSize(this._endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats) || this.isExtendedTeamSize(this._endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats))
         {
            _loc2_ = 20;
         }
         else
         {
            _loc2_ = 25;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats.length)
         {
            _loc5_ = this._endOfGameStatsController.endOfGameStats.teamPlayerParticipantStats[_loc3_];
            _loc4_ = this.createEndOfGameGridColumn();
            if(this._endOfGameStatsController.localPlayer != null)
            {
               _loc4_.teamMembership = EndOfGameGridColumn.FRIENDLY_TEAM_MEMBERSHIP;
            }
            else
            {
               _loc4_.teamMembership = EndOfGameGridColumn.BLUE_TEAM_MEMBERSHIP;
            }
            _loc4_.width = 75;
            _loc4_.minHeight = MIN_COLUMN_HEIGHT;
            _loc4_.data = _loc5_;
            this.mainColumnBox.addChild(_loc4_);
            this.drawSingleHeader(_loc5_,_loc4_.backgroundColor);
            _loc6_ = new EndOfGameGridCheckBox();
            _loc6_.selected = true;
            _loc6_.addEventListener(Event.CHANGE,this.onCheckboxChanged,false,0,true);
            _loc6_.x = 15;
            _loc6_.y = 38 + _loc2_ * _loc3_;
            _loc6_.data = _loc5_;
            this.teamCheckBoxCanvas.addChild(_loc6_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats.length)
         {
            _loc5_ = this._endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats[_loc3_];
            _loc4_ = this.createEndOfGameGridColumn();
            if(this._endOfGameStatsController.localPlayer != null)
            {
               _loc4_.teamMembership = EndOfGameGridColumn.ENEMY_TEAM_MEMBERSHIP;
            }
            else
            {
               _loc4_.teamMembership = EndOfGameGridColumn.PURPLE_TEAM_MEMBERSHIP;
            }
            _loc4_.width = 75;
            _loc4_.minHeight = MIN_COLUMN_HEIGHT;
            _loc4_.data = _loc5_;
            this.mainColumnBox.addChild(_loc4_);
            this.drawSingleHeader(_loc5_,_loc4_.backgroundColor);
            _loc6_ = new EndOfGameGridCheckBox();
            _loc6_.selected = true;
            _loc6_.addEventListener(Event.CHANGE,this.onCheckboxChanged,false,0,true);
            _loc6_.x = 15;
            _loc6_.y = 38 + _loc2_ * _loc3_;
            _loc6_.data = _loc5_;
            this.enemyCheckBoxCanvas.addChild(_loc6_);
            _loc3_++;
         }
         _loc4_ = this.createEndOfGameGridColumn();
         if(this._endOfGameStatsController.localPlayer != null)
         {
            _loc4_.teamMembership = EndOfGameGridColumn.FRIENDLY_TEAM_MEMBERSHIP;
         }
         else
         {
            _loc4_.teamMembership = EndOfGameGridColumn.BLUE_TEAM_MEMBERSHIP;
         }
         _loc4_.width = 75;
         _loc4_.minHeight = MIN_COLUMN_HEIGHT;
         _loc4_.data = this._endOfGameStatsController.combinedTeamStats[0];
         this.mainColumnBox.addChild(_loc4_);
         this.drawSingleHeader(this._endOfGameStatsController.combinedTeamStats[0],_loc4_.backgroundColor);
         if(this._endOfGameStatsController.endOfGameStats.otherTeamPlayerParticipantStats.length > 0)
         {
            _loc4_ = this.createEndOfGameGridColumn();
            if(this._endOfGameStatsController.localPlayer != null)
            {
               _loc4_.teamMembership = EndOfGameGridColumn.ENEMY_TEAM_MEMBERSHIP;
            }
            else
            {
               _loc4_.teamMembership = EndOfGameGridColumn.PURPLE_TEAM_MEMBERSHIP;
            }
            _loc4_.width = 75;
            _loc4_.minHeight = MIN_COLUMN_HEIGHT;
            _loc4_.data = this._endOfGameStatsController.combinedTeamStats[1];
            this.mainColumnBox.addChild(_loc4_);
            this.drawSingleHeader(this._endOfGameStatsController.combinedTeamStats[1],_loc4_.backgroundColor);
         }
         this.headerCanvas.x = 0;
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         var _loc2_:EndOfGameGridColumn = null;
         this._endOfGameStatsController = param1;
         this.ResetView();
         if(param1)
         {
            this.headerList.shouldDrawStatCategoryCallback = this.shouldDrawStatCategory;
            this.headerList.data = this._endOfGameStatsController.combinedTeamStats[0];
            this.teamLabel.text = this._endOfGameStatsController.combinedTeamStats[0].summonerName;
            this.enemyTeamLabel.text = this._endOfGameStatsController.combinedTeamStats[1].summonerName;
            this.drawGrid();
            _loc2_ = this.mainColumnBox.getChildAt(0) as EndOfGameGridColumn;
            this.headerColumnCanvas.verticalScrollPosition = 0;
            if(param1.localPlayer != null)
            {
               this.leftTeamBorder.source = GREEN_GLOW_OVERLAY;
               this.rightTeamBorder.source = RED_GLOW_OVERLAY;
            }
            else
            {
               this.leftTeamBorder.source = BLUE_GLOW_OVERLAY;
               this.rightTeamBorder.source = PURPLE_GLOW_OVERLAY;
               this.teamCheckBoxCanvas.setStyle("backgroundColor",3607);
               this.enemyCheckBoxCanvas.setStyle("backgroundColor",786450);
            }
            callLater(this.validateHeaderSizes);
         }
      }
      
      public function set headerList(param1:EndOfGameGridColumn) : void
      {
         var _loc2_:Object = this._1977284811headerList;
         if(_loc2_ !== param1)
         {
            this._1977284811headerList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerList",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGrid_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return dataColumnsCanvas.verticalScrollPosition;
         },function(param1:Number):void
         {
            headerColumnCanvas.verticalScrollPosition = param1;
         },"headerColumnCanvas.verticalScrollPosition");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_HEIGHT - 1;
         },function(param1:Number):void
         {
            headerList.y = param1;
         },"headerList.y");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return MIN_COLUMN_HEIGHT;
         },function(param1:Number):void
         {
            headerList.minHeight = param1;
         },"headerList.minHeight");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_HEIGHT - 1;
         },function(param1:Number):void
         {
            mainColumnBox.y = param1;
         },"mainColumnBox.y");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_HEIGHT;
         },function(param1:Number):void
         {
            headerCanvas.height = param1;
         },"headerCanvas.height");
         result[4] = binding;
         binding = new Binding(this,function():DisplayObject
         {
            return headerMask;
         },function(param1:DisplayObject):void
         {
            headerCanvas.mask = param1;
         },"headerCanvas.mask");
         result[5] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_HEIGHT;
         },function(param1:Number):void
         {
            headerMask.height = param1;
         },"headerMask.height");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _EndOfGameGrid_Image2.source = param1;
         },"_EndOfGameGrid_Image2.source");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _EndOfGameGrid_Image4.source = param1;
         },"_EndOfGameGrid_Image4.source");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            glowBorder.source = param1;
         },"glowBorder.source");
         result[9] = binding;
         return result;
      }
      
      public function set mainColumnBox(param1:HBox) : void
      {
         var _loc2_:Object = this._2029774044mainColumnBox;
         if(_loc2_ !== param1)
         {
            this._2029774044mainColumnBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainColumnBox",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainGridRow() : ConstraintRow
      {
         return this._597686085mainGridRow;
      }
      
      public function set titleRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1870012318titleRow;
         if(_loc2_ !== param1)
         {
            this._1870012318titleRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleRow",_loc2_,param1));
         }
      }
      
      private function drawHeaderListHeaderSpace() : void
      {
         var _loc1_:UIComponent = new UIComponent();
         _loc1_.height = HEADER_HEIGHT;
         _loc1_.width = this.headerColumn.width;
         var _loc2_:Canvas = new Canvas();
         _loc2_.width = _loc1_.width;
         _loc2_.height = _loc1_.height;
         _loc2_.setStyle("backgroundColor",265495);
         _loc2_.setStyle("backgroundAlpha",1);
         _loc1_.addChild(_loc2_);
         var _loc3_:Image = new Image();
         _loc3_.source = END_OF_GAME_CONCRETE_TEXTURE;
         _loc3_.width = _loc1_.width;
         _loc3_.height = _loc1_.height;
         _loc3_.maintainAspectRatio = false;
         _loc3_.blendMode = BlendMode.OVERLAY;
         _loc3_.alpha = 0.48;
         _loc1_.addChild(_loc3_);
         var _loc4_:Canvas = new Canvas();
         _loc4_.height = _loc1_.height;
         _loc4_.width = _loc1_.width;
         _loc1_.addChild(_loc4_);
         this.addChildAt(_loc1_,this.getChildIndex(this.glowBorder) - 1);
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.lineStyle(1,16777215,0.2);
         _loc5_.moveTo(_loc1_.width - 1,0);
         _loc5_.lineTo(_loc1_.width - 1,HEADER_HEIGHT);
         _loc5_.moveTo(0,HEADER_HEIGHT - 1);
         _loc5_.lineTo(_loc1_.width - 1,HEADER_HEIGHT - 1);
      }
      
      [Bindable(event="propertyChange")]
      public function get headerList() : EndOfGameGridColumn
      {
         return this._1977284811headerList;
      }
      
      [Bindable(event="propertyChange")]
      public function get dataColumns() : ConstraintColumn
      {
         return this._531485485dataColumns;
      }
      
      [Bindable(event="propertyChange")]
      public function get mainColumnBox() : HBox
      {
         return this._2029774044mainColumnBox;
      }
      
      public function set enemyTeamLabel(param1:Label) : void
      {
         var _loc2_:Object = this._371292177enemyTeamLabel;
         if(_loc2_ !== param1)
         {
            this._371292177enemyTeamLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enemyTeamLabel",_loc2_,param1));
         }
      }
      
      private function createEndOfGameGridColumn() : EndOfGameGridColumn
      {
         var _loc1_:EndOfGameGridColumn = new EndOfGameGridColumn();
         _loc1_.shouldDrawStatCategoryCallback = this.shouldDrawStatCategory;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get enemyTeamLabel() : Label
      {
         return this._371292177enemyTeamLabel;
      }
      
      private function _EndOfGameGrid_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.selectorRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"selectorRow");
         return _loc1_;
      }
      
      private function _EndOfGameGrid_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.dataColumnsCanvas.verticalScrollPosition;
         _loc1_ = HEADER_HEIGHT - 1;
         _loc1_ = MIN_COLUMN_HEIGHT;
         _loc1_ = HEADER_HEIGHT - 1;
         _loc1_ = HEADER_HEIGHT;
         _loc1_ = this.headerMask;
         _loc1_ = HEADER_HEIGHT;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = BLUE_GLOW_OVERLAY;
      }
      
      public function set headerColumnCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1706272635headerColumnCanvas;
         if(_loc2_ !== param1)
         {
            this._1706272635headerColumnCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerColumnCanvas",_loc2_,param1));
         }
      }
   }
}

