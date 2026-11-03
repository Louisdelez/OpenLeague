package com.riotgames.platform.gameclient.components.summoner
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
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
   import mx.containers.VBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.FlexNativeMenu;
   import mx.controls.Image;
   import mx.controls.Menu;
   import mx.controls.Text;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.FlexNativeMenuEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SummonerQuickView extends Canvas implements IBindingClient, IMenuItemRenderer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _isUserBlocked:Boolean;
      
      private var _1712502929imageColumn:ConstraintColumn;
      
      private var _2030596687rankedQueueName:String = "";
      
      private var menuXML:XML;
      
      private var _695259115normalWinsText:String = "";
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _1661447317rankedRatingText:String = "";
      
      private var _511756277centerColumn:ConstraintColumn;
      
      private var _3559906tier:String;
      
      private var isMe:Boolean;
      
      protected var _936395889playerLevelInfo:String;
      
      private var _269111509statsColumn:ConstraintColumn;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _1804364382playerLevelInfo_txt:Text;
      
      [Inject]
      public var privacyListController:PrivacyListController;
      
      private var _868055995topRow:ConstraintRow;
      
      protected var _1714148973displayName:String;
      
      private var _1943016241rankedWinsText:String = "";
      
      mx_internal var _watchers:Array;
      
      private var itemContextMenu:FlexNativeMenu;
      
      private var _1816216387playerName_txt:Text;
      
      public var _SummonerQuickView_Text3:Text;
      
      public var _SummonerQuickView_Text4:Text;
      
      private var _909875815normalGamesText:Text;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _2096171365player_img:SummonerIcon;
      
      mx_internal var _bindings:Array;
      
      protected var _1730538681areStatsVisible:Boolean;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public var _SummonerQuickView_Image1:Image;
      
      protected var _1714654783playerImagePath:BitmapData;
      
      public function SummonerQuickView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {
                  "height":60,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Image,
                     "id":"_SummonerQuickView_Image1",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "x":0,
                           "y":0,
                           "percentWidth":100,
                           "percentHeight":100,
                           "maintainAspectRatio":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SummonerIcon,
                     "id":"player_img",
                     "stylesFactory":function():void
                     {
                        this.left = "imageColumn:5";
                        this.verticalCenter = "0";
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"playerName_txt",
                     "stylesFactory":function():void
                     {
                        this.left = "centerColumn:4";
                        this.right = "centerColumn:0";
                        this.top = "5";
                        this.fontFamily = "ApplicationFont2";
                        this.color = 13421772;
                        this.fontSize = 16;
                        this.fontWeight = "normal";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"selectable":false};
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"playerLevelInfo_txt",
                     "stylesFactory":function():void
                     {
                        this.left = "centerColumn:4";
                        this.right = "centerColumn:0";
                        this.top = "22";
                        this.fontFamily = "ApplicationFont2";
                        this.color = 13421772;
                        this.fontSize = 12;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {"selectable":false};
                     }
                  }),new UIComponentDescriptor({
                     "type":VBox,
                     "stylesFactory":function():void
                     {
                        this.right = "5";
                        this.verticalCenter = "0";
                        this.verticalGap = -3;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "horizontalScrollPolicy":"off",
                           "verticalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Text,
                              "id":"_SummonerQuickView_Text3",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "right";
                                 this.fontFamily = "ApplicationFont2";
                                 this.color = 13421772;
                                 this.fontSize = 11;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {"selectable":false};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"_SummonerQuickView_Text4",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "right";
                                 this.fontFamily = "ApplicationFont2";
                                 this.color = 13421772;
                                 this.fontSize = 11;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {"selectable":false};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"normalGamesText",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "right";
                                 this.fontFamily = "ApplicationFont2";
                                 this.color = 13421772;
                                 this.fontSize = 11;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {"selectable":false};
                              }
                           })]
                        };
                     }
                  })]
               };
            }
         });
         this.menuXML = <root>
						<menuitem label='**Block' data='blockUser'/>
						<menuitem label='**Add Buddy' data='addBudy'/>
					</root>;
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
            this.borderStyle = "none";
         };
         this.cacheAsBitmap = true;
         this.height = 60;
         this.percentWidth = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._SummonerQuickView_ConstraintColumn1_i(),this._SummonerQuickView_ConstraintColumn2_i(),this._SummonerQuickView_ConstraintColumn3_i()];
         this.constraintRows = [this._SummonerQuickView_ConstraintRow1_i(),this._SummonerQuickView_ConstraintRow2_i()];
         this.addEventListener("initialize",this.___SummonerQuickView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerQuickView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get centerColumn() : ConstraintColumn
      {
         return this._511756277centerColumn;
      }
      
      private function createContextMenu() : void
      {
         this.itemContextMenu = new FlexNativeMenu();
         this.itemContextMenu.labelField = "@label";
         this.itemContextMenu.showRoot = false;
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK,this.onContextMenuClick);
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.MENU_SHOW,this.onContextMenuShow);
         this.itemContextMenu.setContextMenu(this);
         this.itemContextMenu.dataProvider = this.menuXML;
      }
      
      public function set centerColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._511756277centerColumn;
         if(_loc2_ !== param1)
         {
            this._511756277centerColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerColumn",_loc2_,param1));
         }
      }
      
      private function get isUserBlocked() : Boolean
      {
         return this._isUserBlocked;
      }
      
      public function set imageColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1712502929imageColumn;
         if(_loc2_ !== param1)
         {
            this._1712502929imageColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageColumn",_loc2_,param1));
         }
      }
      
      private function set rankedRatingText(param1:String) : void
      {
         var _loc2_:Object = this._1661447317rankedRatingText;
         if(_loc2_ !== param1)
         {
            this._1661447317rankedRatingText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRatingText",_loc2_,param1));
         }
      }
      
      private function set isUserBlocked(param1:Boolean) : void
      {
         if(param1 != this._isUserBlocked)
         {
            this._isUserBlocked = param1;
            this.updateIcon();
         }
      }
      
      private function _SummonerQuickView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 50;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      [Bindable(event="propertyChange")]
      protected function get areStatsVisible() : Boolean
      {
         return this._1730538681areStatsVisible;
      }
      
      public function set playerLevelInfo_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1804364382playerLevelInfo_txt;
         if(_loc2_ !== param1)
         {
            this._1804364382playerLevelInfo_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerLevelInfo_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get playerImagePath() : BitmapData
      {
         return this._1714654783playerImagePath;
      }
      
      public function set bottomRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1855392849bottomRow;
         if(_loc2_ !== param1)
         {
            this._1855392849bottomRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRow",_loc2_,param1));
         }
      }
      
      public function get menu() : Menu
      {
         return null;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         super.data = param1;
         var _loc2_:SummonerQuickViewData = param1 as SummonerQuickViewData;
         if(_loc2_ != null)
         {
            this.displayName = _loc2_.summonerName;
            _loc3_ = ChatController.jidFromSummonerId(_loc2_.summonerId);
            if(_loc2_.level > 0)
            {
               this.playerLevelInfo = RiotResourceLoader.getString("summoner_level_label",null,[_loc2_.level]);
               this.isUserBlocked = this.privacyListController.isBlocked(_loc3_);
               this.privacyListController.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPrivacyListChanged,false,0,true);
            }
            else
            {
               this.playerLevelInfo = null;
            }
            _loc4_ = "<font color=\'#ffffff\'>";
            _loc5_ = "</font>";
            this.normalWinsText = RiotResourceLoader.getString("summoner_quickview_normal_wins",null,[_loc4_,_loc5_,_loc2_.wins + _loc2_.odinWins]);
            if(_loc2_.rankedRating > 0)
            {
               this.rankedRatingText = RiotResourceLoader.getString("summoner_quickview_rating",null,[_loc4_,_loc5_,_loc2_.rankedRating]);
               this.rankedWinsText = RiotResourceLoader.getString("summoner_quickview_ranked_wins",null,[_loc4_,_loc5_,_loc2_.rankedWins,_loc2_.rankedLosses]);
               this.rankedQueueName = RiotResourceLoader.getString("BuddyListTooltip_rankedQueueName_" + _loc2_.rankedQueueType);
               if(this.rankedQueueName == null)
               {
                  this.rankedQueueName = _loc2_.rankedQueueType;
               }
            }
            else
            {
               this.rankedRatingText = "";
               this.rankedWinsText = "";
               this.rankedQueueName = "";
            }
            this.areStatsVisible = _loc2_.level > 0;
            if(_loc2_.summonerId > 0)
            {
               this.isMe = this.privacyListController.isMe(_loc3_);
            }
            else
            {
               this.isMe = false;
               this.isUserBlocked = false;
            }
            this.updateIcon();
            this.tier = _loc2_.tier;
         }
         else
         {
            this.playerImagePath = null;
            this.displayName = null;
            this.playerLevelInfo = null;
            this.rankedRatingText = "";
            this.rankedWinsText = "";
            this.normalWinsText = "";
            this.areStatsVisible = false;
            this.isMe = false;
            this.isUserBlocked = false;
            this.tier = null;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get player_img() : SummonerIcon
      {
         return this._2096171365player_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get normalGamesText() : Text
      {
         return this._909875815normalGamesText;
      }
      
      private function set rankedQueueName(param1:String) : void
      {
         var _loc2_:Object = this._2030596687rankedQueueName;
         if(_loc2_ !== param1)
         {
            this._2030596687rankedQueueName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedQueueName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      [Bindable(event="propertyChange")]
      protected function get playerLevelInfo() : String
      {
         return this._936395889playerLevelInfo;
      }
      
      private function _SummonerQuickView_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.statsColumn = _loc1_;
         _loc1_.width = 55;
         _loc1_.initialized(this,"statsColumn");
         return _loc1_;
      }
      
      private function onContextMenuClick(param1:FlexNativeMenuEvent) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:int = int(param1.index);
         var _loc3_:SummonerQuickViewData = this.data as SummonerQuickViewData;
         var _loc4_:String = ChatController.jidFromSummonerId(_loc3_.summonerId);
         if(_loc2_ == 0)
         {
            _loc5_ = Boolean(param1.nativeMenuItem.checked);
            if(_loc5_)
            {
               if(this.privacyListController.unblock(_loc4_))
               {
                  this.isUserBlocked = false;
               }
            }
            else
            {
               this.privacyListController.blockAndConfirm(_loc4_,_loc3_.summonerName,this.onBlockAndConfirm);
            }
         }
         else
         {
            this.chatController.addBuddy(_loc3_.summonerName);
         }
      }
      
      private function onBlockAndConfirm(param1:Boolean) : *
      {
         if(param1)
         {
            this.isUserBlocked = true;
         }
      }
      
      public function set playerName_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1816216387playerName_txt;
         if(_loc2_ !== param1)
         {
            this._1816216387playerName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName_txt",_loc2_,param1));
         }
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         return 0;
      }
      
      protected function set areStatsVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1730538681areStatsVisible;
         if(_loc2_ !== param1)
         {
            this._1730538681areStatsVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"areStatsVisible",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerQuickView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerQuickView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_components_summoner_SummonerQuickViewWatcherSetupUtil");
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
      public function get imageColumn() : ConstraintColumn
      {
         return this._1712502929imageColumn;
      }
      
      [Bindable(event="propertyChange")]
      private function get rankedRatingText() : String
      {
         return this._1661447317rankedRatingText;
      }
      
      private function set rankedWinsText(param1:String) : void
      {
         var _loc2_:Object = this._1943016241rankedWinsText;
         if(_loc2_ !== param1)
         {
            this._1943016241rankedWinsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedWinsText",_loc2_,param1));
         }
      }
      
      public function ___SummonerQuickView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      protected function set playerImagePath(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1714654783playerImagePath;
         if(_loc2_ !== param1)
         {
            this._1714654783playerImagePath = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerImagePath",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerLevelInfo_txt() : Text
      {
         return this._1804364382playerLevelInfo_txt;
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         return 0;
      }
      
      public function get measuredIconWidth() : Number
      {
         return 0;
      }
      
      public function set statsColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._269111509statsColumn;
         if(_loc2_ !== param1)
         {
            this._269111509statsColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      [Bindable(event="propertyChange")]
      private function get rankedQueueName() : String
      {
         return this._2030596687rankedQueueName;
      }
      
      private function _SummonerQuickView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_playerItemBackground");
         _loc1_ = this.height - 10;
         _loc1_ = this.player_img.height;
         _loc1_ = this.playerImagePath;
         _loc1_ = this.displayName;
         _loc1_ = this.playerLevelInfo;
         _loc1_ = this.areStatsVisible;
         _loc1_ = this.rankedRatingText;
         _loc1_ = this.areStatsVisible;
         _loc1_ = this.rankedQueueName;
         _loc1_ = this.rankedWinsText;
         _loc1_ = this.areStatsVisible;
         _loc1_ = this.rankedQueueName;
         _loc1_ = this.normalWinsText;
         _loc1_ = this.areStatsVisible;
      }
      
      private function _SummonerQuickView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_playerItemBackground");
         },function(param1:Object):void
         {
            _SummonerQuickView_Image1.source = param1;
         },"_SummonerQuickView_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height - 10;
         },function(param1:Number):void
         {
            player_img.height = param1;
         },"player_img.height");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return player_img.height;
         },function(param1:Number):void
         {
            player_img.width = param1;
         },"player_img.width");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return this.playerImagePath;
         },function(param1:Object):void
         {
            player_img.iconPath = param1;
         },"player_img.iconPath");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_txt.text = param1;
         },"playerName_txt.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.playerLevelInfo;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerLevelInfo_txt.htmlText = param1;
         },"playerLevelInfo_txt.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.areStatsVisible;
         },function(param1:Boolean):void
         {
            playerLevelInfo_txt.visible = param1;
         },"playerLevelInfo_txt.visible");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedRatingText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerQuickView_Text3.htmlText = param1;
         },"_SummonerQuickView_Text3.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.areStatsVisible;
         },function(param1:Boolean):void
         {
            _SummonerQuickView_Text3.visible = param1;
         },"_SummonerQuickView_Text3.visible");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedQueueName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerQuickView_Text3.toolTip = param1;
         },"_SummonerQuickView_Text3.toolTip");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedWinsText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerQuickView_Text4.htmlText = param1;
         },"_SummonerQuickView_Text4.htmlText");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.areStatsVisible;
         },function(param1:Boolean):void
         {
            _SummonerQuickView_Text4.visible = param1;
         },"_SummonerQuickView_Text4.visible");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.rankedQueueName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerQuickView_Text4.toolTip = param1;
         },"_SummonerQuickView_Text4.toolTip");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.normalWinsText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            normalGamesText.htmlText = param1;
         },"normalGamesText.htmlText");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.areStatsVisible;
         },function(param1:Boolean):void
         {
            normalGamesText.visible = param1;
         },"normalGamesText.visible");
         result[14] = binding;
         return result;
      }
      
      private function _SummonerQuickView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.centerColumn = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"centerColumn");
         return _loc1_;
      }
      
      public function set menu(param1:Menu) : void
      {
      }
      
      public function set player_img(param1:SummonerIcon) : void
      {
         var _loc2_:Object = this._2096171365player_img;
         if(_loc2_ !== param1)
         {
            this._2096171365player_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player_img",_loc2_,param1));
         }
      }
      
      private function set tier(param1:String) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
         }
      }
      
      private function onPrivacyListChanged(param1:CollectionEvent) : void
      {
         if(!(this.data is PlayerParticipant) || param1.kind != CollectionEventKind.ADD && param1.kind != CollectionEventKind.REMOVE)
         {
            return;
         }
         var _loc2_:PlayerParticipant = this.data as PlayerParticipant;
         var _loc3_:String = ChatController.jidFromSummonerId(_loc2_.summonerId);
         var _loc4_:PrivacyListItem = param1.items[0] as PrivacyListItem;
         if(_loc3_ == _loc4_.value)
         {
            this.isUserBlocked = param1.kind == CollectionEventKind.ADD;
         }
      }
      
      public function set normalGamesText(param1:Text) : void
      {
         var _loc2_:Object = this._909875815normalGamesText;
         if(_loc2_ !== param1)
         {
            this._909875815normalGamesText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalGamesText",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
         this.localizeContextMenuXML();
         this.createContextMenu();
      }
      
      [Bindable(event="propertyChange")]
      public function get playerName_txt() : Text
      {
         return this._1816216387playerName_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsColumn() : ConstraintColumn
      {
         return this._269111509statsColumn;
      }
      
      private function set normalWinsText(param1:String) : void
      {
         var _loc2_:Object = this._695259115normalWinsText;
         if(_loc2_ !== param1)
         {
            this._695259115normalWinsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalWinsText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get rankedWinsText() : String
      {
         return this._1943016241rankedWinsText;
      }
      
      protected function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      private function updateIcon() : void
      {
         if(this.isUserBlocked)
         {
            this.playerImagePath = BuddyImages.getBlockedIcon();
         }
         else
         {
            this.playerImagePath = this.data.iconSource;
         }
      }
      
      protected function set playerLevelInfo(param1:String) : void
      {
         var _loc2_:Object = this._936395889playerLevelInfo;
         if(_loc2_ !== param1)
         {
            this._936395889playerLevelInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerLevelInfo",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get normalWinsText() : String
      {
         return this._695259115normalWinsText;
      }
      
      private function _SummonerQuickView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.imageColumn = _loc1_;
         _loc1_.width = 0;
         _loc1_.initialized(this,"imageColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get tier() : String
      {
         return this._3559906tier;
      }
      
      private function localizeContextMenuXML() : void
      {
         this.menuXML.menuitem[0].@label = RiotResourceLoader.getString("summonerContext_blockUser_label");
         this.menuXML.menuitem[1].@label = RiotResourceLoader.getString("BuddyListTreeRenderer_groupAddBuddy");
      }
      
      private function onContextMenuShow(param1:FlexNativeMenuEvent) : void
      {
         var _loc2_:SummonerQuickViewData = null;
         var _loc3_:String = null;
         if(!this.areStatsVisible || this.isMe)
         {
            param1.nativeMenu.getItemAt(0).enabled = false;
            param1.nativeMenu.getItemAt(1).enabled = false;
         }
         else if(this.data.summonerId > 0)
         {
            _loc2_ = this.data as SummonerQuickViewData;
            _loc3_ = ChatController.jidFromSummonerId(_loc2_.summonerId);
            this.isUserBlocked = this.privacyListController.isBlocked(_loc3_);
            param1.nativeMenu.getItemAt(0).checked = this.isUserBlocked;
            param1.nativeMenu.getItemAt(0).enabled = true;
            param1.nativeMenu.getItemAt(1).enabled = true;
         }
         else
         {
            param1.nativeMenu.getItemAt(0).enabled = true;
            param1.nativeMenu.getItemAt(1).enabled = true;
         }
      }
      
      private function _SummonerQuickView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 50;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
   }
}

